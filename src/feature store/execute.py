# Arquivo feito após feature stores

#%%
import argparse
import datetime

import sqlalchemy
from sqlalchemy import exc
import pandas as pd


## Lib para mostrar o status
from tqdm import tqdm  

## importando query para o python
def import_query(path):

    with open(path, 'r') as open_file:
    ##with open(path, 'r',  encoding="utf-8") as open_file:
        return open_file.read()

## Função para criar lista de datas
def date_range(start, stop):
    dt_start = datetime.datetime.strptime(start , '%Y-%m-%d')
    dt_stop = datetime.datetime.strptime(stop , '%Y-%m-%d')
    dates = []
    while dt_start <= dt_stop:
        dates.append(dt_start.strftime("%Y-%m-%d"))
        dt_start += datetime.timedelta (days=1)
    return dates

## Funcao de ingestao dos dados

def ingest_date (query, table, dt):

    # Substituição de {date} por uma data 
    query_fmt = query.format(date = dt)

    ## Executando a query e traz o resultado para o python

    df = pd.read_sql(query_fmt , origin_engine)

    ## Deleta os dados com a data de referência para garantir integridade
    with target_engine.connect() as con:
        try:
            state = f"DELETE FROM {table} WHERE dtRef = '{dt}';"
            con.execute(sqlalchemy.text(state))
            con.commit()
        except exc.OperationalError as err:
            print("Tabela ainda não existe, criando ela")

    ## Salvando dataframe no novo database
    df.to_sql(table, target_engine , index=False ,if_exists = 'append')


# %%

now = datetime.datetime.now().strftime("%Y-%m-%d")

parser = argparse.ArgumentParser()
parser.add_argument("--feature_store", "-f", help = "Nome da feature store", type=str)
parser.add_argument("--start", "-s", help="Data de início", default=now)
parser.add_argument("--stop", "-p", help= "Data de Fim", default=now)

args = parser.parse_args()

## Conectando python com database origem

origin_engine = sqlalchemy.create_engine("sqlite:///../../data/database.db")

## Criando conexão com novo database

target_engine = sqlalchemy.create_engine("sqlite:///../../data/feature_store.db")
# %%

## importando a query 
query = import_query(f"{args.feature_store}.sql")

dates = date_range(args.start, args.stop )

### invocando a função onde i = cada data da lista
for i in tqdm(dates):
    ingest_date (query , args.feature_store, i)

# %%

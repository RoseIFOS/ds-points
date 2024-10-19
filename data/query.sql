
WITH tb_fl_churn AS (
    select 
        t1.dtRef,
        t1.idCustomer,
    -- Criando a variável target (flag) --> Infere quais usuários não deram churn nos próximos 21 dias
        CASE 
            WHEN t2.idCustomer IS NULL THEN  1
            ELSE  0
        END AS flChurn
        

    from fs_general as t1

    LEFT JOIN fs_general AS t2
    ON t1.idCustomer = t2.idCustomer
    AND t1.dtRef = DATE(t2.dtRef, '-21 DAY')

    -- Aqui estou considerando data do dia (hoje) - 21 dias para dar tempo de maturar a base
    WHERE t1.dtRef < DATE ('2024-06-06', '21 day')
    AND strftime('%d', t1.dtRef) = '01' -- isso faz que o usuário apareça apenas mensalmente

    ORDER BY 2,1
)

SELECT * FROM tb_fl_churn
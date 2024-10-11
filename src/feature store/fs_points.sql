SELECT 

    idCustomer,
    sum(pointsTransaction) as saldoPoints,


    sum(CASE
            WHEN pointsTransaction > 0 THEN  pointsTransaction
            ELSE 0
        END ) as pointsAcumuladosD21,

    sum(CASE
            WHEN pointsTransaction > 0 
            AND dtTransaction >= date ('2024-06-04', '-14 day')
            THEN  pointsTransaction
            ELSE 0
        END ) as pointsAcumuladosD14,

    sum(CASE
            WHEN pointsTransaction > 0 
            AND dtTransaction >= date ('2024-06-04', '-7 day')
            THEN  pointsTransaction
            ELSE 0
        END ) as pointsAcumuladosD7,

    sum(CASE
            WHEN pointsTransaction < 0 THEN  pointsTransaction
            ELSE 0
        END ) as pointsResgatadosD21,

    sum(CASE
            WHEN pointsTransaction < 0 
            AND dtTransaction >= date ('2024-06-04', '-14 day')
            THEN  pointsTransaction
            ELSE 0
        END ) as pointsResgatadosD14,

    sum(CASE
            WHEN pointsTransaction < 0 
            AND dtTransaction >= date ('2024-06-04', '-7 day')
            THEN  pointsTransaction
            ELSE 0
        END ) as pointsResgatadosD7


FROM transactions

WHERE dtTransaction < '2024-06-04'
AND dtTransaction >=  DATE ('2024-06-04',  '-21 DAY')

GROUP BY idCustomer
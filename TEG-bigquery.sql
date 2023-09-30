/* How does the revenue generated from document registration vary 
across districts in Telangana? List down the top 5 districts that showed 
the highest document registration revenue growth between FY 2019 
and 2022.
*/

WITH revenue_cte as
(
SELECT 
    dist_code,
    SUM(documents_registered_rev) AS Total_revenue_documents_registratrion
FROM
    `cbc.fact_stamps`
WHERE
    EXTRACT(YEAR FROM date) BETWEEN 2019 AND 2022
GROUP BY dist_code
)

SELECT 
    districts,
    Total_revenue_documents_registratrion
FROM
    revenue_cte
        JOIN
    `cbc.dim_districts`
    USING (dist_code)
ORDER BY 2 DESC
LIMIT 5;


-- -----------------------------------------------------------------------------------------------------------------------------------------

/* How does the revenue generated from document registration compare 
to the revenue generated from e-stamp challans across districts? List 
down the top 5 districts where e-stamps revenue contributes 
significantly more to the revenue than the documents in FY 2022?
*/

WITH revenue_cte as
(
SELECT 
    dist_code,
    SUM(documents_registered_rev) AS Total_revenue_documents_registratrion,
    SUM(estamps_challans_rev) AS Total_revenue_estamps_challan
FROM
    `cbc.fact_stamps`
WHERE
    EXTRACT(YEAR FROM Date) = 2022
GROUP BY dist_code
)

SELECT 
    districts,
    Total_revenue_estamps_challan,
    Total_revenue_documents_registratrion
FROM
    revenue_cte
        JOIN
    `cbc.dim_districts`
    USING (dist_code)
WHERE
    Total_revenue_estamps_challan > Total_revenue_documents_registratrion
ORDER BY 2 DESC
LIMIT 5;


# ----------------------------------------------------------------------------------------------------------------------------------


/*Is there any alteration of e-Stamp challan count and document 
registration count pattern since the implementation of e-Stamp 
challan? If so, what suggestions would you propose to the 
government?*/


WITH compare_21 as
(
SELECT 
    districts,
    EXTRACT(YEAR FROM date) AS year,
    SUM(documents_registered_cnt) AS documents_count_21,
    SUM(estamps_challans_cnt) AS challans_count_21,
    (SUM(estamps_challans_cnt) - SUM(documents_registered_cnt)) AS diff_rev_2021
FROM
    `cbc.fact_stamps`
        JOIN
    `cbc.dim_districts`
    USING (dist_code)
WHERE
    EXTRACT(YEAR FROM date) = 2021
GROUP BY 1 , 2
ORDER BY 5 DESC
),compare_22 as
(
SELECT 
    districts,
    EXTRACT(YEAR FROM date) AS year,
    SUM(documents_registered_cnt) AS documents_count_22,
    SUM(estamps_challans_cnt) AS challans_count_22,
    (SUM(estamps_challans_cnt) - SUM(documents_registered_cnt)) AS diff_rev_2022
FROM
    `cbc.fact_stamps`
        JOIN
    `cbc.dim_districts`
    USING (dist_code)
WHERE
    EXTRACT(YEAR FROM date) = 2022
GROUP BY 1 , 2
ORDER BY 5 DESC
)

SELECT 
    *
FROM
    compare_22 a
        JOIN
    compare_21 b
    USING (districts)
ORDER BY 5 DESC , 9 DESC;


# ----------------------------------------------------------------------------------------------------------------------------------

/*Categorize districts into three segments based on their stamp 
registration revenue generation during the fiscal year 2021 to 2022*/


SELECT 
    districts,
    SUM(estamps_challans_rev) AS Total_estamps_challans_rev,
    (CASE
        WHEN SUM(estamps_challans_rev) > 2000000000 THEN 'High_estamp_revenue_district'
        WHEN SUM(estamps_challans_rev) BETWEEN 1000000000 AND 2000000000 THEN 'Medium_estamp_revenue_district'
        WHEN SUM(estamps_challans_rev) < 1000000000 THEN 'Low_estamp_revenue_district'
    END) AS class
FROM
    `cbc.fact_stamps`
        JOIN
    `cbc.dim_districts` USING (dist_code)
WHERE
    EXTRACT(YEAR FROM date) BETWEEN 2021 AND 2022
GROUP BY 1
ORDER BY 2 DESC;


# ----------------------------------------------------------------------------------------------------------------------------------

/*Investigate whether there is any correlation between vehicle sales and 
specific months or seasons in different districts. Are there any months 
or seasons that consistently show higher or lower sales rate, and if yes, 
what could be the driving factors? (Consider Fuel-Type category only)*/

with trans_cte as
(
SELECT 
    districts,
    EXTRACT(MONTH FROM date) AS mnth,
    (fuel_type_petrol + fuel_type_diesel + fuel_type_electric + fuel_type_others) AS total_fuel_type
FROM
    `cbc.fact_transport`
        JOIN
    `cbc.dim_districts` USING (dist_code)
GROUP BY 1 , 2 , fuel_type_petrol , fuel_type_diesel , fuel_type_electric , fuel_type_others , date
)
SELECT 
    districts, SUM(total_fuel_type) AS total_fuel_type
FROM
    trans_cte
GROUP BY 1
ORDER BY 2 DESC;


# ----------------------------------------------------------------------------------------------------------------------------------

/* How does the distribution of vehicles vary by vehicle class 
(MotorCycle, MotorCar, AutoRickshaw, Agriculture) across different 
districts? Are there any districts with a predominant preference for a 
specific vehicle class? Consider FY 2022 for analysis.*/


SELECT 
    districts,
    EXTRACT(YEAR FROM date) AS Year,
    SUM(vehicleClass_MotorCycle) AS vehicleClass_MotorCycle,
    SUM(vehicleClass_MotorCar) AS vehicleClass_MotorCar,
    SUM(vehicleClass_AutoRickshaw) AS vehicleClass_AutoRickshaw,
    SUM(vehicleClass_Agriculture) AS vehicleClass_Agriculture,
    SUM(vehicleClass_others) AS vehicleClass_others
FROM
    `cbc.fact_transport`
        JOIN
    `cbc.dim_districts` USING (dist_code)
WHERE
    EXTRACT(YEAR FROM date) = 2022
GROUP BY 1 , 2
ORDER BY 3 DESC , 4 DESC , 5 DESC;



# ----------------------------------------------------------------------------------------------------------------------------------


/*List down the top 3 and bottom 3 districts that have shown the highest 
and lowest vehicle sales growth during FY 2022 compared to FY 
2021? (Consider and compare categories: Petrol, Diesel and Electric)*/


(
SELECT 
    districts,
    EXTRACT(YEAR FROM date) AS Year,
    SUM(fuel_type_petrol) AS tot_petV_sold,
    SUM(fuel_type_diesel) AS tot_dieV_sold,
    SUM(fuel_type_electric) AS tot_elecV_sold,
    SUM(fuel_type_petrol + fuel_type_diesel + fuel_type_electric) AS total_vehicle_Sales_cnt
FROM
    `cbc.fact_transport`
        JOIN
    `cbc.dim_districts` 
    USING (dist_code)
WHERE
    EXTRACT(YEAR FROM date) = 2022
GROUP BY 1 , 2
ORDER BY 3 DESC , 4 DESC , 5 DESC
LIMIT 3
)
UNION ALL
(
SELECT 
    districts,
    EXTRACT(YEAR FROM date) AS Year,
    SUM(fuel_type_petrol) AS tot_petV_sold,
    SUM(fuel_type_diesel) AS tot_dieV_sold,
    SUM(fuel_type_electric) AS tot_elecV_sold,
    SUM(fuel_type_petrol + fuel_type_diesel + fuel_type_electric) AS total_vehicle_Sales_cnt
FROM
    `cbc.fact_transport`
        JOIN
    `cbc.dim_districts` 
	USING (dist_code)
WHERE
    EXTRACT(YEAR FROM date) = 2022
GROUP BY 1 , 2
ORDER BY 3 , 4 , 5
LIMIT 3
);


# ----------------------------------------------------------------------------------------------------------------------------------


/*
List down the top 5 sectors that have witnessed the most significant 
investments in FY 2022.*/

SELECT 
    sector,
    ROUND(SUM(investment_in_cr), 2) AS Investment_in_crore
FROM
    `cbc.fact_TS_iPASS`
GROUP BY sector
ORDER BY Investment_in_crore DESC;


# ----------------------------------------------------------------------------------------------------------------------------------


/*List down the top 3 districts that have attracted the most significant 
sector investments during FY 2019 to 2022? What factors could have 
led to the substantial investments in these particular districts?
*/

SELECT DISTINCT
    districts,
    ROUND(SUM(investment_in_cr), 2) AS investment_in_cr
FROM
    `cbc.fact_TS_iPASS`
        JOIN
    `cbc.dim_districts` USING (dist_code)
WHERE
    EXTRACT(YEAR FROM date) BETWEEN 2019 AND 2022
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;



# ----------------------------------------------------------------------------------------------------------------------------------------


/*are there any particular sectors that have shown substantial 
 investment in multiple districts between FY 2021 and 2022?*/


WITH cte AS
(	
SELECT *,
	DENSE_RANK() OVER(PARTITION BY sector ORDER BY Investment DESC) AS rnk
FROM (
 SELECT 
    dist_code, sector, SUM(investment_in_cr) AS Investment
FROM
    `cbc.fact_TS_iPASS`
WHERE
    EXTRACT(YEAR FROM date) BETWEEN 2021 AND 2022
GROUP BY sector , dist_code) as tbl
	
)

SELECT 
    sector, ROUND(SUM(investment), 2) AS Investment_in_Cr
FROM
    cte
        JOIN
    `cbc.dim_districts` USING (dist_code)
WHERE
    rnk <= 3
GROUP BY 1
ORDER BY 2 DESC , 2;


#   -----------x-x-x-x--------------------------------------------.
# <h1 align="center" >  📙 Telangana's Economic Growth 📙

<p align="center">
<kbd>  <img src="https://th.bing.com/th/id/R.319bd2493eb84ac65c6ed5a27f0af9f8?rik=EqOwm%2fQ2hFfJng&riu=http%3a%2f%2fwww.theweek.in%2fcontent%2fdam%2fweek%2fnews%2findia%2fimages%2ftelangana-districts.jpg&ehk=saWKJ%2fd8bsenZ6OTnEpQzR5TeSKYs0Kp1A%2f45InB3Zw%3d&risl=&pid=ImgRaw&r=0"></kbd>

## Tableau Dashboard:
Click on this button to view individual interactive Dashboard and Story 👉🏼 [![Jupyter Notebook](https://img.shields.io/badge/Telangana'sEG-%23FA0F00.svg?style=plastic&logo=tableau&logoColor=white)](https://public.tableau.com/views/Telanganaseconomicgrowth-EDA-CaseStudy/Intro?:language=en-US&:display_count=n&:origin=viz_share_link)

## 📚 Table of Contents
- [Business Task](#business-task)
- [Datasets](#datasets)
- [Relationship Model](#relationship-model)
- [Question and Solutions](#question-and-solutions)
- [Inference](#inference)
- [Foresights and Vision](#foresights-and-vision)
- [Recommendations and Suggestions](#recommendations-and-suggestions)

If you have any questions, reach out to me on [LinkedIn](https://www.linkedin.com/in/kasimuthuveerappan/)

***

## 🔎Business Task

### 👉🏼Introduction

"Telangana, a southern state in India, situated on the Deccan Plateau, boasts a rich history, vibrant culture, and a reputation for innovation. With 33 districts, it has emerged as one of India's fastest-growing states, showcasing an impressive average annual growth rate of 13.90% in the last five years. In 2020-21, Telangana achieved a nominal Gross State Domestic Product (GSDP) of ₹13.59 lakh crore.

One of the key drivers of Telangana's success has been its commitment to open data initiatives. The Telangana Open Data Policy, launched in 2016, stands out as a beacon of transparency and accountability. This policy not only makes government data freely accessible but also fosters public participation in governance. It has led to the creation of innovative applications and services, fueling economic growth.

I would like to extend my sincere appreciation to the Telangana government for championing open data. This initiative has not only made information more transparent and accessible to citizens, businesses, and researchers but has also been instrumental in propelling the state's economic prosperity."

### 🤷‍♂️Problem Statement

• Explore Stamp Registration, Transportation and Ts-Ipass Datasets.Understand their attributes, categories and time period.

• Analyze trends and patterns within each department.

• Identify growth opportunities and areas needing attention.

• Find correlation among these departments and report the overall growth of the state through insights and relevant visuals such as shape maps.

***

## 📂Datasets

Please note that all the information regarding the case study has been sourced from the following link: [click here](https://data.telangana.gov.in/). 

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/f0399d23-d5e2-4ca4-b263-7986e012d62b)</kbd>

Now the Agenda is to explore the available data. We have datasets of stamp registration, transportation department, and then the tsipass policy. After a brief quantitative analysis, will suggest and recommend some insights for the futuristic growth of telangana to the stakeholders.

***

## 🪢Relationship Model

- I used Microsoft Excel to clean the data and to establish a entity relationship model.

<kbd>![q1 (2)](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/fe1752fd-72f6-46f4-b90f-af0f55bd87d2)</kbd>



- I have also used tableau to establish a noodle relationship across the datasets.

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/aa9f806d-d0ea-40a6-aa08-396e9b7f32f1)
</kbd>  

***

## 📑Question and Solutions

🔖### *Exploring the Stamp Registration Department*

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/eb81b091-574b-48f5-9276-82321dc3211f)</kbd>

***

📌**Q-1 How does the revenue generated from document registration vary across districts in Telangana? Top 5 districts that showed the highest document registration revenue growth between FY 2019 and 2022.**

```sql

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

```

### Output

<kbd>![q1](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/58bfb4c9-16b5-4d42-922e-0011d7baa6b1)</kbd>

### Insights

- Population, Land availability and it prices, Economic activity of the district.

***

📌**Q-2 How does the revenue generated from document registration compare to the revenue generated from e-stamp challans across districts? List down the top 5 districts where e-stamps revenue contributes significantly more to the revenue than the documents in FY 2022?**

```sql

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

```

### Output

<kbd>![q2](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/da57f1cf-5bfa-41da-8b34-827a14339efc)</kbd>


### Insights

- The revenue generated from document registration and e-stamp challans varies across districts in Telangana. In some districts, the revenue from e-stamp challans is significantly more than the revenue from document registration. In other districts, the revenue from document registration is significantly more than the revenue from e-stamp challans.


***

📌**Q-3 Is there any alteration of e-Stamp challan count and document registration count pattern since the implementation of e-Stamp challan? If so, what suggestions would you propose to the government?**

```sql

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

```

### Output

<kbd>![q3](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/cd405574-fc7b-4112-8ffc-9d51d875c290)</kbd>

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/14445274-7a5c-42bb-92fa-2fe8f1b05e43)</kbd>

### Insights

- The introduction of e-Stamp challans has revolutionized the way stamp duty is paid in Telangana. This makes the process much more convenient and efficient.As a result of the introduction of e-Stamp challans, there has been a significant increase in the number of e-Stamp challans issued. In fact, the number of e-Stamp challans issued in FY 2022 was more than double the number issued in FY 2021. However, there has also been a slight decrease in the number of document registrations. This is because many people are now using e-Stamp challans to pay stamp duty without actually registering their documents.

***

📌**Q-4 Categorize districts into three segments based on their stamp registration revenue generation during the fiscal year 2021 to 2022.**

```sql

SELECT 
    districts,
    SUM(estamps_challans_rev) AS Total_estamps_challans_rev,
    (CASE
        WHEN SUM(estamps_challans_rev) > 2000000000 THEN 'High_revenue_district'
        WHEN SUM(estamps_challans_rev) BETWEEN 1000000000 AND 2000000000 THEN 'Medium_revenue_district'
        WHEN SUM(estamps_challans_rev) < 1000000000 THEN 'Low_revenue_district'
    END) AS class
FROM
    `cbc.fact_stamps`
        JOIN
    `cbc.dim_districts`
    USING (dist_code)
WHERE
    EXTRACT(YEAR FROM date) BETWEEN 2021 AND 2022
GROUP BY 1
ORDER BY 2 DESC;

```

### Output

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/8fbeda70-d4c6-4998-98d4-ce86784c0fe4)</kbd>

***

🔖### *Exploring the Transportation Department*

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/b53c556e-bd8e-43e8-b65a-235bd259f960)</kbd>

***

📌**Q-5 Investigate whether there is any correlation between vehicle sales and specific months or seasons in different districts. Are there any months or seasons that consistently show higher or lower sales rate, and if yes, what could be the driving factors? (Consider Fuel-Type category only)**

```sql

WITH trans_cte as
(
SELECT 
    districts,
    EXTRACT(MONTH FROM date) AS mnth,
    (fuel_type_petrol + fuel_type_diesel + fuel_type_electric + fuel_type_others) AS total_fuel_type
FROM
    `cbc.fact_transport`
        JOIN
    `cbc.dim_districts`
    USING (dist_code)
GROUP BY 1 , 2 , fuel_type_petrol , fuel_type_diesel , fuel_type_electric , fuel_type_others , date
)
SELECT 
    districts, SUM(total_fuel_type) AS total_fuel_type
FROM
    trans_cte
GROUP BY 1
ORDER BY 2 DESC;

```

### Output

<kbd>![q5](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/c4cb3a61-af71-42dc-9a2c-d5388aaa8703)</kbd>

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/6b48fa42-532c-4932-8bcc-b47026c1192d)</kbd>


### Insights

- A weak correlation was found between vehicle sales and specific months or seasons in different districts. However, there were some months and seasons that consistently showed higher or lower sales rates and we could see a pattern of seasonality and cyclicality during October, November months as they show a consistent sales numbers across the span of years.

***

📌**Q-6 How does the distribution of vehicles vary by vehicle class (MotorCycle, MotorCar, AutoRickshaw, Agriculture) across different districts? Are there any districts with a predominant preference for a specific vehicle class? Consider FY 2022 for analysis.**

```sql

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
    `cbc.dim_districts`
    USING (dist_code)
WHERE
    EXTRACT(YEAR FROM date) = 2022
GROUP BY 1 , 2
ORDER BY 3 DESC , 4 DESC , 5 DESC;

```

### Output

<kbd>![q6](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/0716f131-762c-436e-803f-cde91e1f85a4)</kbd>

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/be1edb78-ab8a-4036-b79a-72212f6c70ed)</kbd>

### Insights

The distribution of vehicles varies significantly by vehicle class across different districts. For instance, in the vehicle class of motorcycles, the district of Hyderabad has the highest number of vehicles, followed by the districts of Rangareddy and Medchal-Malkajgiri. This is because these districts are more urbanized and have a higher population density. In contrast, the district of Adilabad has the lowest number of motorcycles, followed by the districts of Karimnagar and Warangal. This is because these districts are more rural and have a lower population density.


***

📌**Q-7 List down the top 3 and bottom 3 districts that have shown the highest and lowest vehicle sales growth during FY 2022 compared to FY 2021?**

```sql

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

```

### Output

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/00239061-4651-47a1-be1a-0009cc3fa2fd)</kbd>

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/c6103af1-3ba6-4cee-af38-789fa3fc0d3f)</kbd>

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/68d39ff8-6901-4870-b8b2-07b4918205df)</kbd>

***

🔖### *Exploring the Ts-iPass(Telangana State Industrial Project Approval and Self-certification policy) Department*

<p align="center"> 
<kbd><img src="https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/24775309-45e7-4d45-ae6a-d01337968618"></kbd>

***

📌**Q-8. List down the top 5 sectors that have witnessed the most significant investments in FY 2022.**

```sql

SELECT 
    sector,
    ROUND(SUM(investment_in_cr), 2) AS Investment_in_crore
FROM
    `cbc.fact_TS_iPASS`
GROUP BY sector
ORDER BY Investment_in_crore DESC;

```

### Output

<kbd>![q8](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/33f80139-6da5-4c1d-849e-e5e403d10ecb)</kbd>

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/5051f22c-d2d8-4be4-918a-37a675245b57)</kbd>


***

📌**Q-9. List down the top 3 districts that have attracted the most significant sector investments during FY 2019 to 2022? What factors could have led to the substantial investments in these particular districts?**

```sql

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

```

### Output

<kbd>![q9](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/a9b7ce08-13c5-4df7-ac58-49d00148f0a8)</kbd>

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/cefe4470-c4f7-4e32-b761-7cb2acf0a09e)</kbd>

### Insights

- The growing economy of Telangana and the government's pro-investment policies.
- The government's incentives for investors.
- The government's focus on promoting industrial development & The proximity to the national and international markets.
- The availability of land and The favorable business environment.
- The ease availability of IT services, Manufacturing, Infrastructure, Logistics, Renewable energy(solar and wind power - sector).
- The presence of major industrial clusters and skilled manpower. 

***

***

📌**Q-10. Is there any relationship between district investments, vehiclessales and stamps revenue within the same district between FY 2021 and 2022?**

### Analysis:

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/b30e1768-2d49-4166-996b-591b9759edb9)</kbd>


### Insights

- We can say, There is a weak positive relationship between district investments, vehicles sales, and stamps revenue within the same district between FY 2021 and 2022. This means that districts with higher investments tend to have higher vehicle sales and stamps revenue. This is because investments lead to economic growth, which in turn leads to an increase in demand for vehicles and stamps.

***

📌**Q-11. Are there any particular sectors that have shown substantial investment in multiple districts between FY 2021 and 2022?**

```sql

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

```

### Output

<kbd>![q11](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/aa154e2a-58f4-4a31-aaea-e1694b1bdc4d)</kbd>

<kbd>![Screenshot 2023-09-28 135219](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/c4581ce1-ce44-4d76-a8aa-b1a832f79d71)</kbd>

### Insights

- Yes, there are a few sectors that have shown substantial investment in multiple districts between FY 2021 and 2022.These sectors are considered to be sunrise sectors and are expected to grow rapidly in the coming years. As a result, they are attracting investments from both domestic and foreign investors.


***

📌**Q-12. Can we identify any seasonal patterns or cyclicality in the investment trends for specific sectors? Do certain sectors experience higher investments during particular months?**


### Analysis

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/2630fc73-6728-4a11-b698-2c181cbaa0ea)</kbd>

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/eac55c85-a76d-4169-b8a2-37e63ffe067c)</kbd>

### Insights

- Yes ofcourse, there are some seasonal patterns and cyclicality in the investment trends for specific sectors. For example, the automobile sector tends to experience higher investments during the festive seasons, such as Diwali and Pongal. The construction sector also tends to experience higher investments during the summer months, when there is less rainfall .The IT sector typically experiences higher investments during the months of October to December, as this is the time when the companies start their annual budgeting process. The manufacturing sector, on the other hand, typically experiences higher investments during the months of January to March, as this is the time when the companies start their new financial year.However, there are also some sectors that do not follow any particular seasonal patterns. They receive investments all over the year based on the demand.


***

## ➕ Additional Research:

📌**What are the top 5 districts to buy commercial properties in Telangana? Justify your answer**

### Analysis

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/7b30d03c-cd99-4f67-85ea-b94782fb3b7b)</kbd>


### Insights

The important factors to be considered while buying commercial properties in the Districts of Telangana are :

* The availability of land
* The infrastructures such as roads, power, and water, than others.
* The proximity to amenities such as schools, hospitals, and shopping malls, theatres, parks etc.
* The potential for economic growth prospects further strengthen its appeal as a commercial property investment destination.
* The district's proximity to the upcoming international airport and the upcoming projects further boost its investment potential.
* A District, that is well-connected to the rest of the cities, has to a number of commercial establishments, including malls, restaurants, and hotels.
* All these prospects makes it an attractive option for investors looking for commercial properties in the vicinity.
* The best district for you will depend on your specific investment goals and requirements and also based on the locality of your bugdget(HIGH class , MIDDLE class or LOWER MIDDLE class).

***

📌**What significant policies or initiatives were put into effect to enhance economic growth, investments, and employment in Telangana by the current government? Can we quantify the impact of these policies using available data?**

- Policies for Economic Growth, Investments, and Employment in Telangana :
- Industrial Promotion : `TS-iPASS` streamlined industrial approvals to attract investment.
- Industrial Parks : `ITIR` (Information Technology & investment Region) and Pharma City aimed to attract IT and pharma investments.
- Innovation Support : `TSIC` (Telangana State Innovation Cell) and T-Hub supported startups and innovation.
- Startup Assistance : Idea to Market `I2M` aided startups from ideation to market entry.
- Textile and Food : Policy focused on boosting the textile industry for job creation and focused on food processing tech.
- Rural Employment : `TREGS` (Telangana Rural Employment Guarantee Scheme) provided rural job opportunities.
- Infrastructure Projects : `Mission Bhagiratha` and `Mission Kakatiya` addressed water and irrigation needs, generating rural employment.

It is difficult to quantify with the available data , But there is no doubt that “TELANGANA” is one of the youngest and Fastest growing states in India.

- Challenges in Quantifying Impact
- Policies may take years to show full effect. Economic growth influenced by various external factors.
- Reliable data on economic indicators and investments is essential.
- Comparing actual outcomes with policy absence is complex.
- Policies may have indirect and long-term effects, creating feedback loops.

***

## 📝Inference

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/cabc5364-33d0-4838-a34c-b8d57481a790)</kbd>

*** 

## 🪩🔭Foresights and Vision

#### Foresights for Sustained Growth in Telangana's Economy :

- Telangana has a strong foundation for sustained growth. The state has a young and growing population, a skilled workforce, and a favorable business environment.

- The state has made significant progress in recent years in attracting investments and creating jobs. In the last five years, the state has attracted over $10 billion in investments and created around 5,63,762 jobs.

- The government has implemented a number of policies and initiatives to boost the economy. These include the TS-iPASS single-window clearance system, the Investment Promotion Policy, skill development programs, infrastructure development, and ease of doing business reforms.

- The state has also taken a number of initiatives to promote tourism, develop the agricultural sector, promote entrepreneurship, and promote innovation. These initiatives are aimed at creating a conducive environment for businesses to operate in Telangana and to attract investments and create jobs.

- The state is well-positioned to achieve its target of attracting $25 billion in investments and creating 1 million jobs in the next five years. The state has the potential to become a major economic hub in the country.

***

## Recommendations and Suggestions

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/8eded44b-12bf-4d12-8e8c-da355327e719)</kbd>

***

## 🏢🧑🏽‍💼Notifying the StakeHolders:

<kbd>![image](https://github.com/KasiMuthuveerappan/Telanganas-Economic-Growth/assets/142071405/1a9b69a2-f469-41eb-88c7-d209f0e0122c)</kbd>


If you like this , Give a ⭐. 

-- Restaurant Customer Satisfaction

-- Formatting columns

SELECT ROUND(WaitTime,6) FROM restaurant_customer_data;

UPDATE restaurant_customer_data
SET WaitTime = ROUND(WaitTime,6);

SELECT ROUND(AverageSpend,6) FROM restaurant_customer_data;

UPDATE restaurant_customer_data
SET AverageSpend = ROUND(AverageSpend,6);

-- Exploratory Data Analysis

-- 1. Retrieve the top 10 customers with the highest AverageSpend.

select * from restaurant_customer_data;
SELECT CustomerID, Age, Gender, AverageSpend
FROM restaurant_customer_satisfaction
ORDER BY AverageSpend DESC
LIMIT 10;

-- 2. List customers ordered by VisitFrequency in descending order.

SELECT CustomerID, Age, Gender, VisitFrequency
FROM restaurant_customer_data
ORDER BY VisitFrequency DESC;

-- 3. Identify customers who consistently provide high satisfaction ratings across service, food, and ambiance using a CTE.

WITH HighSatisfactionCustomers AS (
    SELECT rcd.CustomerID,
		AVG(rr.ServiceRating + rr.FoodRating + rr.AmbianceRating) / 3 AS OverallRating
    FROM restaurant_customer_data rcd
    JOIN restaurant_rating rr ON rcd.CustomerID = rr.CustomerID
    GROUP BY
        rcd.CustomerID
)

SELECT
    hsc.CustomerID,
    rcd.Age,
    rcd.Gender,
    hsc.OverallRating
FROM
    HighSatisfactionCustomers hsc
JOIN
    restaurant_customer_data rcd ON hsc.CustomerID = rcd.CustomerID
WHERE
    hsc.OverallRating > 4.5;

-- 4. Find customers whose AverageSpend is above the overall average spend.

select customerid, averagespend
FROM restaurant_customer_data
HAVING averagespend > (SELECT avg(AverageSpend) FROM restaurant_customer_data);

-- 5. find customers who visited more than twice in a month.

select * from restaurant_customer_satisfaction;

select customerid, visitfrequency
from restaurant_customer_data
where VisitFrequency IN (
						SELECT DISTINCT VisitFrequency FROM restaurant_customer_data
                        WHERE VisitFrequency = 'Daily' OR VisitFrequency = 'Weekly');

-- 6. Filter customers who have a ServiceRating above 4 and FoodRating above 3.

Select rcd.CustomerID, Age, Gender, rr.ServiceRating, rr.FoodRating
FROM restaurant_customer_data rcd
JOIN restaurant_rating rr ON rcd.CustomerID = rr.CustomerID
WHERE ServiceRating > 4 AND FoodRating > 3;

-- 7. Average Spending by age of the customers.

SELECT
case
when age < 30 then 'Under 30'
when age >=30 and age <=50 then 'Between 30 - 50'
when age > 50 then 'Over 50'
end as 'AgeGroups',
CustomerID, avg(averagespend)
from restaurant_customer_data
group by agegroups, customerid;

-- 8. Most preferred cuisine by Gender.

select gender, preferredcuisine, count(*)
from restaurant_customer_data
group by gender, preferredcuisine
order by gender, count(*) desc;

-- 9. Calculate the average ServiceRating, FoodRating, and AmbianceRating for each MealType.

select * from restaurant_customer_satisfaction;

SELECT MealType,
AVG(rr.ServiceRating) AS Avg_Service_Rating,
AVG(rr.FoodRating) AS Avg_Food_Rating,
AVG(rr.AmbianceRating) AS Avg_Ambiance_Rating
FROM restaurant_customer_data rcd
JOIN restaurant_rating rr ON rcd.CustomerID = rr.CustomerID
GROUP BY MealType;

-- 10. Customers who have high satisfaction.

select ServiceRating, FoodRating, AmbianceRating, rcd.WaitTime
FROM restaurant_rating rr
JOIN restaurant_customer_data rcd ON rcd.CustomerID = rr.CustomerID
WHERE HighSatisfaction = 1;

-- 11. Compare AverageSpend between customers who are part of the loyalty program versus those who are not.

select
case
when LoyaltyProgramMember = 1 then 'Yes'
when LoyaltyProgramMember = 0 then 'No'
end as 'LoyaltyProgramMember',
AVG(AverageSpend)
from restaurant_customer_data
group by `LoyaltyProgramMember`
order by AVG(AverageSpend) DESC;

-- 12. Calculate the average AverageSpend for each TimeOfVisit category to analyze spending trends.

SELECT 
ROUND(AVG(AverageSpend),6) AS Total_Avg_Spending,
rr.TimeOfVisit AS Visit_Time
FROM restaurant_customer_data rcd
JOIN restaurant_rating rr ON rcd.CustomerID = rr.CustomerID
GROUP BY rr.TimeOfVisit
ORDER BY AVG(AverageSpend) DESC;

-- 13. Rank customers based on their average spending.

SELECT CustomerID, ROUND(AverageSpend), 
dense_rank() OVER(ORDER BY ROUND(AverageSpend) DESC) AS ranking
FROM restaurant_customer_data;

-- ___________________________________________________________________________________________________________________--

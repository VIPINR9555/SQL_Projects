create database project;
use project;
select *from superstore;

#Q1 what are columns name?
show columns from superstore;

 #Q3  Get unique shipping mode?
 select distinct `Ship Mode`  from superstore;
 
 #Q4 count how many ordered were placed?
 select count(distinct( `Order ID`)) from superstore;
 
 #Q5 total sales category wise.
 select sum(sales) as total_sales , Category from superstore group by category order by total_sales desc;
 
 #Q6 list all customer from california.
 SELECT DISTINCT `Customer Name`, State 
FROM superstore 
WHERE State = "California";

#Q7 find total no. of unique customers.
select count(distinct `Customer name`) from superstore;

#Q8 what is total profit of subcategory chairs.
select sum(Profit) as total_profit, `Sub-Category` from superstore where `Sub-Category`="Chairs";

#Q9 show top 5 product by sales.
select `Product Name`,sum(sales) as total_sales from superstore group by `Product Name` order by total_sales desc limit 5;

#Q10 find earliest and latest order.
SELECT  max(`Order Date`) as latest,min(`Order Date`) as earliest
FROM superstore;

#Q11 avg discount per region
select `Region`,round(avg(Discount),2)as avg_dis from superstore group by `region`;

#Q12 total quantity of product sale per sub-category.
select sum(Quantity) as total_quantity, `Sub-Category` from superstore group by `Sub-Category`order by total_quantity DESC;


#Q13 list customer more than 2 orders.

select count(`Order ID`)as counts,`Customer Name` from superstore group by
 `Customer Name` having counts>2 order by counts desc;
 
 #Q14 no. of order shipped using second class.
 select count(distinct `Order ID`) as no_of_orders,`Ship Mode` from superstore where `Ship Mode`="Second Class";
 
 #Q15 Top 3 sub-category by profit in each category.
 
 select * from
 (select `Category` ,`Sub-Category`, sum(Profit) as profits, rank() over (partition by Category order by sum(Profit) desc)
 as rk from superstore group by `Category`,`Sub-Category`) as rank_sub
 where rk<=3;
 

 #Q16 find orders with negative profit.
 
 select `Order ID`, Profit from superstore where Profit < -1 order by profit asc;
 
 
 #Q17 cities where more than 10000 sales happened.
 select City, sum(Sales) as total_sales from superstore group by City having total_sales >10000 order by total_sales desc;
 
 #Q18 find product with zero profit but non-zero sales.
 select `Product Name` , profit,sales from superstore where profit=0 and sales>0 order by sales desc;
 
 #q19 sub-category where discount always zero.
 select `Sub-Category`, Discount from superstore group by `Sub-Category`,`Discount` having max(discount)=0 and min(discount)=0;
 
 #Q20 rank customer by profit in each region.
 
 select `Customer Name`,Region, sum(Profit) as profits, rank() over (partition by Region order by sum(Profit) desc) as rn
 from superstore group by `Customer Name`,Region having profits >0;
 
 #Q21 state have lowest sales per order.
 
 select * from 
 (select distinct(`Order ID`) as ID, State, sum(sales) as total_sales , rank() over 
 (partition by State order by sum(Sales) asc) as rk from superstore group by ID,State) as subquery;
 
 #q22 most profitable product in each category;
  
 WITH products AS (
  SELECT 
    Category,
    `Product Name`,
    SUM(Profit) AS Profits,
    ROW_NUMBER() OVER (PARTITION BY Category ORDER BY SUM(Profit) DESC) AS ProfitRank
  FROM superstore
  GROUP BY Category, `Product Name`
)
SELECT 
  Category,
  `Product Name`,
  profits
FROM products
WHERE ProfitRank = 1;



                                                      -- SQL Commands

-- 1-Identify the primary keys and foreign keys in maven movies db. Discuss the differences

-- Primary Keys:
SELECT TABLE_NAME, COLUMN_NAME 
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE TABLE_SCHEMA = 'mavenmovies' 
AND CONSTRAINT_NAME = 'PRIMARY';


-- Foreign Keys:
SELECT 
  TABLE_NAME AS 'Table Name', 
  COLUMN_NAME AS 'Foreign Key Column', 
  REFERENCED_TABLE_NAME AS 'Referenced Table', 
  REFERENCED_COLUMN_NAME AS 'Referenced Column'
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE TABLE_SCHEMA = 'mavenmovies' 
AND REFERENCED_TABLE_NAME IS NOT NULL;

-- Here's a discussion on the differences between primary keys and foreign keys:

-- Primary Key:

-- 1. Uniquely identifies each record: A primary key is a column or set of columns that uniquely identifies each record in a table.
-- 2. Ensures data integrity: Primary keys prevent duplicate records and ensure that each record can be uniquely identified.
-- 3. One per table: A table can have only one primary key.
-- 4. Not nullable: Primary key columns cannot be null.

-- Foreign Key:

-- 1. Establishes relationships: A foreign key is a column or set of columns that references the primary key of another table.
-- 2. Links tables: Foreign keys establish relationships between tables, enabling joins and other operations.
-- 3. Multiple per table: A table can have multiple foreign keys, referencing different tables.
-- 4. Nullable: Foreign key columns can be null, indicating no relationship.




-- 2- List all details of actors

SELECT * 
FROM actor;


-- 3 -List all customer information from DB.
SELECT * 
FROM customer;



-- 4 -List different countries.
SELECT DISTINCT country 
FROM country;


-- 5 -Display all active customers.
SELECT * 
FROM customer 
WHERE active = 1;



-- 6 -List of all rental IDs for customer with ID 1.
SELECT rental_id 
FROM rental 
WHERE customer_id = 1;


-- 7 - Display all the films whose rental duration is greater than 5 .
SELECT * 
FROM film 
WHERE rental_duration > 5;


-- 8 - List the total number of films whose replacement cost is greater than $15 and less than $20.
SELECT COUNT(*) 
FROM film 
WHERE replacement_cost > 15 AND replacement_cost < 20;


-- 9 - Display the count of unique first names of actors.
SELECT COUNT(DISTINCT first_name) 
FROM actor;


-- 10- Display the first 10 records from the customer table .
SELECT * 
FROM customer 
LIMIT 10;


-- 11 - Display the first 3 records from the customer table whose first name starts with ‘b’.
SELECT * 
FROM customer 
WHERE first_name LIKE 'b' 
LIMIT 3;

-- 12 -Display the names of the first 5 movies which are rated as ‘G’.
SELECT title 
FROM film 
WHERE rating = 'G' 
LIMIT 5;


-- 13-Find all customers whose first name starts with "a".
SELECT * 
FROM customer 
WHERE first_name LIKE 'a%';


-- 14- Find all customers whose first name ends with "a".
SELECT * 
FROM customer 
WHERE first_name LIKE '%a';



-- 15- Display the list of first 4 cities which start and end with ‘a’ .
SELECT city 
FROM city 
WHERE city LIKE 'a%a' 
LIMIT 4;


-- 16- Find all customers whose first name have "NI" in any position.
SELECT * 
FROM customer 
WHERE first_name LIKE '%NI%';


-- 17- Find all customers whose first name have "r" in the second position .
SELECT * 
FROM customer 
WHERE first_name LIKE '_r%';


-- 18 - Find all customers whose first name starts with "a" and are at least 5 characters in length.
SELECT * 
FROM customer 
WHERE first_name LIKE 'a%' AND LENGTH(first_name) >= 5;


-- 19- Find all customers whose first name starts with "a" and ends with "o".
SELECT * 
FROM customer 
WHERE first_name LIKE 'a%o';


-- 20 - Get the films with pg and pg-13 rating using IN operator.
SELECT * 
FROM film 
WHERE rating IN ('PG', 'PG-13');




-- 21 - Get the films with length between 50 to 100 using between operator.
SELECT * 
FROM film 
WHERE length BETWEEN 50 AND 100;


-- 22 - Get the top 50 actors using limit operator.
SELECT * 
FROM actor 
LIMIT 50;


-- 23 - Get the distinct film ids from inventory table.
SELECT DISTINCT film_id 
FROM inventory;


                                                                   -- Functions

-- Basic Aggregate Functions:


-- Question 1: Retrieve the total number of rentals made.
SELECT COUNT(*) 
FROM rental;



-- Question 2: Find the average rental duration (in days) of movies rented from the Sakila database.
SELECT AVG(DATEDIFF(return_date, rental_date)) 
FROM rental;


-- String Functions:

 -- Question 3: Display the first name and last name of customers in uppercase.
 SELECT UPPER(first_name), UPPER(last_name) 
FROM customer;



-- Question 4: Extract the month from the rental date and display it alongside the rental ID.

SELECT rental_id, MONTH(rental_date) 
FROM rental;



-- GROUP BY:


-- Question 5: Retrieve the count of rentals for each customer (display customer ID and the count of rentals).

SELECT customer_id, COUNT(*) 
FROM rental 
GROUP BY customer_id;




-- Question 6: Find the total revenue generated by each store.

SELECT s.store_id, SUM(p.amount) 
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
GROUP BY s.store_id;


-- Question 7: Determine the total number of rentals for each category of movies.

SELECT c.name, COUNT(r.rental_id) 
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;



-- Question 8: Find the average rental rate of movies in each language.
SELECT l.name, AVG(f.rental_rate) 
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;








                                                                   -- Joins
                                                                   
                                                                   
-- Questions 9 - Display the title of the movie, customer s first name, and last name who rented it.
SELECT f.title, c.first_name, c.last_name
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id;



-- Question 10: Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';





-- Question 11: Retrieve the customer names along with the total amount they've spent on rentals.
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name;






-- Question 12: List the titles of movies rented by each customer in a particular city (e.g., 'London').

SELECT c.first_name, c.last_name, f.title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London';



                                                   -- Advanced Joins and GROUP BY:

-- Question 13: Display the top 5 rented movies along with the number of times they've been rented.
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 5;






-- Question 14: Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE i.store_id IN (1, 2)
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.store_id) = 2;


-- Windows Function:

-- 1. Rank the customers based on the total amount they've spent on rentals.
SELECT customer_id, first_name, last_name, total_spent,
       RANK() OVER (ORDER BY total_spent DESC) AS spend_rank
FROM (
  SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
  FROM customer c
  JOIN payment p ON c.customer_id = p.customer_id
  GROUP BY c.customer_id, c.first_name, c.last_name
) AS customer_spending;



-- 2. Calculate the cumulative revenue generated by each film over time.
SELECT f.title, p.payment_date, SUM(p.amount) OVER (PARTITION BY f.film_id ORDER BY p.payment_date) AS cumulative_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
ORDER BY f.title, p.payment_date;


-- 3. Determine the average rental duration for each film, considering films with similar lengths.
SELECT f.title, f.length, AVG(r.return_date - r.rental_date) OVER (PARTITION BY f.length) AS avg_rental_duration
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id;


-- 4. Identify the top 3 films in each category based on their rental counts.
WITH film_rental_counts AS (
  SELECT f.film_id, f.title, c.name AS category_name, COUNT(r.rental_id) AS rental_count
  FROM film f
  JOIN film_category fc ON f.film_id = fc.film_id
  JOIN category c ON fc.category_id = c.category_id
  JOIN inventory i ON f.film_id = i.film_id
  JOIN rental r ON i.inventory_id = r.inventory_id
  GROUP BY f.film_id, f.title, c.name
)
SELECT category_name, title, rental_count
FROM (
  SELECT category_name, title, rental_count,
         ROW_NUMBER() OVER (PARTITION BY category_name ORDER BY rental_count DESC) AS row_num
  FROM film_rental_counts
) AS subquery
WHERE row_num <= 3;


-- 5. Calculate the difference in rental counts between each customer's total rentals and the average rentals across all customers.
WITH customer_rental_counts AS (
  SELECT c.customer_id, COUNT(r.rental_id) AS rental_count
  FROM customer c
  JOIN rental r ON c.customer_id = r.customer_id
  GROUP BY c.customer_id
),
avg_rental_count AS (
  SELECT AVG(rental_count) AS avg_count
  FROM customer_rental_counts
)
SELECT crc.customer_id, crc.rental_count, crc.rental_count - arc.avg_count AS rental_diff
FROM customer_rental_counts crc
CROSS JOIN avg_rental_count arc;


-- 6. Find the monthly revenue trend for the entire rental store over time.
SELECT EXTRACT(YEAR FROM payment_date) AS year, EXTRACT(MONTH FROM payment_date) AS month, SUM(amount) AS monthly_revenue
FROM payment
GROUP BY EXTRACT(YEAR FROM payment_date), EXTRACT(MONTH FROM payment_date)
ORDER BY year, month;



-- 7. Identify the customers whose total spending on rentals falls within the top 20% of all customers.
WITH customer_spending AS (
  SELECT c.customer_id, SUM(p.amount) AS total_spent
  FROM customer c
  JOIN payment p ON c.customer_id = p.customer_id
  GROUP BY c.customer_id
),
ranked_spending AS (
  SELECT customer_id, total_spent,
         ROW_NUMBER() OVER (ORDER BY total_spent DESC) AS row_num,
         COUNT(*) OVER () AS total_customers
  FROM customer_spending
)
SELECT customer_id, total_spent
FROM ranked_spending
WHERE row_num <= total_customers * 0.2;



-- 8. Calculate the running total of rentals per category, ordered by rental count.

SELECT c.name AS category_name, COUNT(r.rental_id) AS rental_count,
       SUM(COUNT(r.rental_id)) OVER (ORDER BY COUNT(r.rental_id) DESC) AS running_total
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY rental_count DESC;


-- 9. Find the films that have been rented less than the average rental count for their respective categories.
WITH film_rental_counts AS (
  SELECT f.film_id, f.title, c.name AS category_name, COUNT(r.rental_id) AS rental_count
  FROM film f
  JOIN inventory i ON f.film_id = i.film_id
  JOIN rental r ON i.inventory_id = r.inventory_id
  JOIN film_category fc ON f.film_id = fc.film_id
  JOIN category c ON fc.category_id = c.category_id
  GROUP BY f.film_id, f.title, c.name
),
avg_rental_counts AS (
  SELECT category_name, AVG(rental_count) AS avg_count
  FROM film_rental_counts
  GROUP BY category_name
)
SELECT frc.title, frc.category_name, frc.rental_count
FROM film_rental_counts frc
JOIN avg_rental_counts arc ON frc.category_name = arc.category_name
WHERE frc.rental_count < arc.avg_count;


-- 10. Identify the top 5 months with the highest revenue and display the revenue generated in each month.
WITH monthly_revenue AS (
  SELECT EXTRACT(YEAR FROM p.payment_date) AS year,
         EXTRACT(MONTH FROM p.payment_date) AS month,
         SUM(p.amount) AS revenue
  FROM payment p
  GROUP BY EXTRACT(YEAR FROM p.payment_date), EXTRACT(MONTH FROM p.payment_date)
)
SELECT year, month, revenue
FROM (
  SELECT year, month, revenue,
         ROW_NUMBER() OVER (ORDER BY revenue DESC) AS row_num
  FROM monthly_revenue
) AS subquery
WHERE row_num <= 5;


                                                       -- Normalisation & CTE

-- 1. First Normal Form (1NF):

 -- a. Identify a table in the Sakila database that violates 1NF. Explain how you would normalize it to achieve 1NF.
 -- The Sakila database is already normalized, but let's consider a hypothetical scenario where the film table has a column actors 
 -- that contains multiple actor names separated by commas. This would violate 1NF.

-- To normalize it, we would create a separate table film_actors with a composite primary key (film_id, actor_id):


CREATE TABLE film_actors (
  film_id INT,
  actor_id INT,
  PRIMARY KEY (film_id, actor_id),
  FOREIGN KEY (film_id) REFERENCES film(film_id),
  FOREIGN KEY (actor_id) REFERENCES actor(actor_id)
);

 
-- 2. Second Normal Form (2NF):
-- a. Choose a table in Sakila and describe how you would determine whether it is in 2NF. If it violates 2NF, explain the steps to normalize it.
--  Let's consider the film table. To determine whether it is in 2NF, we need to check if it has any partial dependencies. Since 
-- the film table has a single-column primary key film_id, it is already in 2NF.

-- However, if we had a table like film_category with a composite primary key (film_id, category_id) and a column category_description
-- that depended only on category_id, it would violate 2NF. To normalize it, we would create a separate table for categories.


 
-- 3. Third Normal Form (3NF):
-- a. Identify a table in Sakila that violates 3NF. Describe the transitive dependencies  present and outline the steps to normalize the table to 3NF.
-- Let's consider the address table. If it had columns like city, state, and country, and the country column depended on the state column, which in turn depended on the city column, it would violate 3NF.

-- To normalize it, we would create separate tables for cities, states, and countries:


CREATE TABLE countries (
  country_id INT PRIMARY KEY,
  country_name VARCHAR(50)
);

CREATE TABLE states (
  state_id INT PRIMARY KEY,
  state_name VARCHAR(50),
  country_id INT,
  FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

CREATE TABLE cities (
  city_id INT PRIMARY KEY,
  city_name VARCHAR(50),
  state_id INT,
  FOREIGN KEY (state_id) REFERENCES states(state_id)
);

CREATE TABLE address (
  address_id INT PRIMARY KEY,
  city_id INT,
  FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

-- 4. Normalization Process:

 -- a. Take a specific table in Sakila and guide through the process of normalizing it from the initial unnormalized form up to at least 2NF.

 Let's take the hypothetical film table with a column actors that contains multiple actor names separated by commas. Here's how we would normalize it: Unnormalized form:

film_id | title | actors
1 | Movie1 | Actor1, Actor2, Actor3


1NF:
film_id | title | actor
1 | Movie1 | Actor1
1 | Movie1 | Actor2
1 | Movie1 | Actor3


2NF and 3NF:
CREATE TABLE film (
  film_id INT PRIMARY KEY,
  title VARCHAR(50)
);

CREATE TABLE actor (
  actor_id INT PRIMARY KEY,
  name VARCHAR(50)
);

CREATE TABLE film_actor (
  film_id INT,
  actor_id INT,
  PRIMARY KEY (film_id, actor_id),
  FOREIGN KEY (film_id) REFERENCES film(film_id),
  FOREIGN KEY (actor_id) REFERENCES actor(actor_id)
);


-- 5. CTE Basics:

 -- a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they have acted in from the actor and film_actor tables.
WITH actor_film_count AS (
  SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
  FROM actor a
  JOIN film_actor fa ON a.actor_id = fa.actor_id
  GROUP BY a.actor_id, a.first_name, a.last_name
)
SELECT first_name, last_name, film_count
FROM actor_film_count;


-- 6. CTE with Joins:
-- a. Create a CTE that combines information from the film and language tables to display the film title, language name, and rental rate.

WITH film_language_info AS (
  SELECT f.title, l.name AS language_name, f.rental_rate
  FROM film f
  JOIN language l ON f.language_id = l.language_id
)
SELECT title, language_name, rental_rate
FROM film_language_info;


-- 7. CTE for Aggregation:
-- a. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) from the customer and payment tables.
WITH customer_revenue AS (
  SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_revenue
  FROM customer c
  JOIN payment p ON c.customer_id = p.customer_id
  GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, first_name, last_name, total_revenue
FROM customer_revenue;


-- 8. \ CTE with Window Functions:
 -- a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.
 
WITH ranked_films AS (
  SELECT film_id, title, rental_duration,
         RANK() OVER (ORDER BY rental_duration DESC) AS "rank"
  FROM film
)
SELECT film_id, title, rental_duration, "rank"
FROM ranked_films;





 -- 9. CTE and Filtering:
-- a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the customer  table to retrieve additional customer details.

WITH frequent_customers AS (
  SELECT customer_id, COUNT(rental_id) AS rental_count
  FROM rental
  GROUP BY customer_id
  HAVING COUNT(rental_id) > 2
)
SELECT 
  c.customer_id,
  c.first_name,
  c.last_name,
  c.email,
  c.address_id,
  fc.rental_count
FROM customer c
JOIN frequent_customers fc ON c.customer_id = fc.customer_id;


-- 10. CTE for Date Calculations:
-- a. Write a query using a CTE to find the total number of rentals made each month, considering the rental_date from the rental table

WITH monthly_rentals AS (
  SELECT 
    EXTRACT(YEAR FROM rental_date) AS year,
    EXTRACT(MONTH FROM rental_date) AS month,
    COUNT(rental_id) AS rental_count
  FROM rental
  GROUP BY 
    EXTRACT(YEAR FROM rental_date), 
    EXTRACT(MONTH FROM rental_date)
)
SELECT 
  year, 
  month, 
  rental_count
FROM monthly_rentals
ORDER BY 
  year, 
  month;


-- 11. CTE and Self-Join:
 --  a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film together, using the film_actor table.
WITH actor_pairs AS (
  SELECT fa1.actor_id AS actor1_id, fa2.actor_id AS actor2_id
  FROM film_actor fa1
  JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
)
SELECT a1.first_name AS actor1_first_name, a1.last_name AS actor1_last_name,
       a2.first_name AS actor2_first_name, a2.last_name AS actor2_last_name
FROM actor_pairs ap
JOIN actor a1 ON ap.actor1_id = a1.actor_id
JOIN actor a2 ON ap.actor2_id = a2.actor_id;




-- 12. CTE for Recursive Search:

 -- a. Implement a recursive CTE to find all employees in the staff table who report to a specific manager, considering the reports_to colum


WITH staff_hierarchy AS (
  SELECT staff_id, manager_id, 0 AS level
  FROM staff
  WHERE manager_id = (specific_manager_id)
  UNION ALL
  SELECT s.staff_id, s.manager_id, level + 1
  FROM staff s
  JOIN staff_hierarchy sh ON s.manager_id = sh.staff_id
)
SELECT staff_id, manager_id, level
FROM staff_hierarchy;


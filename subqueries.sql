#How many copies of the film Hunchback Impossible exist in the inventory system?
select film_id
from film 
where title = "Hunchback Impossible";

select count(inventory_id) as copies
from inventory
where film_id = (select film_id
from film 
where title = "Hunchback Impossible");

#List all films whose length is longer than the average of all the films.

select round(avg(film.length))
from film;

SELECT title, round(avg(film.length)) as avg_length
from film
group by title
having avg_length > (select round(avg(film.length))
from film);

#Use subqueries to display all actors who appear in the film Alone Trip.
select film_id
from film 
where title = "Alone Trip";

select actor_id
from film_actor
where film_id = (select film_id
from film 
where title = "Alone Trip");

select CONCAT(first_name, " ", last_name) as name
from actor
where actor_id in(select actor_id
from film_actor
where film_id = (select film_id
from film 
where title = "Alone Trip"));

#Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.

select * from category;
select category_id
from category
where name = "Family";

Select film_id
from film_category
where category_id =(select category_id
from category
where name = "Family");

select title 
from film 
where film_id in (Select film_id
from film_category
where category_id =(select category_id
from category
where name = "Family"));

# Get name and email from customers from Canada using subqueries. 
#Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys,
# that will help you get the relevant information.

select country_id
from country
where country = "Canada";

select city_id
from city
where country_id = (select country_id
from country
where country = "Canada");

select address_id 
from address
where city_id IN (select city_id
from city
where country_id = (select country_id
from country
where country = "Canada"));

select CONCAT(first_name, " ", last_name) as name, email
from customer
where address_id IN(select address_id 
from address
where city_id IN (select city_id
from city
where country_id = (select country_id
from country
where country = "Canada")));

#now with joins

SELECT c.first_name, c.last_name, c.email 
FROM customer c
JOIN address a 
ON c.address_id = a.address_id
JOIN city ci 
ON a.city_id = ci.city_id
JOIN country co 
Using (country_id)
WHERE co.country = 'Canada';

#6. Which are films starred by the most prolific actor? 

SELECT f.actor_id FROM film_actor f
JOIN actor a 
USING (actor_id)
GROUP BY f.actor_id
ORDER BY count(f.film_id) DESC 
LIMIT 1;

SELECT f.film_id, f.title 
FROM film f 
JOIN film_actor fa 
using (film_id)
WHERE actor_id = (SELECT f.actor_id FROM film_actor f
JOIN actor a 
USING (actor_id)
GROUP BY f.actor_id
ORDER BY count(f.film_id) DESC 
LIMIT 1);

#7. Films rented by most profitable customer. 
SELECT customer_id, sum(amount)
FROM payment 
GROUP BY customer_id
ORDER BY sum(amount) DESC
LIMIT 1;

SELECT r.rental_id, f.title 
FROM rental r
JOIN inventory i 
USING (inventory_id)
JOIN film f 
using (film_id)
WHERE r.customer_id = (
	SELECT pay.customer_id FROM payment pay
	GROUP BY pay.customer_id
	ORDER BY sum(pay.amount) DESC
	LIMIT 1);
    
#8. Customers who spent more than the average payments.

SELECT  avg(amount) as avg_payment
FROM payment;

SELECT customer_id, avg(amount) as avg_payment
from payment
group by customer_id
having avg_payment > (SELECT  avg(amount) as avg_payment
FROM payment) ;





DROP table if exists book;

create table books( --books
book_id serial primary key,
title varchar (100),
author varchar (100),
genre varchar (100),
Published_Year int,
Price numeric(10,2),
Stock int);

create table customers ( /*customers*/
Customer_ID serial primary key,
Name varchar (100),
Email varchar (100),
Phone int,
city varchar(100),
Country varchar(100)
);

create table orders(
Order_ID serial primary key,
Customer_ID int REFERENCES customers(Customer_ID), /*FOREIGN KEY*/ --CONNECT TABLES
Book_ID int REFERENCES books(book_id), /*FOREIGN KEY*/ --TO CONNECT TABLES
Order_Date date,
Quantity int,
Total_Amount numeric(10,2)
);

SELECT*FROM ORDERS;

---GET DATA FROM EXCEL OF BOOKS
COPY books(Book_ID,	Title,	Author,	Genre,	Published_Year,	Price,	Stock)
FROM 'C:\Program Files\PostgreSQL\18\Books.csv'
DELIMITER ','
CSV HEADER; --	/*BECAUSE THE FILE HAS HEADER*/

---GET DATA FROM EXCEL OF CUSTOMERS
COPY CUSTOMERS(Customer_ID,	Name,	Email,	Phone,	City,	Country)
FROM 'C:\Program Files\PostgreSQL\18\Customers.csv'
DELIMITER ','
CSV HEADER;

--GET DATA FROM EXCEL OF ORDERS
COPY ORDERS(Order_ID,	Customer_ID,	Book_ID,	Order_Date,	Quantity,	Total_Amount)
FROM 'C:\Program Files\PostgreSQL\18\Orders.csv'
DELIMITER ','
CSV HEADER;

--books genre Fiction
select*from books
where genre='Fiction';

--books published in 1950
select*from books
where published_year=1950;

--customers from Canada
select*from customers
where country='Canada';

--order in whole Nov 23
select*from orders
where order_date BETWEEN '2023-11-01' and '2023-11-30'; /*BETWEEN FOR WHOLE MONTH*/

---total books stock
select sum(quantity) as total book stock
from orders;

--most expensive book
select*from books
order by price desc limit 5;   /*LIMIT*/

--customers who ordered more than 1 book /*JOIN WITH CONDITIONS*/
select c.name, o.total_amount
from orders o
JOIN 
customers c ON c.customer_id=o.customer_id
where o.total_amount>1 order by o.total_amount asc;    /*JOIN WITH CONDITIONS*/

--orders where amount<20$
select*from orders
where total_amount>20 order by total_amount asc;

--all genre of books
select Distinct(genre) from books;

--lowest stock of books
select * from books
order by stock asc limit 5;

--totoal revenue from all orders
select sum(total_amount) as total_revenue from orders;


/*ADVANCED QUERIES:*/

--total books sold for each genre
select b.genre, sum(o.total_amount) 
from orders o
JOIN books b ON b.book_id=o.book_id;
group by genre;   -----/*GROUP BY USE TO GET TOTAL OF DISTICNT GENRE*/

--average price of books in Fantasy
select avg(price) from books as average_price
where genre='Fantasy';

3. --customers list who purchased atleast 2 orders
select c.name, o.total_amount
from orders o
JOIN customers c ON c.customer_id=o.customer_id
where o.total_amount>1 order by o.total_amount asc;  /*JOINT WITH CONDITIONS*/

--other way NO CUSTOMER NAME
select customer_id, COUNT(order_id)
from orders
group by customer_id
HAVING COUNT(order_id)>=2;    /*HAVING IS USED ON FILTERING FORMULLAS*/

--most frequent ordered book
select b.title, o.total_amount
from orders o
JOIN Books b ON b.Book_ID=o.Book_ID
order by o.total_amount desc limit 5;  /*JOINT WITH CONDITION AND LIMIT*/

--other way
SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers C ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id)>=2;

--top 3 most expensive books of Fantasy 
select Title, price from books 
where genre='Fantasy'
order by price desc limit 3;

--totla qty of books sold by each author
select b.author, sum(o.total_amount)
from orders o
JOIN books b ON b.book_id=o.book_id
group by b.author
order by sum(o.total_amount) desc;

--cities where customeres spent over 30$
select c.city, sum(o.Total_Amount)
from customers c
JOIN orders o ON c.customer_id=o.customer_id
group by c.city
HAVING sum(o.total_amount)>300
order by SUM(o.total_amount) DESC limit 5;

--OTHER WAY
select distinct c.city, total_amount
from orders o
JOIN customers c ON o.customer_id=c.customer_id
where o.total_amount>30;

--customer who spent the most on orders
select c.customer_id,c.name, sum(o.total_amount)
from customers c
JOIN orders o ON c.customer_id=o.customer_id
group by c.customer_id
order by sum(o.total_amount) desc;

--stock remaining after fulfilling all orders
select b.Book_id, b.title, b.stock, COALESCE (sum (o.quantity),0),
b.stock- COALESCE (sum (o.quantity),0) AS remaining_qty
from books b
Left join orders o on b.book_id=o.book_id
group by b.Book_id; 
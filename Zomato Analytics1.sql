select * from [dbo].[goldusers_signup]
select * from [dbo].[Product]
select * from [dbo].[Sales]
select * from [dbo].[users]

create table goldusers_signup
(userid int,gold_signup_date date)
insert into [dbo].[goldusers_signup]
Values(1,'09-22-2017'),(3,'04-21-2017')
select * from [dbo].[goldusers_signup]

Create table users
(userid int,singup_date date)
insert into users
values (1,'09-02-2014'),(2,'01-15-2015'),(3,'04-11-2014')
select * from users

create table Product
(Product_id int,Product_name text,Price int)
insert into Product
Values(1,'P1',980),(2,'P2',870),(3,'P3',330)

create table Sales
(ID int,created_date date,product_Id int)
insert into sales
Values (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2017',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2014',2),
(2,'09-10-2018',2)

select * from Sales

--what is total amount of each customer spent on zomato ?--
select a.ID,a.Product_ID,b.Price from Sales a inner join product b
on a.product_ID=b.Product_ID

select a.ID,sum(b.Price) from Sales a inner join product b
on a.product_ID=b.Product_ID
group by a.ID

select a.ID,sum(b.Price) total_amt_spent from Sales a inner join product b
on a.product_ID=b.Product_ID
group by a.ID
 
 --How many days has each customer visited Zomato?
select ID,count(distinct [created_date])from Sales group by ID
select ID,count(distinct [created_date]) distinct_days from Sales group by ID

--what was the first product purchased by each cutomer?
(select *,rank() over(partition by ID order by created_date)rnk from Sales)

select * from 
(select *,rank() over(partition by ID order by created_date)rnk from Sales)
a where rnk=1

--what is the most purchased item on the menu and how many times was it 
purchased by all cutomers?

select [product_Id],count([product_Id])from sales group by [product_Id]
order by count([product_Id])desc

select top 1 [product_Id],count([product_Id]) cnt from sales group by [product_Id]
order by count([product_Id])desc

select top 1 product_Id from sales group by [product_Id]
order by count([product_Id])desc

select * from [dbo].[Sales] where [product_Id]=
(select top 1 product_Id from sales group by [product_Id]
order by count([product_Id])desc)

select ID,count([product_Id])cnt from [dbo].[Sales] where [product_Id]=
(select top 1 product_Id from sales group by [product_Id]
order by count([product_Id])desc)
group by ID

--Which item was the most popular for each customer?
select ID,[product_Id],COUNT([product_Id])from Sales group by ID,[product_Id]

Select *,rank() over(partition by ID order by cnt desc) rnk from
(select ID,[product_Id],COUNT([product_Id]) cnt from Sales group by ID,[product_Id])a

select * from
(Select *,rank() over(partition by ID order by cnt desc) rnk from
(select ID,[product_Id],COUNT([product_Id]) cnt from Sales group by ID,[product_Id])a)b
where rnk=1
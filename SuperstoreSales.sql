--##-- Neccessary Data Manupulation---
-- Query--
--1. Find categories those are having more than average profit.
--2. Find categories those are having less than average profit.
--3. Find countries those are having more than average profit.
--4. Find the profits  more than average profit by year.
--5. Find highest profit amount in every category by country.
--6. Find highest profit amount in every category by year.
--7. In which category it takes maximum time to ship things by country? 
--8. In which category it takes maximum time to ship things by year?
--9. Total revenue and total profit(in million).

SELECT [Region]
      ,[Country]
      ,[Item Type]
      ,[Sales Channel]
      ,[Order Priority]
      ,[Order Date]
      ,[Order ID]
      ,[Ship Date]
      ,[Required_Shipping_Days]
      ,[Units Sold]
      ,[Unit Price]
      ,[Unit Cost]
      ,[Total Revenue]
      ,[Total Cost]
      ,[Total Profit]
      ,[Total_Profit_Percentage]
      ,[Month]
      ,[Year]
  FROM [Portfolio].[dbo].['10000 Sales Modified']

  -------------------------------Data Manupulation--------------------
  ---null

 select * from [Portfolio].[dbo].['10000 Sales Modified'] where [Total Revenue] = 0

 ----duplicates

 select * from [Portfolio].[dbo].['10000 Sales Modified'] group by
 [Region],[Country],[Item Type],[Sales Channel],[Order Priority],[Order Date],[Order ID]
,[Ship Date],[Required_Shipping_Days],[Units Sold],[Unit Price],[Unit Cost],[Total Revenue]
,[Total Cost],[Total Profit],[Total_Profit_Percentage],[Month],[Year] having count(*)>1

-----change date formate

alter table [Portfolio].[dbo].['10000 Sales Modified']
add order_date date

update [Portfolio].[dbo].['10000 Sales Modified']
set order_date = convert(date, [Order Date])

alter table [Portfolio].[dbo].['10000 Sales Modified']
add shipping_date date

update [Portfolio].[dbo].['10000 Sales Modified']
set shipping_date = convert(date, [Ship Date])

select * from [Portfolio].[dbo].['10000 Sales Modified']

--dropping column
alter table [Portfolio].[dbo].['10000 Sales Modified']
drop column [Order Date]

alter table [Portfolio].[dbo].['10000 Sales Modified']
drop column [Ship Date]

alter table [Portfolio].[dbo].['10000 Sales Modified']
drop column [Month]

alter table [Portfolio].[dbo].['10000 Sales Modified']
drop column [Order ID]

alter table [Portfolio].[dbo].['10000 Sales Modified']
drop column [Order Priority]

select * from [Portfolio].[dbo].['10000 Sales Modified']

----------------------------------Data Query----------------------------

--1. Find categories those are having more than average profit.
--total 
select s.[Item Type], sum([Total Profit]) 
         as Total_Profit from [Portfolio].[dbo].['10000 Sales Modified']s 
		 group by s.[Item Type]


--average 
select cast(avg(Total_Profit) as int) as average from (select s.[Item Type], sum([Total Profit]) 
         as Total_Profit from [Portfolio].[dbo].['10000 Sales Modified']s 
		 group by s.[Item Type])h


with total ([Item Type], Total_Profit) as
        (select s.[Item Type], sum([Total Profit]) 
         as Total_Profit from [Portfolio].[dbo].['10000 Sales Modified']s 
		 group by s.[Item Type]),
  average_profit (average) as 
(select cast(avg(Total_Profit) as int) as average from total)

select * from total ts join average_profit av on 
ts.Total_Profit > av.average

--2. Find categories those are having less than average profit.

with total ([Item Type], Total_Profit) as
        (select s.[Item Type], sum([Total Profit]) 
         as Total_Profit from [Portfolio].[dbo].['10000 Sales Modified']s 
		 group by s.[Item Type]),
  average_profit (average) as 
(select cast(avg(Total_Profit) as int) as average from total)

select * from total ts join average_profit av on 
ts.Total_Profit < av.average

--3. Find countries those are having more than average profit.

--total 
select s.[Country], sum([Total Profit]) 
         as Total_Profit from [Portfolio].[dbo].['10000 Sales Modified']s 
		 group by s.[Country]


--average 
select cast(avg(Total_Profit) as int) as average from (select s.[Country], sum([Total Profit]) 
         as Total_Profit from [Portfolio].[dbo].['10000 Sales Modified']s 
		 group by s.[Country])h


with total ([Country], Total_Profit) as
        (select s.[Country], sum([Total Profit]) 
         as Total_Profit from [Portfolio].[dbo].['10000 Sales Modified']s 
		 group by s.[Country]),
  average_profit (average) as 
(select cast(avg(Total_Profit) as int) as average from total)

select * from total ts join average_profit av on 
ts.Total_Profit > av.average

--4. Find the profits  more than average profit by year.

--total 
select s.[Year], sum([Total Profit]) 
         as Total_Profit from [Portfolio].[dbo].['10000 Sales Modified']s 
		 group by s.[Year]


--average 
select cast(avg(Total_Profit) as int) as average from (select s.[Year], sum([Total Profit]) 
         as Total_Profit from [Portfolio].[dbo].['10000 Sales Modified']s 
		 group by s.[Year])h

--Main
with total ([Year], Total_Profit) as
        (select s.[Year], sum([Total Profit]) 
         as Total_Profit from [Portfolio].[dbo].['10000 Sales Modified']s 
		 group by s.[Year]),
  average_profit (average) as 
(select cast(avg(Total_Profit) as int) as average from total)

select * from total ts join average_profit av on 
ts.Total_Profit > av.average


--5. Find hifhest profit amount in every category by country

--offline
select m.*, records = ROW_NUMBER() over(partition by [Country], [Item Type] 
order by [Total Profit] desc) from (select e.[Country], 
e.[Item Type],e.[Sales Channel],
e.[Total Revenue],e.[Total Profit],e.Year,
lag([Total Profit], 1, 0) over(partition by [Country] order by [Item Type]) 
as prev_year_profit FROM [Portfolio].[dbo].['10000 Sales Modified'] e 
where e.[Sales Channel] = 'Offline')m

--online
select m.*, records = ROW_NUMBER() over(partition by [Country], [Item Type]
order by [Total Profit] desc) from (select e.[Country], 
e.[Item Type],e.[Sales Channel],e.[Required_Shipping_Days],
e.[Total Revenue],e.[Total Profit],e.Year,
lag([Total Profit], 1, 0) over(partition by [Country] order by [Item Type]) 
as prev_year_profit FROM [Portfolio].[dbo].['10000 Sales Modified'] e 
where e.[Sales Channel] = 'Online')m

--6. Find hifhest profit amount in every category by year

---offline
select m.*, records = ROW_NUMBER() over(partition by [Item Type], [Year] 
order by [Total Profit] desc) from (select e.[Country], 
e.[Item Type],e.[Sales Channel],
e.[Total Revenue],e.[Total Profit],e.Year,
lag([Total Profit], 1, 0) over(partition by [Country] order by [Item Type]) 
as prev_year_profit FROM [Portfolio].[dbo].['10000 Sales Modified'] e 
where e.[Sales Channel] = 'Offline')m

--online
select m.*, records = ROW_NUMBER() over(partition by [Item Type], [Year]
order by [Total Profit] desc) from (select e.[Country], 
e.[Item Type],e.[Sales Channel],e.[Required_Shipping_Days],
e.[Total Revenue],e.[Total Profit],e.Year,
lag([Total Profit], 1, 0) over(partition by [Country] order by [Item Type]) 
as prev_year_profit FROM [Portfolio].[dbo].['10000 Sales Modified'] e 
where e.[Sales Channel] = 'Online')m


--7. In which category it took maximum time to ship things by Country? 

select m.*, records = ROW_NUMBER() over(partition by [Country]
order by [Required_Shipping_Days] desc) from (select e.[Country], 
e.[Item Type],e.[Sales Channel],e.[Required_Shipping_Days],
e.[Total Revenue],e.[Total Profit],e.Year,
lag([Total Profit], 1, 0) over(partition by [Country] order by [Item Type]) 
as prev_year_profit FROM [Portfolio].[dbo].['10000 Sales Modified'] e 
where e.[Sales Channel] = 'Online')m

--8. In which category it took maximum time to ship things by year?

select m.*, records = ROW_NUMBER() over(partition by [Year]
order by [Required_Shipping_Days] desc) from (select e.[Country], 
e.[Item Type],e.[Sales Channel],e.[Required_Shipping_Days],
e.[Total Revenue],e.[Total Profit],e.Year,
lag([Total Profit], 1, 0) over(partition by [Country] order by [Item Type]) 
as prev_year_profit FROM [Portfolio].[dbo].['10000 Sales Modified'] e 
where e.[Sales Channel] = 'Online')m

--9. Total revenue and total profit(in million)

---------Total revenue--------
select cast(sum([Total_Revenue_Million]) as int) as total_revenue_mil from
(SELECT [Region]
      ,[Country]
      ,[Item Type]
      ,[Sales Channel]
      ,[Required_Shipping_Days]
      ,[Total Revenue]*0.000001 as 'Total_Revenue_Million'
      ,[Total Profit]*0.000001 as 'Total_Profit_Million'
      ,[Year]
  FROM [Portfolio].[dbo].['10000 Sales Modified'])s

----------Total Profit----------

 select cast(sum([Total_Profit_Million]) as int) as total_revenue_mil from
(SELECT [Region]
      ,[Country]
      ,[Item Type]
      ,[Sales Channel]
      ,[Required_Shipping_Days]
      ,[Total Revenue]*0.000001 as 'Total_Revenue_Million'
      ,[Total Profit]*0.000001 as 'Total_Profit_Million'
      ,[Year]
  FROM [Portfolio].[dbo].['10000 Sales Modified'])s

--Main part
with overall ([Total_Revenue_Million]) as 
(select cast(sum([Total_Revenue_Million]) as int) as total_profit_mil from
(SELECT [Region]
      ,[Country]
      ,[Item Type]
      ,[Sales Channel]
      ,[Required_Shipping_Days]
      ,[Total Revenue]*0.000001 as 'Total_Revenue_Million'
      ,[Total Profit]*0.000001 as 'Total_Profit_Million'
      ,[Year]
FROM [Portfolio].[dbo].['10000 Sales Modified'])s),
profit(Total_Profit_Million) as ( select cast(sum([Total_Profit_Million]) as int) as total_revenue_mil from
(SELECT [Region]
      ,[Country]
      ,[Item Type]
      ,[Sales Channel]
      ,[Required_Shipping_Days]
      ,[Total Revenue]*0.000001 as 'Total_Revenue_Million'
      ,[Total Profit]*0.000001 as 'Total_Profit_Million'
      ,[Year]
  FROM [Portfolio].[dbo].['10000 Sales Modified'])s)

select * from overall ts join profit av on 
ts.Total_Revenue_Million > av.Total_Profit_Million
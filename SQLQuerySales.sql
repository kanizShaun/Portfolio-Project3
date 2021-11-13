--Importing Data

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
  FROM [Portfolio].[dbo].['10000_Sales_Modified'] order by 1,2

--Null Values

 select * from [Portfolio].[dbo].['10000_Sales_Modified'] order by 3,4

--Handling Duplicets 

select Country, [Total Cost] FROM [Portfolio].[dbo].['10000_Sales_Modified'] 
group by Country, [Total Cost] having COUNT(*) > 1

WITH CTE AS(
   SELECT [Region],[Country],[Unit Price],[Unit Cost],[Total Revenue],[Total Cost],
       RN = ROW_NUMBER()OVER(PARTITION BY [Region],[Country],[Unit Price], [Unit Cost],
	   [Total Revenue],[Total Cost] ORDER BY 
	   [Region],[Country],[Unit Price], [Unit Cost],[Total Revenue],[Total Cost])
   FROM [Portfolio].[dbo].['10000_Sales_Modified']
)
DELETE FROM CTE WHERE RN > 1

select * from [Portfolio].[dbo].['10000_Sales_Modified']

--Changing Date Formate

alter table [Portfolio].[dbo].['10000_Sales_Modified']
add Order_Date date

update [Portfolio].[dbo].['10000_Sales_Modified']
set Order_Date = convert(date, [Order Date])

Alter table [Portfolio].[dbo].['10000_Sales_Modified']
add Ship_Date date

update [Portfolio].[dbo].['10000_Sales_Modified']
set Ship_Date = convert(date, [Ship Date])

select * from [Portfolio].[dbo].['10000_Sales_Modified']


--Total_Profit_Percentage Column modifying

select [Total_Profit_Percentage], [Total_Profit_Percentage]* 100  as [Total_Profit_percentage] 
from [Portfolio].[dbo].['10000_Sales_Modified']
group by [Total_Profit_Percentage];

alter table [Portfolio].[dbo].['10000_Sales_Modified']
add Overall_Profit_Percentage int

update [Portfolio].[dbo].['10000_Sales_Modified']
set Overall_Profit_Percentage = [Total_Profit_Percentage]* 100 
from [Portfolio].[dbo].['10000_Sales_Modified']

select * from [Portfolio].[dbo].['10000_Sales_Modified']

--Dropping Unnecessary Columns

alter table [Portfolio].[dbo].['10000_Sales_Modified']
drop column [Order Date]

alter table [Portfolio].[dbo].['10000_Sales_Modified']
drop column [Ship Date]

alter table [Portfolio].[dbo].['10000_Sales_Modified']
drop column [Total_Profit_Percentage]

select * from [Portfolio].[dbo].['10000_Sales_Modified']

--Data Querying

select * from [Portfolio].[dbo].['10000_Sales_Modified']

select distinct(Region) from [Portfolio].[dbo].['10000_Sales_Modified']

select count(distinct(Region)) from [Portfolio].[dbo].['10000_Sales_Modified']

select distinct(Country) from [Portfolio].[dbo].['10000_Sales_Modified']

select count(distinct(Country)) from [Portfolio].[dbo].['10000_Sales_Modified']

select distinct([Item Type]) from [Portfolio].[dbo].['10000_Sales_Modified']

select count(distinct([Item Type])) from [Portfolio].[dbo].['10000_Sales_Modified']

select count(*) from  [Portfolio].[dbo].['10000_Sales_Modified'] 
where [Sales Channel] = 'Online'

--Data Collection For Visualization

select * from [Portfolio].[dbo].['10000_Sales_Modified'] order by 1,2

SELECT [Region],[Country], [Item Type], [Sales Channel],[Units Sold],[Unit Price], [Unit Cost] 
from [Portfolio].[dbo].['10000_Sales_Modified'] order by 1,2


SELECT [Region],[Country], [Item Type], [Sales Channel],
[Total Revenue],[Total Cost],[Total Profit],[Overall_Profit_Percentage] 
from [Portfolio].[dbo].['10000_Sales_Modified'] order by [Total Revenue] desc

SELECT [Region]
      ,[Country]
      ,[Item Type]
      ,[Sales Channel]
      ,[Total Revenue]
      ,[Total Cost]
      ,[Total Profit]
      ,[Overall_Profit_Percentage]
  FROM [Portfolio].[dbo].['10000_Sales_Modified'] order by [Overall_Profit_Percentage] desc

SELECT [Country]
      ,[Item Type]
      ,[Sales Channel]
      ,[Required_Shipping_Days]
      ,[Units Sold]
      ,[Unit Price]
      ,[Unit Cost]
	  ,[Overall_Profit_Percentage]
FROM [Portfolio].[dbo].['10000_Sales_Modified'] order by [Required_Shipping_Days] asc 

select [Country], [Item Type], [Sales Channel], sum([Total Revenue]) as Highest_Revenue
from [Portfolio].[dbo].['10000_Sales_Modified'] group by [Country], [Item Type], [Sales Channel]
order by sum([Total Revenue]) desc

select [Country], [Item Type], [Sales Channel], sum([Total Cost]) as Highest_Cost
from [Portfolio].[dbo].['10000_Sales_Modified'] group by [Country], [Item Type], [Sales Channel]
order by sum([Total Cost]) desc

select [Country], [Item Type], [Sales Channel], sum([Total Profit]) as Highest_Profit
from [Portfolio].[dbo].['10000_Sales_Modified'] group by [Country], [Item Type], [Sales Channel]
order by sum([Total Profit]) desc

select [Country],[Item Type],[Sales Channel],[Units Sold],
[Unit Price],[Unit Cost],[Total Profit],
[Overall_Profit_Percentage],[Required_Shipping_Days]
from  [Portfolio].[dbo].['10000_Sales_Modified'] 
where [Sales Channel] = 'Online' order by [Total Profit] desc

select [Country],[Item Type],[Sales Channel],[Units Sold],
[Unit Price],[Unit Cost],[Total Profit],
[Overall_Profit_Percentage],[Required_Shipping_Days]
from  [Portfolio].[dbo].['10000_Sales_Modified'] 
where [Sales Channel] = 'Offline' order by [Total Profit] desc




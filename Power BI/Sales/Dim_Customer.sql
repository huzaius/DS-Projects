/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
  c.customerKey as CustomerKey, 
  c.firstname as [FirstName], 
  c.middlename as [MiddleName], 
  c.lastname as [LastName], 
  c.firstname + ' ' + c.LastName as [Full Name], 
  case c.gender when 'M' then 'Male' when 'F' then 'female' end as [Gender], 
  c.DateFirstPurchase as DateFirstPurchase, 
  City as [Customer City], 
  g.[EnglishCountryRegionName] as [Country Name] 
FROM 
  [AdventureWorksDW2019].[dbo].[DimCustomer] as c 
  LEFT JOIN dbo.DimGeography as g ON g.GeographyKey = c.GeographyKey 
order by 
  CustomerKey asc

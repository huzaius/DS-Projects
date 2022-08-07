/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
 [ProductKey], 
  [OrderDateKey], 
  [DueDateKey], 
  [ShipDateKey], 
  [CustomerKey], 
  [SalesOrderNumber], 
  [SalesAmount] 
FROM 
  [AdventureWorksDW2019].[dbo].[FactInternetSales] 
  -- where   LEFT (OrderDateKey,4) >= YEAR(GETDATE()) - 2 --Ensures query is for last 2 years using the orderdatekey
order by 
  OrderDateKey ASC

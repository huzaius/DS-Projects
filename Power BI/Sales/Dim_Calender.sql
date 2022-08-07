/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
  [DateKey], 
  [FullDateAlternateKey] as Date, 
  [EnglishDayNameOfWeek] as Day, 
  [WeekNumberOfYear] as WeekNum, 
  [EnglishMonthName], 
  LEFT([EnglishMonthName], 3) as MonthShort, 
  [MonthNumberOfYear] as monthNum, 
  [CalendarQuarter] as Quarter, 
  [CalendarYear] as Year 
FROM 
  [AdventureWorksDW2019].[dbo].[DimDate]

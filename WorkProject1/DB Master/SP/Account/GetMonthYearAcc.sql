 Alter PROCEDURE [dbo].[GetMonthYearAcc]

AS
BEGIN
 DECLARE @start_date DATETIME , @end_date DATETIME

  SET @start_date = CAST( '2018/1/1' AS datetime)
  SET @end_date = CAST( '2022/12/31' AS datetime);

  WITH CTE AS
(
    SELECT @start_date AS cte_start_date
    UNION ALL
    SELECT DATEADD(MONTH, 1, cte_start_date)
    FROM CTE
    WHERE DATEADD(MONTH, 1, cte_start_date) <= @end_date   
)
SELECT YEAR( cte_start_date)as [year] , MONTH(cte_start_date) , [MonthName]
FROM CTE
INNER JOIN Fees_FeesMonth ON FeesMonthId = MONTH(cte_start_date)



END
---exec [GetMonthYearAcc]
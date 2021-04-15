
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetFiscalSessionByCurrentMonth]'))
BEGIN
DROP PROCEDURE  GetFiscalSessionByCurrentMonth
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[GetFiscalSessionByCurrentMonth] 4457
CREATE PROC [dbo].[GetFiscalSessionByCurrentMonth] 
@StudentIID INT
AS
BEGIN
DECLARE @FeesSessionYearCur INT
DECLARE @FeesSessionYearId INT
DECLARE @FeesSessionYearlast INT
SELECT @FeesSessionYearCur = FeesSessionYearId  FROM Fees_Student WHERE StudentIID = @StudentIID AND MonthId = Month(GETDATE())  AND [Year] = Year(GETDATE())  ORDER BY ProcessId DESC 
SELECT @FeesSessionYearlast =  FeesSessionYearId  FROM Fees_Student WHERE StudentIID = @StudentIID AND datefromparts(Year,MonthId, 1) <= EOMONTH(datefromparts(Year(GETDATE()),Month(GETDATE()), 1))  ORDER BY ProcessId DESC


SELECT @FeesSessionYearId = CASE WHEN @FeesSessionYearCur > 0 THEN @FeesSessionYearCur
                                 ELSE @FeesSessionYearlast END


SELECT FFS.[FeesFiscalSessionId],[SessionId],[FiscalSessionName] FROM Fees_FeesSessionYear FFSY
INNER JOIN dbo.Fees_FiscalSession FFS ON FFS.FeesFiscalSessionId = FFSY.FeesFiscalSessionId
WHERE FFSY.FeesSessionYearId = @FeesSessionYearId
END
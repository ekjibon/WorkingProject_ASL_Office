

/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetMonthByFiscalSession]'))
BEGIN
DROP PROCEDURE  GetMonthByFiscalSession
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 Arifur
-- Create date: 
-- Description:	
-- =============================================

 --execute GetMonthByFiscalSession 11
CREATE  PROCEDURE [dbo].GetMonthByFiscalSession 
(
 @FeesFiscalSessionId INT
)

AS
BEGIN
SELECT FSY.FeesFiscalSessionId
		,FSY.Year,FSY.MonthId,FSY.FeesSessionYearId
,Fm.[MonthName],FAC.Amount,FAC.LateDate,FAC.Remarks 
,(SELECT ISNULL((CASE WHEN COUNT(AutomatedConfigId)>0 THEN 1 ELSE 0 END),0 ) FROM dbo.Fees_AutomatedFeesConfig WHERE FeesSessionYearId = FSY.FeesSessionYearId AND IsConfigChecked = 1) AS IsOldCheck
FROM dbo.Fees_FeesSessionYear FSY
  INNER JOIN dbo.Fees_FeesMonth FM ON Fm.FeesMonthId = FSY.MonthId
  LEFT OUTER JOIN dbo.Fees_AutomatedFeesConfig FAC ON FAC.FeesSessionYearId = FSY.FeesSessionYearId
 WHERE FSY.FeesFiscalSessionId = @FeesFiscalSessionId
END


  



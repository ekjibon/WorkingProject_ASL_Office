


/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetFeesAutomatedFeesConfigList]'))
BEGIN
DROP PROCEDURE  [GetFeesAutomatedFeesConfigList]
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

 --execute ProcessFees 51,1
CREATE  PROCEDURE [dbo].[GetFeesAutomatedFeesConfigList] 

AS
BEGIN

SELECT FA.*,FS.FiscalSessionName ,FM.MonthName,FSY.Year
		FROM Fees_AutomatedFeesConfig FA
		INNER JOIN dbo.Fees_FiscalSession FS ON FS.FeesFiscalSessionId = FA.FeesFiscalSessionId
		INNER JOIN dbo.Fees_FeesSessionYear FSY ON FSY.FeesSessionYearId = FA.FeesSessionYearId
		INNER JOIN dbo.Fees_FeesMonth FM ON FM.FeesMonthId = FSY.MonthId
		WHERE FA.IsDeleted = 0 AND FA.IsConfigChecked = 1
END


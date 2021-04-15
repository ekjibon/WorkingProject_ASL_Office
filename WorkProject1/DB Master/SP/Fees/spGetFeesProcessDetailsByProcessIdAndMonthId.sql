/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[spGetFeesProcessDetailsByProcessIdAndMonthId]'))
BEGIN
DROP PROCEDURE  spGetFeesProcessDetailsByProcessIdAndMonthId
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Biplob
-- Create date: 
-- Description:	
-- =============================================

 --D.ProcessDetailsId=1015 --@ProcessTypeId
 --spGetFeesProcessDetailsByProcessIdAndMonthId 34

Create  PROCEDURE spGetFeesProcessDetailsByProcessIdAndMonthId 
    @FeesMonthId INT
AS
BEGIN

 DECLARE @IsChecked bit =0;
    SELECT 
	ProcessDetailsId, 
	M.[MonthName]
	,(SELECT ISNULL(( CASE WHEN COUNT(S.ProcessDetailsId)>0 THEN 1 ELSE 0 END),0) FROM dbo.Fees_ProcessDetails S WHERE SessionYearId = D.SessionYearId) AS IsCheckedOld
	, @IsChecked AS IsChecked
	,D.SessionYearId as FeesMonthId,ProcessId
	FROM Fees_ProcessDetails D 
	 INNER JOIN Fees_FeesSessionYear FY On D.SessionYearId=Fy.FeesSessionYearId 
	 INNER JOIN Fees_FeesMonth M On M.FeesMonthId=Fy.MonthId
	 where D.SessionYearId=@FeesMonthId

	  DECLARE @IsChecked bit =0;
	 	  SELECT M.[MonthName]
		  	,(SELECT ISNULL(( CASE WHEN COUNT(S.ProcessDetailsId)>0 THEN 1 ELSE 0 END),0) FROM dbo.Fees_ProcessDetails S WHERE SessionYearId = D.SessionYearId) AS IsCheckedOld
			, @IsChecked AS IsChecked
		  ,D.SessionYearId as FeesMonthId FROM Fees_ProcessDetails D 
	 INNER JOIN Fees_FeesSessionYear FY On D.SessionYearId=Fy.FeesSessionYearId 
	 INNER JOIN Fees_FeesMonth M On M.FeesMonthId=Fy.MonthId
	 where D.ProcessId=1005
END	

		
	
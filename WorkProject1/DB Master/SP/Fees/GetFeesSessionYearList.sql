/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetFeesSessionYearList]'))
BEGIN
DROP PROCEDURE  [GetFeesSessionYearList]
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
CREATE  PROCEDURE [dbo].[GetFeesSessionYearList] 

AS
BEGIN

Select  distinct fs.ClassId, fs.SessionName,fs.SessionCode, fs.Session_StartDate,fs.Session_EndDate, c.ClassName from dbo.[Fees_FeesSessionYear] fs
  inner join dbo.Ins_ClassInfo c on c.ClassId = fs.ClassId
	  left outer join dbo.Fees_FeesMonth fm on fm.FeesMonthId = fs.MonthId
	   where  fs.IsDeleted = 0 
	   group by  fs.ClassId,fs.SessionName,c.ClassName,fs.Session_StartDate,fs.Session_EndDate,fs.SessionCode
END


  
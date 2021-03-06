/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptCollectionUserSummeryMonthlyOrRange]'))
BEGIN
DROP PROCEDURE  [rptCollectionUserSummeryMonthlyOrRange]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shahin
-- Create date: March 19, 2018
-- Description:	
-- =============================================


CREATE  PROCEDURE [dbo].[rptCollectionUserSummeryMonthlyOrRange] 
(
  
	@Where varchar(MAX) = NULL,
	@sortby varchar(MAX) = NULL
)	
AS
BEGIN
		DECLARE @sql varchar(max)     
		SET @sql = 'select s.SessionName, v.VersionName, b.BranchName, sh.ShiftName, c.ClassName,g.GroupName, 
 sc.SectionName,DATEPART(DAY, CM.PaymentDate) [Day], SUM(CD.ReceiveAmount) Amount ,U.FullName UserFullName,M.MonthName
 from dbo.Fees_CollectionMaster CM
 inner join dbo.Fees_CollectionDetails CD on CD.MasterID=CM.Id
 inner join dbo.AspNetUsers U on U.Id=CM.AddBy
 join dbo.Student_BasicInfo sb on sb.StudentIID=CM.StudentIID and sb.Status=''A'' and sb.IsDeleted=0 
 INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId  
		INNER JOIN  dbo.Ins_Branch b ON sb.BranchID = b.BranchId 
		INNER JOIN  dbo.Ins_Version V ON sb.VersionID = V.VersionID 
		INNER JOIN dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId 
		INNER JOIN dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId 
		INNER JOIN  dbo.Ins_Group g ON sb.GroupId = g.GroupId
		INNER JOIN dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
		INNER JOIN dbo.Fees_FeesMonth m ON m.FeesMonthId = CD.MonthId'
		  IF(@Where IS NOT NULL AND  @Where <> '')
	 BEGIN
	 SET @sql = @sql + ' where '+ @Where
	 END
 SET @sql = @sql + ' Group By CM.PaymentDate, s.SessionName, v.VersionName, 
b.BranchName, sh.ShiftName, c.ClassName,g.GroupName, sc.SectionName,U.FullName,m.MonthName
'
 IF(@sortby IS NOT NULL AND  @sortby <> '')
	BEGIN
	 SET @sql = @sql + ' Order by '+ @sortby
	 END
	 print(@sql)
	EXEC(@sql)

END










		   

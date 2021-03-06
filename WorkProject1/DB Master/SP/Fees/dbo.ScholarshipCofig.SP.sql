/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ScholarshipCofig]'))
BEGIN
DROP PROCEDURE  [ScholarshipCofig]
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

  CREATE PROCEDURE [dbo].[ScholarshipCofig] 
(
    @Block INT=0,
	@StudentIID BIGINT=null, -- using for block 2
	@SessionId INT=null,
	@BranchId INT=null,
	@ShiftId INT =null,
	@ClassId INT = null,
	@Section INT = null
)	
AS
BEGIN
		IF(@SessionId=0) SET @SessionId = NULL;
		IF(@BranchId=0) SET @BranchId = NULL;
		IF(@ShiftId=0) SET @ShiftId = NULL;
		IF(@ClassId=0) SET @ClassId = NULL;
		IF(@Section=0) SET @Section = NULL;
		IF(@StudentIID=0) SET @StudentIID = NULL;
 
	IF(@Block=1) -- ScholarshipCofig Lists
	BEGIN  -- [dbo].[ScholarshipCofig] 1,null,1,1,2,1,1,0,5
	    select B.FullName,B.RollNo,B.StudentInsID,B.StudentIID AS StudentId,B.SessionId,m.ScholarshipConfigId,m.Amount,M.Command,m.IsPercentage,m.FeesHeadId,H.HeadName,m.ScholarshipTypeId,ST.ScholarshipType
	    from Fees_ScholarshipMaster as m
		INNER JOIN Student_BasicInfo B on B.StudentIID=M.StudentId
		INNER JOIN [dbo].[Fees_ScholarshipType] ST on ST.ScholarshipTypeId=m.ScholarshipTypeId
		INNER JOIN Fees_Head H on H.FeesHeadId=m.FeesHeadId
		
		WHERE  
			B.SessionId=ISNULL(@SessionId,B.SessionId) AND B.BranchID=ISNULL(@BranchId,B.BranchID) 
		AND B.ShiftID=ISNULL(@ShiftId,B.ShiftID) AND B.ClassId=ISNULL(@ClassId,B.ClassId) 
		AND B.SectionId=ISNULL(@Section,B.SectionId) AND B.IsDeleted=0 AND B.Status='A' AND m.IsDeleted = 0
		ORDER BY CAST(B.RollNo AS INT)
				
	END	
	IF(@Block=2) -- ScholarshipCofig Lists
	BEGIN  -- [dbo].[ScholarshipCofig] 2,158,NULL,NULL,NULL,NULL,NULL,NULL
		select B.FullName,B.RollNo,B.StudentInsID,B.StudentIID AS StudentId,m.ScholarshipConfigId,m.Amount,M.Command,m.IsPercentage,m.FeesHeadId,H.HeadName,m.ScholarshipTypeId,ST.ScholarshipType
		 from Fees_ScholarshipMaster as m
		INNER JOIN Student_BasicInfo B on B.StudentIID=M.StudentId
		INNER JOIN [dbo].[Fees_ScholarshipType] ST on ST.ScholarshipTypeId=m.ScholarshipTypeId
		INNER JOIN Fees_Head H on H.FeesHeadId=m.FeesHeadId
		WHERE B.StudentIID=ISNULL(@StudentIID, B.StudentIID) 
		AND	B.SessionId=ISNULL(@SessionId,B.SessionId) 
		AND B.BranchID=ISNULL(@BranchId,B.BranchID) 
		AND B.ShiftID=ISNULL(@ShiftId,B.ShiftID) AND B.ClassId=ISNULL(@ClassId,B.ClassId) 
		AND B.SectionId=ISNULL(@Section,B.SectionId) AND B.IsDeleted=0 AND B.Status='A' AND m.IsDeleted = 0
		ORDER BY CAST(B.RollNo AS INT)
		 		
	END		
	IF(@Block=3) -- Month  List by session Id
	BEGIN  -- [dbo].[ScholarshipCofig] 3,'111811004',NULL,1,NULL,NULL,NULL,NULL
		select --FS.FeesSessionYearId,FS.MonthId,FM.[MonthName],FS.SessionId ,
		FS.FeesSessionYearId,CONCAT(LEFT(FM.[MonthName],3),'-',RIGHT(FS.[Year],2)) AS [MonthName]
		,CAST(0 as bit) as IsSelected 
		,CAST(ISNULL((SELECT top 1 ISNULL(MonthId,0) FROM Fees_Student WHERE FeesStudentId=@StudentIID AND ClassId=FFS.ClassId AND MonthId=FS.MonthId ),0) AS BIT) AS IsDisable
		from [dbo].[Fees_FeesSessionYear] as FS
		
		INNER JOIN Fees_FeesMonth as FM on FM.FeesMonthId=FS.MonthId
		INNER JOIN [dbo].Fees_FiscalSession FFS ON FFS.FeesFiscalSessionId = FS.FeesFiscalSessionId
		where FFS.FeesFiscalSessionId=@SessionId 

		-- SELECT * FROM [dbo].Fees_ScholarshipMaster
		-- SELECT * FROM [dbo].[Fees_FeesSessionYear] WHERE FeesFiscalSessionId = 41
		

	END		
END









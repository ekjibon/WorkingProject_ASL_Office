/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FeesModify]'))
BEGIN
DROP PROCEDURE  [FeesModify]
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


CREATE  PROCEDURE [dbo].[FeesModify] 
(
    @Block INT=0,

	@SessionId INT=null,
	@BranchId INT=null,
	@ShiftId INT =null,
	@ClassId INT = null,

	@SectionId INT=null,	
	@StudentIId INT=null,
	@HeadId INT =null
)
	
AS
BEGIN
	
	IF(@Block=1)-- Studen List with due -- [FeesModify] 1,null,null,null,null,null,null,null,844,null
	BEGIN  -- [FeesModify] 1,1,1,2,1,1,0,5,null,null	    
      SELECT  B.StudentIID,B.FullName,RTRIM(B.StudentInsID) AS StudentInsID,B.RollNo
             ,SUM(ISNULL(S.DueAmount,0)) TotalDueAmount,SUM(Isnull(S.AdvanceAmount,0)) TotalAdvanceAmount
      FROM Student_BasicInfo B 
           LEFT JOIN Fees_Student S ON B.StudentIID=S.StudentIID AND S.IsDeleted=0 
	  WHERE B.StudentIID=ISNULL(@StudentIID, B.StudentIID) 
		AND	B.SessionId=ISNULL(@SessionId,B.SessionId) AND B.BranchID=ISNULL(@BranchId,B.BranchID) 
		AND B.ShiftID=ISNULL(@ShiftId,B.ShiftID) AND B.ClassId=ISNULL(@ClassId,B.ClassId) 
		AND B.SectionId=ISNULL(@SectionId,B.SectionId) AND B.IsDeleted=0 AND B.[Status]='A' --AND S.IsDeleted=0 
      GROUP BY B.StudentIID,B.FullName,B.RollNo,B.StudentInsID
      ORDER BY CAST(B.RollNo AS INT)
	END
		IF(@Block=2)-- 
	BEGIN  -- [FeesModify] 2,null,null,null,null,null,null,null,10749,null   --22808 -  16918
     SELECT s.StudentIID,s.HeadId,h.HeadName,SUM(ISNULL(S.DueAmount,0)) DueAmount,SUM(ISNULL(S.AdvanceAmount,0)) AdvanceAmount
	 from Fees_Student s
       inner join Fees_Head h on h.FeesHeadId=s.HeadId
     where s.StudentIID=@StudentIId and s.IsDeleted=0
     GROUP BY s.StudentIID,s.HeadId,h.HeadName
	END
	IF(@Block=3)-- 
	BEGIN  -- [FeesModify] 3,null,null,null,null,null,null,null,10655,21 
     SELECT S.FeesStudentId,S.HeadId,S.StudentIID,S.DueAmount,S.TotalAmount,S.ScholarshipAmount,S.DiscountAmount,S.PaidAmount,S.AdvanceAmount,S.Narration
     ,S.[ProcessId],S.[IsPaid],S.[IsCompleted],S.[ProcessType],S.[FeesBookNo],S.[NoModifiedDueAmount],S.[FeesSessionYearId],S.[MonthId],S.[SessionId]
	 ,CONCAT(LEFT(FM.[MonthName],3),'-' ,RIGHT(SY.[year],2)) AS [Month]
   from Fees_Student S
   left join Fees_FeesSessionYear SY on sy.FeesSessionYearId=S.FeesSessionYearId
   left join Fees_FeesMonth FM on FM.FeesMonthId=SY.MonthId
   where S.StudentIID=@StudentIId and S.HeadId=@HeadId  and S.IsDeleted=0
	END
	IF(@Block=4)
	BEGIN  -- [FeesModify] 4,null,null,null,null,null,null,null,10655,21 
     SELECT S.FeesStudentId,S.HeadId,S.StudentIID,S.DueAmount,S.TotalAmount,S.ScholarshipAmount,S.DiscountAmount,S.PaidAmount,S.AdvanceAmount,S.Narration
     ,S.[ProcessId],S.[IsPaid],S.[IsCompleted],S.[ProcessType],S.[FeesBookNo],S.[NoModifiedDueAmount],S.[FeesSessionYearId],S.[MonthId],S.[SessionId]
	 ,CONCAT(LEFT(FM.[MonthName],3),'-' ,RIGHT(SY.[year],2)) AS [Month]
   from Fees_Student S
   left join Fees_FeesSessionYear SY on sy.FeesSessionYearId=S.FeesSessionYearId
   left join Fees_FeesMonth FM on FM.FeesMonthId=SY.MonthId
   where S.StudentIID=@StudentIId and S.HeadId=@HeadId and S.IsCompleted=0 and S.IsDeleted=0
	END
END




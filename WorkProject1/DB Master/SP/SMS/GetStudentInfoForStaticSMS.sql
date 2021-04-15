IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentInfoForStaticSMS]'))
BEGIN
DROP PROCEDURE  GetStudentInfoForStaticSMS
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE [dbo].[GetStudentInfoForStaticSMS] -- Total 7 param
	
	
	@SessionId INT = NULL,
	@BranchID INT = NULL,
	@ShiftID INT = NULL,
	@ClassId INT = NULL,
	
	@SectionId INT = NULL,
	@StudentIID INT = NULL
	--@ClubId INT = NULL
	
	
AS
BEGIN

		IF @SessionId = 0 SET @SessionId  = NULL
		IF @BranchID = 0 SET @BranchID  = NULL
		IF @ShiftID = 0 SET @ShiftID  = NULL
		IF @ClassId = 0 SET @ClassId  = NULL
		
		IF @SectionId = 0 SET @SectionId  = NULL
		IF @StudentIID = 0 SET @StudentIID  = NULL
		--IF @ClubId = 0 SET @ClubId  = NULL
	
		

	
	SELECT        
		sb.StudentIID, sb.StudentInsID, sb.FullName,  s.SessionName, b.BranchName, sb.SMSNotificationNo, sg.F_Mobile, sg.M_Mobile,  
        sh.ShiftName, c.ClassName,  sc.SectionName, sb.RollNo,sb.FatherName,sb.MotherName,sb.SessionId,sb.BranchID,sb.ShiftID,sb.ClassId,sb.SectionId
	FROM               
        dbo.Ins_Session s  INNER JOIN
        dbo.Student_BasicInfo sb ON s.SessionId = sb.SessionId
		 left outer JOIN dbo.Student_GuardianInfo sg on sb.StudentIID=sg.StudentIID 
		 INNER JOIN
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId  LEFT OUTER JOIN
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
		WHERE 			

			sb.SessionId = COALESCE(@SessionId,sb.SessionId) AND 
			sb.BranchID = COALESCE(@BranchID,sb.BranchID)AND
			sb.ShiftID = COALESCE(@ShiftID,sb.ShiftID)AND
			sb.ClassId = COALESCE(@ClassId,sb.ClassId)AND

			sb.SectionId = COALESCE(@SectionId,sb.SectionId) AND
			sb.StudentIID = COALESCE(@StudentIID,sb.StudentIID) 
			-- AND sb.ECAClubId = COALESCE(@ClubId,sb.ECAClubId)
			 AND sb.IsDeleted=0 And sb.Status='A'
		--ORDER BY CAST(sb.RollNo AS INT)  ASC

END


--EXEC GetStudentInfoForStaticSMS
GO




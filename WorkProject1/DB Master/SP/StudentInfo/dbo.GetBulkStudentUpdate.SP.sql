IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetBulkStudentUpdate]'))
BEGIN
DROP PROCEDURE  GetBulkStudentUpdate
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].GetBulkStudentUpdate 

	@SessionId INT = NULL,
	@BranchID INT = NULL,
	@ShiftID INT = NULL,
	@ClassId INT = NULL,
	@SectionId INT = NULL


AS
BEGIN  
		SELECT		dbo.Student_BasicInfo.StudentIID,
					dbo.Student_BasicInfo.ECAClubId,
				  dbo.Student_BasicInfo.StudentInsID,
				  dbo.Student_BasicInfo.RollNo,
				  dbo.Student_BasicInfo.CurrentStudentId,
				  dbo.Student_BasicInfo.FullName,
				  dbo.Student_BasicInfo.Nationality, 
				  dbo.Student_BasicInfo.Religion, 
                  dbo.Student_BasicInfo.BloodGroup,
				  dbo.Student_BasicInfo.Quota,
				   dbo.Student_BasicInfo.Gender,
	              dbo.Student_GuardianInfo.F_Qualification,
		          dbo.Student_GuardianInfo.F_Profession, 
                  dbo.Student_GuardianInfo.M_Qualification,
				  dbo.Student_GuardianInfo.M_Profession,
				  dbo.Student_GuardianInfo.LG_Relation,
				  dbo.Student_GuardianInfo.E_Relation,
				  dbo.Student_ContactInfo.Pre_PSId,
				  dbo.Student_ContactInfo.Pre_DisId, 
                  dbo.Student_ContactInfo.Pre_PostOffice,
				  dbo.Student_ContactInfo.Par_PSId,
				  dbo.Student_ContactInfo.Par_DisId,
			     dbo.Student_ContactInfo.Par_PostOffice
FROM            dbo.Student_BasicInfo 
			LEFT OUTER JOIN dbo.Student_GuardianInfo ON dbo.Student_BasicInfo.StudentIID = dbo.Student_GuardianInfo.StudentIID 
			LEFT OUTER JOIN  dbo.Student_ContactInfo ON dbo.Student_BasicInfo.StudentIID = dbo.Student_ContactInfo.StudentIID
		WHERE 
		 Student_BasicInfo.SessionId = @SessionId
		AND Student_BasicInfo.BranchID = @BranchID
		AND Student_BasicInfo.ShiftID = @ShiftID
		AND Student_BasicInfo.ClassId = @ClassId
		
		AND Student_BasicInfo.SectionId = @SectionId

		AND Student_BasicInfo.Status  = 'A'
		ORDER BY CAST (Student_BasicInfo.rollno AS INT)
END

-- GetBulkStudentUpdate 11,9,5,27,109
/****** Object:  StoredProcedure [dbo].[GetStudentInfo]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentAdmitCard]'))
BEGIN
DROP PROCEDURE  GetStudentAdmitCard
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--GetStudentAdmitCard 11,1,1,1,1,1,0,7
CREATE PROCEDURE [dbo].[GetStudentAdmitCard] -- Total 11 param
	@ExamID INT,
	@VersionId INT ,
	@SessionId INT ,
	@BranchID INT ,
	@ShiftID INT ,
	@ClassId INT ,
	@GroupId INT ,
	@SectionId INT ,
	@StuIds VARCHAR(1000)
	
	
AS
BEGIN


	
	SELECT    
		 SB.StudentIID,SB.StudentInsID,
		 s.SessionName, v.VersionName, b.BranchName, sh.ShiftName, c.ClassName,g.GroupName, sc.SectionName,
		sb.RollNo,SB.AdmissionDate , sb.FullName,SB.SMSNotificationNo, SB.Gender,SB.Religion,SB.BloodGroup , SB.Nationality,SB.DateOfBirth , SB.TransportFacility,SB.Height,SB.[Weight],SB.Quota,
		SB.FatherName,SB.MotherName,
		(Select Top(1) Si.Picture From Ins_Signature Si Inner Join Ins_AdmitCardSetup A On A.SignatureID_1=Si.ID  where Si.Type=1 and A.ID=@ExamID) as Signature_1
		,(Select Top(1) Si.PersonName From Ins_Signature Si Inner Join Ins_AdmitCardSetup A On A.SignatureID_1=Si.ID  where Si.Type=1 and A.ID=@ExamID ) as SignatureName_1
		,(Select Top(1) Si.Designation From Ins_Signature Si Inner Join Ins_AdmitCardSetup A On A.SignatureID_1=Si.ID  where Si.Type=1 and A.ID=@ExamID ) as SignatureDesignation_1

		,(Select Top(1) Si.Picture From Ins_Signature Si Inner Join Ins_AdmitCardSetup A On A.SignatureID_2=Si.ID  where Si.Type=2 and A.ID=@ExamID) as Signature_2
		,(Select Top(1) Si.PersonName From Ins_Signature Si Inner Join Ins_AdmitCardSetup A On A.SignatureID_2=Si.ID  where Si.Type=2 and A.ID=@ExamID) as SignatureName_2
		,(Select Top(1) Si.Designation From Ins_Signature Si Inner Join Ins_AdmitCardSetup A On A.SignatureID_2=Si.ID  where Si.Type=2and A.ID=@ExamID ) as SignatureDesignation_2
		

		,(Select Top(1) Si.Picture From Ins_Signature Si Inner Join Ins_AdmitCardSetup A On A.SignatureID_3=Si.ID  where Si.Type=3 and A.ID=@ExamID) as Signature_3
		,(Select Top(1) Si.PersonName From Ins_Signature Si Inner Join Ins_AdmitCardSetup A On A.SignatureID_3=Si.ID  where Si.Type=3 and A.ID=@ExamID) as SignatureName_3
		,(Select Top(1) Si.Designation From Ins_Signature Si Inner Join Ins_AdmitCardSetup A On A.SignatureID_3=Si.ID  where Si.Type=3 and A.ID=@ExamID) as SignatureDesignation_3
		
		,ADS.Title,ADS.TemplateID,ADS.WatermarkImage,ADS.RoutineImage,ADS.IssueDate,SImg.Photo
		
          
	FROM               
        dbo.Ins_Version v 
		INNER JOIN dbo.Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  dbo.Ins_Branch b ON sb.BranchID = b.BranchId 
		INNER JOIN dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId 
		INNER JOIN dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId 
		INNER JOIN  dbo.Ins_Group g ON sb.GroupId = g.GroupId
		INNER JOIN dbo.Ins_Section sc ON sc.SectionId = sb.SectionId 

		LEFT OUTER JOIN dbo.Ins_StudentType STY ON STY.StudentTypeId = SB.StudentTypeID
		
		LEFT OUTER JOIN dbo.Student_GuardianInfo GU ON GU.StudentIID= SB.StudentIID 
		LEFT OUTER JOIN dbo.Student_ContactInfo SCO ON SCO.StudentIID = SB.StudentIID
		INNER JOIN Ins_AdmitCardSetup ADS ON v.VersionId = ADS.VersionID AND sb.SessionId = ADS.SessionId AND sb.BranchID = ADS.BranchId AND sb.ShiftID = ADS.ShiftId AND sb.ClassId = ADS.ClassId 
		LEFT OUTER JOIN Student_Image SImg ON SImg.StudentIID = SB.StudentIID 
	

		WHERE 
			sb.[Status] = 'A' AND
			
			sb.VersionID = @VersionId AND 
			sb.SessionId = @SessionId AND 
			sb.BranchID = @BranchID AND
			sb.ShiftID = @ShiftID AND
			sb.ClassId = @ClassId AND
			sb.GroupId = @GroupId AND
			sb.SectionId = @SectionId  AND
			ADS.ID=@ExamID
			And SB.StudentIID IN (SELECT * FROM [dbo].StringSplit(@StuIds,','))
		ORDER BY CAST(sb.RollNo AS INT)  ASC
		

END



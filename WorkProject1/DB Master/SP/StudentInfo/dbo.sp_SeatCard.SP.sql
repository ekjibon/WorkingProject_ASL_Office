/****** Object:  StoredProcedure [dbo].[GetStudentInfo]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sp_SeatCard]'))
BEGIN 
DROP PROCEDURE  sp_SeatCard 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_AdmitCard 1,6,3,39,NULL
--sp_AdmitCard null,null,null,null,null
CREATE PROCEDURE [dbo].[sp_SeatCard] -- Total 11 param
	@Block INT,
	@SessionId INT=null ,
	@BranchID INT =null ,
	@ShiftID INT  =null  ,
	@ClassId INT  =null,
	@StuIds VARCHAR(1000) =null

AS

BEGIN
if(@Block =1)
BEGIN
	SELECT    
	SC.ID,SC.BranchID,SC.SessionID,SC.ClassID,SC.ShiftID,
		 s.SessionName, b.BranchName, sh.ShiftName, c.ClassName,SC.SignatureID_1,
		 SC.SignatureID_2,SC.SignatureID_3,SC.SignatureID_4,SC.Title,sc.WatermarkImage ,sc.TemplateId,
			 (select Top(1) 
		 (case when SC.SignatureID_1=1 then se.SignatureImg1 
		
		   END) from dbo.Ins_Signature se  where se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID) As SignatureImage1,

		 (select Top(1) 
		 (case when SC.SignatureID_1=1 then se.Designation1 
	
		   END) from dbo.Ins_Signature se where  se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureDesignation_1,
		   
		 (select Top(1) (case when SC.SignatureID_1=1 then se.PersonName1 
		   END) from dbo.Ins_Signature se where  se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As PersonName1,

		   (select Top(1) 
		 (case when SC.SignatureID_2=1 then se.SignatureImg2 
		   END) from dbo.Ins_Signature se where se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureImage2,

		 (select Top(1) (case when SC.SignatureID_1=1 then se.Designation2 
		   END) from dbo.Ins_Signature se where  se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureDesignation_2,
		   
		 (select Top(1) (case when SC.SignatureID_2=1 then se.PersonName2 
		   END) from dbo.Ins_Signature se where se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As PersonName2,

		     (select Top(1) 
		 (case when SC.SignatureID_3=1 then se.SignatureImg3 
		   END) from dbo.Ins_Signature se where se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureImage3,

		 (select Top(1) (case when SC.SignatureID_3=1 then se.Designation3 
		   END) from dbo.Ins_Signature se where se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureDesignation_3,
		   
		 (select Top(1) (case when SC.SignatureID_3=1 then se.PersonName3 
		   END) from dbo.Ins_Signature se where se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As PersonName3,

		  (select Top(1) 
		 (case when SC.SignatureID_4=1 then se.SignatureImg4 
		   END) from dbo.Ins_Signature se where se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureImage4,

		 (select Top(1) (case when SC.SignatureID_4=1 then se.Designation4 
		   END) from dbo.Ins_Signature se where  se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureDesignation_4,
		   
		 (select Top(1) (case when SC.SignatureID_4=1 then se.PersonName4 
		   END) from dbo.Ins_Signature se where se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As PersonName4
	FROM               
        dbo.Ins_Session s
		INNER JOIN Ins_SeatCardSetup SC  ON SC.SessionId = s.SessionId 
		INNER JOIN  dbo.Ins_Branch b ON SC.BranchID = b.BranchId 
		INNER JOIN dbo.Ins_Shift sh ON SC.ShiftID = sh.ShiftId 
		INNER JOIN dbo.Ins_ClassInfo c ON SC.ClassId = c.ClassId 
			where  SC.SessionID=ISNULL( @SessionId,SC.SessionID) And SC.ShiftID=ISNULL( @ShiftID,SC.ShiftID)
		 AND SC.ClassID=ISNULL( @ClassId,SC.ClassID)
END

if(@Block =2)
BEGIN
	SELECT    
		 SB.StudentIID,SB.StudentInsID,
		 s.SessionName, v.VersionName, b.BranchName, sh.ShiftName, c.ClassName, 
		 sc.SectionName,
		sb.RollNo,SB.AdmissionDate , sb.FullName,SB.SMSNotificationNo, SB.Gender,
		SB.Religion,SB.BloodGroup , SB.Nationality,SB.DateOfBirth , SB.TransportFacility,SB.Height,SB.[Weight],SB.Quota,
		SB.FatherName,SB.MotherName,SImg.Photo,sb.BloodGroup
	FROM               
        dbo.Ins_Version v 
		INNER JOIN dbo.Student_BasicInfo SB ON SB.StudentIID IN (SELECT * FROM [dbo].StringSplit(@StuIds,',')) 
		INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  dbo.Ins_Branch b ON sb.BranchID = b.BranchId 
		INNER JOIN dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId 
		INNER JOIN dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId 
		INNER JOIN dbo.Ins_Section sc ON sc.SectionId = sb.SectionId 
		LEFT OUTER JOIN dbo.Ins_StudentType STY ON STY.StudentTypeId = SB.StudentTypeID
		LEFT OUTER JOIN dbo.Student_GuardianInfo GU ON GU.StudentIID= SB.StudentIID 
		LEFT OUTER JOIN dbo.Student_ContactInfo SCO ON SCO.StudentIID = SB.StudentIID
		LEFT OUTER JOIN Student_Image SImg ON SImg.StudentIID = SB.StudentIID 
		WHERE 
			sb.[Status] = 'A'
		ORDER BY CAST(sb.RollNo AS INT)  ASC
END


END

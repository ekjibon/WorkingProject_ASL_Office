/****** Object:  StoredProcedure [dbo].[GetStudentInfo]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAdmitCardSetupInfo]'))
BEGIN
DROP PROCEDURE  GetAdmitCardSetupInfo 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--GetAdmitCardSetupInfo 1,6,3,39,NULL
--GetAdmitCardSetupInfo null,null,null,null,null
CREATE PROCEDURE [dbo].[GetAdmitCardSetupInfo] -- Total 11 param
	@VersionId INT=null ,
	@SessionId INT=null ,
	@BranchID INT =null ,
	@ShiftID INT  =null  ,
	@ClassId INT  =null
	

AS
BEGIN
	SELECT    
	SC.ID,SC.BranchID,SC.VersionID, SC.SessionID,SC.ClassID,SC.ShiftID,
		 s.SessionName, v.VersionName, b.BranchName, sh.ShiftName, c.ClassName ,SC.SignatureID_1,
		 SC.SignatureID_2, SC.SignatureID_3,
		 (select Top(1) 
		 (case when SC.SignatureID_1=1 then se.SignatureImg1 
		
		   END) from dbo.Ins_Signature se  where se.VersionID = SC.VersionID  And se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID) As SignatureImage1,

		 (select Top(1) 
		 (case when SC.SignatureID_1=1 then se.Designation1 
	
		   END) from dbo.Ins_Signature se where se.VersionID = SC.VersionID  And se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureDesignation_1,
		   
		 (select Top(1) (case when SC.SignatureID_1=1 then se.PersonName1 
		   END) from dbo.Ins_Signature se where se.VersionID = SC.VersionID  And se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As PersonName1,

		   (select Top(1) 
		 (case when SC.SignatureID_2=1 then se.SignatureImg2 
		   END) from dbo.Ins_Signature se where se.VersionID = SC.VersionID  And se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureImage2,

		 (select Top(1) (case when SC.SignatureID_1=1 then se.Designation2 
		   END) from dbo.Ins_Signature se where se.VersionID = SC.VersionID  And se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureDesignation_2,
		   
		 (select Top(1) (case when SC.SignatureID_2=1 then se.PersonName2 
		   END) from dbo.Ins_Signature se where se.VersionID = SC.VersionID  And se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As PersonName2,

		     (select Top(1) 
		 (case when SC.SignatureID_3=1 then se.SignatureImg3 
		   END) from dbo.Ins_Signature se where se.VersionID = SC.VersionID  And se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureImage3,

		 (select Top(1) (case when SC.SignatureID_3=1 then se.Designation3 
		   END) from dbo.Ins_Signature se where se.VersionID = SC.VersionID  And se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureDesignation_3,
		   
		 (select Top(1) (case when SC.SignatureID_3=1 then se.PersonName3 
		   END) from dbo.Ins_Signature se where se.VersionID = SC.VersionID  And se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As PersonName3,

		SC.Title, SC.IssueDate
	FROM               
        dbo.Ins_Version v 
		INNER JOIN Ins_AdmitCardSetup SC ON v.VersionId = SC.VersionID 
		INNER JOIN dbo.Ins_Session s ON SC.SessionId = s.SessionId 
		INNER JOIN  dbo.Ins_Branch b ON SC.BranchID = b.BranchId 
		INNER JOIN dbo.Ins_Shift sh ON SC.ShiftID = sh.ShiftId 
		INNER JOIN dbo.Ins_ClassInfo c ON SC.ClassId = c.ClassId 
		where SC.VersionID =ISNULL( @VersionId,SC.VersionID) and SC.SessionID=ISNULL( @SessionId,SC.SessionID) And SC.ShiftID=ISNULL( @ShiftID,SC.ShiftID)
		 AND SC.ClassID=ISNULL( @ClassId,SC.ClassID)
END

--select * from dbo.Ins_AdmitCardSetup
--select * from dbo.Ins_Signature se where Se.VersionID=1  and se.BranchID=6 and se.ShiftID=22 and se.ClassID=2

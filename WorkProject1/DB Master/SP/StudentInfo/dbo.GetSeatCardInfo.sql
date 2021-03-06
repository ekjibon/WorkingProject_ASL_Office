/****** Object:  StoredProcedure [dbo].[GetStudentInfo]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSeatCardInfo]'))
BEGIN
DROP PROCEDURE  GetSeatCardInfo 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--GetSeatCardSetupInfo 1,1,2,1,1
CREATE PROCEDURE [dbo].[GetSeatCardInfo] -- Total 11 param
	

	@SessionId INT =NULL,
	@BranchID INT =NULL,
	@ShiftID INT =NULL,
	@ClassId INT =NULL,
	@Block INT = 0
	
AS
BEGIN
 IF(@Block=1) 
 BEGIN
	SELECT    
	SC.ID,SC.BranchID,SC.SessionID,SC.ClassID,SC.ShiftID,
		 s.SessionName,  b.BranchName, sh.ShiftName, c.ClassName,SC.SignatureID_1,
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
		   END) from dbo.Ins_Signature se where se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As PersonName1,

		   (select Top(1) 
		 (case when SC.SignatureID_2=1 then se.SignatureImg2 
		   END) from dbo.Ins_Signature se where  se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureImage2,

		 (select Top(1) (case when SC.SignatureID_1=1 then se.Designation2 
		   END) from dbo.Ins_Signature se where se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureDesignation_2,
		   
		 (select Top(1) (case when SC.SignatureID_2=1 then se.PersonName2 
		   END) from dbo.Ins_Signature se where se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As PersonName2,

		     (select Top(1) 
		 (case when SC.SignatureID_3=1 then se.SignatureImg3 
		   END) from dbo.Ins_Signature se where  se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureImage3,

		 (select Top(1) (case when SC.SignatureID_3=1 then se.Designation3 
		   END) from dbo.Ins_Signature se where se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureDesignation_3,
		   
		 (select Top(1) (case when SC.SignatureID_3=1 then se.PersonName3 
		   END) from dbo.Ins_Signature se where se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As PersonName3,

		  (select Top(1) 
		 (case when SC.SignatureID_4=1 then se.SignatureImg4 
		   END) from dbo.Ins_Signature se where  se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureImage4,

		 (select Top(1) (case when SC.SignatureID_4=1 then se.Designation4 
		   END) from dbo.Ins_Signature se where se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As SignatureDesignation_4,
		   
		 (select Top(1) (case when SC.SignatureID_4=1 then se.PersonName4 
		   END) from dbo.Ins_Signature se where  se.ShiftID=SC.ShiftID
		 AND se.ClassID=SC.ClassID ) As PersonName4
	FROM               
         dbo.Ins_Session s
		INNER JOIN Ins_SeatCardSetup SC ON SC.SessionId = s.SessionId
		
		INNER JOIN  dbo.Ins_Branch b ON SC.BranchID = b.BranchId 
		INNER JOIN dbo.Ins_Shift sh ON SC.ShiftID = sh.ShiftId 
		INNER JOIN dbo.Ins_ClassInfo c ON SC.ClassId = c.ClassId 
			where  SC.SessionID=ISNULL( @SessionId,SC.SessionID) And SC.ShiftID=ISNULL( @ShiftID,SC.ShiftID)
		 AND SC.ClassID=ISNULL( @ClassId,SC.ClassID)
END
END

--select*from dbo.Ins_SeatCardSetup
--select * from dbo.Ins_Signature se where Se.VersionID=1  and se.BranchID=6 and se.ShiftID=22 and se.ClassID=2

--GetSeatCardInfo 10,1,1002,20,1



/****** Object:  StoredProcedure [dbo].[GetStudentInfo]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentInfo]'))
BEGIN
DROP PROCEDURE  GetStudentInfo
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--   GetStudentInfo 1,6,31,22,2,0,1,null
CREATE PROCEDURE [dbo].[GetStudentInfo] -- Total 11 param 

	@SessionId INT ,
	@BranchID INT ,
	@ShiftID INT ,
	@ClassId INT ,

	@SectionId INT ,
	@StudentType INT 
AS
BEGIN
	SELECT    
		 SB.StudentIID,SB.StudentInsID,SB.CurrentStudentId,
		 s.SessionName, b.BranchName, sh.ShiftName, c.ClassName, sc.SectionName, STY.StudentTypeName, SHO.HouseName,
		sb.RollNo,SB.AdmissionDate , sb.FullName,SB.SMSNotificationNo, SB.Gender,SB.Religion,SB.BloodGroup , SB.Nationality,SB.DateOfBirth , SB.TransportFacility,SB.Height,SB.[Weight],SB.Quota,
		SB.FatherName,SB.MotherName, GU.*,
		SCO.Pre_Address , SCO.Pre_PostOffice,SCO.Pre_PostalCode,PREP.PsName  AS Pre_PsName , PREP.DistrictName AS Pre_DistrictName,
		SCO.Par_Address , SCO.Par_PostOffice,SCO.Par_PostalCode,PARP.PsName AS Par_PsName , PARP.DistrictName AS Par_DistrictName
	FROM               
        dbo.Student_BasicInfo SB 
		INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  dbo.Ins_Branch b ON sb.BranchID = b.BranchId 
		INNER JOIN dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId 
		INNER JOIN dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId 
		INNER JOIN dbo.Ins_Section sc ON sc.SectionId = sb.SectionId 
		LEFT OUTER JOIN dbo.Ins_StudentType STY ON STY.StudentTypeId = SB.StudentTypeID
		LEFT OUTER JOIN dbo.Ins_House SHO ON SHO.HouseId= SB.HouseID
		LEFT OUTER JOIN dbo.Student_GuardianInfo GU ON GU.StudentIID= SB.StudentIID 
		LEFT OUTER JOIN dbo.Student_ContactInfo SCO ON SCO.StudentIID = SB.StudentIID
		LEFT OUTER JOIN dbo.vwPS_District PREP ON PREP.PsId = SCO.Pre_PSId
		LEFT OUTER JOIN dbo.vwPS_District PARP ON PARP.PsId = SCO.Par_PSId

		WHERE 
			sb.[Status] = 'A' AND
			
			
			sb.SessionId = @SessionId AND 
			sb.BranchID = @BranchID AND
			sb.ShiftID = @ShiftID AND
			sb.ClassId = @ClassId AND
		
			sb.SectionId = @SectionId 
			--AND
			--sb.StudentTypeID = @StudentType AND
			--sb.HouseId = @HouseId

		ORDER BY sb.RollNo

END


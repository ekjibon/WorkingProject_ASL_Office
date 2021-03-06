/****** Object:  StoredProcedure [dbo].[GetStudentInfo]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sp_AdmitCard]'))
BEGIN 
DROP PROCEDURE  sp_AdmitCard 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_AdmitCard null,null,null,null,null
--sp_AdmitCard null,null,null,null,null
CREATE PROCEDURE [dbo].[sp_AdmitCard] -- Total 11 param
	@Block INT,
	@SessionId INT=null ,
	@BranchID INT =null ,
	@ShiftID INT  =null  ,
	@ClassId INT  =null,
	@SectionId INT  =null,
	@StuIds VARCHAR(1000) =null
AS
BEGIN
if(@Block =1)
BEGIN
	SELECT    Distinct
	ADS.ID,ADS.BranchID, ADS.SessionID,ADS.ClassID,ADS.ShiftID,
		 s.SessionName, b.BranchName, sh.ShiftName, c.ClassName ,
		 ADS.Title, ADS.TemplateId, ADS.IssueDate,ADS.WatermarkImage,ADS.RoutineImage, ADS.SignatureID_1,
		 ADS.SignatureID_2, ADS.SignatureID_3, ADS.SignatureID_4,
		
		 (select Top(1) 
		 (case when ADS.SignatureID_1=1 then se.SignatureImg1 
		   END) from dbo.Ins_Signature se  where se.ShiftID=ADS.ShiftID
		 AND se.ClassID=ADS.ClassID) As SignatureImage1,

		 (select Top(1) 
		 (case when ADS.SignatureID_1=1 then se.Designation1 
		   END) from dbo.Ins_Signature se where se.ShiftID=ADS.ShiftID
		 AND se.ClassID=ADS.ClassID ) As SignatureDesignation_1,
		   
		 (select Top(1) (case when ADS.SignatureID_1=1 then se.PersonName1 
		   END) from dbo.Ins_Signature se where se.ShiftID=ADS.ShiftID
		 AND se.ClassID=ADS.ClassID ) As PersonName1,

		   (select Top(1) 
		 (case when ADS.SignatureID_2=1 then se.SignatureImg2 
		   END) from dbo.Ins_Signature se where se.ShiftID=ADS.ShiftID
		 AND se.ClassID=ADS.ClassID ) As SignatureImage2,

		 (select Top(1) (case when ADS.SignatureID_1=1 then se.Designation2 
		   END) from dbo.Ins_Signature se where  se.ShiftID=ADS.ShiftID
		 AND se.ClassID=ADS.ClassID ) As SignatureDesignation_2,
		   
		 (select Top(1) (case when ADS.SignatureID_2=1 then se.PersonName2 
		   END) from dbo.Ins_Signature se where se.ShiftID=ADS.ShiftID
		 AND se.ClassID=ADS.ClassID ) As PersonName2,

		     (select Top(1) 
		 (case when ADS.SignatureID_3=1 then se.SignatureImg3 
		   END) from dbo.Ins_Signature se where se.ShiftID=ADS.ShiftID
		 AND se.ClassID=ADS.ClassID ) As SignatureImage3,

		 (select Top(1) (case when ADS.SignatureID_3=1 then se.Designation3 
		   END) from dbo.Ins_Signature se where se.ShiftID=ADS.ShiftID
		 AND se.ClassID=ADS.ClassID ) As SignatureDesignation_3,
		   
		 (select Top(1) (case when ADS.SignatureID_3=1 then se.PersonName3 
		   END) from dbo.Ins_Signature se where  se.ShiftID=ADS.ShiftID
		 AND se.ClassID=ADS.ClassID ) As PersonName3,

		   (select Top(1) 
		 (case when ADS.SignatureID_4=1 then se.SignatureImg4 
		   END) from dbo.Ins_Signature se where se.ShiftID=ADS.ShiftID
		 AND se.ClassID=ADS.ClassID ) As SignatureImage4,

		 (select Top(1) (case when ADS.SignatureID_4=1 then se.Designation4 
		   END) from dbo.Ins_Signature se where se.ShiftID=ADS.ShiftID
		 AND se.ClassID=ADS.ClassID ) As SignatureDesignation_4,
		   
		 (select Top(1) (case when ADS.SignatureID_4=1 then se.PersonName4 
		   END) from dbo.Ins_Signature se where se.ShiftID=ADS.ShiftID
		 AND se.ClassID=ADS.ClassID ) As PersonName4
	FROM               
       dbo.Ins_Session s
		   INNER JOIN Ins_AdmitCardSetup ADS ON ADS.SessionId = s.SessionId
		 INNER JOIN  dbo.Ins_Branch b ON ADS.BranchID = b.BranchId 
		INNER JOIN dbo.Ins_Shift sh ON ADS.ShiftID = sh.ShiftId 
		INNER JOIN dbo.Ins_ClassInfo c ON ADS.ClassId = c.ClassId 
		where  ADS.SessionID=ISNULL( @SessionId,ADS.SessionID) And ADS.ShiftID=ISNULL( @ShiftID,ADS.ShiftID)
		 AND ADS.ClassID=ISNULL( @ClassId,ADS.ClassID)
END
if(@Block =2)
BEGIN-- sp_AdmitCard 2,null,null,null,null,null,null,',5,6,9,10,12,13,25,31,32,33,60,93,94,105,211,212,213,214,215,216,217,221,258,319,336,360'
	SELECT    
		 SB.StudentIID,SB.StudentInsID,SB.AdmissionDate , sb.FullName,SB.SMSNotificationNo, SB.Gender,SB.Religion,SB.BloodGroup , 
		 SB.Nationality,SB.DateOfBirth , SB.TransportFacility,SB.Height,SB.[Weight],SB.Quota,sb.RollNo,
		SB.FatherName,SB.MotherName,SB.ClassId,SB.SectionId,SB.SessionId,SB.ShiftID,SB.BranchID,
		s.SessionName,
		 b.BranchName,
		sh.ShiftName,
		c.ClassName,
	sc.SectionName
		,SImg.Photo
	FROM               
       dbo.Ins_Session s
		LEFT OUTER JOIN dbo.Student_BasicInfo SB ON sb.SessionId = s.SessionId  
		LEFT OUTER JOIN  dbo.Ins_Branch b ON sb.BranchID = b.BranchId 
		LEFT OUTER JOIN dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId 
		LEFT OUTER JOIN dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId 
		LEFT OUTER JOIN dbo.Ins_Section sc ON sc.SectionId = sb.SectionId 
		--LEFT OUTER JOIN dbo.Ins_StudentType STY ON STY.StudentTypeId = SB.StudentTypeID
		--LEFT OUTER JOIN dbo.Student_GuardianInfo GU ON GU.StudentIID= SB.StudentIID 
		--LEFT OUTER JOIN dbo.Student_ContactInfo SCO ON SCO.StudentIID = SB.StudentIID
		LEFT OUTER JOIN Student_Image SImg ON SImg.StudentIID = SB.StudentIID 
		WHERE 
			sb.[Status] = 'A' and sb.StudentIID in  (SELECT * FROM STRING_SPLIT(@StuIds,','))
		ORDER BY CAST(sb.RollNo AS INT)  ASC
END
if(@Block =3)
BEGIN  --   sp_AdmitCard 3,1,6,31,22,2,1,null
select distinct sb.*,'P' AS [Check]  from dbo.Student_BasicInfo sb
LEFT OUTER JOIN dbo.Fees_Student fc on fc.StudentIID=sb.StudentIID and fc.SessionId=sb.SessionId 
where sb.Status='A' and sb.IsDeleted=0 and  fc.IsCompleted=1 
and sb.SessionID=ISNULL( @SessionId,sb.SessionID) And sb.ShiftID=ISNULL( @ShiftID,sb.ShiftID)
AND sb.ClassID=ISNULL( @ClassId,sb.ClassID) AND sb.SectionId=ISNULL( @SectionId,sb.SectionId) AND sb.StudentIID=ISNULL(@StuIds,sb.StudentIID)
and (EXISTS (select * from Fees_Student fstd where StudentIID=sb.StudentIID and SessionId=sb.SessionId) and 
(select count(fstd.FeesStudentId) from Fees_Student fstd where StudentIID=sb.StudentIID and SessionId=sb.SessionId and IsCompleted=0)>0)
order by sb.RollNo
END
if(@Block =4)
BEGIN  -- sp_AdmitCard 4,1,6,31,22,2,1,null
select distinct sb.*,'UP' AS [Check] from dbo.Student_BasicInfo sb
LEFT OUTER JOIN dbo.Fees_Student fc on fc.StudentIID=sb.StudentIID and fc.SessionId=sb.SessionId 
--(select count(fstd.FeesStudentId) from Fees_Student fstd where StudentIID=sb.StudentIID and SessionId=sb.SessionId and IsCompleted=0)>0
where  sb.[Status]='A' and sb.IsDeleted=0
and sb.SessionID=ISNULL( @SessionId,sb.SessionID) And sb.ShiftID=ISNULL( @ShiftID,sb.ShiftID)
AND sb.ClassID=ISNULL( @ClassId,sb.ClassID) AND sb.SectionId=ISNULL( @SectionId,sb.SectionId) AND sb.StudentIID=ISNULL(@StuIds,sb.StudentIID)
and (NOT EXISTS (select * from Fees_Student fstd where StudentIID=sb.StudentIID and SessionId=sb.SessionId) or
(select count(fstd.FeesStudentId) from Fees_Student fstd where fstd.StudentIID=sb.StudentIID  and fstd.SessionId=sb.SessionId and fstd.IsDeleted=0 and fstd.IsCompleted=0)>0)
order by sb.RollNo
END
if(@Block =5)
BEGIN  -- sp_AdmitCard 5,1,6,31,22,2,1,null
SELECT 
  DISTINCT sb.*,
  CASE WHEN EXISTS (select * from Fees_Student fstd where StudentIID=sb.StudentIID and SessionId=sb.SessionId)
       THEN (case when 
(select count(fstd.FeesStudentId) from Fees_Student fstd where StudentIID=sb.StudentIID and SessionId=sb.SessionId)=
(select count(fstd.FeesStudentId) from Fees_Student fstd where StudentIID=sb.StudentIID and SessionId=sb.SessionId and IsCompleted=1 ) then 'P'
 else 'UP' END) 
       ELSE 'UP'
  END AS [Check]  
FROM dbo.Student_BasicInfo sb
LEFT OUTER JOIN dbo.Fees_Student fc on fc.StudentIID=sb.StudentIID and fc.SessionId=sb.SessionId 
where sb.Status='A' and sb.IsDeleted=0
and sb.SessionID=ISNULL( @SessionId,sb.SessionID) And sb.ShiftID=ISNULL( @ShiftID,sb.ShiftID)
AND sb.ClassID=ISNULL( @ClassId,sb.ClassID) AND sb.SectionId=ISNULL( @SectionId,sb.SectionId) AND sb.StudentIID=ISNULL(@StuIds,sb.StudentIID)
order by sb.RollNo
END
END


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentIDCard]'))
BEGIN
DROP PROCEDURE  [GetStudentIDCard]
END
GO
/****** Object:  StoredProcedure [dbo].[GetStudentIDCard]    Script Date: 3/10/2019 4:25:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM [dbo].StringSplit('3658,4284,4285,3659,3660,4286,4287',',')
--GetStudentIDCard 10,8,4,19,78,null
CREATE PROCEDURE [dbo].[GetStudentIDCard] -- Total 11 param
	@SessionId INT =NULL ,
	@BranchID INT=NULL ,
	@ShiftID INT=NULL ,
	@ClassId INT=NULL ,
	@SectionId INT =NULL,
	@StuIds VARCHAR(max)
	
AS
BEGIN
SELECT value  INTO #StuId
FROM STRING_SPLIT(@StuIds, ',') 

	
	SELECT    
		 SB.StudentIID,SB.StudentInsID,
		 s.SessionName, b.BranchName, sh.ShiftName, c.ClassName,sc.SectionName,
		sb.RollNo,SB.AdmissionDate , sb.FullName,SB.SMSNotificationNo, SB.Gender,SB.Religion,SB.BloodGroup , SB.Nationality,SB.DateOfBirth , SB.TransportFacility,SB.Height,SB.[Weight],SB.Quota,
		SB.FatherName,SB.MotherName,SImg.Photo,Sig.SignatureImg1,Sig.SignatureImg2,Sig.SignatureImg3
		
          
	FROM               
        dbo.Ins_Session s
		INNER JOIN dbo.Student_BasicInfo SB ON s.SessionId  = sb.SessionId 

		INNER JOIN  dbo.Ins_Branch b ON sb.BranchID = b.BranchId 
		INNER JOIN dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId 
		INNER JOIN dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId 
		INNER JOIN dbo.Ins_Section sc ON sc.SectionId = sb.SectionId 

		LEFT OUTER JOIN dbo.Ins_StudentType STY ON STY.StudentTypeId = SB.StudentTypeID
		
		LEFT OUTER JOIN dbo.Student_GuardianInfo GU ON GU.StudentIID= SB.StudentIID 
		LEFT OUTER JOIN dbo.Student_ContactInfo SCO ON SCO.StudentIID = SB.StudentIID
		LEFT OUTER JOIN Student_Image SImg ON SImg.StudentIID = SB.StudentIID 
		LEFT OUTER JOIN Ins_Signature Sig ON Sig.BranchID=SB.BranchID AND Sig.ClassID = SB.ClassId AND Sig.ShiftID = SB.ShiftID

		WHERE 
			sb.[Status] = 'A' AND
			
			 sb.SessionID=ISNULL( @SessionId,sb.SessionID) And sb.ShiftID=ISNULL( @ShiftID,sb.ShiftID)
			AND sb.ClassID=ISNULL( @ClassId,sb.ClassID) AND sb.SectionId=ISNULL( @SectionId,sb.SectionId) 
			--AND sb.StudentIID=ISNULL(@StuIds,sb.StudentIID)
			
			And SB.StudentIID IN (SELECT * FROM #StuId)
			
			
		ORDER BY sb.RollNo   ASC
		

END



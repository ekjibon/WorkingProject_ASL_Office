IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetStudentSMSHistory]'))
BEGIN
DROP PROCEDURE  rptGetStudentSMSHistory
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[rptGetStudentSMSHistory] '4/9/2019 12:00:00 AM','4/9/2019 12:00:00 AM',1,1
Create PROCEDURE [dbo].[rptGetStudentSMSHistory] -- Total 7 param
(

	@startDate date = null,
	@EndDate date = null,
	@smsTypeId int = null,
	@categoryId int = null,
	@SessionId INT = NULL,
	@BranchID INT = NULL,
	@ShiftID INT = NULL,
	@ClassId INT = NULL,
	--@SectionId INT = NULL,
	@StudentIID INT = NULL
	)
	
AS
BEGIN
		
		IF @SessionId = 0 SET @SessionId  = NULL
		IF @BranchID = 0 SET @BranchID  = NULL
		IF @ShiftID = 0 SET @ShiftID  = NULL
		IF @ClassId = 0 SET @ClassId  = NULL
		
		--IF @SectionId = 0 SET @SectionId  = NULL
		IF @StudentIID = 0 SET @StudentIID  = NULL
	SELECT        
			count(*) as TotalSms, sms.SendDateTime,
			
			REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE
			(REPLACE(REPLACE(REPLACE(REPLACE(sms.SMSBody,'[StudentName]',Sb.FullName),'[Roll]',Sb.RollNo),'[StudentID]',Sb.StudentInsID),'[Session]',s.SessionName)
			,'[Branch]',b.BranchName),'[Shift]',sh.ShiftName),'[Class]',c.ClassName),'[Section]',Sc.SectionName),'[StudentType]',St.StudentTypeName),'[HouseId]',h.HouseName),'[His_Her]','His/Her'),'[He_She]',' He/She')		
		AS SmsBody,
			(case when sms.SendStatus=1 then 'Success' 
			when sms.SendStatus=2 then 'Pending'
			ELSE 'Failed' END) as SendStatus, 
			 s.SessionName, b.BranchName,sms.SMSTypeId,sms.CategoryId,
        sh.ShiftName, c.ClassName, sc.SectionName, sb.SessionId,sb.BranchID,sb.ShiftID,sb.ClassId,sb.SectionId
	FROM     
	     dbo.SMS_SMSSendHistroy  sms 
		  JOIN dbo.Student_BasicInfo sb ON sb.StudentIId=sms.StudentIID  
	
		 left outer JOIN dbo.Student_GuardianInfo sg on sb.StudentIID=sg.StudentIID
		 left outer JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId
		 left outer JOIN dbo.Ins_Branch b ON sb.BranchID = b.BranchId  
		 left outer JOIN dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId 
		 left outer JOIN  dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId 
	
		 left outer JOIN dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
        left outer JOIn Ins_StudentType st on st.StudentTypeId=SB.StudentTypeID
		left outer JOIn  Ins_House h on h.HouseId=SB.HouseId
		WHERE 	
		sms.SMSTypeId = ISNULL(@smsTypeId,sms.SMSTypeId) AND
			sms.CategoryId = ISNULL(@categoryId,sms.CategoryId) AND		
		
			sb.SessionId = ISNULL(@SessionId,sb.SessionId) AND 
			sb.BranchID = ISNULL(@BranchID,sb.BranchID) AND
			sb.ShiftID = ISNULL(@ShiftID,sb.ShiftID) AND
			sb.ClassId = ISNULL(@ClassId,sb.ClassId) AND
			CONVERT(datetime, sms.SendDateTime,103)  >=   @startDate  and
			CONVERT(datetime,sms.SendDateTime,103)  <=   @EndDate  
			AND sb.IsDeleted=0 And sb.Status='A'
			and sms.SendStatus=2
			group by sb.FullName,Sb.RollNo,sb.StudentInsID, sb.SectionId,  s.SessionName, b.BranchName,sms.SMSTypeId,sms.CategoryId,
            sh.ShiftName, c.ClassName,  sc.SectionName, sb.SessionId,sb.BranchID,sb.ShiftID,sb.ClassId,
			sms.SendDateTime,sms.SMSBody,sms.SendStatus,st.StudentTypeName,h.HouseName
END
GO

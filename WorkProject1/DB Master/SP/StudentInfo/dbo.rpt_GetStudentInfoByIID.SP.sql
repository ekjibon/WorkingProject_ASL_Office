
/****** Object:  StoredProcedure [dbo].[rpt_GetStudentInfoByIID]    Script Date: 7/22/2017 4:37:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rpt_GetStudentInfoByIID]'))
BEGIN
DROP PROCEDURE  rpt_GetStudentInfoByIID
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON  --  rpt_GetStudentInfoByIID 4786
GO
CREATE PROCEDURE [dbo].[rpt_GetStudentInfoByIID] 
	@IID BIGINT
AS
BEGIN

DEClare @WorkingDays INT = 0,	@PresentDays INT= 0 ,@AbsentDays INT = 0 ,@Percentage decimal= 0.0 ,@Comments VARCHAR(100) ='' 
,@TotalMarks varchar(4) =100, @GPA varchar(5) =5  , @TotalDue DECIMAL(10,2),@InvoiceAmmount DECIMAL(10,2),@FeesBookNo VARCHAR(100),@ReceivedAmount DECIMAL(10,2)
DECLARE @FromDate Smalldatetime ,@LatePayDate Smalldatetime 

SET @FromDate = CAST('01/01/'  + CAST(DATEPART(year,GETDATE()) AS VARCHAR) AS date)

SELECT @WorkingDays = Count([day]) FROM Att_AcademicCalendar WHERE DayType = 'Regular'
 AND Year = DATEPART(year,GETDATE()) AND CalendarDate <=GETDATE()

 SELECT @FeesBookNo = fcm.MoneyReceipt  from dbo.Fees_CollectionMaster fcm 
	  INNER JOIN dbo.Fees_CollectionDetails FCD on fcd.MasterID=fcm.Id
	  INNER JOIN dbo.Fees_FeesMonth fm on fm.FeesMonthId=fcm.MonthId
	  group by FCD.MasterID,fcd.MonthId,fcd.Year,fcm.StudentIID,fm.MonthName,fcm.PaymentDate,fcm.MoneyReceipt
	  having fcm.StudentIID =@IID 

 SELECT @ReceivedAmount = sum(FCD.ReceiveAmount) from dbo.Fees_CollectionMaster fcm 
	  INNER JOIN dbo.Fees_CollectionDetails FCD on fcd.MasterID=fcm.Id
	  INNER JOIN dbo.Fees_FeesMonth fm on fm.FeesMonthId=fcm.MonthId
	  group by FCD.MasterID,fcd.MonthId,fcd.Year,fcm.StudentIID,fm.MonthName,fcm.PaymentDate,fcm.MoneyReceipt
	  having fcm.StudentIID =@IID 

 SELECT @PresentDays = COUNT([StudentId]) FROM Att_StudentAttendance 
 WHERE StudentId = @IID AND IsPresent = 1 AND InTime BETWEEN @FromDate AND GETDATE()

 SET @AbsentDays = @WorkingDays - @PresentDays
 SET @Percentage = (CAST( @PresentDays AS DECIMAL)/ CAST(NULLIF( @WorkingDays,0)  AS DECIMAL)) * CAST(100.00 AS decimal) 

 SELECT @Comments = CASE WHEN @Percentage < 40 THEN 'Bad'
						 WHEN @Percentage BETWEEN 40 AND 80 THEN 'Good'
						 WHEN @Percentage >=  80 THEN 'Excelent'
					END

SELECT @TotalDue  = SUM(FS.[DueAmount]),@InvoiceAmmount = SUM(FS.[InvoiceAmount]) FROM Fees_Student FS 
	  	WHERE FS.StudentIID =  @IID AND IsCompleted = 0 	 

		SELECT @LatePayDate = FAH.LateDate  FROM Fees_Student FS 
		 INNER JOIN [dbo].[Fees_AutomatedFeesConfig] FAH ON FAH.FeesSessionYearId = FS.FeesSessionYearId
	  	WHERE FS.StudentIID =  @IID AND IsCompleted = 0 GROUP BY FAH.LateDate


	SELECT        sb.StudentIID,
				  sb.StudentInsID,
				  sb.SessionId,
				  sb.RollNo as RollNoInt,
				  sb.RegiNo,
				  sb.FullName,
				  sb.NameBangla,
				  sb.Gender,
				  sb.BloodGroup,
				  sb.Age,
				  sb.IsPhysicalDrawback,
				  sb.PhyDrawbackDescription,
				  sb.TransportFacility,
				  sb.Height,
				  sb.[Weight],
				  sb.AdmissionDate,
				  sb.StudentTypeID,
				  st.StudentTypeName,
				  sb.FatherName,
				  sb.MotherName,
				  sb.SMSNotificationNo,
				  sb.DateOfBirth,
				  sb.Nationality,
				  sb.Religion,
				  sb.CurrentResidenceType,
				  sb.RegularMedicineInstruction,
				  sb.Quota,
				  sb.[Status] ,
				  sb.PreInsInfoClass,
				  sb.PreInsInfoName,

				  sb.PreInsInfoSection,
				  sb.PreInsInfoGroup,
				  sb.PreInsInfoSession,
				  sb.PreInsInfoVersion,
				  
				  sb.PreInsInfoRollNo,
				  sb.PreInsInfoGPAResult,
				  sb.PreInsInfoTCNo,
				  sb.PreInsInfoDate,sb.MedicalAdvice,sb.PPNumber,sb.RS_MUN,sb.BirthCertificate,sb.PPExpireDate,

				  I.Photo AS StudentPhoto,
				 
				  s.SessionName, 
				  b.BranchName, 
                  sh.ShiftName, 
				  c.ClassName, 
				 
				  sc.SectionName, 
				  CAST( sb.RollNo as int),
				  sb.StudentPositionInChildren,
				  sb.HouseID,
				  shs.HouseName,
				  ( SCO.Pre_Address + ', ' + SCO.Pre_PostOffice+ ', ' + SCO.Pre_PostalCode+ ', ' + RTRIM(prePS.PsName)+ ', ' + preDis.DistrictName) AS PresentAddress,
				  (SCO.Par_Address + ', ' + SCO.Par_PostOffice+ ', ' + SCO.Par_PostalCode+ ', ' + RTRIM(parPS.PsName)+ ', ' + parDis.DistrictName) AS PermanentAddress,
				  preClasss.ClassName as FirstAdmittedinClass,
			      sb.FirstAdmittedDate,
				  ---Parent Info
				  GI.*,
				  @TotalDue AS TotalDue,
				  CASE WHEN @TotalDue> 0 THEN 'Due' ELSE '' END  AS paymentStatus,
				  @InvoiceAmmount AS InvoiceAmmount,
				  @WorkingDays AS WorkingDays, 
				  @PresentDays AS PresentDays,
				  @AbsentDays AS AbsentDays,
				  @Percentage AS [Percentage],
				  @Comments AS Comments,
				  @TotalMarks as TotalMarks,
				  @GPA as GPA,
				  @LatePayDate AS LatePayDate,
				  @FeesBookNo AS FeesBookNo,
				  @ReceivedAmount AS ReceivedAmount
				
FROM               
                  
                  dbo.Student_BasicInfo sb 
				  INNER JOIN
                  dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
                  dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
                  dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
                  dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
                
				  dbo.Ins_Section sc ON sc.SectionId = sb.SectionId LEFT JOIN
				  dbo.Ins_StudentType st ON st.StudentTypeId = sb.StudentTypeId LEFT JOIN
				  dbo.Ins_House shs ON shs.HouseId = sb.HouseId LEFT JOIN
				  dbo.Student_GuardianInfo GI ON GI.StudentIID = sb.StudentIID  LEFT JOIN
				  dbo.Student_Image I ON I.StudentIID = sb.StudentIID 
				LEFT OUTER JOIN dbo.Student_ContactInfo SCO ON SCO.StudentIID = SB.StudentIID
				left outer join dbo.Common_District preDis ON preDis.DistrictId =  SCO.Pre_DisId
				left outer join dbo.Common_District parDis ON parDis.DistrictId = SCO.Par_DisId
				left outer join dbo.Common_PoliceStation parPS ON parPS.PsId = SCO.Par_PSId
				left outer join dbo.Common_PoliceStation prePS ON prePS.PsId = SCO.Pre_PSId
				LEFT OUTER JOIN dbo.Ins_ClassInfo preClasss   ON preClasss.ClassId = sb.ClassId
				where sb.StudentIID=@IID AND SB.IsDeleted=0
END

-- EXEC [dbo].[rpt_GetStudentInfoByIID]  23822



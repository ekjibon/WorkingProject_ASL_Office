/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetFeesCollectionByStudentId]'))
BEGIN
DROP PROCEDURE  [GetFeesCollectionByStudentId]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Biplob
-- Create date: 
-- Description:	
-- =============================================
-- EXEC  [GetFeesCollectionByStudentId] 3,null,20121105,1,2019,null,null,5,null,null,null,null,null,null

-- EXEC  [GetFeesCollectionByStudentId] 1,4398,null,4,2020,NULL,NULL,null,null,null,NULL
-- EXEC  [GetFeesCollectionByStudentId] 4,4398,null,11,2019,11,null,null,null,null,1

CREATE  PROCEDURE [dbo].[GetFeesCollectionByStudentId] 
    @BlockId INT,
   	@StudentIID BIGINT=NULL,
   	@FeesBookNo varchar(100)=NULL,
	@MonthId INT=NULL,
	@Year INT=NULL,		
	@SessionId INT=null,
	@BranchId INT=null,
	@ShiftId INT =null,
	@ClassId INT = null,
	@SectionId INT = null,	
	@headid int=null
AS
BEGIN
	IF(@BlockId=1)
	BEGIN
	IF(@StudentIID is not null)
	BEGIN
select SUM(fs.[TotalAmount]) AS [TotalAmount], 
SUM(fs.DueAmount + fs.AdvanceAmount) AS ReceiveAmount, 
SUM(fs.DueAmount) AS DueAmount,
SUM(fs.InvoiceAmount) AS InvoiceAmount,
SUM(fs.AdvanceAmount) AdvanceAmount, 
SUM(fs.DiscountAmount) DiscountAmount, 
fs.HeadId,h.HeadName
,0.0 AS DiscountAmount
,Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace((Select (
	STUFF ((
	Select DISTINCT	',' +SUBSTRING(fm.MonthName ,0,4),fm.FeesMonthId
	from dbo.Fees_Student f 
	join dbo.Fees_FeesMonth fm on fm.FeesMonthId=f.MonthId 
	and datefromparts(f.Year, f.MonthId, 1) <= EOMONTH(datefromparts(@Year, @MonthId, 1)) and f.StudentIID=@StudentIID 
	where  f.HeadId=fs.HeadId AND f.IsDeleted=0  ORDER BY  
	fm.FeesMonthId  For Xml Path (''), Type).value('.', 'Varchar(Max)'), 1, 1, '') ) AS MonthName
 ),1,''),2,'') ,3,'') ,4,'') ,5,'') ,6,'') ,7,'') ,8,'') ,9,'') ,10,'') ,11,'') ,12,''),0,'')  
 AS Narration,fs.StudentIID,fs.SessionId
from dbo.Fees_Student fs 
join dbo.Fees_Head h on fs.HeadId=h.FeesHeadId   
and datefromparts(FS.Year, FS.MonthId, 1) <= EOMONTH(datefromparts(@Year, @MonthId, 1)) and fs.StudentIID=@StudentIID and h.IsDeleted=0 and fs.IsDeleted=0
AND fs.ProcessType IN ('G','L') --AND fs.InvoiceAmount>0
group by fs.HeadId,h.HeadName,fs.StudentIID,fs.SessionId
	END
	else
	BEGIN
	select  H.HeadName,fs.[FeesStudentId]
			  ,fs.[ProcessId]
			  ,fs.[StudentIID]
			  ,fs.[HeadId]
			  ,fs.[TotalAmount]
			  ,fs.[DueAmount]
			  ,fs.InvoiceAmount
			  ,fs.[ScholarshipAmount]
			  ,fs.[DiscountAmount]
			  ,fs.[PaidAmount]
			  ,fs.[IsPaid]
			  ,fs.[IsCompleted]
			  ,fs.[MonthId]
			  ,fs.[AdvanceAmount]
			
			  ,h.CategoryId
			  ,(fs.[DueAmount] +fs.[AdvanceAmount]) AS ReceiveAmount,
			
			  FeesBookNo
			  ,SUBSTRING(fm.MonthName,0,4) AS  Narration
 from dbo.Fees_Student fs
join dbo.Fees_Head h on fs.HeadId=h.FeesHeadId and fs.MonthId <=@MonthId and fs.FeesBookNo=@FeesBookNo and h.IsDeleted=0
join dbo.Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId AND fs.ProcessType IN ('G','L')
	END
	END
	IF(@BlockId=2)
	BEGIN	
	DECLARE @YearMonthSessionID INT =0 -- AS PER MR. Mustak Requirement 
	SELECT @YearMonthSessionID = SessionId FROM Student_BasicInfo WHERE StudentIID=@StudentIID AND IsDeleted=0
	IF (@YearMonthSessionID>0)	
	BEGIN
		SELECT H.HeadName
		  ,@YearMonthSessionID AS FeesSessionYearId
	      ,0 AS [FeesStudentId]
		  ,0 AS [ProcessId]
		  ,@StudentIID AS [StudentIID]
		  ,H.FeesHeadId AS [HeadId]
		  ,0.0 AS [TotalAmount]
		  ,0.0 AS [DueAmount]
		  ,0.0 AS InvoiceAmount

		  ,0.0 AS [ScholarshipAmount]
		  ,0.0 AS [DiscountAmount]
		  ,0.0 AS[PaidAmount]
		  ,CAST(0 AS BIT) AS [IsPaid]
		  ,CAST(0 AS BIT)  AS [IsCompleted]
		  ,@MonthId AS [MonthId]
		  ,0.0 AS [AdvanceAmount]
		  ,'' AS [Narration] 
		  ,0.0 AS ReceiveAmount,
		   '' AS FeesBookNo
		  FROM Fees_Head AS H WHERE H.CategoryId=4 AND IsDeleted=0
	END
	
	END
	IF(@BlockId=3) -- EXEC  [GetFeesCollectionByStudentId] 3,null,null,12,2019,11,8,4,24,null,null
	BEGIN
			DECLARE @VAT DECIMAL=0;
			SELECT @VAT=VatPercent FROM Fees_Setting WHERE IsVat=1 AND GETDATE() BETWEEN VatStartDate AND VatEndDate AND IsDeleted=0		
			SELECT fs.StudentIID, S.StudentInsID, S.FullName, S.RollNo,
			  SUM(fs.InvoiceAmount) AS TotalAmount 
			  ,SUM(fs.InvoiceAmount)  AS ReceivedAmount	
			  ,SUM(fs.InvoiceAmount)  AS TotalInvoiceAmount	
			  ,SUM(fs.[DiscountAmount]) AS TotalDiscountAmount	
			   ,SUM(fs.[AdvanceAmount]) AS AdvanceAmount	
			  ,(SUM(fs.[DueAmount])*@VAT)/100 AS VAT
			  ,'' AS Narration
			  ,GETDATE() AS BankCollectionDate	
			  ,GETDATE() AS PaymentDate	
			  ,1 AS PaymentType	 
			  --,CASE WHEN  @FeesBookNo IS NULL THEN '' ELSE @FeesBookNo END AS FeesBookNo
			  ,CAST(1 AS BIT) AS [Collection]
			 FROM dbo.Fees_Student fs
			 INNER JOIN Student_BasicInfo AS S ON fs.StudentIID=s.StudentIID AND S.IsDeleted=0			
			 WHERE fs.[Year] <=@Year AND fs.MonthId <= @MonthId 
			  and
		   S.StudentIID=ISNULL( @StudentIID, S.StudentIID)
		 AND  S.SessionId=ISNULL(@SessionId, S.SessionId)
		 AND  S.BranchID=ISNULL(@BranchId, S.BranchID)
		 AND  S.ShiftID=ISNULL(@ShiftId, S.ShiftID)
		 AND  S.ClassId=ISNULL(@ClassId, S.ClassId)
		 AND  S.SectionId=ISNULL(@SectionId, S.SectionId)
			
			AND fs.IsDeleted=0 AND S.[Status] = 'A' AND fs.IsPaid = 0
			 GROUP BY fs.StudentIID,S.StudentInsID, S.FullName, S.RollNo
	END
	IF(@BlockId=4) --EXEC  [GetFeesCollectionByStudentId] 4,4398,null,4,2020,11,null,null,null,null,2
	BEGIN
	IF(@StudentIID is not null)
	BEGIN
	select fs.[FeesStudentId]
      ,fs.[ProcessId]
      ,fs.[StudentIID]
      ,fs.[HeadId]
      ,fs.[TotalAmount]
      ,fs.[DueAmount]
      ,fs.InvoiceAmount
      ,fs.[ScholarshipAmount]
      ,0.00 [DiscountAmount]
      ,fs.[PaidAmount]
      ,fs.[IsPaid]
      ,fs.[IsCompleted]
      ,fs.[IsDeleted]
      ,fs.[AddBy]
      ,fs.[AddDate]
      ,fs.[UpdateBy]
      ,fs.[UpdateDate]
      ,fs.[Remarks]
      ,fs.[Status]
      ,fs.[IP]
      ,fs.[MacAddress]
      ,fs.[MonthId]
      ,fs.[AdvanceAmount]
      ,fs.[Narration]
      ,fs.[FeesBookNo]
      ,fs.[SessionId]
      ,fs.[ProcessType]
      ,fs.[NoModifiedDueAmount]
      ,fs.[FeesSessionYearId]
      ,fs.[EmpId]
      ,fs.[IsVerification]
      ,fs.[AppVerificationNo]
      ,fs.[AutomatedDays]
      ,fs.[AutomatedConsecutiveDays]
      ,fs.[IsPublished]
      ,fs.[Year],fs.InvoiceAmount ReceiveAmount, h.HeadName,(fm.MonthName + ',' +CAST(FS.Year AS VARCHAR(15))) AS MonthName,h.CategoryId from dbo.Fees_Student fs 
	join dbo.Fees_Head h on h.FeesHeadId=fs.HeadId and fs.HeadId=@headid and fs.SessionId=@SessionId 
	and datefromparts(FS.Year, FS.MonthId, 1) <= EOMONTH(datefromparts(@Year, @MonthId, 1)) and fs.StudentIID=@StudentIID
	join dbo.Fees_FeesMonth fm on fs.MonthId=fm.FeesMonthId AND fs.ProcessType IN('G','L') 
	WHERE fs.IsDeleted=0 --AND fs.InvoiceAmount>0
	END
	ELSE
	BEGIN
	select fs.[FeesStudentId]
      ,fs.[ProcessId]
      ,fs.[StudentIID]
      ,fs.[HeadId]
      ,fs.[TotalAmount]
      ,fs.[DueAmount]
	  ,fs.InvoiceAmount
      ,fs.[ScholarshipAmount]
      ,0.00 [DiscountAmount]
      ,fs.[PaidAmount]
      ,fs.[IsPaid]
      ,fs.[IsCompleted]
      ,fs.[IsDeleted]
      ,fs.[AddBy]
      ,fs.[AddDate]
      ,fs.[UpdateBy]
      ,fs.[UpdateDate]
      ,fs.[Remarks]
      ,fs.[Status]
      ,fs.[IP]
      ,fs.[MacAddress]
      ,fs.[MonthId]
      ,fs.[AdvanceAmount]
      ,fs.[Narration]
      ,fs.[FeesBookNo]
      ,fs.[SessionId]
      ,fs.[ProcessType]
      ,fs.[NoModifiedDueAmount]
      ,fs.[FeesSessionYearId]
      ,fs.[EmpId]
      ,fs.[IsVerification]
      ,fs.[AppVerificationNo]
      ,fs.[AutomatedDays]
      ,fs.[AutomatedConsecutiveDays]
      ,fs.[IsPublished]
      ,fs.[Year],fs.InvoiceAmount ReceiveAmount,h.HeadName,fm.MonthName,h.CategoryId from dbo.Fees_Student fs 
	join dbo.Fees_Head h on h.FeesHeadId=fs.HeadId and fs.HeadId=1051  and fs.MonthId <=5 and fs.Year <=2018 and fs.StudentIID=28858
	join dbo.Fees_FeesMonth fm on fs.MonthId=fm.FeesMonthId AND fs.ProcessType IN('G','L')
	END
	END
	IF(@BlockId=5)
	BEGIN
	select MonthName,ss.SessionName ,sum(DueAmount) DueAmount from dbo.Fees_Student fs
INNER JOIN dbo.Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId
INNER JOIN dbo.Ins_Session SS on SS.SessionId=fs.SessionId
where fs.IsCompleted=0  and  fm.FeesMonthId>=@MonthId and fs.Year >=@Year
 group by StudentIID,MonthName,SessionName 
 having fs.StudentIID=@StudentIID
	END
	IF(@BlockId=6)
	BEGIN
	select MonthName,ss.SessionName ,sum(DueAmount) DueAmount from dbo.Fees_Student fs
INNER JOIN dbo.Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId
INNER JOIN dbo.Ins_Session SS on SS.SessionId=fs.SessionId
where fs.IsCompleted=0  and  fm.FeesMonthId>=@MonthId   
 group by StudentIID,MonthName,SessionName 
 having fs.StudentIID=@StudentIID
	END
END

--select HeadId, DueAmount from dbo.Fees_Student where StudentIID=138 and [Year] <= 2019 and MonthId<=5 and IsCompleted=0 and IsDeleted=0
--1711318
--1711319
--1711314
/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ReportFeesSetup]'))
BEGIN
DROP PROCEDURE  ReportFeesSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ReportFeesSetup] -- Total 15 param
	@Block INT = 0,
	
	@SessionId INT = null,
	@BranchID INT = null,
	@ShiftID INT = null,
	@ClassId INT = null,

	@SectionId INT = null,
	@StuIds VARCHAR(1000) = null,
	@ProcessId Int=null,
	@Month int=null,
	@FromMoth INT = null, 
	@ToMoth INT = null,
	@Where varchar(MAX) = NULL,
	@HeadId int =null

	
	
AS
BEGIN

 IF(@Block=1) -- View All Head Setup
-- execute ReportFeesSetup 1,1,1,2,1,1,0,5,'10655,137',2,2,1,2
 BEGIN
	Select H.[HeadName], C.CategoryName From [dbo].[Fees_Head] H inner join [dbo].[Fees_Category] C
	On H.CategoryId=C.[FeesCategoryId] where H.IsDeleted=0 Order by H.ShowOrder

 END

 IF(@Block=2) --  View All Process Setup
-- execute ReportFeesSetup 2,'',6,'','','','','','','',1,'',''

 BEGIN
 Declare @MothId int=0
 -- here @Month is SessionYearID
 SELECT top(1) @MothId=R.MonthId From Fees_FeesSessionYear R where R.FeesSessionYearId=@Month
 Select p.ProcessName,S.SessionName,M.[MonthName],y.[Year]
  ,
 CASE  
 When  (SELECT Top (1) F.FeesSessionYearId From Fees_Student F where F.FeesSessionYearId=Y.FeesSessionYearId And F.ProcessId=p.FeesProcessId) is null  THEN 'Active' 
  ELSE 'Processed' 
END as Statuses 
 from  Fees_Process P Inner join Ins_Session S On P.SessionId=S.SessionId 

 Inner Join Fees_ProcessDetails D ON P.FeesProcessId=D.ProcessId

 Inner join Fees_FeesSessionYear Y
 on Y.FeesSessionYearId=D.SessionYearId inner join Fees_FeesMonth M on M.FeesMonthId=y.MonthId 
 where s.SessionId=@SessionId And S.IsDeleted=0 and P.IsDeleted=0 AND Y.IsDeleted=0
 AND (Y.MonthId=@MothId OR @MothId=0)
 order by p.FeesProcessId asc




 END

 IF(@Block=3) --  Common Setup Process Setup
 BEGIN
 -- execute ReportFeesSetup 3,1,1,2,1,1,0,5,'10655,137',51,2,1,2
 DECLARE @sql varchar(max)
set @sql= 'Select P.ProcessName, v.SessionName,v.BranchName,v.ShiftName,v.ClassName,v.SectionName, H.HeadName, F.Amount,T.StudentTypeName from [dbo].[Fees_Head] H inner join Fees_HeadAmountConfig F On H.FeesHeadId=F.HeadId
 Inner Join view_CommonTableNames V On  V.SessionId=F.SessionId And V.BranchId=F.BranchId 
 And V.ShiftId=F.ShiftId And V.ClassId=F.ClassId And V.SectionId=F.SectionId
 Inner Join [dbo].[Fees_Process] P On P.FeesProcessId=F.ProcessId
 Left Join dbo.Ins_StudentType T ON T.StudentTypeId=F.FessGroupId'
 
 --Where H.CategoryId=1 AND F.StudentIID is Null AND (F.VersionId=@VersionId OR @VersionId is null OR @VersionId=0) AND (F.SessionId=@SessionId OR @SessionId is null OR @SessionId=0)
 --AND F.ProcessId=@ProcessId

  IF(@Where IS NOT NULL AND  @Where <> '')
	 BEGIN
	 SET @sql = @sql + ' WHERE CategoryId=1 AND '+ @Where + ' order by V.ClassId asc'
	 END
	EXEC(@sql)

 END
  
  IF(@Block=4) --  Individual Setup Process Setup
  -- execute ReportFeesSetup 4

 BEGIN
select StudentInsID,FullName,cast(RollNo as int) RollNo,StudentTypeName,HeadName,sum(Amount) Amount from 
		(
		SELECT 
		sb.StudentInsID
		,sb.FullName
		,sb.RollNo
		,Amount
		,st.StudentTypeName
		,fh.HeadName
		,substring(fm.MonthName,1,3) MonthName
		,fm.FeesMonthId
	
		,isn.SessionName
		,ib.BranchName,
		isft.ShiftName
		,ici.ClassName
		
		,isec.SectionName
		,fs.HeadId
		FROM [Fees_HeadAmountConfig] fhac
		INNER JOIN Fees_Process fp on fp.FeesProcessId=fhac.ProcessId
		INNER JOIN Fees_Head fh on fh.FeesHeadId=fhac.HeadId
		INNER JOIN Fees_Student fs on fs.StudentIID=fhac.StudentIID 
		INNER JOIN Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId
		INNER JOIN Student_BasicInfo sb on sb.StudentIID=fhac.StudentIID
		
		INNER JOIN Ins_Session isn on isn.SessionId=sb.SessionId
		INNER JOIN Ins_Branch ib on ib.BranchId=sb.BranchID
		INNER JOIN Ins_Shift isft on isft.ShiftId=sb.ShiftID
		INNER JOIN Ins_ClassInfo ici on ici.ClassId=sb.ClassId
		
		INNER JOIN Ins_Section isec on isec.SectionId=sb.SectionId	
		INNER JOIN Ins_StudentType st on st.StudentTypeId=sb.StudentTypeID	
		where fhac.StudentIID is not null and (fm.FeesMonthId=@Month OR @Month=0 oR @Month is null)
		and isnull(fs.IsDeleted,0)=0 
		) t
		group by StudentInsID,FullName,RollNo,StudentTypeName,HeadName 

		Order By CAST( RollNo as INT) ASC
 END
 
 IF(@Block=5) -- 
  BEGIN
  -- execute ReportFeesSetup @Block=5 

		select StudentInsID,FullName,cast(RollNo as int) RollNo,MonthName,FeesMonthId ,
		sum(Amount) Amount,HeadName,FeesHeadId ,SessionName,BranchName,ShiftName,ClassName,SectionName,HeadNameAll	
		into #TempIndividualStudentFeesSummary2
		from 
		(	
		SELECT 
		StudentInsID
		,sb.FullName
		,sb.RollNo
		,fs.TotalAmount [Amount]
		 ,SUBSTRING(fm.MonthName,1,3) MonthName
		 
		 
		,fm.FeesMonthId
		 ,
		 Case
		 When @SessionId=0 OR @SessionId is null Then 'All' 
		 else  isn.SessionName 
		 end as SessionName
 
		 ,
		 Case
		 When @BranchID=0 OR @BranchID is null Then 'All'
		 else   ib.BranchName 
		 end as  BranchName
		 ,
		 Case
		 When @ShiftID=0 OR @ShiftID is null Then 'All'
		 else   isft.ShiftName
		 end as  ShiftName

		 ,
		 Case
		 When @ClassId=0 OR @ClassId is null  Then 'All'
		 else  ici.ClassName
		 end as ClassName
 
		 ,
		 Case
		 When @SectionId=0 OR @SectionId is null Then 'All'
		 else  isec.SectionName 
		 end as SectionName
		,fh.FeesHeadId
		,fh.HeadName
		 ,
		 Case
		 When @HeadId=0 OR @HeadId is null Then 'All'
		 else  fh.HeadName
		 end as HeadNameAll

		FROM Fees_Student fs --[Fees_HeadAmountConfig] fhac 22794
		INNER JOIN Fees_Process fp on fp.FeesProcessId=fs.ProcessId
		INNER JOIN Fees_Head fh on fh.FeesHeadId=fs.HeadId
		--INNER JOIN  fs on fs.StudentIID=fhac.StudentIID 
		inner JOIN Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId  
		INNER JOIN Student_BasicInfo sb on sb.StudentIID=fs.StudentIID
	
		INNER JOIN Ins_Session isn on isn.SessionId=sb.SessionId
		INNER JOIN Ins_Branch ib on ib.BranchId=sb.BranchID
		INNER JOIN Ins_Shift isft on isft.ShiftId=sb.ShiftID
		INNER JOIN Ins_ClassInfo ici on ici.ClassId=sb.ClassId
		
		INNER JOIN Ins_Section isec on isec.SectionId=sb.SectionId				 
		Where isnull(fs.IsDeleted,0)=0  and fh.CategoryId=2
		and (fs.HeadId=@HeadId	OR @HeadId=0 OR @HeadId is null)   
		
		 And (sb.SessionId=@SessionId  OR @SessionId =0 OR @SessionId  is null) 
		 AND (sb.BranchID=@BranchID OR @BranchID =0 OR @BranchID  is null)
		 AND (sb.ShiftID=@ShiftID  OR @ShiftID =0 OR @ShiftID  is null)
		 AND (sb.ClassId=@ClassId  OR @ClassId =0 OR @ClassId  is null)
		
		 AND (sb.SectionId=@SectionId OR @SectionId =0 OR @SectionId  is null)
  ) 	t
	group by StudentInsID,FullName,RollNo,SUBSTRING(MonthName,1,3),MonthName,FeesMonthId
	,FeesHeadId,HeadName
				,SessionName
				,BranchName
				,ShiftName
				,ClassName
				
				,SectionName
				,FeesMonthId,
				HeadNameAll
	ORDER BY CAST( RollNo as INT) asc	
	
		 
	DECLARE @Counter int =0
	WHILE (@Counter<12)
	BEGIN
	-- -- execute ReportFeesSetup @Block=5 ,@VersionId=1
		SET @Counter=@Counter+1;
		insert into #TempIndividualStudentFeesSummary2 values(null,null,null, SUBSTRING(DateName( month , DateAdd( month , @Counter  , -1 )),1,3),@Counter,null,'',0,'','','','','','','','');		
	END
	IF(EXISTS(Select top  1 * from #TempIndividualStudentFeesSummary2))
	BEGIN
	  update #TempIndividualStudentFeesSummary2
		  set StudentInsID=(select top 1 StudentInsID  from  #TempIndividualStudentFeesSummary2 where StudentInsID is not null order by StudentInsID),
		  	FullName=(select top 1 FullName  from  #TempIndividualStudentFeesSummary2 where StudentInsID is not null order by StudentInsID),
			RollNo=(select top 1 RollNo  from  #TempIndividualStudentFeesSummary2 where StudentInsID is not null order by StudentInsID),			
			Amount=null,	
			HeadName=(select top 1 HeadName  from  #TempIndividualStudentFeesSummary2 where StudentInsID is not null order by StudentInsID),
			FeesHeadId=(select top 1 FeesHeadId  from  #TempIndividualStudentFeesSummary2 where StudentInsID is not null order by StudentInsID),
			
			SessionName=(select top 1 SessionName  from  #TempIndividualStudentFeesSummary2 where StudentInsID is not null order by StudentInsID),
			BranchName=(select top 1 BranchName  from  #TempIndividualStudentFeesSummary2 where StudentInsID is not null order by StudentInsID),
			ShiftName=(select top 1 ShiftName  from  #TempIndividualStudentFeesSummary2 where StudentInsID is not null order by StudentInsID),
			ClassName=(select top 1 ClassName  from  #TempIndividualStudentFeesSummary2 where StudentInsID is not null order by StudentInsID),
			
			SectionName=(select top 1 SectionName  from  #TempIndividualStudentFeesSummary2 where StudentInsID is not null order by StudentInsID),
			HeadNameAll=(select top 1  Case When @HeadId=0 OR @HeadId is null Then 'All' else  HeadName end from  #TempIndividualStudentFeesSummary2 where StudentInsID is not null order by StudentInsID)
			where StudentInsID is null
	END
		  select * from #TempIndividualStudentFeesSummary2 order by FeesMonthId 		   
		  drop table #TempIndividualStudentFeesSummary2 
	END


IF(@Block=6) --  Individual Fees IndStorage  
 BEGIN
-- execute ReportFeesSetup 6
--execute ReportFeesSetup 6,'','','','','','','','','','1058','',''
--need to filter month
 select FeesHeadId,StudentInsID,FullName,RollNo,StudentTypeName,HeadName,MonthName,
	
		
		 Case
		 When @SessionId=0 OR @SessionId is null Then 'All' 
		 else  SessionName 
		 end as SessionName
 
		 ,
		 Case
		 When @BranchID=0 OR @BranchID is null Then 'All'
		 else   BranchName 
		 end as  BranchName
		 ,
		 Case
		 When @ShiftID=0 OR @ShiftID is null Then 'All'
		 else   ShiftName
		 end as  ShiftName

		 ,
		 Case
		 When @ClassId=0 OR @ClassId is null Then 'All'
		 else  ClassName
		 end as ClassName
         ,
		 Case
		 When @SectionId=0 OR @SectionId is null Then 'All'
		 else  SectionName 
		 end as SectionName
		--,Amount
		,sum(Amount) Amount
		,HeadNameAll 
		,Case
		 When @FromMoth=0 OR @FromMoth is null Then 'All'
		 else   MonthName
		 end as   MonthNameAll
		from 
		(
		SELECT 
		sb.StudentInsID
		,sb.FullName
		,sb.RollNo
		,fhac.Amount Amount
		,st.StudentTypeName
		,Case
		 When @HeadId=0 OR @HeadId is null Then 'All'
		 else   fh.HeadName
		 end as  HeadNameAll
		,fh.HeadName
		,substring(fm.MonthName,1,3) MonthName
	 ,fm.FeesMonthId
		
		,isn.SessionName
		,ib.BranchName,
		isft.ShiftName
		,ici.ClassName
		
		,isec.SectionName
		,fh.FeesHeadId		
		FROM Student_BasicInfo sb 
		LEFT JOIN [Fees_HeadAmountConfig] fhac on sb.StudentIID=fhac.StudentIID
		LEFT JOIN Fees_Process fp on fp.FeesProcessId=fhac.ProcessId
		LEFT JOIN Fees_Head fh on fh.FeesHeadId=fhac.HeadId
		LEFT JOIN Fees_Student fs on fs.StudentIID=fhac.StudentIID  OR fs.StudentIID=sb.StudentIID
		LEFT JOIN Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId
 		
		LEFT JOIN Ins_Session isn on isn.SessionId=sb.SessionId
		LEFT JOIN Ins_Branch ib on ib.BranchId=sb.BranchID
		LEFT JOIN Ins_Shift isft on isft.ShiftId=sb.ShiftID
		LEFT JOIN Ins_ClassInfo ici on ici.ClassId=sb.ClassId
		
		LEFT JOIN Ins_Section isec on isec.SectionId=sb.SectionId	
		LEFT JOIN Ins_StudentType st on st.StudentTypeId=sb.StudentTypeID	
		where  --(fhac.ProcessId=@ProcessId OR @ProcessId=0   OR @ProcessId is null)
		  
		  (sb.SessionId=@SessionId  OR @SessionId =0 OR @SessionId  is null) 
		 AND (sb.BranchID=@BranchID OR @BranchID =0 OR @BranchID  is null)
		 AND (sb.ShiftID=@ShiftID  OR @ShiftID =0 OR @ShiftID  is null)
		 AND (sb.ClassId=@ClassId  OR @ClassId =0 OR @ClassId  is null)
		
		 AND (sb.SectionId=@SectionId OR @SectionId =0 OR @SectionId  is null)
		 AND ((fh.FeesHeadId=@HeadId OR @HeadId=0 OR @HeadId is null) OR (fhac.HeadId=@HeadId OR @HeadId=0 OR @HeadId is null))
		 and  (fs.MonthId=@FromMoth OR @FromMoth=0 OR @FromMoth is null) and isnull(fs.IsDeleted,0)=0 
		 
		) t
		
		group by StudentInsID,FullName,RollNo,StudentTypeName,HeadName,SessionName,BranchName,ShiftName,ClassName,SectionName ,MonthName,HeadNameAll,FeesHeadId
		Order By CAST( RollNo as INT) ASC
		-- execute ReportFeesSetup @Block=6,@@HeadId=1041,@FromMoth=1

END



  IF(@Block=77) --  late Pay Setup for Fiexed
-- execute ReportFeesSetup 7,1,1,2,1,1,0,5,'','',1,'',''



  IF(@Block=8) --  late Pay List
-- execute ReportFeesSetup 8,1,1,2,1,1,0,5,'',1190,1190,'',''


 BEGIN 

 Select  
v.SessionName,v.BranchName,v.ShiftName,v.ClassName,v.SectionName ,
B.StudentInsID,B.FullName,B.RollNo,F.AutomatedDays,F.AutomatedConsecutiveDays,F.DueAmount  , F.NoModifiedDueAmount ,T.StudentTypeName,
Y.[Year],M.[MonthName],
((SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF  where SF.StudentIID=F.StudentIID AND SF.IsCompleted=0)-(SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF  where SF.StudentIID=F.StudentIID AND SF.FeesSessionYearId=@Month AND SF.ProcessType='L' AND SF.IsCompleted=0)) as TotalDueWithOutFine,
(SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF  where SF.StudentIID=F.StudentIID AND SF.IsCompleted=0) as TotalDueWithFine
 From dbo.Fees_Student F Inner Join dbo.Student_BasicInfo B On B.StudentIID=F.StudentIID Inner Join view_CommonTableNames V On 
   v.SessionId=B.SessionId And V.BranchId=B.BranchId  And V.ShiftId=B.ShiftId And V.ClassId=B.ClassId  And V.SectionId=B.SectionId
  Left Join dbo.Ins_StudentType T On T.StudentTypeId=B.StudentTypeID
  Inner Join dbo.Fees_FeesSessionYear Y On Y.FeesSessionYearId=F.FeesSessionYearId
  Inner Join dbo.Fees_FeesMonth M On M.FeesMonthId=Y.MonthId
  Where F.ProcessType='L' And  F.IsCompleted=0 AND F.FeesSessionYearId=@Month  /* Only here @@Month is FeesSessionYearId */ 
  
 And (V.SessionId=@SessionId OR @SessionId Is null OR @SessionId =0) 
 AND (V.BranchID=@BranchID OR @BranchID Is null OR @BranchID =0)
 AND (V.ShiftID=@ShiftID OR @ShiftID Is null OR @ShiftID =0)
 AND (V.ClassId=@ClassId OR @ClassId Is null OR @ClassId =0)

 AND (V.SectionId=@SectionId OR @SectionId Is null OR @SectionId =0)
 AND (B.SectionId=@SectionId OR @SectionId Is null OR @SectionId =0)
	Order By   CAST( RollNo as INT) ASC

 END






  IF(@Block=10) -- Absent List
-- execute ReportFeesSetup 10,1,1,2,1,1,0,5,'',1190,1190,'',''

 BEGIN 
 
 Select  
v.SessionName,v.BranchName,v.ShiftName,v.ClassName,v.SectionName ,
B.StudentInsID,B.FullName,B.RollNo,F.AutomatedDays,F.AutomatedConsecutiveDays,F.DueAmount  , F.NoModifiedDueAmount ,T.StudentTypeName,
Y.[Year],M.[MonthName]
 From dbo.Fees_Student F Inner Join dbo.Student_BasicInfo B On B.StudentIID=F.StudentIID Inner Join view_CommonTableNames V On 
   v.SessionId=B.SessionId And V.BranchId=B.BranchId  And V.ShiftId=B.ShiftId And V.ClassId=B.ClassId  And V.SectionId=B.SectionId
  Left Join dbo.Ins_StudentType T On T.StudentTypeId=B.StudentTypeID
  Inner Join dbo.Fees_FeesSessionYear Y On Y.FeesSessionYearId=F.FeesSessionYearId
  Inner Join dbo.Fees_FeesMonth M On M.FeesMonthId=Y.MonthId
  Where F.ProcessType='A' And  F.FeesSessionYearId=@Month /* Only here @@Month is FeesSessionYearId */ 
  
 And (V.SessionId=@SessionId OR @SessionId Is null OR @SessionId =0) 
 AND (V.BranchID=@BranchID OR @BranchID Is null OR @BranchID =0)
 AND (V.ShiftID=@ShiftID OR @ShiftID Is null OR @ShiftID =0)
 AND (V.ClassId=@ClassId OR @ClassId Is null OR @ClassId =0)

 AND (V.SectionId=@SectionId OR @SectionId Is null OR @SectionId =0)
 AND (B.SectionId=@SectionId OR @SectionId Is null OR @SectionId =0)
 and isnull(f.IsDeleted,0)=0 
	Order By CAST( RollNo as INT) ASC


 END



  IF(@Block=12) --  Absconding List
-- execute ReportFeesSetup 12,1,1,2,1,1,0,5,'',1190,1190,'',''

 BEGIN 
  Select  
v.SessionName,v.BranchName,v.ShiftName,v.ClassName,v.SectionName ,
B.StudentInsID,B.FullName,B.RollNo,F.AutomatedDays,F.AutomatedConsecutiveDays,F.DueAmount  , F.NoModifiedDueAmount ,T.StudentTypeName,
Y.[Year],M.[MonthName]
 From dbo.Fees_Student F Inner Join dbo.Student_BasicInfo B On B.StudentIID=F.StudentIID Inner Join view_CommonTableNames V On 
   v.SessionId=B.SessionId And V.BranchId=B.BranchId  And V.ShiftId=B.ShiftId And V.ClassId=B.ClassId  And V.SectionId=B.SectionId
  Left Join dbo.Ins_StudentType T On T.StudentTypeId=B.StudentTypeID
  Inner Join dbo.Fees_FeesSessionYear Y On Y.FeesSessionYearId=F.FeesSessionYearId
  Inner Join dbo.Fees_FeesMonth M On M.FeesMonthId=Y.MonthId
  Where F.ProcessType='B' And  F.FeesSessionYearId=@Month /* Only here @@Month is FeesSessionYearId */ 
 
 And (V.SessionId=@SessionId OR @SessionId Is null OR @SessionId =0) 
 AND (V.BranchID=@BranchID OR @BranchID Is null OR @BranchID =0)
 AND (V.ShiftID=@ShiftID OR @ShiftID Is null OR @ShiftID =0)
 AND (V.ClassId=@ClassId OR @ClassId Is null OR @ClassId =0)

 AND (V.SectionId=@SectionId OR @SectionId Is null OR @SectionId =0)
 AND (B.SectionId=@SectionId OR @SectionId Is null OR @SectionId =0)
 and isnull(F.IsDeleted,0)=0 
	Order By  CAST( RollNo as INT) ASC
 END


  IF(@Block=14) --  LIEO List
-- execute ReportFeesSetup 7,1,1,2,1,1,0,5,'','',1,'',''

 BEGIN 

 Select  
v.SessionName,v.BranchName,v.ShiftName,v.ClassName,v.SectionName ,
B.StudentInsID,B.FullName,B.RollNo,F.AutomatedDays,F.AutomatedConsecutiveDays,F.DueAmount  , F.NoModifiedDueAmount ,T.StudentTypeName,
Y.[Year],M.[MonthName]
 From dbo.Fees_Student F Inner Join dbo.Student_BasicInfo B On B.StudentIID=F.StudentIID Inner Join view_CommonTableNames V On 
   v.SessionId=B.SessionId And V.BranchId=B.BranchId  And V.ShiftId=B.ShiftId And V.ClassId=B.ClassId  And V.SectionId=B.SectionId
  Left Join dbo.Ins_StudentType T On T.StudentTypeId=B.StudentTypeID
  Inner Join dbo.Fees_FeesSessionYear Y On Y.FeesSessionYearId=F.FeesSessionYearId
  Inner Join dbo.Fees_FeesMonth M On M.FeesMonthId=Y.MonthId
  Where F.ProcessType='I' And  F.FeesSessionYearId=@Month /* Only here @@Month is FeesSessionYearId */ 
 
 And (V.SessionId=@SessionId OR @SessionId Is null OR @SessionId =0) 
 AND (V.BranchID=@BranchID OR @BranchID Is null OR @BranchID =0)
 AND (V.ShiftID=@ShiftID OR @ShiftID Is null OR @ShiftID =0)
 AND (V.ClassId=@ClassId OR @ClassId Is null OR @ClassId =0)
 
 AND (V.SectionId=@SectionId OR @SectionId Is null OR @SectionId =0)
 AND (B.SectionId=@SectionId OR @SectionId Is null OR @SectionId =0)
	and isnull(F.IsDeleted,0)=0 
	Order By CAST( RollNo as INT) ASC

 END
  
 IF(@Block=15) -- --  Automated_Yearly_Log
-- execute ReportFeesSetup 15

 BEGIN 

 select StudentInsID,FullName,RollNo,MonthName,FeesMonthId,sum(Amount) Amount from 
		(
		SELECT 
		sb.StudentInsID
		,sb.FullName
		,sb.RollNo
		,[Amount]
		,substring(fm.MonthName,1,3) MonthName
		,fm.FeesMonthId

		,isn.SessionName
		,ib.BranchName,
		isft.ShiftName
		,ici.ClassName
			
		,isec.SectionName
		,fs.HeadId
		FROM [Fees_HeadAmountConfig] fhac
		INNER JOIN Fees_Process fp on fp.FeesProcessId=fhac.ProcessId
		INNER JOIN Fees_Head fh on fh.FeesHeadId=fhac.HeadId
		INNER JOIN Fees_Student fs on fs.StudentIID=fhac.StudentIID 
		INNER JOIN Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId
		INNER JOIN Student_BasicInfo sb on sb.StudentIID=fhac.StudentIID
		
		INNER JOIN Ins_Session isn on isn.SessionId=sb.SessionId
		INNER JOIN Ins_Branch ib on ib.BranchId=sb.BranchID
		INNER JOIN Ins_Shift isft on isft.ShiftId=sb.ShiftID
		INNER JOIN Ins_ClassInfo ici on ici.ClassId=sb.ClassId
		
		INNER JOIN Ins_Section isec on isec.SectionId=sb.SectionId		
		where  isnull(fs.IsDeleted,0)=0 
  ) t		
	group by StudentInsID,FullName,RollNo,MonthName,FeesMonthId
	ORDER BY FeesMonthId,CAST( RollNo as INT) ASC

 END
 
 IF(@Block=16) -- --  Automated_All_Head
-- execute ReportFeesSetup 16

 BEGIN 
 		
		SELECT isn.SessionName,ib.BranchName, isft.ShiftName,ici.ClassName,isec.SectionName
		,sb.StudentInsID ,sb.FullName ,sb.RollNo,sum([Amount]) [Amount],fh.HeadName,FeesSessionYearId, fm.MonthName ,fm.FeesMonthId
		,case when @Month=0 then 'All' else fm.MonthName end MonthNameAll
		FROM [Fees_HeadAmountConfig] fhac
		INNER JOIN Fees_Process fp on fp.FeesProcessId=fhac.ProcessId		
		INNER JOIN Fees_Student fs on fs.StudentIID=fhac.StudentIID 
		INNER JOIN Fees_Head fh on fh.FeesHeadId=fs.HeadId
		INNER JOIN Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId
		INNER JOIN Student_BasicInfo sb on sb.StudentIID=fhac.StudentIID
		
		INNER JOIN Ins_Session isn on isn.SessionId=sb.SessionId
		INNER JOIN Ins_Branch ib on ib.BranchId=sb.BranchID
		INNER JOIN Ins_Shift isft on isft.ShiftId=sb.ShiftID
		INNER JOIN Ins_ClassInfo ici on ici.ClassId=sb.ClassId
		
		INNER JOIN Ins_Section isec on isec.SectionId=sb.SectionId		
		WHERE fh.CategoryId=3 /*automatic */ and (fm.FeesMonthId=@Month OR @Month =0 OR @Month is null) and isnull(fs.IsDeleted,0)=0 --((select top 1 MonthId from Fees_FeesSessionYear fsy where fsy.FeesSessionYearId= fs.FeesSessionYearId)=@Month OR @Month =0 OR @Month is null)
		group by isn.SessionName,ib.BranchName, isft.ShiftName,ici.ClassName,isec.SectionName
		,sb.StudentInsID ,sb.FullName ,sb.RollNo,FeesSessionYearId ,fm.MonthName ,fm.FeesMonthId
		 ,fh.HeadName
		 order by CAST( RollNo as INT) ASC
 END
  
 IF(@Block=17) --  ScholerShif .. @Block=18 Use for  LetaPaySetup for Slab
-- execute ReportFeesSetup 17,1,1,2,1,1,0,5,'','',1,'',''

 BEGIN 

 Select B.StudentInsID,B.FullName,B.RollNo,T.ScholarshipType, S.[Amount] ,S.[IsPercentage] ,U.FullName As AddBy ,S.[AddDate] ,S.[Command],
 ( Select Top (1) M.[MonthName] From dbo.Fees_FeesMonth M
 Inner Join dbo.Fees_FeesSessionYear Y On M.FeesMonthId=Y.MonthId 
 Inner Join dbo.Fees_ScholarshipDetails D On D.ScholarshipMasterId=S.ScholarshipConfigId Order By M.FeesMonthId ASC) as [MonthName],
v.SessionName,v.BranchName,v.ShiftName,v.ClassName,v.SectionName ,H.HeadName
  From dbo.Fees_ScholarshipMaster S 
  Inner Join dbo.Fees_ScholarshipType T On T.ScholarshipTypeId=S.ScholarshipTypeId
 Inner Join dbo.Student_BasicInfo B On S.StudentId=B.StudentIID 
 Inner Join view_CommonTableNames V On v.SessionId=B.SessionId And V.BranchId=B.BranchId And V.ShiftId=B.ShiftId And V.ClassId=B.ClassId  And V.SectionId=B.SectionId
 Left Join dbo.Fees_Head H On H.FeesHeadId=S.FeesHeadId
 Left Join AspNetUsers U On U.Id=S.AddBy
 Where  S.IsDeleted=0  
 
 And (V.SessionId=@SessionId OR @SessionId Is null OR @SessionId =0) 
 AND (V.BranchID=@BranchID OR @BranchID Is null OR @BranchID =0)
 AND (V.ShiftID=@ShiftID OR @ShiftID Is null OR @ShiftID =0)
 AND (V.ClassId=@ClassId OR @ClassId Is null OR @ClassId =0)
 
 AND (V.SectionId=@SectionId OR @SectionId Is null OR @SectionId =0)
 Order By B.ClassId ASC,CAST( RollNo as INT) ASC

 END




 IF(@Block=19) --  Common Setup Process Class Wise Setup
 BEGIN
 -- execute ReportFeesSetup 19,1,6,2,1,1,0,5,'1063,137',51,2,1,2
 DECLARE @sqlShift varchar(max)
set @sqlShift= 'Select P.ProcessName, v.SessionName,v.BranchName,v.ClassName,v.ClassId, H.HeadName, F.Amount from [dbo].[Fees_Head] H inner join Fees_HeadAmountConfig F On H.FeesHeadId=F.HeadId
 Inner Join view_CommonTableNames V On  V.SessionId=F.SessionId And V.BranchId=F.BranchId 
 And V.ClassId=F.ClassId 
 Inner Join [dbo].[Fees_Process] P On P.FeesProcessId=F.ProcessId
 '
 
 --Where H.CategoryId=1 AND F.StudentIID is Null AND (F.VersionId=@VersionId OR @VersionId is null OR @VersionId=0) AND (F.SessionId=@SessionId OR @SessionId is null OR @SessionId=0)
 --AND F.ProcessId=@ProcessId

  IF(@Where IS NOT NULL AND  @Where <> '')
	 BEGIN
	 SET @sqlShift = @sqlShift + ' WHERE CategoryId=1 AND '+ @Where + 'group by P.ProcessName,v.SessionName,v.BranchName,v.ClassName, v.ClassId ,H.HeadName, F.Amount  order by V.ClassId '
	 END
	EXEC(@sqlShift)

 END

  IF(@Block=20) --??????????
  BEGIN
  -- execute ReportFeesSetup @Block=20,@Month=1

		select StudentInsID,FullName,cast(RollNo as int) RollNo,MonthName,FeesMonthId ,
		sum(Amount) Amount,HeadName,FeesHeadId ,SessionName,BranchName,ShiftName,ClassName,SectionName 		
		from 
		(	
		SELECT 
		sb.StudentInsID
		,sb.FullName
		,sb.RollNo
		--,fs.TotalAmount [Amount]
		, fhac.Amount
		 
		--,substring(fm.MonthName,1,3) MonthName
		,Case
		 When @Month=0 OR @Month is null Then 'All'
		 else fm.MonthName
		 end as MonthName
		 
		,fm.FeesMonthId
		
		 ,
		 Case
		 When @SessionId=0 OR @SessionId is null Then 'All' 
		 else  isn.SessionName 
		 end as SessionName
 
		 ,
		 Case
		 When @BranchID=0 OR @BranchID is null Then 'All'
		 else   ib.BranchName 
		 end as  BranchName
		 ,
		 Case
		 When @ShiftID=0 OR @ShiftID is null Then 'All'
		 else   isft.ShiftName
		 end as  ShiftName

		 ,
		 Case
		 When @ClassId=0 OR @ClassId is null  Then 'All'
		 else  ici.ClassName
		 end as ClassName
 
		 ,
		 Case
		 When @SectionId=0 OR @SectionId is null Then 'All'
		 else  isec.SectionName 
		 end as SectionName
		,fh.FeesHeadId
		,fh.HeadName
		FROM[Fees_HeadAmountConfig] fhac
		INNER JOIN Fees_Process fp on fp.FeesProcessId=fhac.ProcessId
		INNER JOIN Fees_Head fh on fh.FeesHeadId=fhac.HeadId
		INNER JOIN   Fees_Student fs  on fs.StudentIID=fhac.StudentIID 
		inner JOIN Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId  
		INNER JOIN Student_BasicInfo sb on sb.StudentIID=fhac.StudentIID
		
		INNER JOIN Ins_Session isn on isn.SessionId=sb.SessionId
		INNER JOIN Ins_Branch ib on ib.BranchId=sb.BranchID
		INNER JOIN Ins_Shift isft on isft.ShiftId=sb.ShiftID
		INNER JOIN Ins_ClassInfo ici on ici.ClassId=sb.ClassId
		
		INNER JOIN Ins_Section isec on isec.SectionId=sb.SectionId				 
		Where fh.CategoryId=2 and isnull(fs.IsDeleted,0)=0  and 
		   (fm.FeesMonthId=@FromMoth	OR @FromMoth=0 OR @FromMoth is null)  
		
		 And (sb.SessionId=@SessionId  OR @SessionId =0 OR @SessionId  is null) 
		 AND (sb.BranchID=@BranchID OR @BranchID =0 OR @BranchID  is null)
		 AND (sb.ShiftID=@ShiftID  OR @ShiftID =0 OR @ShiftID  is null)
		 AND (sb.ClassId=@ClassId  OR @ClassId =0 OR @ClassId  is null)
		
		 AND (sb.SectionId=@SectionId OR @SectionId =0 OR @SectionId  is null)
		 and (fhac.HeadId=@HeadId	OR @HeadId=0 OR @HeadId is null)  
  ) t		
	group by StudentInsID,FullName,RollNo,MonthName,FeesMonthId,
	FeesHeadId,HeadName
				,SessionName
				,BranchName
				,ShiftName
				,ClassName
				
				,SectionName
				,FeesMonthId
				

	ORDER BY CAST( RollNo as INT) asc		 
	END
  -- execute ReportFeesSetup @Block=20,@Month=3,versionid=1
   
    IF(@Block=21) --??????????
  BEGIN
 
		SELECT distinct
		sb.StudentInsID
		,sb.FullName
		,cast(sb.RollNo as int) RollNo
		, fs.TotalAmount Amount
		,Case
		 When @Month=0 OR @Month is null Then 'All'
		 else fm.MonthName
		 end as MonthName 
		,fm.FeesMonthId
		
		 ,
		 Case
		 When @SessionId=0 OR @SessionId is null Then 'All' 
		 else  isn.SessionName 
		 end as SessionName
 
		 ,
		 Case
		 When @BranchID=0 OR @BranchID is null Then 'All'
		 else   ib.BranchName 
		 end as  BranchName
		 ,
		 Case
		 When @ShiftID=0 OR @ShiftID is null Then 'All'
		 else   isft.ShiftName
		 end as  ShiftName

		 ,
		 Case
		 When @ClassId=0 OR @ClassId is null  Then 'All'
		 else  ici.ClassName
		 end as ClassName
 
	
		 ,
		 Case
		 When @SectionId=0 OR @SectionId is null Then 'All'
		 else  isec.SectionName 
		 end as SectionName
		,fh.FeesHeadId
		,fh.HeadName
		,Case
		 When @HeadId=0 OR @HeadId is null Then 'All'
		 else   fh.HeadName
		 end as  HeadNameAll
		 ,Case
		 When @Month=0 OR @Month is null Then 'All'
		 else   MonthName
		 end as   MonthNameAll
		 ,tp.StudentTypeName
		FROM Fees_Student fs --[Fees_HeadAmountConfig] fhac
		INNER JOIN Fees_Process fp on fp.FeesProcessId=fs.ProcessId
		INNER JOIN Fees_Head fh on fh.FeesHeadId=fs.HeadId
		--INNER JOIN   Fees_Student fs  on fs.StudentIID=fhac.StudentIID 
		inner JOIN Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId  
		INNER JOIN Student_BasicInfo sb on sb.StudentIID=fs.StudentIID
		Left JOIN  Ins_StudentType tp on tp.StudentTypeId=sb.StudentTypeID

		INNER JOIN Ins_Session isn on isn.SessionId=sb.SessionId
		INNER JOIN Ins_Branch ib on ib.BranchId=sb.BranchID
		INNER JOIN Ins_Shift isft on isft.ShiftId=sb.ShiftID
		INNER JOIN Ins_ClassInfo ici on ici.ClassId=sb.ClassId

		INNER JOIN Ins_Section isec on isec.SectionId=sb.SectionId				 
		Where fh.CategoryId=2  --only individual
		and (fs.ProcessId=@ProcessId OR @ProcessId=0 OR @ProcessId is null)
		and   (fs.MonthId=@Month	OR @Month=0 OR @Month is null)  
	 
		 And (sb.SessionId=@SessionId  OR @SessionId =0 OR @SessionId  is null) 
		 AND (sb.BranchID=@BranchID OR @BranchID =0 OR @BranchID  is null)
		 AND (sb.ShiftID=@ShiftID  OR @ShiftID =0 OR @ShiftID  is null)
		 AND (sb.ClassId=@ClassId  OR @ClassId =0 OR @ClassId  is null)
		
		 AND (sb.SectionId=@SectionId OR @SectionId =0 OR @SectionId  is null)
		and (fs.HeadId=@HeadId	OR @HeadId=0 OR @HeadId is null)  
	ORDER BY CAST( RollNo as INT) asc		 
	END
   --    execute ReportFeesSetup @Block=21,@@HeadId=1062,@versionid=1,@SessionId=6,@BranchId=3,@ShiftId=5,@ClassId=2,@SectionId=120
   /*
   select amount, * from Fees_HeadAmountConfig where VersionId=1 and SessionId=6
and BranchId=3 and ShiftId=5 and ClassId=2 and SectionId=120
and HeadId=1062
   */

IF(@Block=22) 
  BEGIN
 
		SELECT distinct
		sb.StudentInsID
		,sb.FullName
		,cast(sb.RollNo as int) RollNo
		, fs.TotalAmount Amount
		 
		,Case
		 When @Month=0 OR @Month is null Then 'All'
		 else fm.MonthName
		 end as MonthName 
		,fm.FeesMonthId

		 ,
		 Case
		 When @SessionId=0 OR @SessionId is null Then 'All' 
		 else  isn.SessionName 
		 end as SessionName
 
		 ,
		 Case
		 When @BranchID=0 OR @BranchID is null Then 'All'
		 else   ib.BranchName 
		 end as  BranchName
		 ,
		 Case
		 When @ShiftID=0 OR @ShiftID is null Then 'All'
		 else   isft.ShiftName
		 end as  ShiftName

		 ,
		 Case
		 When @ClassId=0 OR @ClassId is null  Then 'All'
		 else  ici.ClassName
		 end as ClassName
 
		 ,
		 Case
		 When @SectionId=0 OR @SectionId is null Then 'All'
		 else  isec.SectionName 
		 end as SectionName
		,fh.FeesHeadId
		,fh.HeadName
		,Case
		 When @HeadId=0 OR @HeadId is null Then 'All'
		 else   fh.HeadName
		 end as  HeadNameAll
		 ,Case
		 When @FromMoth=0 OR @FromMoth is null Then 'All'
		 else   MonthName
		 end as   MonthNameAll
		 ,tp.StudentTypeName
		FROM Fees_Student fs --[Fees_HeadAmountConfig] fhac
		INNER JOIN Fees_Process fp on fp.FeesProcessId=fs.ProcessId
		INNER JOIN Fees_Head fh on fh.FeesHeadId=fs.HeadId
		--INNER JOIN   Fees_Student fs  on fs.StudentIID=fhac.StudentIID 
		inner JOIN Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId  
		INNER JOIN Student_BasicInfo sb on sb.StudentIID=fs.StudentIID
		Left JOIN  Ins_StudentType tp on tp.StudentTypeId=sb.StudentTypeID
		
		INNER JOIN Ins_Session isn on isn.SessionId=sb.SessionId
		INNER JOIN Ins_Branch ib on ib.BranchId=sb.BranchID
		INNER JOIN Ins_Shift isft on isft.ShiftId=sb.ShiftID
		INNER JOIN Ins_ClassInfo ici on ici.ClassId=sb.ClassId
	
		INNER JOIN Ins_Section isec on isec.SectionId=sb.SectionId				 
		Where fh.CategoryId=2  and isnull(fs.IsDeleted,0)=0 
		and (fs.ProcessId=@ProcessId OR @ProcessId=0 OR @ProcessId is null)
		and   (fs.MonthId=@Month	OR @Month=0 OR @Month is null)  
	 
		 And (sb.SessionId=@SessionId  OR @SessionId =0 OR @SessionId  is null) 
		 AND (sb.BranchID=@BranchID OR @BranchID =0 OR @BranchID  is null)
		 AND (sb.ShiftID=@ShiftID  OR @ShiftID =0 OR @ShiftID  is null)
		 AND (sb.ClassId=@ClassId  OR @ClassId =0 OR @ClassId  is null)
		
		 AND (sb.SectionId=@SectionId OR @SectionId =0 OR @SectionId  is null)
		and (fs.HeadId=@HeadId	OR @HeadId=0 OR @HeadId is null)  
	ORDER BY CAST( RollNo as INT) asc		 
	END
	 
IF(@Block=23) -- 
  BEGIN
  -- execute ReportFeesSetup @Block=23

		select StudentInsID,FullName,cast(RollNo as int) RollNo,StudentTypeName,MonthName,FeesMonthId ,
		sum(Amount) Amount,isnull(HeadName,'????') HeadName,FeesHeadId ,SessionName,BranchName,ShiftName,ClassName,SectionName,HeadNameAll	
		into #TempIndividualStudentFeesSummary23
		from 
		(	
		SELECT 
		StudentInsID
		,sb.FullName
		,st.StudentTypeName
		,sb.RollNo
		,fs.TotalAmount [Amount]
		 ,SUBSTRING(fm.MonthName,1,3) MonthName
		 
		 
		,fm.FeesMonthId

		 ,
		 Case
		 When @SessionId=0 OR @SessionId is null Then 'All' 
		 else  isn.SessionName 
		 end as SessionName
 
		 ,
		 Case
		 When @BranchID=0 OR @BranchID is null Then 'All'
		 else   ib.BranchName 
		 end as  BranchName
		 ,
		 Case
		 When @ShiftID=0 OR @ShiftID is null Then 'All'
		 else   isft.ShiftName
		 end as  ShiftName

		 ,
		 Case
		 When @ClassId=0 OR @ClassId is null  Then 'All'
		 else  ici.ClassName
		 end as ClassName
 

		 ,
		 Case
		 When @SectionId=0 OR @SectionId is null Then 'All'
		 else  isec.SectionName 
		 end as SectionName
		,fh.FeesHeadId
		,fh.HeadName
		 ,
		 Case
		 When @HeadId=0 OR @HeadId is null Then 'All'
		 else  fh.HeadName
		 end as HeadNameAll

		FROM Fees_Student fs --[Fees_HeadAmountConfig] fhac		
		INNER JOIN Fees_Process fp on fp.FeesProcessId=fs.ProcessId
		INNER JOIN Fees_Head fh on fh.FeesHeadId=fs.HeadId
		--INNER JOIN  fs on fs.StudentIID=fhac.StudentIID 
		inner JOIN Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId  
		INNER JOIN Student_BasicInfo sb on sb.StudentIID=fs.StudentIID
		left join Ins_StudentType st on st.StudentTypeId=sb.StudentTypeID

		INNER JOIN Ins_Session isn on isn.SessionId=sb.SessionId
		INNER JOIN Ins_Branch ib on ib.BranchId=sb.BranchID
		INNER JOIN Ins_Shift isft on isft.ShiftId=sb.ShiftID
		INNER JOIN Ins_ClassInfo ici on ici.ClassId=sb.ClassId
	
		INNER JOIN Ins_Section isec on isec.SectionId=sb.SectionId				 
		Where isnull(fs.IsDeleted,0)=0 and fh.CategoryId=3-- and fs.StudentIID=28904
		and (fs.HeadId=@HeadId	OR @HeadId=0 OR @HeadId is null)   
	
		 And (sb.SessionId=@SessionId  OR @SessionId =0 OR @SessionId  is null) 
		 AND (sb.BranchID=@BranchID OR @BranchID =0 OR @BranchID  is null)
		 AND (sb.ShiftID=@ShiftID  OR @ShiftID =0 OR @ShiftID  is null)
		 AND (sb.ClassId=@ClassId  OR @ClassId =0 OR @ClassId  is null)

		 AND (sb.SectionId=@SectionId OR @SectionId =0 OR @SectionId  is null)
  ) 	t
	group by StudentInsID,FullName,RollNo,SUBSTRING(MonthName,1,3),StudentTypeName,MonthName,FeesMonthId
	,FeesHeadId,HeadName,SessionName,BranchName,ShiftName,ClassName,SectionName,FeesMonthId,HeadNameAll
	
	ORDER BY CAST( RollNo as INT) asc	
	
		 
	SET @Counter   =0
	WHILE (@Counter<12)
	BEGIN
  -- execute ReportFeesSetup @Block=23 
    -- execute ReportFeesSetup @Block=23  ,@Versionid=1, @SessionId=6, @BranchId=3, @ShiftId=5, @ClassId=2, @GroupId=0, @SectionId=0
		SET @Counter=@Counter+1;
		insert into #TempIndividualStudentFeesSummary23 values(null,0,0, 0,SUBSTRING(DateName( month , DateAdd( month , @Counter  , -1 )),1,3),@Counter,0,'',0,'','','','','','','','');		
	END
	IF(EXISTS(Select top  1 * from #TempIndividualStudentFeesSummary23))
	BEGIN
			update #TempIndividualStudentFeesSummary23
			set StudentInsID=(select top 1 StudentInsID  from  #TempIndividualStudentFeesSummary23 where StudentInsID is not null order by StudentInsID),
		  	FullName=(select top 1 FullName  from  #TempIndividualStudentFeesSummary23 where StudentInsID is not null order by StudentInsID),
			RollNo=(select top 1 RollNo  from  #TempIndividualStudentFeesSummary23 where StudentInsID is not null order by StudentInsID),			
			StudentTypeName=(select top 1 StudentTypeName  from  #TempIndividualStudentFeesSummary23 where StudentInsID is not null order by StudentInsID),			
			Amount=null,	
			HeadName=(select top 1  HeadName   from  #TempIndividualStudentFeesSummary23 where StudentInsID is not null order by StudentInsID),
			FeesHeadId=(select top 1 FeesHeadId  from  #TempIndividualStudentFeesSummary23 where StudentInsID is not null order by StudentInsID),
			
			SessionName=(select top 1 SessionName  from  #TempIndividualStudentFeesSummary23 where StudentInsID is not null order by StudentInsID),
			BranchName=(select top 1 BranchName  from  #TempIndividualStudentFeesSummary23 where StudentInsID is not null order by StudentInsID),
			ShiftName=(select top 1 ShiftName  from  #TempIndividualStudentFeesSummary23 where StudentInsID is not null order by StudentInsID),
			ClassName=(select top 1 ClassName  from  #TempIndividualStudentFeesSummary23 where StudentInsID is not null order by StudentInsID),
			
			SectionName=(select top 1 SectionName  from  #TempIndividualStudentFeesSummary23 where StudentInsID is not null order by StudentInsID),
			HeadNameAll=(select top 1  Case When @HeadId=0 OR @HeadId is null Then 'All' else  HeadName end from  #TempIndividualStudentFeesSummary23 where StudentInsID is not null order by StudentInsID)
			where StudentInsID is null --and Amount =0
	END 
		  select * from #TempIndividualStudentFeesSummary23  order by FeesMonthId, cast(RollNo as int)
		  drop table #TempIndividualStudentFeesSummary23 
	END


 IF(@Block=24) -- 
  BEGIN
  -- execute ReportFeesSetup @Block=24

		select StudentInsID,FullName,cast(RollNo as int) RollNo,MonthName,FeesMonthId ,
		sum(Amount) Amount,HeadName,FeesHeadId ,SessionName,BranchName,ShiftName,ClassName,SectionName 		
		into #TempIndividualStudentFeesSummary21
		from 
		(	
		SELECT 
		StudentInsID
		,sb.FullName
		,sb.RollNo
		,fs.TotalAmount [Amount]
		 ,SUBSTRING(fm.MonthName,1,3) MonthName
		 
		 
		,fm.FeesMonthId
	
		 ,
		 Case
		 When @SessionId=0 OR @SessionId is null Then 'All' 
		 else  isn.SessionName 
		 end as SessionName
 
		 ,
		 Case
		 When @BranchID=0 OR @BranchID is null Then 'All'
		 else   ib.BranchName 
		 end as  BranchName
		 ,
		 Case
		 When @ShiftID=0 OR @ShiftID is null Then 'All'
		 else   isft.ShiftName
		 end as  ShiftName

		 ,
		 Case
		 When @ClassId=0 OR @ClassId is null  Then 'All'
		 else  ici.ClassName
		 end as ClassName
 
		 ,
		 Case
		 When @SectionId=0 OR @SectionId is null Then 'All'
		 else  isec.SectionName 
		 end as SectionName
		,fh.FeesHeadId
		,fh.HeadName
		FROM Fees_Student fs --[Fees_HeadAmountConfig] fhac
		INNER JOIN Fees_Process fp on fp.FeesProcessId=fs.ProcessId
		INNER JOIN Fees_Head fh on fh.FeesHeadId=fs.HeadId
		--INNER JOIN  fs on fs.StudentIID=fhac.StudentIID 
		inner JOIN Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId  
		INNER JOIN Student_BasicInfo sb on sb.StudentIID=fs.StudentIID

		INNER JOIN Ins_Session isn on isn.SessionId=sb.SessionId
		INNER JOIN Ins_Branch ib on ib.BranchId=sb.BranchID
		INNER JOIN Ins_Shift isft on isft.ShiftId=sb.ShiftID
		INNER JOIN Ins_ClassInfo ici on ici.ClassId=sb.ClassId

		INNER JOIN Ins_Section isec on isec.SectionId=sb.SectionId				 
		Where fh.CategoryId=3 and isnull(fs.IsDeleted,0)=0   

		 And (sb.SessionId=@SessionId  OR @SessionId =0 OR @SessionId  is null) 
		 AND (sb.BranchID=@BranchID OR @BranchID =0 OR @BranchID  is null)
		 AND (sb.ShiftID=@ShiftID  OR @ShiftID =0 OR @ShiftID  is null)
		 AND (sb.ClassId=@ClassId  OR @ClassId =0 OR @ClassId  is null)
	
		 AND (sb.SectionId=@SectionId OR @SectionId =0 OR @SectionId  is null)
  ) 	t
	group by StudentInsID,FullName,RollNo,SUBSTRING(MonthName,1,3),MonthName,FeesMonthId,
	FeesHeadId,HeadName
				,SessionName
				,BranchName
				,ShiftName
				,ClassName
				
				,SectionName
				,FeesMonthId
	ORDER BY CAST( RollNo as INT) asc		 
	DECLARE @Counter2 int =0
	WHILE (@Counter2<12)
	BEGIN
	-- -- execute ReportFeesSetup @Block=5 ,@VersionId=1
		SET @Counter2=@Counter2+1;
		insert into #TempIndividualStudentFeesSummary21 values(null,null,null, SUBSTRING(DateName( month , DateAdd( month , @Counter2  , -1 )),1,3),@Counter2,null,'',0,'','','','','','','');		
	END
	IF(EXISTS(Select top  1 * from #TempIndividualStudentFeesSummary21))
	BEGIN
	  update #TempIndividualStudentFeesSummary21
		  set StudentInsID=(select top 1 StudentInsID  from  #TempIndividualStudentFeesSummary21 where StudentInsID is not null order by StudentInsID),
		  	FullName=(select top 1 FullName  from  #TempIndividualStudentFeesSummary21 where StudentInsID is not null order by StudentInsID),
			RollNo=(select top 1 RollNo  from  #TempIndividualStudentFeesSummary21 where StudentInsID is not null order by StudentInsID),			
			Amount=null,	
			HeadName=(select top 1 HeadName  from  #TempIndividualStudentFeesSummary21 where StudentInsID is not null order by StudentInsID),
			FeesHeadId=(select top 1 FeesHeadId  from  #TempIndividualStudentFeesSummary21 where StudentInsID is not null order by StudentInsID),
			
			SessionName=(select top 1 SessionName  from  #TempIndividualStudentFeesSummary21 where StudentInsID is not null order by StudentInsID),
			BranchName=(select top 1 BranchName  from  #TempIndividualStudentFeesSummary21 where StudentInsID is not null order by StudentInsID),
			ShiftName=(select top 1 ShiftName  from  #TempIndividualStudentFeesSummary21 where StudentInsID is not null order by StudentInsID),
			ClassName=(select top 1 ClassName  from  #TempIndividualStudentFeesSummary21 where StudentInsID is not null order by StudentInsID),
			
			SectionName=(select top 1 SectionName  from  #TempIndividualStudentFeesSummary21 where StudentInsID is not null order by StudentInsID)
			where StudentInsID is null
	END  
		  select * from #TempIndividualStudentFeesSummary21 order by FeesMonthId 		   
		  drop table #TempIndividualStudentFeesSummary21 
	END


	IF(@Block=25)--execute ReportFeesSetup 25,NULL,NULL,NULL,NULL,NULL,4533,NULL,2019,08,09,NULL,NULL
	BEGIN
 
	  SELECT FH.HeadName,FS.DueAmount AS Amount,B.BranchName,B.Branch_ContactNumber,
	  FM.MonthName,SB.FullName,SB.StudentInsID,C.ClassName,S.SectionName,
	  CAST(FAH.LateDate AS DATE) AS LateDate,datefromparts(FS.[Year],FS.MonthId, 1) AS TempMonth   INTO #TempDefaulter
	FROM [dbo].[Fees_Student]  FS
	
	INNER JOIN dbo.Student_BasicInfo SB ON SB.StudentIID = FS.StudentIID
	INNER JOIN [dbo].[Fees_Head] FH ON FH.FeesHeadId = FS.HeadId
	INNER JOIN [dbo].[Fees_FeesMonth] FM ON FM.FeesMonthId = FS.MonthId
	INNER JOIN [dbo].[Ins_ClassInfo] C ON C.ClassId = SB.ClassId
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = SB.BranchId
	INNER JOIN [dbo].[Ins_Section] S ON S.SectionId = SB.SectionId
	LEFT OUTER JOIN [dbo].[Fees_AutomatedFeesConfig] FAH ON FAH.FeesSessionYearId = FS.FeesSessionYearId

	AND SB.BranchId = SB.BranchID AND SB.ShiftId = SB.ShiftID AND SB.SectionId = SB.SectionId 
	WHERE FS.IsPaid = 0 AND  FS.StudentIID IN(SELECT CAST(value AS INT) FROM STRING_SPLIT(@StuIds, ',') ) AND SB.IsDeleted = 0 AND SB.[Status] = 'A' 
	GROUP BY FH.HeadName,FS.DueAmount ,B.BranchName,B.Branch_ContactNumber,FS.[Year],FS.MonthId,
	  FM.MonthName,SB.FullName,SB.StudentInsID,C.ClassName,S.SectionName,FAH.LateDate

	 SELECT * FROM #TempDefaulter  WHERE TempMonth <= EOMONTH(datefromparts(@Month, @ToMoth, 1))
	DROP TABLE #TempDefaulter
	END 
	

	/*
	CREATE PROCEDURE [dbo].[ReportFeesSetup] -- Total 14 param
	@Block INT = 0,
	@SessionId INT = null,
	@BranchID INT = null,
	@ShiftID INT = null,
	@ClassId INT = null,
	@SectionId INT = null,
	@StuIds VARCHAR(1000) = null,
	@ProcessId Int=null,
	@Month int=null,
	@FromMoth INT = null, 
	@ToMoth INT = null,
	@Where varchar(MAX) = NULL,
	@HeadId int
	*/ 
END

/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetFeesByBlockId]'))
BEGIN
DROP PROCEDURE  [GetFeesByBlockId]
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

CREATE  PROCEDURE [dbo].[GetFeesByBlockId] 
    @Block INT=0,
	@SessionId INT=null,
	@BranchId INT=null,
	@ShiftId INT =null,
	@ClassId INT = null,
	@SectionId INT = null,
	@StudentIID INT=null,
	@ProcessTypeId int=null,
	@HeadId int=null
AS
BEGIN
	if(@Block=1) 	 -- GetFeesByBlockId 1,0,0,0,0,0,0,0,0
	BEGIN
	 SELECT * FROM Fees_Head H INNER JOIN Fees_Category C ON H.[CategoryId] = C.FeesCategoryId
	 WHERE H.IsDeleted = 0 
	  ORDER BY H.FeesHeadId DESC
	 END
	 if(@Block=2) --Common Fees
	 -- GetFeesByBlockId 2,1,1,2,1,1,0,'','',23,3
	BEGIN  
	 Select HA.*,H.HeadName,ST.StudentTypeName From Fees_HeadAmountConfig HA  
	 Inner Join Fees_Head H On H.FeesHeadId=HA.HeadId
	 Left Outer Join Ins_StudentType ST ON ST.StudentTypeId=HA.FessGroupId
	where HA.ProcessId=@ProcessTypeId AND Ha.HeadId=@HeadId
	 END
	 if(@Block=3) -- Individual Fees
	 -- GetFeesByBlockId 3,1,1,2,1,1,0,5,'',1,7
	BEGIN  
	DECLARE @Selected bit=0
	 Select SB.FullName,SB.RollNo,SB.StudentInsID, SB.StudentIID,SB.SessionId,SB.BranchID,SB.ShiftID,SB.ClassId,SB.SectionId,
	  HA.Amount,@ProcessTypeId as ProcessId,@Selected as Selected,@HeadId as HeadId From Student_BasicInfo SB  Left Join Fees_HeadAmountConfig HA ON SB.StudentIID=HA.StudentIID AND HA.ProcessId=@ProcessTypeId AND HA.HeadId=@HeadId
	  Where
	  SB.SessionId=@SessionId AND  SB.branchId=@BranchId AND SB.ClassId=@ClassId  AND SB.SectionId=@SectionId AND SB.IsDeleted=0
 
	  order by (SB.RollNo ) asc 
	 END
	 if(@Block=4) -- getProcessMonth
	BEGIN
	 -- GetFeesByBlockId 4,1,1,2,1,1,0,'','',1068,3
	 --SELECT M.FeesMonthId,M.[MonthName] FROM Fees_ProcessDetails D 
	 --INNER JOIN Fees_FeesSessionYear FY On D.SessionYearId=Fy.FeesSessionYearId 
	 --INNER JOIN Fees_FeesMonth M On M.FeesMonthId=Fy.MonthId
	 --where D.ProcessId=@ProcessTypeId
	 
	  DECLARE @IsChecked bit =0;
	 	 	  SELECT M.[MonthName]
		  	,(SELECT ISNULL(( CASE WHEN COUNT(S.ProcessDetailsId)>0 THEN 1 ELSE 0 END),0) FROM dbo.Fees_ProcessDetails S WHERE SessionYearId = D.SessionYearId) AS IsCheckedOld
			, @IsChecked AS IsChecked
		  ,D.SessionYearId as FeesMonthId FROM Fees_ProcessDetails D 
	 INNER JOIN Fees_FeesSessionYear FY On D.SessionYearId=Fy.FeesSessionYearId 
	 INNER JOIN Fees_FeesMonth M On M.FeesMonthId=Fy.MonthId
	 where D.ProcessId=@ProcessTypeId

	 -- SELECT M.[MonthName],D.SessionYearId as FeesMonthId FROM Fees_ProcessDetails D 
	 --INNER JOIN Fees_FeesSessionYear FY On D.SessionYearId=Fy.FeesSessionYearId 
	 --INNER JOIN Fees_FeesMonth M On M.FeesMonthId=Fy.MonthId
	 --where D.ProcessId=


	 END
	 if(@Block=5) -- getBulkFees
	BEGIN
	 -- GetFeesByBlockId 5,'','','','','','','',134,'',''

	 SELECT st.StudentIID, st.StudentInsID, st.FullName, st.RollNo,  cls.ClassName,  0 as Receive,'' as FeesBookNo,GETDATE() as BankCollectionDate,1 as PaymentType, '' as Narration  FROM Student_BasicInfo st 
	
	  INNER JOIN Ins_ClassInfo cls On st.ClassId=cls.ClassId
	 where st.StudentIID=@StudentIID
	 END
	 if(@Block=6) -- get common head
	BEGIN
	 SELECT H.*,C.*, NULL AS Amount FROM Fees_Head H INNER JOIN Fees_Category C ON H.[CategoryId] = C.FeesCategoryId
	 Where C.FeesCategoryId=1 ORDER BY H.FeesHeadId DESC
	 END
	 if(@Block=7) -- get Individual head
	BEGIN
	 SELECT * FROM Fees_Head H INNER JOIN Fees_Category C ON H.[CategoryId] = C.FeesCategoryId
	 Where C.FeesCategoryId=2
	 END
	  if(@Block=8) -- CommonFeesConfigReport
	BEGIN	--	GetFeesByBlockId 8,0,0,0,0,0,0,null,null,null,null
	 SELECT *
	 FROM [Fees_HeadAmountConfig] H 
	 Where  H.SessionId=@SessionId 
	  and (@BranchId=h.BranchId OR (@BranchId=0 AND h.BranchId is null))
	  and (@ShiftId=h.ShiftId OR (@ShiftId=0 AND h.ShiftId is null))
	  and H.ClassId=@ClassId
	  
	 --and H.GroupId=case when @GroupId=0 then  null else @GroupId end

	 
	 END
	 if(@Block=9) -- GetFeesFeesHead - only common head
	BEGIN	--	GetFeesByBlockId 9,null,null,null,null,null,null,null,null,null,null
	 SELECT  Distinct F.HeadName,F.FeesHeadId,F.CategoryId
	 FROM Fees_Head F 
	 inner join Fees_HeadAmountConfig H on H.HeadId=F.FeesHeadId 
	 where F.CategoryId=1 and F.IsDeleted=0 and H.IsDeleted=0 and H.Amount>0
	END
	IF(@Block=10) -- GetCommonTablesID Version to Section
	BEGIN	--	GetFeesByBlockId 10,1,6,null,null,null,null,null
	 SELECT DISTINCT [SessionId],[BranchId],[ShiftId],[ClassId],[SectionId]  FROM [dbo].[view_CommonTableNames] WHERE  SessionId=@SessionId 
	END
	IF(@Block=11)
	BEGIN
	 SELECT * FROM Fees_Head H INNER JOIN Fees_Category C ON H.[CategoryId] = C.FeesCategoryId WHERE H.CategoryId=1 ORDER BY H.FeesHeadId DESC
	 END

	 IF(@Block=12) --  GetFeesByBlockId 12,24,0,null,null,null,null,null,null
	BEGIN
	 SELECT P.FeesProcessId,P.SessionId,P.ProcessName,[Status],p.ProcessType --This Status feld for Active or Inactive Status Shoing..
	 --,(select case when exists((select top 1 *  FROM Fees_Student S where  S.ProcessId=P.FeesProcessId)) then 'P' else 'A' end) ProcessStatus--This ProcessStatus feld for Proecssed or NotProcessed Status Shoing..
	 ,(select case when exists((select top 1 *  FROM Fees_Student S where  S.ProcessId=P.FeesProcessId )) then 'P' else 'A' end) ProcessStatus--This ProcessStatus feld for Proecssed or NotProcessed Status Shoing..
	 FROM Fees_Process P 
	 WHERE P.SessionId=@SessionId and P.IsDeleted=0
	 END
	 --   select * from Fees_Process
	 if(@Block=13) -- GetFeesByBlockId 13,1,1,null,null,null,null,null,null,null,null
	BEGIN
	-- GetFeesByBlockId 13,1,1,null,null,null,null,null,null,null,null
	  SELECT 
	 
	  Y.[Year] FROM Fees_FeesSessionYear Y
	  where Y.FeesFiscalSessionId=@SessionId
	  Group By 
	  Y.[Year]
	 END

	IF(@Block=14) -- getYearBySession
	BEGIN
	-- GetFeesByBlockId 14,1,15,null,null,null,null,null,null,null,null
	  SELECT 
	 
	 Y.FeesSessionYearId, M.[MonthName] FROM Fees_FeesMonth M Inner Join Fees_FeesSessionYear Y On M.FeesMonthId=Y.MonthId
	  where Y.[Year]=@ProcessTypeId AND Y.FeesFiscalSessionId=@SessionId /*@ProcessTypeId is Year*/
	  
	 END	
	 IF(@Block=15) -- getYearBySession
	BEGIN-- GetFeesByBlockId 15,1,15,null,null,null,null,null,null,null,null	
	select *  from Fees_Student FS
		left join Student_BasicInfo SB on SB.StudentIID=FS.StudentIID
		left join Fees_Head FH on FH.FeesHeadId=FS.HeadId
		left join Fees_Category FC on FC.FeesCategoryId=FH.CategoryId
		where  SB.SectionId=@SessionId and SB.BranchId=@BranchId and SB.ShiftId=@ShiftId and SB.ClassId=@ClassId 
		and SB.SectionId=@SectionId and SB.StudentTypeID=COALESCE(@StudentIID,SB.StudentTypeID)  --@StudentIID is Student Type Id
		and FC.FeesCategoryId=3 and FH.IsDeleted=0 and FS.IsDeleted=0and SB.IsDeleted=0
	  
	 END

	 IF(@Block = 16)
	 BEGIN --GetFeesByBlockId 16,null,null,null,null,null,null,1005,null

	 SELECT 
	 FS.* 
	,FP.ProcessName
	,FSY.[Year]
	,FSY.FeesSessionYearId AS FeesMonthId
	,(SELECT ISNULL(( CASE WHEN COUNT(S.FeesStudentId)>0 THEN 1 ELSE 0 END),0) FROM dbo.Fees_Student S WHERE ProcessId = FPD.ProcessId AND FeesSessionYearId = FPD.SessionYearId  AND IsPaid=1) AS IsCollectionChecked
	,(SELECT ISNULL(( CASE WHEN COUNT(S.FeesStudentId)>0 THEN 1 ELSE 0 END),0) FROM dbo.Fees_Student S WHERE ProcessId = FPD.ProcessId AND FeesSessionYearId = FPD.SessionYearId ) AS IsProcessChecked
	,(SELECT ISNULL(( CASE WHEN COUNT(S.FeesStudentId)>0 THEN 1 ELSE 0 END),0) FROM dbo.Fees_Student S WHERE ProcessId = FPD.ProcessId AND FeesSessionYearId = FPD.SessionYearId AND IsPublished=1) AS IsProcessPub
	,(SELECT ISNULL(( CASE WHEN COUNT(S.FeesStudentId)>0 THEN 1 ELSE 0 END),0) FROM dbo.Fees_Student S WHERE ProcessId = FPD.ProcessId AND FeesSessionYearId = FPD.SessionYearId AND IsLatePay=1) AS IsProcessAutoMatedChecked
	,(SELECT ISNULL(( CASE WHEN COUNT(S.FeesStudentId)>0 THEN 1 ELSE 0 END),0) FROM dbo.Fees_Student S WHERE ProcessId = FPD.ProcessId AND FeesSessionYearId = FPD.SessionYearId AND IsLatePayPublished = 1) AS IsLateProcessPub --Add By Khaled
	,FM.[MonthName] + ' ( ' + CAST(FSY.[Year] AS VARCHAR ) + ' )'  AS [MonthName]
	FROM 
	dbo.Fees_Process FP  
	INNER JOIN dbo.Fees_ProcessDetails FPD ON FP.FeesProcessId = FPD.ProcessId
	INNER JOIN   Fees_FiscalSession FS ON FP.SessionId = FS.FeesFiscalSessionId
	INNER JOIN Fees_FeesSessionYear FSY ON FSY.FeesSessionYearId = FPD.SessionYearId
	INNER JOIN Fees_FeesMonth FM ON FM.FeesMonthId = FSY.MonthId
 
 
	WHERE FP.FeesProcessId = @ProcessTypeId 
	 END

	 	 if(@Block=17) -- get common head
	BEGIN
	 SELECT H.*,C.*, NULL AS Amount FROM Fees_Head H INNER JOIN Fees_Category C ON H.[CategoryId] = C.FeesCategoryId
	 Where H.AccCode1 IS NOT NULL AND H.AccCode2 IS NOT NULL AND C.FeesCategoryId=1 
	 
	 ORDER BY H.FeesHeadId DESC
	 END
	END

	-- SELECT * FROM Fees_FeesSessionYear

--Drop table [TEST_DB].[dbo].[Fees_HeadAmountConfig]

		
	
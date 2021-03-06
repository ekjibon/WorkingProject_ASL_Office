
/****** Object:  StoredProcedure [dbo].[GetStudentInfoByFilter]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptStudentCollection]'))
BEGIN
DROP PROCEDURE  rptStudentCollection
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
---[dbo].rptStudentCollection '1=1   AND  SB.SessionId  IN (11)    AND  SB.BranchID  IN (8)    AND  SB.ShiftID  IN (2)    AND  SB.ClassId  IN (19)    AND  SB.SectionId  IN (76)    AND CM.IsEnrollment = 0   '  
Create PROCEDURE [dbo].rptStudentCollection -- Total 11 param


@Where varchar(MAX) = NULL
AS
BEGIN           
DECLARE @sql varchar(max)
create table #studentlist
(
SessionName varchar(max)
 ,BranchName varchar(max)
 ,ShiftName varchar(max)
 ,ClassName varchar(max)

 ,SectionName varchar(max)
,[StudentIID] int not null
,[RollNo] int not null
,[StudentInsID] int not null

 ,FullName varchar(max)
 ,MonthId int
 ,MonthName varchar(max)
 ,Year int
 ,Amount decimal(10,2)
 ,CollAmnt decimal(10,2)
 ,PaymentDate varchar(max)
 ,BankCollectionDate varchar(max)
 ,PCS_BankName varchar(max)
 ,PaymentType varchar(max)
 ,FeesHeadId int
 ,HeadName varchar(max)
 ,AdvAmnt decimal(10,2)

)



SET @sql = '	
   insert into #studentlist
		SELECT distinct s.SessionName ,b.BranchName ,sh.ShiftName ,c.ClassName ,sc.SectionName,
		 sb.StudentIID,cast(sb.RollNo AS INT) RollNo, sb.StudentInsID, sb.FullName, 
		CD.MonthId,
		FM.MonthName AS MonthName ,
		CD.Year, CD.ReceiveAmount As Amount, CM.TotalAmount As CollAmnt
		, STUFF(
             (SELECT '', '' + CAST(CAST(MC.PaymentDate AS DATE) AS VARCHAR(125))
              FROM Fees_CollectionMaster MC 
              WHERE MC.MonthId = CM.MonthId AND MC.StudentIID = CM.StudentIID
			  GROUP BY MC.MonthId,MC.PaymentDate 
              FOR XML PATH (''''))
             , 1, 1, '''') AS PaymentDate
		,STUFF(
             (SELECT '', '' + CAST(CAST(MC.BankCollectionDate AS DATE) AS VARCHAR(125))
              FROM Fees_CollectionMaster MC 
              WHERE MC.MonthId = CM.MonthId AND MC.StudentIID = CM.StudentIID
			  GROUP BY MC.MonthId,MC.BankCollectionDate 
              FOR XML PATH (''''))
             , 1, 1, '''') AS BankCollectionDate
		,cm.PCS_BankName,
		(CASE WHEN CM.PaymentType=1 THEN ''CASH'' WHEN CM.PaymentType=2 THEN ''CHEQUE'' WHEN CM.PaymentType=3 THEN ''ONLINE'' ELSE '''' END ) AS PaymentType,
		H.[FeesHeadId] , H.[HeadName],0
		FROM Fees_CollectionMaster CM 	 
		INNER JOIN Fees_CollectionDetails CD ON CM.Id= CD.MasterID 
		INNER JOIN 
		dbo.Student_BasicInfo sb ON sb.StudentIID = CM.StudentIID
		
		 left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
		 left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
		 left outer join dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId
		 left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
		
		 left outer join dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
		 INNER JOIN [dbo].[Fees_FeesMonth] FM ON FM.FeesMonthId = CD.MonthId
		 INNER JOIN Fees_Head H ON H.FeesHeadId = CD.HeadId
		--left JOIN dbo.Fees_Student FS ON FS.StudentIID =  CM.StudentIID AND FS.AdvanceAmount <> 0 AND FS.HeadId = H.FeesHeadId
		--				AND CM.MonthId = FS.MonthId  AND FS.Year = CD.Year

	    
		  '
	 IF(@Where IS NOT NULL and  @Where <> '') --
	 BEGIN
     SET @sql = @sql + ' WHERE '+ @Where 
	 END
	 SET @sql=@sql + '
		 UPDATE stu SET stu.AdvAmnt = ISNULL((SELECT TOP(1) FS.AdvanceAmount FROM dbo.Fees_Student FS WHERE FS.StudentIID =  stu.StudentIID AND FS.AdvanceAmount <> 0 ),0) FROM #StudentList AS stu
				--LEFT JOIN dbo.Fees_Student FS ON FS.StudentIID =  stu.StudentIID 

	 select * from #StudentList  
	 '
	 PRINT(@sql)

	--SET @sql = @sql + '  ORDER BY cast(sb.RollNo AS INT) MonthId'
	  EXEC(@sql)
END


	--- EXEC rptStudentCollection '   SB.VersionID  IN (1)    AND  SB.SessionId  IN (1)   AND cm.PaymentDate = CAST('5/9/2018 12:00:00 AM' AS Date)'
	----,(select StudentTypeName from Ins_StudentType where StudentTypeId=sb.StudentTypeID) as StudentTypeName

	-- SELECT * FROM Fees_CollectionDetails
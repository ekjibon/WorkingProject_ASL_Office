IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentInfoForFeesDynamicSMS]'))
BEGIN
DROP PROCEDURE  GetStudentInfoForFeesDynamicSMS
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create PROCEDURE [dbo].[GetStudentInfoForFeesDynamicSMS] -- Total 7 param
(
	@Block INT,
	@Where NVARCHAR(MAX)=NULL,
	@SmsBody NVARCHAR(MAX) = NULL,
	@MonthsId NVARCHAR(100) = NULL,	
	@SessionMonth NVARCHAR(MAX)=NULL,
	@FeesHead INT = NULL,
	@Total BIT = NULL	
)
AS
BEGIN
	DECLARE @sql varchar(max)
	--DECLARE @FeesHead INT =7
	--DECLARE @TOTAL1 BIT=1
	--DECLARE @SmsBody vARCHAR(MAX)='ALSJFLKAJSDKFLKASJ ADJFLKSDAJLKF [StudentName] FDASDF  [DueAmount] DAFAS [Month] fads [HeadName]'
	

			create table #StudentSms
			(
			 StudentIID bigint not null
			,StudentInsID NVARCHAR(160) not null
			,FullName varchar(200) null
			,RollNo int not null
			,DestinationNumber NVARCHAR(100) NULL
			,SmsBody NVARCHAR(max) not null
			,NoOfSms int null
			,SmsLength int null
			,TotalSms int not null			
			,IsSms BIT			
			)

			create table #StudentList
			(
			 [StudentIID] bigint not null
			
			,[SessionId] int not null
			,[BranchID] int not null
			,[ShiftID] int not null
			,[ClassId] int not null
			
			,[SectionId] int not null
					
			,SessionName Varchar(100) Null
			,BranchName Varchar(100) Null
			,ShiftName Varchar(100) Null
			,ClassName Varchar(100) Null
			
			,SectionName Varchar(100) Null
			,StudentTypeName Varchar(100) Null
			,[StudentInsID] NVARCHAR(160) not null
			,[FullName] varchar(200) null
			,[RollNo] int not null
			,DestinationNumber NVARCHAR(100) NULL
			,IsSms BIT
			--,SmsBody NVARCHAR(MAX) NULL
			)
			CREATE TABLE #FessSessionYear
			(	
			FessSessionYearID INT	null			
			)

			CREATE TABLE #FessTotalCollection
			(	
			[StudentIID] INT null,
			ReceivedAmount int null,				
			)		
			CREATE TABLE #FessHeadCollection
			(	
			MasterID INT null,
			ReceivedAmount int null,
			FeesHead Varchar(50) null				
			)

		
				
				SET @sql = 'INSERT INTO #StudentList 
								SELECT SB.[StudentIID], SB.[SessionId], SB.[BranchID], SB.[ShiftID], SB.[ClassId],  SB.[SectionId], 
								
								(SELECT SessionName FROM Ins_Session WHERE SessionId=SB.SessionId),
								(SELECT BranchName FROM Ins_Branch WHERE BranchId=SB.BranchID),
								(SELECT ShiftName FROM Ins_Shift WHERE ShiftId=SB.ShiftID),
								(SELECT ClassName FROM Ins_ClassInfo WHERE ClassId=SB.ClassId),
								
								(SELECT SectionName FROM Ins_Section WHERE SectionId=SB.SectionId),
								(SELECT StudentTypeName FROM Ins_StudentType WHERE StudentTypeId=SB.StudentTypeID),
								SB.[StudentInsID], SB.[FullName], SB.[RollNo], SB.[SMSNotificationNo] AS DestinationNumber, 0 
							    FROM [dbo].[Student_BasicInfo] AS SB '
					PRINT(@sql)
				 IF(@Where IS NOT NULL and  @Where <> '')
				 BEGIN
					SET @sql = @sql + ' WHERE '+ @Where
				 END
					 SET @sql = @sql + '  ORDER BY SB.[StudentIID], SB.[ClassId], SB.[SectionId], SB.RollNo'
					EXEC(@sql)

				

		
			 
			
				--For Month
					declare @Months Varchar(50)=NULL
					--declare	@ToDate varchar(max)='FS.FeesMonthId in(1,5,6,7,9)'
					--declare @SessionMonth1 VARCHAR(mAX)='FS.IsDeleted = 0   AND  FS.MonthId  IN (1,2,3,4,5,6,7,8,9,10,11)    AND  FS.SessionId  IN (6)'
							CREATE TABLE #Months1
							(
							Months Varchar(50)
							)
							CREATE TABLE #Months2
							(
							Months Varchar(50)
							)
							declare @msql NVARCHAR(MAX)=null;
							set @msql='insert into #Months1 Select top 1 Code from Fees_FeesMonth FS '
							set @msql=@msql+' where ' + @MonthsId  
							EXEC(@msql)
							set @msql='';
							set @msql='insert into #Months2 Select top 1 Code from Fees_FeesMonth FS '
							set @msql=@msql+' where ' + @MonthsId											
							set @msql=@msql+' order by FS.FeesMonthId desc'
							EXEC(@msql)
							select @Months=#Months1.Months+'-'+#Months2.Months from #Months1,#Months2
							---select @Months
							drop table #Months1,#Months2
				--For Month
	
				
						Declare @fSql NVARCHAR(MAX)
						SET @fSql = 'INSERT INTO #FessSessionYear SELECT [FeesSessionYearId] FROM [Fees_FeesSessionYear] AS FS '
							PRINT(@fSql)
						 IF(@SessionMonth IS NOT NULL AND  @SessionMonth <> '')
						 BEGIN
							SET @fSql = @fSql + ' WHERE '+ @SessionMonth
						 END
						 --select @fSql				 
							EXEC(@fSql)
							--select * from #FessSessionYear
							IF(@Block=5)
							BEGIN
									IF(@FeesHead=0 AND @TOTAL=1) -- fOR TOTAL DUE
									BEGIN
							
												--select @FeesHead, @Total
												SELECT [StudentIID], SUM([DueAmount]) AS DueAmount,SUM(AdvanceAmount) AS AdvanceAmount,SUM(PaidAmount) AS PaidAmount INTO #FTD FROM [Fees_Student] WHERE FeesSessionYearId IN
												(SELECT [FeesSessionYearId] FROM  #FessSessionYear)  AND StudentIID IN
												(SELECT [StudentIID] FROM #Studentlist) AND IsCompleted=0 AND IsDeleted=0  GROUP BY StudentIID
												--select * from #FTD
												--SELECT DISTINCT S.StudentIID,S.VersionID,S.SessionId,S.BranchID,S.ShiftID,S.ClassId,S.GroupId,S.SectionId,S.StudentInsID,
												--S.FullName,S.RollNo,S.DestinationNumber,
												--REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',FullName),'[DueAmount]', CAST(ROUND(A.DueAmount,0) AS INT)),'[Month]',@Months) AS SmsBody 
												--FROM #Studentlist S INNER JOIN #FTD A ON S.StudentIID=A.StudentIID

											INSERT INTO #StudentSms
											SELECT DISTINCT S.StudentIID, S.StudentInsID, S.FullName, S.RollNo, S.DestinationNumber,
											REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID),'[Session]',S.SessionName),'[Branch]',S.BranchName),'[Shift]',ISNULL(S.ShiftName,'')),'[Class]',ISNULL(S.ClassName,'')),'[Section]',ISNULL(S.SectionName,'')),'[StudentType]',ISNULL(S.StudentTypeName,'')),
											'[Month]',ISNULL(@Months,'')),'[Due]',CAST(ROUND(A.DueAmount,0) AS INT)),'[Adanvance]',ISNULL( CAST(ROUND(A.AdvanceAmount,0) AS INT),0)),'[Receive]',ISNULL( CAST(ROUND(A.PaidAmount,0) AS INT),0))
											--REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',FullName),'[DueAmount]', CAST(ROUND(A.DueAmount,0) AS INT)),'[Month]',@Months)
											AS SmsBody, 
											0,0,0,0 FROM #Studentlist S INNER JOIN #FTD A ON S.StudentIID=A.StudentIID

											UPDATE S SET NoOfSms=(SELECT [dbo].[SMSCounter](M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID),
											SmsLength= (SELECT LEN(M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID)		
											FROM #StudentSms AS S

											UPDATE S SET TotalSms=(SELECT SUM(NoOfSms) FROM #StudentSms AS M )	FROM #StudentSms AS S
											SELECT * FROM #StudentSms
											DROP TABLE #FTD

									END
										ELSE
									BEGIN
											 SELECT [StudentIID],(SELECT F.HeadCode FROM Fees_Head AS F WHERE F.FeesHeadId=HeadId) AS HeadCode,
											  SUM([DueAmount]) AS DueAmount INTO #FHD FROM [Fees_Student] WHERE FeesSessionYearId IN
												(SELECT [FeesSessionYearId] FROM  #FessSessionYear)  AND StudentIID IN
												 (SELECT [StudentIID] FROM #Studentlist) AND IsCompleted=0 AND IsDeleted=0 AND HeadId=@FeesHead  GROUP BY StudentIID,HeadId

												 --select * from #FHD

											 --SELECT DISTINCT S.StudentIID,S.VersionID,S.SessionId,S.BranchID,S.ShiftID,S.ClassId,S.GroupId,S.SectionId,S.StudentInsID,
												--S.FullName,S.RollNo,S.DestinationNumber,
												-- REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',FullName),'[DueAmount]', CAST(ROUND(A.DueAmount,0) AS INT)),'[HeadName]',A.HeadCode),'[Month]',@Months) AS SmsBody 
												--FROM #Studentlist S INNER JOIN #FHD A ON S.StudentIID=A.StudentIID

												INSERT INTO #StudentSms
											SELECT S.StudentIID, S.StudentInsID, S.FullName, S.RollNo, S.DestinationNumber,
											REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID),'[Session]',S.SessionName),'[Branch]',S.BranchName),'[Shift]',S.ShiftName),'[Class]',S.ClassName),'[Section]',S.SectionName),'[StudentType]',S.StudentTypeName),
											'[Month]',@Months),'[Due]',CAST(ROUND(A.DueAmount,0) AS INT)),'[HeadName]',A.HeadCode)
											--REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',FullName),'[DueAmount]', CAST(ROUND(A.DueAmount,0) AS INT)),'[HeadName]',A.HeadCode),'[Month]',@Months) 
											AS SmsBody, 
											0,0,0,0 FROM #Studentlist S INNER JOIN #FHD A ON S.StudentIID=A.StudentIID
		
											UPDATE S SET NoOfSms=(SELECT [dbo].[SMSCounter](M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID),
											SmsLength= (SELECT LEN(M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID)		
											FROM #StudentSms AS S

											UPDATE S SET TotalSms=(SELECT SUM(NoOfSms) FROM #StudentSms AS M )	FROM #StudentSms AS S
											SELECT * FROM #StudentSms
												DROP TABLE #FHD
									END
							END
							IF(@Block=6)
							BEGIN
								IF(@FeesHead=0 AND @Total=1)
								BEGIN
												Declare @fTotalCollectionSql NVARCHAR(MAX)
												SET @fTotalCollectionSql = 'INSERT INTO #FessTotalCollection SELECT  FS.[StudentIID], 
																			SUM(FS.[ReceivedAmount]) AS ReceivedAmount  FROM [Fees_CollectionMaster] FS '
													PRINT(@fTotalCollectionSql)
												 IF(@SessionMonth IS NOT NULL AND  @SessionMonth <> '')
												 BEGIN
													SET @fTotalCollectionSql = @fTotalCollectionSql + ' WHERE '+ @SessionMonth
													SET @fTotalCollectionSql = @fTotalCollectionSql +' AND FS.StudentIID IN(SELECT StudentIID FROM #StudentList) GROUP BY StudentIID'
												 END				 
													EXEC(@fTotalCollectionSql)
													-- SELECT DISTINCT S.StudentIID,S.VersionID,S.SessionId,S.BranchID,S.ShiftID,S.ClassId,S.GroupId,S.SectionId,S.StudentInsID,
													--S.FullName,S.RollNo,S.DestinationNumber,
													--REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',FullName),'[DueAmount]', CAST(ROUND(A.ReceivedAmount,0) AS INT)),'[Month]',@Months) AS SmsBody 
													--FROM #Studentlist S INNER JOIN #FessTotalCollection A ON S.StudentIID=A.StudentIID

													INSERT INTO #StudentSms
												SELECT DISTINCT S.StudentIID, S.StudentInsID, S.FullName, S.RollNo, S.DestinationNumber,
												REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID),'[Session]',S.SessionName),'[Branch]',S.BranchName),'[Shift]',S.ShiftName),'[Class]',S.ClassName),'[Section]',S.SectionName),'[StudentType]',S.StudentTypeName),
											    '[Month]',@Months),'[Receive]', CAST(ROUND(A.ReceivedAmount,0) AS INT))
												--REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',FullName),'[DueAmount]', CAST(ROUND(A.ReceivedAmount,0) AS INT)),'[Month]',@Months)
												AS SmsBody, 
												0,0,0,0 FROM #Studentlist S INNER JOIN #FessTotalCollection A ON S.StudentIID=A.StudentIID
		
												UPDATE S SET NoOfSms=(SELECT [dbo].[SMSCounter](M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID),
												SmsLength= (SELECT LEN(M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID)		
												FROM #StudentSms AS S

												UPDATE S SET TotalSms=(SELECT SUM(NoOfSms) FROM #StudentSms AS M )	FROM #StudentSms AS S
												SELECT * FROM #StudentSms
							

				
											--#FessTotalCollection
											--INSERT INTO #FessTotalCollection SELECT  FS.[StudentIID], SUM(FS.[ReceivedAmount]) AS ReceivedAmount    
											--FROM [Fees_CollectionMaster] FS WHERE FS.SessionId IN (6,25,26) AND FS.MonthId IN (1,5,6,7,9) 
											--AND FS.StudentIID IN(SELECT StudentIID FROM #StudentList) GROUP BY StudentIID
								END
									ELSE
								BEGIN
												Declare @fHeadCollectionSql NVARCHAR(MAX)
												SET @fHeadCollectionSql = 'INSERT INTO #FessHeadCollection SELECT D.MasterID, SUM(D.ReceiveAmount), 
																		(SELECT TOP 1 H.HeadCode FROM Fees_Head AS H WHERE H.FeesHeadId=D.HeadId) AS FN 
																		FROM Fees_CollectionDetails AS D WHERE D.IsDeleted=0 AND D.MasterID IN( SELECT Id FROM [Fees_CollectionMaster] FS '
													PRINT(@fHeadCollectionSql)
												 IF(@SessionMonth IS NOT NULL AND  @SessionMonth <> '')
												 BEGIN
													SET @fHeadCollectionSql = @fHeadCollectionSql + ' WHERE '+ @SessionMonth
													SET @fHeadCollectionSql = @fHeadCollectionSql +'  AND FS.IsDeleted=0 AND FS.StudentIID IN(SELECT StudentIID FROM #Studentlist)  ) AND HeadId=@FeesHead GROUP BY D.MasterID, D.HeadId'
												 END				 
													EXEC(@fTotalCollectionSql)
						
												SELECT FC.ReceivedAmount, FC.FeesHead, M.StudentIID INTO #FCH FROM #FessHeadCollection FC INNER JOIN [Fees_CollectionMaster] AS M ON FC.MasterID=M.Id AND M.IsDeleted=0

												 -- SELECT DISTINCT S.StudentIID,S.VersionID,S.SessionId,S.BranchID,S.ShiftID,S.ClassId,S.GroupId,S.SectionId,S.StudentInsID,
													--S.FullName,S.RollNo,S.DestinationNumber,
													-- REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',FullName),'[DueAmount]', CAST(ROUND(A.ReceivedAmount,0) AS INT)),'[DueAmount]',A.FeesHead),'[Month]',@Months) AS SmsBody 
													--FROM #Studentlist S INNER JOIN #FCH A ON S.StudentIID=A.StudentIID 

												INSERT INTO #StudentSms
											SELECT DISTINCT S.StudentIID, S.StudentInsID, S.FullName, S.RollNo, S.DestinationNumber,
											REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID),'[Session]',S.SessionName),'[Branch]',S.BranchName),'[Shift]',S.ShiftName),'[Class]',S.ClassName),'[Section]',S.SectionName),'[StudentType]',S.StudentTypeName),
											'[Month]',@Months),'[Receive]', CAST(ROUND(A.ReceivedAmount,0) AS INT)),'HeadName',A.FeesHead)
											--REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',FullName),'[DueAmount]', CAST(ROUND(A.ReceivedAmount,0) AS INT)),'[DueAmount]',A.FeesHead),'[Month]',@Months)
											
											AS SmsBody , 
											0,0,0,0 FROM #Studentlist S INNER JOIN #FCH A ON S.StudentIID=A.StudentIID 
		
											UPDATE S SET NoOfSms=(SELECT [dbo].[SMSCounter](M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID),
											SmsLength= (SELECT LEN(M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID)		
											FROM #StudentSms AS S

											UPDATE S SET TotalSms=(SELECT SUM(NoOfSms) FROM #StudentSms AS M )	FROM #StudentSms AS S
											SELECT * FROM #StudentSms
													DROP TABLE #FCH
										  --SELECT D.MasterID, SUM(D.ReceiveAmount), 
										  --(SELECT TOP 1 H.HeadCode FROM Fees_Head AS H WHERE H.FeesHeadId=D.HeadId) AS FN FROM Fees_CollectionDetails AS D WHERE D.MasterID IN(
										  --SELECT Id FROM [Fees_CollectionMaster] FS WHERE FS.SessionId IN (6,25,26) AND FS.MonthId IN (1,5,6,7,9)
										  -- AND FS.StudentIID IN(SELECT StudentIID FROM #Studentlist)  ) AND HeadId=@FeesHead GROUP BY D.MasterID, D.HeadId
					
								END

							END
			
			
		--select * from #StudentList 
	drop table  #Studentlist,#FessSessionYear,#FessHeadCollection, #FessTotalCollection
END


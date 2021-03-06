
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetResultSetup]'))
BEGIN
DROP PROCEDURE  rptGetResultSetup
END
GO
Create proc [dbo].[rptGetResultSetup]
(
	@BranchID INT=NULL,
	@SessionID INT=NULL,
	@ClassID INT=NULL,
	@BlockNo INT

)
AS
BEGIN
	IF(@BlockNo=1)-- [rptGetResultSetup] Null,1,6,Null,Null,1
	BEGIN
		-- Report Controller SubjectSetup 
		SELECT DISTINCT C.SessionName
                          ,C.ClassName
                          ,C.ClassId
                         
                          ,SubjectName as  ShortName
                          --,ShortName as ShortNa
                          ,SubjectCode
                          ,ReportSerialNo
                      
                          ,SpecialSubject
                      
						  ,IsCompulsory
                          ,IsSelective
                         ,IsPair
                         -- ,(SELECT ISNULL([SubjectName],'') FROM [Res_SubjectSetup] WHERE SubID=S.[FirstPairSubID]) AS [FirstPairSubID] 
                          --,(SELECT ISNULL([SubjectName],'') FROM [Res_SubjectSetup] WHERE SubID=S.[SecondPairSubID]) AS [SecondPairSubID]      
                      FROM [Res_SubjectSetup]
                      AS S INNER JOIN [view_CommonTableNames] AS C ON  S.SessionId=C.SessionId AND S.ClassId=C.ClassId 
                      where  S.SessionId=@SessionID AND S.IsDeleted=0 ORDER BY C.ClassId
	END
	ELSE IF(@BlockNo=2)-- [rptGetResultSetup] 1,1,1,3,0,2
	BEGIN
		-- Report Controller SubjectProcessReport 
		SELECT DISTINCT
                          C.SessionName
                          ,C.ClassName
                         
						  ,C.SectionName
						  ,SB.StudentInsID
						  ,SB.FullName
						  ,SB.RollNo
                          ,SubjectName,SS.SubjectID                                              
						  ,SS.SubjectType     
                      FROM Res_StudentSubject AS SS
					  INNER JOIN [Res_SubjectSetup] AS S ON SS.SubjectID=S.SubID
					  INNER JOIN [view_CommonTableNames] AS C ON   S.SessionId=C.SessionId AND S.ClassId=C.ClassId 
					  LEFT OUTER JOIN Student_BasicInfo SB ON SB.StudentIID=SS.StudentID
                      WHERE  SB.SessionId=@SessionID AND SB.BranchID=@BranchID AND SB.ClassId=@ClassID
					  AND  SB.IsDeleted=0 AND SS.IsDeleted=0 AND S.IsDeleted=0 ORDER BY SB.RollNo	END
	ELSE IF(@BlockNo=3) -- [rptGetResultSetup] Null,1,1,Null,Null,2
	BEGIN
		-- Report Controller FourthSubjectRulesReport 
		SELECT DISTINCT FS.ClassId,  C.SessionName, C.ClassName, FS.[IsFailImpact], FS.[DeductMarks], FS.[DeductGP], FS.[AttendancePassFailimpact]
                      FROM [Res_FouthSubjectRules] AS FS					
					  INNER JOIN [view_CommonTableNames] AS C ON  FS.SessionId=C.SessionId AND FS.ClassId=C.ClassId 		 
                      WHERE  FS.SessionId=@SessionID AND FS.IsDeleted=0 ORDER BY FS.ClassId
	END
	ELSE IF(@BlockNo=4)-- [rptGetResultSetup] Null,1,1,Null,Null,4
	BEGIN
		  -- Report Controller RoundingRuleReport
		  SELECT DISTINCT MG.ClassId, C.SessionName, C.ClassName,
					  CASE WHEN MG.[BodyCalculationRule]='C' THEN 'Celling' WHEN MG.[BodyCalculationRule]='F' THEN 'Floor' WHEN MG.[BodyCalculationRule]='R' THEN 'Round'  WHEN MG.[BodyCalculationRule]='O' THEN 'Original' END AS BodyCalculationRule,
					  CASE WHEN MG.[TotalCalculatuonRule]='C' THEN 'Celling' WHEN MG.[TotalCalculatuonRule]='F' THEN 'Floor' WHEN MG.[TotalCalculatuonRule]='R' THEN 'Round'  WHEN MG.[TotalCalculatuonRule]='O' THEN 'Original' END AS TotalCalculatuonRule 
					  FROM [Res_MarksMigratedSetup] AS MG					
					  INNER JOIN [view_CommonTableNames] AS C ON  MG.SessionId=C.SessionId AND MG.ClassId=C.ClassId					 
                      WHERE  MG.SessionId=@SessionID AND MG.IsDeleted=0 ORDER BY MG.ClassId
	END
	ELSE IF(@BlockNo=5) -- [rptGetResultSetup] Null,Null,Null,Null,Null,5
	BEGIN
		-- Report Controller ReportConfigurReport
		SELECT ReportConfigId ,RC.ClassId, C.ClassName, R.ReportName ,RC.[ReportId],
		(CASE WHEN RC.[Type] = 'M' THEN 'Main  Exam' WHEN RC.[Type] = 'S' THEN 'SUb Exam' WHEN RC.[Type] = 'G' THEN 'Grand Result' END) AS Exam 
        FROM [dbo].[Res_ReportConfig] RC INNER JOIN Ins_ClassInfo C ON C.[ClassId] = RC.[ClassId]
		INNER JOIN [dbo].[Res_Reports] R ON R.ReportId = RC.ReportId  order by RC.ClassId
		End
	ELSE IF(@BlockNo=6) -- [rptGetResultSetup] Null,1,6,Null,Null,6
	BEGIN
		-- Report Controller MainExamReport
	SELECT DISTINCT M.MainExamId, S.SubExamId, M.ClassId, C.ClassName, 
	  C.SessionName, 
	  M.MainExamName, 
	  S.SubExamName, 
	  M.MainExamGrandShowOrder
	
	  FROM Res_MainExam AS M  
	  LEFT JOIN Res_SubExam AS S ON S.MainExamId=M.MainExamId AND S.IsDeleted=0
	
	  LEFT JOIN [view_CommonTableNames] AS C ON M.SessionId=C.SessionId AND M.ClassId=C.ClassId 
	  WHERE  M.SessionId=@SessionID AND M.IsDeleted=0   ORDER BY M.ClassId, M.MainExamId, S.SubExamName END
	ELSE IF(@BlockNo=7) -- [rptGetResultSetup] Null,1,1,Null,Null,7
	BEGIN
		-- Report Controller HighestMarkSetupReport
		SELECT M.ClassId,C.ClassName
		,Se.SessionName ,S.SectionName
		,BranchWise
		,VersionWise
		,ClassWise
		,ShiftWise
		,SectionWise 
		,IsGrand
		,IsFrac
		FROM Res_HighestMarkConfig AS M		
		inner join Ins_ClassInfo as C on C.ClassId=M.ClassId

		inner join Ins_Session as Se on Se.SessionId=M.SessionId

		left join Ins_Section as S on S.SectionId=M.SessionId
		WHERE  M.SessionId=@SessionID AND M.IsDeleted=0  
	END
	ELSE IF(@BlockNo=8) -- [rptGetResultSetup] Null,1,1,Null,Null,8
	BEGIN
		-- Report Controller MeritListConfigReport
		SELECT DISTINCT S.SessionName , C.ClassName
      ,BranchWise
      ,M.[ClassId]

      ,[SortSerialByGPAWith4th] as GPAWith4Subject
      ,[SortSerialByGPAWithout4th] as GPAWithout4Subject
      ,[SortSerialByTotalMark] as TotalMark
      ,[SortSerialByRoll] as Roll
      ,[SortSerialByName] as Names
      ,TotalMarkSameMerit
      ,TotalIsFraction
	  --,[SubjectId1]
      ,[SortSerialBySubjectId1] as  Subject1
      --,[SubjectId2]
      ,[SortSerialBySubjectId2] as Subject2
      --,[SubjectId3]
      ,[SortSerialBySubjectId3] as Subject3
	  
FROM [dbo].[Res_MeritListConfig] M  INNER JOIN [dbo].[Ins_Session] S ON S.[SessionId] = M.[SessionId]
											 INNER JOIN [dbo].[Ins_ClassInfo] C ON C.[ClassId] = M.ClassId
											 
									
			WHERE  M.SessionId =  @SessionId 
	END

	ELSE IF(@BlockNo=9) -- [rptGetResultSetup] Null,1,1,Null,Null,9
	BEGIN
		-- Report Controller GradePolicyReport
		SELECT  S.SessionName , C.ClassName
	   ,G.ClassID,G.GL as LetterGrade,G.GP,IsFailGrade,Comments
	   ,G.Marks_From,G.Marks_To
		FROM [dbo].[Res_GradingSystem] G 

		INNER JOIN [dbo].[Ins_Session] S ON S.[SessionId] = G.[SessionId]
		INNER JOIN [dbo].[Ins_ClassInfo] C ON C.[ClassId] = G.ClassId
		WHERE  G.SessionId =  @SessionId 
	END
	ELSE IF(@BlockNo=10) -- [rptGetResultSetup] Null,1,1,Null,Null,10
	BEGIN
		-- Report Controller TabConfigReport
		SELECT  m.ClassId,c.ClassName,T.MainExamId,T.SubExamId,m.MainExamName,s.SubExamName,
		se.SessionName,
		T.WrittenObt1
		,T.WrittenConv1
		,T.WrittenFrac1,
		T.WrittenObt2
		,T.WrittenConv2
		,T.WrittenFrac2
		,T.WrittenObt3
		,T.WrittenConv3
		,T.WrittenFrac3,
		T.SubjectiveObt
		,T.SubjectiveConv
		,T.SubjectiveFrac,
		T.ObjectiveObt
		,T.ObjectiveConv
		,T.ObjectiveFrac,
		T.PracticalObt
		,T.PracticalConv
		,T.PracticalFrac,
		T.SubExamTotalObt
		,T.SubExamTotalConv
		,T.SubExamTotalFrac,
		T.SubjectObtMarks
		,T.SubjectConvertedMarks,
		T.Virtual1
		,T.Virtual2,
		T.SubjectGL
		,T.SubjectGP
		
	
		FROM [dbo].[Res_TabConfig] T 
		inner join Res_MainExam m on m.MainExamId=T.MainExamId
		inner join Res_SubExam s on s.SubExamId=T.SubExamId
		inner join Ins_ClassInfo c on c.ClassId=m.ClassId
	
		inner join Ins_Session se on se.SessionId=m.SessionId
		where m.SessionId=@SessionID and (m.ClassId=@ClassID or @ClassID is null) order by ClassId
	END
	ELSE IF(@BlockNo=11) -- [rptGetResultSetup] Null,1,1,Null,Null,11
	BEGIN
		-- Report Controller GrandExamListReport
		SELECT DISTINCT M.GrandExamId, M.ClassId,  C.ClassName,
		C.SessionName, 
		M.GrandExamName
			FROM Res_GrandExam AS M		
		
		
		INNER JOIN [view_CommonTableNames] AS C ON M.SessionId=C.SessionId AND M.ClassId=C.ClassId 	
		WHERE  M.SessionId=@SessionID AND M.IsDeleted=0 ORDER BY M.ClassId, M.GrandExamId
	END
	ELSE IF(@BlockNo=12) -- [rptGetResultSetup] Null,1,1,Null,Null,12
	BEGIN
		-- Report Controller GrandExamVertualReport   
		SELECT V.VersionName,S.SessionName,C.ClassName,sub.SubjectName
		,G.ClassId,
		CASE WHEN G.DivExamTypeVirtual1='S' THEN 'Subjective' WHEN G.DivExamTypeVirtual1='O' THEN 'Objective' 
		WHEN G.DivExamTypeVirtual1='P' THEN 'Practical' WHEN G.DivExamTypeVirtual1='W1' THEN 'Written-1'
		WHEN G.DivExamTypeVirtual1='W2' THEN 'Written-2' WHEN G.DivExamTypeVirtual1='W3' THEN 'Written-3'
	    ELSE ' ' END AS DivExamTypeVirtual1
		,CASE WHEN G.DivExamTypeVirtual2='S' THEN 'Subjective' WHEN G.DivExamTypeVirtual2='O' THEN 'Objective' 
		WHEN G.DivExamTypeVirtual2='P' THEN 'Practical' WHEN G.DivExamTypeVirtual2='W1' THEN 'Written-1'
		WHEN G.DivExamTypeVirtual2='W2' THEN 'Written-2' WHEN G.DivExamTypeVirtual2='W3' THEN 'Written-3'
	    ELSE ' ' END AS DivExamTypeVirtual2
		,G.GrandSubExamName
		,CASE WHEN G.VirtualPassMark1= 0.00 THEN null ELSE G.VirtualPassMark1 END AS VirtualPassMark1
		,CASE WHEN G.VirtualPassMark2= 0.00 THEN null ELSE G.VirtualPassMark2 END AS VirtualPassMark2
		,VirtualPassMarkIsPercent1
		,VirtualPassMarkIsPercent2
		FROM Res_GrandVirtualExamSetup  G 
		INNER JOIN [dbo].[Ins_Version] V ON  V.[VersionId] = G.VersionId 
		INNER JOIN [dbo].[Ins_Session] S ON S.[SessionId] = G.SessionId
		INNER JOIN [dbo].[Ins_ClassInfo] C ON C.[ClassId] = G.ClassId
		INNER JOIN Ins_Group gr ON gr.GroupId=G.GroupId
		Left JOIN [Res_SubjectSetup] sub ON sub.SubID=G.SubjectID
		WHERE  G.SessionId =  @SessionId  ORDER BY G.ClassId
	END
	ELSE IF(@BlockNo=13) -- [rptGetResultSetup] Null,1,1,Null,Null,13
	BEGIN
		-- Report Controller   GrandMeritconfigReport
		SELECT V.VersionName,S.SessionName,C.ClassName,C.ClassId,gr.GroupName,main.MainExamName
		,TotalIsFraction,TotalMarkSameMerit,BranchWise
		,G.SortSerialBySubjectId1,G.SortSerialBySubjectId2,G.SortSerialBySubjectId3
		,G.SubjectId1,G.SubjectId2,G.SubjectId3
		,G.SortSerialByGPAWith4th,G.SortSerialByGPAWithout4th,G.SortSerialByTotalMark
		,G.SortSerialByName,G.SortSerialByRoll,G.MainGPAW4th,G.MainGPAWO4th,G.MainTotalMark,G.SortSerialByTotalMark,G.NoOfAttendExam
		FROM Res_GrandMeritListConfig  G 
		INNER JOIN [dbo].[Ins_Version] V ON  V.[VersionId] = G.VersionId 
		INNER JOIN [dbo].[Ins_Session] S ON S.[SessionId] = G.SessionId
		INNER JOIN [dbo].[Ins_ClassInfo] C ON C.[ClassId] = G.ClassId
		INNER JOIN Res_MainExam main ON main.MainExamId=G.MainExamId
		INNER JOIN Ins_Group gr ON gr.GroupId=G.GroupId
		WHERE  G.SessionId =  @SessionId 
	END
	--ELSE IF(@BlockNo=14)-- [rptGetResultSetup] 1,1,1,3,0,2
	--BEGIN
	--	-- Report Controller SubjectListReport 
	--	SELECT DISTINCT C.VersionName
 --                         ,C.SessionName
 --                         ,C.ClassName
 --                         ,C.GroupName
	--					  ,C.SectionName
	--					  ,SB.StudentInsID
	--					  ,SB.FullName
	--					  ,SB.RollNo
 --                         ,SubjectName,SS.SubjectID                                              
	--					  ,SS.SubjectType     
 --                     FROM Res_StudentSubject AS SS
	--				  INNER JOIN [Res_SubjectSetup] AS S ON SS.SubjectID=S.SubID
	--				  INNER JOIN [view_CommonTableNames] AS C ON S.VersionID=C.VersionID AND S.SessionId=C.SessionId AND S.ClassId=C.ClassId AND S.GroupId=C.GroupId
	--				  LEFT OUTER JOIN Student_BasicInfo SB ON SB.StudentIID=SS.StudentID
 --                     WHERE SB.VersionID=@VersionID AND SB.SessionId=@SessionID AND SB.BranchID=@BranchID AND SB.ClassId=@ClassID
	--				  AND SB.GroupId=@GroupID AND  SB.IsDeleted=0 AND SS.IsDeleted=0 AND S.IsDeleted=0 ORDER BY SB.RollNo	
	--END

	
END

/****** Object:  StoredProcedure [dbo].[rptStatisticaData]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptStatisticaData]'))
BEGIN
DROP PROCEDURE  rptStatisticaData
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select COUNT(*) from dbo.Student_BasicInfo where Height is not null
--[dbo].[rptStatisticaData] 1,6,3,22,1,0,31,null,null
CREATE PROCEDURE [dbo].[rptStatisticaData] 
@SessionId INT =null, 
@BranchID INT =null, 
@ShiftID INT =null,
@ClassId INT =null, 
@SectionId INT =null,
@StudentType INT =null,
@HouseId INT =null
 
AS
BEGIN
DECLARE @TotalStu INt 
SELECT @TotalStu = COUNT( StudentIID) FROM Student_BasicInfo s WHERE 
 s.SessionId=ISNULL(@SessionId,s.SessionId)
AND s.ShiftID=ISNULL(@ShiftID,s.ShiftID)
AND s.BranchID=ISNULL(@BranchID,s.BranchID)
AND s.ClassId=ISNULL(@ClassId,s.ClassId)
AND s.SectionId=ISNULL(@SectionId,s.SectionId)
AND s.StudentTypeID=ISNULL(@StudentType,s.StudentTypeID)
AND s.HouseID=ISNULL(@HouseId,s.HouseID)

SELECT s.* INTO #TempStudent FROM Student_BasicInfo s  WHERE 
 s.SessionId=ISNULL(@SessionId,s.SessionId)
AND s.ShiftID=ISNULL(@ShiftID,s.ShiftID)
AND s.BranchID=ISNULL(@BranchID,s.BranchID)
AND s.ClassId=ISNULL(@ClassId,s.ClassId)
AND s.SectionId=ISNULL(@SectionId,s.SectionId)
AND s.StudentTypeID=ISNULL(@StudentType,s.StudentTypeID)
AND s.HouseID=ISNULL(@HouseId,s.HouseID)

PRINT @TotalStu
	CREATE TABLE #temp (
	ValueName VARCHAR(100),
	Total INT ,
	Percentage DECIMAL(10,2),
	ValueType VARCHAR(50)
	)
	---- For BloodGroup
	INSERT INTO #temp
	SELECT BloodGroup,COUNT(StudentIID),(COUNT(StudentIID)*100)/@TotalStu ,'BloodGroup'  FROM #TempStudent 
	GROUP BY BloodGroup

		---- For Religion
	INSERT INTO #temp
	SELECT Religion,COUNT(StudentIID),(COUNT(StudentIID)*100)/@TotalStu ,'Religion'  FROM #TempStudent 
	GROUP BY Religion

	---- For Quota Wise
	INSERT INTO #temp
	SELECT Quota,COUNT(StudentIID),(COUNT(StudentIID)*100)/@TotalStu ,'Quota'  FROM #TempStudent 
	GROUP BY Quota


	---- For Age
	INSERT INTO #temp
	SELECT T.AgeRange,COUNT(*),(COUNT(*)*100)/@TotalStu ,'Age' 
	 FROM ( SELECT 
			 (CASE WHEN Age BETWEEN 6 AND 8 THEN '6 - 8'
				   WHEN Age BETWEEN 9 AND 11 THEN '9 - 11'
				   WHEN Age BETWEEN 12 AND 14 THEN '12 - 14'
				   WHEN Age BETWEEN 15 AND 17 THEN '15 - 17'
				     WHEN Age is null THEN 'N/A'
				    END ) AS AgeRange
			 FROM  #TempStudent  
			 ) AS T
	GROUP BY T.AgeRange

		---- For Hight
	INSERT INTO #temp
	SELECT T.Hight,COUNT(*),(COUNT(*)*100)/@TotalStu ,'Hight' 
	 FROM ( SELECT 
			 (CASE 
			       WHEN Height < '2' THEN '1'
			       WHEN Height BETWEEN '2' AND '2.11' THEN '2" - 2.11"'
				   WHEN Height BETWEEN '3' AND '3.11' THEN '3"- 3.11"'
				   WHEN Height BETWEEN '4' AND '4.11' THEN '4" - 4.11" '
				   WHEN Height BETWEEN '5' AND '5.11' THEN '5" - 5.11"'
				   WHEN Height < '6' THEN 'Upper 6"'
				   WHEN Height is null or Height =' ' or Height='NULL' THEN  'N/A'
				    END ) AS Hight
			 FROM  #TempStudent
			 ) AS T
	GROUP BY T.Hight
	---- For Weight
	INSERT INTO #temp
	SELECT T.Weight,COUNT(*),(COUNT(*)*100)/@TotalStu ,'Weight' 
	 FROM ( SELECT 
			 (CASE WHEN Weight BETWEEN 15 AND 25 THEN '15 - 25'
				   WHEN Weight BETWEEN 26 AND 70 THEN '26 - 70'
				   WHEN Weight BETWEEN 71 AND 150 THEN '71 -150 '
				   WHEN Weight BETWEEN 151 AND 200 THEN '151 - 200'
				   WHEN Weight is null  THEN 'N/A'
				    END ) AS Weight
			 FROM  #TempStudent
			 ) AS T
	GROUP BY T.Weight

	---- For Type
	INSERT INTO #temp
	SELECT stuType.StudentTypeName,COUNT(StudentIID),(COUNT(StudentIID)*100)/@TotalStu ,'Type'  FROM #TempStudent sb
	left JOIN Ins_StudentType stuType on sb.StudentTypeId=stuType.StudentTypeId

	GROUP BY stuType.StudentTypeId,stuType.StudentTypeName

		---- For House
	INSERT INTO #temp
	SELECT H.HouseName,
	COUNT(StudentIID),(COUNT(StudentIID)*100)/@TotalStu ,'House'  FROM #TempStudent S LEFT JOIN Ins_House H ON H.HouseId = S.HouseId
	
	GROUP BY S.HouseId, H.HouseName

	---- For Gender
	INSERT INTO #temp
	SELECT Gender,COUNT(StudentIID),(COUNT(StudentIID)*100)/@TotalStu ,'Gender'  FROM #TempStudent
	GROUP BY Gender
	
	------ For Interest
	--	INSERT INTO #temp
	--SELECT H.HouseName,
	--COUNT(S.StudentIID),(COUNT(S.StudentIID)*100)/@TotalStu ,'House'  FROM Student_BasicInfo S LEFT JOIN Student_OthersInfo STO ON STO.StudentIID = S.StudentIID
	-- WHERE ClassId = @ClassId AND S.Status = 'A'
	--GROUP BY S.HouseId, H.HouseName

	-- For  Monthly Income Father's 
	INSERT INTO #temp
	SELECT T.INCOME ,COUNT(*),(COUNT(*)*100)/@TotalStu ,'FatherIncome' 
	 FROM ( SELECT 
			 (CASE WHEN SGI.F_MonthlyIncome BETWEEN '10000' AND '20000' THEN '10000 - 20000'
				   WHEN SGI.F_MonthlyIncome BETWEEN '21000' AND '40000' THEN '21000 - 40000 '
				   WHEN SGI.F_MonthlyIncome BETWEEN '41000' AND '80000' THEN '41000 - 80000'
				   WHEN SGI.F_MonthlyIncome > '80000'   THEN '80000 - '
				   WHEN SGI.F_MonthlyIncome is null  THEN 'N/A'
				    END ) AS INCOME
			 FROM  #TempStudent
			 S LEFT JOIN Student_GuardianInfo SGI ON SGI.StudentIID = S.StudentIID
			
			 ) AS T
	GROUP BY T.INCOME

		-- For  Monthly Income Mother's
	INSERT INTO #temp
	SELECT T.INCOME ,COUNT(*),(COUNT(*)*100)/@TotalStu ,'MotherIncome' 
	 FROM ( SELECT 
			 (CASE WHEN SGI.M_MonthlyIncome BETWEEN '10000' AND '20000' THEN '10000 - 20000'
				   WHEN SGI.M_MonthlyIncome BETWEEN '21000' AND '40000' THEN '21000 - 40000 '
				   WHEN SGI.M_MonthlyIncome BETWEEN '41000' AND '80000' THEN '41000 - 80000'
				   WHEN SGI.M_MonthlyIncome > '80000'   THEN '80000 - '
				   WHEN SGI.M_MonthlyIncome is null  THEN 'N/A'
				    END ) AS INCOME
			 FROM  #TempStudent  
			 S LEFT JOIN Student_GuardianInfo SGI ON SGI.StudentIID = S.StudentIID
			
			 ) AS T
	GROUP BY T.INCOME
 

 	---- For Present District
	INSERT INTO #temp
	SELECT ISNULL(PreCD.DistrictName,'N/A') DistrictName,
	COUNT(S.StudentIID),(COUNT(S.StudentIID)*100)/@TotalStu ,'PresentDistrict'  FROM #TempStudent S LEFT JOIN Student_ContactInfo SC ON SC.StudentIID = S.StudentIID
	LEFT JOIN  Common_District PreCD ON PreCD.DistrictId = SC.Par_DisId
	
	GROUP BY PreCD.DistrictName


	---- For  PermanentDistrict
	INSERT INTO #temp
	SELECT ISNULL(ParCD.DistrictName,'N/A') DistrictName,
	COUNT(S.StudentIID),(COUNT(S.StudentIID)*100)/@TotalStu ,'PermanentDistrict'  FROM #TempStudent S LEFT JOIN Student_ContactInfo SC ON SC.StudentIID = S.StudentIID
	LEFT JOIN  Common_District ParCD ON ParCD.DistrictId = SC.Par_DisId
	
	GROUP BY ParCD.DistrictName


		---- For Present Thana
	INSERT INTO #temp
	SELECT ISNULL(PrePo.PsName,'N/A') Thana,
	COUNT(S.StudentIID),(COUNT(S.StudentIID)*100)/@TotalStu ,'PresentThana'  FROM #TempStudent S LEFT JOIN Student_ContactInfo SC ON SC.StudentIID = S.StudentIID
	LEFT JOIN  Common_PoliceStation PrePo ON PrePo.PsId = SC.Pre_PSId
	
	GROUP BY PrePo.PsName

		---- For ParmanentThana
	INSERT INTO #temp
	SELECT ISNULL(ParPo.PsName,'N/A') Thana,
	COUNT(S.StudentIID),(COUNT(S.StudentIID)*100)/@TotalStu ,'ParmanentThana'  FROM #TempStudent S LEFT JOIN Student_ContactInfo SC ON SC.StudentIID = S.StudentIID
	LEFT JOIN  Common_PoliceStation ParPo ON ParPo.PsId = SC.Par_PSId

	GROUP BY ParPo.PsName


	------ For GPAPSC
	INSERT INTO #temp
	SELECT ISNULL( T.GPA,'N/A'),COUNT(*),(COUNT(*)*100)/@TotalStu ,'GPAPSC' 
	 FROM ( SELECT 
			 (CASE WHEN SAI.GPA BETWEEN 1 AND 1.99 THEN '1'
				   WHEN SAI.GPA BETWEEN 2 AND 2.99 THEN '2'
				   WHEN SAI.GPA BETWEEN 3 AND 3.99 THEN '3'
				   WHEN SAI.GPA BETWEEN 4 AND 4.99 THEN '4'
				   WHEN SAI.GPA = 5 THEN '5'
				   WHEN SAI.GPA is null  THEN 'N/A'
				    END ) AS GPA
			 FROM  #TempStudent SB LEFT JOIN Student_AcademicInfo SAI ON sb.StudentIID =SAI.StudentIID WHERE  SAI.ExamName='PSC' 
			 ) AS T
	GROUP BY T.GPA

	---- For GPAJSC
	INSERT INTO #temp
	SELECT  ISNULL( T.GPA,'N/A'),COUNT(*),(COUNT(*)*100)/@TotalStu ,'GPAJSC' 
	 FROM ( SELECT 
			 (CASE WHEN SAI.GPA BETWEEN 1 AND 1.99 THEN '1'
				   WHEN SAI.GPA BETWEEN 2 AND 2.99 THEN '2'
				   WHEN SAI.GPA BETWEEN 3 AND 3.99 THEN '3'
				   WHEN SAI.GPA BETWEEN 4 AND 4.99 THEN '4'
				   WHEN SAI.GPA = 5 THEN '5'
				   WHEN SAI.GPA is null  THEN 'N/A'
				    END ) AS GPA
			 FROM  #TempStudent SB LEFT JOIN Student_AcademicInfo SAI 
			 ON sb.StudentIID =SAI.StudentIID WHERE  SAI.ExamName='JSC'
			 ) AS T
	GROUP BY T.GPA

	---- For GPASSC
	INSERT INTO #temp
	SELECT  ISNULL( T.GPA,'N/A'),COUNT(*),(COUNT(*)*100)/@TotalStu ,'GPASSC' 
	 FROM ( SELECT 
			 (CASE WHEN SAI.GPA BETWEEN 1 AND 1.99 THEN '1'
				   WHEN SAI.GPA BETWEEN 2 AND 2.99 THEN '2'
				   WHEN SAI.GPA BETWEEN 3 AND 3.99 THEN '3'
				   WHEN SAI.GPA BETWEEN 4 AND 4.99 THEN '4'
				   WHEN SAI.GPA = 5 THEN '5'
				   WHEN SAI.GPA is null  THEN 'N/A'
				    END ) AS GPA
			 FROM  #TempStudent SB LEFT JOIN Student_AcademicInfo SAI ON sb.StudentIID =SAI.StudentIID 
			 WHERE  SAI.ExamName='SSC' 
			 ) AS T
	GROUP BY T.GPA

	---- For PSCBoard 
	INSERT INTO #temp
	SELECT ISNULL(SAI.Board,'N/A'),COUNT(SB.StudentIID),(COUNT(SB.StudentIID)*100)/@TotalStu ,'PSCBoard'  FROM #TempStudent SB
	LEFT JOIN Student_AcademicInfo SAI ON SAI.StudentIID=SB.StudentIID  WHERE  SAI.ExamName='PSC'
	GROUP BY SAI.Board

		---- For JSCBoard 
	INSERT INTO #temp
	SELECT ISNULL(SAI.Board,'N/A'),COUNT(SB.StudentIID),(COUNT(SB.StudentIID)*100)/@TotalStu ,'JSCBoard'  FROM #TempStudent SB
	LEFT JOIN Student_AcademicInfo SAI ON SAI.StudentIID=SB.StudentIID  WHERE  SAI.ExamName='JSC' 
	GROUP BY SAI.Board

		---- For PSCBoard 
	INSERT INTO #temp
	SELECT ISNULL(SAI.Board,'N/A'),COUNT(SB.StudentIID),(COUNT(SB.StudentIID)*100)/@TotalStu ,'SSCBoard'  FROM #TempStudent SB
	LEFT JOIN Student_AcademicInfo SAI ON SAI.StudentIID=SB.StudentIID  WHERE  SAI.ExamName='PSC'
	GROUP BY SAI.Board





	SELECT tem.*,@TotalStu TotalStudent FROM #temp tem
	DROP TABLE #temp
	DROP TABLE #TempStudent
	
END

	
	-- rptStatisticaData 2

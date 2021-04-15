IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentDashBoardData]'))
BEGIN
DROP PROCEDURE  GetStudentDashBoardData
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Comments --
-- EXEC GetStudentDashBoardData

CREATE PROCEDURE [dbo].[GetStudentDashBoardData]
AS
BEGIN


DECLARE @TotalStu INT, @TotalActive INT ,@TotalInActive INT , @TotalMale INT, @TotalFemale INT

SELECT
		@TotalStu = COUNT(StudentIID),
	 @TotalActive  =  COUNT(CASE WHEN S.Status='A' THEN 1 ELSE NULL END) ,
	@TotalInActive  =  COUNT(CASE WHEN S.Status='I' THEN 1 ELSE NULL END) ,
	@TotalMale  =  COUNT(CASE WHEN S.Gender='Male' AND S.Status='A' THEN 1 ELSE NULL END) ,
	@TotalFemale  =  COUNT(CASE WHEN S.Gender='Female' AND S.Status='A' THEN 1 ELSE NULL END) 
From Student_BasicInfo S



SELECT COUNT(StudentIId) AS y  , T.StudentTypeName AS [name]
From Student_BasicInfo S
INNER JOIN Ins_StudentType T ON T.StudentTypeId = S.StudentTypeID
WHERE S.IsDeleted = 0 AND S.Status = 'A'
GROUP BY T.StudentTypeID,StudentTypeName
ORDER BY T.StudentTypeID


SELECT COUNT(StudentIId) AS y  ,  ISNULL(S.Gender,'NILL') AS [name]
From Student_BasicInfo S
WHERE S.IsDeleted = 0 AND S.Status = 'A'
GROUP BY  S.Gender

SELECT COUNT(StudentIId) AS y  ,  ISNULL(S.BloodGroup,'NILL') AS [name]
From Student_BasicInfo S
WHERE S.IsDeleted = 0 AND S.Status = 'A'
GROUP BY RTRIM(LTRIM( S.BloodGroup)) , ISNULL(S.BloodGroup,'NILL')


SELECT COUNT(StudentIId) AS y  ,  ISNULL(S.Religion,'NILL') AS [name]
From Student_BasicInfo S
WHERE S.IsDeleted = 0 AND S.Status = 'A'
GROUP BY RTRIM(LTRIM( S.Religion)) , ISNULL(S.Religion,'NILL')


 SELECT COUNT(StudentId) AS y , ST.ScholarshipType AS [name]
 FROM Fees_ScholarshipMaster SM
 INNER JOIN Student_BasicInfo S ON S.StudentIID = SM.StudentId
 INNER JOIN Fees_ScholarshipType ST ON ST.ScholarshipTypeId = SM.ScholarshipTypeId
WHERE S.IsDeleted = 0 AND S.Status = 'A'
GROUP BY SM.ScholarshipTypeId , ST.ScholarshipType


SELECT ISNULL( T.y,0) AS y, FM.MonthName AS [name] 
	FROM ( SELECT COUNT(StudentIId) AS y ,MONTH(S.AdmissionDate)  AS [name]
		From Student_BasicInfo S 
		
		WHERE S.IsDeleted = 0 AND S.Status = 'A' AND YEAR(S.AdmissionDate) = YEAR(GETDATE())
		GROUP BY YEAR(S.AdmissionDate) , MONTH(S.AdmissionDate)
		) T 

		RIGHT JOIN Fees_FeesMonth FM ON FM.FeesMonthId = T.name


SELECT ISNULL( T.y,0) AS y, FM.MonthName AS [name] 
	FROM ( SELECT COUNT(StudentIId) AS y ,MONTH(S.AdmissionDate)  AS [name]
		From Student_BasicInfo S 
		
		WHERE S.IsDeleted = 0 AND S.Status = 'A' AND YEAR(S.AdmissionDate) = YEAR( DATEADD(yy,-1, GETDATE()))
		GROUP BY YEAR(S.AdmissionDate) , MONTH(S.AdmissionDate)
		) T 

		RIGHT JOIN Fees_FeesMonth FM ON FM.FeesMonthId = T.name




		SELECT  @TotalStu AS TotalStu , @TotalActive AS TotalActive,@TotalInActive AS TotalInActive, @TotalMale AS TotalMale , @TotalFemale AS TotalFemale
		
	

		SELECT COUNT(StudentIID) AS y,S.ShiftName AS [name],S.BranchId AS branchId FROM dbo.Student_BasicInfo SB INNER JOIN  
		   dbo.Ins_Shift S ON S.ShiftId = SB.ShiftID
		   GROUP BY S.ShiftName,S.BranchId

		   	SELECT COUNT(StudentIID) AS y, B.BranchName  AS [name],SB.BranchID AS branchId FROM dbo.Student_BasicInfo SB
           INNER JOIN dbo.Ins_Branch B ON B.BranchId = SB.BranchID
          
		   GROUP BY B.BranchName,SB.BranchID
		    --SELECT BranchName,BranchId FROM dbo.Ins_Branch


END


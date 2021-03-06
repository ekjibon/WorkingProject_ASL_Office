/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentInfoForResult]'))
BEGIN
DROP PROCEDURE  GetStudentInfoForResult
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec GetStudentInfoForResult 1,6,5,1,22,0,53,null

CREATE PROCEDURE [dbo].[GetStudentInfoForResult] -- Total 8 param
	@BlockNo INT ,
	@SessionId INT = NULL,
	@BranchID INT = NULL,
	@ShiftID INT = NULL,
	@ClassId INT = NULL,
	@SectionId INT = NULL,
	@StudentIID INT = NULL,
	@MainExamId INT = NULL,
	@InActiveDate nvarchar(15) = NULL
	
AS
BEGIN
PRINT 'dfgdfg>>>>>>>>>>>>>'

		IF @SessionId = 0 SET @SessionId  = NULL
		IF @BranchID = 0 SET @BranchID  = NULL
		IF @ShiftID = 0 SET @ShiftID  = NULL
		IF @ClassId = 0 SET @ClassId  = NULL
	
		IF @SectionId = 0 SET @SectionId  = NULL
		IF @StudentIID = 0 SET @StudentIID  = NULL
	
		IF(@BlockNo=1)  ---exec GetStudentInfoForResult 1,5,6,3,28,67,0,0,'2021-01-15'
		BEGIN
				SELECT        
				sb.StudentIID, sb.StudentInsID, sb.FullName,  s.SessionName, b.BranchName, 
				sh.ShiftName, c.ClassName,  sc.SectionName, sb.RollNo,sb.FatherName,sb.MotherName,sb.SessionId,sb.BranchID,sb.ShiftID,sb.ClassId,sb.SectionId,
				RME.MainExamId --added main exam_id
			FROM               
        
				dbo.Student_BasicInfo sb INNER JOIN
				dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
				dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
				dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
				dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
       
				dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
				INNER JOIN dbo.Res_MainExamResult RME ON RME.StudentIID = sb.StudentIID
				WHERE 			

					sb.SessionId = COALESCE(@SessionId,sb.SessionId) AND 
					sb.BranchID = COALESCE(@BranchID,sb.BranchID)AND
					sb.ShiftID = COALESCE(@ShiftID,sb.ShiftID)AND
					sb.ClassId = COALESCE(@ClassId,sb.ClassId)AND

					sb.SectionId = COALESCE(@SectionId,sb.SectionId) AND
					sb.StudentIID = COALESCE(@StudentIID,sb.StudentIID)
					 AND sb.IsDeleted=0  AND RME.MainExamId = @MainExamId
					 AND sb.[Status] = 'A' 
				ORDER BY sb.FullName
		END
				IF(@BlockNo=2) -- exec GetStudentInfoForResult 2,5,6,3,28,67,0,0,''
		BEGIN
				SELECT DISTINCT sb.StudentIID
				, sb.StudentInsID, sb.FullName,  s.SessionName, b.BranchName, 
				sh.ShiftName, c.ClassName,  sc.SectionName, sb.RollNo,sb.FatherName,sb.MotherName,sb.SessionId,sb.BranchID,sb.ShiftID,sb.ClassId,sb.SectionId
				--,--RME.MainExamId --added main exam_id
				,CAST(SB.InActiveDate AS DATE)
			FROM               
        
				dbo.Student_BasicInfo sb 

				INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId 
				INNER JOIN dbo.Ins_Branch b ON sb.BranchID = b.BranchId 
				INNER JOIN dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId 
				INNER JOIN dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId 
       
				INNER JOIN dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
				--INNER JOIN  dbo.Res_MainExamResultSubjectDetails RME ON RME.StudentIID = sb.StudentIID
				WHERE 			

					sb.SessionId = COALESCE(@SessionId,sb.SessionId) 
					AND sb.BranchID = COALESCE(@BranchID,sb.BranchID)
					AND sb.ShiftID = COALESCE(@ShiftID,sb.ShiftID)
					AND sb.ClassId = COALESCE(@ClassId,sb.ClassId)
					AND sb.SectionId = COALESCE(@SectionId,sb.SectionId) 
					AND sb.StudentIID = COALESCE(@StudentIID,sb.StudentIID)
					AND sb.IsDeleted=0  
					AND sb.[Status] = 'A' 
					--AND RME.MainExamId = @MainExamId
			    OR CAST(SB.InActiveDate AS DATE)>=CASE WHEN @InActiveDate<>'' THEN CAST(@InActiveDate AS DATE) ELSE CAST(SB.InActiveDate AS DATE) END
			      
				  ORDER BY sb.FullName
				
		END

		        IF(@BlockNo=3)
		BEGIN
				SELECT        
				sb.StudentIID, sb.StudentInsID, sb.FullName,  s.SessionName, b.BranchName, 
				sh.ShiftName, c.ClassName,  sc.SectionName, sb.RollNo,sb.FatherName,sb.MotherName,sb.SessionId,sb.BranchID,sb.ShiftID,sb.ClassId,sb.SectionId
				
			FROM               
        
				dbo.Student_BasicInfo sb INNER JOIN
				dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
				dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
				dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
				dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
       
				dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
				
				WHERE 			

					sb.SessionId = COALESCE(@SessionId,sb.SessionId) AND 
					sb.BranchID = COALESCE(@BranchID,sb.BranchID)AND
					sb.ShiftID = COALESCE(@ShiftID,sb.ShiftID)AND
					sb.ClassId = COALESCE(@ClassId,sb.ClassId)AND

					sb.SectionId = COALESCE(@SectionId,sb.SectionId) AND
					sb.StudentIID = COALESCE(@StudentIID,sb.StudentIID)
					 AND sb.IsDeleted=0
					 AND sb.[Status] = 'A'  OR CAST(SB.InActiveDate AS DATE)>=CASE WHEN @InActiveDate<>'' THEN CAST(@InActiveDate AS DATE) ELSE CAST(SB.InActiveDate AS DATE) END
				ORDER BY sb.FullName
		END
	
	

END

-- SELECT * FROM dbo.Res_MainExamResult WHERE MainExamId = 2034
-- UPDATE dbo.Res_MainExamResult SET [IsPublished] = 0 WHERE MainExamId = 2034 AND StudentIID = 3774
--EXEC GetStudentInfoForResult

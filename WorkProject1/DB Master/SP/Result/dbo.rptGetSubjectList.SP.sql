
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetSubjectList]'))
BEGIN
DROP PROCEDURE  rptGetSubjectList
END
GO
Create proc [dbo].[rptGetSubjectList]
(
    @STUDENTID INT=NULL,
	@SESSIONID INT=NULL,
	@BRANCHID INT=NULL,
	@SHIFTID INT =NULL,
	@CLASSID INT=NULL,
    @SECTIONID INT =NULL,
    @EMPLOYEEID INT =NULL,
	@BLOCKNO INT=NULL
)
AS
BEGIN
   IF(@BlockNo=1)-- [rptGetSubjectList] Null,1,1,2,1,1,0,5,1,null,1  --  111812011
	BEGIN   -- [rptGetSubjectList] 143,Null,Null,Null,Null,Null,Null,Null,Null,null,1
		select SB.SessionName,SB.BranchName,SB.ShiftName,SB.ClassName,SB.SectionName
		,RTRIM(SB.StudentInsID) AS StudentInsID,SB.FullName,SB.RollNo,ss.StudentID,SS.SubjectType as [Status] ,SubSet.SubjectName,SS.ClassId
		from Res_StudentSubject SS
		inner join vwStudentBasic SB on SB.StudentIID=ss.StudentID
		inner join Res_SubjectSetup SubSet on SubSet.SubID=SS.SubjectID
		where SS.StudentID=COALESCE(@StudentID,SS.StudentID) and 

		SS.SessionId=COALESCE(@SessionID,SS.SessionId) and
		SS.BranchID=COALESCE(@BranchID,SS.BranchID) and
		SS.ClassId=COALESCE(@ClassID,SS.ClassId) 

		 order by CAST(SB.RollNo AS INT) ,SS.ClassId ,SS.SessionId
	END
	IF(@BlockNo=2)-- [rptGetSubjectList] Null,1,1,2,1,1,0,5,1,null,2
	BEGIN   -- [rptGetSubjectList] 143,Null,Null,Null,Null,Null,Null,Null,Null,null,2
		select SB.SessionName,SB.BranchName,SB.ShiftName,SB.ClassName,SB.SectionName
		,RTRIM(SB.StudentInsID) AS StudentInsID,SB.FullName,SB.RollNo,ss.StudentID,SS.SubjectType as [Status] ,SubSet.SubjectName,SS.ClassId
		from Res_StudentSubject SS
		inner join vwStudentBasic SB on SB.StudentIID=ss.StudentID
		inner join Res_SubjectSetup SubSet on SubSet.SubID=SS.SubjectID
		where SS.StudentID=COALESCE(@StudentID,SS.StudentID) and 

		SS.SessionId=COALESCE(@SessionID,SS.SessionId) and
		SS.BranchID=COALESCE(@BranchID,SS.BranchID) and
		SS.ClassId=COALESCE(@ClassID,SS.ClassId) order by CAST(SB.RollNo AS INT),SS.ClassId ,SS.SessionId
	END
	IF(@BlockNo=3)  --[rptGetSubjectList] Null,Null,Null,Null,Null,Null,57,3
	BEGIN   --[rptGetSubjectList] 143,Null,Null,Null,Null,Null,Null,Null,Null,2,3
		
		DECLARE @TeachersID VARCHAR(100), @UserId VARCHAR(50), @Name VARCHAR(150) 
		SELECT @UserId=UserName FROM [dbo].[AspNetUsers] WHERE EmpId=@EmployeeID
		SELECT @TeachersID=EmpID, @Name=FullName FROM Emp_BasicInfo WHERE EmpBasicInfoID=@EmployeeID AND IsDeleted=0	
	SELECT DISTINCT	 @UserId AS USERID, @Name AS FullName, @TeachersID AS EmpID,
   
      C.SessionName
      ,C.BranchName
      ,C.ShiftName
      ,C.ClassName
      ,C.SectionName     
      ,S.SubjectName
      ,E.MainExamName	     
	  ,E.SubExamName	  
  FROM [dbo].[Res_AssignSubjectsToTeacher] AS A
  INNER JOIN [dbo].[view_CommonTableNames] AS C ON A.ClassID=C.ClassId 
  AND A.SessionID=C.SessionId AND A.BranchID=C.BranchId AND A.ShiftID=C.ShiftId
  AND A.ClassID=C.ClassId AND A.SectionID=C.SectionId AND A.IsDeleted=0
  INNER JOIN Res_SubjectSetup AS S ON A.SubjectID=S.SubID AND S.IsDeleted=0
  INNER JOIN [vwMainExam] AS E ON A.MainExamID=E.MainExamId AND A.SubExamID=E.SubExamId      
  WHERE A.TeacherID=@EmployeeID AND A.IsDeleted=0 
	END
	IF(@BlockNo=4)  --[rptGetSubjectList] Null,1,6,1,1,1,null,null,null,null,4
	BEGIN  	
	SELECT DISTINCT		
   
      C.SessionName
      ,C.BranchName
      ,C.ShiftName
      ,C.ClassName
     
      ,C.SectionName     
      ,S.SubjectName
	  ,B.EmpID
	  ,B.FullName
	  ,U.UserName as UserID	 
      ,E.MainExamName	     
	  ,E.SubExamName	  
  FROM [dbo].[Res_AssignSubjectsToTeacher] AS A
  INNER JOIN [dbo].[view_CommonTableNames] AS C ON A.ClassID=C.ClassId 
  AND A.SessionID=C.SessionId AND A.BranchID=C.BranchId AND A.ShiftID=C.ShiftId
  AND A.ClassID=C.ClassId AND A.SectionID=C.SectionId AND A.IsDeleted=0
  INNER JOIN Res_SubjectSetup AS S ON A.SubjectID=S.SubID AND S.IsDeleted=0
  INNER JOIN [vwMainExam] AS E ON A.MainExamID=E.MainExamId AND A.SubExamID=E.SubExamId  
  INNER JOIN Emp_BasicInfo AS B ON A.TeacherID=B.EmpBasicInfoID AND B.IsDeleted=0
  INNER JOIN AspNetUsers AS U ON A.TeacherID=U.EmpId   
  WHERE  A.SessionID=@SESSIONID AND A.BranchID=@BRANCHID AND A.ShiftID=@SHIFTID
  AND A.ClassID=@CLASSID  AND A.SectionID=ISNULL(@SECTIONID,A.SectionID) AND A.IsDeleted=0
  END
END
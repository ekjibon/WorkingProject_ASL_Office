/****** Object:  StoredProcedure [dbo].[ProccesStudentSubject]    Script Date: 7/22/2017 4:31:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccesStudentSubject]'))
BEGIN
DROP PROCEDURE  ProccesStudentSubject
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kawsar Ahmed
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ProccesStudentSubject]  --2002,2012,1018,2003,1
	@VersionId int,
	@SessionId int,
	@BranchId int,
	@ClassId int,
	@GroupId int,
	@IsClear bit
	
AS
BEGIN

 DELETE R FROM [Res_StudentSubject] R --INNER JOIN [dbo].[Res_SubjectSetup] S ON ( S.SubID = R.SubjectID  )
  WHERE R.[VersionID] = @VersionId AND R.[SessionId] = @SessionId 
									AND [BranchID]=@BranchId AND R.[ClassId] = @ClassId AND R.[GroupId] = @GroupId
									AND R.SubjectType ='C'
									
IF(@IsClear=1)
return

	INSERT INTO [dbo].[Res_StudentSubject]
           ([SubjectID]
           ,[StudentID]
           ,[SubjectType]
           ,[IsDeleted]
		   ,[VersionID]
           ,[SessionId]
           ,[BranchID]
           ,[ClassId]
           ,[GroupId]
           )

	SELECT S.SubID,ST.StudentIID,'C',0 ,@VersionId,@SessionId,@BranchId,@ClassId,@GroupId  FROM [Student_BasicInfo] ST , [Res_SubjectSetup] S   
	 WHERE ST.VersionID =  @VersionId  AND ST.SessionId =@SessionId  AND ST.BranchID =@BranchId  AND ST.ClassId = @ClassId AND ST.GroupId = @GroupId 
	 AND  S.VersionID = @VersionId AND S.SessionId =@SessionId  AND S.ClassId = @ClassId AND S.GroupId = @GroupId  AND ((S.IsCompulsory = 1 OR S.NoEffectOnExam=1) AND S.IsThird<>1 AND S.IsFourth<>1)
	 AND ST.Status = 'A'
	 AND ST.Status = 'A'
	 AND S.IsDeleted = 0

	-- exec ProccesStudentSubject 1,3,1,2,0,1
END
--select * from [Res_SubjectSetup]  where classid=1 and ((IsCompulsory=1 OR NoEffectOnExam=1) and IsThird<>1 and IsFourth<>1)
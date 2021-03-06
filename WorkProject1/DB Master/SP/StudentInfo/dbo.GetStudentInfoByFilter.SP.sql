/****** Object:  StoredProcedure [dbo].[GetStudentInfoByFilter]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentInfoByFilter]'))
BEGIN
DROP PROCEDURE  GetStudentInfoByFilter
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  [dbo].[GetStudentInfoByFilter]  'SB.SessionId  IN (12)  AND   SB.BranchID  IN (1)  AND   SB.ShiftID  IN (2,3)  AND   SB.ClassId  IN (19)  AND   SB.SectionId  IN (76) ' 
CREATE PROCEDURE [dbo].[GetStudentInfoByFilter]  -- Total 11 param
@Where varchar(MAX) = ''	
AS
BEGIN
DECLARE @sql varchar(max)
--      DECLARE @where varchar(max) = ''
--		IF @Ins_ID = '' SET @Ins_ID  = NULL
--		IF @VersionId = 0 SET @VersionId  = NULL
--		IF @SessionId = 0 SET @SessionId  = NULL
--		IF @BranchID = 0 SET @BranchID  = NULL
--		IF @ShiftID = 0 SET @ShiftID  = NULL
--		IF @ClassId = 0 SET @ClassId  = NULL
--		IF @GroupId = 0 SET @GroupId  = NULL
--		IF @SectionId = 0 SET @SectionId  = NULL
--		IF @StudentType = 0 SET @StudentType  = NULL
--		IF @HouseId = 0 SET @HouseId  = NULL	
--		IF @RollNo = 0 SET @RollNo  = NULL

	PRINT @Where
	IF(@Where <> '')
	BEGIN 
			SET @sql = ' SELECT   sb.StudentIID,cast(sb.RollNo AS INT) RollNo,sb.CurrentStudentId, sb.StudentInsID, sb.FullName,sb.SMSNotificationNo, sb.RollNo,sb.FatherName,sb.MotherName,sb.Status
	FROM dbo.Student_BasicInfo sb'
	 IF( @Where <> '' )
	 BEGIN
	 SET @sql = @sql + ' WHERE '+ @Where
	 END
	 SET @sql = @sql + '  ORDER BY sb.FullName'
	 	 EXEC(@sql)
	 select COUNT(*) AS Rows from dbo.Student_BasicInfo  
	END
	ELSE IF(@Where = '' OR @Where = NULL)
	BEGIN 
			SET @sql = ' SELECT   sb.StudentIID,cast(sb.RollNo AS INT) RollNo,sb.CurrentStudentId, sb.StudentInsID, sb.FullName,sb.SMSNotificationNo, sb.RollNo,sb.FatherName,sb.MotherName,sb.Status
	FROM dbo.Student_BasicInfo sb'
	 SET @Where  = ' sb.[Status] = ''A''';
	 IF( @Where <> '' )
	 BEGIN
	 SET @sql = @sql + ' WHERE '+ @Where
	 END
	 SET @sql = @sql + '  ORDER BY sb.FullName'
	 	 EXEC(@sql)
	  select COUNT(*) AS Rows from dbo.Student_BasicInfo  WHERE [Status] = 'A'
	END

	 	PRINT @sql
	 END
	
		--WHERE 
		--	sb.[Status] = 'A' AND
		--	sb.StudentInsID = COALESCE(@Ins_ID,sb.StudentInsID) AND
		--	sb.VersionID = COALESCE(@VersionId,sb.VersionID) AND 
		--	sb.SessionId = COALESCE(@SessionId,sb.SessionId) AND 
		--	sb.BranchID = COALESCE(@BranchID,sb.BranchID)AND
		--	sb.ShiftID = COALESCE(@ShiftID,sb.ShiftID)AND
		--	sb.ClassId = COALESCE(@ClassId,sb.ClassId)AND
		--	sb.GroupId = COALESCE(@GroupId,sb.GroupId)AND
		--	sb.SectionId = COALESCE(@SectionId,sb.SectionId)AND
		--	sb.StudentTypeID = COALESCE(@StudentType,sb.StudentTypeID)AND
		--	sb.HouseId = COALESCE(@HouseId,sb.HouseId)AND
		--	sb.RollNo = COALESCE(@RollNo,sb.RollNo)
		--ORDER BY sb.RollNo

--EXEC GetStudentInfoByFilter 0,0, '141111113011111011001'
--EXEC GetStudentInfoByFilter '',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
--SELECT   sb.StudentIID,cast(sb.RollNo AS INT) RollNo,sb.CurrentStudentId, sb.StudentInsID, sb.FullName,sb.SMSNotificationNo, sb.RollNo,sb.FatherName,sb.MotherName,sb.Status
--	FROM dbo.Student_BasicInfo SB
--	where
--SB.SessionId  IN (12)  AND   SB.BranchID  IN (1)  AND   SB.ShiftID  IN (2,3)  AND   SB.ClassId  IN (19)  AND   SB.SectionId  IN (76) 

--select * from dbo.Student_BasicInfo SB where SB.ECAClubId = 1002
/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UpdateEmployeeRoster]'))
BEGIN
DROP PROCEDURE  [UpdateEmployeeRoster]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		AYESHA
-- Create date: 
-- Description:	
-- =============================================
-- execute [dbo].[InsertEmployeeRoster] 19,1003,8,1,'17:15:44.4600000','17:15:44.4600000',''
CREATE PROCEDURE [dbo].[UpdateEmployeeRoster] 
@Block INT	,
@Id INT	,
@UpdateBy nvarchar(128)
AS
BEGIN
IF(@Block=1)
BEGIN
    UPDATE [dbo].[Att_EmpRoster]
	SET IsApproved =1,
		UpdateBy =@UpdateBy,
		UpdateDate= GETDATE()
	WHERE EmpId=@Id AND IsTemporary = 0 AND IsApproved =0
		SELECT @@ROWCOUNT
END
IF(@Block=2)
BEGIN
    UPDATE [dbo].[Att_EmpRoster]
	SET IsTempApproved =1,
		InTime = TempInTime,
		OutTime = TempOutTime,
		TempInTime = NULL,
		TempOutTime = NULL,
		UpdateBy =@UpdateBy,
		UpdateDate= GETDATE()
	WHERE Id=@Id AND IsTemporary = 1 
SELECT @@ROWCOUNT
END

IF(@Block=3)
BEGIN
    UPDATE [dbo].[Att_EmpRoster]
	SET IsRejected =1,
		UpdateBy =@UpdateBy,
		UpdateDate= GETDATE()
	WHERE EmpId=@Id AND IsTemporary = 0 AND IsApproved =0
		SELECT @@ROWCOUNT
END

IF(@Block=4)
BEGIN
    UPDATE [dbo].[Att_EmpRoster]
	SET IsTempRejected =1,
		UpdateBy =@UpdateBy,
		UpdateDate= GETDATE()
	WHERE Id=@Id AND IsTemporary = 1 
SELECT @@ROWCOUNT
END
END




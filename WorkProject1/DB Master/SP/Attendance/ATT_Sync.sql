USE [ZKT_DB]
GO
/****** Object:  Trigger [dbo].[ATT_Sync]    Script Date: 2/14/2021 12:04:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER TRIGGER [dbo].[ATT_Sync]
   ON    [dbo].[CHECKINOUT]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--INSERT INTO ASL_Office_DB_test.[dbo].[Emp_DeviceAttendance]
	--			([EmpId],
	--			   [DeviceUSERID],[CHECKTIME],[CHECKTYPE]
	--			   ,[VERIFYCODE],[SENSORID],[Memoinfo],[WorkCode],[sn]
	--			   ,[UserExtFmt],[IsSync],[IsDeleted],[AddBy],[AddDate])
	--SELECT (SELECT TOP 1 E.EmpBasicInfoID FROM ASL_Office_DB_test.[dbo].Emp_BasicInfo E WHERE E.EmpID = U.BADGENUMBER),
	--		U.USERID,I.CHECKTIME,I.CHECKTYPE
	--			,I.VERIFYCODE,I.SENSORID,I.Memoinfo,I.WorkCode,I.sn
	--			,I.UserExtFmt,I.IsSync,0,'ztkdb',GETDATE()
	--			FROM inserted AS I
	--			INNER JOIN USERINFO U ON U.USERID= I.USERID

	INSERT INTO ASL_Office_DB.[dbo].[Emp_DeviceAttendance]
				([EmpId],
				   [DeviceUSERID],[CHECKTIME],[CHECKTYPE]
				   ,[VERIFYCODE],[SENSORID],[Memoinfo],[WorkCode],[sn]
				   ,[UserExtFmt],[IsSync],[IsDeleted],[AddBy],[AddDate])
	SELECT (SELECT TOP 1 E.EmpBasicInfoID FROM ASL_Office_DB.[dbo].Emp_BasicInfo E WHERE E.EmpID = U.BADGENUMBER),
			U.USERID,I.CHECKTIME,I.CHECKTYPE
				,I.VERIFYCODE,I.SENSORID,I.Memoinfo,I.WorkCode,I.sn
				,I.UserExtFmt,I.IsSync,0,'ztkdb',GETDATE()
				FROM inserted AS I
				INNER JOIN USERINFO U ON U.USERID= I.USERID
    -- Insert statements for trigger here

END

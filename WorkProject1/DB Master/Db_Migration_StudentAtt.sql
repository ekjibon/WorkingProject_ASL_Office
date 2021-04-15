

	--- Att_StudentAttendance 
	ALTER TABLE [Att_StudentAttendance] NOCHECK CONSTRAINT ALL
	ALTER TABLE [Att_StudentAttendance] DISABLE TRIGGER ALL
	DELETE FROM [Att_StudentAttendance]
	DBCC CHECKIDENT ('[Att_StudentAttendance]',RESEED, 0)
	ALTER TABLE [Att_StudentAttendance] CHECK CONSTRAINT ALL
	ALTER TABLE [Att_StudentAttendance] ENABLE TRIGGER ALL

	--SET IDENTITY_INSERT [Att_StudentAttendance] ON

	INSERT INTO [Att_StudentAttendance]([StudentId],[InTime],IsPresent,[IsLeave],IsAbsconding,IsLate,IsEarlyOut,Device_SerialNo,[Device_UserID],[AddBy],[AddDate],Isdeleted )
	SELECT  [StudentInfo_SlNo],[StudentAttendance_Date],1,[StudentAttendance_IsLeave],0,0,0,[Device_SerialNo],[Device_UserID],[StudentAttendance_AddBy],GETDATE(),0
	FROM [apsclhs_db].[dbo].[Tbl_StudentAttendance]
	WHERE StudentAttendance_IsPresent =1
	
	--SET IDENTITY_INSERT [Att_StudentAttendance] OFF
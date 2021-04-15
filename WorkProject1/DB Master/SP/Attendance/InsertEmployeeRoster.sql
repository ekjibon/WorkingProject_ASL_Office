/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertEmployeeRoster]'))
BEGIN
DROP PROCEDURE  [InsertEmployeeRoster]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		ARIFUR
-- Create date: 
-- Description:	
-- =============================================
-- execute [dbo].[InsertEmployeeRoster] 1,65,3,10,3,'10:00:00','19:00:00','admin','',0,0
CREATE PROCEDURE [dbo].[InsertEmployeeRoster]
	@Block INT, 
	@EmpId INT,
	@EmpCategory INT,
	@BranchId INT, 
	@CalendarId INT,
	@InTime TIME,
	@OutTime TIME,
	@AddBy VARCHAR(MAX),
	@Remarks VARCHAR(MAX),
	@Year INT,
	@MonthId INT

AS
BEGIN
IF(@Block=1)
	BEGIN
  	DELETE ER FROM [dbo].[Att_EmpRoster] ER
				INNER JOIN [dbo].[Att_EmpAcademicCalendar] EAC ON EAC.EmpCategory = ER.EmpCategory AND EAC.Id=ER.CalendarId
				 INNER JOIN [dbo].[Att_EmpAcademicCalendarDetails] EAD ON  EAD.CalendarId = EAC.Id
				   WHERE  EAC.Id = @CalendarId AND ER.EmpId = @EmpId AND ER.BranchId = @BranchId AND ER.EmpCategory = @EmpCategory AND IsApproved = 0 

   IF(@@ROWCOUNT>0)
   BEGIN 
   		INSERT INTO [dbo].[Att_EmpRoster]
					([EmpId],[EmpCategory],[BranchId],[CalendarDate],[Day],[DayType],[InTime],[OutTime],[IsApproved],[IsDeleted],[AddBy],[AddDate],[UpdateBy],[UpdateDate],[Remarks],[Status],[IsTempApproved],[IsTemporary],CalendarId)
		SELECT @EmpId,@EmpCategory,@BranchId,[CalendarDate],FORMAT([CalendarDate],'dddd'),[DayType],CAST(@InTime AS TIME),CAST(@OutTime AS TIME),0,0,@AddBy,GETDATE(),'',GETDATE(),@Remarks,'A',0,0 ,@CalendarId
							FROM dbo.Att_EmpAcademicCalendarDetails WHERE CalendarId = @CalendarId  AND CAST([CalendarDate] AS date) NOT IN(SELECT CAST(ER.[CalendarDate] AS date) FROM [dbo].[Att_EmpRoster] ER
																									INNER JOIN [dbo].[Att_EmpAcademicCalendar] EAC ON EAC.EmpCategory = ER.EmpCategory AND EAC.Id=ER.CalendarId
																									 INNER JOIN [dbo].[Att_EmpAcademicCalendarDetails] EAD ON  EAD.CalendarId = EAC.Id
																									   WHERE  EAC.Id = @CalendarId AND ER.EmpId = @EmpId AND ER.BranchId = @BranchId AND ER.EmpCategory = @EmpCategory AND IsApproved = 1 )
   END 
   ELSE 
   BEGIN
      		INSERT INTO [dbo].[Att_EmpRoster]
					([EmpId],[EmpCategory],[BranchId],[CalendarDate],[Day],[DayType],[InTime],[OutTime],[IsApproved],[IsDeleted],[AddBy],[AddDate],[UpdateBy],[UpdateDate],[Remarks],[Status],[IsTempApproved],[IsTemporary],CalendarId)
		SELECT @EmpId,@EmpCategory,@BranchId,[CalendarDate],FORMAT([CalendarDate],'dddd'),[DayType],CAST(@InTime AS TIME),CAST(@OutTime AS TIME),0,0,@AddBy,GETDATE(),'',GETDATE(),@Remarks,'A',0,0 ,@CalendarId
							FROM dbo.Att_EmpAcademicCalendarDetails WHERE CalendarId = @CalendarId  AND CAST([CalendarDate] AS date) NOT IN(SELECT CAST(ER.[CalendarDate] AS date) FROM [dbo].[Att_EmpRoster] ER
																									INNER JOIN [dbo].[Att_EmpAcademicCalendar] EAC ON EAC.EmpCategory = ER.EmpCategory AND EAC.Id=ER.CalendarId
																									 INNER JOIN [dbo].[Att_EmpAcademicCalendarDetails] EAD ON  EAD.CalendarId = EAC.Id
																									   WHERE  EAC.Id = @CalendarId AND ER.EmpId = @EmpId AND ER.BranchId = @BranchId AND ER.EmpCategory = @EmpCategory AND IsApproved = 1 )
   END

END
IF(@Block=2)
	BEGIN
	UPDATE ER 
		  SET ER.TempInTime = CAST(@InTime AS TIME)
		  ,ER.TempOutTime = CAST(@OutTime AS TIME)
		  ,UpdateBy = @AddBy
		  ,UpdateDate = GETDATE()
		  ,Remarks = @Remarks
		  ,IsTempApproved = 0
		  ,IsTemporary = 1
		FROM  [dbo].[Att_EmpRoster] ER
		INNER JOIN dbo.Att_EmpAcademicCalendar EAC ON EAC.EmpCategory = ER.EmpCategory AND EAC.Id=ER.CalendarId
		INNER JOIN dbo.Att_EmpAcademicCalendarDetails EACD ON EACD.CalendarId = EAC.Id
	  WHERE ER.Id = @BranchId AND ER.EmpId = @EmpId AND EAC.Id = @CalendarId AND EACD.Year = @Year AND EACD.Month =@MonthId
	END

	SELECT @@ROWCOUNT AS TOTALLROWS

END




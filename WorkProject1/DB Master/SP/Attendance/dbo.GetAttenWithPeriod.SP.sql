/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAttenWithPeriod]'))
BEGIN
DROP PROCEDURE  [GetAttenWithPeriod]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kawsar
-- Create date: 
-- Description:	
-- =============================================
--VersionID	SessionId	BranchID	ShiftID	ClassId	GroupId	SectionId
--1	6	1	1	1	0	3
-- execute [dbo].[GetAttenWithPeriod] null,null,null,null,null,null,null,null,null,11222,1
CREATE PROCEDURE [dbo].[GetAttenWithPeriod] 
	@SessionId INT=NULL,
	@BranchId INT = NULL,
	@ShiftId INT =NULL,
	@ClassId INT = NULL,
	@SectionId INT = NULL,
	@Date SMALLDATETIME=NULL,
	@AttendanceID INT = NULL,
	@StudentID BIGINT=NULL,
	@Block INT
AS
BEGIN

DECLARE @WorkingDays INT = 0;
SELECT @WorkingDays = COUNT(*)  FROM Att_AcademicCalendar WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) = CAST( @Date AS DATE)
IF(@Block=1)
BEGIN
	-- execute [dbo].[GetAttenWithPeriod]  10, 8, 2,19,76,'2019-04-09 12:00:00 AM',0,NULL,1
	 IF EXISTS(SELECT * FROM [dbo].[Att_AcademicCalendar] WHERE CAST(CalendarDate AS DATE)=CAST(@Date AS DATE) AND DayType='Regular' AND IsDeleted=0)
	 BEGIN
	  DECLARE @TotalStudent INT, @TotalPresent INT
	  IF(@StudentID IS NULL)
		BEGIN
			  SELECT DISTINCT StudentIID, StudentInsID, CAST(RollNo AS INT) AS RollNo, FullName, CAST(ISNULL(A.IsLeave, 0) AS BIT) AS IsLeave,
			  CAST(ISNULL(A.IsPresent, 0) AS BIT) AS IsPresent, ISNULL(A.AttendId,0) AS AttendId
			  INTO #TEMP FROM [dbo].[Student_BasicInfo] AS B
			  LEFT JOIN [dbo].[Att_StudentAttendance] AS A ON B.StudentIID=A.StudentId AND  CONVERT(DATE,A.InTime) = CONVERT(DATE, @Date) AND A.IsDeleted=0	
			  --LEFT JOIN [dbo].[Att_AbscondingDetails] AS P ON A.AttendId=P.AttenId 
			  WHERE B.SessionId=@SessionId AND B.BranchID=@BranchId 
			  AND B.ShiftID=@ShiftId AND B.ClassId=@ClassId AND  B.SectionId=@SectionId AND B.IsDeleted=0	and B.Status= 'A'
			  ORDER BY FullName --CAST(RollNo AS INT), StudentIID 

			  SELECT @TotalStudent=COUNT(*) FROM #TEMP
			  SELECT @TotalPresent=COUNT(*) FROM #TEMP WHERE #TEMP.IsPresent=1
			  SELECT StudentIID, StudentInsID, RollNo, FullName, IsLeave, IsPresent, AttendId, @TotalStudent AS TotalStudent, @TotalPresent AS TotalPresent FROM #TEMP ORDER BY FullName
		END
		ELSE
		BEGIN
			SELECT DISTINCT StudentIID, StudentInsID, CAST(RollNo AS INT) AS RollNo, FullName, CAST(ISNULL(A.IsLeave, 0) AS BIT) AS IsLeave,
			  CAST(ISNULL(A.IsPresent, 0) AS BIT) AS IsPresent, ISNULL(A.AttendId,0) AS AttendId
			  INTO #TEMP1 FROM [dbo].[Student_BasicInfo] AS B
			  LEFT JOIN [dbo].[Att_StudentAttendance] AS A ON B.StudentIID=A.StudentId AND  CONVERT(DATE,A.InTime) = CONVERT(DATE, @Date) AND A.IsDeleted=0	
			  --LEFT JOIN [dbo].[Att_AbscondingDetails] AS P ON A.AttendId=P.AttenId 
			  WHERE B.StudentIID=@StudentID AND B.IsDeleted=0 and B.Status= 'A'
			  ORDER BY FullName --CAST(RollNo AS INT), StudentIID 

			  SELECT @TotalStudent=COUNT(*) FROM #TEMP1
			  SELECT @TotalPresent=COUNT(*) FROM #TEMP1 WHERE #TEMP1.IsPresent=1
			  SELECT StudentIID, StudentInsID, RollNo, FullName, IsLeave, IsPresent, AttendId, @TotalStudent AS TotalStudent, @TotalPresent AS TotalPresent FROM #TEMP1 ORDER BY FullName
		END
	 END
END
IF(@Block=2)
BEGIN
-- execute [dbo].[GetAttenWithPeriod]  1, 6, 1,1,2,0,120,'8/4/2018 12:00:00',30390,null,2
	SELECT distinct C.PeriodId, C.PeriodName, CAST((CASE WHEN  A.AbscondingId>0 THEN 1 ELSE 0 END) AS BIT) AS IsAbsconding,
    CAST( CASE WHEN @AttendanceID=0 THEN 0 WHEN (SELECT COUNT(P.AbscondingId) AS SS FROM [dbo].[Att_AbscondingDetails] AS P  WHERE P.PeriodId=A.PeriodId AND P.AttenId IN(SELECT SA.AttendId FROM [dbo].[Student_BasicInfo] AS B
	LEFT JOIN [dbo].[Att_StudentAttendance] AS SA ON B.StudentIID=SA.StudentId AND  CONVERT(DATE,SA.InTime) = CONVERT(DATE, @Date) AND SA.IsDeleted=0	
	WHERE  B.SessionId=@SessionId AND B.BranchID=@BranchId
	AND B.ShiftID=@ShiftId AND B.ClassId=@ClassId AND B.SectionId=@SectionId AND B.IsDeleted=0))=0 THEN 1 ELSE 0 END AS BIT) AS IsAllPresent,
	ISNULL((SELECT TOP 1 IsLeave FROM [dbo].[Att_StudentPeriodAtten] WHERE [StudentId]=(SELECT TOP 1 StudentId FROM [dbo].[Att_StudentAttendance] WHERE AttendId=@AttendanceID) AND IsLeave=1 AND IsDeleted=0 AND PeriodId=C.PeriodId),0) AS PeriodIsLeave
	FROM [dbo].[Rtn_ClassPeriod] AS C 
	LEFT JOIN [dbo].[Att_AbscondingDetails] AS A ON C.PeriodId=a.PeriodId AND A.AttenId=@AttendanceID
	where  C.ClassId=@ClassId 
END	
IF(@Block=3)
BEGIN
--  execute [dbo].[GetAttenWithPeriod]  null,null,null,null,null,null,null,null,30390,1711317,3
	SELECT distinct C.PeriodId, C.PeriodName, CAST((CASE WHEN  A.AbscondingId>0 THEN 1 ELSE 0 END) AS BIT) AS IsAbsconding
    --,CAST( CASE WHEN @AttendanceID=0 THEN 0 WHEN (SELECT COUNT(P.AbscondingId) AS SS FROM [dbo].[Att_AbscondingDetails] AS P  WHERE P.PeriodId=A.PeriodId AND P.AttenId IN(SELECT SA.AttendId FROM [dbo].[Student_BasicInfo] AS B
	--LEFT JOIN [dbo].[Att_StudentAttendance] AS SA ON B.StudentIID=SA.StudentId AND  CONVERT(DATE,SA.InTime) = CONVERT(DATE, @Date) AND SA.IsDeleted=0	
	--WHERE B.VersionID=@VersionId AND B.SessionId=@SessionId AND B.BranchID=@BranchId AND B.ShiftID=@ShiftId AND B.ClassId
	--=@ClassId AND B.GroupId=@GroupId AND B.SectionId=@SectionId AND B.IsDeleted=0))=0 THEN 1 ELSE 0 END AS BIT) AS IsAllPresent,
	--ISNULL((SELECT TOP 1 IsLeave FROM [dbo].[Att_StudentPeriodAtten] WHERE [StudentId]=@StudentID AND IsLeave=1 AND IsDeleted=0 AND PeriodId=C.PeriodId),0) AS PeriodIsLeave
	FROM [dbo].[Rtn_ClassPeriod] AS C 
	LEFT JOIN [dbo].[Att_AbscondingDetails] AS A ON C.PeriodId=a.PeriodId AND A.AttenId=@AttendanceID
	where C.IsDeleted=0 and  C.ClassId=(select Bas.ClassId  from Student_BasicInfo Bas where bas.StudentIID=@StudentID)
	and C.ShiftId=(select Bas.ShiftID  from Student_BasicInfo Bas where bas.StudentIID=@StudentID)  

	--- SELECT * FROM [dbo].[Rtn_ClassPeriod] 
	
END
IF(@Block=4)
BEGIN
--  execute [dbo].[GetAttenWithPeriod]  null,null,null,null,null,null,null,3778,4
	SELECT  C.PeriodId, C.PeriodName FROM [dbo].[Rtn_ClassPeriod] AS C 
	where  C.IsDeleted=0 and C.ClassId=(select Bas.ClassId  from Student_BasicInfo Bas where bas.StudentIID=@StudentID) 
	and C.ShiftId=(select Bas.ShiftID  from Student_BasicInfo Bas where bas.StudentIID=@StudentID) 
END
END

-- 

--SELECT COUNT(P.AbscondingId) AS SS FROM [dbo].[Att_AbscondingDetails] AS P 
-- WHERE P.PeriodId=1 AND P.AttenId IN(SELECT SA.AttendId FROM [dbo].[Student_BasicInfo] AS B
--	LEFT JOIN [dbo].[Att_StudentAttendance] AS SA ON B.StudentIID=SA.StudentId AND  CONVERT(DATE,SA.InTime) = CONVERT(DATE, @Date) AND SA.IsDeleted=0	
--	WHERE B.VersionID=@VersionId AND B.SessionId=@SessionId AND B.BranchID=@BranchId
--	AND B.ShiftID=@ShiftId AND B.ClassId=@ClassId AND B.GroupId=@GroupId AND B.SectionId=@SectionId AND B.IsDeleted=0) 

--	SELECT SA.AttendId FROM [dbo].[Student_BasicInfo] AS B
--	LEFT JOIN [dbo].[Att_StudentAttendance] AS SA ON B.StudentIID=SA.StudentId AND  CONVERT(DATE,SA.InTime) = CONVERT(DATE, @Date) AND SA.IsDeleted=0	
--	WHERE B.VersionID=@VersionId AND B.SessionId=@SessionId AND B.BranchID=@BranchId
--	AND B.ShiftID=@ShiftId AND B.ClassId=@ClassId AND B.GroupId=@GroupId AND B.SectionId=@SectionId AND B.IsDeleted=0
--SELECT C.PeriodId, C.PeriodName, CAST((CASE WHEN  A.AbscondingId>0 THEN 1 ELSE 0 END) AS BIT) AS IsAbsconding FROM [dbo].[Rtn_ClassPeriod] AS C LEFT JOIN [dbo].[Att_AbscondingDetails] AS A ON C.PeriodId=a.PeriodId AND A.AttenId=1270






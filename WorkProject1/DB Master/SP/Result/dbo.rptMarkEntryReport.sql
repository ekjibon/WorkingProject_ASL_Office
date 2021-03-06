
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptMarkEntryReport]'))
BEGIN
DROP PROCEDURE  rptMarkEntryReport
END
GO

--	rptMarkEntryReport 1,0,0,0,0,0,0,0,0,0
--	rptMarkEntryReport 1,1,6,1,2,10,3,162,1007,1016

Create proc [dbo].[rptMarkEntryReport]
(
	@BlockNo INT=0,			--1
	@VersionID INT=0,		--2
	@SessionID INT=0,		--3
	@BranchID INT=0,		--4
	@ShiftID int=0,			--5
	@ClassID INT=0,			--6
	@GroupID INT=0,			--7
	@SectionID INT=0,		--8
	@MainExamID int=0,		--9
	@SubjectId int =0		--10
)
AS

BEGIN
	IF(@BlockNo=1)
	BEGIN	 
		-- rptMarkEntryReport @BlockNo=1      --case when isnull(me.IsAbsent,0) = 0 then '' else isnull( cast(me.ObtainMarks as varchar(50)),'A') end 
		SELECT    sb.StudentInsID,sb.FullName,cast(sb.RollNo as int ) RollNo,
		de.DividedExamName+'('+cast(10 as varchar(50))+')' DividedExamName, 
		se.SubExamName,de.DividedExamId,de.SubExamId, 
		case when IsAbsent =1 then 'A' else  cast(ObtainMarks as varchar(50)) end ObtainMarks,m.MainExamName,ctn.VersionName,ctn.SessionName,ctn.BranchName,ctn.ShiftName,ctn.ClassName,
		ctn.GroupName,ctn.SectionName,ss.SubjectName,me.IsAbsent
				
		FROM [Res_DividedExam] de
		INNER JOIN Qry_MarkSetup QMS on QMS.MainExamSubjectID=@SubjectId and QMS.DividedExamId=de.DividedExamId and qms.SubExamId=de.SubExamId  		 
		INNER JOIN Res_MainExamMarks me on me.DividedExamID=de.DividedExamId and me.SubExamID=de.SubExamId and me.SubjectID=@SubjectId
		
		INNER JOIN Res_MainExam m on m.MainExamId=me.MainExamID
		INNER JOIN Res_SubjectSetup ss on ss.SubID=me.SubjectID
		INNER JOIN Student_BasicInfo sb on sb.StudentIID=me.StudentIID	
		INNER JOIN Res_SubExam se on se.MainExamId=m.MainExamId	
		INNER JOIN view_CommonTableNames ctn on ctn.VersionID=sb.VersionID AND ctn.SessionId=sb.SessionId and ctn.ShiftId= sb.ShiftID AND ctn.ClassId=sb.ClassId AND ctn.GroupId=sb.GroupId and ctn.SectionId=sb.SectionId
		where de.IsDeleted=0 and sb.IsDeleted=0 and (me.MainExamID=@MainExamID OR @MainExamID=0) and (me.SubjectID=@SubjectId OR @SubjectId=0)
			and (ctn.VersionId=@VersionID OR @VersionID=0)and (ctn.SessionId=@SessionID OR @SessionID=0)and (ctn.BranchId=@BranchID OR @BranchID=0)
			and (ctn.ShiftId=@ShiftID OR @ShiftID=0)and (ctn.ClassId=@ClassID OR @ClassID=0) 
			and (ctn.GroupId=@GroupId OR @GroupId=0)and (ctn.SectionId=@SectionId OR @SectionId=0) 
			AND se.SubExamId = 1004
			--and (ctn.ShiftId=@ShiftID OR @ShiftID=0)and (ctn.ClassId=@ClassID OR @ClassID=0) 
			--and sb.StudentInsID='1710801                 '
		order by se.SubExamId
		--order by cast(sb.RollNo as int ),
		--select * from Res_DividedExamMarkSetup
		--select * from Res_SubjectSetup
	END 
	ELSE IF(@BlockNo=2)
	BEGIN		
		-- rptMarkEntryReport @BlockNo=2    --- case when isnull(me.IsAbsent,0) = 0 then '' else isnull( cast(me.ObtainMarks as varchar(50)),'A') end 
		SELECT distinct  sb.StudentInsID,sb.FullName,cast(sb.RollNo as int ) RollNo,de.DividedExamName+'('+cast(cast((select top 1 DividedExamFullMarks from Res_DividedExamMarkSetup d2 where d2.DividedExamId=de.DividedExamId and d2.DividedExamIsEnable=1) as int) as varchar(50))+')' DividedExamName, 
		 --case when IsAbsent =1 then 'A' else  cast(ObtainMarks as varchar(50)) end
		 ObtainMarks,m.MainExamName,ctn.VersionName,ctn.SessionName,ctn.BranchName,ctn.ShiftName,ctn.ClassName,
		ctn.GroupName,ctn.SectionName,ss.SubjectName,me.DividedExamID,se.SubExamName,se.SubExamId,me.IsAbsent
		
		FROM [Res_DividedExam] de
		--INNER JOIN Res_DividedExamMarkSetup dems on de.DividedExamId=dems.DividedExamId
		INNER JOIN Res_MainExamMarks me on me.DividedExamID=de.DividedExamId and me.SubExamID=de.SubExamId --and me.MainExamID=
		INNER JOIN Res_MainExam m on m.MainExamId=me.MainExamID
		INNER JOIN Res_SubjectSetup ss on ss.SubID=me.SubjectID
		INNER JOIN Student_BasicInfo sb on sb.StudentIID=me.StudentIID	
		INNER JOIN Res_SubExam se on se.MainExamId=m.MainExamId	
		INNER JOIN view_CommonTableNames ctn on ctn.VersionID=sb.VersionID AND ctn.SessionId=sb.SessionId and ctn.ShiftId= sb.ShiftID AND ctn.ClassId=sb.ClassId AND ctn.GroupId=sb.GroupId and ctn.SectionId=sb.SectionId
		where de.IsDeleted=0 and (me.MainExamID=@MainExamID OR @MainExamID=0) and (me.SubjectID=@SubjectId OR @SubjectId=0)
			and (ctn.VersionId=@VersionID OR @VersionID=0)and (ctn.SessionId=@SessionID OR @SessionID=0)and (ctn.BranchId=@BranchID OR @BranchID=0)
			and (ctn.ShiftId=@ShiftID OR @ShiftID=0)and (ctn.ClassId=@ClassID OR @ClassID=0) 
			and (ctn.GroupId=@GroupId OR @GroupId=0)and (ctn.SectionId=@SectionId OR @SectionId=0) 
			AND (me.ObtainMarks = 0 or isnull(me.IsAbsent,1)=1)--only 
		order by cast(sb.RollNo as int )

	END 
	ELSE IF(@BlockNo=3)
	BEGIN		
		-- rptMarkEntryReport @BlockNo=3  
		SELECT distinct  de.DividedExamName+'('+cast(cast((select top 1 DividedExamFullMarks from Res_DividedExamMarkSetup d2 where d2.DividedExamId=de.DividedExamId and d2.DividedExamIsEnable=1) as int) as varchar(50))+')' DividedExamName, 
		(select count(*) from Student_BasicInfo  sb where ctn.VersionID=sb.VersionID AND ctn.SessionId=sb.SessionId and ctn.ShiftId= sb.ShiftID AND ctn.ClassId=sb.ClassId AND ctn.GroupId=sb.GroupId and ctn.SectionId=sb.SectionId)
		-count(*) ZeroCount,m.MainExamName,ctn.VersionName,ctn.SessionName,ctn.BranchName,ctn.ShiftName,ctn.ClassName,
		ctn.GroupName,ctn.SectionName,ss.SubjectName,me.DividedExamID,se.SubExamName,se.SubExamId,
		(select count(*) from Student_BasicInfo  sb where ctn.VersionID=sb.VersionID AND ctn.SessionId=sb.SessionId and ctn.ShiftId= sb.ShiftID AND ctn.ClassId=sb.ClassId AND ctn.GroupId=sb.GroupId and ctn.SectionId=sb.SectionId) TotalStudent
		FROM [Res_DividedExam] de
		--INNER JOIN Res_DividedExamMarkSetup dems on de.DividedExamId=dems.DividedExamId
		INNER JOIN Res_MainExamMarks me on me.DividedExamID=de.DividedExamId and me.SubExamID=de.SubExamId --and me.MainExamID=
		INNER JOIN Res_MainExam m on m.MainExamId=me.MainExamID
		INNER JOIN Res_SubjectSetup ss on ss.SubID=me.SubjectID
		INNER JOIN Student_BasicInfo sb on sb.StudentIID=me.StudentIID	
		INNER JOIN Res_SubExam se on se.MainExamId=m.MainExamId	
		INNER JOIN view_CommonTableNames ctn on ctn.VersionID=me.VersionID AND ctn.SessionId=me.SessionId and ctn.ShiftId= me.ShiftID AND ctn.ClassId=me.ClassId AND ctn.GroupId=me.GroupId and ctn.SectionId=me.SectionId
		where de.IsDeleted=0 and (me.MainExamID=@MainExamID OR @MainExamID=0) --and (me.SubjectID=@SubjectId OR @SubjectId=0)
			and (ctn.VersionId=@VersionID OR @VersionID=0)and (ctn.SessionId=@SessionID OR @SessionID=0)and (ctn.BranchId=@BranchID OR @BranchID=0)
			and (ctn.ShiftId=@ShiftID OR @ShiftID=0)and (ctn.ClassId=@ClassID OR @ClassID=0) 
			and (ctn.GroupId=@GroupId OR @GroupId=0)and (ctn.SectionId=@SectionId OR @SectionId=0) 		
			and (me.ObtainMarks is not null OR me.IsAbsent =1)
		group by de.DividedExamName,de.DividedExamId,
		m.MainExamName,ctn.VersionName,ctn.SessionName,ctn.BranchName,ctn.ShiftName,ctn.ClassName,
		ctn.GroupName,ctn.SectionName,ss.SubjectName,me.DividedExamID,se.SubExamName,se.SubExamId,
		ctn.VersionID,ctn.SessionId,ctn.ShiftId,ctn.ClassId,ctn.GroupId,ctn.SectionId
	END 


END

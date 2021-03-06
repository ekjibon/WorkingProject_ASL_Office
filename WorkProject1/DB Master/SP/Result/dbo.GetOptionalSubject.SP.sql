/****** Object:  StoredProcedure [dbo].[GetOptionalSubject]    Script Date: 7/22/2017 4:11:01 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetOptionalSubject]'))
BEGIN
DROP PROCEDURE  GetOptionalSubject
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetOptionalSubject] 
(
@StudentID nvarchar(max)=null,
@BranchID int = null,
@VersionID int = null,
@ShiftID int = null,
@SessionID int = null,
@ClassID int = null,
@SectionID int = null,
@GroupID int = null
)
as
Begin
create table #StudentList
(
optionalID int null,
IsMarkThird int null,
IsMarkFourth int null,
IsMarkReligious int null,
StudentID bigint null,
StudentInsID varchar(100) null,
Name varchar(150) null,
Roll int null,
ThirdSubjectID int null,
FourthSubjectID int null,
ReligiousSubjectID int null,
VersionID int null,
BranchId int null,
ClassId int null,
SessionId int null,
GroupId int null
)

Declare @version int, @class int, @session int, @group int, @branch int, @shift int, @section int
if @StudentID is null
Begin
--Set Variable
Select @version=b.VersionID, @class=b.ClassId, @session=b.SessionId, @group=b.GroupId, @branch=b.BranchID,
@shift=b.ShiftID, @section=b.SectionId
from Student_BasicInfo as b where b.BranchID=@BranchID and b.VersionID=@VersionID 
and b.ShiftID=@ShiftID and b.SessionId=@SessionID and b.ClassId=@ClassID and b.SectionId =@SectionID
and b.GroupId=@GroupID and b.IsDeleted=0
--End Set Variable

--Student List with SujectId

Insert Into #StudentList Select distinct null,
--case when ISNULL(o.StudentID,0)=0 THEN 0 ELSE 1 END AS optionalID,
ISNULL((SELECT TOP(1)  SubjectID FROM Res_MainExamMarks WHERE StudentIID=b.StudentIID AND SubjectID=
(select isnull(t.SubjectID,0) as SubjectID from Res_StudentSubject as t 
where t.StudentID=b.StudentIID and t.OptionalType='HT' and  t.BranchID=@BranchID and t.VersionID=@VersionID 
and t.SessionId=@SessionID and t.ClassId=@ClassID and t.GroupId=@GroupID and t.IsDeleted=0)
 AND StudentIID=b.StudentIID AND VersionId=@VersionID 
AND SessionId=@SessionID AND ShiftId=@ShiftID AND ClassId=@ClassID AND GroupId=@GroupID AND SectionId=@SectionID
),0) AS IsMarkThird,

ISNULL((SELECT TOP(1)  SubjectID FROM Res_MainExamMarks WHERE StudentIID=b.StudentIID AND SubjectID=
(select isnull(SubjectID,0) as SubjectID from Res_StudentSubject
where StudentID=b.StudentIID and OptionalType='FT' and  BranchID=@BranchID and VersionID=@VersionID 
and SessionId=@SessionID and ClassId=@ClassID and GroupId=@GroupID and IsDeleted=0)
 AND StudentIID=b.StudentIID AND VersionId=@VersionID 
AND SessionId=@SessionID AND ShiftId=@ShiftID AND ClassId=@ClassID AND GroupId=@GroupID AND SectionId=@SectionID
),0) AS IsMarkFourth,

ISNULL((SELECT TOP(1)  SubjectID FROM Res_MainExamMarks WHERE StudentIID=b.StudentIID AND SubjectID=
(select TOP(1) isnull(SubjectID,0) as SubjectID from Res_StudentSubject 
where StudentID=b.StudentIID and OptionalType='RT' and  BranchID=@BranchID and VersionID=@VersionID 
and SessionId=@SessionID and ClassId=@ClassID and GroupId=@GroupID and IsDeleted=0)
 AND StudentIID=b.StudentIID AND VersionId=@VersionID 
AND SessionId=@SessionID AND ShiftId=@ShiftID AND ClassId=@ClassID AND GroupId=@GroupID AND SectionId=@SectionID
),0) AS IsMarkReligious,

 isnull(b.StudentIID,0) as StudentID , isnull(b.StudentInsID,'') as StudentInsID, 
 isnull(b.FullName,'') as Name , isnull(b.RollNo,0) as Roll, 

(select isnull(t.SubjectID,0) as SubjectID from Res_StudentSubject as t 
where t.StudentID=b.StudentIID and t.OptionalType='HT' and  t.BranchID=@BranchID and t.VersionID=@VersionID 
and t.SessionId=@SessionID and t.ClassId=@ClassID and t.GroupId=@GroupID and t.IsDeleted=0) as ThirdSubjectID,
(select isnull(SubjectID,0) as SubjectID from Res_StudentSubject
where StudentID=b.StudentIID and OptionalType='FT' and  BranchID=@BranchID and VersionID=@VersionID 
and SessionId=@SessionID and ClassId=@ClassID and GroupId=@GroupID and IsDeleted=0) as FourthSubjectID, 
(select isnull(SubjectID,0) as SubjectID from Res_StudentSubject 
where StudentID=b.StudentIID and OptionalType='RT' and  BranchID=@BranchID and VersionID=@VersionID 
and SessionId=@SessionID and ClassId=@ClassID and GroupId=@GroupID and IsDeleted=0) as ReligiousSubjectID, 
isnull(b.VersionID,0) as VersionID, isnull(b.BranchID,0) as BranchId, isnull(b.ClassId,0) 
as ClassId, isnull(b.SessionId,0) as SessionId , isnull(b.GroupId,0) as GroupId
from Student_BasicInfo as b left outer join Res_StudentSubject
as o on b.StudentIID=o.StudentID and o.IsDeleted=0 where b.BranchID=@BranchID and b.VersionID=@VersionID 
and b.ShiftID=@ShiftID and b.SessionId=@SessionID and b.ClassId=@ClassID and b.SectionId =@SectionID
and b.GroupId=@GroupID and b.IsDeleted=0 Order By Roll Asc 
--End Student List with SujectId
End
Else
Begin
--Set Variable
Select @branch=b.BranchID,  @version=b.VersionID, @class=b.ClassId, @shift=b.ShiftID,
 @session=b.SessionId, @group=b.GroupId, @section=b.SectionId from Student_BasicInfo as b where b.StudentInsID=@StudentID and b.IsDeleted=0
--End Set Variable
--Student List with SujectId
Insert Into #StudentList Select distinct null,
ISNULL((SELECT TOP(1) SubjectID FROM Res_MainExamMarks WHERE StudentIID=b.StudentIID AND SubjectID=
(select TOP(1)  isnull(SubjectID,0) as SubjectID from Res_StudentSubject 
where StudentID=b.StudentIID and OptionalType='HT' and  BranchID=@branch and VersionID=@version 
and SessionId=@session and ClassId=@class and GroupId=@group and IsDeleted=0)
AND StudentIID=b.StudentIID AND VersionId=@version 
AND SessionId=@session AND ShiftId=@shift AND ClassId=@class AND GroupId=@group AND SectionId=@section
),0) AS IsMarkThird,

ISNULL((SELECT TOP(1) SubjectID FROM Res_MainExamMarks WHERE StudentIID=b.StudentIID AND SubjectID=

(select TOP(1) isnull(SubjectID,0) as SubjectID from Res_StudentSubject 
where StudentID=b.StudentIID and OptionalType='FT' and  BranchID=@branch and VersionID=@version 
and SessionId=@session and ClassId=@class and GroupId=@group and IsDeleted=0)
 AND StudentIID=b.StudentIID AND VersionId=@version 
AND SessionId=@session AND ShiftId=@shift AND ClassId=@class AND GroupId=@group AND SectionId=@section
),0) AS IsMarkFourth,

ISNULL((SELECT TOP(1) SubjectID FROM Res_MainExamMarks WHERE StudentIID=b.StudentIID AND SubjectID=
(select TOP(1) isnull(SubjectID,0) as SubjectID from Res_StudentSubject 
where StudentID=b.StudentIID and OptionalType='RT' and  BranchID=@branch and VersionID=@version 
and SessionId=@session and ClassId=@class and GroupId=@group and IsDeleted=0)
 AND StudentIID=b.StudentIID AND VersionId=@version 
AND SessionId=@session AND ShiftId=@shift AND ClassId=@class AND GroupId=@group AND SectionId=@section
),0) AS IsMarkReligious,



isnull(b.StudentIID,0) as StudentID , isnull(b.StudentInsID,0) as StudentInsID, 
isnull(b.FullName,'') as Name, isnull(b.RollNo,0) as Roll, 
(select  isnull(SubjectID,0) as SubjectID from Res_StudentSubject 
where StudentID=b.StudentIID and OptionalType='HT' and  BranchID=@branch and VersionID=@version 
and SessionId=@session and ClassId=@class and GroupId=@group and IsDeleted=0) as ThirdSubjectID,

(select isnull(SubjectID,0) as SubjectID from Res_StudentSubject 
where StudentID=b.StudentIID and OptionalType='FT' and  BranchID=@branch and VersionID=@version 
and SessionId=@session and ClassId=@class and GroupId=@group and IsDeleted=0) as FourthSubjectID,
(select isnull(SubjectID,0) as SubjectID from Res_StudentSubject 
where StudentID=b.StudentIID and OptionalType='RT' and  BranchID=@branch and VersionID=@version 
and SessionId=@session and ClassId=@class and GroupId=@group and IsDeleted=0) as ReligiousSubjectID, 
isnull(b.VersionID,0) as VersionID,isnull(b.BranchID,0) as BranchId, isnull(b.ClassId,0) as ClassId,
isnull(b.SessionId,0) as SessionId,isnull(b.GroupId,0) as GroupId
from Student_BasicInfo as b left outer join 
Res_StudentSubject as o on b.StudentIID=o.StudentID and o.IsDeleted=0  where b.StudentInsID = @StudentID
and b.IsDeleted=0 Order By Roll Asc
--End Student List with SujectId
End
update #StudentList set optionalID= case when #StudentList.ThirdSubjectID is null
and #StudentList.FourthSubjectID is null and #StudentList.ReligiousSubjectID is null then 0 else 1 end

Select * from #StudentList Order By  Roll Asc
--Third Subject
SELECT distinct case when IsPair=1 then (select top(1) SubID  from Res_SubjectSetup where FirstPairSubID=s.SubID or SecondPairSubID=s.SubID) else SubID end as [SubID], VersionID, SessionId, ClassId, GroupId, 
case when IsPair=1 then (select top(1) SubjectName from Res_SubjectSetup where FirstPairSubID=s.SubID or SecondPairSubID=s.SubID) else SubjectName end as [SubjectName] FROM Res_SubjectSetup
as s where  s.IsThird=1 and s.VersionID = @version and s.ClassId = @class
and s.SessionId = @session and s.GroupId = @group and s.IsDeleted=0 and s.SubjectType !='T' 
--End Third Subject

--Forth Subject
SELECT distinct case when IsPair=1 then (select top(1) SubID from Res_SubjectSetup where FirstPairSubID=s.SubID or SecondPairSubID=s.SubID) else SubID end as [SubID],
 VersionID, SessionId, ClassId, GroupId, case when IsPair=1 then (select top(1) SubjectName from Res_SubjectSetup 
 where FirstPairSubID=s.SubID or SecondPairSubID=s.SubID) else SubjectName end as [SubjectName] FROM Res_SubjectSetup
as s where  s.IsFourth=1 and s.VersionID = @version and s.ClassId = @class
and s.SessionId = @session and s.GroupId = @group and s.IsDeleted=0 and s.SubjectType !='T'
-- End Forth Subject

--Religious Subject
SELECT distinct case when IsPair=1 then (select top(1) SubID from Res_SubjectSetup where FirstPairSubID=s.SubID or SecondPairSubID=s.SubID) else SubID end as [SubID],
 VersionID, SessionId, ClassId, GroupId, case when IsPair=1 then (select top(1) SubjectName from Res_SubjectSetup 
 where FirstPairSubID=s.SubID or SecondPairSubID=s.SubID) else SubjectName end as [SubjectName] FROM Res_SubjectSetup
as s where  s.IsReligious=1 and s.VersionID = @version and s.ClassId = @class
and s.SessionId = @session and s.GroupId = @group and s.IsDeleted=0 and s.SubjectType !='T' 
--End Religious
End
Drop table #StudentList


--[dbo].[GetOptionalSubject] '1170912013'
--[dbo].[GetOptionalSubject] null,1,1,1,5,7,116,0 
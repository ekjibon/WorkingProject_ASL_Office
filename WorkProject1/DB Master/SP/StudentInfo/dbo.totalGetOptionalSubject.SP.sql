/****** Object:  StoredProcedure [dbo].[totalGetOptionalSubject]    Script Date: 7/22/2017 5:10:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[totalGetOptionalSubject]'))
BEGIN
DROP PROCEDURE  totalGetOptionalSubject
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[totalGetOptionalSubject] --'1411dhm113011111sad1004'
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
Declare @version int, @class int, @session int, @group int
if @StudentID is null
Begin
--Set Variable
Select @version=b.VersionID, @class=b.ClassId, @session=b.SessionId, @group=b.GroupId
from Student_BasicInfo as b where b.BranchID=@BranchID and b.VersionID=@VersionID 
and b.ShiftID=@ShiftID and b.SessionId=@SessionID and b.ClassId=@ClassID and b.SectionId =@SectionID
and b.GroupId=@GroupID
--End Set Variable

--Student List with SujectId
Select isnull(o.ID,0) as optionalID, isnull(b.StudentIID,0) as StudentID , isnull(b.StudentInsID,'') as StudentInsID, isnull(b.FullName,'') as Name , isnull(b.RollNo,0) as Roll, 
isnull(o.ThirdSubjectID,0) as ThirdSubjectID, isnull(o.FourthSubjectID,0) as FourthSubjectID, isnull( o.ReligiousSubjectID,0) as ReligiousSubjectID, 
isnull(b.VersionID,0) as VersionID, isnull(b.ClassId,0) as ClassId, isnull(b.SessionId,0) as SessionId , isnull(b.GroupId,0) as GroupId, 
isnull(o.AddBy,0) as AddBy, isnull(o.AddDate,0) as AddDate -- IsMark Join from Student Mark Table 
from Student_BasicInfo as b left outer join Res_OptionalSubjectSetup
as o on b.StudentIID=o.StudentID where b.BranchID=@BranchID and b.VersionID=@VersionID 
and b.ShiftID=@ShiftID and b.SessionId=@SessionID and b.ClassId=@ClassID and b.SectionId =@SectionID
and b.GroupId=@GroupID
--End Student List with SujectId
End
Else
Begin
--Set Variable
Select @StudentID = b.StudentInsID,  @version=b.VersionID, @class=b.ClassId, @session=b.SessionId, @group=b.GroupId
from Student_BasicInfo as b where b.StudentInsID=@StudentID 
--Set Variable
--Student List with SujectId
Select isnull(o.ID,0) as optionalID, isnull(b.StudentIID,0) as StudentID , isnull(b.StudentInsID,0) as StudentInsID, isnull(b.FullName,'') as Name , isnull(b.RollNo,0) as Roll, 
isnull(o.ThirdSubjectID,0) as ThirdSubjectID, isnull(o.FourthSubjectID,0) as FourthSubjectID, isnull( o.ReligiousSubjectID,0) as ReligiousSubjectID, 
isnull(b.VersionID,0) as VersionID, isnull(b.ClassId,0) as ClassId, isnull(b.SessionId,0) as SessionId , isnull(b.GroupId,0) as GroupId, 
isnull(o.AddBy,0) as AddBy, isnull(o.AddDate,0) as AddDate -- IsMark Join from Student Mark Table 
from Student_BasicInfo as b left outer join 
Res_OptionalSubjectSetup as o on b.StudentIID=o.StudentID where b.StudentInsID = @StudentID
--End Student List with SujectId
End
-------------  (select SubID from Res_SubjectSetup where SubID=SubID)
--Third Subject
SELECT distinct case when IsPair=1 then (select SubID from Res_SubjectSetup where FirstPairSubID=SubID or SecondPairSubID=SubID) else SubID end as [SubID], VersionID, SessionId, ClassId, GroupId, 
case when IsPair=1 then (select SubjectName from Res_SubjectSetup where FirstPairSubID=SubID or SecondPairSubID=SubID) else SubjectName end as [SubjectName] FROM Res_SubjectSetup
as s where  s.IsThird=1 and s.VersionID = @version and s.ClassId = @class
and s.SessionId = @session and s.GroupId = @group and s.IsDeleted=0  and s.Status='A'
--End Third Subject

--Forth Subject
SELECT SubID, VersionID, SessionId, ClassId, GroupId, SubjectName, ShortName  FROM Res_SubjectSetup
as s where  s.IsFourth=1 and s.VersionID = @version and s.ClassId = @class
and s.SessionId = @session and s.GroupId = @group and s.IsDeleted=0   and s.Status='A'
--End Forth Subject

--End Religious
SELECT SubID, VersionID, SessionId, ClassId, GroupId, SubjectName, ShortName  FROM Res_SubjectSetup
as s where  s.IsReligious=1 and s.VersionID = @version and s.ClassId = @class
and s.SessionId = @session and s.GroupId = @group and s.IsDeleted=0  and s.Status='A'
--End Religious
End

--[dbo].[GetOptionalSubject] '1411dhm113011111sad1004'
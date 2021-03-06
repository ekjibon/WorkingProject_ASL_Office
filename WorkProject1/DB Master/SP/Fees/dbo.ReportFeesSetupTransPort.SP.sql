/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ReportFeesSetupTransPort]'))
BEGIN
DROP PROCEDURE  ReportFeesSetupTransPort
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ReportFeesSetupTransPort] -- Total 13 param
	@Block INT = 0,
	@VersionId INT = 0,
	@SessionId INT = 0,
	@BranchID INT = 0,
	@ShiftID INT = 0,
	@ClassId INT = 0,
	@GroupId INT = 0,
	@SectionId INT = 0,
	@StudentTypeId INT =0,
	@StuIds VARCHAR(1000) = NULL,
	@ProcessId Int= 0,
	@Month int= 0,
	@RouteId int=0,
	@VehicleType VARCHAR(100) = NULL
	
	
AS
BEGIN


	 IF(@Block=1) --  TransPort Setup
-- execute ReportFeesSetupTransPort 1,1,15,12,10,28,2,35,'','1051','','','',''

 BEGIN

 Select S.FullName,S.StudentInsID,S.StudentIID,S.RollNo,R.RouteName,R.VehicleType,A.Amount,T.StudentTypeName ,
 Case
 When @VersionId=0 Then 'All'
 else  V.VersionName 
 end as VersionName
 ,
 Case
 When @SessionId=0 Then 'All'
 else  v.SessionName 
 end as SessionName
 
 ,
 Case
 When @BranchID=0 Then 'All'
 else   v.BranchName 
 end as  BranchName
 ,
 Case
 When @ShiftID=0 Then 'All'
 else   v.ShiftName
 end as  ShiftName

 ,
 Case
 When @ClassId=0 Then 'All'
 else  v.ClassName
 end as ClassName
 
 ,
 Case
 When @GroupId=0 Then 'All'
 else   v.GroupName
 end as  GroupName
 ,
 Case
 When @SectionId=0 Then 'All'
 else  V.SectionName 
 end as SectionName

 from dbo.Student_BasicInfo S Inner JOIN dbo.Ins_Route R ON S.RouteId=R.RouteId
 Inner Join view_CommonTableNames V On V.VersionId=S.VersionId AND V.SessionId=S.SessionId And V.BranchId=S.BranchId 
 And V.ShiftId=S.ShiftId And V.ClassId=S.ClassId And V.GroupId=S.GroupId And V.SectionId=S.SectionId
 Inner Join Fees_HeadAmountConfig A On A.StudentIID=s.StudentIID 
left Join dbo.Ins_StudentType T On t.StudentTypeId=S.StudentTypeId

 Where (S.VersionID=@VersionId  OR @VersionId=0 ) 
 And (S.SessionId=@SessionId  OR @SessionId =0) 
 AND (S.BranchID=@BranchID OR @BranchID =0)
 AND (S.ShiftID=@ShiftID  OR @ShiftID =0)
 AND (S.ClassId=@ClassId  OR @ClassId =0)
 AND (S.GroupId=@GroupId  OR @GroupId =0)
 AND (S.SectionId=@SectionId OR @SectionId =0)
 AND (R.RouteId=@RouteId  OR @RouteId=0)
 AND (R.VehicleType=@VehicleType OR @VehicleType='')
 AND (T.StudentTypeId=@StudentTypeId OR @StudentTypeId= 0)
 AND (A.ProcessId=@ProcessId OR @ProcessId=0)
 Order By S.VersionID,S.SessionId,S.BranchID,S.ShiftID,S.ClassId,S.GroupId,S.SectionId,Cast(S.RollNo as INT)
 END
END



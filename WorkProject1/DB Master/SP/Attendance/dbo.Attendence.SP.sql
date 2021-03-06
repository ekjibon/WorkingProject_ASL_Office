IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Attendence]'))
BEGIN
DROP PROCEDURE  Attendence
END
/****** Object:  StoredProcedure [dbo].[Attendence]    Script Date: 3/28/2019 11:55:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kawsar
-- Create date: 
-- Description:	
-- =============================================
-- execute [dbo].[Attendence] 8,1,12,58,'',1,2,1,1,'Pending','2018-02-27 00:00:00.000','2018-02-27 00:00:00.000','a824790f-6be8-4218-9c10-72eea8d83f89'
-- execute [dbo].[Attendence] 6,'','','','22','','','','','','','',''

CREATE  PROCEDURE [dbo].[Attendence] 
    @Block INT=0,
	@ShiftId INT =null,
	@ClassId INT = null,
	@SectionId INT = null,
	@StudentIID INT=null,
	@SessionId INT=null,
	@BranchId INT=null,
    @LeaveStatus Varchar(50) =null,
	@FromDate dateTime =null,
	@ToDate dateTime =null,
	@TeacherId varchar(50)=null
AS
BEGIN
if(@Block=1)
BEGIN  -- execute [dbo].[Attendence] 2,1,6,null,null,null,null,null,null,null,null,null,null
 select CP.*,S.ShiftName,C.ClassName from dbo.Rtn_ClassPeriod CP LEFT JOIN dbo.Ins_Shift S ON s.ShiftId= CP.ShiftId 
 LEFT JOIN dbo.Ins_ClassInfo C ON C.ClassId= CP.ClassId 
 where CP.IsDeleted=0 and (@ShiftId is null or S.ShiftId=@ShiftId) and (@ClassId is null or C.ClassId=@ClassId)
 END
if(@Block=2)
BEGIN -- execute [dbo].[Attendence] 2,null,null,null,null,null,null,null,null,null,null
 select SL.LIEOId,sl.SessionId,sl.BranchId,sl.ShiftId,sl.ClassId,sl.SectionId
 ,CONVERT(datetime, sl.StartTime) StartTime,CONVERT(datetime, sl.LateInTime) LateInTime,CONVERT(datetime, sl.EndTime) EndTime,CONVERT(datetime, sl.EarlyOutTime) EarlyOutTime
 ,Se.SessionName,B.BranchName,S.ShiftName,C.ClassName,Sec.SectionName from dbo.Att_StudentLIEO SL LEFT JOIN dbo.Ins_Shift S ON s.ShiftId= SL.ShiftId 

 left join Ins_Session Se on Se.SessionId=SL.SessionId
 left join Ins_Branch B on B.BranchId=SL.BranchId
 left join Ins_Shift Sh on Sh.ShiftId=SL.ShiftId
 LEFT JOIN dbo.Ins_ClassInfo C ON C.ClassId= SL.ClassId 

 LEFT JOIN dbo.Ins_Section Sec ON Sec.SectionId= SL.SectionId 
  
 where SL.IsDeleted=0 and SL.SessionId=ISNULL(@SessionId,SL.SessionId)
 and SL.BranchId=ISNULL(@BranchId,SL.BranchId) and SL.ShiftId=ISNULL(@ShiftId,SL.ShiftId) and SL.ClassId=ISNULL(@ClassId,SL.ClassId) 
 and SL.SectionId=ISNULL(@SectionId,SL.SectionId) 
 order by sl.LIEOId	 desc
 END
if(@Block=3)
BEGIN -- execute [dbo].[Attendence] 3,null,null,null,7,null,null,null,null,null,null,null,null
  select BI.StudentInsID,BI.ClassId,BI.ShiftID, BI.FullName,Student.SessionName,Student.BranchName,Student.ClassName,
 Student.SectionName,Student.ShiftName,ST.StudentTypeName
  from Student_BasicInfo AS BI
  left join vwStudentBasic Student on Student.StudentIID=@StudentIID
  left join Ins_StudentType ST on ST.StudentTypeId=BI.StudentTypeID
  where BI.StudentIID=@StudentIID
END
if(@Block=4)

BEGIN
 
  IF(@StudentIID is  null)
  BEGIN
   BEGIN -- execute [dbo].[Attendence] 4,1002,19,76,null,12,1,'5/19/2019 6:00:00 AM','5/29/2019 6:00:00 AM',null
	  select SL.LeaveId,SL.AddBy,SL.AddDate,SL.Description,SL.Duration,SL.FromDate,SL.ToDate,SL.Status,SL.RequestOn,SL.StudentIId,SL.UpdateDate, SL.UpdateBy,
	lt.TypeName LeaveType,sl.LeaveTypeId,sl.[File],SB.StudentInsID
	,SB.FullName, Ss.SessionName,B.BranchName, SB.StudentInsID,SB.RollNo, ST.StudentTypeName, S.ShiftName,C.ClassName,Se.SectionName,u.FullName as uFullName, SL.UpdateDate,
	 CASE 
	  WHEN SL.Status='Pending' Then 'skyblue' 
	  WHEN SL.Status='Delete' Then 'INDIANRED'  
	  WHEN SL.Status='Disapproved' Then 'INDIANRED' 
	  ELSE '#7DCEA0' 
	END as ColorCode 
	 from dbo.Att_StudentLeave SL 
	 INNER JOIN Student_BasicInfo SB ON SL.StudentIId=SB.StudentIID
	 Inner JOIN dbo.Ins_Session Ss ON Ss.SessionId= SB.SessionId
	 Inner JOIN dbo.Ins_Branch B ON B.BranchId= SB.BranchID
	 Inner JOIN dbo.Ins_Shift S ON s.ShiftId= SB.ShiftId 
	 Inner JOIN dbo.Ins_ClassInfo C ON C.ClassId= SB.ClassId 
	 Inner JOIN dbo.Ins_Section SE ON SE.SectionId= SB.SectionId 
	 Left JOIN dbo.Ins_StudentType ST ON ST.StudentTypeId= SB.StudentTypeID 
	 Left JOIN dbo.Att_LeaveTypes lt ON lt.LeaveId= SL.LeaveTypeId
	 Left JOIN dbo.AspNetUsers u ON u.UserName= SL.AddBy 
	  where SL.IsDeleted=0 and SB.SessionId=ISNULL(@SessionId,SB.SessionId) and Sb.BranchID=ISNULL(@BranchId,Sb.BranchID)
	 AND SB.ShiftID=ISNULL(@ShiftId,SB.ShiftID) and SB.ClassId=ISNULL(@ClassId,SB.ClassId) and SB.SectionId=ISNULL(@SectionId,SB.SectionId)
	 AND SL.[Status]=ISNULL(@LeaveStatus,SL.[Status])
	 And (SL.FromDate>=@FromDate AND SL.ToDate <=@ToDate) 
	 order by SL.RequestOn desc
	END
   END
   ELSE
   BEGIN
    select SL.LeaveId,SL.AddBy,SL.AddDate,SL.Description,SL.Duration,SL.FromDate,SL.ToDate,SL.Status,SL.RequestOn,SL.StudentIId,SL.UpdateBy,SL.UpdateDate
	,lt.TypeName LeaveType,sl.LeaveTypeId,sl.[File],SB.StudentInsID
	,SB.FullName, Ss.SessionName,B.BranchName, SB.StudentInsID,SB.RollNo, ST.StudentTypeName, S.ShiftName,C.ClassName,Se.SectionName,u.FullName as uFullName ,
	 CASE 
	  WHEN SL.Status='Pending' Then 'skyblue' 
	  WHEN SL.Status='Cancel' Then 'INDIANRED'  
	  ELSE '#7DCEA0' 
	END as ColorCode
	 from dbo.Att_StudentLeave SL 
	 INNER JOIN Student_BasicInfo SB ON SL.StudentIId=SB.StudentIID
	 Inner JOIN dbo.Ins_Session Ss ON Ss.SessionId= SB.SessionId
	 Inner JOIN dbo.Ins_Branch B ON B.BranchId= SB.BranchID
	 Inner JOIN dbo.Ins_Shift S ON s.ShiftId= SB.ShiftId 
	 Inner JOIN dbo.Ins_ClassInfo C ON C.ClassId= SB.ClassId 
	 Inner JOIN dbo.Ins_Section SE ON SE.SectionId= SB.SectionId 
	 Left JOIN dbo.Ins_StudentType ST ON ST.StudentTypeId= SB.StudentTypeID 
	  Left JOIN dbo.Att_LeaveTypes lt ON lt.LeaveId= SL.LeaveTypeId
	 Left JOIN dbo.AspNetUsers u ON u.UserName= SL.AddBy 
	 where SL.IsDeleted=0 and SB.StudentIID=@StudentIID
   END
 END
if(@Block=5)
BEGIN
 BEGIN
	DECLARE @TID INT
	SELECT @TID = EmpId FROM [dbo].[AspNetUsers] WHERE Id=@TeacherId
  --   Attendence 5,null,null,null,null,null,null,null,null,null,null,null,'49b0da3b-546a-4615-b77e-e620ad61f8a5'
       SELECT DISTINCT
	   V.[BranchName],  V.[SessionName], V.[ShiftName],  V.[ClassName], V.[SectionName],
	   V.[BranchId],V.[SessionId], V.[ShiftId], V.[ClassId],  V.[SectionId], C.[TeacherId], E.[FullName]	    
	   FROM [dbo].[Emp_ClassTeacher] AS C
	   INNER JOIN [view_CommonTableNames] AS V ON C.BranchID=V.BranchId AND C.ClassID=V.ClassId
	   AND C.SessionID=V.SessionId AND C.ShiftID=V.ShiftId AND C.SectionID=V.SectionId
	   INNER JOIN Emp_BasicInfo AS E ON C.TeacherID=E.EmpBasicInfoID AND E.IsDeleted=0	   
	   WHERE C.TeacherId=@TID AND C.IsDeleted=0
	   group by  V.[BranchName], V.[ClassName], V.[SessionName], V.[ShiftName], V.[SectionName],
	   V.[SessionId], V.[ClassId], V.[BranchId], V.[ShiftId], V.[SectionId], C.[TeacherId], E.[FullName]	  
	   ORDER BY   V.[SessionId], V.[BranchId], V.[ShiftId], V.[ClassId], V.[SectionId]
 END
END
 if(@Block=6)
BEGIN
	select s.LeaveId,
	s.FromDate,
	s.ToDate,
	s.Duration,
	s.RequestOn,
	s.[Status],
	u.FullName,
	s.UpdateDate,
	s.[File],
	lt.TypeName  LeaveType
	,s.UpdateBy,s.UpdateDate
	from Att_StudentLeave s
	Left JOIN dbo.AspNetUsers u ON u.Id= s.UpdateBy 
		  Left JOIN dbo.Att_LeaveTypes lt ON lt.LeaveId= S.LeaveTypeId
	where s.StudentIId=@StudentIID and s.IsDeleted=0 
	order by  s.LeaveId Desc
END
 if(@Block=7)
BEGIN
	select s.StudentIId,s.LeaveDate, s.LeaveId,s.startPeriodId,CLS.PeriodName startPeriodName, s.endPeriodId,CLE.PeriodName EndPeriodName,s.LeaveRequest,s.[Status],u.FullName,s.UpdateDate,s.[File],lt.TypeName  LeaveType,s.[File],s.UpdateBy,s.UpdateDate,s.IsDeleted
	from  dbo.Att_StudentPeriodLeave s
	Left JOIN dbo.Student_BasicInfo u ON u.StudentIID= s.StudentIID 
		  Left JOIN dbo.Att_LeaveTypes lt ON lt.LeaveId= S.LeaveTypeId
		  left join dbo.Rtn_ClassPeriod CLS ON CLS.PeriodId=s.startPeriodId
		  left join dbo.Rtn_ClassPeriod CLE ON CLE.PeriodId=s.endPeriodId
	where s.StudentIId=@StudentIID and s.IsDeleted=0 
	order by  s.LeaveId Desc
END
if(@Block=8)
BEGIN
 select SL.LeaveId,SL.AddBy,SL.AddDate,SL.Description,SL.Duration,SL.FromDate,SL.ToDate,SL.Status,SL.RequestOn,SL.StudentIId,SL.UpdateDate, SL.UpdateBy,
	lt.TypeName LeaveType,sl.LeaveTypeId,sl.[File],SB.StudentInsID
	,SB.FullName, Ss.SessionName,B.BranchName, SB.StudentInsID,SB.RollNo, ST.StudentTypeName, S.ShiftName,C.ClassName,Se.SectionName,u.FullName as uFullName, SL.UpdateDate,
	 CASE 
	  WHEN SL.Status='Pending' Then 'skyblue' 
	  WHEN SL.Status='Delete' Then 'INDIANRED'  
	  WHEN SL.Status='Disapproved' Then 'INDIANRED' 
	  ELSE '#7DCEA0' 
	END as ColorCode 
	 from dbo.Att_StudentLeave SL 
	 INNER JOIN Student_BasicInfo SB ON SL.StudentIId=SB.StudentIID
	 Inner JOIN dbo.Ins_Session Ss ON Ss.SessionId= SB.SessionId
	 Inner JOIN dbo.Ins_Branch B ON B.BranchId= SB.BranchID
	 Inner JOIN dbo.Ins_Shift S ON s.ShiftId= SB.ShiftId 
	 Inner JOIN dbo.Ins_ClassInfo C ON C.ClassId= SB.ClassId 
	 Inner JOIN dbo.Ins_Section SE ON SE.SectionId= SB.SectionId 
	 Left JOIN dbo.Ins_StudentType ST ON ST.StudentTypeId= SB.StudentTypeID 
	 Left JOIN dbo.Att_LeaveTypes lt ON lt.LeaveId= SL.LeaveTypeId
	 Left JOIN dbo.AspNetUsers u ON u.UserName= SL.AddBy
	 where SL.Status!='Delete'
	 order by SL.RequestOn desc
END
END




-- execute [dbo].[Attendence] 6,null,null,null,4307,null,null,null,null,null,null,null,null

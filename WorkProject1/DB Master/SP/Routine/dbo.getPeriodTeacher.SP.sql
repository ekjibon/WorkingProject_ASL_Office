/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[getPeriodTeacher]'))
BEGIN
DROP PROCEDURE  [getPeriodTeacher]
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
-- execute [dbo].[getPeriodTeacher] 2,1,10,8,null,null,null,null
CREATE PROCEDURE [dbo].[getPeriodTeacher] 
@block int,

@SessionId int =null,
@BranchId int =null,
@ShfiftId int =null,
@ClassId int =null,

@SectionId int =null
AS
BEGIN

If(@block=1)
	Begin
		 select PT.*, Ss.SessionName,B.BranchName, S.ShiftName,
		 C.ClassName,Sec.SectionName, EB.FullName,CP.PeriodName
		 from dbo.Rtn_PeriodTeacher PT
		
		 Inner JOIN dbo.Ins_Session Ss ON Ss.SessionId= PT.SessionId
		 Inner JOIN dbo.Ins_Branch B ON B.BranchId= PT.BranchID
		 Inner JOIN dbo.Ins_Shift S ON s.ShiftId= PT.ShiftId 
		 Inner JOIN dbo.Ins_ClassInfo C ON C.ClassId= PT.ClassId 
	
		  inner join Ins_Section Sec on Sec.SectionId=PT.SectionId
		 INNER JOIN  Rtn_ClassPeriod CP on CP.PeriodId=PT.[Period]
		 Inner JOIN Emp_BasicInfo EB ON PT.TeacherId=EB.EmpBasicInfoID
		 where PT.IsDeleted=0 
	 End
 
 If(@block=2)
	Begin
		select PT.*, Ss.SessionName,B.BranchName, S.ShiftName,C.ClassName,Sec.SectionName, EB.FullName,CP.PeriodName
		 from dbo.Rtn_PeriodTeacher PT
	
		 Inner JOIN dbo.Ins_Session Ss ON Ss.SessionId= PT.SessionId
		 Inner JOIN dbo.Ins_Branch B ON B.BranchId= PT.BranchID
		 Inner JOIN dbo.Ins_Shift S ON s.ShiftId= PT.ShiftId 
		 Inner JOIN dbo.Ins_ClassInfo C ON C.ClassId= PT.ClassId 
		
		 inner join Ins_Section Sec on Sec.SectionId=PT.SectionId
		 INNER JOIN  Rtn_ClassPeriod CP on CP.PeriodId=PT.[Period]
		 Inner JOIN Emp_BasicInfo EB ON PT.TeacherId=EB.EmpBasicInfoID
		 where PT.IsDeleted=0 And
		  PT.SessionId=isnull(@SessionId,pt.SessionId) And PT.BranchId=isnull(@BranchId,pt.BranchId) And PT.ShiftId=isnull(@ShfiftId,pt.ShiftId)
		 And PT.ClassId=isnull(@ClassId,pt.ClassId) 
	 End
END




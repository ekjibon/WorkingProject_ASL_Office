IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpTeacherList]'))
BEGIN
DROP PROCEDURE  [GetEmpTeacherList]
END
GO
/****** Object:  StoredProcedure [dbo].[ClassWiseResultProcess]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC ClassWiseResultProcess 10,19,8,1011
Create Procedure [dbo].[GetEmpTeacherList]

As
BEGIN
Create Table #EmpList (
PageID Int,
ParentID Int ,
NameOption_En Varchar(50),
[Action] varchar(50),
Controller varchar(50),
Displayorder INT,
IconClass varchar(50),
ModuleId INT
);

Insert INto #EmpList(PageID,ParentID,NameOption_En,[Action],Controller,Displayorder,IconClass,ModuleId) Values 
(1,0,'Dashboard', 'Dashboard', 'Employee', 1,'fas fa-address-card',0),
(2,0,'EmployeeProfile','EmployeeProfile','Employee',1,'fas fa-user-tie',0 ),
(3,0,'Mark Submission',NULL,NULL,1,'fas fa-user-tie',0 ),
(31,3,'Teacher ExamList','TeacherExamList','Result',1,'fas fa-user-tie',0 ),
(32,3,'TeacherMarksEntrySubjectList','TeacherMarksEntrySubjectList','Employee',1,'fas fa-user-tie',0 ),
(4,0,'EmployeeRequest','EmployeeRequest','Employee',1,'fas fa-bullhorn',0 ),
(5,0,'Parents Meeting','ParentsMeeting','Employee',1,'fas fa-handshake',0 ),
(6,0,'Newsletter','Newsletter','Notice',1,'fas fa-handshake',0 ),
(7,0,'ECAList','ECAList','ECA',1,'fas fa-road',0 ),
(8,0,'Routine','Routine','Employee',1,'fas fa-road',0 ),
(9,0,'Payroll','Payroll','Employee',1,'fas fa-road',0 )

Select * from #EmpList

END

-- select * from Inv_Product Where ProductId = 

--[rptGetAllProducList] '2019-08-4 00:00:00.000','2019-08-31 00:00:00.000',1
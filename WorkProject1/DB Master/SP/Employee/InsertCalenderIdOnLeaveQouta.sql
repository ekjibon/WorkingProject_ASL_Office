/****** Object:  StoredProcedure [dbo].[InsertCalenderIdOnLeaveQouta]    Script Date: 06/05/2020 11:33:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertCalenderIdOnLeaveQouta]'))
BEGIN
DROP PROCEDURE  InsertCalenderIdOnLeaveQouta
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Author: Khaled
---[dbo].[InsertCalenderIdOnLeaveQouta] 3
CREATE PROCEDURE [dbo].[InsertCalenderIdOnLeaveQouta] 
(
@CategoryID INT
)
AS
BEGIN


DECLARE @CalendarId INT
SET @CalendarId =(SELECT TOP(1) Id FROM [dbo].[Att_EmpAcademicCalendar] WHERE EmpCategory = @CategoryID ORDER BY Id DESC)  

 
INSERT INTO HR_EmpLeaveQuota ( [EmpId], [BranchId], [EmpCategory], [AnnualLeaveDay], [SickLeaveDay], [AdvanceLeaveDay], [MaternityLeaveDay], 
[IsDeleted], [AddBy], [AddDate], [UpdateBy], [UpdateDate], [Remarks], [Status], [IP], [MacAddress], [CalenderId])
	SELECT EmpBasicInfoID,BranchID,CategoryID,0,0,0,0,0,NULL,NULL,NULL,NULL,NUll,NULL,NUll,NULL,@CalendarId FROM Emp_BasicInfo WHERE CategoryID = @CategoryID  
END
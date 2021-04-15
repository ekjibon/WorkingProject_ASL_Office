--SELECT DATENAME(weekday, '2020-07-05')
--SELECT DATEADD(day, -3,(convert(date, '2020-07-05')))

/****** Object:  StoredProcedure [dbo].[GetLeaveDetailsEmpWise]    Script Date: 04/05/2020 3:23:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sandwichleave]'))
BEGIN
DROP PROCEDURE Sandwichleave
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---[dbo].[Sandwichleave] 3113
CREATE PROCEDURE [dbo].[Sandwichleave] 
(

@ID INT = Null

)
AS
BEGIN
DECLARE @CalendarId INT
DECLARE @FROMDATE DATETIME
DECLARE @TODATE DATETIME
DECLARE @NEWFROMDATE DATETIME
DECLARE @COMTODATE DATETIME
DECLARE @Sunday nvarchar(50)
DECLARE @Thusday DATETIME
DECLARE @EmpId INT


SELECT @FROMDATE=FromDate,@TODATE=ToDate,@EmpId=EmpId FROM Emp_Request WHERE Id=@ID AND LeaveCategoryId <> 4

SET @CalendarId =(SELECT TOP(1) Id FROM [dbo].[Att_EmpAcademicCalendar] 
                  WHERE EmpCategory = (SELECT CategoryID FROM Emp_BasicInfo 
				  WHERE EmpBasicInfoID= (SELECT EmpId FROM dbo.Emp_Request WHERE Id = @ID)) ORDER BY Id DESC)  

SELECT @Sunday = DATENAME(weekday,@FROMDATE)
--print @Sunday
IF( @Sunday='Sunday')
BEGIN
--print @Sunday
 SELECT @Thusday= DATEADD(day, -3,(convert(date, @FROMDATE)))
-- print @Thusday
 SELECT @COMTODATE= ToDate FROM dbo.Emp_Request WHERE EmpId = @EmpId AND ToDate = @Thusday AND Status ='Approved' 
 --print @COMTODATE
 IF(@COMTODATE = @Thusday )
 BEGIN
  --print @COMTODATE
  SELECT @NEWFROMDATE= DATEADD(day, -2,(convert(date, @FROMDATE)))
  UPDATE dbo.Emp_Request
  SET FromDate =@NEWFROMDATE ,Duration=3
  WHERE Id = @ID AND EmpId = @EmpId

  SELECT DISTINCT EMPR.*,LT.CategoryName,		
		CASE EMPR.RequestType
		WHEN  5 THEN 'For Leave'
		END RequestType
  ,EB.FullName RequestedBy,ED.DesignationName,
 Q.SickLeaveDay ,Q.AdvanceLeaveDay,Q.AnnualLeaveDay,Q.MaternityLeaveDay,
 CASE WHEN LT.Id = 1 THEN Q.SickLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 1 AND Status = 'Approved'),0)
      WHEN LT.Id = 2 THEN Q.AdvanceLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 2 AND Status = 'Approved'),0)
	  WHEN LT.Id = 3 THEN Q.AnnualLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 3 AND Status = 'Approved'),0)
	  WHEN LT.Id = 4 THEN Q.MaternityLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 4 AND Status = 'Approved'),0)
	  ELSE '0'
	  END AS Adjustable,
 CASE WHEN LT.Id = 1 THEN EMPR.Duration-(Q.SickLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 1 AND Status = 'Approved'),0))
      WHEN LT.Id = 2 THEN EMPR.Duration-(Q.AdvanceLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 2 AND Status = 'Approved'),0))
	  WHEN LT.Id = 3 THEN EMPR.Duration-(Q.AnnualLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 3 AND Status = 'Approved'),0))
	  WHEN LT.Id = 4 THEN EMPR.Duration-(Q.MaternityLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 4 AND Status = 'Approved'),0))
	  ELSE '0'
	  END AS Unadjusted
 FROM dbo.Emp_Request  EMPR
 INNER JOIN dbo.Emp_BasicInfo EB ON EMPR.EmpId = EB.EmpBasicInfoID 
  INNER JOIN [dbo].[Emp_Designation] ED ON ED.DesignationID = EB.DesignationID
  INNER JOIN [dbo].[HR_LeaveCategory] LT ON LT.Id = EMPR.LeaveCategoryId 
  INNER JOIN dbo.HR_EmpLeaveQuota Q ON Q.EmpId = EB.EmpBasicInfoID 
WHERE EMPR.Id = @ID  AND EMPR.RequestType = 5 and EMPR.IsDeleted=0  --AND Q.CalenderId = @CalendarId

 END

END
   

		   
END
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetEmployeeSMSHistory]'))
BEGIN
DROP PROCEDURE  rptGetEmployeeSMSHistory
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[rptGetEmployeeSMSHistory] '7/3/2018 12:00:00 AM','3/28/2019 12:00:00 AM',1,1
Create PROCEDURE [dbo].[rptGetEmployeeSMSHistory] -- Total 7 param
(
    @dateStart smalldatetime,
    @dateEnd smalldatetime, 
	@smsTypeId int = null,
	@categoryId int = null,
	@BranchID INT = NULL

	)
	
AS
BEGIN	
         IF @smsTypeId = 0 SET @smsTypeId  = NULL
		IF @categoryId = 0 SET @categoryId  = NULL
		IF @BranchID = 0 SET @BranchID  = NULL
	
		
		
	print @BranchID
	
SELECT  count(*) as TotalSms, sms.SendDateTime,sms.SMSBody,dbo.Emp_Designation.DesignationName,
(case when sms.SendStatus=1 then 'Success' 
			when sms.SendStatus=2 then 'Pending'
			ELSE 'Failed' END) as SendStatus
       
FROM    dbo.Emp_BasicInfo as EM left join
        dbo.Emp_Designation ON EM.DesignationID = dbo.Emp_Designation.DesignationID left join
		dbo.SMS_SMSSendHistroy sms on EM.EmpBasicInfoID=sms.EmpId inner join
		dbo.Emp_Status ON EM.StatusID = dbo.Emp_Status.StatusID
	WHERE 	

	     ( @BranchID is null OR EM.BranchID =@BranchID OR @BranchID=0)
		 and
		(@smsTypeId is null OR sms.SMSTypeId=@smsTypeId OR @smsTypeId=0)AND
		(@categoryId is null OR sms.CategoryId=@categoryId OR @categoryId=0)
		and EM.EmpBasicInfoID=sms.EmpId
		 AND EM.IsDeleted =0
		 and (sms.SendDateTime between @dateStart-1 and @dateEnd+1)
		 group by dbo.Emp_Designation.DesignationName, sms.SendDateTime,sms.SMSBody,sms.SendStatus

END
GO

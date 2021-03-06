/****** Object:  StoredProcedure [dbo].[GetStudentInfoByFilter]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptFeesMoneyReceiptModify]'))
BEGIN
DROP PROCEDURE  rptFeesMoneyReceiptModify
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].rptFeesMoneyReceiptModify -- Total 11 param
@Where varchar(MAX) = NULL
AS
BEGIN           
DECLARE @sql varchar(max)
SET @sql = '	 
     SELECT s.SessionName ,b.BranchName ,sh.ShiftName ,c.ClassName ,sc.SectionName ,
			sb.StudentIID,sb.RollNo, sb.StudentInsID, sb.FullName, 		
			H.[FeesHeadId] , H.[HeadName], U.UserName, FCM.AddDate AS TIME	,FCM.UpdateDate AS UpdateTIME,FCM.MoneyReceipt			
			FROM Fees_CollectionMaster FCM INNER JOIN
			dbo.Fees_CollectionDetails FD on FD.MasterID=FCM.Id		
			INNER JOIN dbo.Student_BasicInfo sb ON sb.StudentIID = FCM.StudentIID 
			
			left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
			left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
			left outer join dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId
			left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
			
			left outer join dbo.Ins_Section sc ON sb.SectionId = sc.SectionId
			INNER JOIN Fees_Head H ON H.FeesHeadId = FD.HeadId
			INNER JOIN AspNetUsers U ON FCM.AddBy=U.UserName
		  '
		PRINT(@sql)
	 IF(@Where IS NOT NULL and  @Where <> '')
	 BEGIN
 SET @sql = @sql + ' WHERE 1=1 '+ @Where
	 END
	  EXEC(@sql)
END

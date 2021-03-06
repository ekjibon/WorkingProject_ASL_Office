/****** Object:  StoredProcedure [dbo].[GetStudentInfoByFilter]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetOnlineCollection]'))
BEGIN
DROP PROCEDURE  GetOnlineCollection
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].GetOnlineCollection -- Total 11 param

@Where varchar(MAX) = NULL
AS
BEGIN           
DECLARE @sql varchar(max)



SET @sql = '	
		select  sb.StudentInsID,sb.FullName,sb.RollNo,Sty.StudentTypeName,fcm.ReceivedAmount,fcm.PCS_BankName,cast(fcm.PaymentDate as date) [Date],ltrim(right(convert(varchar(25), fcm.PaymentDate, 100), 7)) [Time] from dbo.Fees_CollectionMaster FCM
		INNER JOIN dbo.Student_BasicInfo SB on SB.StudentIID=FCM.StudentIID
		 left outer join dbo.Ins_Version v on sb.VersionID=v.VersionId
		 left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
		 left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
		 left outer join dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId
		 left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
		 left outer join dbo.Ins_Group g ON sb.GroupId = g.GroupId
		 left outer join dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
		 left outer join dbo.Ins_StudentType Sty ON Sty.StudentTypeId = sb.StudentTypeId
		  '
		PRINT(@sql)
	 IF(@Where IS NOT NULL and  @Where <> '')
	 BEGIN
 SET @sql = @sql + ' WHERE  '+ @Where
	 END
	 

	 SET @sql = @sql + '  ORDER BY cast(sb.RollNo AS INT)'
	  EXEC(@sql)
END

	--- EXEC rptStudentCollection '   SB.VersionID  IN (1)    AND  SB.SessionId  IN (1)   AND cm.PaymentDate = CAST('5/9/2018 12:00:00 AM' AS Date)'

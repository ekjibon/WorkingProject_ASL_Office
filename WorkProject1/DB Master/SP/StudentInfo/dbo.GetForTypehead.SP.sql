IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetForTypehead]'))
BEGIN
DROP PROCEDURE  GetForTypehead
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
 ---- [dbo].GetForTypehead '210',19
Create PROCEDURE [dbo].GetForTypehead 
	@SrchText VARCHAR(50),
	@Type INT
AS
BEGIN  
	--  GetForTypehead '01841300303',2
	IF(@Type=1)
	BEGIN
		 SELECT TOP 12 (RTRIM( S.StudentInsID) +' '+ S.FullName ) AS [Text], CAST( S.StudentIID AS varchar) AS [Value]
		 FROM Student_BasicInfo S 
		 WHERE s.IsDeleted=0 and s.Status='A' and ( S.StudentInsID like '%'+@SrchText+'%' OR S.FullName like '%'+@SrchText+'%' OR S.SMSNotificationNo like '%'+@SrchText+'%')
	END

	IF(@Type=2)
	BEGIN
		 SELECT TOP 12 (RTRIM( E.EmpID) +' '+ E.FullName ) AS [Text], CAST( E.EmpBasicInfoID AS varchar) AS [Value]
		 FROM Emp_BasicInfo E 
		 WHERE (E.IsDeleted=0 and E.Status='A') and (E.EmpID like '%'+@SrchText+'%' OR E.FullName like '%'+@SrchText+'%' OR E.MobileNo like '%'+@SrchText+'%' OR E.SMSNotificationNo like '%'+@SrchText+'%')
	END
	--for Feesbook Bar code
	IF(@Type=3)
	BEGIN
		 SELECT top 1 RTRIM(S.StudentIID) AS StudentID FROM Student_BasicInfo S 
		 join Fees_Student fs on fs.StudentIID=S.StudentIID
		 WHERE s.IsDeleted=0 and s.Status='A' and  fs.FeesBookNo=@SrchText
	END

	IF(@Type=4)
	BEGIN
		 SELECT TOP 12 (RTRIM( q.StudentInsID) +' '+ q.FullName ) AS [Text], CAST( q.StudentIID AS varchar) AS [Value] from (select * 
		 FROM Student_BasicInfo S 
		 WHERE  s.IsDeleted=0 and s.TransportFacility='Yes' and s.Status='A') as q where  q.StudentInsID like '%'+@SrchText+'%' OR q.FullName like '%'+@SrchText+'%' OR q.SMSNotificationNo like '%'+@SrchText+'%'
	END
	IF(@Type=5)
	BEGIN
	
	DECLARE @Search varchar(100),@TeacherId varchar(100)
	SET @Search =(select Data from  dbo.Split(@SrchText,'~') where id=1)
	SET @TeacherId =(select Data from  dbo.Split(@SrchText,'~') where id=2)
	print(@Search);
	print(@TeacherId);
	SELECT TOP 12 (RTRIM( S.StudentInsID) +' '+ S.FullName ) AS [Text], CAST( S.StudentIID AS varchar) AS [Value] from dbo.AspNetUsers u
inner join dbo.Emp_BasicInfo emp on emp.EmpID=u.UserName 
inner join dbo.Ins_Branch b on b.BranchId=emp.BranchID
inner join Student_BasicInfo S  on S.BranchId=b.BranchID
WHERE  s.IsDeleted=0  and S.StudentInsID like '%'+@Search+'%' OR S.FullName like '%'+@Search+'%' OR S.SMSNotificationNo like '%'+@Search+'%'
	and  u.UserName=@TeacherId


	 END
	 IF(@Type=6)
	BEGIN
		 SELECT TOP 12 (RTRIM( E.EmpID) +' '+ E.FullName ) AS [Text], CAST( E.EmpBasicInfoID AS varchar) AS [Value]
		 FROM Emp_BasicInfo E 
		 WHERE (E.IsDeleted=0 and E.Status='A' and E.IsClassTeacher=1) and (E.EmpID like '%'+@SrchText+'%' OR E.FullName like '%'+@SrchText+'%' OR E.MobileNo like '%'+@SrchText+'%')
	END


		IF(@Type=7) -- All Product
	BEGIN
		 SELECT TOP 12
		 (RTRIM( p.ProductCode) +' '+ p.ProductName ) AS [Text], CAST( p.ProductId AS varchar) AS [Value] ,CAST(ps.Quantity AS varchar)  AS [Type]
		 FROM dbo.Inv_Product p  
		      inner join dbo.Inv_UnitSetup u on u.UnitSetupId = p.UnitId
		      inner join dbo.Inv_ProductStocks ps on ps.ProductId = p.ProductId
		 WHERE ( p.IsDeleted=0 and p.Status='A' and  p.ProductName like '%'+@SrchText+'%' OR p.ProductCode like '%'+@SrchText+'%')
	END

		IF(@Type=8) -- Purchase Order
	BEGIN
		 SELECT TOP 12
		 (RTRIM( po.POCode) +' '+ s.SupplierName ) AS [Text], CAST( po.POId AS varchar) AS [Value]  
		 FROM dbo.Inv_PurchaseOrder po  
		 inner join dbo.Inv_Supplier s on s.SupplierId = po.SupplierId
		 WHERE ( po.IsDeleted=0 and po.[Status] ='A' and po.IsReceived = 0 and  po.POCode like '%'+@SrchText+'%' )
		 -- select * from dbo.Inv_PurchaseOrder
	END
	
			IF(@Type=9) -- Distributed Product
	BEGIN
		 SELECT TOP 12
		 (RTRIM( p.ProductCode) +' '+ p.ProductName ) AS [Text], CAST( p.ProductId AS varchar) AS [Value]  
		 FROM dbo.Inv_Product p  
		      inner join dbo.Inv_UnitSetup u on u.UnitSetupId = p.UnitId
		 WHERE ( p.IsDeleted=0 and p.ProductTypeId=2 and p.Status='A' and  (p.ProductName like '%'+@SrchText+'%' OR p.ProductCode like '%'+@SrchText+'%'))
	END

	IF(@Type=10) -- Selling Product
	BEGIN
		 SELECT TOP 12
		 (RTRIM( p.ProductCode) +' '+ p.ProductName ) AS [Text], CAST( p.ProductId AS varchar) AS [Value]  
		 FROM dbo.Inv_Product p  
		      inner join dbo.Inv_UnitSetup u on u.UnitSetupId = p.UnitId
		 WHERE ( p.IsDeleted=0 and p.ProductTypeId= 1 and p.[Status]='A' and  (p.ProductName like '%'+@SrchText+'%' OR p.ProductCode like '%'+@SrchText+'%'))
	END

		IF(@Type=11) -- Fixed Asset Product
	BEGIN
		 SELECT TOP 12
		 (RTRIM( p.ProductCode) +' '+ p.ProductName ) AS [Text], CAST( p.ProductId AS varchar) AS [Value]  
		 FROM dbo.Inv_Product p  
		      inner join dbo.Inv_UnitSetup u on u.UnitSetupId = p.UnitId
		 WHERE ( p.IsDeleted=0 and p.ProductTypeId=3 and p.[Status]='A' and  (p.ProductName like '%'+@SrchText+'%' OR p.ProductCode like '%'+@SrchText+'%'))
	END

	IF(@Type=12) --Without ClassTeacher
	BEGIN
		 SELECT TOP 12 (RTRIM( E.EmpID) +' '+ E.FullName ) AS [Text], CAST( E.EmpBasicInfoID AS varchar) AS [Value]
		 FROM Emp_BasicInfo E 
		 WHERE (E.IsDeleted=0 and E.Status='A') and (E.EmpID like '%'+@SrchText+'%' OR E.FullName like '%'+@SrchText+'%' OR E.MobileNo like '%'+@SrchText+'%')
	END
	IF(@Type=13)
	BEGIN
		 SELECT TOP 12 (RTRIM( S.StudentInsID) +' '+ S.FullName ) AS [Text], CAST( S.StudentIID AS varchar) AS [Value]
		 FROM Student_BasicInfo S 
		 WHERE s.IsDeleted=0 AND s.IsEnrollment = 1 and s.Status='A' and ( S.StudentInsID like '%'+@SrchText+'%' OR S.FullName like '%'+@SrchText+'%' OR S.SMSNotificationNo like '%'+@SrchText+'%')
	END
	IF(@Type=14)
	BEGIN
		 SELECT TOP 12 (RTRIM( E.EmpID) +' '+ E.FullName ) AS [Text], CAST( E.EmpBasicInfoID AS varchar) AS [Value]
		 FROM Emp_BasicInfo E 
		 WHERE (E.IsDeleted=0) and (E.EmpID like '%'+@SrchText+'%' OR E.FullName like '%'+@SrchText+'%' OR E.MobileNo like '%'+@SrchText+'%' OR E.SMSNotificationNo like '%'+@SrchText+'%')
	END
	IF(@Type=15)
	BEGIN
		 SELECT TOP 12 FullName As [Text], CAST(Id AS VARCHAR(MAX)) As [Value]
		 FROM CRM_Client C 
		 WHERE (C.IsDeleted=0) and (C.FullName like '%'+@SrchText+'%' OR C.ShortName like '%'+@SrchText+'%' OR C.Code like '%'+@SrchText+'%')
		 ORDER BY FullName ASC
	END
	IF(@Type=16)
	BEGIN
		 SELECT TOP 12 FullName As [Text], CAST(ShortName AS VARCHAR(MAX)) As [Value]
		 FROM CRM_Client C 
		 WHERE (C.IsDeleted=0) and (C.FullName like '%'+@SrchText+'%' OR C.ShortName like '%'+@SrchText+'%' OR C.Code like '%'+@SrchText+'%')
		 ORDER BY FullName ASC
	END
	IF(@Type=17)
	BEGIN
		 SELECT TOP 12 InvoiceNo As [Text], CAST(InvoiceNo AS VARCHAR(MAX)) As [Value]
		 FROM Invoice_InvoiceGenerate I 
		 WHERE (I.IsDeleted=0) and (I.InvoiceNo like '%'+@SrchText+'%')
		 GROUP BY InvoiceNo
		 ORDER BY InvoiceNo ASC
	END
	IF(@Type=18)
	BEGIN
		 SELECT TOP 12 (RTRIM( AU.UserName) +' '+ AU.FullName ) AS [Text], AU.Id AS [Value]
		 FROM AspNetUsers AU
		 WHERE (AU.UserName like '%'+@SrchText+'%' OR AU.FullName like '%'+@SrchText+'%')
	END
	IF(@Type=19)
	BEGIN
		 SELECT TOP 12 (RTRIM( AU.InvoiceNo)) AS [Text], CAST(AU.InvoiceNo AS VARCHAR(MAX)) AS [Value]
		 FROM Invoice_InvoicePrintMaster AU
		 WHERE (AU.IsDeleted=0) and (AU.InvoiceNo like '%'+@SrchText+'%')
	END
	--exec GetForTypehead 'New', 15
END



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_GetInvoiceGenerate'))
BEGIN
DROP PROCEDURE  SP_GetInvoiceGenerate
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
	--- EXEC SP_GetInvoiceGenerate 0,0,0,'3,4,5','','','',0,12

CREATE PROCEDURE [dbo].SP_GetInvoiceGenerate
(
    @YearID INT = 0,
	@MonthId INT = 0,
	@ClientId INT = 0,
	@InvoiceNo Nvarchar(max) = null,
	@FromDate nvarchar(max)=null,
	@ToDate nvarchar(max)=null,
	@InvoiceId Nvarchar(max) = null,
	@FilterType INT = 0,
	@Block INT = 0
)
AS
BEGIN 
IF(@FilterType=1)--Process Month
	BEGIN
		IF(@Block = 2) ---Invoice Modification,Generate ,Discount List  EXEC SP_GetInvoiceGenerate 2021,1,1042,'','','','',1,2
		BEGIN
		  SELECT IG.ClientId ,CC.ShortName,ISNULL(cc.ClientId,'')+'-'+CC.ShortName AS FullName,
		 ((SELECT SUM(DueAmount) FROM Invoice_InvoiceGenerate WHERE IsDeleted = 0 AND DueAmount>0
					AND ClientId =  IG.ClientId AND	 EOMONTH(datefromparts(Year,MonthId, 1)) <= EOMONTH(datefromparts(@YearId, @MonthId, 1)))-ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE IsDeleted = 0 AND IsPaid=0 AND InvoiceStatus='Discount' AND ClientId =  IG.ClientId AND	 EOMONTH(datefromparts(Year,MonthId, 1)) <= EOMONTH(datefromparts(@YearId, @MonthId, 1))),0))DueAmount
			FROM 
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id AND CC.ActivityStatus ='A'

			WHERE 
				IG.IsDeleted = 0  AND IG.DueAmount > 0 
				AND  IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				AND EOMONTH(datefromparts(IG.Year,IG.MonthId, 1)) <= EOMONTH(datefromparts(@YearId,@MonthId, 1))
				GROUP BY IG.ClientId , cc.ShortName,ISNULL(cc.ClientId,'')
		END
		IF(@Block =14)-- Get Invoice Discount List --- EXEC SP_GetInvoiceGenerate 2022,4,3,'','','','',1,14
		BEGIN
			SELECT IG.BillingHeadId,IBH.BillingHeadName,IG.DiscountlinkBillingHeadId,IBHD.BillingHeadName LinkBillingHeadName, IG.Quantity, IG.Rate, IG.TotalAmount, IG.Description, IG.DiscountPercentage
			FROM Invoice_InvoiceGenerate IG
			INNER JOIN Invoice_BillingHead IBH ON IBH.Id=IG.BillingHeadId
			LEFT JOIN Invoice_BillingHead IBHD ON IBHD.Id=IG.DiscountlinkBillingHeadId
			WHERE IG.IsDeleted = 0 AND IG.InvoiceStatus='Discount'
			AND  IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
			AND  EOMONTH(datefromparts(IG.Year,IG.MonthId, 1)) = EOMONTH(datefromparts(@YearId, @MonthId, 1))
				
		END	
		IF(@Block =15)--Invoice Discount list for Generate  --- EXEC SP_GetInvoiceGenerate 2020,12,0,'','','','',1,15
		BEGIN
			SELECT IG.Id,CC.ShortName, IG.InvoiceNo, IG.InvoiceAmount ,IG.ClientId ,IG.Year ,IG.MonthId ,IG.BillingHeadId ,IBH.BillingHeadName+'-'+LEFT(M.Text,3)+'-'+CAST(RIGHT(IG.Year,2) AS nvarchar(10))BillingHeadName,IG.Quantity, IG.Rate, IG.TotalAmount,IG.DueAmount,ISNULL(IG.CollectionAmount,0)CollectionAmount, IG.BillingPeriodStart,IG.BillingPeriodEnd,IG.IssueDate,IG.DueDate
			,IG.Status
			FROM 
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id
				inner join Common_DropDownConfig M on M.Type='Month' and M.Value=IG.MonthId

			WHERE 
				IG.IsDeleted = 0 AND IG.DueAmount > 0 AND  IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				AND  EOMONTH(datefromparts(IG.Year,IG.MonthId, 1)) <= EOMONTH(datefromparts(@YearId, @MonthId, 1))
				ORDER BY IG.Year,IG.MonthId
				
			
		END
	END
	ELSE  --Due Month
		BEGIN
		IF(@Block =1)--Invoice Show
		BEGIN
		  SELECT IIG.ClientId ,CC.Code,IIG.InvoiceNo, CC.ShortName,(SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE InvoiceNo=IIG.InvoiceNo)TotalTk
		   FROM  
				Invoice_InvoiceGenerate IIG 
				INNER JOIN CRM_Client CC ON IIG.ClientId = CC.Id AND CC.ActivityStatus ='A'
				INNER JOIN Invoice_BillingHead IBH ON IIG.BillingHeadId = IBH.Id  
				WHERE IIG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IIG.ClientId END
				AND  IIG.Year = CASE WHEN @YearID<>0 THEN @YearID ELSE IIG.Year END
				AND  IIG.MonthId = CASE WHEN @MonthId<>0 THEN @MonthId ELSE IIG.MonthId END
				GROUP BY IIG.ClientId ,IIG.InvoiceNo, cc.Code ,CC.ShortName
		END		
		IF(@Block = 2) ---Invoice Modification,Generate ,Discount List  EXEC SP_GetInvoiceGenerate 2020,1,0,'','','','',2
		BEGIN
		  SELECT IG.ClientId ,CC.ShortName,ISNULL(cc.ClientId,'')+'-'+CC.ShortName AS FullName,--SUM(IG.DueAmount)DueAmount --(SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE InvoiceNo=IG.InvoiceNo)InvoiceAmount
		 ((SELECT SUM(DueAmount) FROM Invoice_InvoiceGenerate WHERE IsDeleted = 0 AND DueAmount>0
					AND ClientId =  IG.ClientId AND	 EOMONTH(datefromparts(YEAR(DueDate),Month(DueDate), 1)) <= EOMONTH(datefromparts(@YearId, @MonthId, 1)))-ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE IsDeleted = 0 AND IsPaid=0 AND InvoiceStatus='Discount' AND ClientId =  IG.ClientId AND	 EOMONTH(datefromparts(YEAR(DueDate),Month(DueDate), 1)) <= EOMONTH(datefromparts(@YearId, @MonthId, 1))),0))DueAmount
			FROM 
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id AND CC.ActivityStatus ='A'

			WHERE 
				IG.IsDeleted = 0  AND IG.DueAmount > 0 
				AND  IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				AND  EOMONTH(datefromparts(YEAR(IG.DueDate),Month(IG.DueDate), 1)) <= EOMONTH(datefromparts(@YearId, @MonthId, 1))
				--AND  IG.Year = CASE WHEN @YearID<>0 THEN @YearID ELSE IG.Year END
				--AND  IG.MonthId = CASE WHEN @MonthId<>0 THEN @MonthId ELSE IG.MonthId END
			GROUP BY IG.ClientId , cc.ShortName,ISNULL(cc.ClientId,'') --,IG.InvoiceNo, IG.Status
		END			
		IF(@Block =3)--Invoice Modification,Generate  --- EXEC SP_GetInvoiceGenerate 2022,1,0,'','','','',3
		BEGIN
			SELECT IG.Id,CC.ShortName, IG.InvoiceNo, IG.InvoiceAmount ,IG.ClientId ,IG.Year ,IG.MonthId ,IG.BillingHeadId ,IBH.BillingHeadName+'-'+LEFT(M.Text,3)+'-'+CAST(RIGHT(IG.Year,2) AS nvarchar(10)) BillingHeadName,IG.Quantity, IG.Rate, IG.TotalAmount,IG.DueAmount,ISNULL(IG.CollectionAmount,0)CollectionAmount, IG.BillingPeriodStart,IG.BillingPeriodEnd,IG.IssueDate,IG.DueDate
			,IG.Status
			FROM 
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id
				inner join Common_DropDownConfig M on M.Type='Month' and M.Value=IG.MonthId

			WHERE 
				IG.IsDeleted = 0 AND IG.DueAmount > 0  AND  IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				AND  EOMONTH(datefromparts(YEAR(IG.DueDate),Month(IG.DueDate), 1)) <= EOMONTH(datefromparts(@YearId, @MonthId, 1))
				
				UNION ALL
				SELECT IG.Id,CC.ShortName, IG.InvoiceNo, IG.InvoiceAmount ,IG.ClientId ,IG.Year ,IG.MonthId ,IG.BillingHeadId ,IBH.BillingHeadName+'-'+LEFT(M.Text,3)+'-'+CAST(RIGHT(IG.Year,2) AS nvarchar(10))+CASE WHEN InvoiceStatus='Discount' THEN '-('+InvoiceStatus+')' ELSE '' END  BillingHeadName,IG.Quantity, IG.Rate, IG.TotalAmount,IG.DueAmount,ISNULL(IG.CollectionAmount,0)CollectionAmount, IG.BillingPeriodStart,IG.BillingPeriodEnd,IG.IssueDate,IG.DueDate
			,IG.Status
			FROM 
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id
				inner join Common_DropDownConfig M on M.Type='Month' and M.Value=IG.MonthId

			WHERE 
				IG.IsDeleted = 0 AND IG.InvoiceStatus='Discount' AND IG.IsPaid=0 AND  IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				AND  EOMONTH(datefromparts(YEAR(IG.DueDate),Month(IG.DueDate), 1)) <= EOMONTH(datefromparts(@YearId, @MonthId, 1))
				ORDER BY IG.Year,IG.MonthId
				
			
		END
		IF(@Block = 4) --- Invoice Payment EXEC SP_GetInvoiceGenerate 0,0,0,'','','','',4
		BEGIN
		  SELECT IG.InvoiceNo ,IG.ClientId ,ISNULL(cc.ClientId,'')+'-'+CC.ShortName AS FullName,--(SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IG.ClientId and InvoiceNo=IG.InvoiceNo)InvoiceAmount
		  (sum(IG.DueAmount)-ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IG.ClientId AND InvoiceNo=IG.InvoiceNo AND InvoiceStatus='Discount' AND IsPaid=0),0) )InvoiceAmount

			FROM 
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id AND CC.ActivityStatus ='A'

			WHERE 
				IG.IsDeleted = 0  AND IG.DueAmount>0
				AND  IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				AND  IG.InvoiceNo = CASE WHEN @InvoiceNo<>'' THEN @InvoiceNo ELSE IG.InvoiceNo END
				AND  IG.InvoiceNo <>''
				--AND  IG.Year = CASE WHEN @YearID<>0 THEN @YearID ELSE IG.Year END
				--AND  IG.MonthId = CASE WHEN @MonthId<>0 THEN @MonthId ELSE IG.MonthId END
			GROUP BY IG.ClientId , cc.FullName ,IG.InvoiceNo,ISNULL(cc.ClientId,''),CC.ShortName
		END			
		IF(@Block =5)--Invoice Payment EXEC SP_GetInvoiceGenerate 0,0,0,'VNSC/2020/10/26','','',5
		BEGIN
			SELECT IG.Id, IG.InvoiceNo, IG.InvoiceAmount ,IG.ClientId ,IG.Year ,IG.MonthId ,IG.BillingHeadId ,IBH.BillingHeadName+'-'+LEFT(M.Text,3)+'-'+CAST(RIGHT(IG.Year,2) AS nvarchar(10))BillingHeadName,IG.Quantity, IG.Rate, IG.TotalAmount, IG.BillingPeriodStart,IG.BillingPeriodEnd,IG.IssueDate,IG.DueDate,IG.DueAmount,ISNULL(IG.CollectionAmount,0)CollectionAmount
			,CASE WHEN DueAmount=0 AND CollectionAmount>0 THEN 'Paid' 
		WHEN DueAmount>0 AND CollectionAmount>0 THEN 'Partial Paid'
		ELSE IG.Status END Status
			FROM 
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id
				inner join Common_DropDownConfig M on M.Type='Month' and M.Value=IG.MonthId

			WHERE 
				IG.IsDeleted = 0 --AND IG.DueAmount > 0  
				AND  IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				--AND  IG.Year = CASE WHEN @YearId<>0 THEN @YearId ELSE IG.Year END
				--AND  IG.MonthId = CASE WHEN @MonthId<>0 THEN @MonthId ELSE IG.MonthId END
				AND  IG.InvoiceNo = @InvoiceNo
		END
		IF(@Block =6)--Invoice Payment Collection
		BEGIN
			SELECT IG.Id, IG.InvoiceNo, IG.InvoiceAmount ,IG.ClientId ,IG.Year ,IG.MonthId ,IG.BillingHeadId ,IBH.BillingHeadName+'-'+LEFT(M.Text,3)+'-'+CAST(RIGHT(IG.Year,2) AS nvarchar(10))BillingHeadName,IG.Quantity, IG.Rate, IG.TotalAmount, IG.BillingPeriodStart,IG.BillingPeriodEnd,IG.IssueDate,IG.DueDate
			 ,CASE WHEN DueAmount=0 AND CollectionAmount>0 THEN 'Paid' 
		WHEN DueAmount>0 AND CollectionAmount>0 THEN 'Partial Paid'
		ELSE 'Draft' END Status, CC.FullName, CC.Address,
		ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IG.ClientId AND DiscountlinkBillingHeadId=IG.BillingHeadId AND Year=IG.Year AND MonthId=IG.MonthId AND InvoiceNo=IG.InvoiceNo AND IsPaid=0),0)DiscountAmount,
		IG.DueAmount - (ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IG.ClientId AND DiscountlinkBillingHeadId=IG.BillingHeadId AND Year=IG.Year AND MonthId=IG.MonthId AND InvoiceNo=IG.InvoiceNo AND IsPaid=0),0))DueAmount,
		IG.DueAmount - (ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IG.ClientId AND DiscountlinkBillingHeadId=IG.BillingHeadId AND Year=IG.Year AND MonthId=IG.MonthId AND InvoiceNo=IG.InvoiceNo AND IsPaid=0),0))CollectionAmount
			FROM 
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id
				inner join Common_DropDownConfig M on M.Type='Month' and M.Value=IG.MonthId

			WHERE 
				IG.IsDeleted = 0 AND IG.InvoiceNo =@InvoiceNo  AND ISNULL(IG.IsPublish,0) =1 AND IG.DueAmount > 0 AND  IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
		END
		IF(@Block =7) --Invoice Print --- EXEC SP_GetInvoiceGenerate 2022,1,0,'BAFSK','','','3095,2113,2112,1068,1069,1071,1072,1073,1074,3102,3103,3104,2115,2116,2117,1070,2,3,4,2090,3109,3110,5,6,7,8,9,10,2119,2120,2121,2122,2123,3091,3092,3093,1054',2,7
		BEGIN
		 Select  Value Into #InvNo from string_split(@InvoiceNo,',')
		 DECLARE @InvCnt varchar(5), @InvoiceNoP varchar(100), @InvoiceAmountP DECIMAL(18,2), @ClientIdP INT=0, @BillingMonthP varchar(100),@DueDateP DATETIME,@BillingPeriodStartP DATETIME,@BillingPeriodEndP DATETIME,@MasterIdP INT=0

		 DECLARE Structure_Cursor CURSOR FOR 
	
				SELECT IIG.ClientId FROM Invoice_InvoiceGenerate IIG 
				INNER JOIN CRM_Client CC ON IIG.ClientId = CC.Id
				WHERE CC.ShortName  in(Select * from #InvNo)
				AND IIG.Id IN  (SELECT value  FROM STRING_SPLIT(@InvoiceId, ','))
				AND IIG.IsDeleted = 0 
				AND  EOMONTH(datefromparts(YEAR(IIG.DueDate),Month(IIG.DueDate), 1)) <= EOMONTH(datefromparts(@YearId, @MonthId, 1))
				GROUP BY IIG.ClientId
				
	
	OPEN Structure_Cursor;

	FETCH NEXT FROM Structure_Cursor 
	INTO @ClientIdP

	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF(@ClientIdP>0)
			BEGIN
			 SET @InvCnt=(SELECT REPLACE( STR( isnull(max(cast(isnull(right(InvoiceNo,5),0) as int)),0)+1,5),space(1),'0') FROM Invoice_InvoicePrintMaster  )
		 SET @InvoiceNoP=CONVERT(varchar,right(year(getdate()),2))+CONVERT(varchar,REPLACE( STR(month(getdate()),2),space(1),'0'))+CONVERT(varchar,REPLACE( STR(day(getdate()),2),space(1),'0'))+@InvCnt;
		 --UPDATE IIG SET IIG.InvoiceNo=CC.ShortName+'-'+CONVERT(varchar,@YearId)+'-'+CONVERT(varchar,REPLACE( STR(@MonthId,2),space(1),'0'))+'-'+CONVERT(varchar,REPLACE( STR(day(getdate()),2),space(1),'0'))
		UPDATE IIG SET IIG.InvoiceNo=@InvoiceNoP
		   FROM  
				Invoice_InvoiceGenerate IIG 
				INNER JOIN CRM_Client CC ON IIG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IIG.BillingHeadId = IBH.Id 
				INNER JOIN Common_DropDownConfig M ON M.Value=IIG.MonthId AND Type='Month'

				WHERE IIG.ClientId=@ClientIdP
				AND IIG.Id IN  (SELECT value  FROM STRING_SPLIT(@InvoiceId, ','))
				AND IIG.IsDeleted = 0 
				AND  EOMONTH(datefromparts(YEAR(IIG.DueDate),Month(IIG.DueDate), 1)) <= EOMONTH(datefromparts(@YearId, @MonthId, 1))

		 SELECT TOP 1 @BillingPeriodStartP=CAST(CAST(Year AS VARCHAR(4)) + '-' + CONVERT(varchar,REPLACE( STR(MonthId,2),space(1),'0')) + '-01' AS DATETIME) FROM Invoice_InvoiceGenerate WHERE InvoiceNo=@InvoiceNoP ORDER BY Year,MonthId ASC
		 SELECT TOP 1 @BillingPeriodEndP=DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, CAST(CAST(Year AS VARCHAR(4)) + '-' + CONVERT(varchar,REPLACE( STR(MonthId,2),space(1),'0')) + '-01' AS DATETIME)) + 1, 0))    FROM Invoice_InvoiceGenerate WHERE InvoiceNo=@InvoiceNoP AND YEAR=(SELECT  TOP 1 YEAR FROM Invoice_InvoiceGenerate WHERE InvoiceNo=@InvoiceNoP ORDER BY YEAR DESC) ORDER BY MonthId DESC

		  SELECT  @InvoiceAmountP=((select sum(DueAmount) from Invoice_InvoiceGenerate where InvoiceNo=IIG.InvoiceNo and Id IN  (SELECT value  FROM STRING_SPLIT(@InvoiceId, ',')))-ISNULL((select sum(TotalAmount) from Invoice_InvoiceGenerate where InvoiceNo=IIG.InvoiceNo AND InvoiceStatus='Discount' and Id IN  (SELECT value  FROM STRING_SPLIT(@InvoiceId, ','))),0))
		  ,@BillingMonthP=ISNULL((SELECT  STUFF((SELECT  ', ' + LEFT(M.Text,3)+' '+CAST(RIGHT(Year,2) AS nvarchar(10)) FROM Invoice_InvoiceGenerate G
		 inner join Common_DropDownConfig M on M.Type='Month' and M.Value=G.MonthId 
		  WHERE G.ClientId=IIG.ClientId AND InvoiceNo=IIG.InvoiceNo  AND G.IsDeleted = 0 AND G.DueAmount>0  GROUP BY M.Text,G.MonthId,G.Year ORDER BY G.Year,G.MonthId    FOR XML PATH('')), 1, 1, '')),'')
		  ,@DueDateP=DATEADD(DD,15,getdate())
		   FROM  
				Invoice_InvoiceGenerate IIG 
				INNER JOIN CRM_Client CC ON IIG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IIG.BillingHeadId = IBH.Id 
				INNER JOIN Common_DropDownConfig M ON M.Value=IIG.MonthId AND Type='Month'

				WHERE IIG.ClientId=@ClientIdP
				AND IIG.Id IN  (SELECT value  FROM STRING_SPLIT(@InvoiceId, ','))
				AND IIG.IsDeleted = 0 
				AND  EOMONTH(datefromparts(YEAR(IIG.DueDate),Month(IIG.DueDate), 1)) <= EOMONTH(datefromparts(@YearId, @MonthId, 1))
				ORDER BY CC.ShortName,IIG.Year,IIG.MonthId

			INSERT INTO Invoice_InvoicePrintMaster([InvoiceNo], [InvoiceAmount], [ClientId], [BillingMonth], [InvoiceDate], [DueDate], [BillingPeriodStart], [BillingPeriodEnd], [IsDeleted], [AddBy], [AddDate],[PaymentStatus])
			VALUES(@InvoiceNoP,@InvoiceAmountP,@ClientIdP,@BillingMonthP,getdate(),@DueDateP,@BillingPeriodStartP,@BillingPeriodEndP,0,'Admin',getdate(),'Draft')
			SELECT @MasterIdP = @@IDENTITY 

		  INSERT INTO Invoice_InvoicePrintDetails ([MasterId], [ClientId], [Year], [MonthId], [BillingHeadId], [Quantity], [Rate], [SubTotalAmount], [DiscountAmount], [NetTotalAmount], [DueStatus], [IsDeleted], [AddBy], [AddDate],[BillingHeadName],[DiscountHeadName])
		  SELECT @MasterIdP,IIG.ClientId,IIG.Year,IIG.MonthId,IIG.BillingHeadId,IIG.Quantity,IIG.Rate,IIG.TotalAmount,ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IIG.ClientId AND DiscountlinkBillingHeadId=IIG.BillingHeadId AND Year=IIG.Year AND MonthId=IIG.MonthId AND InvoiceNo=IIG.InvoiceNo AND IsPaid=0),0),(IIG.TotalAmount-ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IIG.ClientId AND DiscountlinkBillingHeadId=IIG.BillingHeadId AND Year=IIG.Year AND MonthId=IIG.MonthId AND InvoiceNo=IIG.InvoiceNo AND IsPaid=0),0)),
		  CASE WHEN IIG.MonthId=( SELECT TOP 1 MonthId FROM Invoice_InvoiceGenerate WHERE InvoiceNo=@InvoiceNoP AND YEAR=(SELECT  TOP 1 YEAR FROM Invoice_InvoiceGenerate WHERE InvoiceNo=@InvoiceNoP ORDER BY YEAR DESC) ORDER BY MonthId DESC) THEN 'Current Bill' ELSE 'Previous Due' END,0,'Admin',getdate()
		  , CASE WHEN ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IIG.ClientId AND DiscountlinkBillingHeadId=IIG.BillingHeadId AND Year=IIG.Year AND MonthId=IIG.MonthId AND InvoiceNo=IIG.InvoiceNo AND IsPaid=0),0)>0 THEN IBH.BillingHeadName+'-'+LEFT(M.Text,3)+'-'+CAST(RIGHT(IIG.Year,2) AS nvarchar(10)) +'<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+ 'Less: ' + (select BillingHeadName from Invoice_BillingHead where Id=(SELECT BillingHeadId FROM Invoice_InvoiceGenerate WHERE ClientId=IIG.ClientId AND DiscountlinkBillingHeadId=IIG.BillingHeadId AND Year=IIG.Year AND MonthId=IIG.MonthId AND InvoiceNo=IIG.InvoiceNo AND IsPaid=0))
		  ELSE IBH.BillingHeadName+'-'+LEFT(M.Text,3)+'-'+CAST(RIGHT(IIG.Year,2) AS nvarchar(10)) END
		  ,(select BillingHeadName from Invoice_BillingHead where Id=(SELECT BillingHeadId FROM Invoice_InvoiceGenerate WHERE ClientId=IIG.ClientId AND DiscountlinkBillingHeadId=IIG.BillingHeadId AND Year=IIG.Year AND MonthId=IIG.MonthId AND InvoiceNo=IIG.InvoiceNo AND IsPaid=0))
		   FROM  
				Invoice_InvoiceGenerate IIG 
				INNER JOIN CRM_Client CC ON IIG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IIG.BillingHeadId = IBH.Id 
				INNER JOIN Common_DropDownConfig M ON M.Value=IIG.MonthId AND Type='Month'
				WHERE IIG.ClientId=@ClientIdP
				AND IIG.Id IN  (SELECT value  FROM STRING_SPLIT(@InvoiceId, ','))
				AND IIG.IsDeleted = 0  AND IIG.InvoiceStatus IS NULL
				AND  EOMONTH(datefromparts(YEAR(IIG.DueDate),Month(IIG.DueDate), 1)) <= EOMONTH(datefromparts(@YearId, @MonthId, 1))
				ORDER BY CC.ShortName,IIG.Year,IIG.MonthId
			END		
			
		FETCH NEXT FROM Structure_Cursor 
		
		INTO  @ClientIdP
		END
		DEALLOCATE Structure_Cursor;

		
		

		  SELECT IIG.Id,IIG.InvoiceNo,IIG.InvoiceAmount,IIG.ClientId,IIG.Year,IIG.BillingHeadId,IIG.Quantity,IIG.Rate,IIG.TotalAmount SubTotalAmount,ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IIG.ClientId AND DiscountlinkBillingHeadId=IIG.BillingHeadId AND Year=IIG.Year AND MonthId=IIG.MonthId AND InvoiceNo=IIG.InvoiceNo AND IsPaid=0),0)DiscountAmount,(IIG.TotalAmount-ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IIG.ClientId AND DiscountlinkBillingHeadId=IIG.BillingHeadId AND Year=IIG.Year AND MonthId=IIG.MonthId AND InvoiceNo=IIG.InvoiceNo AND IsPaid=0),0))NetTotalAmount,getdate() IssueDate,IPM.DueDate,IPM.BillingPeriodStart,IPM.BillingPeriodEnd,CC.Code,CC.FullName,CC.Address, CC.ShortName
		  ,  CASE WHEN ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IIG.ClientId AND DiscountlinkBillingHeadId=IIG.BillingHeadId AND Year=IIG.Year AND MonthId=IIG.MonthId AND InvoiceNo=IIG.InvoiceNo AND IsPaid=0),0)>0 THEN IBH.BillingHeadName+'-'+LEFT(M.Text,3)+'-'+CAST(RIGHT(IIG.Year,2) AS nvarchar(10)) +'<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+ 'Less: ' +  (select BillingHeadName from Invoice_BillingHead where Id=(SELECT BillingHeadId FROM Invoice_InvoiceGenerate WHERE ClientId=IIG.ClientId AND DiscountlinkBillingHeadId=IIG.BillingHeadId AND Year=IIG.Year AND MonthId=IIG.MonthId AND InvoiceNo=IIG.InvoiceNo AND IsPaid=0))
		  ELSE IBH.BillingHeadName+'-'+LEFT(M.Text,3)+'-'+CAST(RIGHT(IIG.Year,2) AS nvarchar(10)) END BillingHeadName
		  ,(select BillingHeadName from Invoice_BillingHead where Id=(SELECT BillingHeadId FROM Invoice_InvoiceGenerate WHERE ClientId=IIG.ClientId AND DiscountlinkBillingHeadId=IIG.BillingHeadId AND Year=IIG.Year AND MonthId=IIG.MonthId AND InvoiceNo=IIG.InvoiceNo AND IsPaid=0))DiscountHeadName
		  ,IPM.InvoiceAmount TotalDueAmount
		  ,[dbo].[fNumToWordsBD](IPM.InvoiceAmount)TotalDueAmountInword,IPM.BillingMonth,IIG.DueAmount,ISNULL(IIG.CollectionAmount,0)CollectionAmount,
		  IPM.InvoiceAmount TotalInvoiceAmount,  CASE WHEN IIG.MonthId=( SELECT TOP 1 MonthId FROM Invoice_InvoiceGenerate WHERE InvoiceNo=@InvoiceNoP AND YEAR=(SELECT  TOP 1 YEAR FROM Invoice_InvoiceGenerate WHERE InvoiceNo=@InvoiceNoP ORDER BY YEAR DESC) ORDER BY MonthId DESC) THEN 'Current Bill' ELSE 'Previous Due' END DueStatus
		   FROM  
				Invoice_InvoiceGenerate IIG 
				INNER JOIN CRM_Client CC ON IIG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IIG.BillingHeadId = IBH.Id 
				INNER JOIN Common_DropDownConfig M ON M.Value=IIG.MonthId AND Type='Month'
				INNER JOIN Invoice_InvoicePrintMaster IPM ON IPM.InvoiceNo = IIG.InvoiceNo 
				WHERE CC.ShortName  in(Select * from #InvNo)
				AND IIG.Id IN  (SELECT value  FROM STRING_SPLIT(@InvoiceId, ','))
				AND IIG.IsDeleted = 0 AND IIG.InvoiceStatus IS NULL
				AND  EOMONTH(datefromparts(YEAR(IIG.DueDate),Month(IIG.DueDate), 1)) <= EOMONTH(datefromparts(@YearId, @MonthId, 1))
				ORDER BY CC.ShortName,IIG.Year,IIG.MonthId DESC
			
		END
		IF(@Block =8) --Collection Print --- EXEC SP_GetInvoiceGenerate 0,0,1,0,'2020-11-01 00:00:00.000','2020-12-30 00:00:00.000',8
		BEGIN
		  SELECT CC.FullName, ICM.InvoiceNo, IBH.BillingHeadName, ICD.Year, CDDC.Text, ICD.Quantity, ICD.Rate, ICD.TotalAmount, ICD.CollectionAmount, @FromDate FromDate,@ToDate ToDate, ICM.CollectionDate,
		  CASE WHEN @ClientId<>0 THEN CC.FullName ELSE 'All' END ClientName
		   FROM  
				Invoice_CollectionMaster ICM
				INNER JOIN CRM_Client CC ON ICM.ClientId = CC.Id
				INNER JOIN Invoice_CollectionDetails ICD ON ICM.Id = ICD.MasterID
				INNER JOIN Invoice_BillingHead IBH ON ICD.BillingHeadId = IBH.Id 
				INNER JOIN Common_DropDownConfig CDDC ON CDDC.Value=ICD.MonthId AND Type='Month'
			WHERE 
				ICM.IsDeleted = 0 AND ICM.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE ICM.ClientId END
				AND  ICD.Year = CASE WHEN @YearId<>0 THEN @YearId ELSE ICD.Year END
				AND  ICD.MonthId = CASE WHEN @MonthId<>0 THEN @MonthId ELSE ICD.MonthId END
				AND	 (CAST(ICM.CollectionDate as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date)) 
		END
		IF(@Block =9) --Due Print --- EXEC SP_GetInvoiceGenerate 0,0,1,0,'2020-11-01 00:00:00.000','2020-12-30 00:00:00.000',9
		BEGIN
		  SELECT CC.FullName, IG.InvoiceNo, IBH.BillingHeadName, IG.Year, CDDC.Text, IG.Quantity, IG.Rate, IG.TotalAmount, IG.DueAmount, @FromDate FromDate,@ToDate ToDate, IG.IssueDate,
		  CASE WHEN @ClientId<>0 THEN CC.FullName ELSE 'All' END ClientName
		   FROM  
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id 
				INNER JOIN Common_DropDownConfig CDDC ON CDDC.Value=IG.MonthId AND Type='Month'
			WHERE 
				IG.IsDeleted = 0 AND IG.DueAmount>0
				AND IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				AND  IG.Year = CASE WHEN @YearId<>0 THEN @YearId ELSE IG.Year END
				AND  IG.MonthId = CASE WHEN @MonthId<>0 THEN @MonthId ELSE IG.MonthId END
				AND	 (CAST(IG.IssueDate as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date)) 
		END
		IF(@Block =10)--Invoice Show --- EXEC SP_GetInvoiceGenerate 0,0,0,'AGHS0001','','',10
		BEGIN
		  SELECT IIG.* ,CC.Code,IIG.InvoiceNo, CC.ShortName, IBH.BillingHeadName,
		  (SELECT SUM(DueAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IIG.ClientId AND BillingHeadId=IIG.BillingHeadId and Year=IIG.Year and MonthId<IIG.MonthId)PreviousDueAmount
		  ,ISNULL((SELECT  STUFF((SELECT ', ' + M.Text FROM Invoice_InvoiceGenerate G
		  inner join Common_DropDownConfig M on M.Type='Month' and M.Value=G.MonthId 
					WHERE ClientId=IIG.ClientId AND BillingHeadId=IIG.BillingHeadId AND G.DueAmount>0 AND Year=IIG.Year AND MonthId<IIG.MonthId FOR XML PATH('')), 1, 1, '')),'') MonthNames
		   FROM  
				Invoice_InvoiceGenerate IIG 
				INNER JOIN CRM_Client CC ON IIG.ClientId = CC.Id AND CC.ActivityStatus ='A'
				INNER JOIN Invoice_BillingHead IBH ON IIG.BillingHeadId = IBH.Id  
				WHERE IIG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IIG.ClientId END
				AND  IIG.Year = CASE WHEN @YearID<>0 THEN @YearID ELSE IIG.Year END
				AND  IIG.MonthId = CASE WHEN @MonthId<>0 THEN @MonthId ELSE IIG.MonthId END
				AND IIG.InvoiceNo = @InvoiceNo
		END	
		IF(@Block =11)--Get Money Receipt --- EXEC SP_GetInvoiceGenerate 0,0,0,'AGHS0001','','',11
		BEGIN
		  SELECT ICM.Id MasterID,ISNULL(cc.ClientId,'')+'-'+CC.ShortName AS FullName,ICM.ClientId,   ICM.CollectionAmount, (CAST(ICM.CollectionDate AS date))CollectionDate,ICM.PaymentMethod,ChequeNo,InvoiceNo,InvoiceAmount
		   FROM  
				Invoice_CollectionMaster ICM
				INNER JOIN CRM_Client CC ON ICM.ClientId = CC.Id
			WHERE ICM.IsDeleted = 0 AND ICM.CollectionAmount>0
				AND ICM.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE ICM.ClientId END
				AND	 (CAST(ICM.CollectionDate as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date)) 
				ORDER BY CC.ShortName, (CAST(ICM.CollectionDate AS date))
		END	
		IF(@Block =12)-- Money Receipt Print --- EXEC SP_GetInvoiceGenerate 0,0,0,'1,2','','',12
		BEGIN
		 Select  Value Into #MasterId from string_split(@InvoiceNo,',')

		   SELECT M.Id MasterID,CC.Code,CC.FullName,CC.Address, CC.ShortName,  IBH.BillingHeadName+'-'+LEFT(MN.Text,3)+'-'+CAST(RIGHT(D.Year,2) AS nvarchar(10))BillingHeadName
		  ,[dbo].[fNumToWordsBD](M.CollectionAmount+ISNULL(M.ExtraCollectionAmount,0))TotalAmountInword,D.CollectionAmount, (CAST(M.CollectionDate AS date))CollectionDate,M.PaymentMethod,ChequeNo,InvoiceNo,InvoiceAmount,
		   M.DiscountAmount ,M.AdjustmentAmount,M.ExtraCollectionAmount
		   FROM  Invoice_CollectionMaster M
				INNER JOIN Invoice_CollectionDetails D ON D.MasterID=M.Id 
				INNER JOIN CRM_Client CC ON M.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON D.BillingHeadId = IBH.Id 
				INNER JOIN Common_DropDownConfig MN ON MN.Value=D.MonthId AND Type='Month'

				WHERE M.Id  in(Select * from #MasterId)
				AND D.CollectionAmount>0
				ORDER BY CC.ShortName,D.Year,D.MonthId


		END	
		IF(@Block =13)-- Get Phone Call Maintain --- EXEC SP_GetInvoiceGenerate 0,0,0,'1,2','','',13
		BEGIN
			SELECT M.*,ISNULL(cc.ClientId,'')+'-'+CC.ShortName AS FullName
			FROM  Invoice_PhoneCallMaintain M
			INNER JOIN CRM_Client CC ON M.ClientId = CC.Id
			WHERE M.IsDeleted=0
			ORDER BY m.Id DESC
		END	
		IF(@Block =14)-- Get Invoice Discount List --- EXEC SP_GetInvoiceGenerate 2022,4,3,'','','','',14
		BEGIN
			SELECT IG.BillingHeadId,IBH.BillingHeadName,IG.DiscountlinkBillingHeadId,IBHD.BillingHeadName LinkBillingHeadName, IG.Quantity, IG.Rate, IG.TotalAmount, IG.Description, IG.DiscountPercentage
			FROM Invoice_InvoiceGenerate IG
			INNER JOIN Invoice_BillingHead IBH ON IBH.Id=IG.BillingHeadId
			LEFT JOIN Invoice_BillingHead IBHD ON IBHD.Id=IG.DiscountlinkBillingHeadId
			WHERE IG.IsDeleted = 0 AND IG.InvoiceStatus='Discount'
			AND  IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
			AND  EOMONTH(datefromparts(YEAR(IG.DueDate),Month(IG.DueDate), 1)) = EOMONTH(datefromparts(@YearId, @MonthId, 1))
				
		END	
		IF(@Block =15)--Invoice 'Discount,Generate  --- EXEC SP_GetInvoiceGenerate 2020,12,0,'','','','',15
		BEGIN
			SELECT IG.Id,CC.ShortName, IG.InvoiceNo, IG.InvoiceAmount ,IG.ClientId ,IG.Year ,IG.MonthId ,IG.BillingHeadId ,IBH.BillingHeadName+'-'+LEFT(M.Text,3)+'-'+CAST(RIGHT(IG.Year,2) AS nvarchar(10))BillingHeadName,IG.Quantity, IG.Rate, IG.TotalAmount,IG.DueAmount,ISNULL(IG.CollectionAmount,0)CollectionAmount, IG.BillingPeriodStart,IG.BillingPeriodEnd,IG.IssueDate,IG.DueDate
			,IG.Status
			FROM 
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id
				inner join Common_DropDownConfig M on M.Type='Month' and M.Value=IG.MonthId

			WHERE 
				IG.IsDeleted = 0 AND IG.DueAmount > 0 AND  IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				AND  EOMONTH(datefromparts(YEAR(IG.DueDate),Month(IG.DueDate), 1)) <= EOMONTH(datefromparts(@YearId, @MonthId, 1))
				ORDER BY IG.Year,IG.MonthId
				
			
		END
		IF(@Block =16)--Invoice Search Panel Get  --- EXEC SP_GetInvoiceGenerate 0,0,0,'','2021-03-03 17:27:32.900','2021-03-08 17:27:32.900','',0,16
		BEGIN
			SELECT IPM.[Id], [InvoiceNo], [InvoiceAmount], IPM.[ClientId], [BillingMonth], [InvoiceDate], [DueDate], [BillingPeriodStart], [BillingPeriodEnd], IPM.[IsDeleted],ISNULL(cc.ClientId,'')+'-'+CC.ShortName AS FullName,
			IPM.PaymentStatus
			
			FROM [dbo].[Invoice_InvoicePrintMaster] IPM
				INNER JOIN CRM_Client CC ON IPM.ClientId = CC.Id
			WHERE IPM.IsDeleted = 0  AND  IPM.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IPM.ClientId END
				AND	 CAST(InvoiceDate as date) BETWEEN CASE WHEN @FromDate<>'' THEN  CAST(@FromDate AS date) ELSE CAST(InvoiceDate as date) END 
				AND CASE WHEN @ToDate<>'' THEN  CAST(@ToDate AS date) ELSE CAST(InvoiceDate as date) END  
				AND  InvoiceNo = CASE WHEN @InvoiceNo<>'' THEN @InvoiceNo  ELSE InvoiceNo END
				ORDER BY Id DESC
				
			
		END
		IF(@Block =17) --Invoice Print Search panel--- EXEC SP_GetInvoiceGenerate 2022,1,0,'BAFSK','','','8',2,17
		BEGIN
		SELECT IPM.Id,IPM.InvoiceNo,IPM.InvoiceAmount,IPM.ClientId,D.Year,D.BillingHeadId,D.Quantity,D.Rate,D.SubTotalAmount,D.DiscountAmount,D.NetTotalAmount,IPM.InvoiceDate IssueDate,IPM.DueDate,IPM.BillingPeriodStart,IPM.BillingPeriodEnd,CC.Code,CC.FullName,CC.Address, CC.ShortName,  D.BillingHeadName,D.DiscountHeadName ,IPM.InvoiceAmount TotalDueAmount,[dbo].[fNumToWordsBD](IPM.InvoiceAmount)TotalDueAmountInword,IPM.BillingMonth,D.SubTotalAmount DueAmount,IPM.InvoiceAmount TotalInvoiceAmount,  D.DueStatus
		FROM  
		Invoice_InvoicePrintMaster IPM
		INNER JOIN Invoice_InvoicePrintDetails D ON D.MasterId=IPM.Id
		INNER JOIN CRM_Client CC ON IPM.ClientId = CC.Id
		WHERE  IPM.Id IN  (SELECT value  FROM STRING_SPLIT(@InvoiceId, ','))
		ORDER BY CC.ShortName,D.Year,D.MonthId DESC
			
		END
	 END
END  

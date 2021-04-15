IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_RPTInvoiceReport'))
BEGIN
DROP PROCEDURE  SP_RPTInvoiceReport
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
	--- EXEC SP_RPTInvoiceReport 0,0,0,'','','',1

CREATE PROCEDURE [dbo].SP_RPTInvoiceReport
(
    @YearID INT = 0,
	@MonthId INT = 0,
	@ClientId INT = 0,
	@FromDate nvarchar(max)=null,
	@ToDate nvarchar(max)=null,
	@InvoiceServiceId INT = 0,
	@BillingHeadId INT = 0,
	@Status nvarchar(100)=null,
	@FilterType INT = 0,
	@Block INT = 0

)
AS
BEGIN 
	IF(@FilterType=1)--Process Month
	BEGIN
			IF(@Block =4) --Due Report monthly --- EXEC SP_RPTInvoiceReport 0,0,0,'01/01/2021','04/29/2022',0,0,'',1,4
		BEGIN
		SELECT * FROM 
		  (SELECT distinct CC.ShortName,  IBH.BillingHeadName ,((SELECT SUM(DueAmount) FROM Invoice_InvoiceGenerate WHERE IsDeleted = 0 AND DueAmount>0
				AND ClientId =  IG.ClientId  AND BillingHeadId=IG.BillingHeadId AND	EOMONTH(datefromparts(Year,MonthId, 1)) BETWEEN EOMONTH(datefromparts(YEAR(@FromDate),month(@FromDate), 1))  AND EOMONTH(datefromparts(YEAR(@ToDate),month(@ToDate), 1)))
				- ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IG.ClientId AND DiscountlinkBillingHeadId=IG.BillingHeadId  AND IsPaid=0 AND	EOMONTH(datefromparts(Year,MonthId, 1)) BETWEEN EOMONTH(datefromparts(YEAR(@FromDate),month(@FromDate), 1))  AND EOMONTH(datefromparts(YEAR(@ToDate),month(@ToDate), 1))),0) )TotalDueAmount 
				, SUM(IG.DueAmount) DueAmount,@FromDate FromDate,@ToDate ToDate,
		  CASE WHEN @ClientId<>0 THEN CC.ShortName ELSE 'All' END ClientName
		   ,ISNULL((SELECT  STUFF((SELECT  ', ' + LEFT(M.Text,3) FROM Invoice_InvoiceGenerate G
		 inner join Common_DropDownConfig M on M.Type='Month' and M.Value=G.MonthId 
		  WHERE G.ClientId=IG.ClientId  AND G.IsDeleted = 0 AND G.DueAmount>0 AND EOMONTH(datefromparts(G.Year,G.MonthId, 1)) BETWEEN EOMONTH(datefromparts(YEAR(@FromDate),month(@FromDate), 1))  AND EOMONTH(datefromparts(YEAR(@ToDate),month(@ToDate), 1))     GROUP BY  M.Text,G.MonthId,G.Year ORDER BY G.Year,G.MonthId    FOR XML PATH('')), 1, 1, '')),'')MonthNames,'Process Month' FilterType,'Addition' InvoiceStatus
	  
		   FROM  
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id 
			
			WHERE 
				IG.IsDeleted = 0 AND IG.DueAmount>0 
				AND IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				AND EOMONTH(datefromparts(IG.Year,IG.MonthId, 1)) BETWEEN EOMONTH(datefromparts(YEAR(@FromDate),month(@FromDate), 1))  AND EOMONTH(datefromparts(YEAR(@ToDate),month(@ToDate), 1)) 
				GROUP BY CC.ShortName,  IBH.BillingHeadName,IG.BillingHeadId,IG.ClientId
				
				UNION ALL
				SELECT distinct CC.ShortName,  IBH.BillingHeadName+'-'+'Discount' BillingHeadName,0 TotalDueAmount 
				, SUM(IG.TotalAmount) DueAmount,@FromDate FromDate,@ToDate ToDate,
		  CASE WHEN @ClientId<>0 THEN CC.ShortName ELSE 'All' END ClientName
		   ,ISNULL((SELECT  STUFF((SELECT  ', ' + LEFT(M.Text,3) FROM Invoice_InvoiceGenerate G
		 inner join Common_DropDownConfig M on M.Type='Month' and M.Value=G.MonthId 
		  WHERE G.ClientId=IG.ClientId  AND G.IsDeleted = 0 AND G.DueAmount>0 AND EOMONTH(datefromparts(G.Year,G.MonthId, 1)) BETWEEN EOMONTH(datefromparts(YEAR(@FromDate),month(@FromDate), 1))  AND EOMONTH(datefromparts(YEAR(@ToDate),month(@ToDate), 1))     GROUP BY M.Text,G.MonthId ORDER BY G.MonthId    FOR XML PATH('')), 1, 1, '')),'')MonthNames,'Process Month' FilterType,'Discount' InvoiceStatus
	  
		   FROM  
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id 
			
			WHERE 
				IG.IsDeleted = 0  AND IG.InvoiceStatus='Discount' AND IsPaid=0
				AND IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				AND EOMONTH(datefromparts(IG.Year,IG.MonthId, 1)) BETWEEN EOMONTH(datefromparts(YEAR(@FromDate),month(@FromDate), 1))  AND EOMONTH(datefromparts(YEAR(@ToDate),month(@ToDate), 1)) 
				GROUP BY CC.ShortName,  IBH.BillingHeadName,IG.ClientId)T
				ORDER BY ShortName,InvoiceStatus
		END
		IF(@Block =5) --Due Report Yearly process month wise --- EXEC SP_RPTInvoiceReport 2021,0,0,'2020-11-01 00:00:00.000','2020-12-30 00:00:00.000',0,0,'',2,5
		BEGIN
		SELECT ShortName,DueAmount,FromDate,ToDate,ClientName,left(M.Text,3) +'-'+ RIGHT(@YearId,2)DueMonth,@YearId Year,M.Value MonthId,'Process Month' FilterType FROM 
		  (SELECT CC.ShortName,  (SUM(IG.DueAmount)-ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IG.ClientId AND InvoiceStatus='Discount' AND Year=IG.Year AND MonthId=IG.MonthId AND IsPaid=0),0) )DueAmount
		  , @FromDate FromDate,@ToDate ToDate,
		  CASE WHEN @ClientId<>0 THEN CC.ShortName ELSE 'All' END ClientName,IG.Year,IG.MonthId
	  
		   FROM  
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
				
			WHERE 
				IG.IsDeleted = 0 AND IG.DueAmount>0
				AND IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				AND  IG.Year = CASE WHEN @YearId<>0 THEN @YearId ELSE IG.Year END
				GROUP BY CC.ShortName,IG.ClientId,IG.Year,IG.MonthId)T
				RIGHT JOIN (SELECT Text,Value FROM Common_DropDownConfig WHERE Type='Month') M ON M.Value=T.MonthId
		END
		IF(@Block =6) --Monthly status report --- EXEC SP_RPTInvoiceReport 2021,2,0,'2020-11-01 00:00:00.000','2020-12-30 00:00:00.000',0,0,'',1,6
		BEGIN
		SELECT  * FROM
		(SELECT ShortName,	OverAllPaidAmount,CASE WHEN	OverAllDueAmount>0 THEN OverAllDueAmount ELSE 0 END OverAllDueAmount ,
		CASE WHEN OverAllPaidAmount>0 AND OverAllDueAmount=0 THEN 'Paid' 
		WHEN OverAllDueAmount>0 AND OverAllPaidAmount>0 THEN 'Partial Paid'
		ELSE 'Due' END OverAllStatus
		,	CurrentPaidAmount,	CurrentDueAmount,
		CASE WHEN CurrentPaidAmount=CurrentDueAmount AND CurrentPaidAmount>0 THEN 'Paid' 
		WHEN CurrentDueAmount>0 AND CurrentPaidAmount>0 THEN 'Partial Paid'
		WHEN CurrentDueAmount>0  THEN 'Due'
		ELSE 'No Due' END CurrentStatus
		,FromDate	,ToDate	,MonthNames	,ProbablePaymentDate,	Comments, CASE WHEN @ClientId<>0 THEN ShortName ELSE 'All' END ClientName,@YearID Year,'Process Month' FilterType
		,(select Text  from  Common_DropDownConfig  where Type='Month' AND Value=cast(@MonthId as nvarchar(10)))FilterMonth
		FROM  (SELECT CC.ShortName, isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionMaster] where ClientId=IG.ClientId),0)OverAllPaidAmount 
		,(SUM(IG.DueAmount) -ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IG.ClientId AND InvoiceStatus='Discount'  AND IsPaid=0),0)) OverAllDueAmount
		  , isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionMaster] where ClientId=IG.ClientId AND YEAR(CollectionDate)=@YearID AND MONTH(CollectionDate)=@MonthId),0)CurrentPaidAmount 
		  ,(isnull((SELECT sum(DueAmount) FROM [dbo].Invoice_InvoiceGenerate where ClientId=IG.ClientId AND Year=@YearID AND MonthId=@MonthId),0)
		  -ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IG.ClientId AND InvoiceStatus='Discount' AND Year=@YearID AND MonthId=@MonthId AND IsPaid=0),0) )CurrentDueAmount
		  , @FromDate FromDate,@ToDate ToDate
		  ,ISNULL((SELECT  STUFF((SELECT  ', ' + LEFT(M.Text,3) FROM Invoice_InvoiceGenerate G
		 inner join Common_DropDownConfig M on M.Type='Month' and M.Value=G.MonthId 
		  WHERE G.ClientId=IG.ClientId  AND G.IsDeleted = 0 AND G.DueAmount>0  GROUP BY M.Text,G.MonthId ORDER BY G.MonthId    FOR XML PATH('')), 1, 1, '')),'')MonthNames
					,(SELECT TOP 1 CAST(ProbablePaymentDate as date) FROM [dbo].[Invoice_PhoneCallMaintain] WHERE ClientId=IG.ClientId ORDER BY Id DESC)ProbablePaymentDate
					,(SELECT TOP 1 Comments FROM [dbo].[Invoice_PhoneCallMaintain] WHERE ClientId=IG.ClientId ORDER BY Id DESC)Comments
	  
		   FROM  
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
			WHERE 
				IG.IsDeleted = 0 --AND IG.DueAmount>0
				AND IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				GROUP BY CC.ShortName,IG.ClientId)T)T1
				WHERE T1.OverAllStatus = CASE WHEN @Status<>'' THEN @Status ELSE T1.OverAllStatus END
		END
		IF(@Block =7) --Management view report monthly --- EXEC SP_RPTInvoiceReport 2020,3,0,'2020-11-01 00:00:00.000','2020-12-30 00:00:00.000',0,0,'',1,7
		BEGIN
		SELECT 	Projection,TotalCollection,(Projection-TotalCollection)ExistingDue,CASE WHEN TotalCollection>0 THEN CAST((TotalCollection*100/Projection) AS decimal(18,2)) ELSE 0 END CollectionRate,
			CurrentProjection,CurrentCollection,CASE WHEN  (CurrentProjection-CurrentCollection)>0 THEN (CurrentProjection-CurrentCollection) ELSE 0 END CurrentDue,CASE WHEN CurrentCollection>0 THEN  CAST((CurrentCollection*100/CurrentProjection)AS decimal(18,2)) ELSE 0 END CurrentCollectionRate,CurrentMonth,@YearID CurrentYear,'Process Month' FilterType
		
		FROM  (SELECT  (SUM(IG.DueAmount) -ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE Year=@YearID AND  InvoiceStatus='Discount'  AND IsPaid=0),0))Projection
		,isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionMaster] WHERE IsDeleted = 0 AND Year=@YearID ),0)TotalCollection 
		,(isnull((SELECT sum(DueAmount) FROM [dbo].Invoice_InvoiceGenerate where YEAR=@YearID AND MonthId=@MonthId),0)-ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE  InvoiceStatus='Discount' AND Year=@YearID AND MonthId=@MonthId AND IsPaid=0),0) )CurrentProjection
		  , isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionMaster] where  YEAR=@YearID AND MonthId=@MonthId),0)CurrentCollection
		  ,(SELECT Text FROM Common_DropDownConfig WHERE Type='Month' and Value=cast(@MonthId as nvarchar))CurrentMonth
	  
		   FROM  
				Invoice_InvoiceGenerate IG
			WHERE 
				IG.IsDeleted = 0 AND IG.Year=@YearID AND IG.DueAmount>0)T

		--Monthly Headwise due and collection
		SELECT 	BillingHeadName,Projection,TotalCollection,CASE WHEN (Projection-TotalCollection)>0 THEN (Projection-TotalCollection) ELSE 0 END ExistingDue,CAST((TotalCollection*100/Projection) AS decimal(18,2))CollectionRate
		FROM  (SELECT  IBH.BillingHeadName,SUM(IG.DueAmount)Projection,isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionDetails] WHERE IsDeleted = 0 AND BillingHeadId=IG.BillingHeadId AND YEAR=@YearID AND MonthId=@MonthId),0)TotalCollection 
		FROM  
		Invoice_InvoiceGenerate IG
		INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id 
	
		WHERE 
		IG.IsDeleted = 0  
		AND  IG.Year = CASE WHEN @YearId<>0 THEN @YearId ELSE IG.Year END
		AND  IG.MonthId = CASE WHEN @MonthId<>0 THEN @MonthId ELSE IG.MonthId END
		GROUP BY IBH.BillingHeadName,IG.BillingHeadId)T

		--Previous Month Headwise due and collection
		SELECT distinct BillingHeadName,	MonthNames,Projection,TotalCollection,CASE WHEN (Projection-TotalCollection)>0 THEN (Projection-TotalCollection) ELSE 0 END ExistingDue,CAST((TotalCollection*100/Projection) AS decimal(18,2))CollectionRate,MonthId
		FROM  (SELECT distinct  IBH.BillingHeadName,SUM(IG.DueAmount)Projection,
		isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionDetails] WHERE IsDeleted = 0 AND BillingHeadId=IG.BillingHeadId  AND  YEAR=@YearID AND MonthId=IG.MonthId-1   ),0)TotalCollection,
		M.Text+' Due' MonthNames,IG.MonthId
		FROM  
		Invoice_InvoiceGenerate IG
		INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id and IG.Year=@YearID
		inner join Common_DropDownConfig M on M.Type='Month' and M.Value=cast(IG.MonthId as nvarchar)
		WHERE 
		IG.IsDeleted = 0  --AND  EOMONTH(datefromparts(IG.Year,IG.MonthId, 1)) < EOMONTH(datefromparts(@YearId, @MonthId, 1))
		AND IG.Year=@YearId AND IG.MonthId<@MonthId
		GROUP BY IBH.BillingHeadName,IG.BillingHeadId,M.Text,IG.MonthId)T
		ORDER BY MonthId ASC
		END
		IF(@Block =8) --Management view report Yearly --- EXEC SP_RPTInvoiceReport 2021,1,0,'2020-11-01 00:00:00.000','2020-12-30 00:00:00.000',0,0,'',1,8
		BEGIN
	
		SELECT 	left(M.Text,3) +'-'+ RIGHT(@YearId,2) DueMonth,@YearId Year,M.Value MonthId,Projection,PreviousDue,(Projection+PreviousDue)TotalPayable,MonthCollection,PreviousCollection,(MonthCollection+PreviousCollection)TotalCollection,
		CASE WHEN ((Projection+PreviousDue)-(MonthCollection+PreviousCollection))>0 THEN ((Projection+PreviousDue)-(MonthCollection+PreviousCollection)) ELSE 0 END ExistingDue
		,CAST(((MonthCollection+PreviousCollection)*100/(Projection+PreviousDue)) AS decimal(18,2))CollectionRate,'Process Month' FilterType
		FROM  (SELECT  (SUM(IG.DueAmount) -ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE Year=@YearID AND  InvoiceStatus='Discount'  AND IsPaid=0),0))Projection,
		isnull((SELECT SUM(DueAmount) FROM Invoice_InvoiceGenerate WHERE IsDeleted = 0  AND  YEAR=@YearID AND MonthId=IG.MonthId-1),0)PreviousDue,
		isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionDetails] WHERE IsDeleted = 0  AND  YEAR=@YearID AND MonthId=IG.MonthId ),0)MonthCollection,
		isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionDetails] WHERE IsDeleted = 0  AND  YEAR=@YearID AND MonthId=IG.MonthId-1 ),0)PreviousCollection
		,MonthId
		FROM  
		Invoice_InvoiceGenerate IG
		WHERE IG.IsDeleted = 0  AND  Year=@YearId
		GROUP BY Year,MonthId)T
		RIGHT JOIN (SELECT Text,Value FROM Common_DropDownConfig WHERE Type='Month') M ON M.Value=T.MonthId
		ORDER BY CAST(M.Value AS int) ASC
		END
	END
	
		
	ELSE  --Due Month
	BEGIN
		IF(@Block =1) --Collection summary report --- EXEC SP_RPTInvoiceReport 0,0,0,'2020-11-01 00:00:00.000','2020-12-30 00:00:00.000',0,0,1
		BEGIN
		  SELECT CC.ShortName,ICM.ClientId,   SUM(ICD.CollectionAmount)PaidAmount, @FromDate FromDate,@ToDate ToDate, (CAST(ICM.CollectionDate AS date))CollectionDate,ICM.PaymentMethod,
		  CASE WHEN @ClientId<>0 THEN CC.ShortName ELSE 'All' END ClientName
		   ,CASE WHEN @BillingHeadId<>0 THEN 'All' ELSE 'All' END BillingHeadName
		  , CASE WHEN @InvoiceServiceId<>0 THEN 'All' ELSE 'All' END ServiceName
		  ,ISNULL((SELECT  STUFF((SELECT  ', ' + LEFT(M.Text,3) FROM Invoice_CollectionDetails CD
		  inner join Invoice_CollectionMaster ICMM on ICMM.Id=CD.MasterID 
		  inner join Common_DropDownConfig M on M.Type='Month' and M.Value=CD.MonthId 
		  WHERE ICMM.ClientId=ICM.ClientId AND  CD.IsDeleted = 0 AND ICMM.PaymentMethod=ICM.PaymentMethod AND CD.CollectionAmount>0 and CAST(CollectionDate AS date)=CAST(ICM.CollectionDate AS date) GROUP BY M.Text,CD.Year,CD.MonthId ORDER BY CD.Year,CD.MonthId    FOR XML PATH('')), 1, 1, '')),'')MonthNames
	  
		   FROM  
				Invoice_CollectionMaster ICM
				INNER JOIN CRM_Client CC ON ICM.ClientId = CC.Id
				INNER JOIN Invoice_CollectionDetails ICD ON ICM.Id = ICD.MasterID
			WHERE ICM.IsDeleted = 0 AND ICD.CollectionAmount>0
				AND ICM.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE ICM.ClientId END
				AND  ICD.BillingHeadId = CASE WHEN @BillingHeadId<>0 THEN @BillingHeadId ELSE ICD.BillingHeadId END
				AND	 (CAST(ICM.CollectionDate as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date)) 
				GROUP BY CC.ShortName, (CAST(ICM.CollectionDate AS date)),ICM.PaymentMethod,ICM.ClientId--,ICD.BillingHeadId--IBH.BillingHeadName,,S.ServiceName
		END
		IF(@Block =2) --Collection Details Report monthly --- EXEC SP_RPTInvoiceReport 0,0,0,'2020-12-01 00:00:00.000','2020-12-30 00:00:00.000',0,0,'',2
		BEGIN
		   SELECT CC.ShortName,ICM.ClientId,   SUM(ICD.CollectionAmount)PaidAmount, @FromDate FromDate,@ToDate ToDate, (CAST(ICM.CollectionDate AS date))CollectionDate,
		   CASE WHEN @InvoiceServiceId<>0 THEN 'All' ELSE 'All' END ServiceName
		  ,ISNULL((SELECT  STUFF((SELECT  ', ' + PaymentMethod FROM  Invoice_CollectionMaster 
		  WHERE ClientId=ICM.ClientId AND  IsDeleted = 0  AND CollectionAmount>0 and CAST(CollectionDate AS date)=CAST(ICM.CollectionDate AS date) GROUP BY PaymentMethod    FOR XML PATH('')), 1, 1, '')),'')PaymentMethod,
		  CASE WHEN @ClientId<>0 THEN CC.ShortName ELSE 'All' END ClientName
		   ,IBH.BillingHeadName
		  , CASE WHEN @InvoiceServiceId<>0 THEN 'All' ELSE 'All' END ServiceName
		  ,ISNULL((SELECT  STUFF((SELECT  ', ' + LEFT(M.Text,3) FROM Invoice_CollectionDetails CD
		  inner join Invoice_CollectionMaster ICMM on ICMM.Id=CD.MasterID 
		  inner join Common_DropDownConfig M on M.Type='Month' and M.Value=CD.MonthId 
		  WHERE ICMM.ClientId=ICM.ClientId AND  CD.IsDeleted = 0  AND CD.CollectionAmount>0 and CAST(ICMM.CollectionDate AS date)=CAST(ICM.CollectionDate AS date) GROUP BY M.Text,CD.MonthId ORDER BY CD.MonthId    FOR XML PATH('')), 1, 1, '')),'')MonthNames
		   FROM  
				Invoice_CollectionMaster ICM
				INNER JOIN CRM_Client CC ON ICM.ClientId = CC.Id
				INNER JOIN Invoice_CollectionDetails ICD ON ICM.Id = ICD.MasterID
				INNER JOIN Invoice_BillingHead IBH ON ICD.BillingHeadId = IBH.Id 
			WHERE ICM.IsDeleted = 0 AND ICD.CollectionAmount>0
				AND ICM.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE ICM.ClientId END
				AND  ICD.BillingHeadId = CASE WHEN @BillingHeadId<>0 THEN @BillingHeadId ELSE ICD.BillingHeadId END
				AND	 (CAST(ICM.CollectionDate as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date)) 
				GROUP BY CC.ShortName, (CAST(ICM.CollectionDate AS date)),ICM.PaymentMethod,ICM.ClientId,IBH.BillingHeadName,ICD.BillingHeadId
		END
		IF(@Block =3) --Collection Details Report yearly --- --- EXEC SP_RPTInvoiceReport 2020,0,0,'2020-11-01 00:00:00.000','2020-12-30 00:00:00.000',0,0,'',3
		BEGIN
		SELECT ShortName,CollectionAmount,left(M.Text,3) +'-'+ RIGHT(@YearId,2)CollectionMonth,ClientName,@YearId Year,M.Value MonthId FROM 
		(SELECT CC.ShortName,  SUM(ICD.CollectionAmount)CollectionAmount,left(DATENAME(MONTH,ICM.CollectionDate),3) +'-'+ RIGHT(DATENAME(YEAR,ICM.CollectionDate),2)CollectionMonth ,
		  CASE WHEN @ClientId<>0 THEN CC.ShortName ELSE 'All' END ClientName,MONTH(ICM.CollectionDate)MonthId
	
		   FROM  
				Invoice_CollectionMaster ICM
				INNER JOIN CRM_Client CC ON ICM.ClientId = CC.Id
				INNER JOIN Invoice_CollectionDetails ICD ON ICM.Id = ICD.MasterID
			WHERE 
				ICM.IsDeleted = 0 AND ICD.CollectionAmount>0
				AND ICM.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE ICM.ClientId END
				AND  YEAR(ICM.CollectionDate) = CASE WHEN @YearId<>0 THEN @YearId ELSE YEAR(ICM.CollectionDate) END
				GROUP BY CC.ShortName,left(DATENAME(MONTH,ICM.CollectionDate),3),RIGHT(DATENAME(YEAR,ICM.CollectionDate),2),YEAR(ICM.CollectionDate),MONTH(ICM.CollectionDate))T
				RIGHT JOIN (SELECT Text,Value FROM Common_DropDownConfig WHERE Type='Month') M ON M.Value=T.MonthId
			 
		END
		IF(@Block =4) --Due Report monthly --- EXEC SP_RPTInvoiceReport 0,0,0,'2020-01-01 00:00:00.000','2022-12-30 00:00:00.000',0,0,'',2,4
		BEGIN
		SELECT * FROM 
		  (SELECT distinct CC.ShortName,  IBH.BillingHeadName ,((SELECT SUM(DueAmount) FROM Invoice_InvoiceGenerate WHERE IsDeleted = 0 AND DueAmount>0
				AND ClientId =  IG.ClientId AND BillingHeadId =IG.BillingHeadId AND (CAST(DueDate as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date)))
				- ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IG.ClientId AND DiscountlinkBillingHeadId=IG.BillingHeadId  AND IsPaid=0 AND (CAST(DueDate as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date))),0) ) TotalDueAmount 
				,SUM(IG.DueAmount)DueAmount, @FromDate FromDate,@ToDate ToDate,
		  CASE WHEN @ClientId<>0 THEN CC.ShortName ELSE 'All' END ClientName
		   ,ISNULL((SELECT  STUFF((SELECT  ', ' + LEFT(M.Text,3) FROM Invoice_InvoiceGenerate G
		 inner join Common_DropDownConfig M on M.Type='Month' and M.Value=G.MonthId 
		  WHERE G.ClientId=IG.ClientId  AND G.IsDeleted = 0 AND G.DueAmount>0 AND	 (CAST(G.DueDate as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date))   GROUP BY  M.Text,G.MonthId,G.Year ORDER BY G.Year,G.MonthId    FOR XML PATH('')), 1, 1, '')),'')MonthNames ,'Due Month' FilterType,'Addition' InvoiceStatus
	  
		   FROM  
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id 
			
			WHERE 
				IG.IsDeleted = 0 AND IG.DueAmount>0
				AND IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				AND	 (CAST(IG.DueDate as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date)) 
				GROUP BY CC.ShortName,  IBH.BillingHeadName,IG.BillingHeadId,IG.ClientId

				UNION ALL
				SELECT distinct CC.ShortName,  IBH.BillingHeadName+'-'+'Discount' BillingHeadName,0 TotalDueAmount 
				,SUM(IG.TotalAmount)DueAmount, @FromDate FromDate,@ToDate ToDate,
		  CASE WHEN @ClientId<>0 THEN CC.ShortName ELSE 'All' END ClientName
		   ,ISNULL((SELECT  STUFF((SELECT  ', ' + LEFT(M.Text,3) FROM Invoice_InvoiceGenerate G
		 inner join Common_DropDownConfig M on M.Type='Month' and M.Value=G.MonthId 
		  WHERE G.ClientId=IG.ClientId  AND G.IsDeleted = 0 AND G.DueAmount>0 AND	 (CAST(G.DueDate as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date))   GROUP BY M.Text,G.MonthId ORDER BY G.MonthId    FOR XML PATH('')), 1, 1, '')),'')MonthNames ,'Due Month' FilterType,'Discount' InvoiceStatus
	  
		   FROM  
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
				INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id 
			
			WHERE 
				IG.IsDeleted = 0 AND IG.InvoiceStatus='Discount' AND IsPaid=0
				AND IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				AND	 (CAST(IG.DueDate as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date)) 
				GROUP BY CC.ShortName,  IBH.BillingHeadName,IG.ClientId)T
				ORDER BY ShortName,InvoiceStatus
		END
		IF(@Block =5) --Due Report Yearly --- EXEC SP_RPTInvoiceReport 2021,0,0,'2021-11-01 00:00:00.000','2020-12-30 00:00:00.000',0,0,'',2,5
		BEGIN
		SELECT ShortName,DueAmount,FromDate,ToDate,ClientName,left(M.Text,3) +'-'+ RIGHT(@YearId,2)DueMonth,@YearId Year,M.Value MonthId ,'Due Month' FilterType FROM 
		  (SELECT CC.ShortName,  (SUM(IG.DueAmount) - ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IG.ClientId AND InvoiceStatus='Discount' AND Year=YEAR(IG.DueDate) AND MonthId=MONTH(IG.DueDate) AND IsPaid=0),0) )DueAmount
		  , @FromDate FromDate,@ToDate ToDate,
		  CASE WHEN @ClientId<>0 THEN CC.ShortName ELSE 'All' END ClientName,left(DATENAME(MONTH,IG.DueDate),3) +'-'+ RIGHT(DATENAME(YEAR,IG.DueDate),2)DueMonth,MONTH(IG.DueDate)MonthId
	  
		   FROM  
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
			WHERE 
				IG.IsDeleted = 0 AND IG.DueAmount>0
				AND IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				AND  YEAR(IG.DueDate) = CASE WHEN @YearId<>0 THEN @YearId ELSE YEAR(IG.DueDate) END
				GROUP BY CC.ShortName,IG.ClientId,left(DATENAME(MONTH,IG.DueDate),3) ,RIGHT(DATENAME(YEAR,IG.DueDate),2),YEAR(IG.DueDate),MONTH(IG.DueDate))T
				RIGHT JOIN (SELECT Text,Value FROM Common_DropDownConfig WHERE Type='Month') M ON M.Value=T.MonthId
		END
		IF(@Block =6) --Monthly status report --- EXEC SP_RPTInvoiceReport 2020,12,0,'2020-11-01 00:00:00.000','2020-12-30 00:00:00.000',0,0,'',2,6
		BEGIN
		SELECT  * FROM
		(SELECT ShortName,	OverAllPaidAmount,	CASE WHEN	OverAllDueAmount>0 THEN OverAllDueAmount ELSE 0 END OverAllDueAmount,
		CASE WHEN OverAllPaidAmount>0 AND OverAllDueAmount=0 THEN 'Paid' 
		WHEN OverAllDueAmount>0 AND OverAllPaidAmount>0 THEN 'Partial Paid'
		ELSE 'Due' END OverAllStatus
		,	CurrentPaidAmount,	CurrentDueAmount,
		CASE WHEN CurrentPaidAmount=CurrentDueAmount AND CurrentPaidAmount>0 THEN 'Paid' 
		WHEN CurrentDueAmount>0 AND CurrentPaidAmount>0 THEN 'Partial Paid'
		WHEN CurrentDueAmount>0  THEN 'Due'
		ELSE 'No Due' END CurrentStatus
		,FromDate	,ToDate	,MonthNames	,ProbablePaymentDate,	Comments, CASE WHEN @ClientId<>0 THEN ShortName ELSE 'All' END ClientName,@YearID Year,'Due Month' FilterType
		,(select Text  from  Common_DropDownConfig  where Type='Month' AND Value=cast(@MonthId as nvarchar(10)))FilterMonth
		FROM  (SELECT CC.ShortName, isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionMaster] where ClientId=IG.ClientId),0)OverAllPaidAmount 
		,(SUM(IG.DueAmount) -ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IG.ClientId AND InvoiceStatus='Discount'  AND IsPaid=0),0) )OverAllDueAmount
		  , isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionMaster] where ClientId=IG.ClientId AND YEAR(CollectionDate)=@YearID AND MONTH(CollectionDate)=@MonthId),0)CurrentPaidAmount 
		  ,(isnull((SELECT sum(DueAmount) FROM [dbo].Invoice_InvoiceGenerate where ClientId=IG.ClientId AND YEAR(DueDate)=@YearID AND MONTH(DueDate)=@MonthId),0)
		  -ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE ClientId=IG.ClientId AND InvoiceStatus='Discount' AND Year=@YearID AND MonthId=@MonthId AND IsPaid=0),0) )CurrentDueAmount
		  , @FromDate FromDate,@ToDate ToDate
		  ,ISNULL((SELECT  STUFF((SELECT  ', ' + LEFT(M.Text,3) FROM Invoice_InvoiceGenerate G
		 inner join Common_DropDownConfig M on M.Type='Month' and M.Value=G.MonthId 
		  WHERE G.ClientId=IG.ClientId  AND G.IsDeleted = 0 AND G.DueAmount>0  GROUP BY M.Text,G.MonthId ORDER BY G.MonthId    FOR XML PATH('')), 1, 1, '')),'')MonthNames
					,(SELECT TOP 1 CAST(ProbablePaymentDate as date) FROM [dbo].[Invoice_PhoneCallMaintain] WHERE ClientId=IG.ClientId ORDER BY Id DESC)ProbablePaymentDate
					,(SELECT TOP 1 Comments FROM [dbo].[Invoice_PhoneCallMaintain] WHERE ClientId=IG.ClientId ORDER BY Id DESC)Comments
	  
		   FROM  
				Invoice_InvoiceGenerate IG
				INNER JOIN CRM_Client CC ON IG.ClientId = CC.Id
			WHERE 
				IG.IsDeleted = 0 --AND IG.DueAmount>0
				AND IG.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IG.ClientId END
				GROUP BY CC.ShortName,IG.ClientId)T)T1
				WHERE T1.OverAllStatus = CASE WHEN @Status<>'' THEN @Status ELSE T1.OverAllStatus END
		END
		IF(@Block =7) --Management view report monthly --- EXEC SP_RPTInvoiceReport 2022,1,0,'2020-11-01 00:00:00.000','2020-12-30 00:00:00.000',0,0,'',2,7
		BEGIN
			SELECT 	Projection,TotalCollection,(Projection-TotalCollection)ExistingDue,CASE WHEN TotalCollection>0 THEN CAST((TotalCollection*100/Projection) AS decimal(18,2)) ELSE 0 END CollectionRate,
			CurrentProjection,CurrentCollection,CASE WHEN  (CurrentProjection-CurrentCollection)>0 THEN (CurrentProjection-CurrentCollection) ELSE 0 END CurrentDue,CASE WHEN CurrentCollection>0 THEN  CAST((CurrentCollection*100/CurrentProjection)AS decimal(18,2)) ELSE 0 END CurrentCollectionRate,CurrentMonth,@YearID CurrentYear,'Due Month' FilterType
		FROM  (SELECT  (SUM(IG.DueAmount) -ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE Year=@YearID AND InvoiceStatus='Discount'  AND IsPaid=0),0))Projection
		,isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionMaster] WHERE IsDeleted = 0  AND Year=@YearID ),0)TotalCollection 
		,isnull((SELECT sum(DueAmount) FROM [dbo].Invoice_InvoiceGenerate where YEAR=@YearID AND MonthId=@MonthId),0)CurrentProjection
		  , isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionMaster] where  YEAR=@YearID AND MonthId=@MonthId),0)CurrentCollection
		  ,(SELECT Text FROM Common_DropDownConfig WHERE Type='Month' and Value=cast(@MonthId as nvarchar))CurrentMonth
	  
		   FROM  
				Invoice_InvoiceGenerate IG
			WHERE 
				IG.IsDeleted = 0 AND IG.Year=@YearID AND IG.DueAmount>0)T

		--Monthly Headwise due and collection
		SELECT 	BillingHeadName,Projection,TotalCollection,CASE WHEN (Projection-TotalCollection)>0 THEN (Projection-TotalCollection) ELSE 0 END ExistingDue,CAST((TotalCollection*100/Projection) AS decimal(18,2))CollectionRate
		FROM  (SELECT  IBH.BillingHeadName,SUM(IG.DueAmount)Projection,isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionDetails] WHERE IsDeleted = 0 AND BillingHeadId=IG.BillingHeadId AND YEAR=@YearID AND MonthId=@MonthId),0)TotalCollection 
		FROM  
		Invoice_InvoiceGenerate IG
		INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id 
	
		WHERE 
		IG.IsDeleted = 0  
		AND  YEAR(IG.DueDate) = CASE WHEN @YearId<>0 THEN @YearId ELSE YEAR(IG.DueDate) END
		AND  Month(IG.DueDate) = CASE WHEN @MonthId<>0 THEN @MonthId ELSE Month(IG.DueDate) END
		GROUP BY IBH.BillingHeadName,IG.BillingHeadId)T

		--Previous Month Headwise due and collection
		SELECT distinct BillingHeadName,	MonthNames,Projection,TotalCollection,CASE WHEN (Projection-TotalCollection)>0 THEN (Projection-TotalCollection) ELSE 0 END ExistingDue,CAST((TotalCollection*100/Projection) AS decimal(18,2))CollectionRate,MonthId
		FROM  (SELECT distinct  IBH.BillingHeadName,SUM(IG.DueAmount)Projection,
		isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionDetails] WHERE IsDeleted = 0 AND BillingHeadId=IG.BillingHeadId  AND  YEAR=@YearID AND MonthId=Month(IG.DueDate)-1   ),0)TotalCollection,
		DATENAME(MONTH,IG.DueDate)+' Due' MonthNames,Month(IG.DueDate) MonthId
		FROM  
		Invoice_InvoiceGenerate IG
		INNER JOIN Invoice_BillingHead IBH ON IG.BillingHeadId = IBH.Id and IG.Year=@YearID
		--inner join Common_DropDownConfig M on M.Type='Month' and M.Value=cast(IG.MonthId as nvarchar)
		WHERE 
		IG.IsDeleted = 0  --AND  EOMONTH(datefromparts(YEAR(IG.DueDate),Month(IG.DueDate), 1)) < EOMONTH(datefromparts(@YearId, @MonthId, 1))
		AND YEAR(IG.DueDate)=@YearId AND Month(IG.DueDate)<@MonthId
		GROUP BY IBH.BillingHeadName,IG.BillingHeadId,DATENAME(MONTH,IG.DueDate),Month(IG.DueDate))T
		ORDER BY MonthId ASC
		END
		IF(@Block =8) --Management view report Yearly --- EXEC SP_RPTInvoiceReport 2021,12,0,'2020-11-01 00:00:00.000','2020-12-30 00:00:00.000',0,0,'',2,8
		BEGIN
	
		SELECT 	left(M.Text,3) +'-'+ RIGHT(@YearId,2) DueMonth,@YearId Year,MonthId,Projection,PreviousDue,(Projection+PreviousDue)TotalPayable,MonthCollection,PreviousCollection,(MonthCollection+PreviousCollection)TotalCollection,
		((Projection+PreviousDue)-(MonthCollection+PreviousCollection))ExistingDue,CAST(((MonthCollection+PreviousCollection)*100/(Projection+PreviousDue)) AS decimal(18,2))CollectionRate,'Due Month' FilterType
		FROM  (SELECT  (SUM(IG.DueAmount) -ISNULL((SELECT SUM(TotalAmount) FROM Invoice_InvoiceGenerate WHERE Year=@YearID AND InvoiceStatus='Discount'  AND IsPaid=0),0))Projection,
		isnull((SELECT SUM(DueAmount) FROM Invoice_InvoiceGenerate WHERE IsDeleted = 0  AND  YEAR=@YearID AND MonthId=MONTH(IG.DueDate)-1),0)PreviousDue,
		isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionDetails] WHERE IsDeleted = 0  AND  YEAR=@YearID AND MonthId=MONTH(IG.DueDate) ),0)MonthCollection,
		isnull((SELECT sum(CollectionAmount) FROM [dbo].[Invoice_CollectionDetails] WHERE IsDeleted = 0  AND  YEAR=@YearID AND MonthId=MONTH(IG.DueDate)-1 ),0)PreviousCollection
		,left(DATENAME(MONTH,IG.DueDate),3) +'-'+ RIGHT(DATENAME(YEAR,IG.DueDate),2)DueMonth,MONTH(IG.DueDate)MonthId
		FROM  
		Invoice_InvoiceGenerate IG
		WHERE 
		IG.IsDeleted = 0  AND  YEAR(IG.DueDate)=@YearId
		GROUP BY left(DATENAME(MONTH,IG.DueDate),3), RIGHT(DATENAME(YEAR,IG.DueDate),2),MONTH(IG.DueDate))T
		RIGHT JOIN (SELECT Text,Value FROM Common_DropDownConfig WHERE Type='Month') M ON M.Value=T.MonthId
		ORDER BY CAST(M.Value AS int) ASC
		END	
		IF(@Block =9) --Adjustment Extra income Report --- EXEC SP_RPTInvoiceReport 2021,12,0,'2020-11-01 00:00:00.000','2021-12-30 00:00:00.000',0,0,'',2,9
		BEGIN
		SELECT CC.ShortName,ICM.ClientId,SUM(ICM.AdjustmentAmount)AdjustmentAmount,SUM(ICM.ExtraCollectionAmount)ExtraCollectionAmount, @FromDate FromDate,@ToDate ToDate, 
		CASE WHEN @ClientId<>0 THEN CC.ShortName ELSE 'All' END ClientName
		FROM Invoice_CollectionMaster ICM
		INNER JOIN CRM_Client CC ON ICM.ClientId = CC.Id
		WHERE ICM.IsDeleted = 0 AND (ICM.AdjustmentAmount>0 OR ICM.ExtraCollectionAmount>0)
		AND ICM.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE ICM.ClientId END
		AND	 (CAST(ICM.CollectionDate as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date)) 
		GROUP BY CC.ShortName,ICM.ClientId
		END	
	END
END  

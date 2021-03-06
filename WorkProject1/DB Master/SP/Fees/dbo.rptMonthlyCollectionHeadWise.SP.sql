/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptMonthlyCollectionHeadWise]'))
BEGIN
DROP PROCEDURE  [rptMonthlyCollectionHeadWise]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shahin
-- Create date: March 19, 2018
-- Description:	
-- =============================================


CREATE  PROCEDURE [dbo].[rptMonthlyCollectionHeadWise] 
(
    @Block INT=0,
	@Where varchar(MAX) = NULL
)	
AS
BEGIN
	IF(@Block=1)
	BEGIN

		DECLARE @sql varchar(max)     

		SET @sql = 'SELECT  DATEPART(DAY,CM.AddDate) AS [DATE], H.HeadName, SUM(CM.ReceivedAmount) AS Amount FROM [dbo].[Fees_CollectionMaster] AS CM 
		INNER JOIN [dbo].[Fees_CollectionDetails] AS CD ON CM.ID=CD.MasterID AND CD.IsDeleted=0
		INNER JOIN Fees_Head AS H ON CD.HeadId=H.FeesHeadId AND H.IsDeleted=0
		INNER JOIN Student_BasicInfo AS SB ON CM.StudentIID=SB.StudentIID AND SB.IsDeleted=0 '


	 IF(@Where IS NOT NULL AND  @Where <> '')
	 BEGIN
	 SET @sql = @sql + ' WHERE '+ @Where
	 END
	EXEC(@sql)

	END
	IF(@Block=2) --[FeesConfiguration] 2,'SELECT SB.FullName,SB.RollNo,SB.StudentInsID, SB.StudentIID,SB.VersionID,SB.SessionId,SB.BranchID,SB.ShiftID,SB.ClassId,SB.GroupId,SB.SectionId,HA.Amount,51 AS ProcessId,8 AS HeadId From Student_BasicInfo SB LEFT JOIN Fees_HeadAmountConfig HA ON SB.StudentIID = HA.StudentIID AND HA.ProcessId = 51 AND HA.HeadId = 8 WHERE SB.IsDeleted=0 AND SB.VersionId IN (1) AND SB.SessionId IN (1) AND SB.BranchId IN (2) AND SB.ShiftId IN (1) AND SB.ClassId IN (1) AND SB.GroupId IN (0) AND SB.SectionId IN (5) ORDER BY (SB.RollNo ) ASC'
	BEGIN
		DECLARE @sqlIndividual VARCHAR(MAX)

	 IF(@Where IS NOT NULL AND  @Where <> '')
	 BEGIN
	 SET @sqlIndividual = @Where
	 END
	EXEC(@sqlIndividual)

	END
END






--SELECT  DATEPART(DAY,CM.PaymentDate) AS [DATE], H.HeadName, CD.HeadId, SUM(ReceiveAmount) AS AMOUNT FROM [dbo].[Fees_CollectionMaster] AS CM 
--INNER JOIN [dbo].[Fees_CollectionDetails] AS CD ON CM.ID=CD.MasterID AND CD.IsDeleted=0
--INNER JOIN Fees_Head AS H ON CD.HeadId=H.FeesHeadId AND H.IsDeleted=0
--INNER JOIN Student_BasicInfo AS SB ON CM.StudentIID=SB.StudentIID AND SB.IsDeleted=0
--WHERE
----B.VersionID IN (1,2) AND B.SessionId IN(1) AND B.BranchID IN (5) AND B.ShiftID IN (6)
----AND B.ClassId IN (4) AND B.GroupId IN (4) AND B.SectionId IN (5) AND B.StudentTypeID IN (4) 
----AND M.PaymentType IN (1) 
----AND CAST(M.PaymentDate AS DATE) BETWEEN CAST(GETDATE() AS DATE) AND CAST(GETDATE() AS DATE)
----AND CAST(M.BankCollectionDate AS DATE) BETWEEN CAST(GETDATE() AS DATE) AND CAST(GETDATE() AS DATE) AND M.IsDeleted=0
----GROUP BY HeadId, HeadName, DATEPART(DAY,M.AddDate) ORDER BY DATEPART(DAY,M.AddDate), HeadId

--    --SB.VersionID  IN (1)    AND  SB.SessionId  IN (1)    AND  SB.BranchID  IN (2)    AND  SB.ShiftID  IN (1)    AND  SB.ClassId  IN (1)    AND  SB.SectionId  IN (5)    AND  SB.GroupId  IN (0)   AND 
--	CM.IsDeleted = 0  AND CAST(CM.PaymentDate AS DATE) BETWEEN CAST('1/1/2018 12:00:00 AM' AS DATE) AND CAST('5/31/2018 12:00:00 AM' AS DATE)  GROUP BY HeadId, HeadName, DATEPART(DAY,CM.AddDate), DATEPART(DAY, CM.PaymentDate) ORDER BY DATEPART(DAY, CM.PaymentDate), HeadId

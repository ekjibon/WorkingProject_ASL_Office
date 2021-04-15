IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetFeesDeuListbyStudentIID]'))
BEGIN
DROP PROCEDURE  [GetFeesDeuListbyStudentIID]
END
GO
/****** Object:  StoredProcedure [dbo].[GetFeesDeuListbyStudentIID]    **/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[GetFeesDeuListbyStudentIID]  4483,2
Create Procedure [dbo].[GetFeesDeuListbyStudentIID]
(
@StudentIID INT,
@Block INT
)
As
BEGIN
IF(@Block = 1)
BEGIN
SELECT 
FS.HeadId,FS.DueAmount,FH.HeadName,FS.IsCompleted,FS.IsPaid,FS.DiscountAmount,FS.FeesSessionYearId,FS.Year
,FS.FeesBookNo,FS.InvoiceAmount,FS.ProcessedAmount,FS.TotalAmount,FS.AdvanceAmount,FS.MonthId
FROM  [dbo].[Fees_Student] FS
INNER JOIN Fees_Head FH ON FH.FeesHeadId = FS.HeadId
WHERE FS.StudentIID = @StudentIID AND IsCompleted =0
END
IF(@Block = 2)
BEGIN
SELECT 
StudentIID,(SUM(DueAmount)) AS  Totalfeesdueamount
FROM  [dbo].[Fees_Student] 
WHERE StudentIID = @StudentIID AND IsCompleted =0
GROUP BY StudentIID
END
END
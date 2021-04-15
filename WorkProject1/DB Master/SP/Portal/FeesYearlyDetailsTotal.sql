IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FeesYearlyDetailsTotal]'))
BEGIN
DROP PROCEDURE  [FeesYearlyDetailsTotal]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec [FeesYearlyDetailsTotal] 33414

CREATE PROCEDURE [dbo].[FeesYearlyDetailsTotal] 

	(
	@IID INT
	)
	
AS
BEGIN

 --   execute [FeesYearlyDetailsTotal] 33414

	BEGIN
	 Select * from (
	Select sum(TotalAmount)TotalAmount ,
	 sum(DueAmount)DueAmount ,sum(AdvanceAmount)AdvanceAmount ,
	sum(PaidAmount)PaidAmount ,sum(DiscountAmount)DiscountAmount,
	sum(PreviousDue)PreviousDue
	from

	(SELECT     DISTINCT   
		sb.StudentIID, sb.StudentInsID, sb.FullName,
		

		 
		sum(F.DueAmount) as DueAmount,
		
		sum(F.TotalAmount) as TotalAmount,
		sum(F.PaidAmount) as PaidAmount, 
		sum(F.AdvanceAmount) as AdvanceAmount,
		sum(F.DiscountAmount) as DiscountAmount,
		ISNULL((select Sum(DueAmount) from Fees_Student where  StudentIID=@IID and MonthId<F.MonthId),0) As PreviousDue,
		CM.MonthName,
		F.Year ,F.MonthId
		
	FROM               
     
        dbo.Student_BasicInfo sb INNER JOIN
        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
        
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
		dbo.Ins_StudentType stutype ON stutype.StudentTypeId = sb.StudentTypeId INNER JOIN
		dbo.Fees_Student F ON F.StudentIID = sb.StudentIID INNER JOIN
		dbo.Fees_Head FH ON FH.FeesHeadId = F.HeadId
		INNER JOIN [dbo].[Fees_FeesMonth] CM ON CM.FeesMonthId = F.MonthId
			WHERE 			
		F.StudentIID = @IID AND
			sb.IsDeleted=0  AND F.IsDeleted = 0
			 
			AND F.DueAmount <> 0 AND  sb.[Status] = 'A' 
			
		Group By sb.StudentIID, sb.StudentInsID, sb.FullName,CM.MonthName,F.Year,F.MonthId
		)t) As Details

		UNPIVOT
(
       Details
       FOR Dt IN (TotalAmount, DueAmount, AdvanceAmount, PaidAmount,DiscountAmount,PreviousDue )
) AS P
		
	END

 END
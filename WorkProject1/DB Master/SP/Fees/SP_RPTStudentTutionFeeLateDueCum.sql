-- =============================================
-- Author:		Azmal
-- Create date: 2020-05-19
-- Description:	
-- =============================================
-- EXEC SP_RPTStudentTutionFeeLateDueCum 8,11,21,'2020-06-01 12:00:00.000','2020-06-01 12:00:00.000'
ALTER PROC SP_RPTStudentTutionFeeLateDueCum
(
@BranchId INT=0,
@SessionId INT=0,
@ClassId INT=0,
@FromDate datetime=null,
@ToDate datetime=null
)
AS
BEGIN
		SELECT FM.studentIId, sb.StudentInsID, sb.FullName,case when b.BranchName='CGSD Primary' then 'Primary Campus' else 'Secondary Campus' end BranchName ,c.ClassName,
		ISNULL((SELECT SUM(DueAmount) FROM Fees_Student WHERE studentIId=FM.studentIId AND  HeadId=1 AND IsDeleted=0 AND DueAmount>0 AND Year BETWEEN YEAR(@FromDate) AND YEAR(@ToDate)
		 AND MonthId BETWEEN MONTH(@FromDate) AND MONTH(@ToDate) GROUP BY studentIId),0) DueAmountTutionFee,
		ISNULL((SELECT SUM(DueAmount) FROM Fees_Student WHERE studentIId=FM.studentIId AND  HeadId=8 AND IsDeleted=0 AND DueAmount>0 AND Year BETWEEN YEAR(@FromDate) AND YEAR(@ToDate)
		 AND MonthId BETWEEN MONTH(@FromDate) AND MONTH(@ToDate) GROUP BY studentIId),0) DueAmounLateFee,
		ISNULL((SELECT  STUFF((SELECT ', ' + M.MonthName+'-'+cast(FS.Year as nvarchar(10)) FROM Fees_Student FS INNER JOIN Fees_FeesMonth M ON M.FeesMonthId=FS.MonthId 
		WHERE studentIId=FM.studentIId AND  HeadId=1 AND IsDeleted=0 AND DueAmount>0 AND FS.Year BETWEEN YEAR(@FromDate) AND YEAR(@ToDate)
		 AND FS.MonthId BETWEEN MONTH(@FromDate) AND MONTH(@ToDate) FOR XML PATH('')), 1, 1, '')),'') MonthNameTutionFee,
		ISNULL((SELECT  STUFF((SELECT ', ' + M.MonthName+'-'+cast(FS.Year as nvarchar(10)) FROM Fees_Student FS INNER JOIN Fees_FeesMonth M ON M.FeesMonthId=FS.MonthId 
		WHERE studentIId=FM.studentIId AND  HeadId=8 AND IsDeleted=0 AND DueAmount>0 AND FS.Year BETWEEN YEAR(@FromDate) AND YEAR(@ToDate)
		 AND FS.MonthId BETWEEN MONTH(@FromDate) AND MONTH(@ToDate) FOR XML PATH('')), 1, 1, '')),'') MonthNameLateFee
		,Convert(nvarchar(15), cast(@FromDate as Date),106)FromDate,Convert(nvarchar(15), cast(@ToDate as Date),106)ToDate
		FROM Fees_Student FM 
		INNER JOIN dbo.Student_BasicInfo sb ON sb.StudentIID = FM.studentIId
		 left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
		 left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
		 left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
		 WHERE FM.DueAmount>0 AND FM.IsDeleted=0
		 AND  FM.HeadId in(1,8) AND sb.BranchID=@BranchId AND s.SessionId=@SessionId AND sb.ClassId=@ClassId
		 AND FM.Year BETWEEN YEAR(@FromDate) AND YEAR(@ToDate)
		 AND FM.MonthId BETWEEN MONTH(@FromDate) AND MONTH(@ToDate)
		 GROUP BY FM.studentIId,sb.StudentInsID, sb.FullName,b.BranchName,c.ClassName
		 ORDER BY sb.FullName
		
END
/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAttenForEntry]'))
BEGIN
DROP PROCEDURE  [GetAttenForEntry]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kawsar
-- Create date: 
-- Description:	
-- =============================================
-- execute [dbo].[GetAttenForEntry] 10,8,4,92,null,'6/1/2019','6/30/2019',1
CREATE PROCEDURE [dbo].[GetAttenForEntry] 
 
	@SessionId INT,
	@BranchId INT = null,
	@ShiftId INT =null,

	@SectionId INT = null,
	@PeriodId INT = null,
	@FromDate SMALLDATETIME,
	@ToDate SMALLDATETIME,
	@BlockNo INT
AS
BEGIN

IF(@BlockNo=1)
	BEGIN
		SELECT SB.StudentIID StudentId ,SB.StudentInsID
			   ,ISNULL([AttendId],0) AS AttendId     
			  ,ISNULL( [InTime] , GETDATE()) AS [InTime]
			  ,ISNULL([IsPresent],0) AS [IsPresent]
			  ,ISNULL( [IsAbsconding] , 0) AS [IsAbsconding]
			  ,ISNULL( IsLeave , 0) AS IsLeave
     
		FROM  Student_BasicInfo SB
		LEFT OUTER JOIN   Att_StudentAttendance A  ON SB.StudentIID = A.StudentId 
			AND SB.BranchID = @BranchId
			AND SB.ShiftID = @ShiftId
			AND SB.SectionId = @SectionId
			AND SB.SessionId = @SessionId
			AND ( CAST( A.InTime AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE))
			 AND A.IsDeleted=0 ORDER BY SB.FullName
	END
IF(@BlockNo=2) -- For Abosconding
	BEGIN
		SELECT SB.StudentIID StudentId,SB.StudentInsID,SB.FullName,sb.RollNo
			  , ISNULL([AttendId],0) AS AttendId     
			  ,ISNULL( [InTime] , GETDATE()) AS [InTime]
			  ,ISNULL([IsPresent],0) AS [IsPresent]
			  ,ISNULL( [IsAbsconding] , 0) AS [IsAbsconding]
			  ,AbscondingPeriod
     
		FROM  Att_StudentAttendance A  
		INNER  JOIN Student_BasicInfo SB ON SB.StudentIID = A.StudentId 
		WHERE

			SB.BranchID = @BranchId
			AND SB.ShiftID = @ShiftId
			AND SB.SectionId = @SectionId
			AND SB.SessionId = @SessionId
	
			AND SB.Status = 'A'
			AND SB.IsDeleted=0
		 AND A.IsDeleted=0
			AND A.IsPresent =  1

			AND ( CAST( A.InTime AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE)) ORDER BY SB.FullName
	END
	
IF(@BlockNo=3) -- For Period Wise Attendance
	BEGIN
		SELECT SB.StudentIID StudentId,SB.StudentInsID
			  ,  ISNULL(PeriodAttendId,0) AS PeriodAttendId     
			  ,ISNULL( AttenTime , GETDATE()) AS AttenTime
			  ,ISNULL([IsPresent],0) AS [IsPresent]
			  ,ISNULL( [IsAbsconding] , 0) AS [IsAbsconding]
     
		FROM  Att_StudentPeriodAtten A  
		INNER  JOIN Student_BasicInfo SB ON SB.StudentIID = A.StudentId 
		WHERE

			SB.BranchID = @BranchId
			AND SB.ShiftID = @ShiftId
			AND SB.SectionId = @SectionId
			AND SB.SessionId = @SessionId
		
			AND SB.Status = 'A'
			AND A.IsPresent =  1
			AND SB.IsDeleted=0
			
			AND A.PeriodId = @PeriodId

			AND ( CAST( A.AttenTime AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE)) ORDER BY SB.FullName
	END
END


select*from dbo.Student_BasicInfo where StudentInsID='111811015'
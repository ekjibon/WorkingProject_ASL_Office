IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetDashBoardData]'))
BEGIN
DROP PROCEDURE  GetDashBoardData
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Comments --
-- EXEC GetDashBoardData

CREATE PROCEDURE [dbo].[GetDashBoardData]
AS
BEGIN
DECLARE   @TotalStudent INT=0,@TotalPresent INT=0, @TotalCollection DECIMAL=0.0, @TotalSentSMS int=0


	SELECT @TotalStudent = ISNULL( COUNT(StudentIID),0)  FROM Student_BasicInfo WHERE Status = 'A'
	SELECT @TotalPresent = ISNULL( COUNT(StudentId),0)  FROM Att_StudentAttendance WHERE  CAST(InTime AS DATE) = CAST(GETDATE() AS DATE)
	SELECT @TotalCollection = ISNULL( SUM(ReceivedAmount),0)  FROM Fees_CollectionMaster WHERE  CAST(PaymentDate AS DATE) = CAST(GETDATE() AS DATE)
	SELECT @TotalSentSMS = ISNULL( Count(HistoryId),0)  FROM SMS_SMSSendHistroy WHERE  CAST(SendDateTime AS DATE) = CAST(GETDATE() AS DATE) AND SendStatus = 1



	SELECT  @TotalStudent AS TotalStudent ,@TotalPresent AS TotalPresent, @TotalCollection AS TotalCollection, @TotalSentSMS  AS TotalSentSMS

	SELECT Convert(varchar(10), CAST(PaymentDate AS DATE),101)  AS PaymentDate , SUM(ReceivedAmount) Amount  FROM Fees_CollectionMaster 
	WHERE  MONTH(PaymentDate) = MONTH(GETDATE())
	GROUP BY CAST(PaymentDate AS DATE)
	

	SELECT SC.ClassName,COUNT(SA.StudentId) AS PresentStudent FROM Att_StudentAttendance SA
	INNER JOIN Student_BasicInfo SB ON SB.StudentIID = SA.StudentId
	INNER JOIN Ins_ClassInfo SC ON SC.ClassId = SB.ClassId
	 WHERE  CAST(InTime AS DATE) = CAST(GETDATE() AS DATE)
	GROUP BY SC.ClassName

END


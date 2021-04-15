/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertEmployeeTeporaryRoster]'))
BEGIN
DROP PROCEDURE  [InsertEmployeeTeporaryRoster]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Khaled
-- Create date: 
-- Description:	
-- =============================================
-- execute [dbo].[InsertEmployeeTeporaryRoster] 1072,'admin','test','2020-09-01','2020-09-03','Thursday','17:15:44.4600000','17:15:44.4600000'
CREATE PROCEDURE [dbo].[InsertEmployeeTeporaryRoster]
	 
	@EmpId INT,
	--@EmpCategory INT,
	@AddBy VARCHAR(MAX),
	@Remarks VARCHAR(MAX),
    @FromDate VARCHAR(MAX),
    @ToDate VARCHAR(MAX),
	@Day VARCHAR(MAX),
	@InTime VARCHAR(MAX),
	@OutTime VARCHAR(MAX)


AS
BEGIN

	
	UPDATE [dbo].[Att_EmpRoster] 
		  SET TempInTime = CAST(@InTime AS TIME)
		  ,TempOutTime = CAST(@OutTime AS TIME)
		  ,UpdateBy = @AddBy
		  ,UpdateDate = GETDATE()
		  ,Remarks = @Remarks
		  ,IsTempApproved = 0
		  ,IsTemporary = 1
		  
	  WHERE  EmpId = @EmpId --AND EAC.Id = @CalendarId 
	  AND CalendarDate BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND [Day] = @Day AND IsApproved=1


	SELECT @@ROWCOUNT AS TOTALLROWS

END
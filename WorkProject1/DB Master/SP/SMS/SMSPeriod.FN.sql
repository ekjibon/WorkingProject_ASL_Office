IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SMSPeriod]'))
BEGIN
DROP Function  [dbo].[SMSPeriod]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create FUNCTION [dbo].[SMSPeriod]
(
	@StudentID int,
	@Date Date
	
)
RETURNS  varchar(500)
AS
BEGIN
	DECLARE @Period varchar(500)='N/A'		
	DECLARE @VERSION INT=0, @SHIFT INT=0, @CLASSID INT=0
	SELECT @VERSION=VersionID,@SHIFT=ShiftID, @CLASSID=ClassId FROM Student_BasicInfo WHERE StudentIID=@StudentID

	--SELECT [PeriodId],[PeriodShortCode] FROM [dbo].[Rtn_ClassPeriod]
	--WHERE PeriodId NOT IN (SELECT PeriodId FROM [dbo].[Att_StudentPeriodAtten] where StudentId=@StudentID AND IsDeleted=0
	--AND CAST(AttenTime AS DATE)=CAST(@Date AS DATE))
	--AND VersionId=@VERSION AND ShiftId=@SHIFT AND ClassId=@CLASSID AND IsDeleted=0
	
			SELECT DISTINCT  @Period = SUBSTRING((SELECT ','+CAST(P.PeriodShortCode AS VARCHAR(15))  AS [text()] FROM dbo.[Rtn_ClassPeriod] P
							--WHERE P.PeriodId = P2.PeriodId
							WHERE PeriodId NOT IN (SELECT PeriodId FROM [dbo].[Att_StudentPeriodAtten] where StudentId=@StudentID AND IsDeleted=0
	AND CAST(AttenTime AS DATE)=CAST(@Date AS DATE))
	AND P.VersionId=@VERSION AND P.ShiftId=@SHIFT AND P.ClassId=@CLASSID AND P.IsDeleted=0
							ORDER BY P.PeriodShortCode
							FOR XML PATH ('')
						), 2, 1000) 
				 FROM dbo.[Rtn_ClassPeriod] P2 
				WHERE PeriodId NOT IN (SELECT PeriodId FROM [dbo].[Att_StudentPeriodAtten] where StudentId=@StudentID AND IsDeleted=0
	AND CAST(AttenTime AS DATE)=CAST(@Date AS DATE))
	AND P2.VersionId=@VERSION AND P2.ShiftId=@SHIFT AND P2.ClassId=@CLASSID AND P2.IsDeleted=0


	--SELECT @Period= SUBSTRING((SELECT ','+CAST(P.PeriodShortCode AS VARCHAR(15))  AS [text()] FROM dbo.[Att_AbscondingDetails] A1  RIGHT JOIN Rtn_ClassPeriod AS P ON A1.PeriodId=P.PeriodId
	--						WHERE A1.AttenId = @attnID
	--						ORDER BY P.PeriodShortCode
	--						FOR XML PATH ('')
	--					), 2, 1000) 
	--			 FROM dbo.[Att_AbscondingDetails] A2
	--			WHERE A2.AttenId= @attnID 				
	RETURN @Period

END


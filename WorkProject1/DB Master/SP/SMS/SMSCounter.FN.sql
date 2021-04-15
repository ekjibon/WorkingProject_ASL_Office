IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SMSCounter]'))
BEGIN
DROP Function  [dbo].[SMSCounter]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create FUNCTION [dbo].[SMSCounter]
(
	@SmsBody Nvarchar(max)
	
)
RETURNS  INT
AS
BEGIN
	DECLARE @NoOfSms INT=0	
	IF CAST(@SmsBody AS VARCHAR(MAX)) <> @SmsBody
	BEGIN
	--PRINT 'Contains Unicode characters'
			IF(LEN(@SmsBody)<=70)
		BEGIN
			SELECT @NoOfSms=1
		END
		ELSE
		BEGIN
			SELECT @NoOfSms =CEILING(CAST(LEN(@SmsBody) AS DECIMAL)/70)
		END
	END	
	ELSE
	BEGIN

		IF(LEN(@SmsBody)<=160)
		BEGIN
			SELECT @NoOfSms=1
		END
		ELSE
		BEGIN
			SELECT @NoOfSms =CEILING(CAST(LEN(@SmsBody) AS DECIMAL)/153)
		END
	END
	RETURN @NoOfSms

END


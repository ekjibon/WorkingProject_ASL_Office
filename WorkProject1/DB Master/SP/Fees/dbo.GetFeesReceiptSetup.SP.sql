/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[GetFeesReceiptSetup]'))
BEGIN
  DROP PROCEDURE GetFeesReceiptSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Kawsar 
-- Create date: 
-- Description:	
-- =============================================
-- execute ProcessFeesAutomated 1069,25,'2018-01-1','2018-01-31','A'

CREATE PROCEDURE [dbo].[GetFeesReceiptSetup] --1,6,4,0,2
@VersionID INT=NULL,
@SessionID INT=NULL,
@ClassID INT=NULL,
@GroupID INT,
@BlockID INT
AS
BEGIN
	IF(@BlockID=1)
	BEGIN
		SELECT DISTINCT D.Id, [MergeId], R.[VersionId], R.[SessionId], R.[ClassId], R.[GroupId], C.VersionName, C.SessionName,
		C.ClassName, C.GroupName, M.[MonthName], [MergeName], R.ReceiptFormat,(SELECT Text FROM Common_DropDownConfig WHERE [TYPE]='ReceiptFormat' AND [Value]=CAST(R.ReceiptFormat AS VARCHAR(50)) ) AS [ReceiptFormatName] 
		FROM [Fees_ReceiptSetting] AS R
		INNER JOIN [Fees_ReceiptSettingDetails] AS D ON R.MergeId=D.MonthMergeId 
		INNER JOIN view_CommonTableNames AS C ON R.VersionId=C.VersionId AND R.SessionId=C.SessionId AND R.ClassId=C.ClassId AND R.GroupId=C.GroupId AND R.[IsDeleted]=0
		INNER JOIN [Fees_FeesMonth] AS M ON D.ReceiptMonth=M.FeesMonthId 
	END
	IF(@BlockID=2)
	BEGIN
		SELECT DISTINCT D.Id [MergeId], R.[VersionId], R.[SessionId], R.[ClassId], R.[GroupId], C.VersionName, C.SessionName,
		C.ClassName, C.GroupName, M.[MonthName], [MergeName], R.ReceiptFormat, (SELECT Text FROM Common_DropDownConfig WHERE [TYPE]='ReceiptFormat' AND [Value]=CAST(R.ReceiptFormat AS VARCHAR(50)) ) AS [ReceiptFormatName] 
		FROM [Fees_ReceiptSetting] AS R
		INNER JOIN [Fees_ReceiptSettingDetails] AS D ON R.MergeId=D.MonthMergeId INNER JOIN view_CommonTableNames AS C 
		ON R.VersionId=C.VersionId AND R.SessionId=C.SessionId AND R.ClassId=C.ClassId AND R.GroupId=C.GroupId
		INNER JOIN [Fees_FeesMonth] AS M ON D.ReceiptMonth=M.FeesMonthId
		--INNER JOIN Common_DropDownConfig AS CD ON CAST(R.ReceiptFormat AS VARCHAR(50))=CD.[Value] AND CD.[TYPE]='ReceiptFormat'
		WHERE R.[VersionId]=@VersionID AND R.[SessionId]=@SessionID AND R.[ClassId]=@ClassID AND R.[GroupId]=@GroupID AND R.[IsDeleted]=0
	END
	
END
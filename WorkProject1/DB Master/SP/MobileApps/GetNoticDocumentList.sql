IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetNoticDocumentList]'))
BEGIN
DROP PROCEDURE  GetNoticDocumentList
END
GO
/****** Object:  StoredProcedure [dbo].[GetNoticDocumentList]    Script Date: 5/10/2019 10:25:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetNoticDocumentList]
(
 @Type Int,                     
 @BranchId Int,
 @Month nvarchar(15),                          
 @EmpId INT,
 @DocumentId INT
)
As 
Begin
IF(@Type=1)  -- Type =9 General Notice List For Employee Portal --   GetNoticDocumentList 9, null, null, null
BEGIN
	SELECT 
	 pd.DocumentId
	,pd.TypeId
	,pd.BranchId
	,pd.Title
	,pd.FileName
	--,pd.[File]
	,pd.[Month]
	,pd.[Year],
	CASE pd.TypeId
		WHEN 1 THEN 'Academic Calendar'
		WHEN 2 THEN 'Newsletter'
		WHEN 3 THEN 'ECA Notice'
		WHEN 4 THEN 'General Notice'
		WHEN 5 THEN 'Homework'
		WHEN 6 THEN 'CS Header'
		WHEN 7 THEN 'Routine'
		END TypeName,
    pd.AddDate
	FROM dbo.Portal_Document pd
	WHERE pd.TypeId=4 and (pd.IsDeleted=0 and pd.[Status]= 'A') and pd.DocType=2   order by pd.DocumentId desc
 END
IF(@Type=2)  -- Type =9 General Notice List For Employee Portal --   GetNoticDocumentList 9, null, null, null
BEGIN
	SELECT 
	 pd.[File]	
	FROM dbo.Portal_Document pd
	WHERE  pd.DocumentId = @DocumentId
 END
END

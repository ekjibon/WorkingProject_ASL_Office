/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AutomatedFees]'))
BEGIN
DROP PROCEDURE  [AutomatedFees]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shahin
-- Create date: March 19, 2018
-- Description:	
-- =============================================


CREATE  PROCEDURE [dbo].[AutomatedFees]
(
    @Block INT=0,
	@SessionId INT=null,
	@BranchId INT=null,
	@ShiftId INT =null,
	@ClassId INT = null,
	@SectionId INT=null,	
	@FeesGroupId INT=null,
	@Type VARCHAR(50)=null
)	
AS
BEGIN
	SELECT FeesHeadId, [HeadName] INTO #F FROM [dbo].[Fees_Head] WHERE IsDeleted=0
	
	IF(@Block=1) -- AutomatedFees Lists
	BEGIN  -- [AutomatedFees] 2,1,1,2,1,1,0,5,2,L	    
		SELECT DISTINCT [AutomatedConfigId], C.SessionName, C.ShiftName, C.BranchName, C.ClassName,  C.SectionName,
	     F.[SessionId], F.[branchId], F.[ShiftId], F.[ClassId],  F.SectionId, 
		F.[LatePayHeadId], (SELECT [HeadName] FROM #F WHERE FeesHeadId=F.[LatePayHeadId])  AS [LatePayHeadName],LatePayHeadIdAmount,
		[LatePayDay], [LatePayAmount], [IsFixed],
	   [LateInHead], (SELECT [HeadName] FROM #F WHERE FeesHeadId=F.[LateInHead])  AS [LateInHeadName], [LateInPeriod], [LateInAmount], [LateInHeadIdAmount]
	   ,LateInAbsConfigDay
	  ,[LatePayLongRange]
      ,[LatePayLongRangeAmount]
      ,[LatePayLongRangeAmountIsPercentage]
      ,[LatePayLongRangeHeadIdAmount]
      ,[LatePayIsPreviouseFine],
		[AbsAHead], (SELECT [HeadName] FROM #F WHERE FeesHeadId=F.[AbsAHead])  AS [AbsAHeadName], [AbsPeriod], [AbsAmount], [AbsHeadIdAmount], 
		[AbsConPeriod], [AbsConAHead], (SELECT [HeadName] FROM #F WHERE FeesHeadId=F.[AbsConAHead])  AS [AbsConAHeadName], [AbsConAmount], [AbsConHeadIdAmount], F.[Type], FessGroupId
	    FROM [dbo].[Fees_AutomatedFeesConfig] AS F 
		LEFT JOIN view_CommonTableNames AS C
		ON  F.SessionId=C.SessionId AND F.branchId=C.BranchId AND F.ShiftId=C.ShiftId AND F.ClassId=C.ClassId  AND F.SectionId=C.SectionId	
		WHERE F.IsDeleted=0 
	END
	IF(@Block=2) -- AutomatedFees by type
	BEGIN  -- [AutomatedFees] 1,1,2,1,1,1,0,null
		SELECT DISTINCT [AutomatedConfigId],  C.SessionName, C.ShiftName, C.BranchName, C.ClassName, C.SectionName,
		 F.[SessionId], F.[branchId], F.[ShiftId], F.[ClassId], F.SectionId, 
		F.[LatePayHeadId], (SELECT [HeadName] FROM #F WHERE FeesHeadId=F.[LatePayHeadId])  AS [LatePayHeadName],LatePayHeadIdAmount,
		[LatePayDay], [LatePayAmount], [IsFixed], 
		[LateInHead], (SELECT [HeadName] FROM #F WHERE FeesHeadId=F.[LateInHead])  AS [LateInHeadName], [LateInPeriod], [LateInAmount], [LateInHeadIdAmount],
		[AbsAHead], (SELECT [HeadName] FROM #F WHERE FeesHeadId=F.[AbsAHead])  AS [AbsAHeadName], [AbsPeriod], [AbsAmount], [AbsHeadIdAmount]
		,LateInAbsConfigDay
		,[LatePayLongRange]
		,[LatePayLongRangeAmount]
		,[LatePayLongRangeAmountIsPercentage]
		,[LatePayLongRangeHeadIdAmount]
		,[LatePayIsPreviouseFine],
		[AbsConPeriod], [AbsConAHead], (SELECT [HeadName] FROM #F WHERE FeesHeadId=F.[AbsConAHead])  AS [AbsConAHeadName], [AbsConAmount], [AbsConHeadIdAmount],F.[Type], F.FessGroupId
		FROM [dbo].[Fees_AutomatedFeesConfig] AS F INNER JOIN view_CommonTableNames AS C
		ON  F.SessionId=C.SessionId AND F.branchId=C.BranchId AND F.ShiftId=C.ShiftId AND F.ClassId=C.ClassId 
		WHERE  F.SessionId=@SessionId AND F.BranchId=ISNULL(@BranchId,F.BranchId) AND F.ShiftId=ISNULL(@ShiftId,F.ShiftId) AND F.ClassId=ISNULL(@ClassId,F.ClassId)
		 AND F.SectionId=ISNULL(@SectionId,F.SectionId) AND 
		F.[Type]= ISNULL(@Type, F.[Type])  AND F.IsDeleted=0 AND (F.FessGroupId=ISNULL(@FeesGroupId,F.FessGroupId) OR F.FessGroupId IS NULL)
	END
		IF(@Block=3) -- AutomatedFees Lists
	BEGIN  --   [AutomatedFees] 3,1,6,null,null,null,null,null,null,'A'
		SELECT f.* ,s.SessionName,b.BranchName,sh.ShiftName,c.ClassName,se.SectionName
		, (SELECT [HeadName] FROM #F WHERE FeesHeadId=F.[LatePayHeadId])  AS LatePayHeadName
		, (SELECT [HeadName] FROM #F WHERE FeesHeadId=F.[LateInHead])  AS LateInHeadName
		, (SELECT [HeadName] FROM #F WHERE FeesHeadId=F.[AbsAHead])  AS AbsAHeadName
		, (SELECT [HeadName] FROM #F WHERE FeesHeadId=F.[AbsConAHead])  AS AbsConAHeadName
		FROM [dbo].[Fees_AutomatedFeesConfig] AS F 
		LEFT JOIN Ins_Session s on s.SessionId=f.SessionId
		LEFT JOIN Ins_Branch b on b.BranchId=f.BranchId
		LEFT JOIN Ins_Shift sh on sh.ShiftID=f.ShiftId
		LEFT JOIN Ins_ClassInfo c on c.ClassId=f.ClassId
		LEFT JOIN Ins_Section se on se.SectionId=f.SectionId
	 
		WHERE  F.SessionId=@SessionId AND F.BranchId=ISNULL(@BranchId,F.BranchId) AND F.ShiftId=ISNULL(@ShiftId,F.ShiftId) AND F.ClassId=ISNULL(@ClassId,F.ClassId)
		AND  F.SectionId=ISNULL(@SectionId,F.SectionId) AND 
		F.[Type]= @Type AND F.IsDeleted=0 AND (F.FessGroupId=ISNULL(@FeesGroupId,F.FessGroupId) OR F.FessGroupId IS NULL)
		order by f.ClassId
	END
	DROP TABLE #F
END

		   

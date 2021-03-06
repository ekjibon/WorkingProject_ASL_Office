/****** Object:  StoredProcedure [dbo].[GetStudentInfo]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentInfoForTransport]'))
BEGIN
DROP PROCEDURE  dbo.GetStudentInfoForTransport
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[GetStudentInfoForTransport] 1,1,2,1,1,0,5,2,
--[GetStudentInfoForTransport] null,null,null,null,null,null,null,null,null,10513
CREATE PROCEDURE [dbo].[GetStudentInfoForTransport] -- Total 11 param
	
	@VersionId INT =null,
	@SessionId INT =null ,
	@BranchID INT  =null,
	@ShiftID INT =null,
	@ClassId INT =null,
	@GroupId INT =null,
	@SectionId INT  =null,
	@StudentTypeID INT =null,
	@ProcessID INT =null,
	@StudentIID NVARCHAR(50) =null
AS
BEGIN
	SELECT    
		 SB.StudentIID,SB.StudentInsID,
		 s.SessionName, v.VersionName, b.BranchName, sh.ShiftName, c.ClassName,g.GroupName, sc.SectionName, 
		 CAST( sb.RollNo as int) RollNo,sb.FullName, SB.TransportFacility,
		SB.FatherName,SB.MotherName,sb.StudentTypeID, STY.StudentTypeName,ro.RouteId,ro.RouteName,ro.VehicleType
		,(CASE WHEN exists(select * from dbo.Fees_HeadAmountConfig fhc where fhc.StudentIID=SB.StudentIID and fhc.ProcessId=@ProcessID) 
		THEN (select top 1 Amount from dbo.Fees_HeadAmountConfig fhc where fhc.StudentIID=SB.StudentIID and fhc.ProcessId=@ProcessID 
		order by HeadAmountConfigId desc ) 
		ELSE ISNULL(ro.Amount,0) END ) Amount
	FROM     dbo.Student_BasicInfo SB          
       
		INNER JOIN  dbo.Ins_Version v  ON v.VersionId = sb.VersionID 
		INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  dbo.Ins_Branch b ON sb.BranchID = b.BranchId 
		INNER JOIN dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId 
		INNER JOIN dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId 
		INNER JOIN  dbo.Ins_Group g ON sb.GroupId = g.GroupId
		INNER JOIN dbo.Ins_Section sc ON sc.SectionId = sb.SectionId 
		INNER JOIN  dbo.Ins_StudentType STY ON STY.StudentTypeId = SB.StudentTypeID 
		LEFT OUTER JOIN Ins_Route ro ON ro.RouteId = SB.RouteId

		WHERE 
			sb.[Status] = 'A' AND 
			 -- Sb.StudentTypeID =2 AND
			sb.VersionID =ISNULL(@VersionId,Sb.VersionID)  AND 
			sb.SessionId =ISNULL(@SessionId,Sb.SessionId)  AND 
			sb.BranchID =ISNULL(@BranchID,Sb.BranchID)  AND
			sb.ShiftID =ISNULL(@ShiftID,Sb.ShiftID)  AND
			sb.ClassId =ISNULL(@ClassId,Sb.ClassId)  AND
			sb.GroupId =ISNULL(@GroupId,Sb.GroupId)  AND
			sb.SectionId =ISNULL(@SectionId,Sb.SectionId)   
			
		and Sb.StudentTypeID =ISNULL(@StudentTypeID,Sb.StudentTypeID)
		and sb.StudentIID= ISNULL(@StudentIID,sb.StudentIID)
		ORDER BY CAST( sb.RollNo as int)

END
--Declare @a int= select * from dbo.Fees_HeadAmountConfig fhc where fhc.StudentIID= and fhc.ProcessId=@ProcessID
--select top 1 Amount,HeadAmountConfigId from dbo.Fees_HeadAmountConfig where StudentIID=10513 and ProcessId=51 order by HeadAmountConfigId desc 
--select top 1 MAX(Amount) from dbo.Fees_HeadAmountConfig fhc where fhc.StudentIID=SB.StudentIID and fhc.ProcessId=@ProcessID)

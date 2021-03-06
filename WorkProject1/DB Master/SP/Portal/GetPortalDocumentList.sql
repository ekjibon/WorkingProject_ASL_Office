IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetPortalDocumentList]'))
BEGIN
DROP PROCEDURE  GetPortalDocumentList
END
GO
/****** Object:  StoredProcedure [dbo].[GetPortalDocumentList]    Script Date: 5/10/2019 10:25:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetPortalDocumentList]
(
 @Type Int,                     --All List = 1,Academic Calander List = 2,Newsletter = 3   
 @SessionId Int,
 @Month nvarchar(15),                            -- DocumentType 1 Student ,2 Employee
 @StuId INT
)
As 
Begin
if(@Type=1)  -- GetPortalDocumentList 1,null,null,null
begin
Select pd.DocumentId,pd.TypeId,pd.DocType, pd.BranchId,pd.SessionId,pd.ShiftId,pd.ClassId, pd.Title,pd.ClassId,pd.AddDate,
         case pd.DocType 
		 when 1 then 'Student'
		 when 2 then 'Employee'
		 end DocTypeName,
pd.Month,pd.Year,
      case pd.TypeId
	   when 1 then 'Academic Calendar'
	   when 2 then 'Newsletter'
	   when 3 then 'ECA Notice'
	   when 4 then 'General Notice'
	   when 5 then 'Homework'
	   when 6 then 'CS Header'
	   when 7 then 'Routine'
	   when 8 then 'Working Calender'
	   end TypeName,
s.SessionName,cl.ClassName,sft.ShiftName,bra.BranchName from dbo.Portal_Document pd
 left outer join Ins_Session s on s.SessionId = pd.SessionId
 left outer join Ins_ClassInfo cl on cl.ClassId=pd.ClassId
 left outer join Ins_Shift sft on sft.ShiftId=pd.ShiftId
 left outer join Ins_Branch bra on bra.BranchId=pd.BranchId
 where pd.IsDeleted=0 and pd.Status= 'A' order by pd.DocumentId desc
end
if(@Type=2)    ---- GetPortalDocumentList 2,null,null,5118      ---For Student Portal TypeId = 1 Academic Calender                                     
begin                                                  
Select pd.DocumentId,pd.TypeId,pd.Title,pd.Month,pd.Year,pd.ClassId,SB.ClassId,c.ClassName,
      case pd.TypeId
	   when 1 then 'Academic Calendar'
	   when 2 then 'Newsletter'
	   when 3 then 'ECA Notice'
	   when 4 then 'General Notice'
	   when 5 then 'Homework'
	   when 6 then 'CS Header'
	   when 7 then 'Routine'
	   end TypeName,

s.SessionName from dbo.Portal_Document pd
Join dbo.Student_BasicInfo SB on SB.StudentIID = @StuId
 join Ins_Session s on SB.SessionId = s.SessionId
 join Ins_ClassInfo c on  SB.ClassId = c.ClassId
 where SB.BranchID = pd.BranchId and SB.ShiftID = pd.ShiftId and SB.ClassId = pd.ClassId 
                  and SB.SessionId = pd.SessionId and pd.TypeId=1 and (pd.IsDeleted=0 and pd.Status= 'A') and pd.DocType=1
 order by pd.DocumentId desc
end
if(@Type=5)            ---- GetPortalDocumentList 5,null,null,5118
begin
Select pd.*,
      case 
	   when pd.TypeId=1 then 'Academic Calendar'
	   when pd.TypeId=2 then 'Newsletter'
	   when pd.TypeId=3 then 'ECA Notice'
	   when pd.TypeId=4 then 'General Notice'
	   when pd.TypeId=5 then 'Homework'
	   when pd.TypeId=6 then 'CS Header'
	   when pd.TypeId=7 then 'Routine'
	   end TypeName
	    from dbo.Portal_Document pd
		INNER JOIN dbo.Student_BasicInfo SB ON SB.StudentIID = @StuId
 where pd.TypeId=5 and (pd.IsDeleted=0 and pd.Status= 'A') and pd.DocType=1 AND SB.ClassId = pd.ClassId AND pd.BranchId = SB.BranchID
 ORDER BY pd.DocumentId DESC
end
if(@Type=3)
begin
Select pd.DocumentId,pd.TypeId,pd.Title,pd.Month,pd.Year,pd.ClassId,
      case pd.TypeId
	   when 1 then 'Academic Calendar'
	   when 2 then 'Newsletter'
	   when 3 then 'ECA Notice'
	   when 4 then 'General Notice'
	   when 5 then 'Homework'
	   when 6 then 'CS Header'
	   when 7 then 'Routine'
	   end TypeName,

s.SessionName from dbo.Portal_Document pd
 join Ins_Session s on s.SessionId = pd.SessionId 
  Inner JOin dbo.Student_BasicInfo sb on sb.ClassId=pd.ClassId and sb.StudentIID = @StuId 
                                              and sb.BranchID=pd.BranchId and sb.ShiftID=pd.ShiftId and sb.SessionId=pd.SessionId
 where pd.TypeId=2 and pd.SessionId=@SessionId and pd.Month =@Month  and (pd.IsDeleted=0 and pd.Status= 'A') and pd.DocType=1
end
if(@Type=4)
begin
Select pd.DocumentId,pd.TypeId,pd.Title,pd.Month,pd.Year,
      case pd.TypeId
	  when 1 then 'Academic Calendar'
	   when 2 then 'Newsletter'
	   when 3 then 'ECA Notice'
	   when 4 then 'General Notice'
	   when 5 then 'Homework'
	   when 6 then 'CS Header'
	   when 7 then 'Routine'
	   end TypeName,

s.SessionName from dbo.Portal_Document pd
 join Ins_Session s on s.SessionId = pd.SessionId
 where pd.TypeId=3 and (pd.IsDeleted=0 and pd.Status= 'A') and pd.DocType=1 order by pd.DocumentId desc
end

if(@Type=6)  -- Type =6 CS list GetPortalDocumentList 6,null,null,null
begin
select cs.*,
case
when cs.CSType='Donation' then CONVERT(varchar,'')
when cs.CSType='CS Visit Request' then CONVERT(varchar,cs.CSVisitDateTime)
when cs.CSType='Volunteer Request' then CONVERT(varchar,cs.VolunteerDate)
end VVDate,cs.VolunteerName,cs.Relation,cs.AddBy,cs.AddDate,sb.FullName,EB.FullName AS EmpName
 from Ins_CSInfo cs 
LEFT JOIN  Student_BasicInfo sb on cs.ReferenceId=sb.StudentIID --where cs.RefTypeId = 2
LEFT JOIN  dbo.Emp_BasicInfo EB on cs.ReferenceId=EB.EmpBasicInfoID --where cs.RefTypeId = 2
order by cs.CSId desc
end


if(@Type=7)  -- Type =7 Newsletter List DocType =2 For Employee Only using Sp for Employee Portal
begin                   --GetPortalDocumentList 7,null,null,null
Select pd.DocumentId,pd.TypeId,pd.SessionId,pd.BranchId, pd.Title,pd.Month, pd.DocType, pd.FileName,pd.Month,pd.Year,
      case pd.TypeId
	   when 1 then 'Academic Calendar'
	   when 2 then 'Newsletter'
	   when 3 then 'ECA Notice'
	   when 4 then 'General Notice'
	   when 5 then 'Homework'
	   end TypeName,
       pd.AddDate
 from dbo.Portal_Document pd
 where  pd.DocType = 2 and pd.IsDeleted=0 and pd.Status= 'A' and (pd.TypeId=1 or pd.TypeId=2 or pd.TypeId=8)   --order by pd.DocumentId desc
end


if(@Type=8)  -- Type =8 General Notice List
begin
Select pd.DocumentId,pd.TypeId,pd.Title,pd.FileName,pd.Month,pd.Year,
      case pd.TypeId
	   when 1 then 'Academic Calendar'
	   when 2 then 'Newsletter'
	   when 3 then 'ECA Notice'
	   when 4 then 'General Notice'
	   when 5 then 'Homework'
	   when 6 then 'CS Header'
	   when 7 then 'Routine'
	   end TypeName,
       pd.AddDate,
s.SessionName from dbo.Portal_Document pd
Inner join Ins_Session s on s.SessionId = pd.SessionId  
 Inner Join Student_BasicInfo SB on SB.StudentIID = @StuId and SB.SessionId = pd.SessionId
                                                     and SB.ClassId = pd.ClassId and SB.ShiftID = pd.ShiftId
													 and SB.BranchID = pd.BranchId
 where pd.TypeId=4 and (pd.IsDeleted=0 and pd.Status= 'A') and pd.DocType=1 order by pd.DocumentId desc
end
IF(@Type=9)  -- Type =9 General Notice List For Employee Portal
BEGIN
	SELECT 
	 pd.DocumentId
	,pd.TypeId
		,pd.BranchId
	,pd.Title
	,pd.FileName
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
	WHERE pd.TypeId=4 and (pd.IsDeleted=0 and pd.[Status]= 'A') and pd.DocType=2 AND pd.BranchId = @SessionId  order by pd.DocumentId desc
END
IF(@Type=10)  -- Type =10 General Notice List For Employee Portal
BEGIN
	SELECT 
	 pd.DocumentId
	,pd.TypeId

	,pd.Title
	,pd.FileName
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
	WHERE pd.TypeId=6 and (pd.IsDeleted=0 and pd.[Status]= 'A') and pd.DocType=2 order by pd.DocumentId desc
END
END

-- GetPortalDocumentList 10,8,'',0

-- SELECT * FROM Portal_Document
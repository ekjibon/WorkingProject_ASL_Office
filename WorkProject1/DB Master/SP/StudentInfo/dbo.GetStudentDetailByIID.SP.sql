
/****** Object:  StoredProcedure [dbo].[rpt_GetStudentInfoByIID]    Script Date: 7/22/2017 4:37:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentDetailByIID]'))
BEGIN
DROP PROCEDURE  [dbo].GetStudentDetailByIID 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[GetStudentDetailByIID]  13710

create PROCEDURE [dbo].[GetStudentDetailByIID] 
	@StudentIID BIGINT
AS
BEGIN
--1.Student Info
SELECT sb.*
,cast(sb.RollNo AS INT) RollNo
,stp.StudentTypeName
,hus.HouseName House
,stp.StudentTypeName
,rt.RouteName
,hus.HouseName
,stIm.ImageName 
,stIm.Photo StudentPhoto
--Address Info
,Con.Pre_Address PresentAddress
,Con.Pre_DisId
,preDis.DistrictName PresentDistric
,Con.Pre_PSId
,prePS.PsName PresentPS
,Con.Pre_PostOffice PresentPostOffice
,con.Pre_PostalCode PresentPostalCode
,Con.Par_Address PermanentAddress
,Con.Par_DisId
,parDis.DistrictName PermanentDistric
,Con.Par_PSId
,parPS.PsName PermanentPS
,Con.Par_PostOffice PermanentPostOffice
,con.Par_PostalCode	PermanentPostalCode

-- common 
,s.SessionName
,s.Session_StartDate
,s.Session_EndDate
,sh.ShiftName
,c.ClassName,sc.LockOut,sc.PickUpTime
,sc.SectionName,ec.ClubName,CAST(ecc.[ToTime] as datetime) as ToTime,
case ecc.DayId
when 2 then 'Sunday'
when 3 then 'Monday'
when 4 then 'Thuesday'
end DayName
,b.BranchName
	FROM   
	 dbo.Student_BasicInfo sb 
left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
left outer join dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId
left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
left outer join dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
	 left outer join dbo.Student_ContactInfo Con ON Con.StudentIID = sb.StudentIID
	 left outer join dbo.Ins_StudentType stp ON stp.StudentTypeId = sb.StudentTypeId
	 left outer join dbo.Ins_Route rt ON rt.RouteId = sb.RouteId
	 left outer join dbo.Ins_House hus ON hus.HouseId = sb.HouseId
	 left outer join dbo.Student_Image stIm ON stIm.StudentIID = sb.StudentIID
	  left outer join dbo.Ins_ECAClub ec ON ec.ClubId = sb.ECAClubId
	 left outer join dbo.Ins_ECAClubConfig ecc ON ecc.ClubId = sb.ECAClubId and ecc.ClassId = sb.ClassId
	                                                   and ecc.SessionId = ecc.SessionId and ecc.BranchId = sb.BranchID
	                                                    and ecc.ShiftId = sb.ShiftID
	 left outer join dbo.Common_District preDis ON preDis.DistrictId = Con.Par_DisId
	 left outer join dbo.Common_District parDis ON parDis.DistrictId = Con.Pre_DisId
	 left outer join dbo.Common_PoliceStation parPS ON parPS.PsId = Con.Par_PSId
	 left outer join dbo.Common_PoliceStation prePS ON prePS.PsId = Con.Pre_PSId
	
	 where sb.StudentIID=@StudentIID

	 --2.Gurdian Info
Select 
	 SG.GuardianInfoId
	 ,SG.StudentIID
	 	--Father Info
,SG.F_Qualification 
,SG.F_Email  
,SG.F_Profession 
,SG.F_OfficeAddress 
,SG.F_Mobile 
,SG.F_TIN 
,SG.F_NIDNo 
,SG.F_GuardianImage
,SG.F_GuardianSignature 
,SG.F_Mobile 
,SG.F_MonthlyIncome 
,SG.F_NIDNo 
,SG.F_PassportNo
--Mather info
,SG.M_Email
,SG.M_Mobile 
,SG.M_MonthlyIncome  
,SG.M_NIDNo 
,SG.M_Qualification 
,SG.M_Profession 
,SG.M_OfficeAddress  
,SG.M_Profession 
,SG.M_TIN 
,SG.M_NIDNo 
,SG.M_GuardianImage 
,SG.M_GuardianSignature 
,SG.M_PassportNo
--Gurdian Info
,SG.G1_Name 
,SG.G1_Qualification 
,SG.G1_Profession
,SG.G1_MonthlyIncome 
,SG.G1_OfficeAddress 
,SG.G1_Mobile  
,SG.G1_Email 
,SG.G1_TIN 
,SG.G1_NIDNo 
,SG.G1_PassportNo 
--Local Gurdian Info
,SG.LG_Name 
,SG.LG_Relation 
,SG.LG_Address 
,SG.LG_Mobile 
,SG.LG_Email 
,SG.LG_TIN 
,SG.LG_GuardianImage 
,SG.LG_GuardianSignature 
,SG.LG_NIDNo
--Local Gurdian Info 2
,SG.LG2_Name 
,SG.LG2_Relation 
,SG.LG2_Address 
,SG.LG2_Mobile 
,SG.LG2_Email 
,SG.LG2_TIN 
,SG.LG2_GuardianImage 
,SG.LG2_GuardianSignature 
,SG.LG2_NIDNo
--Local Gurdian Info 3
,SG.LG3_Name 
,SG.LG3_Relation 
,SG.LG3_Address 
,SG.LG3_Mobile 
,SG.LG3_Email 
,SG.LG3_TIN 
,SG.LG3_GuardianImage 
,SG.LG3_GuardianSignature 
,SG.LG3_NIDNo


,SG.LG4_Name 
,SG.LG4_Relation 
,SG.LG4_Address 
,SG.LG4_Mobile 
,SG.LG4_Email 
,SG.LG4_TIN 
,SG.LG4_GuardianImage 
,SG.LG4_GuardianSignature 
,SG.LG4_NIDNo
--Emergence Info
,SG.E_Name 
,SG.E_Address 
,SG.E_Mobile 
,SG.E_NIDNo 
,SG.E_Relation 
,SG.E_Email
,SG.E_GuardianImage
,SG.E_GuardianSignature
from dbo.Student_GuardianInfo SG 
where SG.StudentIID=@StudentIID
	 --3.Acamemic Info
select * from dbo.Student_AcademicInfo SA where SA.StudentIID=@StudentIID
 --4.Contact Info
 select SC.*,Pre.DistrictName Pre_DisName,Popre.PsName Pre_PSName,
 Par.DistrictName Par_DisName,Popar.PsName Par_PSName from dbo.Student_ContactInfo SC 
 left outer join dbo.Common_District Pre on SC.Pre_DisId=pre.DistrictId
 left outer join dbo.Common_District Par on SC.Par_DisId=Par.DistrictId
 left outer join dbo.Common_PoliceStation Popre on SC.Pre_PSId=Popre.PsId 
 left outer join dbo.Common_PoliceStation Popar on SC.Par_PSId=Popar.PsId 
 where SC.StudentIID=@StudentIID
	 --5.Sibling Info
select 
sb.StudentIID
,sb.RollNo
,sb.StudentInsID 
,sb.FullName 
,sb.SMSNotificationNo
,sb.Gender
,sb.Nationality
,sb.AdmissionDate
,sb.DateOfBirth
,sb.Age
,stIm.ImageName
,sb.TransportFacility
,sb.Height
,sb.[Weight]
,s.SessionName
,sh.ShiftName
,c.ClassName
,sc.SectionName
,b.BranchName
,ih.HouseName
,st.StudentTypeName
from  dbo.Student_SiblingInfo SA
left outer join Student_BasicInfo sb on sb.StudentIID=SA.SiblingStudentIID
left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
left outer join dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId
left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
left outer join dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
left outer join dbo.Student_Image stIm ON stIm.StudentIID = sb.StudentIID
left outer join dbo.Ins_House IH on ih.HouseId=sb.HouseID
left outer join dbo.Ins_StudentType st on st.StudentTypeId=sb.StudentTypeID
	  where SA.StudentIID=@StudentIID
	  --6.other Info
select *from dbo.Student_OthersInfo where Student_OthersInfo.StudentIID=@StudentIID
--Result Info
	--7.Grand Result info
	
	select * from dbo.Res_MainExamResult MER
	Join dbo.Res_MainExam ME on ME.MainExamId=MER.MainExamId
	 join dbo.Ins_Session s ON ME.SessionId = s.SessionId
	 join dbo.Ins_ClassInfo c ON ME.ClassId = c.ClassId
	 where MER.StudentIID=@StudentIID
	 --9. Attendence
	create table #temp (
TotalAttendence int,
TotalLeave int,
TotalAbsconding int ,
TotalWorkingDays int,
TotalAbsent int  
)
Declare @TotalAttendence int
Declare @TotalLeave int
Declare @TotalAbsconding int
Declare @TotalWorkingDays int
Declare @TotalAbsent int
set  @TotalAttendence =ISNULL((select COUNT(*) from dbo.Att_StudentAttendance group by StudentId,IsPresent having IsPresent=1 and StudentId= @StudentIID),0)
set  @TotalLeave =ISNULL((select COUNT(*) from dbo.Att_StudentAttendance group by StudentId,IsLeave having IsLeave=1 and StudentId= @StudentIID),0)
set  @TotalAbsconding =ISNULL((select COUNT(*) from dbo.Att_StudentAttendance group by StudentId,IsAbsconding having IsAbsconding=1 and StudentId= @StudentIID),0)
set  @TotalWorkingDays =ISNULL((select COUNT(*) from dbo.Att_AcademicCalendar where Year= YEAR(getdate()) and DayType='Regular'),0)
set  @TotalAbsent =ISNULL( @TotalWorkingDays-@TotalAttendence-@TotalLeave,0)
insert into #temp (TotalAttendence,TotalLeave,TotalAbsconding,TotalWorkingDays,TotalAbsent) values  (@TotalAttendence, @TotalLeave,@TotalAbsconding,@TotalWorkingDays,@TotalAbsent)
select*from #temp
drop table #temp
	 --Fees info
	 select *from dbo.Fees_CollectionMaster where StudentIID=@StudentIID
		
END
 
 select*from dbo.Student_SiblingInfo where Student_SiblingInfo.StudentIID=@StudentIID

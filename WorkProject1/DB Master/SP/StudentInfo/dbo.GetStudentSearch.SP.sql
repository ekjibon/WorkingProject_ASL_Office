
GO
/****** Object:  StoredProcedure [dbo].[GetStudentSearch]    Script Date: 5/16/2019 9:52:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec GetStudentSearch 'SB.Status IN (''A'') AND SB.IsDeleted=0  AND   SB.SessionId  IN (12)  AND   SB.BranchID  IN (1)  AND   SB.ShiftID  IN (1002)  AND   SB.ClassId  IN (19)'

ALTER PROCEDURE [dbo].[GetStudentSearch] -- Total 11 param

@Where varchar(MAX) = NULL
AS
BEGIN           
DECLARE @sql varchar(max)

SET @sql =  'SELECT Distinct sb.StudentIID,s.SessionName Session,b.BranchName Branch,sh.ShiftName Shift,c.ClassName Class,sc.SectionName Section,
		 cast(sb.RollNo AS INT) RollNo, sb.StudentInsID, sb.FullName, sb.SMSNotificationNo SMSNotificationNo,stp.StudentTypeName
		,hus.HouseName House,sb.Gender,RDC.Text Religion,BDC.Text BloodGroup,sb.Nationality,FORMAT( sb.AdmissionDate, ''dd/MM/yyyy'', ''en-US'' ) as AdmissionDate,
		FORMAT( sb.DateOfBirth, ''dd/MM/yyyy'', ''en-US'' ) as DOB ,sb.Age,stIm.Photo ImageName
		,sb.TransportFacility Transport,sb.Height,sb.Weight, rt.RouteName,sb.Quota,
		 STUFF((SELECT '','' + so.ExtraActivity 
              FROM dbo.Student_OthersInfo so where so.StudentIID=sb.StudentIID and so.Type=''InterestIn''
              FOR XML PATH ('''')),1,1,'''') AS InterestIn, 
			 STUFF(  (SELECT '','' + so.ExtraActivity 
              FROM dbo.Student_OthersInfo so where so.StudentIID=sb.StudentIID and so.Type=''MemberofClub''
              FOR XML PATH ('''')),1,1,'''') AS MemberofClub, 
			  STUFF(  (SELECT '','' + so.ExtraActivity 
              FROM dbo.Student_OthersInfo so where so.StudentIID=sb.StudentIID and so.Type=''Organization''
              FOR XML PATH ('''')),1,1,'''') AS Organization,
			   STUFF(  (SELECT '','' + so.ExtraActivity 
              FROM dbo.Student_OthersInfo so where so.StudentIID=sb.StudentIID and so.Type=''Participation''
              FOR XML PATH ('''')),1,1,'''') AS Participation,
			  sb.FatherName,sb.MotherName, gur.F_Qualification FatherEQ,gur.F_Email FatherEmail,gur.F_Profession FatherProfession,gur.F_OfficeAddress FatherOfficeAddress ,gur.F_TIN FatherTINNo,gur.F_NIDNo FatherNID,gur.F_GuardianImage FatherImage,gur.F_PassportNo FatherPassport
		,gur.F_Mobile FatherMobileNo,gur.F_MonthlyIncome FatherMonthlyIncome,gur.F_NIDNo FatherNIDNo,
		gur.M_Email MotherEmail,gur.M_Mobile MotherEmail,gur.M_MonthlyIncome MotherMonthlyIncome ,gur.M_NIDNo MotherMobileNo,gur.M_Qualification MotherEQ,gur.M_Profession MotherProfession, gur.M_OfficeAddress MotherOfficeAddress,gur.M_PassportNo MotherPassport	
		,gur.M_TIN MotherTINNo,gur.M_NIDNo MotherNID,gur.M_GuardianImage MotherImage
		,gur.G1_Name GuardianName
		,gur.G1_Mobile GuardianMother,gur.G1_MonthlyIncome GuardianMonthlyIncome,gur.G1_NIDNo GuardianNIDNo,gur.G1_Qualification 
		,gur.LG_Relation GuardianRelation,gur.LG_Address GuardianAddress ,gur.LG_Mobile GuardianMobile,gur.LG_Email,gur.LG_TIN ,gur.LG_NIDNo GuardianNID,gur.LG_GuardianImage, 
		   gur.G1_Mobile GuardianMobile,gur.G1_OfficeAddress GuardianAddress,gur.G1_NIDNo GuardianNID,gur.LG_GuardianImage GuardianImage,
		gur.E_Name EmergencyContactName,gur.E_Address EmergencyContactAddress,gur.E_Mobile EmergencyContactMobile,gur.E_NIDNo EmergencyContactNID,gur.E_Relation EmergencyContactRelation,gur.F_GuardianImage EmergencyContactImage
		, gur.F_Email,Con.Par_Address ,Con.Pre_Address PresentAddress,Con.Par_Address,Con.Par_Address,Con.Par_Address,Con.Par_Address PermanentAddress,
		preDis.DistrictName PresentDistrict,parDis.DistrictName PermanentDistrict,prePS.PsName PresentThana ,parPS.PsName PermanentThana,PSCaci.ExamName ,PSCaci.DistrictThana PECDistrictThana,PSCaci.ExamSession
		,PSCaci.ExamRoll PECRollNo,PSCaci.ExamRegNo PECRegNo,PSCaci.InstituteName PECInstituteName,PSCaci.PassYear PECYear,PSCaci.ExamSession PECSession,PSCaci.GPA PECGPAMarks,
		JSCaci.ExamName ,JSCaci.DistrictThana JSCDistrictThana,JSCaci.ExamSession
		,JSCaci.ExamRoll JSCRollNo,JSCaci.ExamRegNo JSCRegNo,JSCaci.InstituteName JSCInstituteName,JSCaci.PassYear JSCYear,JSCaci.ExamSession JSCSession, PSCaci.GPA JSCGPAMarks,
		SSCaci.ExamName ,SSCaci.DistrictThana SSCDistrictThana,SSCaci.ExamSession,SSCaci.Board SSCBoard,SSCaci.ExamGroup SSCGroup,SSCaci.Center SSCCenter
		,SSCaci.ExamRoll SSCRollNo,SSCaci.ExamRegNo SSCRegNo,SSCaci.InstituteName SSCInstituteName,SSCaci.PassYear SSCPassYear,SSCaci.ExamSession SSCSession, PSCaci.GPA SSCGPAMarks,SSCaci.ExamYear SSCExamYear
	FROM   
	 vwStudentBasicDetail sb 
	 left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
	 left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
	 left outer join dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId
	 left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
	 left outer join dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
	 left outer join dbo.Ins_Route rt ON rt.RouteId = sb.RouteId
	 left outer join dbo.Student_AcademicInfo PSCaci ON PSCaci.StudentIID = sb.StudentIID and PSCaci.ExamName=''PSC''
	 left outer join dbo.Student_AcademicInfo JSCaci ON JSCaci.StudentIID = sb.StudentIID and JSCaci.ExamName=''JSC''
	 left outer join dbo.Student_AcademicInfo SSCaci ON SSCaci.StudentIID = sb.StudentIID and SSCaci.ExamName=''SSC''
	  left outer join dbo.Student_AcademicInfo HSCaci ON HSCaci.StudentIID = sb.StudentIID and HSCaci.ExamName=''HSC''
	 left outer join dbo.Student_GuardianInfo gur ON gur.StudentIID = sb.StudentIID
	 left outer join dbo.Student_ContactInfo Con ON Con.StudentIID = sb.StudentIID

	 left outer join dbo.Ins_StudentType stp ON stp.StudentTypeId = sb.StudentTypeId
	 left outer join dbo.Ins_House hus ON hus.HouseId = sb.HouseId
	 left outer join dbo.Student_Image stIm ON stIm.StudentIID = sb.StudentIID
	 left outer join dbo.Common_District preDis ON preDis.DistrictId = Con.Par_DisId
	 left outer join dbo.Common_District parDis ON parDis.DistrictId = Con.Pre_DisId
	 left outer join dbo.Common_PoliceStation parPS ON parPS.PsId = Con.Par_PSId
	 left outer join dbo.Common_PoliceStation prePS ON prePS.PsId = Con.Pre_PSId
	 left outer join dbo.Student_OthersInfo OIn ON OIn.StudentIID = sb.StudentIID
	  left outer join dbo.Common_DropDownConfig RDC ON RDC.Value = sb.Religion and RDC.Type=''Religion''
	 left outer join dbo.Common_DropDownConfig BDC ON BDC.Value = sb.BloodGroup and BDC.Type=''Blood Group''
	 '
	 IF(@Where IS NOT NULL and  @Where <> '')
	 BEGIN
	 SET @sql = @sql + ' WHERE '+ @Where
	
	 END
	 SET @sql = @sql + '  ORDER BY cast(sb.RollNo AS INT)'
	  EXEC(@sql)
	 END
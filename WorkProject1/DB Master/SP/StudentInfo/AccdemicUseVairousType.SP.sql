GO
/****** Object:  StoredProcedure [dbo].[AccdemicUseVairousType]    Script Date: 3/12/2019 11:36:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[AccdemicUseVairousType] -- exec [AccdemicUseVairousType] 10,8,2,19,76,1,'7/22/2019 12:00:00 AM','7/23/2019 12:00:00 AM'
	
	@SessionId INT,
	@BranchID INT,
	@ShiftID INT,
	@ClassId INT,
	
	@SectionId INT,
	@TypeId INT,  --1 With TC, 2 By Admission AT, 3 given tc, 4 testimonial, 5 General GA, 6 TC AT GA
	@FromDate smallDateTime=null,
	@ToDate smallDateTime =null,
	@StudentIID INT = 0

AS
BEGIN
	--All Admitted Student
	if(@TypeId=1 )
	BEGIN
	select sb.StudentInsID,
	sb.FullName,
	sb.RollNo,
	sb.SMSNotificationNo,
	sb.AdmissionDate ,
	sb.AddmissionEntryType,sb.AdmissionDate,
	C.ClassName,
	
	SEC.SectionName,(
	case when sb.AddmissionEntryType='GN' then 'General'
	when sb.AddmissionEntryType='AT' then 'Admission Test'
	when  sb.AddmissionEntryType='WT' then 'With TC'
	end ) as AddmissionEntryType
	 from Student_BasicInfo sb
	
	LEFT OUTER JOIN Ins_Session S on S.SessionId=sb.SessionId 
	LEFT OUTER JOIN Ins_Branch B on B.BranchId=sb.BranchID 
	LEFT OUTER JOIN Ins_Shift SFT on SFT.ShiftId=sb.ShiftID 
	LEFT OUTER JOIN Ins_ClassInfo C on C.ClassId=sb.ClassId 
	
	LEFT OUTER JOIN Ins_Section SEC on SEC.SectionId=sb.SectionId 
	where (sb.AdmissionDate between @FromDate+1 and @ToDate+1) 
 		
		and sb.SessionId=ISNULL(@SessionId ,sb.SessionId )
		and sb.BranchID=ISNULL(@BranchID ,sb.BranchID )
		and sb.ClassId=ISNULL( @ClassId,sb.ClassId )
		and sb.ShiftID=ISNULL( @ShiftID,sb.ShiftID )
	
		and sb.SectionId=ISNULL(@SectionId,sb.SectionId)
	order by sb.AdmissionDate 
	END
	--General Admission
	if(@TypeId=2)
	BEGIN
	select 
	sb.StudentInsID,
	sb.FullName,
	sb.RollNo,
	sb.SMSNotificationNo,
	sb.AdmissionDate ,
	sb.AddmissionEntryType,
	C.ClassName,
	SEC.SectionName,(
	case when sb.AddmissionEntryType='GN' then 'General'
	when sb.AddmissionEntryType='AT' then 'Admission Test'
	when  sb.AddmissionEntryType='WT' then 'With TC'
	end ) as AddmissionEntryType
	from Student_BasicInfo sb
	 LEFT OUTER JOIN Ins_ClassInfo C on C.ClassId=sb.ClassId 
	 LEFT OUTER JOIN Ins_Section SEC on SEC.SectionId=sb.SectionId 

	 where (sb.AdmissionDate between @FromDate+1 and @ToDate+1) 
			and sb.SessionId=ISNULL(@SessionId ,sb.SessionId )
			and sb.ClassId=ISNULL( @ClassId,sb.ClassId )
			and sb.ShiftID=ISNULL( @ShiftID,sb.ShiftID )
			and sb.SectionId=ISNULL(@SectionId,sb.SectionId)
			and sb.AddmissionEntryType='GN'
	 order by AdmissionDate 
	END
	--Admission Test
	if(@TypeId=3)
	BEGIN
	select 
	sb.StudentInsID,
	sb.FullName,
	sb.RollNo,
	sb.SMSNotificationNo,
	sb.AdmissionDate ,
	sb.AddmissionEntryType,
	C.ClassName,
	SEC.SectionName,(
	case when sb.AddmissionEntryType='GN' then 'General'
	when sb.AddmissionEntryType='AT' then 'Admission Test'
	when  sb.AddmissionEntryType='WT' then 'With TC'
	end ) as AddmissionEntryType
	from Student_BasicInfo sb
	 LEFT OUTER JOIN Ins_ClassInfo C on C.ClassId=sb.ClassId 
	 LEFT OUTER JOIN Ins_Section SEC on SEC.SectionId=sb.SectionId 

	 where (sb.AdmissionDate between @FromDate+1 and @ToDate+1) 
							and sb.SessionId=ISNULL(@SessionId ,sb.SessionId )
							and sb.ClassId=ISNULL( @ClassId,sb.ClassId )
							and sb.ShiftID=ISNULL( @ShiftID,sb.ShiftID )
							and sb.SectionId=ISNULL(@SectionId,sb.SectionId)
							and sb.AddmissionEntryType='AT'
	 order by AdmissionDate 

END
	--With TC
	if(@TypeId=4)
	BEGIN
	select 
	sb.StudentInsID,
	sb.FullName,
	sb.RollNo,
	sb.SMSNotificationNo,
	sb.AdmissionDate ,
	sb.AddmissionEntryType,
	C.ClassName,
	SEC.SectionName,(
	case when sb.AddmissionEntryType='GN' then 'General'
	when sb.AddmissionEntryType='AT' then 'Admission Test'
	when  sb.AddmissionEntryType='WT' then 'With TC'
	end ) as AddmissionEntryType
	from Student_BasicInfo sb
	 LEFT OUTER JOIN Ins_ClassInfo C on C.ClassId=sb.ClassId 
	 LEFT OUTER JOIN Ins_Section SEC on SEC.SectionId=sb.SectionId 

	 where (sb.AdmissionDate between @FromDate+1 and @ToDate+1) 
 		
							and sb.SessionId=ISNULL(@SessionId ,sb.SessionId )
							and sb.ClassId=ISNULL( @ClassId,sb.ClassId )
							and sb.ShiftID=ISNULL( @ShiftID,sb.ShiftID )
						
							and sb.SectionId=ISNULL(@SectionId,sb.SectionId)
							and sb.AddmissionEntryType='WT'
	 order by AdmissionDate 

END	
	--Given TC         
	if(@TypeId=5)   -- exec [AccdemicUseVairousType] 1,6,31,23,1,null,44,5,'1/1/2018','9/17/2018'
	BEGIN
    SELECT
	dbo.Ins_Session.SessionName, dbo.Ins_Shift.ShiftName, dbo.Ins_ClassInfo.ClassName, dbo.Ins_Section.SectionName, sb.RollNo, 
    sb.FullName, sb.SMSNotificationNo, (CASE WHEN sb.AddmissionEntryType='GN' THEN 'General Admission' END) as AddmissionEntryType, sb.AdmissionDate, dbo.Ins_Branch.BranchName, 
    sb.StudentInsID,sb.TCApprovedBy,sb.TCBy,sb.TCCauses,sb.TCDate,sb.TCStatus
    FROM dbo.Ins_ClassInfo INNER JOIN
     dbo.Student_BasicInfo  sb ON sb.ClassId=dbo.Ins_ClassInfo.ClassId
	 inner join dbo.Ins_Section on sb.SectionId= dbo.Ins_Section.SectionId
	 INNER JOIN dbo.Ins_Session ON sb.SessionId = dbo.Ins_Session.SessionId INNER JOIN
     dbo.Ins_Branch ON sb.BranchID = dbo.Ins_Branch.BranchId INNER JOIN
     dbo.Ins_Shift ON sb.ShiftID = dbo.Ins_Shift.ShiftId 
	 WHERE        
		sb.IsTC = 1
		
		and sb.SessionId=ISNULL(@SessionId,sb.SessionId)
		and sb.ClassId=ISNULL( @ClassId,sb.ClassId )
		and sb.ShiftID=ISNULL( @ShiftID,sb.ShiftID )
	
		and sb.SectionId=ISNULL(@SectionId,sb.SectionId)
		and cast( sb.TCDate as date) BETWEEN cast(@FromDate as date) AND cast(@ToDate as date)
	order by AdmissionDate 
	END
	--Testimonial
	if(@TypeId=6)
	BEGIN
	select 
	sb.StudentInsID,
	sb.FullName,
	sb.RollNo,
	sb.SMSNotificationNo,
	sb.AdmissionDate ,
	sb.AddmissionEntryType,

	C.ClassName,

	SEC.SectionName,sb.TestimonialIssueBy,sb.TestimonialIssueDate
	from Student_BasicInfo sb

	 LEFT OUTER JOIN Ins_ClassInfo C on C.ClassId=sb.ClassId 
	
	 LEFT OUTER JOIN Ins_Section SEC on SEC.SectionId=sb.SectionId 
	 where (sb.AdmissionDate between @FromDate+1 and @ToDate+1) 
 		
		and sb.SessionId=ISNULL(@SessionId ,sb.SessionId )
		and sb.ClassId=ISNULL( @ClassId,sb.ClassId )
		and sb.ShiftID=ISNULL( @ShiftID,sb.ShiftID )
	
		and sb.SectionId=ISNULL(@SectionId,sb.SectionId)
		and sb.TestimonialIssueBy is not null
	 order by AdmissionDate 
	END
	--Admission Summary
	if(@TypeId=7)
	BEGIN
	CREATE TABLE #temp (
	ClassId INT,
	SectionId INT,
	StudentTypeID INT,
	NoOfstudent INT,
	[Status] VARCHAR(50),
	[StatusSerial] INT
	)
		INSERT INTO #temp 
		SELECT SB.ClassId, SB.SectionId,Sb.StudentTypeID,COUNT(SB.ClassId),'New Addmission',1
		FROM   dbo.Student_BasicInfo SB WHERE SB.AddmissionStatus = 'N'
		GROUP BY SB.ClassId , SB.SectionId,Sb.StudentTypeID 

		INSERT INTO #temp 
		SELECT SB.ClassId, SB.SectionId,Sb.StudentTypeID,COUNT(SB.ClassId),'Re- Admission',2
		FROM   dbo.Student_BasicInfo SB WHERE SB.AddmissionStatus = 'R'
		GROUP BY SB.ClassId , SB.SectionId,Sb.StudentTypeID 

		INSERT INTO #temp 
		SELECT SB.ClassId, SB.SectionId,Sb.StudentTypeID,COUNT(SB.ClassId),'Inactive (TC)',3
		FROM   dbo.Student_BasicInfo SB WHERE SB.Status = 'ITC' AND IsTC = 1
		GROUP BY SB.ClassId , SB.SectionId,Sb.StudentTypeID
	
		INSERT INTO #temp 
		SELECT SB.ClassId, SB.SectionId,Sb.StudentTypeID,COUNT(SB.ClassId),'Inactive',4
		FROM   dbo.Student_BasicInfo SB WHERE SB.Status = 'I' 
		GROUP BY SB.ClassId , SB.SectionId,Sb.StudentTypeID 

		INSERT INTO #temp 
		SELECT SB.ClassId, SB.SectionId,Sb.StudentTypeID,COUNT(SB.ClassId),'Active',5
		FROM   dbo.Student_BasicInfo SB WHERE SB.Status = 'A' 
		GROUP BY SB.ClassId , SB.SectionId,Sb.StudentTypeID

	SELECT CL.ClassName,SE.SectionName, T.* ,  TY.StudentTypeName FROM #temp T
	INNER JOIN Ins_ClassInfo CL ON CL.ClassId = T.ClassId and CL.ClassId =@ClassId
	INNER JOIN Ins_Section SE ON SE.SectionId = T.SectionId and SE.SectionId = @SectionId
	INNER JOIN Ins_StudentType TY ON TY.StudentTypeId = T.StudentTypeID
	ORDER BY T.ClassId

	DROP TABLE #temp
		
	END
	--TOT List
	if(@TypeId=8)
	BEGIN
	SELECT 
		   SS.StudentIID,
		   STUFF((SELECT ', ' + convert(varchar(500),S.SubjectName)
				  FROM [Res_StudentSubject] US INNER JOIN [Res_SubjectSetup] AS S ON US.SubjectID=S.SubID
				  WHERE US.StudentID = SS.StudentIID
				  FOR XML PATH('')), 1, 1, '') [SUBJECT]
		INTO #SUBJECTNAME FROM [Student_BasicInfo] SS 
		GROUP BY SS.StudentIID, SS.FullName
	ORDER BY 1
	SELECT 
	   SS.StudentIID,
	   STUFF((SELECT ', ' + convert(varchar(500),S.SubjectCode)
			  FROM [Res_StudentSubject] US INNER JOIN [Res_SubjectSetup] AS S ON US.SubjectID=S.SubID
			  WHERE US.StudentID = SS.StudentIID
			  FOR XML PATH('')), 1, 1, '') [SUBJECT CODE]
	INTO #SUBJECTCODE FROM [Student_BasicInfo] SS 
	GROUP BY SS.StudentIID, SS.FullName
	ORDER BY 1
	SELECT S.[StudentID]
		   ,SS.SubjectName
		  , SS.SubjectCode
		  ,[OptionalType]     
	 INTO #OptionalSubject  FROM [dbo].[Res_StudentSubject] AS S
	 LEFT JOIN [dbo].[Res_SubjectSetup] AS SS ON S.SubjectID=SS.SubID WHERE S.[OptionalType] ='FT' 
	SELECT B.FullName, B.FatherName, B.MotherName, B.DateOfBirth, B.Gender, B.RollNo,SI.Photo,
	 V.SessionName,V.ShiftName,V.BranchName, O.SubjectName+'('+O.SubjectCode+')' AS OptionalSubjectAndCode, N.[SUBJECT] as ComSubjectName, C.[SUBJECT CODE] as SUBJECTCODE  
	  FROM [dbo].[Student_BasicInfo] AS B INNER JOIN view_CommonTableNames AS V ON B.ClassId=V.ClassId 
	 AND B.SessionId=V.SessionId AND B.BranchID=V.BranchId AND B.ShiftID=V.ShiftId AND B.SectionId=V.SectionId
	 LEFT JOIN #SUBJECTNAME AS N ON B.StudentIID=N.StudentIID INNER JOIN #SUBJECTCODE AS C ON B.StudentIID=C.StudentIID
	 LEFT JOIN #OptionalSubject AS O ON B.StudentIID=O.StudentID
	 LEFT JOIN [dbo].[Student_Image] AS SI ON B.StudentIID = SI.StudentIID

	 WHERE  B.SessionId=ISNULL(@SessionId ,B.SessionId )
		   and B.BranchID=ISNULL(@BranchID,B.BranchID)
		   and B.ClassId=ISNULL( @ClassId,B.ClassId )
		   and B.ShiftID=ISNULL( @ShiftID,B.ShiftID )	  
		   and B.SectionId=ISNULL(@SectionId,B.SectionId)
	 DROP TABLE #SUBJECTNAME,#SUBJECTCODE,#OptionalSubject
	END

	if(@TypeId=12)
	BEGIN
	select SB.FullName,SB.NameBangla, SB.ClassId,CL.ClassName,SB.SectionId,SE.SectionName from Student_BasicInfo SB
	inner join Ins_ClassInfo CL on CL.ClassId=SB.ClassId
	inner join Ins_Section SE on SE.SectionId=SB.SectionId
	WHERE  SB.SessionId=@SessionId
		   and SB.BranchID=@BranchID
		   and SB.ClassId=@ClassId
		   and SB.ShiftID=@ShiftID
		   and SB.SectionId=@SectionId
	END
	if(@TypeId=13)
	BEGIN
	select SB.FullName,SB.ClassId,
	CL.ClassName,
	SB.SectionId,
	SE.SectionName,
	S.SessionName,
	SB.SMSNotificationNo,
	SE.LockOut,
	SE.PickUpTime,
	SB.ECAClubId,
	C.ClubName,
	CASE cc.DayId 
	When 2 then 'Sunday'
	When 3 then 'Monday'
	When 4 then 'Thuesday'
	end DayName,
	I.Photo,SB.StudentInsID,G.F_GuardianImage as FatherPhoto,
	b.BranchName,b.BranchId, G.M_GuardianImage as MotherPhoto,
	G.LG_GuardianImage as GardianPhoto,
	G.LG_Relation,
	G.E_GuardianImage as EGardianPhoto,
	G.E_Relation,
	ssi.Photo as SiblingImage,G.LG2_GuardianImage,G.LG2_Relation,G.LG2_Name,G.LG3_GuardianImage,G.LG3_Relation,G.LG3_Name,G.LG4_GuardianImage,G.LG4_Relation,G.LG4_Name
	 from Student_BasicInfo SB
	inner join Ins_ClassInfo CL on CL.ClassId=SB.ClassId
	inner join Ins_Section SE on SE.SectionId=SB.SectionId
	LEFT OUTER JOIN Ins_Session S on S.SessionId=SB.SessionId 
	LEFT OUTER JOIN Ins_Branch b on b.BranchId=SB.BranchId 
	LEFT OUTER JOIN Student_Image I on I.StudentIID=SB.StudentIID
	LEFT OUTER JOIN Student_GuardianInfo G on G.StudentIID=SB.StudentIID
	LEFT OUTER JOIN dbo.Ins_ECAClub C on C.ClubId = SB.ECAClubId  and C.Status = 'Approved' 
	LEFT OUTER JOIN dbo.Ins_ECAClubConfig cc on cc.ClubId = C.ClubId
	LEFT OUTER JOIN dbo.Student_SiblingInfo ss on ss.StudentIID = SB.StudentIID
	LEFT OUTER JOIN Student_Image ssi on ssi.StudentIID=ss.SiblingStudentIID

	WHERE SB.SessionId=@SessionId
		   and SB.BranchID=@BranchID
		   and SB.ClassId=@ClassId
		   and SB.ShiftID=@ShiftID
		   and SB.SectionId=@SectionId
	END
	if(@TypeId=14) -- For Studnet Portal
	BEGIN
	select SB.FullName,
	SB.BirthCertificate,
	SB.PPNumber,
	SB.MedicalAdvice,
	SB.RS_MUN, 
	SB.ClassId,
	CL.ClassName,
	SB.SectionId,
	SE.SectionName,
	S.SessionName,
	SB.SMSNotificationNo,
	SB.ECAClubId,b.BranchId,
      sc.Status,SE.LockOut,SE.PickUpTime,	C.ClubName,
	CASE cc.DayId 
	When 2 then 'Sunday'
	When 3 then 'Monday'
	When 4 then 'Thuesday'
	end DayName,
	I.Photo,SB.StudentInsID,G.F_GuardianImage as FatherPhoto,G.M_GuardianImage as MotherPhoto,G.LG4_GuardianImage,G.LG4_Relation,G.LG4_Name,
	G.LG_GuardianImage as GardianPhoto,
	G.LG_Relation,
	G.E_GuardianImage as EGardianPhoto,
	G.LG2_GuardianImage,
	G.LG2_Relation,
	G.LG2_Name,
	G.LG3_GuardianImage,
	G.LG3_Relation,G.LG3_Name,
	G.E_Relation,ssi.Photo as SiblingImage
	 from Student_BasicInfo SB  
	inner join Ins_ClassInfo CL on CL.ClassId=SB.ClassId
	inner join Ins_Section SE on SE.SectionId=SB.SectionId
	inner join Ins_Branch b on b.BranchId=SB.BranchId
	LEFT OUTER JOIN Ins_Session S on S.SessionId=SB.SessionId 
	LEFT OUTER JOIN Student_Image I on I.StudentIID=SB.StudentIID
	LEFT OUTER JOIN Student_GuardianInfo G on G.StudentIID=SB.StudentIID

	LEFT OUTER JOIN dbo.Student_SiblingInfo ss on ss.StudentIID = SB.StudentIID
	LEFT OUTER JOIN Student_Image ssi on ssi.StudentIID=ss.SiblingStudentIID


	Left Outer Join Stu_Clubs sc on  sc.Status = 'Approved' and sc.ClubId = SB.ECAClubId  and sc.StudentId = SB.StudentIID 
	LEFT OUTER JOIN dbo.Ins_ECAClub C on C.ClubId = sc.ClubId 	

	LEFT OUTER JOIN dbo.Ins_ECAClubConfig cc on cc.ClubId = C.ClubId and cc.ClassId = SB.ClassId 
	                         and cc.BranchId = SB.BranchID and cc.SessionId = SB.SessionId and cc.ShiftId =SB.ShiftID
	WHERE SB.StudentIID = @StudentIID and SB.SessionId=@SessionId 
		   and SB.BranchID=@BranchID
		   and SB.ClassId=@ClassId
		   and SB.ShiftID=@ShiftID
		   and SB.SectionId=@SectionId

		   --print SB.ECAClubId;
	END
END	


---AccdemicUseVairousType 10,8,2,19,76,13,null,null,3606
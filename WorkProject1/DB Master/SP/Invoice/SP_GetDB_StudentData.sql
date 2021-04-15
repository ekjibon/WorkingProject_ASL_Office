IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_GetDB_StudentData]'))
BEGIN
DROP PROCEDURE  SP_GetDB_StudentData
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
	--- EXEC SP_GetDB_StudentData ''
CREATE PROCEDURE [dbo].[SP_GetDB_StudentData]
(
@ClientName AS NVARCHAR(MAX)
)
AS

BEGIN
SELECT * FROM
		(select 'AGHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [aghs_new_2018]..Ins_Version v 
		INNER JOIN [aghs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [aghs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [aghs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'APSCL' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [apscl_new_2018]..Ins_Version v 
		INNER JOIN [apscl_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [apscl_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [apscl_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'ACADEMIA' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [academia_new_2020]..Ins_Version v 
		INNER JOIN [academia_new_2020]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [academia_new_2020]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [academia_new_2020]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'BZS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [bzs_new_2018]..Ins_Version v 
		INNER JOIN [bzs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [bzs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [bzs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'BADCHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [badchs_new_2018]..Ins_Version v 
		INNER JOIN [badchs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [badchs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [badchs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'BABS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [babs_new_2019]..Ins_Version v 
		INNER JOIN [babs_new_2019]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [babs_new_2019]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [babs_new_2019]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'BGHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [bghs_new_2019]..Ins_Version v 
		INNER JOIN [bghs_new_2019]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [bghs_new_2019]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [bghs_new_2019]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'BCSIR' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [bcsirhs_new_2018]..Ins_Version v 
		INNER JOIN [bcsirhs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [bcsirhs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [bcsirhs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'BPSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [bpsc_new_2018]..Ins_Version v 
		INNER JOIN [bpsc_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [bpsc_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [bpsc_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'BKSP' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [bksppsc_new_2018]..Ins_Version v 
		INNER JOIN [bksppsc_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [bksppsc_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [bksppsc_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'BBHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [bbhs_new_2018]..Ins_Version v 
		INNER JOIN [bbhs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [bbhs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [bbhs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'BRSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [brsc_new_2018]..Ins_Version v 
		INNER JOIN [brsc_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [brsc_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [brsc_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'BTCL' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [btclisc_new_2018]..Ins_Version v 
		INNER JOIN [btclisc_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [btclisc_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [btclisc_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'CCPC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [ccpc_new_2018]..Ins_Version v 
		INNER JOIN [ccpc_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [ccpc_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [ccpc_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'CGS' Institution,s.SessionName,b.BranchName, 'English' Language, COUNT(SB.StudentIID) Student
		from  [cgsd_new_2019]..Student_BasicInfo SB 
		INNER JOIN [cgsd_new_2019]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [cgsd_new_2019]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by b.BranchName,s.SessionName

		UNION ALL
		select 'DCGHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [dcghs_new_2018]..Ins_Version v 
		INNER JOIN [dcghs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [dcghs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [dcghs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'DCSD' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [dcsd_new_2018]..Ins_Version v 
		INNER JOIN [dcsd_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [dcsd_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [dcsd_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'EUSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [eusc_new_2018]..Ins_Version v 
		INNER JOIN [eusc_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [eusc_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [eusc_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'GFSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [gfsc_new_2018]..Ins_Version v 
		INNER JOIN [gfsc_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [gfsc_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [gfsc_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'GVHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [gvhs_new_2018]..Ins_Version v 
		INNER JOIN [gvhs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [gvhs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [gvhs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'GMUB' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [gmub_new_2018]..Ins_Version v 
		INNER JOIN [gmub_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [gmub_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [gmub_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'HGHSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [hghsc_new_2018]..Ins_Version v 
		INNER JOIN [hghsc_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [hghsc_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [hghsc_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'HPAHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [hpahs_new_2019]..Ins_Version v 
		INNER JOIN [hpahs_new_2019]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [hpahs_new_2019]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [hpahs_new_2019]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'IGGSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [iggsc_new_2018]..Ins_Version v 
		INNER JOIN [iggsc_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [iggsc_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [iggsc_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'IGSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [igsc_new_2019]..Ins_Version v 
		INNER JOIN [igsc_new_2019]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [igsc_new_2019]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [igsc_new_2019]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'KHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [khs_new_2018]..Ins_Version v 
		INNER JOIN [khs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [khs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [khs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'KGSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [kgsc_new_2018]..Ins_Version v 
		INNER JOIN [kgsc_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [kgsc_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [kgsc_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'KAHSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [kahsc_new_2019]..Ins_Version v 
		INNER JOIN [kahsc_new_2019]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [kahsc_new_2019]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [kahsc_new_2019]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'KGSCK' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [kgsck_new_2018]..Ins_Version v 
		INNER JOIN [kgsck_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [kgsck_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [kgsck_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'KGHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [kghs_new_2018]..Ins_Version v 
		INNER JOIN [kghs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [kghs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [kghs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'LGHSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [lghsc_new_2018]..Ins_Version v 
		INNER JOIN [lghsc_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [lghsc_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [lghsc_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'MMHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [mmhs_new_2018]..Ins_Version v 
		INNER JOIN [mmhs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [mmhs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [mmhs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'MHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [mhs_new_2018]..Ins_Version v 
		INNER JOIN [mhs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [mhs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [mhs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'MGHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [mghs_new_2018]..Ins_Version v 
		INNER JOIN [mghs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [mghs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [mghs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'MUBC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [mubc_new_2020]..Ins_Version v 
		INNER JOIN [mubc_new_2020]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [mubc_new_2020]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [mubc_new_2020]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'MGSCN' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [mgscn_new_2018]..Ins_Version v 
		INNER JOIN [mgscn_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [mgscn_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [mgscn_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'NBPSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [nbpsc_new_2019]..Ins_Version v 
		INNER JOIN [nbpsc_new_2019]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [nbpsc_new_2019]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [nbpsc_new_2019]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'PPIMSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [ppimsc_new_2019]..Ins_Version v 
		INNER JOIN [ppimsc_new_2019]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [ppimsc_new_2019]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [ppimsc_new_2019]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'RCMS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [rcms_new_2018]..Ins_Version v 
		INNER JOIN [rcms_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [rcms_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [rcms_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'RBHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [rbhs_new_2018]..Ins_Version v 
		INNER JOIN [rbhs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [rbhs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [rbhs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'RSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [rsc_new_2018]..Ins_Version v 
		INNER JOIN [rsc_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [rsc_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [rsc_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'SACHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [sachs_new_2018]..Ins_Version v 
		INNER JOIN [sachs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [sachs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [sachs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'SC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [sc_new_2019]..Ins_Version v 
		INNER JOIN [sc_new_2019]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [sc_new_2019]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [sc_new_2019]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'SBBM' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [sbbm_new_2018]..Ins_Version v 
		INNER JOIN [sbbm_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [sbbm_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [sbbm_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'SOS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [sos_new_2018]..Ins_Version v 
		INNER JOIN [sos_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [sos_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [sos_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'TQEMS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [tqems_new_2019]..Ins_Version v 
		INNER JOIN [tqems_new_2019]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [tqems_new_2019]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [tqems_new_2019]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'TRSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [trscunique_new_2021]..Ins_Version v 
		INNER JOIN [trscunique_new_2021]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [trscunique_new_2021]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [trscunique_new_2021]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'TGHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [tghs_new_2018]..Ins_Version v 
		INNER JOIN [tghs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [tghs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [tghs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'ULSCDU' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [ulscdu_new_2018]..Ins_Version v 
		INNER JOIN [ulscdu_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [ulscdu_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [ulscdu_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'WHS' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [whs_new_2018]..Ins_Version v 
		INNER JOIN [whs_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [whs_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [whs_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		UNION ALL
		select 'ZCPSC' Institution,s.SessionName,b.BranchName, v.VersionName, COUNT(SB.StudentIID) Student
		from [zcpsc_new_2018]..Ins_Version v 
		INNER JOIN [zcpsc_new_2018]..Student_BasicInfo SB ON v.VersionId = sb.VersionID 
		INNER JOIN [zcpsc_new_2018]..Ins_Session s ON sb.SessionId = s.SessionId 
		INNER JOIN  [zcpsc_new_2018]..Ins_Branch b ON sb.BranchID = b.BranchId 
		WHERE sb.[Status] = 'A' AND S.Status='A'
		group by s.SessionName,b.BranchName, v.VersionName

		)T
		where Institution=CASE WHEN @ClientName<>'' THEN @ClientName ELSE Institution END
END
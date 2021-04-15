IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_GetDB_SMSData]'))
BEGIN
DROP PROCEDURE  SP_GetDB_SMSData
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
	--- EXEC SP_GetDB_SMSData 'ACADEMIA','2019-07-24','2019-07-25'
CREATE PROCEDURE [dbo].[SP_GetDB_SMSData]
(
	@ClientName AS NVARCHAR(MAX),
	@FromDate nvarchar(max)=null,
	@ToDate nvarchar(max)=null
)
AS

BEGIN
SELECT *, CAST(@FromDate AS DATE) FromDate,CAST(@ToDate AS DATE) ToDate FROM
		(select 'AGHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			  WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from [aghs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [aghs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [aghs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [aghs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [aghs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'APSCL' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			  WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [apscl_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [apscl_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [apscl_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [apscl_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [apscl_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'ACADEMIA' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			  WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [academia_new_2020]..SMS_SMSSendHistroy S
		LEFT JOIN [academia_new_2020]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [academia_new_2020]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [academia_new_2020]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [academia_new_2020]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName
		
		UNION ALL
		select 'BZS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			  WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [bzs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [bzs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [bzs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [bzs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [bzs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName
		
		UNION ALL
		select 'BADCHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			  WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [badchs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [badchs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [badchs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [badchs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [badchs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName
		
		UNION ALL
		select 'BABS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			  WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [babs_new_2019]..SMS_SMSSendHistroy S
		LEFT JOIN [babs_new_2019]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [babs_new_2019]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [babs_new_2019]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [babs_new_2019]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName
		
		--UNION ALL
		--select 'BMA' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		--CASE WHEN S.CategoryId=1 THEN 'STUDENT'
		--	 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
		--	 WHEN S.CategoryId=3 THEN 'Absent'
		--	 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
		--	 WHEN S.CategoryId=5 THEN 'FEES DUE'
		--	 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
		--	 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
		--	 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
		--	 WHEN S.CategoryId=9 THEN 'Absconding SMS'
		--	 WHEN S.CategoryId=10 THEN 'Birthday SMS'
		--	 WHEN S.CategoryId=11 THEN 'Service'
		--else 'General' end Category, COUNT(HistoryId) SMSCount
		--from  [bma_new_2019]..SMS_SMSSendHistroy S
		--LEFT JOIN [bma_new_2019]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		--LEFT JOIN [bma_new_2019]..Ins_Version V ON V.VersionId=B.VersionID
		--LEFT JOIN [bma_new_2019]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		--LEFT JOIN [bma_new_2019]..Ins_Version EV ON EV.VersionId=EB.VersionID
		--where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		--group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'BGHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [bghs_new_2019]..SMS_SMSSendHistroy S
		LEFT JOIN [bghs_new_2019]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [bghs_new_2019]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [bghs_new_2019]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [bghs_new_2019]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'BCSIR' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [bcsirhs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [bcsirhs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [bcsirhs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [bcsirhs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [bcsirhs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'BPSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [bpsc_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [bpsc_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [bpsc_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [bpsc_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [bpsc_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'BKSP' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [bksppsc_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [bksppsc_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [bksppsc_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [bksppsc_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [bksppsc_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'BBHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [bbhs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [bbhs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [bbhs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [bbhs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [bbhs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'BRSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [brsc_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [brsc_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [brsc_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [brsc_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [brsc_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'BTCL' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [btclisc_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [btclisc_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [btclisc_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [btclisc_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [btclisc_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'CCPC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [ccpc_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [ccpc_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [ccpc_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [ccpc_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [ccpc_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'CGS' Institution,'English' Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [cgsd_new_2019]..SMS_SMSSendHistroy S
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId

		UNION ALL
		select 'DCGHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [dcghs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [dcghs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [dcghs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [dcghs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [dcghs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'DCSD' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [dcsd_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [dcsd_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [dcsd_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [dcsd_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [dcsd_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'EUSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [eusc_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [eusc_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [eusc_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [eusc_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [eusc_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'GFSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [gfsc_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [gfsc_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [gfsc_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [gfsc_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [gfsc_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'GVHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [gvhs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [gvhs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [gvhs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [gvhs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [gvhs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName
		
		UNION ALL
		select 'GMUB' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [gmub_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [gmub_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [gmub_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [gmub_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [gmub_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'HGHSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [hghsc_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [hghsc_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [hghsc_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [hghsc_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [hghsc_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'HPAHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [hpahs_new_2019]..SMS_SMSSendHistroy S
		LEFT JOIN [hpahs_new_2019]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [hpahs_new_2019]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [hpahs_new_2019]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [hpahs_new_2019]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName
		
		UNION ALL
		select 'IGGSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [iggsc_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [iggsc_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [iggsc_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [iggsc_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [iggsc_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'IGSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [igsc_new_2019]..SMS_SMSSendHistroy S
		LEFT JOIN [igsc_new_2019]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [igsc_new_2019]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [igsc_new_2019]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [igsc_new_2019]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName
		
		UNION ALL
		select 'KHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [khs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [khs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [khs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [khs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [khs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'KGSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [kgsc_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [kgsc_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [kgsc_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [kgsc_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [kgsc_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'KAHSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [kahsc_new_2019]..SMS_SMSSendHistroy S
		LEFT JOIN [kahsc_new_2019]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [kahsc_new_2019]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [kahsc_new_2019]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [kahsc_new_2019]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'KGSCK' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [kgsck_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [kgsck_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [kgsck_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [kgsck_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [kgsck_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'KGHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [kghs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [kghs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [kghs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [kghs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [kghs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'LGHSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [lghsc_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [lghsc_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [lghsc_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [lghsc_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [lghsc_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'MMHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [mmhs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [mmhs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [mmhs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [mmhs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [mmhs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'MHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [mhs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [mhs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [mhs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [mhs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [mhs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'MGHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [mghs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [mghs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [mghs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [mghs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [mghs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'MUBC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [mubc_new_2020]..SMS_SMSSendHistroy S
		LEFT JOIN [mubc_new_2020]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [mubc_new_2020]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [mubc_new_2020]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [mubc_new_2020]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'MGSCN' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [mgscn_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [mgscn_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [mgscn_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [mgscn_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [mgscn_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'NBPSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [nbpsc_new_2019]..SMS_SMSSendHistroy S
		LEFT JOIN [nbpsc_new_2019]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [nbpsc_new_2019]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [nbpsc_new_2019]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [nbpsc_new_2019]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'PPIMSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [ppimsc_new_2019]..SMS_SMSSendHistroy S
		LEFT JOIN [ppimsc_new_2019]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [ppimsc_new_2019]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [ppimsc_new_2019]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [ppimsc_new_2019]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'RCMS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [rcms_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [rcms_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [rcms_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [rcms_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [rcms_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'RBHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [rbhs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [rbhs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [rbhs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [rbhs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [rbhs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'RSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [rsc_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [rsc_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [rsc_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [rsc_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [rsc_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'SACHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [sachs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [sachs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [sachs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [sachs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [sachs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'SC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [sc_new_2019]..SMS_SMSSendHistroy S
		LEFT JOIN [sc_new_2019]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [sc_new_2019]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [sc_new_2019]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [sc_new_2019]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		--UNION ALL
		--select 'SBA' Institution,'English' Language,CASE WHEN CategoryId=1 THEN 'STUDENT'  ------Shahid Babul Academy
		--	 WHEN CategoryId=2 THEN 'EMPLOYEE'
		--	 WHEN CategoryId=3 THEN 'Absent'
		--	 WHEN CategoryId=4 THEN 'Period Wise Absent'
		--	 WHEN CategoryId=5 THEN 'FEES DUE'
		--	 WHEN CategoryId=6 THEN 'FEES COLLECTION'
		--	 WHEN CategoryId=7 THEN 'MAIN EXAM'
		--	 WHEN CategoryId=8 THEN 'GRAND EXAM'
		--	 WHEN CategoryId=9 THEN 'Absconding SMS'
		--	  WHEN CategoryId=10 THEN 'Birthday SMS'
		--	 WHEN CategoryId=11 THEN 'Service'
		--else 'General' end Category, COUNT(HistoryId) SMSCount
		--from  [sba_new_2018]..SMS_SMSSendHistroy
		--where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		--group by CategoryId

		UNION ALL
		select 'SBBM' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [sbbm_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [sbbm_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [sbbm_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [sbbm_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [sbbm_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		--UNION ALL
		--select 'SGC' Institution,'English' Language,CASE WHEN CategoryId=1 THEN 'STUDENT'  ------Siddheswari Girls' College
		--	 WHEN CategoryId=2 THEN 'EMPLOYEE'
		--	 WHEN CategoryId=3 THEN 'Absent'
		--	 WHEN CategoryId=4 THEN 'Period Wise Absent'
		--	 WHEN CategoryId=5 THEN 'FEES DUE'
		--	 WHEN CategoryId=6 THEN 'FEES COLLECTION'
		--	 WHEN CategoryId=7 THEN 'MAIN EXAM'
		--	 WHEN CategoryId=8 THEN 'GRAND EXAM'
		--	 WHEN CategoryId=9 THEN 'Absconding SMS'
		--	  WHEN CategoryId=10 THEN 'Birthday SMS'
		--	 WHEN CategoryId=11 THEN 'Service'
		--else 'General' end Category, COUNT(HistoryId) SMSCount
		--from  [sgc_new_2018]..SMS_SMSSendHistroy
		--where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		--group by CategoryId

		UNION ALL
		select 'SOS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [sos_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [sos_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [sos_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [sos_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [sos_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'TQEMS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [tqems_new_2019]..SMS_SMSSendHistroy S
		LEFT JOIN [tqems_new_2019]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [tqems_new_2019]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [tqems_new_2019]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [tqems_new_2019]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'TRSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [trscunique_new_2021]..SMS_SMSSendHistroy S
		LEFT JOIN [trscunique_new_2021]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [trscunique_new_2021]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [trscunique_new_2021]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [trscunique_new_2021]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'TGHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [tghs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [tghs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [tghs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [tghs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [tghs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'ULSCDU' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [ulscdu_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [ulscdu_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [ulscdu_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [ulscdu_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [ulscdu_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		--UNION ALL
		--select 'VNSC' Institution,'English' Language,CASE WHEN CategoryId=1 THEN 'STUDENT'  ------Viqarunnisa Noon School & College
		--	 WHEN CategoryId=2 THEN 'EMPLOYEE'
		--	 WHEN CategoryId=3 THEN 'Absent'
		--	 WHEN CategoryId=4 THEN 'Period Wise Absent'
		--	 WHEN CategoryId=5 THEN 'FEES DUE'
		--	 WHEN CategoryId=6 THEN 'FEES COLLECTION'
		--	 WHEN CategoryId=7 THEN 'MAIN EXAM'
		--	 WHEN CategoryId=8 THEN 'GRAND EXAM'
		--	 WHEN CategoryId=9 THEN 'Absconding SMS'
		--	  WHEN CategoryId=10 THEN 'Birthday SMS'
		--	 WHEN CategoryId=11 THEN 'Service'
		--else 'General' end Category, COUNT(HistoryId) SMSCount
		--from [vnsc_new_2020]..SMS_SMSSendHistroy
		--where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		--group by CategoryId

		UNION ALL
		select 'WHS' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [whs_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [whs_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [whs_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [whs_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [whs_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		UNION ALL
		select 'ZCPSC' Institution,ISNULL(V.VersionName,EV.VersionName) Language,
		CASE WHEN S.CategoryId=1 THEN 'STUDENT'
			 WHEN S.CategoryId=2 THEN 'EMPLOYEE'
			 WHEN S.CategoryId=3 THEN 'Absent'
			 WHEN S.CategoryId=4 THEN 'Period Wise Absent'
			 WHEN S.CategoryId=5 THEN 'FEES DUE'
			 WHEN S.CategoryId=6 THEN 'FEES COLLECTION'
			 WHEN S.CategoryId=7 THEN 'MAIN EXAM'
			 WHEN S.CategoryId=8 THEN 'GRAND EXAM'
			 WHEN S.CategoryId=9 THEN 'Absconding SMS'
			 WHEN S.CategoryId=10 THEN 'Birthday SMS'
			 WHEN S.CategoryId=11 THEN 'Service'
		else 'General' end Category, COUNT(HistoryId) SMSCount
		from  [zcpsc_new_2018]..SMS_SMSSendHistroy S
		LEFT JOIN [zcpsc_new_2018]..Student_BasicInfo B ON B.StudentIID=S.StudentIId
		LEFT JOIN [zcpsc_new_2018]..Ins_Version V ON V.VersionId=B.VersionID
		LEFT JOIN [zcpsc_new_2018]..Emp_BasicInfo EB ON EB.EmpBasicInfoID=S.EmpId
		LEFT JOIN [zcpsc_new_2018]..Ins_Version EV ON EV.VersionId=EB.VersionID
		where CAST(SendDateTime as date) BETWEEN  CAST(@FromDate AS date) AND CAST(@ToDate AS date)
		group by S.CategoryId,V.VersionName,EV.VersionName

		)T
		where Institution=CASE WHEN @ClientName<>'' THEN @ClientName ELSE Institution END
	
END

-- select * from   [apscl_new_2018]..SMS_SMSSendHistroy
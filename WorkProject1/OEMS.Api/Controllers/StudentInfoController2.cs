using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.ViewModel;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Http;
using static OEMS.Models.Constant.Enums;

namespace OEMS.Api.Controllers
{
    //[ApiAuth]
    public class StudentInfoController : ApiController
    {
        [HttpPost]
        [Route("Student/SearchVairousType/")]
        public IHttpActionResult SearchVairousType(StudentBasicInfo basicinfo)
        {
            //1 With TC, 2 By Admission, 3 Testimonial, 4 Given TC


            CommonResponse cr = new CommonResponse();

            if (basicinfo.ReportType == 1)
            {
                var result = DataAccess.Instance.StudentBasicInfo.Filter(a => a.AddmissionEntryType == "WT" && a.IsDeleted == false);


            }
            else if (basicinfo.ReportType == 2)
            {
                //var result = DataAccess.Instance.StudentBasicInfo.Filter(a => a.AddmissionEntryType == "AT" && a.IsDeleted == false && a.AdmissionDate);
            }
            else if (basicinfo.ReportType == 3)
            {
                var result = DataAccess.Instance.StudentBasicInfo.Filter(a => a.AddmissionEntryType == "WT" && a.IsDeleted == false);
            }
            else if (basicinfo.ReportType == 4)
            {

            }
            else
            {

            }

            return Json(cr);
        }

        [Route("Student/GetStudentIDbyIID/{StudentIID}")]
        public IHttpActionResult GetStudentIDbyIID(string StudentIID)
        {
            CommonResponse cr = new CommonResponse();

            var student = DataAccess.Instance.StudentBasicInfo.Filter(a => a.StudentInsID.Trim() == StudentIID.Trim() && a.IsDeleted == false).FirstOrDefault();
            if (student != null)
            {
                cr.results = student.StudentIID;
            }
            else
            {
                cr.results = 0;
            }
            return Json(cr);
        }

        [Route("Student/SearchStudent/{srhtext}")]
        [HttpGet]
        public IHttpActionResult SearchStudent(string srhtext) //This method will Search Student by Student ID , name and sms notification no.
        { 
            CommonResponse cr = new CommonResponse();
            
            cr.results = DataAccess.Instance.StudentBasicInfo.SearchStudent(srhtext).ToList();
            return Json(cr);
        }
        //remove student
        [HttpGet]
        [Route("Student/RemoveStudentProfilePhoto/{StudentSearchID}")]
        public IHttpActionResult RemoveStudentProfilePhoto(long StudentSearchID)
        {
            CommonResponse cr = new CommonResponse();
            var Student = DataAccess.Instance.StudentImage.Filter(a=>a.StudentIID== StudentSearchID).FirstOrDefault();
            Student.Photo = null;
            var IsDelete = DataAccess.Instance.StudentImage.Update(Student);
            cr.results = IsDelete;
            return Json(cr);
        }
        #region Student Basicinfo
        //Active Inactive

        [Route("StudentInfo/LockUser/")]
        [HttpPost]
        public IHttpActionResult LockUser(StudentBasicInfo Stu)
        {
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            // Filter Student by Student IID

            StudentBasicInfo Stu1 = DataAccess.Instance.StudentBasicInfo.Filter(x => x.StudentIID == Stu.StudentIID).FirstOrDefault();
            string StudentInsID = Stu1.StudentInsID;
            Stu1.Status = Stu.Status;
            DataAccess.Instance.StudentBasicInfo.Update(Stu1);
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSingleStudentSearchInfo", StudentInsID);
            cr.results = dt;
            return Json(cr);
        }

        [Route("StudentInfo/GetAllSummery/{StuIID}")]
        [HttpGet]
        public IHttpActionResult GetAllSummery(long StuIID)
        {
            CommonResponse res = new CommonResponse();
            List<StudentView> studentBasicInfo = new List<StudentView>();

            res = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("rpt_GetStudentInfoByIID", StuIID);

            if (res != null)
            {
                res.httpStatusCode = HttpStatusCode.OK;

            }
            else
            {
                res.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(res);

        }



        [Route("Student/BulkUploadStu/")]    
        [HttpPost]
        public IHttpActionResult StuBulkUpload()
        {
            CommonResponse cr = new CommonResponse();
            int rCount = 0;
            string currFilePath = string.Empty;
            string currFileExtension = string.Empty;
            var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["excel"] : null;

            string fileName = file.FileName;
            string tempPath = System.IO.Path.GetTempPath();    //Point 1 Get Temporary File Path
            fileName = System.IO.Path.GetFileName(fileName);  //Point 2 Get File Name (not including path)
            currFileExtension = System.IO.Path.GetExtension(fileName);   //Point 3 Get File Extension
            currFilePath = tempPath + fileName; // Get File Path after Uploading and Record to Former Declared Global Variable
            file.SaveAs(currFilePath);  //Upload

            string value = HttpContext.Current.Request.Form["studentFilter"] ?? "";
            if (string.IsNullOrEmpty(value))
                return BadRequest("Incorrect Format.");
            StudentFilter fil = JsonConvert.DeserializeObject<StudentFilter>(value);
            string Type = JsonConvert.DeserializeObject<string>(HttpContext.Current.Request.Form["UploadType"]) ?? "";
            if (Type == "Save")
            {
                using (var package = new ExcelPackage(file.InputStream))
                {

                    var workSheet = package.Workbook.Worksheets["BulkStudentForID"];
                    var noOfRow = workSheet.Dimension.End.Row;
                    for (int i = 2; i <= noOfRow; i++)
                    {
                        DateTime AddmissionDate = DateTime.Now;
                        string Roll = workSheet.Cells[i, 10].Value != null ? workSheet.Cells[i, 10].Value.ToString() : string.Empty;
                        try
                        {
                            AddmissionDate = workSheet.Cells[i, 11].Value != null ? Convert.ToDateTime(workSheet.Cells[i, 11].Value.ToString()) : DateTime.Now;
                        }
                        catch (Exception)
                        {

                            AddmissionDate = DateTime.Now;
                        }

                        string Name = workSheet.Cells[i, 12].Value != null ? workSheet.Cells[i, 12].Value.ToString() : string.Empty;
                        string SMS = workSheet.Cells[i, 13].Value != null ? workSheet.Cells[i, 13].Value.ToString() : string.Empty;


                        if (Name != string.Empty)
                        {
                            var para = new object[] { fil.VersionID, fil.SessionId, fil.BranchID, fil.ShiftID, fil.ClassId, fil.GroupId, fil.SectionId, fil.StudentType, 0, Convert.ToInt32(Roll), Name, AddmissionDate, SMS };
                            var res = DataAccess.Instance.CommonServices.GetBySpWithParam("StudentBulkUpload", para);

                        }

                        rCount++;
                    }

                }

                cr.message = rCount + " Students Uploaded Successfully.";
            }
            else if (Type == "Update")
            {
                rCount = 0;
                using (var package = new ExcelPackage(file.InputStream))
                {

                    var workSheet = package.Workbook.Worksheets["BulkStudentForUpdate"];
                    var noOfRow = workSheet.Dimension.End.Row;


                    for (int i = 2; i <= noOfRow; i++)
                    {
                        var _params = new object[] {

                           workSheet.Cells[i, 8].Value  , // Ins ID
                           workSheet.Cells[i, 9].Value  , // Roll
                           workSheet.Cells[i, 10].Value , // AdmissionDate
                           workSheet.Cells[i, 11].Value , // Name
                           workSheet.Cells[i, 12].Value , // SMS Noti
                           workSheet.Cells[i, 13].Value , // Gender
                           workSheet.Cells[i, 14].Value , // DOB

                           workSheet.Cells[i, 15].Value==null?"": workSheet.Cells[i, 15].Value , // Transport
                           workSheet.Cells[i, 16].Value==null? 0: workSheet.Cells[i, 16].Value , // Height
                           workSheet.Cells[i, 17].Value==null? 0: workSheet.Cells[i, 17].Value , // Weight
                           workSheet.Cells[i, 18].Value==null?"": workSheet.Cells[i, 18].Value , // F_Name
                           workSheet.Cells[i, 19].Value==null?"": workSheet.Cells[i, 19].Value , // F_Monthly_Income
                                                     
                           workSheet.Cells[i, 20].Value==null?"": workSheet.Cells[i, 20].Value , // F_OfficeAddress
                           workSheet.Cells[i, 21].Value==null?"": workSheet.Cells[i, 21].Value , // F_Mobile
                           workSheet.Cells[i, 22].Value==null?"": workSheet.Cells[i, 22].Value , // F_Email
                           workSheet.Cells[i, 23].Value==null?"": workSheet.Cells[i, 23].Value , // F_TIN_No
                           workSheet.Cells[i, 24].Value==null?"": workSheet.Cells[i, 24].Value , // F_NID
                                                      
                           workSheet.Cells[i, 25].Value==null?"": workSheet.Cells[i, 25].Value , // F_Passport
                           workSheet.Cells[i, 26].Value==null?"": workSheet.Cells[i, 26].Value , // M_Name
                           workSheet.Cells[i, 27].Value==null?"": workSheet.Cells[i, 27].Value , // M_Monthly_Income
                           workSheet.Cells[i, 28].Value==null?"": workSheet.Cells[i, 28].Value , // M_Office_Address
                           workSheet.Cells[i, 29].Value==null?"": workSheet.Cells[i, 29].Value , // M_Mobile

                           workSheet.Cells[i, 30].Value==null?"": workSheet.Cells[i, 30].Value, // M_Email
                           workSheet.Cells[i, 31].Value==null?"": workSheet.Cells[i, 31].Value , // M_TIN_No
                           workSheet.Cells[i, 32].Value==null?"": workSheet.Cells[i, 32].Value , // M_NID
                           workSheet.Cells[i, 33].Value==null?"": workSheet.Cells[i, 33].Value , // M_Passport
                           workSheet.Cells[i, 34].Value==null?"": workSheet.Cells[i, 34].Value , // L_Guardian_Name

                           workSheet.Cells[i, 35].Value==null?"": workSheet.Cells[i, 35].Value , // L_Mobile
                           workSheet.Cells[i, 36].Value==null?"": workSheet.Cells[i, 36].Value , // L_Address
                           workSheet.Cells[i, 37].Value==null?"": workSheet.Cells[i, 37].Value , // L_NID
                           workSheet.Cells[i, 38].Value==null?"": workSheet.Cells[i, 38].Value , // E_Guardian_Name
                           workSheet.Cells[i, 39].Value==null?"": workSheet.Cells[i, 39].Value , // E_Mobile

                           workSheet.Cells[i, 40].Value==null?"": workSheet.Cells[i, 40].Value , // E_Address
                           workSheet.Cells[i, 41].Value==null?"": workSheet.Cells[i, 41].Value , // E_NID
                           workSheet.Cells[i, 42].Value==null?"": workSheet.Cells[i, 42].Value , // Pre_Address
                           workSheet.Cells[i, 43].Value==null?"": workSheet.Cells[i, 43].Value , // Par_Address
                           workSheet.Cells[i, 44].Value==null?"": workSheet.Cells[i, 44].Value , // Par_Post
                           User.Identity.GetUserName()

                    };

                        //DateTime AddmissionDate = DateTime.Now;
                        //string Roll = 
                        //try
                        //{
                        //    AddmissionDate =  : DateTime.Now;
                        //}
                        //catch (Exception)
                        //{

                        //    AddmissionDate = DateTime.Now;
                        //}

                        //string Name = workSheet.Cells[i, 12].Value != null ? workSheet.Cells[i, 12].Value.ToString() : string.Empty;
                        //string SMS = workSheet.Cells[i, 13].Value != null ? workSheet.Cells[i, 13].Value.ToString() : string.Empty;


                        //if (Name != string.Empty)
                        //{
                        //    var para = new object[] { fil.VersionID, fil.SessionId, fil.BranchID, fil.ShiftID, fil.ClassId, fil.GroupId, fil.SectionId, fil.StudentType, fil.HouseId, Convert.ToInt32(Roll), Name, AddmissionDate, SMS };
                        var res = DataAccess.Instance.CommonServices.GetBySpWithParam("StudentBulkUpdate", _params);

                        // }

                        rCount++;
                    }

                }
                cr.message = rCount + " Students Updated Successfully.";
            }








            //cr.message = res ? Constant.SAVED : Constant.FAILED;

            return Json(cr);
        }

        [Route("Student/StuBulkReadExcel/")]
        [HttpPost]
        public IHttpActionResult StuBulkReadExcel()
        {
            CommonResponse cr = new CommonResponse();


            int rCount = 0;
            string currFilePath = string.Empty;
            string currFileExtension = string.Empty;
            var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["excel"] : null;

            string fileName = file.FileName;
            string tempPath = System.IO.Path.GetTempPath();    //Point 1 Get Temporary File Path
            fileName = System.IO.Path.GetFileName(fileName);  //Point 2 Get File Name (not including path)
            currFileExtension = System.IO.Path.GetExtension(fileName);   //Point 3 Get File Extension
            currFilePath = tempPath + fileName; // Get File Path after Uploading and Record to Former Declared Global Variable
            file.SaveAs(currFilePath);  //Upload

            string value = HttpContext.Current.Request.Form["studentFilter"] ?? "";
            if (string.IsNullOrEmpty(value))
                return BadRequest("Incorrect Format.");
            StudentFilter fil = JsonConvert.DeserializeObject<StudentFilter>(value);
            string Type = JsonConvert.DeserializeObject<string>(HttpContext.Current.Request.Form["UploadType"]) ?? "";
            if (Type == "Save")
            {
                using (var package = new ExcelPackage(file.InputStream))
                {

                    var workSheet = package.Workbook.Worksheets["BulkStudentForID"];
                    var noOfRow = workSheet.Dimension.End.Row;
                    List<object> results = new List<object>();
                    for (int i = 2; i <= noOfRow; i++)
                    {
                        DateTime AddmissionDate = DateTime.Now;
                        string Roll = workSheet.Cells[i, 10].Value != null ? workSheet.Cells[i, 10].Value.ToString() : string.Empty;
                        try
                        {
                            AddmissionDate = workSheet.Cells[i, 11].Value != null ? Convert.ToDateTime(workSheet.Cells[i, 11].Value.ToString()) : DateTime.Now;
                        }
                        catch (Exception)
                        {

                            AddmissionDate = DateTime.Now;
                        }

                        string Name = workSheet.Cells[i, 12].Value != null ? workSheet.Cells[i, 12].Value.ToString() : string.Empty;
                        string SMS = workSheet.Cells[i, 13].Value != null ? workSheet.Cells[i, 13].Value.ToString() : string.Empty;

                        
                        results.Add(new { Name = Name, SMS = SMS, AddmissionDate = AddmissionDate.ToShortDateString(), Roll = Roll, StudentType= "" });


                        rCount++;
                    }
                    cr.results = results;
                }
               
                cr.message = rCount + " Students Uploaded Successfully.";
            }
            

            //cr.message = res ? Constant.SAVED : Constant.FAILED;

            return Json(cr);
        }

        [Route("Student/GetBulkStudentUpdate/")]
        [HttpPost]
        public IHttpActionResult SaveBulkStudent(StudentFilter fil)
        {
            CommonResponse cr = new CommonResponse();
            DataTable dtresult = DataAccess.Instance.CommonServices.GetBySpWithParam("GetBulkStudentUpdate", new object[] { fil.VersionID, fil.SessionId, fil.BranchID, fil.ShiftID, fil.ClassId, fil.GroupId, fil.SectionId });
            if(dtresult.Rows.Count==0)
            {
                cr.message = Constant.NOT_FOUND;
                return Json(cr);
            }
            List<VMBulkStudentUpdate> lstBulk = APIUitility.ConvertDataTable<VMBulkStudentUpdate>(dtresult);
            cr.results = lstBulk;
            cr.message = Constant.SUCCESS;
            return Json(cr);
        }
        [Route("Student/SaveBulkStudentUpdate/")]
        [HttpPost]
        public IHttpActionResult SaveBulkStudentUpdate(List<VMBulkStudentUpdate> _student)

        {
            CommonResponse cr = new CommonResponse();
            if (!_student.Any())
                return BadRequest(Constant.INVAILD_DATA);
            foreach (var item in _student)
            {

                Dictionary<string, string> colms = new Dictionary<string, string>();
                colms.Add("Religion", "@Religion");
                colms.Add("BloodGroup", "@BloodGroup");
                colms.Add("Nationality", "@Nationality");
                colms.Add("Quota", "@Quota");
                colms.Add("UpdateBy", "@UpdateBy");
                colms.Add("UpdateDate", "@UpdateDate");


                Dictionary<string, string> WhereClause = new Dictionary<string, string>();
                WhereClause.Add("StudentIID", "@StudentIID");

                List<SqlParameter> param = new List<SqlParameter>
               {
                   new SqlParameter("@Religion", item.Religion)
                  ,new SqlParameter("@BloodGroup", item.BloodGroup)
                  ,new SqlParameter("@Nationality", item.Nationality)
                  ,new SqlParameter("@Quota", item.Quota)
                  ,new SqlParameter("@UpdateBy", User.Identity.GetUserName())
                  ,new SqlParameter("@UpdateDate", DateTime.Now)
                  ,new SqlParameter("@StudentIID", item.StudentIID)
               };

                DataAccess.Instance.CommonServices.UpdateBySql("Student_BasicInfo", colms, WhereClause,param);

                var GurdianInfo = DataAccess.Instance.aStudentGuardianService.Filter(e => e.StudentIID == item.StudentIID).FirstOrDefault();
                if (GurdianInfo != null)
                {
                    colms = new Dictionary<string, string>();
                    colms.Add("F_Qualification", "@F_Qualification");
                    colms.Add("F_Profession", "@F_Profession");
                    colms.Add("M_Qualification", "@M_Qualification");
                    colms.Add("M_Profession", "@M_Profession");
                    colms.Add("LG_Relation", "@LG_Relation");
                    colms.Add("E_Relation", "@E_Relation");
                    colms.Add("UpdateBy", "@UpdateBy");
                    colms.Add("UpdateDate", "@UpdateDate");


                    WhereClause = new Dictionary<string, string>();
                    WhereClause.Add("StudentIID", "@StudentIID");

                        param = new List<SqlParameter>
                   {
                       new SqlParameter("@F_Qualification", item.F_Qualification)
                      ,new SqlParameter("@F_Profession", item.F_Profession)
                      ,new SqlParameter("@M_Qualification", item.M_Qualification)
                      ,new SqlParameter("@M_Profession", item.M_Profession)

                      ,new SqlParameter("@LG_Relation", item.LG_Relation)
                      ,new SqlParameter("@E_Relation", item.E_Relation)
                      ,new SqlParameter("@UpdateBy", User.Identity.GetUserName())
                      ,new SqlParameter("@UpdateDate", DateTime.Now)
                      ,new SqlParameter("@StudentIID", item.StudentIID)
                   };

                    DataAccess.Instance.CommonServices.UpdateBySql("Student_GuardianInfo", colms, WhereClause, param);
                }
                else
                {
                    StudentGuardianInfo gurd = new StudentGuardianInfo
                    {
                        StudentIID = item.StudentIID,
                        F_Qualification = item.F_Qualification,
                        F_Profession = item.F_Profession,
                        M_Qualification = item.M_Qualification,
                        M_Profession = item.M_Profession,
                        LG_Relation = item.LG_Relation,
                        E_Relation = item.E_Relation,
                        AddBy = User.Identity.GetUserName(),
                        AddDate = DateTime.Now
                    };
                    DataAccess.Instance.aStudentGuardianService.Add(gurd);
                }
                var ContactInfo = DataAccess.Instance.StudentContactInfo.Filter(e => e.StudentIID == item.StudentIID).FirstOrDefault();
                if (ContactInfo != null)
                {
                    colms = new Dictionary<string, string>();
                    colms.Add("Pre_PSId", "@Pre_PSId");
                    colms.Add("Pre_DisId", "@Pre_DisId");
                    colms.Add("Pre_PostOffice", "@Pre_PostOffice");
                    colms.Add("Par_PSId", "@Par_PSId");
                    colms.Add("Par_DisId", "@Par_DisId");
                    colms.Add("Par_PostOffice", "@Par_PostOffice");
                    colms.Add("UpdateBy", "@UpdateBy");
                    colms.Add("UpdateDate", "@UpdateDate");


                    WhereClause = new Dictionary<string, string>();
                    WhereClause.Add("StudentIID", "@StudentIID");

                    param = new List<SqlParameter>
               {
                   new SqlParameter("@Pre_PSId", item.Pre_PSId)
                  ,new SqlParameter("@Pre_DisId", item.Pre_DisId)
                  ,new SqlParameter("@Pre_PostOffice", item.Pre_PostOffice)
                  ,new SqlParameter("@Par_PSId", item.Par_PSId)
                  ,new SqlParameter("@Par_DisId", item.Par_DisId)
                  ,new SqlParameter("@Par_PostOffice", item.Par_PostOffice)

                  ,new SqlParameter("@UpdateBy", User.Identity.GetUserName())
                  ,new SqlParameter("@UpdateDate", DateTime.Now)
                  ,new SqlParameter("@StudentIID", item.StudentIID)
               };

                    DataAccess.Instance.CommonServices.UpdateBySql("Student_ContactInfo", colms, WhereClause, param);
                }
                else
                {
                    StudentContactInfo cont = new StudentContactInfo
                    {
                        StudentIID = item.StudentIID,
                        Pre_PSId = item.Pre_PSId,
                        Pre_DisId = item.Pre_DisId,
                        Pre_PostOffice = item.Pre_PostOffice,
                        Par_PSId = item.Par_PSId,
                        Par_DisId = item.Par_DisId,
                        Par_PostOffice = item.Par_PostOffice,
                        AddBy = User.Identity.GetUserName(),
                        AddDate = DateTime.Now
                    };
                    DataAccess.Instance.StudentContactInfo.Add(cont);
                }

            }
            return Json(cr);
        }

        [Route("Student/SaveBulkStudent/")]
        [HttpPost]
        public IHttpActionResult SaveBulkStudent()
        {
            CommonResponse cr = new CommonResponse();


            int rCount = 0;
            string currFilePath = string.Empty;
            string currFileExtension = string.Empty;
          

            string value = HttpContext.Current.Request.Form["studentFilter"] ?? "";
            if (string.IsNullOrEmpty(value))
                return BadRequest("Incorrect Format.");
            StudentFilter fil = JsonConvert.DeserializeObject<StudentFilter>(value);
            string _ListStudent = HttpContext.Current.Request.Form["ListStudent"] ?? "";
            if (string.IsNullOrEmpty(_ListStudent))
                return BadRequest("Invaild Data !!!");

            var _lstStudent = JsonConvert.DeserializeAnonymousType(_ListStudent, new[] { new { Name = "", SMS = "", AddmissionDate = "", Roll = "", StudentType = "" } }).ToList();

            foreach (var item in _lstStudent)
            {
                var para = new object[] { fil.VersionID, fil.SessionId, fil.BranchID, fil.ShiftID, fil.ClassId, fil.GroupId, fil.SectionId, item.StudentType, 0, item.Roll, item.Name, item.AddmissionDate, item.SMS };
                var res = DataAccess.Instance.CommonServices.GetBySpWithParam("StudentBulkUpload", para);
                rCount++;
            }

            cr.message = rCount + " Students Uploaded Successfully.";
            return Json(cr);
        }

        [Route("Student/BulkImagesUpdate/")]    ///  StudentAcademicInfo Add With Image 
        [HttpPost]
        public IHttpActionResult BulkImagesUpdate()
        {
            CommonResponse cr = new CommonResponse();
            int rCount = 0;
            string currFilePath = string.Empty;
            string currFileExtension = string.Empty;
            var dd = HttpContext.Current.Request.Form["imgs"] ?? "";
            List<HttpPostedFile> imagesList = new List<HttpPostedFile>();
            for (int i = 0; i < HttpContext.Current.Request.Files.AllKeys.Count(); i++)
            {
                var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["imgs_" + i] : null;
                imagesList.Add(file);
            }
            if (!imagesList.Any())
            {
                return BadRequest("No Images Selected!");
            }
            string Type = JsonConvert.DeserializeObject<string>(HttpContext.Current.Request.Form["ImageUploadType"]) ?? "";
            if (Type == "Student")
            {
                rCount = 0;
                foreach (var file in imagesList)
                {
                    if (file != null)
                    {
                        string InsId = Path.GetFileNameWithoutExtension(file.FileName);
                        StudentView Stu = DataAccess.Instance.StudentBasicInfo.GetBasicInfo(InsId);
                        if (Stu == null)
                            continue;

                        if (!DataAccess.Instance.StudentImage.Filter(e => e.StudentIID == Stu.StudentIID).Any())
                        {
                            StudentImage studentImg = new StudentImage();
                            studentImg.SetDate();
                            studentImg.StudentIID = Convert.ToInt32(Stu.StudentIID);
                            studentImg.IsDeleted = false;
                            studentImg.Photo = GetImageByte(file.InputStream); ;
                            studentImg.ImageName = file.FileName;
                            studentImg.Remarks = "";
                            studentImg.Status = "A";
                            bool imageSaved = DataAccess.Instance.StudentImage.Add(studentImg);
                            if (imageSaved)
                            {
                                rCount++;
                            }
                        }
                        else
                        {

                            Byte[] data = GetImageByte(file.InputStream);

                            Dictionary<string, string> colms = new Dictionary<string, string>();
                            colms.Add("Photo", "@Photo");
                            colms.Add("ImageName", "@ImageName");
                            colms.Add("UpdateBy", "@UpdateBy");
                            colms.Add("UpdateDate", "@UpdateDate");

                            Dictionary<string, string> WhereClause = new Dictionary<string, string>();
                            WhereClause.Add("StudentIID", "@StudentIID");

                            SqlParameter[] param = new SqlParameter[5];
                            param[0] = new SqlParameter("@StudentIID", Stu.StudentIID);
                            param[1] = new SqlParameter("@Photo", data);
                            param[2] = new SqlParameter("@ImageName", file.FileName);
                            param[3] = new SqlParameter("@UpdateBy", User.Identity.GetUserName());
                            param[4] = new SqlParameter("@UpdateDate", DateTime.Now);

                            if (DataAccess.Instance.CommonServices.UpdateBySql("Student_Image", colms, WhereClause, param))
                            {
                                rCount++;
                            }

                        }

                    }
                }

            }
            else   /// For Father
            {
                rCount = 0;
                foreach (var file in imagesList)
                {


                    if (file != null)
                    {
                        string InsId = Path.GetFileNameWithoutExtension(file.FileName);

                        StudentView Stu = DataAccess.Instance.StudentBasicInfo.GetBasicInfo(InsId);
                        if (Stu == null)
                            continue;

                        if (!DataAccess.Instance.aStudentGuardianService.Filter(e => e.StudentIID == Stu.StudentIID).Any())
                        {
                            StudentGuardianInfo GImg = new StudentGuardianInfo();
                            GImg.SetDate();
                            GImg.StudentIID = Convert.ToInt32(Stu.StudentIID);
                            if (Type == "Father")
                                GImg.F_GuardianImage = GetImageByte(file.InputStream);
                            else if (Type == "Mother")
                                GImg.M_GuardianImage = GetImageByte(file.InputStream);
                            else if (Type == "LG")
                                GImg.LG_GuardianImage = GetImageByte(file.InputStream);


                            GImg.IsDeleted = false;
                            GImg.Remarks = "";
                            GImg.Status = "A";
                            bool imageSaved = DataAccess.Instance.aStudentGuardianService.Add(GImg);
                            if (imageSaved)
                            {
                                rCount++;

                            }
                        }
                        else
                        {




                            Image bm = Image.FromStream(file.InputStream);
                            Bitmap result = new Bitmap(100, 100);
                            using (Graphics g = Graphics.FromImage((Image)result))
                                g.DrawImage(bm, 0, 0, 100, 100);

                            Byte[] data;

                            using (var memoryStream = new MemoryStream())
                            {
                                result.Save(memoryStream, ImageFormat.Bmp);

                                data = memoryStream.ToArray();

                                Dictionary<string, string> colms = new Dictionary<string, string>();
                                if (Type == "Father")
                                    colms.Add("F_GuardianImage", "@Photo");
                                else if (Type == "Mother")
                                    colms.Add("M_GuardianImage", "@Photo");
                                else if (Type == "LG")
                                    colms.Add("LG_GuardianImage", "@Photo");


                                colms.Add("UpdateBy", "@UpdateBy");
                                colms.Add("UpdateDate", "@UpdateDate");

                                Dictionary<string, string> WhereClause = new Dictionary<string, string>();
                                WhereClause.Add("StudentIID", "@StudentIID");

                                SqlParameter[] param = new SqlParameter[4];
                                param[0] = new SqlParameter("@StudentIID", Stu.StudentIID);
                                param[1] = new SqlParameter("@Photo", data);
                                param[2] = new SqlParameter("@UpdateBy", User.Identity.GetUserName());
                                param[3] = new SqlParameter("@UpdateDate", DateTime.Now);



                                if (DataAccess.Instance.CommonServices.UpdateBySql("Student_GuardianInfo", colms, WhereClause, param))
                                {
                                    rCount++;
                                }
                            }

                        }

                    }
                }

            }

            cr.message = rCount + " Students Uploaded Successfully.";


            return Json(cr);
        }

        [Route("Student/AddStudent/")]    ///  Student Add With Image 
        [HttpPost]
        public IHttpActionResult AddStudent()
        {
            var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["Img"] : null;

            string value = HttpContext.Current.Request.Form["studentBasicInfo"] ?? "";

            if (string.IsNullOrEmpty(value))
                return BadRequest("Student info is incorrect.");
            StudentBasicInfo studentBasicInfo = JsonConvert.DeserializeObject<StudentBasicInfo>(value);

            if (string.IsNullOrEmpty(studentBasicInfo.StudentInsID))
                return BadRequest("Student Institute Id have been not supplied");   // check student ID
            if (studentBasicInfo.AdmissionDate.ToString() == "1/1/0001 12:00:00 AM")
                return BadRequest("Student Admission Date have been not supplied");  // check admission date
            if (studentBasicInfo.DateOfBirth.ToString() == "1/1/0001 12:00:00 AM")
                return BadRequest("Student Date of Birth has been not supplied");  // check date of birth

            CommonResponse cr = new CommonResponse();
            studentBasicInfo.IsDeleted = false;
            studentBasicInfo.AddBy = User.Identity.GetUserId();
            studentBasicInfo.SetDate();
            studentBasicInfo.Status = "A";
            var res = DataAccess.Instance.StudentBasicInfo.Add(studentBasicInfo);

            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            bool imageSaved = false;

            if (res)
            {
                cr.returnvalue = DataAccess.Instance.StudentBasicInfo.SingleOrDefault(e => e.StudentInsID == studentBasicInfo.StudentInsID).StudentInsID.ToString();
                if (file != null)
                {
                    StudentImage studentImg = new StudentImage();
                    studentImg.SetDate();
                    studentImg.StudentIID = Convert.ToInt32(cr.returnvalue);
                    Image bm = Image.FromStream(file.InputStream);
                    Bitmap result = new Bitmap(100, 100);
                    using (Graphics g = Graphics.FromImage((Image)result))
                        g.DrawImage(bm, 0, 0, 100, 100);

                    Byte[] data;

                    using (var memoryStream = new MemoryStream())
                    {
                        result.Save(memoryStream, ImageFormat.Bmp);

                        data = memoryStream.ToArray();
                    }

                    studentImg.IsDeleted = false;
                    studentImg.Photo = data;
                    studentImg.ImageName = file.FileName;
                    studentImg.Remarks = studentBasicInfo.Remarks;
                    studentImg.Status = "A";
                    imageSaved = DataAccess.Instance.StudentImage.Add(studentImg);
                    if (!imageSaved)
                    {
                        cr.message = res ? Constant.SAVED : "Student Image Not Saved";
                        return Json(cr);

                    }

                }
            }
            cr.message = res ? Constant.SAVED : "Failed! Something is worng please check and try again";
            return Json(cr);
        }
        [Route("Student/AddStudent_old/")]
        [HttpPost]
        public IHttpActionResult AddStudent_old(StudentBasicInfo studentBasicInfo)
        {
            CommonResponse cr = new CommonResponse();
            StudentBasicInfo oStudentBasicInfo = new StudentBasicInfo();
            oStudentBasicInfo.StudentInsID = studentBasicInfo.StudentInsID;
            oStudentBasicInfo.FullName = studentBasicInfo.FullName;
            oStudentBasicInfo.NameBangla = studentBasicInfo.NameBangla;
            oStudentBasicInfo.FatherName = studentBasicInfo.FatherName;
            oStudentBasicInfo.MotherName = studentBasicInfo.MotherName;
            oStudentBasicInfo.DateOfBirth = studentBasicInfo.DateOfBirth;
            oStudentBasicInfo.Age = studentBasicInfo.Age;
            oStudentBasicInfo.Gender = studentBasicInfo.Gender;
            oStudentBasicInfo.Nationality = studentBasicInfo.Nationality;
            oStudentBasicInfo.Religion = studentBasicInfo.Religion;
            oStudentBasicInfo.BloodGroup = studentBasicInfo.BloodGroup;
            oStudentBasicInfo.IsPhysicalDrawback = studentBasicInfo.IsPhysicalDrawback;
            oStudentBasicInfo.TransportFacility = studentBasicInfo.TransportFacility;
            oStudentBasicInfo.RegularMedicineInstruction = studentBasicInfo.RegularMedicineInstruction;
            oStudentBasicInfo.Height = studentBasicInfo.Height;
            oStudentBasicInfo.Weight = studentBasicInfo.Weight;
            oStudentBasicInfo.NoOfChildren = studentBasicInfo.NoOfChildren;
            oStudentBasicInfo.StudentPositionInChildren = studentBasicInfo.StudentPositionInChildren;
            oStudentBasicInfo.CurrentResidenceType = studentBasicInfo.CurrentResidenceType;
            oStudentBasicInfo.PreInsInfoName = studentBasicInfo.PreInsInfoName;
            oStudentBasicInfo.PreInsInfoClass = studentBasicInfo.PreInsInfoClass;
            oStudentBasicInfo.PreInsInfoSection = studentBasicInfo.PreInsInfoSection;
            oStudentBasicInfo.PreInsInfoGroup = studentBasicInfo.PreInsInfoGroup;
            oStudentBasicInfo.PreInsInfoSession = studentBasicInfo.PreInsInfoSession;
            oStudentBasicInfo.PreInsInfoVersion = studentBasicInfo.PreInsInfoVersion;
            oStudentBasicInfo.PreInsInfoRollNo = studentBasicInfo.PreInsInfoRollNo;
            oStudentBasicInfo.PreInsInfoGPAResult = studentBasicInfo.PreInsInfoGPAResult;
            oStudentBasicInfo.PreInsInfoTCNo = studentBasicInfo.PreInsInfoTCNo;
            oStudentBasicInfo.PreInsInfoDate = studentBasicInfo.PreInsInfoDate;
            oStudentBasicInfo.IsDeleted = false;
            oStudentBasicInfo.AddBy = User.Identity.GetUserId();
            oStudentBasicInfo.SetDate();
            oStudentBasicInfo.Remarks = studentBasicInfo.Remarks;
            oStudentBasicInfo.Status = "A";

            oStudentBasicInfo.VersionID = studentBasicInfo.VersionID;
            oStudentBasicInfo.SessionId = studentBasicInfo.SessionId;
            oStudentBasicInfo.BranchID = studentBasicInfo.BranchID;
            oStudentBasicInfo.ShiftID = studentBasicInfo.ShiftID;
            oStudentBasicInfo.ClassId = studentBasicInfo.ClassId;
            oStudentBasicInfo.GroupId = studentBasicInfo.GroupId;
            oStudentBasicInfo.SectionId = studentBasicInfo.SectionId;
            oStudentBasicInfo.RollNo = studentBasicInfo.RollNo;
            oStudentBasicInfo.FirstAdmittedinClass = studentBasicInfo.FirstAdmittedinClass;
            oStudentBasicInfo.FirstAdmittedInMonth = studentBasicInfo.FirstAdmittedInMonth;
            oStudentBasicInfo.FirstAdmittedInYear = studentBasicInfo.FirstAdmittedInYear;
            oStudentBasicInfo.StudentTypeID = studentBasicInfo.StudentTypeID;
            oStudentBasicInfo.HouseID = studentBasicInfo.HouseID;


            var res = DataAccess.Instance.StudentBasicInfo.Add(oStudentBasicInfo);

            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.returnvalue = DataAccess.Instance.StudentBasicInfo.SingleOrDefault(e => e.StudentInsID == oStudentBasicInfo.StudentInsID).StudentIID.ToString();
            cr.message = res ? Constant.SAVED : Constant.FAILED;

            return Json(cr);
        }


        [Route("Student/Search/")]
        [HttpPost]
        public IHttpActionResult SearchStudent(StudentsFilter f)
        {                   
            //p1 search student by various filter
            CommonResponse cr = new CommonResponse();
            f.IsDeleted = false;
            // DataTable dt = new System.Data.DataTable();

            /// Create SQL Parameter for query , field value value will be 0 if no need to query on this
            //  var param = new object[] { f.Ins_ID, f.Version, f.Session, f.Branch, f.Shift, f.Class, f.Group, f.Section, f.StuType, f.House, f.RollNo };

            if (f.StudentInsID!=null)
            {
                var dt = DataAccess.Instance.StudentBasicInfo.Filter(s => s.StudentInsID == (f.StudentInsID) || s.SMSNotificationNo == (f.StudentInsID) || s.RollNo == (f.StudentInsID) || s.FullName.Contains(f.StudentInsID)).ToList();
                if (dt.Count == 0)
                {
                    cr.message = "No Data Found";
                    cr.httpStatusCode = HttpStatusCode.OK;
                }
                else
                {
                    cr.results = dt;
                    cr.message = dt.Count + " Data found";
                    cr.httpStatusCode = HttpStatusCode.OK;
                }
            }
            else
            {
                string whereClause = CommunicationService.GetWhereClause(f).Trim().Trim('~').Replace("~", " AND ");
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoByFilter", whereClause);
                if (dt.Rows.Count == 0)
                {
                    cr.message = "No Data Found";
                    cr.httpStatusCode = HttpStatusCode.OK;
                }
                else
                {
                    cr.results = dt;
                    cr.message = dt.Rows.Count + " Data found";
                    cr.httpStatusCode = HttpStatusCode.OK;
                }
            }

            if (cr.httpStatusCode == HttpStatusCode.OK)
                return Json(cr);
            return BadRequest(Constant.INVAILD_DATA);
        }//
        [Route("StudentInfo/GetStudents/{StudentInsID}/{VersionId}/{SessionId}/{BranchId}/{ShiftId}/{ClassId}/{GroupId}/{SectionId}/{HouseID}/{StudentTypeID}")]
        [HttpGet]
        public IHttpActionResult GetStudents(string StudentInsID, int VersionId, int SessionId, int BranchId, int ShiftId, int ClassId, int GroupId, int SectionId, int HouseID, int StudentTypeID)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (string.IsNullOrEmpty(StudentInsID) || StudentInsID == "undefined" || StudentInsID == "null")//point 1 : Chack student id is null or empt or undefin.
                {
                    var dt = DataAccess.Instance.StudentBasicInfo.Filter(s => s.VersionID == VersionId && s.SessionId == SessionId && s.BranchID == BranchId && s.ShiftID == ShiftId && s.ClassId == ClassId && s.GroupId == GroupId && s.SectionId == SectionId && s.StudentTypeID==StudentTypeID && s.HouseID==HouseID);
                    cr.results = dt;
                    cr.message = dt.Count() > 0 ? dt.Count().ToString() + " Data Found" : "Data Not Found";
                    cr.httpStatusCode = dt.Count() > 0 ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                }
                else
                {
                    var dt = DataAccess.Instance.StudentBasicInfo.Filter(s =>s.StudentInsID==(StudentInsID) || s.SMSNotificationNo==(StudentInsID) ||s.RollNo==(StudentInsID) || s.FullName.Contains(StudentInsID));
                    cr.results = dt;
                    cr.message = dt.Count() > 0 ? dt.Count().ToString() + " Data Found" : "Data Not Found";
                    cr.httpStatusCode = dt.Count() > 0 ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                }
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("Student/SearchMainExam/")]
        [HttpPost]
        public IHttpActionResult SearchStudenForMainExamt(StudentFilter f)
        {
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            /// Create SQL Parameter for query , field value  will be 0 if no need to query on this
            var param = new object[] { f.VersionID, f.SessionId, f.BranchID, f.ShiftID, f.ClassId, f.GroupId, f.SectionId };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForResult", param);
            if (dt.Rows.Count == 0)
            {
                cr.message = "No Data Found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            else
            {
                cr.results = dt;
                cr.message = dt.Rows.Count + " Data found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            if (cr.httpStatusCode == HttpStatusCode.OK)
                return Json(cr);
            return BadRequest(Constant.INVAILD_DATA);
        }
        [Route("Student/SearchStudentForGrandResult/")]
        [HttpPost]
        public IHttpActionResult SearchStudentForGrandResult(StudentFilter f)
        {
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            /// Create SQL Parameter for query , field value value will be 0 if no need to query on this
            var param = new object[] { f.VersionID, f.SessionId, f.BranchID, f.ShiftID, f.ClassId, f.GroupId, f.SectionId };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForResult", param);
            if (dt.Rows.Count == 0)
            {
                cr.message = "No Data Found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            else
            {
                cr.results = dt;
                cr.message = dt.Rows.Count + " Data found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            if (cr.httpStatusCode == HttpStatusCode.OK)
                return Json(cr);
            return BadRequest(Constant.INVAILD_DATA);
        }
        [Route("Student/GetStudentByID/{id}")]
        [HttpGet]
        public IHttpActionResult GetStudentByID(int id)
        {
            CommonResponse res = new CommonResponse();
            StudentBasicInfo studentBasicInfo = new StudentBasicInfo();
            studentBasicInfo = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentIID == id && e.IsDeleted == false).FirstOrDefault();
            //studentBasicInfo = DataAccess.Instance.StudentBasicInfo.Get(id);
            var photo = DataAccess.Instance.StudentImage.Filter(e => e.StudentIID == id).FirstOrDefault();
            if (photo!=null && photo.Photo != null)
            {
                studentBasicInfo.Photo = Convert.ToBase64String(photo.Photo);
            }



            res.results = studentBasicInfo;
            res.httpStatusCode = HttpStatusCode.OK;
            return Json(res);

        }

        [Route("Student/GetStudentByInsID/{id}")]
        [HttpGet]
        public IHttpActionResult GetStudentByInsID(string id)
        {
            CommonResponse res = new CommonResponse();
            List<StudentBasicInfo> studentBasicInfo = new List<StudentBasicInfo>(); // Search Student by StudentInsID
            studentBasicInfo = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentInsID == id && e.IsDeleted == false).ToList();
            res.results = studentBasicInfo;
            res.httpStatusCode = HttpStatusCode.OK;
            return Json(res);

        }

        [Route("Student/CheckStudent/{id}")]
        [HttpGet]
        public IHttpActionResult CheckStudent(string id)
        {
            CommonResponse cr = new CommonResponse();
            List<StudentBasicInfo> studentBasicInfo = new List<StudentBasicInfo>();
            studentBasicInfo = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentInsID == id).ToList(); // Check Student By StudentInsID
            if (studentBasicInfo.Any())
            {
                cr.results = true;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.SAVED;
                return Json(cr);
            }
            else
            {
                cr.results = false;
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = Constant.FAILED;
                return Json(cr);

            }

        }

        [Route("Student/GetStudentByRoll/{versionId}/{sessionId}/{branchId}/{shiftId}/{classId}/{groupId}/{sectionId}/{roll}")]
        [HttpGet]
        public IHttpActionResult GetStudentByRoll(int versionId, int sessionId, int branchId, int shiftId, int classId, int groupId, int sectionId, int roll)
        {
            CommonResponse res = new CommonResponse();
            List<StudentBasicInfo> studentBasicInfo = new List<StudentBasicInfo>();
            // Student Filter by ersionId, sessionId, branchId, shiftId, classId, groupId, sectionId, roll
            studentBasicInfo = DataAccess.Instance.StudentBasicInfo.Filter(e => e.RollNo == roll.ToString() && e.IsDeleted == false)
                .Where(x => x.VersionID == versionId && x.SessionId == sessionId && x.BranchID == branchId && x.ShiftID == shiftId && x.ClassId == classId && x.GroupId == groupId && x.SectionId == sectionId).ToList();

            res.results = studentBasicInfo;
            res.httpStatusCode = HttpStatusCode.OK;
            return Json(res);

        }
        [Route("StudentInfo/GetStudentsApproveTC/{StudentInsID}/{VersionId}/{SessionId}/{BranchId}/{ShiftId}/{ClassId}/{GroupId}/{SectionId}/{HouseID}/{StudentTypeID}")]
        [HttpGet]
        public IHttpActionResult GetStudentsApproveTC(string StudentInsID, int VersionId, int SessionId, int BranchId, int ShiftId, int ClassId, int GroupId, int SectionId, int HouseID, int StudentTypeID)
        {
            CommonResponse cr = new CommonResponse();
            try
            {

                if (string.IsNullOrEmpty(StudentInsID) || StudentInsID == "undefined" || StudentInsID == "null")//point 1 : Chack student id is null or empt or undefin.
                {
                    var dt = DataAccess.Instance.StudentBasicInfo.Filter(s => s.VersionID == VersionId && s.SessionId == SessionId && s.BranchID == BranchId && s.ShiftID == ShiftId && s.ClassId == ClassId && s.GroupId == GroupId && s.SectionId == SectionId && s.HouseID == HouseID && s.StudentTypeID == StudentTypeID && (s.TCStatus == TCStatues.A.ToString() || s.TCStatus == TCStatues.P.ToString()));
                    cr.results = dt;
                    cr.message = dt.Count() > 0 ? dt.Count().ToString() + " Data Found" : "Data Not Found";
                    cr.httpStatusCode = dt.Count() > 0 ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                }
                else
                {
                    var dt = DataAccess.Instance.StudentBasicInfo.Filter(s => (s.StudentInsID == (StudentInsID) || s.SMSNotificationNo == (StudentInsID) || s.RollNo == (StudentInsID) || s.FullName.Contains(StudentInsID))  && (s.TCStatus == TCStatues.A.ToString() || s.TCStatus == TCStatues.P.ToString()));

                   // var dt = DataAccess.Instance.StudentBasicInfo.Filter(s => s.StudentInsID == StudentInsID && (s.TCStatus == TCStatues.A.ToString() || s.TCStatus == TCStatues.P.ToString()));
                    cr.results = dt;
                    cr.message = dt.Count() > 0 ? dt.Count().ToString() + " Data Found" : "Data Not Found";
                    cr.httpStatusCode = dt.Count() > 0 ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                }
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Student/UpdateStudentBasicInfo/")]
        [HttpPost]
        public IHttpActionResult UpdateStudentBasicInfo() // Update Student Basic with image
        {
            var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["Img"] : null;

            string value = HttpContext.Current.Request.Form["studentBasicInfo"] ?? ""; // Get form data
            if (string.IsNullOrEmpty(value))
                return BadRequest("Student info is incorrect.");
            StudentBasicInfo studentBasicInfo = JsonConvert.DeserializeObject<StudentBasicInfo>(value); // DeSerialize form data
            CommonResponse cr = new CommonResponse();
            studentBasicInfo.UpdateBy = User.Identity.GetUserId();
            studentBasicInfo.UpdateDate = DateTime.UtcNow.AddHours(6);
            var res = DataAccess.Instance.StudentBasicInfo.Update(studentBasicInfo);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            if (!res)
            {
                return Json(cr);
            }
            else
            {
                bool imageSaved = false;

                if (file != null)
                {
                    StudentImage studentImg2 = new StudentImage();
                var    studentImg = DataAccess.Instance.StudentImage.Filter(e => e.StudentIID == studentBasicInfo.StudentIID).SingleOrDefault();

                    if (studentImg!=null)
                    {
                       
                        // filter student image by StudentIID for update
                        studentImg.SetDate();
                        Image bm = Image.FromStream(file.InputStream);
                        Bitmap result = new Bitmap(100, 100);
                        using (Graphics g = Graphics.FromImage((Image)result))
                            g.DrawImage(bm, 0, 0, 100, 100);

                        Byte[] data;

                        using (var memoryStream = new MemoryStream())
                        {
                            result.Save(memoryStream, ImageFormat.Bmp);

                            data = memoryStream.ToArray();
                        }


                        studentImg.Photo = data;
                        studentImg.ImageName = file.FileName;
                        imageSaved = DataAccess.Instance.StudentImage.Update(studentImg);
                    }
                    else
                    {
                       
                        studentImg2.SetDate();
                        studentImg2.StudentIID = Convert.ToInt32(cr.returnvalue);
                        Image bm = Image.FromStream(file.InputStream);
                        Bitmap result = new Bitmap(100, 100);
                        using (Graphics g = Graphics.FromImage((Image)result))
                            g.DrawImage(bm, 0, 0, 100, 100);

                        Byte[] data;

                        using (var memoryStream = new MemoryStream())
                        {
                            result.Save(memoryStream, ImageFormat.Bmp);

                            data = memoryStream.ToArray();
                        }
                        studentImg2.StudentIID = studentBasicInfo.StudentIID;
                        studentImg2.IsDeleted = false;
                        studentImg2.Photo = data;
                        studentImg2.ImageName = file.FileName;
                        studentImg2.Remarks = studentBasicInfo.Remarks;
                        studentImg2.Status = "A";
                        imageSaved = DataAccess.Instance.StudentImage.Add(studentImg2);
                    }

                    if (!imageSaved)
                    {
                        cr.message = res ? Constant.SAVED : "Student Image Not Saved";
                        return Json(cr);

                    }


                }
            }

            return Json(cr);
        }

        [Route("Student/DeleteStudentBasicInfo/{StudentIID}")] // Delete Student by StudentIID
        [HttpDelete]
        public IHttpActionResult DeleteStudentBasicInfo(long StudentIID)
        {
            CommonResponse cr = new CommonResponse();
            StudentBasicInfo oStudentBasicInfo = new StudentBasicInfo();
            oStudentBasicInfo = DataAccess.Instance.StudentBasicInfo.Filter(a=>a.StudentIID== StudentIID).FirstOrDefault();
            oStudentBasicInfo.UpdateBy = User.Identity.GetUserId();
            oStudentBasicInfo.UpdateDate = DateTime.UtcNow.AddHours(6);
            oStudentBasicInfo.IsDeleted = true;
            var res = DataAccess.Instance.StudentBasicInfo.Update(oStudentBasicInfo);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }

        #endregion Student Basicinfo 

        #region ContactInfo

        [Route("Student/AddStudentContact/")]
        [HttpPost]
        public IHttpActionResult AddStudentContactInfo(StudentContactInfo studentContactInfo)
        { // Add Student Contact 
            CommonResponse cr = new CommonResponse();

            if (DataAccess.Instance.StudentBasicInfo.Get(studentContactInfo.StudentIID) == null)
            { // Check Student IID null
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.results = "Student not found";
                return Json(cr);
            }
            var err = studentContactInfo.Validate(); // New Implement for  Entity Validation
            bool checkSC = DataAccess.Instance.StudentContactInfo.Filter(e => e.StudentIID == studentContactInfo.StudentIID).Any() ? true : false;
            if (checkSC)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = "Student " + " address already exists";
                return Json(cr);
            }
            studentContactInfo.IsDeleted = false;
            studentContactInfo.AddBy = User.Identity.GetUserId();
            studentContactInfo.SetDate();
            studentContactInfo.Status = "A";
            var res = DataAccess.Instance.StudentContactInfo.Add(studentContactInfo);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;

            return Json(cr);

        }


        [Route("Student/GetStudentContact/{pageno}/{pagesize}/{searchtxt}")]
        [HttpGet]
        public IHttpActionResult GetStudentContactInfo(int pageno, int pagesize, string searchtxt)
        {
            //Get Sudent Contact Info
            CommonResponse res = new CommonResponse();
            if (!string.IsNullOrEmpty(searchtxt) && searchtxt != "null")
            {
                res = DataAccess.Instance.StudentContactInfo.Filter(pageno, pagesize, e => e.IsDeleted == false, o => o.OrderByDescending(e => e.ContactIID));

            }
            else
            {
                res = DataAccess.Instance.StudentContactInfo.getPageResponse(pageno, pagesize);
            }

            if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(res);
            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("Student/GetContactInfoByID/{SIId}")]
        [HttpGet]
        public IHttpActionResult GetContactInfoByID(int SIId)
        {
            //Get Contact Info by StudentID
            object[] param = new object[1];
            param[0] = SIId;
            DataTable res = new DataTable();
            // res = DataAccess.Instance.StudentContactInfo.getDataSetResponseBySp("sp_StudentContactInfo",param);
            res = DataAccess.Instance.CommonServices.GetBySpWithParam("sp_StudentContactInfo", param);
            //StudentContactInfo Contacts = DataAccess.Instance.StudentContactInfo.GetByStudentIID(SIId).FirstOrDefault();
            //res.results = Contacts;

            //res.httpStatusCode = HttpStatusCode.OK;

            //if (res.httpStatusCode == HttpStatusCode.OK)
            return Json(res);
            //return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("Student/GetStudentContactByID/{id}")]
        [HttpGet]
        public IHttpActionResult GetStudentContactByID(long id)
        {
            // Get Contact Info by StudentID 
            CommonResponse res = new CommonResponse();
            StudentContactInfo studentContactInfo = new StudentContactInfo();
            studentContactInfo = DataAccess.Instance.StudentContactInfo.Filter(e => e.StudentIID == id && e.IsDeleted == false).FirstOrDefault();
            res.results = studentContactInfo;
            res.httpStatusCode = HttpStatusCode.OK;
            return Json(res);

        }
        [Route("Student/UpdateStudentContact/")]
        [HttpPut]
        public IHttpActionResult UpdateStudentContactInfo(StudentContactInfo studentContactInfo)
        {
            // Update student Contact
            CommonResponse cr = new CommonResponse();
            studentContactInfo.UpdateBy = User.Identity.GetUserId();
            studentContactInfo.UpdateDate = DateTime.UtcNow.AddHours(6);
            bool res ;
            if(studentContactInfo.ContactIID<=0)
            {
                 res = DataAccess.Instance.StudentContactInfo.Add(studentContactInfo);
            }
            else
            {
                 res = DataAccess.Instance.StudentContactInfo.Update(studentContactInfo);
            }
          
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }

        [Route("Student/DeleteStudentContact/{ContactIID}")]
        [HttpDelete]
        public IHttpActionResult DeleteStudentContactInfo(int ContactIID)
        {
            // Delete Student Contact by Contact IID
            CommonResponse cr = new CommonResponse();
            StudentContactInfo sinfo = new StudentContactInfo();
            sinfo = DataAccess.Instance.StudentContactInfo.Get(ContactIID);
            sinfo.UpdateBy = User.Identity.GetUserId();
            sinfo.UpdateDate = DateTime.UtcNow.AddHours(6);
            sinfo.IsDeleted = true;
            var res = DataAccess.Instance.StudentContactInfo.Update(sinfo);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }


        #endregion ContactInfo

        #region StudentBasicInfo

        [Route("Student/GetStudentID/{versionId}/{sessionId}/{branchId}/{shiftId}/{classId}/{groupId}/{sectionId}/{sttypeId}/{houseId}/{configType}")]
        [HttpGet]
        public IHttpActionResult GetStudentID(int versionId, int sessionId, int branchId, int shiftId, int classId, int groupId, int sectionId, int sttypeId, int houseId, string configType)
        {
            // Create Student ID with these param
            CommonResponse res = new CommonResponse();
            // ID Created into SP
            var StudentID = DataAccess.Instance.CommonServices.GetBySpWithParam("sp_GetStudentID", new object[] { versionId, sessionId, branchId, shiftId, classId, groupId, sectionId, sttypeId, houseId, configType });
            var ss = StudentID.Rows[0][0].ToString().Trim();

            return Json(ss);

        }

        [Route("Student/GetStudentIDList/{versionId}/{sessionId}/{classId}/{groupId}")]
        [HttpGet]
        public IHttpActionResult GetStudentIDList(int versionId, int sessionId, int classId, int groupId)
        {
            // Get StudentID List filter by Version, Session, Class, Group
            CommonResponse cr = new CommonResponse();

            var res = DataAccess.Instance.StudentBasicInfo.Filter(c => c.VersionID.Equals(versionId) && c.SessionId.Equals(sessionId) && c.ClassId.Equals(classId) && c.GroupId.Equals(groupId));
            if (res.Any())
            {
                cr.results = res;
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);

        }
        [Route("Student/GetAllStudentBasicInfo/")]
        [HttpGet]
        public IHttpActionResult GetAllStudentBasicInfo()
        {
            CommonResponse cr = new CommonResponse();
            // Get All Student Basic Info for subject 
            var res = DataAccess.Instance.StudentBasicInfo.GetAll().Select(c => new { c.StudentInsID, StudentName = c.StudentInsID + ' ' + c.FullName }).ToList();
            if (res.Any())
            {
                cr.results = res;
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);

        }
        [Route("Student/GetAllStudentBasicInfo/{NameID}")]
        [HttpGet]
        public IHttpActionResult GetAllStudentBasicInfo(string NameID)
        {
            CommonResponse cr = new CommonResponse();
            // Get All Student Basic Info for subject 
            var res = DataAccess.Instance.StudentBasicInfo.GetAll().Where(c => c.FullName.Contains(NameID) && c.StudentInsID.Contains(NameID) && c.Status.Equals("A")).Select(c => new { c.StudentInsID, StudentName = c.StudentInsID.TrimEnd() + ' ' + c.FullName.Trim() }).ToList();
            if (res.Any())
            {
                cr.results = res;
                cr.message = "Data Found " + res.Count;
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            else
            {
                cr.message = "Data Not Found ";
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);

        }
        #endregion StudentBasicInfo

        #region Academic Info
        [Route("Student/AddAcademicInfo/")]
        [HttpPost]
        public IHttpActionResult AddAcademicInfo(StudentAcademicInfo academicinfo)
        {
            CommonResponse cr = new CommonResponse();
            // Add Academic info 
            //  StudentAcademicInfo StudentExist = DataAccess.Instance.aStudentAcademicService.Get(academicinfo.StudentIID);

            //if (StudentExist != null)

            //StudentAcademicInfo aStudentAcademicInfo = new StudentAcademicInfo();
            //aStudentAcademicInfo.StudentIID = academicinfo.StudentIID;
            //aStudentAcademicInfo.ExamName = academicinfo.ExamName;
            //aStudentAcademicInfo.InstituteName = academicinfo.InstituteName;
            //aStudentAcademicInfo.InstituteAddress = academicinfo.InstituteAddress;
            //aStudentAcademicInfo.DistrictThana = academicinfo.DistrictThana;
            //aStudentAcademicInfo.Center = academicinfo.Center;
            //aStudentAcademicInfo.ExamGroup = academicinfo.ExamGroup;
            //aStudentAcademicInfo.ExamYear = academicinfo.ExamYear;
            //aStudentAcademicInfo.PassYear = academicinfo.PassYear;
            //aStudentAcademicInfo.ExamSession = academicinfo.ExamSession;
            //aStudentAcademicInfo.ExamRoll = academicinfo.ExamRoll;
            //aStudentAcademicInfo.ExamRegNo = academicinfo.ExamRegNo;
            //aStudentAcademicInfo.Board = academicinfo.Board;
            //aStudentAcademicInfo.GPA = academicinfo.GPA;
            //aStudentAcademicInfo.GPAWithOut4thSubject = academicinfo.GPAWithOut4thSubject;
            //aStudentAcademicInfo.Grade = academicinfo.Grade;
            //aStudentAcademicInfo.Comment = academicinfo.Comment;
            academicinfo.SetDate();
            academicinfo.AddBy = User.Identity.GetUserId();
            academicinfo.Status = "A";
            //aStudentAcademicInfo.StudentIID = academicinfo.StudentIID;

            var res = DataAccess.Instance.aStudentAcademicService.Add(academicinfo);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;

            return Json(cr);

        }


        [Route("Student/GetAcademicInfoByID/{id}")]
        [HttpGet]
        public IHttpActionResult GetAcademicInfoByID(int id)
        {
            // Get Academic Info by ID
            CommonResponse res = new CommonResponse();
            List<StudentAcademicInfo> academicInfo = new List<StudentAcademicInfo>();
            academicInfo = DataAccess.Instance.aStudentAcademicService.Filter(e => e.StudentIID == id && e.IsDeleted == false).ToList();
            res.results = academicInfo;
            res.httpStatusCode = HttpStatusCode.OK;
            return Json(res);
        }

        [Route("Student/UpdateAcademicInfo/")]
        [HttpPut]
        public IHttpActionResult UpdateAcademicInfo(StudentAcademicInfo academicinfo)
        {
            // Update Academic Info
            CommonResponse cr = new CommonResponse();
            academicinfo.UpdateBy = User.Identity.GetUserId();
            academicinfo.UpdateDate = DateTime.UtcNow.AddHours(6);
            var res = DataAccess.Instance.aStudentAcademicService.Update(academicinfo);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }

        [Route("Student/DeleteAcademicInfo/{academicId}")]
        [HttpDelete]
        public IHttpActionResult DeleteAcademicInfo(int academicId)
        {
            //// Delete Academic Info
            CommonResponse cr = new CommonResponse();
            //StudentAcademicInfo aStudentAcademicInfo = new StudentAcademicInfo();
            //aStudentAcademicInfo = DataAccess.Instance.aStudentAcademicService.Get(academicId);
            //aStudentAcademicInfo.UpdateBy = User.Identity.GetUserId();
            //aStudentAcademicInfo.UpdateDate = DateTime.UtcNow.AddHours(6);
            //aStudentAcademicInfo.IsDeleted = true;

            //var res = DataAccess.Instance.aStudentAcademicService.Update(aStudentAcademicInfo);

            var res = DataAccess.Instance.aStudentAcademicService.Remove(academicId);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }


        #endregion ContactInfo

        #region Guardian Info
        [Route("Student/AddGuardianInfo/")]
        [HttpPost]
        public IHttpActionResult AddGuardianInfo()
        {
            // Add Guardian Info
            var image = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["F_GuardianImage"] : null; //Get Image / Files from front end
            var signature = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["F_GuardianSignature"] : null;
            var Mimage = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["M_GuardianImage"] : null; //Get Image / Files from front end
            var Msignature = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["M_GuardianSignature"] : null;

            string value = HttpContext.Current.Request.Form["guardianInfo"] ?? "";
            if (string.IsNullOrEmpty(value))
                return BadRequest("Info is incorrect.");
            StudentGuardianInfo aguardianInfo = JsonConvert.DeserializeObject<StudentGuardianInfo>(value); //  Deserialize Form Data

            
            //aguardianInfo.M_MonthlyIncome = aguardianInfo.M_MonthlyIncome.ToString();
            //aguardianInfo.F_MonthlyIncome = aguardianInfo.F_MonthlyIncome.ToString();

            //Update Mother father name here this two fields are ing student basic info
            var StudentInfo=DataAccess.Instance.StudentBasicInfo.Get(aguardianInfo.StudentIID);
            StudentInfo.FatherName = aguardianInfo.FatherName;
            StudentInfo.MotherName = aguardianInfo.MotherName;
           var isSave= DataAccess.Instance.StudentBasicInfo.Update(StudentInfo);

            CommonResponse cr = new CommonResponse();
            aguardianInfo.IsDeleted = false;
            aguardianInfo.AddBy = User.Identity.GetUserId();
            aguardianInfo.SetDate();
            aguardianInfo.Remarks = aguardianInfo.Remarks;
            aguardianInfo.Status = "A";


            if (image != null)
            {
                Image bm = Image.FromStream(image.InputStream);
                Bitmap result = new Bitmap(100, 100);
                using (Graphics g = Graphics.FromImage((Image)result))
                    g.DrawImage(bm, 0, 0, 100, 100);
                Byte[] data_image;
                using (var memoryStream = new MemoryStream())
                {
                    result.Save(memoryStream, ImageFormat.Bmp);
                    data_image = memoryStream.ToArray();
                }
                aguardianInfo.F_GuardianImage = data_image;
            }
            if (Mimage != null)
            {
                Image bm = Image.FromStream(Mimage.InputStream);
                Bitmap result = new Bitmap(100, 100);
                using (Graphics g = Graphics.FromImage((Image)result))
                    g.DrawImage(bm, 0, 0, 100, 100);
                Byte[] data_image;
                using (var memoryStream = new MemoryStream())
                {
                    result.Save(memoryStream, ImageFormat.Bmp);
                    data_image = memoryStream.ToArray();
                }
                aguardianInfo.M_GuardianImage = data_image;
            }

            if (signature != null)
            {
                Image bm = Image.FromStream(signature.InputStream);
                Bitmap result = new Bitmap(100, 100);
                using (Graphics g = Graphics.FromImage((Image)result))
                    g.DrawImage(bm, 0, 0, 100, 100);
                Byte[] data_signature;
                using (var memoryStream = new MemoryStream())
                {
                    result.Save(memoryStream, ImageFormat.Bmp);
                    data_signature = memoryStream.ToArray();
                }
                aguardianInfo.F_GuardianSignature = data_signature;
            }

            if (Msignature != null)
            {
                Image bm = Image.FromStream(Msignature.InputStream);
                Bitmap result = new Bitmap(100, 100);
                using (Graphics g = Graphics.FromImage((Image)result))
                    g.DrawImage(bm, 0, 0, 100, 100);
                Byte[] data_signature;
                using (var memoryStream = new MemoryStream())
                {
                    result.Save(memoryStream, ImageFormat.Bmp);
                    data_signature = memoryStream.ToArray();
                }
                aguardianInfo.M_GuardianSignature = data_signature;
            }

            if(aguardianInfo.StudentIID>0 && aguardianInfo.GuardianInfoId>0)
            {
                var res = DataAccess.Instance.aStudentGuardianService.Update(aguardianInfo);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            else
            {
                var res = DataAccess.Instance.aStudentGuardianService.Add(aguardianInfo);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }

            return Json(cr);
        }


        [Route("Student/GetGuardianInfoByID/{id}")]
        [HttpGet]
        public IHttpActionResult GetGuardianInfoByID(long id)
        {
            // Get Guardian Info by ID
            CommonResponse res = new CommonResponse();
            //List<StudentGuardianInfo> guardianInfo = new List<StudentGuardianInfo>();
            StudentGuardianInfo guardianInfo = new StudentGuardianInfo();
            guardianInfo = DataAccess.Instance.aStudentGuardianService.Filter(e => e.StudentIID == id && e.IsDeleted == false).FirstOrDefault();

            var StudentInfo= DataAccess.Instance.StudentBasicInfo.Get(id);
            guardianInfo.FatherName = StudentInfo.FatherName;
            guardianInfo.MotherName = StudentInfo.MotherName;

            //if(guardianInfo.F_MonthlyIncome!=null || guardianInfo.M_MonthlyIncome != null)
            //{
            //    guardianInfo.F_MonthlyIncome = 0;
            //    guardianInfo.F_MonthlyIncome = 0;
            //}

            res.results = guardianInfo;
            res.httpStatusCode = HttpStatusCode.OK;
            return Json(res);

        }

        [Route("Student/GetBasicInfoByID/{id}")]
        [HttpGet]
        public IHttpActionResult GetBasicInfoByID(long id)
        {
            // Get Guardian Info by ID
            CommonResponse res = new CommonResponse();
            DataTable dt = new DataTable();
            StudentView Info = DataAccess.Instance.StudentBasicInfo.GetStudentViewByID(id);
            res.results = Info;
            res.httpStatusCode = HttpStatusCode.OK;
            return Json(res);

        }

        [Route("Student/UpdateGuardianInfo/")]
        [HttpPut]
        public IHttpActionResult UpdateGuardianInfo(StudentGuardianInfo guardianInfo)

        {
            // Update Guardian Info 
            CommonResponse cr = new CommonResponse();
            guardianInfo.UpdateBy = User.Identity.GetUserId();
            guardianInfo.UpdateDate = DateTime.UtcNow.AddHours(6);
            var res = DataAccess.Instance.aStudentGuardianService.Update(guardianInfo);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }

        [Route("Student/DeleteGuardianInfo/{aguardianId}")]
        [HttpDelete]
        public IHttpActionResult DeleteGuardianInfo(int aguardianId)
        {
            // Delete Guardian info by GuardianInfoID
            CommonResponse cr = new CommonResponse();
            StudentGuardianInfo aStudentGuardianInfo = new StudentGuardianInfo();
            aStudentGuardianInfo = DataAccess.Instance.aStudentGuardianService.Get(aguardianId);
            aStudentGuardianInfo.UpdateBy = User.Identity.GetUserId();
            aStudentGuardianInfo.UpdateDate = DateTime.UtcNow.AddHours(6);
            aStudentGuardianInfo.IsDeleted = true;
            var res = DataAccess.Instance.aStudentGuardianService.Update(aStudentGuardianInfo);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }


        #endregion 

        #region Sibling Info
        [Route("Student/AddSiblingInfo/{studentIID}/{siblingstudentIID}")]
        [HttpPost]
        public IHttpActionResult AddSiblingInfo(int studentIID, int siblingstudentIID)
        {
            // Add Sibling info with Param StudentIID and SiblingStudentIID
            CommonResponse cr = new CommonResponse();
            StudentSiblingInfo aStudentSiblingInfo = new StudentSiblingInfo();
            aStudentSiblingInfo.StudentIID = studentIID;
            aStudentSiblingInfo.SiblingStudentIID = siblingstudentIID;
            aStudentSiblingInfo.IsDeleted = false;
            aStudentSiblingInfo.AddBy = User.Identity.GetUserId();
            aStudentSiblingInfo.SetDate();
            aStudentSiblingInfo.Status = "A";
            var res = DataAccess.Instance.aStudentSiblingService.Add(aStudentSiblingInfo);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;

            return Json(cr);
        }

        [Route("Student/GetSiblingInfoByID/{id}")]
        [HttpGet]
        public IHttpActionResult GetSiblingInfoByID(int id)
        {
            // Get Sibling Info By StudentID
            CommonResponse res = new CommonResponse();
            DataTable dt = new DataTable();
            List<StudentSiblingInfo> siblingInfo = new List<StudentSiblingInfo>();
            // siblingInfo = DataAccess.Instance.aStudentSiblingService.Filter(e => e.StudentIID == id && e.IsDeleted == false).ToList();
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSiblingInfoById", id);
            res.results = dt;
            res.httpStatusCode = HttpStatusCode.OK;
            return Json(res);

        }


        [Route("Student/GetSiblingInfoByInsID/{id}")]
        [HttpGet]
        public IHttpActionResult GetSiblingInfoByInsID(string id)
        {
            //  Get Sibling Info By Student Ins ID
            CommonResponse res = new CommonResponse();
            var siblingInfo = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoByInsId", new object[] { id });

            res.results = siblingInfo;
            res.httpStatusCode = HttpStatusCode.OK;
            return Json(res);

        }


        [Route("Student/UpdateSiblingInfo/")]
        [HttpPut]
        public IHttpActionResult UpdateSiblingInfo(StudentSiblingInfo asiblingInfo)
        {
            // Update Sibling Info 
            CommonResponse cr = new CommonResponse();
            asiblingInfo.UpdateBy = User.Identity.GetUserId();
            asiblingInfo.UpdateDate = DateTime.UtcNow.AddHours(6);
            var res = DataAccess.Instance.aStudentSiblingService.Update(asiblingInfo);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }

        [Route("Student/DeleteSiblingInfo/{siblingId}")]
        [HttpDelete]
        public IHttpActionResult DeleteSiblingInfo(int siblingId)
        {
            // Delete Sibling Info by Sibling ID
            CommonResponse cr = new CommonResponse();
            //StudentSiblingInfo aStudentSiblingInfo = new StudentSiblingInfo();
            //aStudentSiblingInfo = DataAccess.Instance.aStudentSiblingService.Filter(a => a.SiblingStudentIID == siblingId).FirstOrDefault();
            //aStudentSiblingInfo.UpdateBy = User.Identity.GetUserId();
            //aStudentSiblingInfo.UpdateDate = DateTime.Now;
            //aStudentSiblingInfo.IsDeleted = true;
            //var x = DataAccess.Instance.aStudentSiblingService.Update(aStudentSiblingInfo);

            var x = DataAccess.Instance.CommonServices.ExecuteSQL("Delete from Student_SiblingInfo where SiblingStudentIID='" + siblingId + "'");
            cr.results = x;
            //cr.httpStatusCode = x ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            //cr.message = x ? Constant.SAVED : Constant.FAILED;
            return Json(cr);

        }


        #endregion

        #region    Others Info


        [Route("Student/AddOthersInfo/")]
        [HttpPost]
        public IHttpActionResult AddOthersInfo()
        {
            // Add Others Info 

            // Get Image from front-end
            var achievementImg = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["achievementImg"] : null;

            string value = HttpContext.Current.Request.Form["othersInfo"] ?? "";
            // Get form value from frot-end
            if (string.IsNullOrEmpty(value))
                return BadRequest("Student info is incorrect.");
            OthersInfo OthersInfo = JsonConvert.DeserializeObject<OthersInfo>(value);
            // Form Data deserialize   

            if (string.IsNullOrEmpty(OthersInfo.StudentIID.ToString()))
                return BadRequest("StudentIID have been not supplied");
            CommonResponse cr = new CommonResponse();
            if (DataAccess.Instance.StudentBasicInfo.Get(OthersInfo.StudentIID) == null)
            {
                // Check Student Exist or  not
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.results = "Student not found";
                return Json(cr);
            }

            if (achievementImg != null)
            {
                Image bm = Image.FromStream(achievementImg.InputStream);
                Bitmap result = new Bitmap(100, 100);
                using (Graphics g = Graphics.FromImage((Image)result))
                    g.DrawImage(bm, 0, 0, 100, 100);

                Byte[] data_image;

                using (var memoryStream = new MemoryStream())
                {
                    result.Save(memoryStream, ImageFormat.Bmp);

                    data_image = memoryStream.ToArray();
                }


                OthersInfo.AchievementPicture = data_image;
            }
            OthersInfo.IsDeleted = false;
            OthersInfo.AddBy = User.Identity.GetUserId();
            OthersInfo.SetDate();
            OthersInfo.Status = "A";
            var res = DataAccess.Instance.OthersInfo.Add(OthersInfo);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;

            return Json(cr);
        }


        [Route("Student/GetOthersInfo/{pageno}/{pagesize}/{searchtxt}")]
        [HttpGet]
        public IHttpActionResult GetOthersInfo(int pageno, int pagesize, string searchtxt)
        {
            // Get Others Info
            CommonResponse res = new CommonResponse();
            if (!string.IsNullOrEmpty(searchtxt) && searchtxt != "null")
            {
                res = DataAccess.Instance.OthersInfo.Filter(pageno, pagesize, e => e.Type.Contains(searchtxt) && e.IsDeleted == false, o => o.OrderByDescending(e => e.Id));

            }
            else
            {
                res = DataAccess.Instance.StudentContactInfo.getPageResponse(pageno, pagesize);
            }

            if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(res);
            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("Student/GetOthersInfoByID/{Id}")]
        [HttpGet]
        public IHttpActionResult GetOthersInfoByID(int Id)
        {
            // Get Others Info By ID
            CommonResponse res = new CommonResponse();
            List<OthersInfo> othersInfo = new List<OthersInfo>();
            othersInfo = DataAccess.Instance.OthersInfo.Filter(e => e.StudentIID == Id && e.IsDeleted == false).ToList();

            res.results = othersInfo;
            res.httpStatusCode = HttpStatusCode.OK;
            return Json(res);
        }

        [Route("Student/GetOthersInfo/{otherInfoId}")]
        [HttpGet]
        public IHttpActionResult GetOthersInfo(int otherInfoId)
        {
            // Get Others Info by OthersInfoID
            CommonResponse res = new CommonResponse();
            List<OthersInfo> othersInfo = new List<OthersInfo>();
            othersInfo = DataAccess.Instance.OthersInfo.Filter(e => e.Id == otherInfoId && e.IsDeleted == false).ToList();
            res.results = othersInfo;
            res.httpStatusCode = HttpStatusCode.OK;
            return Json(res);

        }
        [Route("Student/UpdateOthersInfo/")]
        [HttpPut]
        public IHttpActionResult UpdateOthersInfo(OthersInfo othersInfo)
        {
            // Update Others Info 
            CommonResponse cr = new CommonResponse();
            othersInfo.UpdateBy = User.Identity.GetUserId();
            othersInfo.UpdateDate = DateTime.UtcNow.AddHours(6);
            var res = DataAccess.Instance.OthersInfo.Update(othersInfo);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }

        [Route("Student/DeleteOthersInfo/{othersInfoID}")]
        [HttpDelete]
        public IHttpActionResult DeleteOthersInfo(int othersInfoID)
        {
            // Delete Others Info By othersInfoID
            CommonResponse cr = new CommonResponse();
           

            var res = DataAccess.Instance.OthersInfo.Remove(othersInfoID);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }

        #endregion Others Info

        #region Subject Info
        [Route("Student/SubjectList/{versionId}/{sessionID}/{classId}/{groupId}")]
        [HttpGet]
        public IHttpActionResult SubjectList(int versionID, int sessionID, int classID, string groupID)
        {
            // Get Subject List by parameter version, session, class, group
            int _groupID = 0;
            if (groupID.ToLower().Trim() != "null" && groupID != "undefined")
            {
                _groupID = Convert.ToInt32(groupID);
            }
            else
            {
                return BadRequest("Invaild Request.");
            }
            CommonResponse cr = new CommonResponse();
            dynamic res = null;
            var subjectListId = DataAccess.Instance.StudentSubject.Filter(s => s.VersionID == versionID
             && s.SessionId == sessionID && s.ClassId == classID && s.GroupId == _groupID && s.IsDeleted == false, null).Select(c => c.SubjectID).ToList();
            foreach (var item in subjectListId)
            {
                res += DataAccess.Instance.SubjectSetup.Filter(c => c.SubID.Equals(item));
            }
            if (res.Any())
            {
                cr.results = res;
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        #endregion Subject Info

        #region Subject Detail Infomation
        [Route("Student/StuDetailInfo/")]
        [HttpPost]
        public IHttpActionResult StuDetailInfo(CheckStudentFilter f)
        {
            string whereClause = CommunicationService.GetWhereClauseWithCheck(f).Trim().Trim('~').Replace("~", " AND ");
            //p1 search student by various filter
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentSearch", new object[] { whereClause });
            if (dt.Rows.Count == 0)
            {
                cr.message = "No Data Found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            else
            {
                cr.results = dt;
                cr.message = dt.Rows.Count + " Data found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            if (cr.httpStatusCode == HttpStatusCode.OK)
                return Json(cr);
            return BadRequest(Constant.INVAILD_DATA);
        }


        #endregion Subject Detail Infomation


        #region Others
        [Route("Student/ReqTC/{StudentId}/{Comment}")]
        [HttpGet]
        public IHttpActionResult ReqTC(long StudentId, string Comment)
        {

            CommonResponse cr = new CommonResponse();

            Dictionary<string, string> colms = new Dictionary<string, string>();
            colms.Add("IsTC", "@IsTC");
            colms.Add("TCCauses", "@TCCauses");
            colms.Add("TCStatus", "@TCStatus");
            colms.Add("TCBy", "@TCBy");
            colms.Add("UpdateBy", "@UpdateBy");
            colms.Add("UpdateDate", "@UpdateDate");


            Dictionary<string, string> WhereClause = new Dictionary<string, string>();
            WhereClause.Add("StudentIID", "@StudentIID");

            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@TCCauses", Comment);
            param[1] = new SqlParameter("@TCStatus", "P");
            param[2] = new SqlParameter("@TCBy", User.Identity.GetUserName());
            param[3] = new SqlParameter("@UpdateBy", User.Identity.GetUserName());
            param[4] = new SqlParameter("@UpdateDate", DateTime.Now);
            param[5] = new SqlParameter("@StudentIID", StudentId);
            param[6] = new SqlParameter("@IsTC", 1);

            if (DataAccess.Instance.CommonServices.UpdateBySql("Student_BasicInfo", colms, WhereClause, param))
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.UPDATED;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.FAILED;
            }
            return Json(cr);
        }

        [Route("Student/ApproveTC/{StudentId}/{TCStatus}/{Type}")]
        [HttpGet]
        public IHttpActionResult ApproveTC(long StudentId, string TCStatus, int Type)
        {

            CommonResponse cr = new CommonResponse();

            Dictionary<string, string> colms = new Dictionary<string, string>();

            colms.Add("TCStatus", "@TCStatus");
            colms.Add("TCApprovedBy", "@TCApprovedBy");
            colms.Add("UpdateBy", "@UpdateBy");
            colms.Add("UpdateDate", "@UpdateDate");
            colms.Add("Status", "@Status");

            Dictionary<string, string> WhereClause = new Dictionary<string, string>();
            WhereClause.Add("StudentIID", "@StudentIID");

            SqlParameter[] param = new SqlParameter[7];

            if (TCStatus == "P" && Type == 0)
            {
                param[1] = new SqlParameter("@TCStatus", "");
                param[6] = new SqlParameter("@Status", "A");
            }
            else if(TCStatus == "P" && Type == 1)
            {
                param[1] = new SqlParameter("@TCStatus", "A");
                param[6] = new SqlParameter("@Status", "I");
            }
            else if(TCStatus == "A" && Type == 2)
            {
                param[1] = new SqlParameter("@TCStatus", "");
                param[6] = new SqlParameter("@Status", "A");
            }

            param[2] = new SqlParameter("@TCApprovedBy", User.Identity.GetUserName());
            param[3] = new SqlParameter("@UpdateBy", User.Identity.GetUserName());
            param[4] = new SqlParameter("@UpdateDate", DateTime.Now);
            param[5] = new SqlParameter("@StudentIID", StudentId);


            dynamic res = null;

            if (DataAccess.Instance.CommonServices.UpdateBySql("Student_BasicInfo", colms, WhereClause, param))
            {
                cr.results = res;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.UPDATED;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);


            //CommonResponse cr = new CommonResponse();
            //dynamic res = null;

            //if (res.Any())
            //{
            //    cr.results = res;
            //    cr.httpStatusCode = HttpStatusCode.OK;
            //}
            //else
            //{
            //    cr.httpStatusCode = HttpStatusCode.BadRequest;
            //}
            //return Json(cr);
        }

        #endregion


        public static byte[] GetImageByte(Stream File)
        {
            Image bm = Image.FromStream(File);
            Bitmap result = new Bitmap(100, 100);
            using (Graphics g = Graphics.FromImage((Image)result))
                g.DrawImage(bm, 0, 0, 100, 100);

            Byte[] data;

            using (var memoryStream = new MemoryStream())
            {
                result.Save(memoryStream, ImageFormat.Bmp);

                data = memoryStream.ToArray();
            }
            return data;
        }



        [Route("Student/SearchStudenForAdmitCard/")]
        [HttpPost]
        public IHttpActionResult SearchStudenForAdmitCard(StudentFilter f)
        {
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            /// Create SQL Parameter for query , field value  will be 0 if no need to query on this
            var param = new object[] { f.VersionID, f.SessionId, f.BranchID, f.ShiftID, f.ClassId, f.GroupId, f.SectionId };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForResult", param);
            if (dt.Rows.Count == 0)
            {
                cr.message = "No Data Found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            else
            {
                cr.results = dt;
                cr.message = dt.Rows.Count + " Data found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            if (cr.httpStatusCode == HttpStatusCode.OK)
                return Json(cr);
            return BadRequest(Constant.INVAILD_DATA);
        }



        [Route("Student/SearchStudenForSeatCard/")]
        [HttpPost]
        public IHttpActionResult SearchStudenForSeatCard(StudentFilter f)
        {
            CommonResponse cr = new CommonResponse();
            DataTable dt = new DataTable();
            /// Create SQL Parameter for query , field value  will be 0 if no need to query on this
            var param = new object[] { f.VersionID, f.SessionId, f.BranchID, f.ShiftID, f.ClassId, f.GroupId, f.SectionId };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForResult", param);
            if (dt.Rows.Count == 0)
            {
                cr.message = "No Data Found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            else
            {
                cr.results = dt;
                cr.message = dt.Rows.Count + " Data found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            if (cr.httpStatusCode == HttpStatusCode.OK)
                return Json(cr);
            return BadRequest(Constant.INVAILD_DATA);
        }


        [Route("Student/SearchStudenForIDCard/")]
        [HttpPost]
        public IHttpActionResult SearchStudenForIDCard(StudentFilter f)
        {
            CommonResponse cr = new CommonResponse();
            DataTable dt = new DataTable();
            /// Create SQL Parameter for query , field value  will be 0 if no need to query on this
            var param = new object[] { f.VersionID, f.SessionId, f.BranchID, f.ShiftID, f.ClassId, f.GroupId, f.SectionId };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForResult", param);
            if (dt.Rows.Count == 0)
            {
                cr.message = "No Data Found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            else
            {
                cr.results = dt;
                cr.message = dt.Rows.Count + " Data found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            if (cr.httpStatusCode == HttpStatusCode.OK)
                return Json(cr);
            return BadRequest(Constant.INVAILD_DATA);
        }
        
    }
}

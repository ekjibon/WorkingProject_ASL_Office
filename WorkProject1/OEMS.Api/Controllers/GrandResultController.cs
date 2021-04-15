using Microsoft.AspNet.Identity;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Exam;
using OEMS.Models.ViewModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Collections;
using System.Web.Http;
using System.Data.SqlClient;
using System.Transactions;

namespace OEMS.Api.Controllers
{
    //[ApiAuth]
    public class GrandResultController : ApiController
    {
        public GrandResultController() { }
        #region Grand Exam
        [Route("GrandResult/CloneMainExam/{MainExamId}/{NewExamName}/{Version}/{Session}/{Class}/{Group}")]
        [HttpPost]
        public IHttpActionResult CloneMainExam(int MainExamId, string NewExamName, int Version, int Session, int Class, int Group) //P1 Grand Exam, Grand Sub Exam and Grand Divided Exam, GrandExamMarkset, GrandSubExam and GranddividedExam create based on Main Exam, Sub Exam and Divided Exam, MainExamMarkSetu, SubExamMarkSetup and DividedExamMarkSetup
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                using (TransactionScope scope = new TransactionScope())
                {
                    if (string.IsNullOrEmpty("NewExamName"))  //P2 Check Grand Exam Name
                return BadRequest("Grand Exam Name Can't Left Blank");
            List<SubExamMarkSetup> lstSEMarkSetup = new List<SubExamMarkSetup>();    
            //P3 Get Main Exam Mark Percentage from GrandSetup Table
            var mp = DataAccess.Instance.GrandSetupService.Filter(g => g.VersionId == Version && g.SessionId == Session
            && g.ClassId == Class && g.GroupId == Group && g.IsDeleted == false).ToList();
            var me = mp.Where(e => e.MainExamId == MainExamId).ToList();
            if(!me.Any())
            {
                return BadRequest("Source Main Exam Mark Percentage didn't configure yet!");
            } 
            //P4 Fetch MainExam
            var _MainExam = DataAccess.Instance.MainExamService.Filter(e => e.MainExamId == MainExamId && e.VersionId==Version
                            && e.SessionId==Session && e.ClassId==Class && e.GroupId==Group && e.IsDeleted==false).FirstOrDefault();            
            if (_MainExam == null)
            {
                return BadRequest("Source Main Exam Invaild!");
            }
            //P5 pcheck GrandExam exists
            var nameExists = DataAccess.Instance.GrandExamService.Filter(e => e.GrandExamName.ToLower() == NewExamName.ToLower()
                             && e.VersionId == Version && e.SessionId == Session && e.ClassId == Class && e.GroupId == Group && e.IsDeleted == false).FirstOrDefault();
            if (nameExists !=null)
            {
                return BadRequest("Main Exam Name Exists!");
            }          
            GrandExam Exam = new GrandExam();
            Exam.GrandExamName = NewExamName;
            Exam.SessionId = _MainExam.SessionId;
            Exam.VersionId = _MainExam.VersionId;
            Exam.ClassId = _MainExam.ClassId;
            Exam.GroupId = _MainExam.GroupId;
            Exam.Remarks = "Clone From-" + _MainExam.MainExamId;
            Exam.IsDeleted = _MainExam.IsDeleted;
            Exam.Status = _MainExam.Status;
            Exam.AddBy = User.Identity.Name;
                    Exam.IsDeleted = false;
                    Exam.Status = "A";
            Exam.SetDate();
            DataAccess.Instance.GrandExamService.Add(Exam);
            var param = new SqlParameter();
            //P6 Update GrandSetup Table GrandExamId column by GrandExamId  which is just created above
            var GrandSetup = DataAccess.Instance.GrandSetupService.Filter(e => e.VersionId == Exam.VersionId && e.SessionId == Exam.SessionId && e.ClassId == Exam.ClassId && e.GroupId == Exam.GroupId).ToList();
            foreach (var item in GrandSetup)
            {
                item.GrandExamId = Exam.GrandExamId;
                if (Exam.GrandExamId==0)
                {
                     throw new Exception("Grand Exam Name Doesn't Found");
                }
                item.UpdateBy = User.Identity.Name;
                item.SetDate();
                DataAccess.Instance.GrandSetupService.Update(item);
            }
           // DataAccess.Instance.CommonServices.ExecuteSQL("UPDATE Res_GrandSetup  SET UpdateBy='"+ Exam.AddBy+ "', UpdateDate='"+Exam.AddDate+"', GrandExamId="+Exam.GrandExamId+" WHERE VersionId="+Exam.VersionId+" AND SessionId="+Exam.SessionId+" AND ClassId="+Exam.ClassId+" AND GroupId="+Exam.GroupId+"");
            cr.results = Exam.GrandExamId; // This line for successfully return 
            //P7 Fetch MainExamMarkSetup
            var lstMEMarkSetup = DataAccess.Instance.MainExamMarkSetupService.Filter(e => e.MainExamId == MainExamId && e.IsDeleted == false).ToList();
            ArrayList GEMS = new ArrayList();
            foreach (var MMarkSetup in lstMEMarkSetup) //Create GrandExamMarkSetup All Subject
            {
                //P8 Fetch All SubexamMarkSetup
                var _SMMS = DataAccess.Instance.aSubExamMarkSetupService.Filter(e => e.MainExamMarkSetupId == MMarkSetup.Id && e.IsDeleted == false).ToList();

                //GrandExamMarkSetup
                GrandExamMarkSetup M = new GrandExamMarkSetup();
                M.VersionId = MMarkSetup.VersionId;
                M.SessionId = MMarkSetup.SessionId;
                M.ClassId = MMarkSetup.ClassId;
                M.GroupId = MMarkSetup.GroupId;
                M.GrandExamId = Exam.GrandExamId;
                M.ExamSubjectID = MMarkSetup.MainExamSubjectID;
                M.ExamFullMarks = MMarkSetup.MainExamFullMarks;
                M.ExamIsPassDepend = MMarkSetup.MainExamIsPassDepend;
                M.ExamPassMark = MMarkSetup.MainExamPassMark;
                M.ExamPassMarkIsPercent = MMarkSetup.MainExamPassMarkIsPercent;
                M.IsDeleted = MMarkSetup.IsDeleted;
                M.SetDate();
                M.Remarks = MMarkSetup.Remarks;
                M.Status = MMarkSetup.Status;
                M.AddBy = User.Identity.Name;
                        M.SetDate();
                        DataAccess.Instance.GrandExamMarkSetupService.Add(M);
                GEMS.Add(M.GrandExamMarkSetupId);
                foreach (var item in _SMMS) //P8 GrandSubExamMarkSetup Store without ID
                {
                    //item.Id = 0;
                    item.MainExamMarkSetupId = M.GrandExamMarkSetupId;
                    item.MainExamMarkSetup = null;
                    item.DividedExamMarkSetup = null;
                    item.SetDate();

                }
                lstSEMarkSetup.AddRange(_SMMS);
            }

            //P9 Pull Sub Exam And Save 
            var lstSubExam = DataAccess.Instance.SubexamService.Filter(e => e.MainExamId == MainExamId && e.IsDeleted == false).ToList();
            if (lstSubExam.Any())
            {
                foreach (var _sub in lstSubExam)
                {
                    GrandSubExam SExam = new GrandSubExam();
                    SExam.GrandSubExamName = _sub.SubExamName;
                    SExam.GrandExamId = Exam.GrandExamId;
                    SExam.IsDeleted = _sub.IsDeleted;
                    SExam.Remarks = _sub.Remarks;
                    SExam.Status = _sub.Status;
                    SExam.AddBy = User.Identity.Name;
                    SExam.SetDate();
                    DataAccess.Instance.GrandSubExamService.Add(SExam);
                   
                    List<DividedExamMarkSetup> lstDEMarkSetup = new List<DividedExamMarkSetup>();

                    foreach (var item in lstSEMarkSetup.Where(e => e.SubExamId == _sub.SubExamId).ToList())
                    {
                        var _DEMS = DataAccess.Instance.DividedExamMarkSetup.Filter(e => e.SubExamMarkSetupId == item.Id && e.IsDeleted == false).ToList();
                        GrandSubExamMarkSetup GSM = new GrandSubExamMarkSetup();
                        GSM.GrandExamMarkSetupId = item.MainExamMarkSetupId;
                        GSM.SubExamId = SExam.GrandSubExamId;
                        GSM.SubExamFullMarks = item.SubExamFullMarks;
                        GSM.SubExamExamMarks = item.SubExamExamMarks;
                        GSM.SubExamIsPassDepend = item.SubExamIsPassDepend;
                        GSM.SubExamPassMark = item.SubExamPassMark;
                        GSM.SubExamPassMarkIsPercent = item.SubExamPassMarkIsPercent;
                        GSM.SubExamIsEnable = item.SubExamIsEnable;
                        GSM.SetDate();
                        GSM.AddBy = User.Identity.Name;
                         GSM.Remarks = item.Remarks;
                        GSM.Status = item.Status;
                                GSM.SetDate();
                        DataAccess.Instance.GrandSubExamMarkSetupService.Add(GSM);

                        foreach (var itemd in _DEMS)        //P10 GrandDividedExamMarkSetup Store without ID
                        {
                            //itemd.Id = 0;
                            itemd.SubExamMarkSetupId = GSM.GrandSubExamMarkSetupId;
                            item.MainExamMarkSetup = null;
                            itemd.SubExamMarkSetup = null;
                            item.SetDate();

                        }
                        lstDEMarkSetup.AddRange(_DEMS);
                    }

                    //P11 Pull Divied And Save
                    var _lstdivided = DataAccess.Instance.DividedExamService.Filter(e => e.SubExamId == _sub.SubExamId && e.IsDeleted == false).ToList();
                    foreach (var _divided in _lstdivided)
                    {
                        GrandDividedExam DExam = new GrandDividedExam();
                        DExam.GrandSubExamId = SExam.GrandSubExamId;
                        DExam.DividedExamName = _divided.DividedExamName;
                        DExam.DividedExamType = _divided.DividedExamType;
                        DExam.IsDeleted = _divided.IsDeleted;
                        DExam.Remarks = _divided.Remarks;
                        DExam.Status = _divided.Status;
                        DExam.AddBy = User.Identity.Name;
                        DExam.SetDate();
                        DataAccess.Instance.GrandDividedExamService.Add(DExam);

                        foreach (var item in lstDEMarkSetup.Where(e => e.DividedExamId == _divided.DividedExamId).ToList())       //P12 Save GrandDividedExamMarkSetup
                        {
                            GrandDividedExamMarkSetup GDMS = new GrandDividedExamMarkSetup();
                            GDMS.SubExamMarkSetupId = item.SubExamMarkSetupId;
                            GDMS.DividedExamId = DExam.GrandDividedExamId;
                            GDMS.DividedExamType = item.DividedExamType;
                            GDMS.DividedExamFullMarks = item.DividedExamFullMarks;
                            GDMS.DividedExamExamMarks = item.DividedExamExamMarks;
                            GDMS.DividedExamIsPassDepend = item.DividedExamIsPassDepend;
                            GDMS.DividedExamPassMarks = item.DividedExamPassMarks;
                            GDMS.DividedExamPassMarkIsPercent = item.DividedExamPassMarkIsPercent;
                            GDMS.DividedExamIsEnable = item.DividedExamIsEnable;
                            GDMS.IsDeleted = item.IsDeleted;
                            GDMS.SetDate();
                            GDMS.AddBy = User.Identity.Name;
                            GDMS.Remarks = item.Remarks;
                            GDMS.Status = item.Status;
                                    GDMS.SetDate();
                            DataAccess.Instance.GrandDividedExamMarkSetupService.Add(GDMS);
                        }
                    }
                }
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.SAVED;
            }
                    scope.Complete();
                }
            }
            catch (TransactionAbortedException ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            catch (ApplicationException ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }            
        [Route("GrandResult/AddMainExam/")]
        [HttpPost]
        public IHttpActionResult AddGrandExam(GrandExam mainExam)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //P1 Check GrandExam
                var ExistingExam = DataAccess.Instance.GrandExamService.Filter(s => s.GrandExamName == mainExam.GrandExamName && s.VersionId == mainExam.VersionId
                 && s.ClassId == mainExam.ClassId && s.SessionId == mainExam.SessionId && s.GroupId == mainExam.GroupId && s.IsDeleted == false);
                if (ExistingExam.Any())
                    return BadRequest("Exam Name already exist");
                mainExam.IsDeleted = false;
                mainExam.AddBy = User.Identity.Name;
                mainExam.SetDate();
                mainExam.Status = "A";
                var res = DataAccess.Instance.GrandExamService.Add(mainExam);
                if (res) //P2 Return GrandExam if succeessfully Add
                {                                  
                    cr.results = mainExam;
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.FAILED;
                }
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }

            return Json(cr);
        }
        [Route("GrandResult/GetMainExam/{mainExamID}")]     // Using for Exam Add Wizard Page
        [HttpGet]
        public IHttpActionResult GetGrandExam(int mainExamID)
        {
            CommonResponse cr = new CommonResponse();
            //P1 Pull GrandExam and Return
            var res = DataAccess.Instance.GrandExamService.Get(mainExamID);
            if (res != null)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/GetMainExamById/{mainExamID}")] // Using for Exam Edit Wizard Page  inside angular init method
        [HttpGet]
        public IHttpActionResult GetGrandExamById(int mainExamID)
        {
            CommonResponse cr = new CommonResponse();
            //P1 Pull GrandExam and Return
            var result = DataAccess.Instance.GrandExamService.Filter(s => s.GrandExamId == mainExamID && s.IsDeleted == false, o => o.OrderBy(i => i.GrandExamId), new string[] { "ClassInfo", "Session" }).ToList();
            if (result.Any())
            {
                foreach (var GrandExam in result)
                {
                    cr.results = GrandExam;
                    break;
                }
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/GetMainExam/{versionId}/{sessionID}/{classId}/{groupId}")]
        [HttpGet]
        public IHttpActionResult GetGrandExam(int versionID, int sessionID, int classID, string groupID)    //
        {
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
            //P1 Pull GrandExam with GrandSubExam Name
            var res = DataAccess.Instance.GrandExamService.Filter(s => s.VersionId == versionID
             && s.SessionId == sessionID && s.ClassId == classID && s.GroupId == _groupID && s.IsDeleted == false, null, new string[] { "GrandSubExam" }).ToList();
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
        [Route("GrandResult/GetMainExam/{versionId}/{sessionID}/{classId}")]
        [HttpGet]
        public IHttpActionResult GetGrandExam(int versionID, int sessionID, int classID)     // For Merit Config
        {
            CommonResponse cr = new CommonResponse();
            //P1 Pull GrandExam with GrandSubExam Name    For Merit Config
            var res = DataAccess.Instance.GrandExamService.Filter(s => s.VersionId == versionID
             && s.SessionId == sessionID && s.ClassId == classID && s.IsDeleted == false, null, new string[] { "GrandSubExam" }).ToList();
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
        [Route("GrandResult/GetAllMainExam/")]    // Using for Exam List Page  angular init method
        [HttpGet]
        public IHttpActionResult GetAllGrandExam()
        {
            CommonResponse cr = new CommonResponse();
            //P1 Pull All GrandExam With Class and Sesseion Name
            var res = DataAccess.Instance.GrandExamService.Filter(s => s.IsDeleted == false, o => o.OrderBy(i => i.SessionId).ThenBy(i => i.ClassId).ThenBy(i => i.GrandExamId), new string[] { "ClassInfo", "Session" }).ToList();
            if (res.Any())
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/GetGrandExamByVersionSession/{sessionID}/{ClassId?}/{GroupId?}")]  
        [HttpGet]
        public IHttpActionResult GetGrandExamByVersionSession(int sessionID,int? ClassId=0 ,int? GroupId=0)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                string sql = @"SELECT M.[GrandExamId], V.VersionName+'-'+C.ClassName+'-'+G.GroupName+'-'+[GrandExamName] AS GrandExamName       
                           FROM [dbo].[Res_GrandExam] M INNER JOIN Ins_ClassInfo C ON M.ClassId=C.ClassId AND C.IsDeleted=0
                           INNER JOIN Ins_Group G ON M.GroupId=G.GroupId AND G.Group_Status='A'
						   INNER JOIN Ins_Version V ON M.VersionId=V.VersionId AND V.IsDeleted=0
                           WHERE  M.SessionId=" + sessionID;
                if(ClassId != 0 )
                {
                    sql = sql + " and m.ClassId =" + ClassId;
                }
                if(GroupId != 0)
                {
                    sql = sql + " and m.GroupId =" + GroupId;
                }
                sql = sql + " and  M.IsDeleted=0 ORDER BY C.ClassId, G.GroupId";
                var dt = DataAccess.Instance.CommonServices.ExecuteSQLQUERY(sql);
                List<GrandExam> res = APIUitility.ConvertDataTable<GrandExam>(dt).ToList();
                if (res.Any())
                {
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.results = res;
                    cr.message = Constant.SUCCESS;
                }
                else
                {
                    return BadRequest("No Grand Exam Found.");
                }
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        [Route("GrandResult/GetGrandExamBySessionClassGroup/{sessionID}/{ClassId}/{GroupId}")]  
        [HttpGet]
        public IHttpActionResult GetGrandExamBySessionClassGroup(int sessionID, int ClassId, int GroupId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                string sql = @"SELECT M.[GrandExamId], V.VersionName+'-'+C.ClassName+'-'+G.GroupName+'-'+[GrandExamName] AS GrandExamName       
                           FROM [dbo].[Res_GrandExam] M INNER JOIN Ins_ClassInfo C ON M.ClassId=C.ClassId AND C.IsDeleted=0
                           INNER JOIN Ins_Group G ON M.GroupId=G.GroupId AND G.Group_Status='A'
						   INNER JOIN Ins_Version V ON M.VersionId=V.VersionId AND V.IsDeleted=0
                           WHERE  M.SessionId=" + sessionID;
                if (ClassId != 0)
                {
                    sql = sql + " and m.ClassId =" + ClassId;
                }
                if (GroupId != 0)
                {
                    sql = sql + " and m.GroupId =" + GroupId;
                }
                sql = sql + " and  M.IsDeleted=0 ORDER BY C.ClassId, G.GroupId";
                var dt = DataAccess.Instance.CommonServices.ExecuteSQLQUERY(sql);
                List<GrandExam> res = APIUitility.ConvertDataTable<GrandExam>(dt).ToList();
                if (res.Any())
                {
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.results = res;
                    cr.message = Constant.SUCCESS;
                }
                else
                {
                    return BadRequest("No Grand Exam Found.");
                }
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        [Route("GrandResult/GetGrandExamBySession/{versionId}/{sessionID}/{classId}/{groupId}")]  // Using for Exam List Page  inside Show Button
        [HttpGet]
        public IHttpActionResult GetGrandExamBySession(int versionID, int sessionID, int classID, string groupID)
        {
            CommonResponse cr = new CommonResponse();
            int _groupID = 0;
            if (groupID != "null" && groupID != "undefined")
            {
                _groupID = Convert.ToInt32(groupID);
            }
            //P1 Pull GrandExam with Class and Sesseion Name
            var res = DataAccess.Instance.GrandExamService.Filter(s => s.VersionId == versionID
             && s.SessionId == sessionID && s.ClassId == classID && s.GroupId == _groupID && s.IsDeleted == false,
             o => o.OrderBy(i => i.GrandExamId), new string[] { "ClassInfo", "Session" }).ToList();
            if (res.Any())
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
                cr.message = Constant.SUCCESS;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = Constant.FAILED;

            }
            return Json(cr);
        }        
        [Route("GrandResult/GetMainExamByGroup/{versionId}/{sessionID}/{classId}/{groupId}")]  // Using for Exam List Page  inside Show Button
        [HttpGet]
        public IHttpActionResult GetMainExamByGroup(int versionID, int sessionID, int classID, string groupID)
        {
            CommonResponse cr = new CommonResponse();
            int _groupID = 0;
            if (groupID != "null" && groupID != "undefined")
            {
                _groupID = Convert.ToInt32(groupID);
            }
            //P1 Pull GrandExam with Class and Sesseion Name
            var res = DataAccess.Instance.GrandExamService.Filter(s => s.VersionId == versionID
             && s.SessionId == sessionID && s.ClassId == classID && s.GroupId == _groupID && s.IsDeleted == false,
             o => o.OrderBy(i => i.GrandExamId), new string[] { "ClassInfo", "Session" }).Select(e=> new GrandExam {GrandExamId= e.GrandExamId, GrandExamName=e.GrandExamName}).ToList();

            if (res.Any())
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/UpdateMainExam/")]
        [HttpPut]
        public IHttpActionResult UpdateGrandExam(GrandExam mainExam)
        {
            CommonResponse cr = new CommonResponse();
            bool res = false;
            try
            {
                GrandExam _Mainexam = DataAccess.Instance.GrandExamService.Get(mainExam.GrandExamId);
                // P1 Check Marks Exists by GrandExamId
                var mainExamMark = DataAccess.Instance.GrandExamMarkSetupService.Filter(m => m.GrandExamId == mainExam.GrandExamId && m.IsDeleted == false).ToList();

                if (mainExamMark.Any() && (User.IsInRole("Super")))      //P2 Update If Marks exists and user role super
                {
                    _Mainexam.GrandExamName = mainExam.GrandExamName;                        
                    _Mainexam.UpdateBy = User.Identity.Name;
                    _Mainexam.SetDate();
                    res = DataAccess.Instance.GrandExamService.Update(_Mainexam);
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? "Only Name Updated." : Constant.FAILED;
                }
                else if(!mainExamMark.Any())      //P3 Update If Marks not exists 
                {
                    _Mainexam.GrandExamName = mainExam.GrandExamName;
                    _Mainexam.UpdateBy = User.Identity.Name;
                    _Mainexam.SetDate();
                    res = DataAccess.Instance.GrandExamService.Update(_Mainexam);
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.UPDATED : Constant.FAILED;
                }

                if (res)       //P4 Return Updated Grand Exam
                {
                    cr.results = DataAccess.Instance.GrandExamService.Filter(s => s.GrandExamId == mainExam.GrandExamId && s.IsDeleted == false, o => o.OrderBy(i => i.GrandExamId), new string[] { "ClassInfo", "Session" }).ToList().FirstOrDefault();

                }

            }
            catch (Exception ex)
            {
                var mainExamResult = DataAccess.Instance.GrandExamService.Filter(s => s.GrandExamId == mainExam.GrandExamId && s.IsDeleted == false, o => o.OrderBy(i => i.GrandExamId), new string[] { "ClassInfo", "Session" }).ToList();
                foreach (var GrandExam in mainExamResult)
                {
                    cr.results = GrandExam;
                    break;
                }
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();

            }

            return Json(cr);
        }
       
        [Route("GrandResult/DeleteMainExam/")]
        [HttpPut]
        public IHttpActionResult DeleteGrandExam(GrandExam mainExam)
        {
            CommonResponse cr = new CommonResponse();
            var GrandSubExam = DataAccess.Instance.GrandSubExamService.Filter(s => s.GrandExamId == mainExam.GrandExamId && s.IsDeleted == false).ToList();
            var GrandExamSetup = DataAccess.Instance.GrandExamMarkSetupService.Filter(m => m.GrandExamId == mainExam.GrandExamId && m.IsDeleted == false).ToList();
            if (GrandSubExam.Any())     //P1 Check Grand SubExam
            {
                return BadRequest("Grand Sub Exam Exists.You can not delete.");
            }
            else if (GrandExamSetup.Any())    //P2 Check GrandExamMarkSetup
            {
                return BadRequest("Grand Exam Mark Setup Exists.You can not delete.");
            }
            else
            {
                mainExam.IsDeleted = true;
                mainExam.UpdateBy = User.Identity.Name;
                mainExam.SetDate();
                var res = DataAccess.Instance.GrandExamService.Update(mainExam);  //P3 UPDATE DELETE SATATUS 
                if (res)   //P4 CHECK AND RETURN GRAND EXAM LIST
                {
                    var mainExamResult = DataAccess.Instance.GrandExamService.Filter(s => s.IsDeleted == false, o => o.OrderBy(i => i.GrandExamId), new string[] { "ClassInfo", "Session" }).ToList();
                    cr.results = mainExamResult;
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.FAILED;
                }
                return Json(cr);
            }
        }
        [Route("GrandResult/GetSubjectByGrandExamIds/{GrandExamIds}")]  // Using for Exam List Page  inside Show Button
        [HttpGet]
        public IHttpActionResult GetSubjectByGrandExamIds(string GrandExamIds)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                DataTable dtResult = new DataTable();
                List<SubjectSetup> sms = new List<SubjectSetup>();
                #region WHERE
                System.Text.StringBuilder whereClause = new System.Text.StringBuilder();
                whereClause.Append(" IsDeleted=0 ");
                if (!string.IsNullOrWhiteSpace(GrandExamIds))
                {
                    whereClause.Append(" AND  GrandExamId  IN (" + GrandExamIds.Trim(',') + ") ");
                }
                #endregion WHERE
                object[] Param = new object[] { whereClause.ToString(), 1 };
                dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSubjectByGrandExam", Param);
                sms = Api.APIUitility.ConvertDataTable<SubjectSetup>(dtResult);
                cr.results = sms;

                cr.httpStatusCode = sms.Any() ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = sms.Any() ? Constant.SUCCESS : "Data Not Found";
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        [Route("GrandResult/GetNoOfSubjectByGrandExamIds/{GrandExamIds}")]  // Using for Exam List Page  inside Show Button
        [HttpGet]
        public IHttpActionResult GetNoOfSubjectByGrandExamIds(string GrandExamIds)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                DataTable dtResult = new DataTable();
                //List<SubjectSetup> sms = new List<SubjectSetup>();
                #region WHERE
                System.Text.StringBuilder whereClause = new System.Text.StringBuilder();
                whereClause.Append(" IsDeleted=0 ");
                if (!string.IsNullOrWhiteSpace(GrandExamIds))
                {
                    whereClause.Append(" AND  GrandExamId  IN (" + GrandExamIds.Trim(',') + ") ");
                }
                #endregion WHERE
                object[] Param = new object[] { whereClause.ToString(), 3 };
                dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSubjectByGrandExam", Param);
                //sms = Api.APIUitility.ConvertDataTable<SubjectSetup>(dtResult);
                cr.results = dtResult;

                cr.httpStatusCode = dtResult.Rows.Count > 0 ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = dtResult.Rows.Count > 0 ? Constant.SUCCESS : "Data Not Found";
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        [Route("GrandResult/GetGradeByGrandExamIds/{GrandExamIds}")]  // Using for Exam List Page  inside Show Button
        [HttpGet]
        public IHttpActionResult GetGradeByGrandExamIds(string GrandExamIds)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                DataTable dtResult = new DataTable();
                List<GradingSystem> sms = new List<GradingSystem>();
                #region WHERE
                System.Text.StringBuilder whereClause = new System.Text.StringBuilder();
                whereClause.Append(" IsDeleted=0 ");
                if (!string.IsNullOrWhiteSpace(GrandExamIds))
                {
                    whereClause.Append(" AND  GrandExamId  IN (" + GrandExamIds.Trim(',') + ") ");
                }
                #endregion WHERE
                object[] Param = new object[] { whereClause.ToString(), 2 };
                dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSubjectByGrandExam", Param);
                sms = Api.APIUitility.ConvertDataTable<GradingSystem>(dtResult);
                cr.results = sms;

                cr.httpStatusCode = sms.Any() ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = sms.Any() ? Constant.SUCCESS : "Data Not Found";
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        #endregion Grand Exam    
        #region Sub Exam
        [Route("GrandResult/AddSubExam/")]
        [HttpPost]
        public IHttpActionResult AddSubExam(GrandSubExam subExam)
        {
            CommonResponse cr = new CommonResponse();
            var ExistingExam = DataAccess.Instance.GrandSubExamService.Filter(s => s.GrandSubExamName == subExam.GrandSubExamName
            && s.GrandExamId == subExam.GrandExamId && s.IsDeleted == false).ToList();
            if (ExistingExam.Any())  //P1 CHECK GRAND SUB EXAM NAME
                return BadRequest("Exam Name already exist");
            subExam.IsDeleted = false;
            subExam.AddBy = User.Identity.Name;
            subExam.IsDeleted = false;
            subExam.SetDate();
            subExam.Status = "A";
            var res = DataAccess.Instance.GrandSubExamService.Add(subExam);
            if (res)  //P2 IF ADD SUCCESSFULLY THEN RETURN GRAND SUB EXAM 
            {
                var subExamResult = DataAccess.Instance.GrandSubExamService.Filter(s => s.GrandExamId == subExam.GrandExamId && s.IsDeleted == false).ToList();
                cr.results = subExamResult;
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            return Json(cr);
        }
        [Route("GrandResult/GetAllGrandSubExam/")] //    // Using for Exam Edit Wizard inside main exam save method
        [HttpGet]
        public IHttpActionResult GetAllSubExam()
        {
            CommonResponse cr = new CommonResponse();
            var res = DataAccess.Instance.GrandSubExamService.GetAll().Where(c => c.IsDeleted == false);
            if (res.Any())        //P1 RETURN ALL GRAND SUB EXAM 
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/GetSubExamByMainExamID/{mainExamID}/")] //    // Using for Exam Edit Wizard inside main exam save method
        [HttpGet]
        public IHttpActionResult GetSubExamByMainExamID(int mainExamID)
        {
            CommonResponse cr = new CommonResponse();
            var res = DataAccess.Instance.GrandSubExamService.Filter(s => s.GrandExamId == mainExamID && s.IsDeleted == false).ToList();
            if (res.Any()) //P1 RETURN GRAND SUB EXAM FILTER BY GRAND EXAM ID
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/GetSubExam/{mainExamID}/{subExamName}")]
        [HttpGet]
        public IHttpActionResult GetSubExam(int mainExamID, string subExamName)
        {
            CommonResponse cr = new CommonResponse();
            var res = DataAccess.Instance.GrandSubExamService.Filter(s => s.GrandSubExamName == subExamName && s.GrandExamId == mainExamID && s.IsDeleted == false).ToList();
            if (res.Any())       //P1 RETURN GRAND SUB EXAM FILTER BY GRAND SUB EXAM NAME AND GRAND EXAM ID
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/UpdateSubExam/")]
        [HttpPut]
        public IHttpActionResult UpdateSubExam(GrandSubExam subExam)
        {

            //subExam. = null;
            CommonResponse cr = new CommonResponse();
            bool res = false;
            if (subExam.GrandSubExamId == 0)   //P1 RETURN IF GRAND EXAM ID 0
            {
                return AddSubExam(subExam);
            }
            else
            {
                var oldsubexam= DataAccess.Instance.GrandSubExamService.Get(subExam.GrandSubExamId);
                subExam.AddBy = oldsubexam.AddBy;
                subExam.AddDate = oldsubexam.AddDate;
                subExam.IsDeleted = oldsubexam.IsDeleted;
                subExam.Status = oldsubexam.Status;
                subExam.UpdateBy = User.Identity.Name;
                subExam.SetDate();
                res = DataAccess.Instance.GrandSubExamService.Update(subExam);
                if (res)         // P2 UPDATE GRAND SUB EXAM AND RETURN GRAND SUB EXAM
                {
                    var subExamResult = DataAccess.Instance.GrandSubExamService.Filter(s => s.GrandExamId == subExam.GrandExamId
                    && s.IsDeleted == false).ToList();
                    cr.results = subExamResult;
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.FAILED;
                }
            }
            return Json(cr);
        }
        [Route("GrandResult/DeleteSubExam/{subExamID}")]
        [HttpDelete]
        public IHttpActionResult DeleteSubExam(int subExamID)
        {
            CommonResponse cr = new CommonResponse();
            var GrandDividedExam = DataAccess.Instance.GrandDividedExamService.Filter(s => s.GrandSubExamId == subExamID && s.IsDeleted == false).ToList();
            var SubExamSetup = DataAccess.Instance.GrandSubExamMarkSetupService.Filter(m => m.SubExamId == subExamID && m.IsDeleted == false).ToList();
            if (GrandDividedExam.Any())    //P1 CHECK GRAND DIVIDED EXAM IF EXISTS THEN RETURN
            {
                return BadRequest("Grand Divided Exam Exists.You can not delete.");
            }
            else if (SubExamSetup.Any())    //P2 CHECK GRAND SUB EXAM MARK SETUP IF EXISTS THEN RETURN
            {
                return BadRequest("Grand Sub Exam Mark Setup Exists.You can not delete.");
            }
            else
            {
                GrandSubExam osubExam = new GrandSubExam();
                osubExam = DataAccess.Instance.GrandSubExamService.FirstOrDefault(s => s.GrandSubExamId == subExamID);
                osubExam.IsDeleted = true;
                osubExam.UpdateBy = User.Identity.Name;
                osubExam.SetDate();
                var res = DataAccess.Instance.GrandSubExamService.Update(osubExam);
                if (res)       //P3 DELETE THEN RETURN SUBEXAM LIST
                {
                    var subExamResult = DataAccess.Instance.GrandSubExamService.Filter(s => s.GrandExamId == osubExam.GrandExamId && s.IsDeleted == false).ToList();
                    cr.results = subExamResult;
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.FAILED;
                }
                return Json(cr);
            }
        }
        #endregion Sub Exam   
        #region Divided Exam
        [Route("GrandResult/AddDividedExam/")]
        [HttpPost]
        public IHttpActionResult AddDividedExam(GrandDividedExam dividedExam)
        {
            CommonResponse cr = new CommonResponse();
            var ExistingExam = DataAccess.Instance.GrandDividedExamService.Filter(s => (s.DividedExamName == dividedExam.DividedExamName || s.DividedExamType == dividedExam.DividedExamType) && s.GrandSubExamId == dividedExam.GrandSubExamId && s.IsDeleted == false).ToList();
            if (ExistingExam.Any())   //P1 CHECK GRAND DIVIDED EXAM EXISTS OR NOT
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = "Exam  already exist";
                return Json(cr);
            }
            dividedExam.IsDeleted = false;
            dividedExam.AddBy = User.Identity.Name;
            dividedExam.SetDate();
            dividedExam.Status = "A";
            var res = DataAccess.Instance.GrandDividedExamService.Add(dividedExam); //P2 ADD GRAND EXAM
            if (res)
            {
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            return Json(cr);
        }
        [Route("GrandResult/GetAllGrandDividedExam/")]
        [HttpGet]
        public IHttpActionResult GetAllGrandDividedExam()
        {
            CommonResponse cr = new CommonResponse();
            var res = DataAccess.Instance.GrandDividedExamService.GetAll().Where(c=>c.IsDeleted == false);
            if (res.Any())   //P1 PULL GRAND DIVIDED EXAM THEN RETURN GRND DIVIDED EXAM
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/GetDividedExamBySubExamID/{SubExamID}")]
        [HttpGet]
        public IHttpActionResult GetDividedExam(int subExamID)
        {
            CommonResponse cr = new CommonResponse();
            var res = DataAccess.Instance.GrandDividedExamService.Filter(s => s.GrandSubExamId == subExamID && s.IsDeleted == false, o => o.OrderBy(i => i.GrandDividedExamId), new string[] { "GrandSubExam" }).ToList();
            if (res.Any())   //P1 PULL GRAND DIVIDED EXAM BY SUB EXAM ID THEN RETURN GRND DIVIDED EXAM
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/GetDividedExamByMainExamID/{GrandExamId}")]
        [HttpGet]
        public IHttpActionResult GetDividedExamByMainExamId(int GrandExamId)
        {
            CommonResponse cr = new CommonResponse();
            //P1 Get Sub Exam ID filter BY MAIN EXAM ID
            var SubExam = DataAccess.Instance.GrandSubExamService.Filter(e => e.GrandExamId == GrandExamId && e.IsDeleted == false).ToList();
            List<GrandDividedExam> listDivs = new List<GrandDividedExam>();
            foreach (var item in SubExam)
            {
                var res = DataAccess.Instance.GrandDividedExamService.Filter(s => s.GrandSubExamId == item.GrandSubExamId && s.IsDeleted == false, o => o.OrderBy(i => i.GrandDividedExamId), new string[] { "GrandSubExam" }).ToList();
                //P2 GET DIVIDED EXAM BY SUB EXAM ID
                res.Select(c => { c.GrandSubExamName = item.GrandSubExamName; return c; }).ToList();   // Need correction
                //P3 ADD GRAND SUB EXAM NAME IN LIST VARIABLE
                listDivs.AddRange(res);

            }
            if (listDivs.Any())   //P4 RETURN LIST VARIABLE IF EXIST
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = listDivs;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/GetDividedExam/{subExamID}/{dividedExamName}")]
        [HttpGet]
        public IHttpActionResult GetDividedExam(int subExamID, string dividedExamName)
        {
            CommonResponse cr = new CommonResponse();
            var res = DataAccess.Instance.GrandDividedExamService.Filter(s => s.DividedExamName == dividedExamName && s.GrandSubExamId == subExamID && s.IsDeleted == false, o => o.OrderBy(i => i.GrandDividedExamId), new string[] { "SubExam" }).ToList();
            //P1 GET DIVIDED EXAM FILTER BY SUBEXAM ID AND DIVIDED EXAM NAME
            if (res.Any())
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/UpdateDividedExam")]
        [HttpPut]
        public IHttpActionResult UpdateDividedExam(GrandDividedExam dividedExam)
        {
            CommonResponse cr = new CommonResponse();
            var ExistingExam = DataAccess.Instance.GrandDividedExamService.Filter(s => (s.DividedExamType == dividedExam.DividedExamType) && s.GrandSubExamId == dividedExam.GrandSubExamId
                            && s.GrandDividedExamId != dividedExam.GrandDividedExamId && s.IsDeleted == false).ToList();
            if (ExistingExam.Any())     //P1    CHECK DIVIDED   NAME
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = "Exam  already exist";
                return Json(cr);
            }
            var res = false;
            //dividedExam. = null;
            if (dividedExam.GrandDividedExamId == 0)         //P2 IF DIVIDED EXAM NO NOT  0 THEN UPDATE
            {
                return AddDividedExam(dividedExam);
            }
            else
            {
                dividedExam.UpdateBy = User.Identity.Name;
                dividedExam.SetDate();
                res = DataAccess.Instance.GrandDividedExamService.Update(dividedExam);
            }
            if (res)
            {

                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            return Json(cr);
        }
        //[Route("GrandResult/DeleteDividedExam/{dividedExamId}")]
        [Route("GrandResult/DeleteDividedExam/")]
        [HttpPut]
        public IHttpActionResult DeleteDividedExam(GrandDividedExam dividedExam)
        {
            CommonResponse cr = new CommonResponse();
            var DivExamSetup = DataAccess.Instance.GrandDividedExamMarkSetupService.Filter(m => m.DividedExamId == dividedExam.GrandDividedExamId && m.IsDeleted == false).ToList();
            if (DivExamSetup.Any())
            {
                return BadRequest("Divided Exam Mark Setup Exists.You can not delete.");
            }
            else
            {
                dividedExam.IsDeleted = true;
                dividedExam.UpdateBy = User.Identity.Name;
                dividedExam.SetDate();
                var res = DataAccess.Instance.GrandDividedExamService.Update(dividedExam);
                if (res)
                {
                    var dividedbExamResult = DataAccess.Instance.GrandDividedExamService.Filter(s => s.GrandSubExamId == dividedExam.GrandSubExamId && s.IsDeleted == false, o => o.OrderBy(i => i.GrandDividedExamId), new string[] { "GrandSubExam" }).ToList();
                    cr.results = dividedbExamResult;
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.FAILED;
                }
                return Json(cr);
            }
        }
        #endregion Divided Exam    
        #region GrandExamMarkSetup
        [Route("GrandResult/AddMainExamMark/")]
        [HttpPost]
        public IHttpActionResult AddMainExamMark(List<GrandExamSubjectMark> VmainExamMark)
        {
            GrandExamMarkSetup mainExamMark = new GrandExamMarkSetup();
            CommonResponse cr = new CommonResponse();
            bool res = false;
            try
            {
                foreach (var mainExamSubjectMark in VmainExamMark)
                {
                    mainExamMark.VersionId = mainExamSubjectMark.VersionId;
                    mainExamMark.SessionId = mainExamSubjectMark.SessionId;
                    mainExamMark.ClassId = mainExamSubjectMark.ClassId;
                    mainExamMark.GroupId = mainExamSubjectMark.GroupId;
                    mainExamMark.GrandExamId = mainExamSubjectMark.GrandExamId;

                    var checkExists = DataAccess.Instance.GrandExamMarkSetupService.Filter(m => m.VersionId == mainExamSubjectMark.VersionId
                    && m.SessionId == mainExamSubjectMark.SessionId && m.ClassId == mainExamSubjectMark.ClassId && m.GroupId == mainExamSubjectMark.GroupId
                    && m.GrandExamId == mainExamSubjectMark.GrandExamId && m.ExamSubjectID == mainExamSubjectMark.ExamSubjectID
                    && m.ExamFullMarks == mainExamSubjectMark.ExamFullMarks && m.ExamIsPassDepend == mainExamSubjectMark.ExamIsPassDepend
                    && m.ExamPassMark == mainExamSubjectMark.ExamPassMark && m.ExamPassMarkIsPercent == mainExamSubjectMark.ExamPassMarkIsPercent
                    && m.IsDeleted == mainExamSubjectMark.IsDeleted).ToList();
                    if (checkExists.Any())           //P1 CHECK GRAND EXAM MARK SETUP IF EXISTS THEN SKIP CURRENT SUBJECT
                        continue;                      
                    var result = DataAccess.Instance.MainExamMarksService.Filter(m => m.MainExamID == mainExamSubjectMark.GrandExamId && m.SubjectID == mainExamSubjectMark.ExamSubjectID && m.IsDeleted == false);
                    //P2 CHECK MAIN EXAM MARK   
                    if (User.IsInRole("Super"))     
                    {
                        string s = User.Identity.Name;
                    }
                    if (result.Any() && (!User.IsInRole("Super")))   //P3 IF MARKS EXIST AND ROLE NOT SUPER THEN SKIP CURRENT SUBJECT
                        continue;
                    #region TotalSubject MarkSetup
                    var TotalSubject = DataAccess.Instance.SubjectSetup.FirstOrDefault(s => s.IsDeleted == false && s.IsPair == true &&
                                       s.SubID == mainExamSubjectMark.ExamSubjectID && (s.FirstPairSubID != 0 && s.SecondPairSubID != 0));
                    if (TotalSubject != null)    //P4 CHECK CURRENT SUBJECT IS TOTAL OR NOT 
                    {
                        var TotalSubjectMarkSetup = DataAccess.Instance.GrandExamMarkSetupService.FirstOrDefault(s => s.VersionId == mainExamSubjectMark.VersionId
                                   && s.SessionId == mainExamSubjectMark.SessionId && s.GroupId == mainExamSubjectMark.GroupId && s.ClassId == mainExamSubjectMark.ClassId
                                   && s.GrandExamId == mainExamSubjectMark.GrandExamId && s.ExamSubjectID == mainExamSubjectMark.ExamSubjectID && s.IsDeleted == false);
                        if (TotalSubjectMarkSetup != null)   //P5 IF TOTAL SUBJECT MARK SETUP EXISTS THEN  UPDATE 
                        {
                            TotalSubjectMarkSetup.ExamIsPassDepend = mainExamSubjectMark.ExamIsPassDepend;
                            TotalSubjectMarkSetup.ExamPassMark = mainExamSubjectMark.ExamPassMark;
                            TotalSubjectMarkSetup.ExamPassMarkIsPercent = mainExamSubjectMark.ExamPassMarkIsPercent;
                            TotalSubjectMarkSetup.UpdateBy = User.Identity.Name;
                            TotalSubjectMarkSetup.SetDate();
                            res = DataAccess.Instance.GrandExamMarkSetupService.Update(TotalSubjectMarkSetup);
                            if (res)
                            {
                                mainExamMark.VersionId = TotalSubjectMarkSetup.VersionId;
                                mainExamMark.SessionId = TotalSubjectMarkSetup.SessionId;
                                mainExamMark.ClassId = TotalSubjectMarkSetup.ClassId;
                                mainExamMark.GroupId = TotalSubjectMarkSetup.GroupId;
                                mainExamMark.GrandExamId = TotalSubjectMarkSetup.GrandExamId;
                            }

                        }
                    }
                    #endregion TotalSubject MarkSetup
                    else
                    {
                        if (mainExamSubjectMark.GrandExamMarkSetupId == 0 && mainExamSubjectMark.ExamFullMarks != 0)  //P6 CHECK MARK SETUP ID ZERO AND FULL MARKS NOT ZERO THEN ADD MARKS SETUP
                        {
                            mainExamMark.GrandExamMarkSetupId = mainExamSubjectMark.GrandExamMarkSetupId;
                            mainExamMark.VersionId = mainExamSubjectMark.VersionId;
                            mainExamMark.SessionId = mainExamSubjectMark.SessionId;
                            mainExamMark.ClassId = mainExamSubjectMark.ClassId;
                            mainExamMark.GroupId = mainExamSubjectMark.GroupId;
                            mainExamMark.GrandExamId = mainExamSubjectMark.GrandExamId;
                            mainExamMark.ExamSubjectID = mainExamSubjectMark.ExamSubjectID;
                            mainExamMark.ExamFullMarks = mainExamSubjectMark.ExamFullMarks;
                            mainExamMark.ExamIsPassDepend = mainExamSubjectMark.ExamIsPassDepend;
                            mainExamMark.ExamPassMark = mainExamSubjectMark.ExamPassMark;
                            mainExamMark.ExamPassMarkIsPercent = mainExamSubjectMark.ExamPassMarkIsPercent;
                            mainExamMark.IsDeleted = false;
                            mainExamMark.AddBy = User.Identity.Name;
                            mainExamMark.SetDate();
                            mainExamMark.Status = "A";
                            res = DataAccess.Instance.GrandExamMarkSetupService.Add(mainExamMark);
                            #region Auto Marksetup for Total Subject
                            if (res)
                            {
                                var pair = DataAccess.Instance.SubjectSetup.FirstOrDefault(s => s.IsDeleted == false && s.IsPair == true &&
                                (s.FirstPairSubID == mainExamMark.ExamSubjectID || s.SecondPairSubID == mainExamMark.ExamSubjectID)
                                 && (s.FirstPairSubID != 0 && s.SecondPairSubID != 0)
                                );
                                if (pair != null)    //P7 CHECK CURRENT SUBJECT IS PAIR THEN ADD TOTAL SUBJECT MARK SETUP
                                {
                                    var pairMarkSetup = DataAccess.Instance.GrandExamMarkSetupService.FirstOrDefault(s => s.VersionId == mainExamMark.VersionId
                                    && s.SessionId == mainExamMark.SessionId && s.GroupId == mainExamMark.GroupId && s.ClassId == mainExamMark.ClassId
                                    && s.GrandExamId == mainExamMark.GrandExamId && s.ExamSubjectID == pair.SubID && s.IsDeleted == false);
                                    if (pairMarkSetup == null)     //P8 CHECK TOTAL SUBJECT MARK SETUP IF NOT EXISTS THEN ADD MARK SETUP
                                    {
                                        mainExamMark.GrandExamMarkSetupId = 0;
                                        mainExamMark.ExamSubjectID = pair.SubID;
                                        mainExamMark.ExamIsPassDepend = false;
                                        mainExamMark.ExamPassMark = 0;
                                        mainExamMark.ExamPassMarkIsPercent = false;
                                        mainExamMark.Status = "A";
                                        mainExamMark.AddBy = User.Identity.Name;
                                        mainExamMark.IsDeleted = false;
                                        mainExamMark.SetDate();
                                        res = DataAccess.Instance.GrandExamMarkSetupService.Add(mainExamMark);
                                    }
                                    else
                                    {
                                        var firstpair = pair.FirstPairSubID == mainExamMark.ExamSubjectID;
                                        if (firstpair) //P9 CHECK FIRST PAIR SUBJECT IS TRUE THEN FETCH SECOND PAIR SUBJECT 
                                        {
                                            var secondPairMarkSetup = DataAccess.Instance.GrandExamMarkSetupService.FirstOrDefault(s => s.VersionId == mainExamMark.VersionId
                                            && s.SessionId == mainExamMark.SessionId && s.GroupId == mainExamMark.GroupId && s.ClassId == mainExamMark.ClassId
                                            && s.GrandExamId == mainExamMark.GrandExamId && s.ExamSubjectID == pair.SecondPairSubID && s.IsDeleted == false);
                                            if (secondPairMarkSetup == null)    // P10 CHECK SECOND PARI SUBJECT ID MARK SETUP EXISTS OR NOT
                                            {
                                                pairMarkSetup.ExamFullMarks = mainExamMark.ExamFullMarks;
                                            }
                                            else
                                            {
                                                pairMarkSetup.ExamFullMarks = mainExamMark.ExamFullMarks + secondPairMarkSetup.ExamFullMarks;
                                            }
                                            res = DataAccess.Instance.GrandExamMarkSetupService.Update(pairMarkSetup);   //P11 UPDATE TOTAL SUBJECT MARK SETUP  
                                        }
                                        else
                                        {
                                            var secondPair = pair.SecondPairSubID == mainExamMark.ExamSubjectID;
                                            if (secondPair) //P12 CHECK SECOND PAIR SUBJECT IS TRUE THEN FETCH FIRST PAIR SUBJECT 
                                            {
                                                var firstPairMarkSetup = DataAccess.Instance.GrandExamMarkSetupService.FirstOrDefault(s => s.VersionId == mainExamMark.VersionId
                                                && s.SessionId == mainExamMark.SessionId && s.GroupId == mainExamMark.GroupId && s.ClassId == mainExamMark.ClassId
                                                && s.GrandExamId == mainExamMark.GrandExamId && s.ExamSubjectID == pair.FirstPairSubID && s.IsDeleted == false);
                                                if (firstPairMarkSetup == null)
                                                {
                                                    pairMarkSetup.ExamFullMarks = mainExamMark.ExamFullMarks;
                                                }
                                                else
                                                {
                                                    pairMarkSetup.ExamFullMarks = mainExamMark.ExamFullMarks + firstPairMarkSetup.ExamFullMarks;
                                                }
                                                res = DataAccess.Instance.GrandExamMarkSetupService.Update(pairMarkSetup); //P13 UPDATE TOTAL SUBJECT MARK SETUP
                                            }
                                        }
                                    }
                                }
                            }
                            #endregion Auto Marksetup for Total Subject
                        }
                        else if (mainExamSubjectMark.GrandExamMarkSetupId != 0 && mainExamSubjectMark.ExamFullMarks != 0)  //P14 CHECK MARK SETUP ID AND FULL MARKS NOT ZERO THEN UPDATE MARKS SETUP
                        {
                            var ExistingMainExamMark = DataAccess.Instance.GrandExamMarkSetupService.Filter(s => s.GrandExamMarkSetupId == mainExamSubjectMark.GrandExamMarkSetupId && s.VersionId == mainExamSubjectMark.VersionId && s.SessionId == mainExamSubjectMark.SessionId
                            && s.ClassId == mainExamSubjectMark.ClassId && s.GroupId == mainExamSubjectMark.GroupId && s.ExamSubjectID == mainExamSubjectMark.ExamSubjectID
                            && s.GrandExamId == mainExamSubjectMark.GrandExamId && s.ExamFullMarks == mainExamSubjectMark.ExamFullMarks && s.ExamPassMark == mainExamSubjectMark.ExamPassMark
                            && s.ExamIsPassDepend == mainExamSubjectMark.ExamIsPassDepend && s.ExamPassMarkIsPercent == mainExamSubjectMark.ExamPassMarkIsPercent && s.IsDeleted == false).ToList();
                            if (!ExistingMainExamMark.Any())
                            {
                                mainExamMark.GrandExamMarkSetupId = mainExamSubjectMark.GrandExamMarkSetupId;
                                mainExamMark.VersionId = mainExamSubjectMark.VersionId;
                                mainExamMark.SessionId = mainExamSubjectMark.SessionId;
                                mainExamMark.ClassId = mainExamSubjectMark.ClassId;
                                mainExamMark.GroupId = mainExamSubjectMark.GroupId;
                                mainExamMark.GrandExamId = mainExamSubjectMark.GrandExamId;
                                mainExamMark.ExamSubjectID = mainExamSubjectMark.ExamSubjectID;
                                mainExamMark.ExamFullMarks = mainExamSubjectMark.ExamFullMarks;
                                mainExamMark.ExamIsPassDepend = mainExamSubjectMark.ExamIsPassDepend;
                                mainExamMark.ExamPassMark = mainExamSubjectMark.ExamPassMark;
                                mainExamMark.ExamPassMarkIsPercent = mainExamSubjectMark.ExamPassMarkIsPercent;
                                mainExamMark.IsDeleted = false;
                                mainExamMark.AddBy = mainExamSubjectMark.AddBy;
                                mainExamMark.AddDate = mainExamSubjectMark.AddDate;
                                mainExamMark.UpdateBy = User.Identity.Name;
                                mainExamMark.SetDate();
                                mainExamMark.Status = "A";
                                res = DataAccess.Instance.GrandExamMarkSetupService.Update(mainExamMark);
                                #region Auto MarkUpdte for Total Subject
                                if (res)
                                {
                                    var pair = DataAccess.Instance.SubjectSetup.FirstOrDefault(s => s.IsDeleted == false && s.IsPair == true &&
                                    (s.FirstPairSubID == mainExamMark.ExamSubjectID || s.SecondPairSubID == mainExamMark.ExamSubjectID)
                                     && (s.FirstPairSubID != 0 && s.SecondPairSubID != 0)
                                    );
                                    if (pair != null)
                                    {
                                        var pairMarkSetup = DataAccess.Instance.GrandExamMarkSetupService.FirstOrDefault(s => s.VersionId == mainExamMark.VersionId
                                        && s.SessionId == mainExamMark.SessionId && s.GroupId == mainExamMark.GroupId && s.ClassId == mainExamMark.ClassId
                                        && s.GrandExamId == mainExamMark.GrandExamId && s.ExamSubjectID == pair.SubID && s.IsDeleted == false);
                                        if (pairMarkSetup != null)
                                        {
                                            var firstpair = pair.FirstPairSubID == mainExamMark.ExamSubjectID;
                                            if (firstpair)
                                            {
                                                var secondPairMarkSetup = DataAccess.Instance.GrandExamMarkSetupService.FirstOrDefault(s => s.VersionId == mainExamMark.VersionId
                                                && s.SessionId == mainExamMark.SessionId && s.GroupId == mainExamMark.GroupId && s.ClassId == mainExamMark.ClassId
                                                && s.GrandExamId == mainExamMark.GrandExamId && s.ExamSubjectID == pair.SecondPairSubID && s.IsDeleted == false);
                                                if (secondPairMarkSetup == null)
                                                {
                                                    pairMarkSetup.ExamFullMarks = mainExamMark.ExamFullMarks;
                                                }
                                                else
                                                {
                                                    pairMarkSetup.ExamFullMarks = mainExamMark.ExamFullMarks + secondPairMarkSetup.ExamFullMarks;
                                                }
                                                res = DataAccess.Instance.GrandExamMarkSetupService.Update(pairMarkSetup);
                                            }
                                            else
                                            {
                                                var secondPair = pair.SecondPairSubID == mainExamMark.ExamSubjectID;
                                                if (secondPair)
                                                {
                                                    var firstPairMarkSetup = DataAccess.Instance.GrandExamMarkSetupService.FirstOrDefault(s => s.VersionId == mainExamMark.VersionId
                                                    && s.SessionId == mainExamMark.SessionId && s.GroupId == mainExamMark.GroupId && s.ClassId == mainExamMark.ClassId
                                                    && s.GrandExamId == mainExamMark.GrandExamId && s.ExamSubjectID == pair.FirstPairSubID && s.IsDeleted == false);
                                                    if (firstPairMarkSetup == null)
                                                    {
                                                        pairMarkSetup.ExamFullMarks = mainExamMark.ExamFullMarks;
                                                    }
                                                    else
                                                    {
                                                        pairMarkSetup.ExamFullMarks = mainExamMark.ExamFullMarks + firstPairMarkSetup.ExamFullMarks;
                                                    }
                                                    res = DataAccess.Instance.GrandExamMarkSetupService.Update(pairMarkSetup);
                                                }
                                            }
                                        }
                                    }
                                }
                                #endregion Auto MarkUpdate for Total Subject
                            }
                        }
                    }
                }        
                           
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : "No Changes Found.";
                //P15 AFTER COMPLETE ALL SUBJECT THEN RETURN ALL SUBJECT MARK SETUP    
                object[] param = new object[5];
                param[0] = mainExamMark.VersionId;
                param[1] = mainExamMark.SessionId;
                param[2] = mainExamMark.ClassId;
                param[3] = mainExamMark.GroupId;
                param[4] = mainExamMark.GrandExamId;
                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandGetAllExamMarkSubject", param);
                List<GrandExamSubjectMark> _MainExamSubjectMark = APIUitility.ConvertDataTable<GrandExamSubjectMark>(dt);
                cr.results = _MainExamSubjectMark;
            }
            catch (Exception ex)
            {
                object[] param = new object[5];
                param[0] = mainExamMark.VersionId;
                param[1] = mainExamMark.SessionId;
                param[2] = mainExamMark.ClassId;
                param[3] = mainExamMark.GroupId;
                param[4] = mainExamMark.GrandExamId;
                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandGetAllExamMarkSubject", param);
                List<GrandExamSubjectMark> _MainExamSubjectMark = APIUitility.ConvertDataTable<GrandExamSubjectMark>(dt);
                cr.results = _MainExamSubjectMark;
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("GrandResult/GetMainExamSubject/{versionId}/{sessionID}/{classId}/{groupId}/{mainExamID}")]
        [HttpGet]
        public IHttpActionResult GetMainExamSubject(int versionID, int sessionID, int classID, string groupID, int mainExamID)
        {
            CommonResponse cr = new CommonResponse();
            object[] param = new object[5];
            param[0] = versionID;
            param[1] = sessionID;
            param[2] = classID;
            if (groupID == "null" || groupID == "undefined")
            {
                param[3] = 0;
            }
            else
            {
                param[3] = Convert.ToInt32(groupID);
            }
            param[4] = mainExamID;
            DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandGetAllExamMarkSubject", param);
            List<GrandExamSubjectMark> _MainExamSubjectMark = APIUitility.ConvertDataTable<GrandExamSubjectMark>(dt);
            //P1 Get All Subject for Grand Exam Mark Setup
            if (_MainExamSubjectMark.Any())
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = _MainExamSubjectMark;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/UpdateMainExamMark/")]
        [HttpPut]
        public IHttpActionResult UpdateMainExamMark(GrandExamMarkSetup mainExamMark)
        {
            CommonResponse cr = new CommonResponse();
            var res = false;
            //Service will be change
            var result = DataAccess.Instance.MainExamMarksService.Filter(m => m.MainExamID == mainExamMark.GrandExamId && m.SubjectID == mainExamMark.ExamSubjectID && m.IsDeleted == false);
            if (result.Any() && (!User.IsInRole("Super")))    // P1 check Subject Grand Exam mark Exist or not
            {

                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = "Opps! Marks Exists";
                return Json(cr);
            }

            // P2 IF MARK EXISTS AND SUPER USER THEN UPDATE OR MARK NOT EXISTS THEN UPDATE
            mainExamMark.UpdateBy = User.Identity.Name;
            mainExamMark.SetDate();
            res = DataAccess.Instance.GrandExamMarkSetupService.Update(mainExamMark);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }
        [Route("GrandResult/BulkUpdateMainExamMark/")]
        [HttpPut]
        public IHttpActionResult BulkUpdateMainExamMark(List<GrandExamMarkSetup> MainExamMarkSetups)
        {
            CommonResponse cr = new CommonResponse();
            bool res = false;
            foreach (var s in MainExamMarkSetups)
            {
                var result = DataAccess.Instance.MainExamMarksService.Filter(m => m.MainExamID == s.GrandExamId && m.SubjectID == s.ExamSubjectID && m.IsDeleted == false);
                if (result.Any() && (!User.IsInRole("Super"))) //P1 check Subject Grand Exam mark Exist or not
                {

                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = "Opps! Marks Exists";
                    return Json(cr);
                }
                // P2 IF MARK EXISTS AND SUPER USER THEN UPDATE OR MARK NOT EXISTS THEN UPDATE
                s.UpdateBy = User.Identity.Name;
                s.SetDate();
                res = DataAccess.Instance.GrandExamMarkSetupService.Update(s);
            }
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }
        [Route("GrandResult/DeleteMainExamMark/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteMainExamMark(int id)
        {
            CommonResponse cr = new CommonResponse();
            bool res = false;
            try
            {
                bool ChildSubExists = false;
               
                GrandExamMarkSetup oMainExamMarkSetup = new GrandExamMarkSetup();
                oMainExamMarkSetup = DataAccess.Instance.GrandExamMarkSetupService.FirstOrDefault(id);
                if (oMainExamMarkSetup != null)
                {
                    DataTable d = new DataTable();
                    string sql = "SELECT [GrandExamId], [GrandSubExamId], [StudentIID] FROM [Res_GrandResultMarksDetails] WHERE GrandExamId=" + oMainExamMarkSetup.GrandExamId;
                    d = DataAccess.Instance.CommonServices.ExecuteSQLQUERY(sql);
                    if (d.Rows.Count > 0 && (!User.IsInRole("Super")))
                    {
                        throw new Exception("Oops! Grand process exists and you have not super role");
                    }
                }
                //Service will be change
                if(oMainExamMarkSetup == null)
                {
                    return BadRequest("Opps! Subject Marks Setup Doesn't Exists");
                }
                var result = DataAccess.Instance.GrandConfigService.Filter(m => m.GrandExamId == oMainExamMarkSetup.GrandExamId && m.SubjectId == oMainExamMarkSetup.ExamSubjectID && m.IsDeleted == false);
                var TotalSubject = DataAccess.Instance.SubjectSetup.FirstOrDefault(s => s.IsDeleted == false && s.IsPair == true &&
                            s.SubID == oMainExamMarkSetup.ExamSubjectID && (s.FirstPairSubID != 0 && s.SecondPairSubID != 0));                     
                if (TotalSubject != null)     // P1 CHECK TOTAL SUBJECT
                {
                    var ChildSub = DataAccess.Instance.GrandExamMarkSetupService.Filter(m => m.ExamSubjectID == TotalSubject.FirstPairSubID || m.ExamSubjectID == TotalSubject.SecondPairSubID && m.IsDeleted == false).FirstOrDefault();
                    if (ChildSub != null)     // P2 CHECK CHILD SUBJECT IS EXISTS THEN SET ChildSubExists TRUE 
                        ChildSubExists = true;
                }
                if (TotalSubject != null && ChildSubExists)   //P3 CHECK TOTAL SUBJECT AND CHILD SUBJECT 
                    return BadRequest("Opps! This is Total Subject you are not able to delete it");
                else if (result.Any() && (!User.IsInRole("Super")))
                    return BadRequest("Opps! Grand Config Exists");
                else if (DataAccess.Instance.GrandSubExamMarkSetupService.Filter(s => s.GrandExamMarkSetupId == id && s.IsDeleted == false).Any() && (!User.IsInRole("Super")))
                    return BadRequest("Opps! Sub Exam Mark Setup Exists");   // P4 CHECK SUBEXAM MARK SETUP 
                else
                {
                    res = DataAccess.Instance.GrandExamMarkSetupService.Remove(oMainExamMarkSetup.GrandExamMarkSetupId);
                    var TS = DataAccess.Instance.SubjectSetup.FirstOrDefault(s => s.IsDeleted == false && s.IsPair == true &&
                                    (s.FirstPairSubID == oMainExamMarkSetup.ExamSubjectID || s.SecondPairSubID == oMainExamMarkSetup.ExamSubjectID)
                                    && (s.FirstPairSubID != 0 && s.SecondPairSubID != 0)); //P5 GET TOTAL SUBJECT ID
                    if (res && TS.IsPair)
                    { 
                        var mts = DataAccess.Instance.GrandExamMarkSetupService.FirstOrDefault(e => e.ExamSubjectID == TS.SubID
                                  && e.GrandExamId == oMainExamMarkSetup.GrandExamId && e.IsDeleted == false);  // P6 GET TOTAL SUBJET MARK SETUP
                        mts.ExamFullMarks = mts.ExamFullMarks - oMainExamMarkSetup.ExamFullMarks;   // P7 ADJUST TOTAL SUBJECT MARK SETUP
                        DataAccess.Instance.GrandExamMarkSetupService.Update(mts);
                    }
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.DELETED : Constant.FAILED;
                    return Json(cr);
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        [Route("GrandResult/DeleteAllMainExamSubject/{versionId}/{sessionID}/{classId}/{groupId}/{mainExamID}")]
        [HttpDelete]
        public IHttpActionResult DeleteAllMainExamSubject(int versionID, int sessionID, int classID, string groupID, int mainExamID)
        {
            try
            {
                object[] param = new object[5];
                param[0] = versionID;
                param[1] = sessionID;
                param[2] = classID;
                if (groupID == "null" || groupID == "undefined")
                    param[3] = 0;
                else
                    param[3] = Convert.ToInt32(groupID);

                param[4] = mainExamID;
                CommonResponse cr = new CommonResponse();
                // P1 UPDATE DELETE STATUS BUY THIS SP "GrandDeleteAllExamMarkSubject" 
                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandDeleteAllExamMarkSubject", param);
                if (dt.Rows[0]["FAIL_OR_SUCCESS"].ToString() != "MARKS EXISTS" && dt.Rows[0]["FAIL_OR_SUCCESS"].ToString() != "SUB EXAM MARK SETUP EXISTS")
                {
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.results = dt;
                    cr.message = (int)dt.Rows[0][0] + " Data has been deleted";
                    return Json(cr);
                }
                else
                {
                    if (dt.Rows[0]["FAIL_OR_SUCCESS"].ToString() == "MARKS EXISTS")
                        return BadRequest("Opps! Grand Config Exists");
                    else if (dt.Rows[0]["FAIL_OR_SUCCESS"].ToString() == "SUB EXAM MARK SETUP EXISTS")
                        return BadRequest("SUB EXAM MARK SETUP EXISTS");
                    else
                        return BadRequest("Opps! Data Not Found");
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());

            }

        }
        [Route("GrandResult/GrandDeleteAllMainSubDivMarkSetup/{versionId}/{sessionID}/{classId}/{groupId}/{GrandExamID}")]
        [HttpDelete]
        public IHttpActionResult GrandDeleteAllMainSubDivMarkSetup(int versionID, int sessionID, int classID, string groupID, int GrandExamID)
        {
            try
            {
                if ((!User.IsInRole("Super")))  //P1 CHECK SUPER USER
                {
                     return BadRequest("You are not able to do this");
                }
                object[] param = new object[5];
                param[0] = versionID;
                param[1] = sessionID;
                param[2] = classID;
                param[3] = groupID == "null" || groupID == "undefined" ? 0 : Convert.ToInt32(groupID);
                param[4] = GrandExamID;
                CommonResponse cr = new CommonResponse();
                //P2 DeleteAllGrandSubDivMarkSetup by THIS SP GrandDeleteAllMainSubDivMarkSetup  int versionID, int sessionID, int classID, string groupID, int GrandExamID
                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandDeleteAllMainSubDivMarkSetup", param);

                if (dt.Rows[0]["FAIL_OR_SUCCESS"].ToString() != "GRAND CONFIG EXISTS")
                {
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.results = dt;
                    cr.message = (int)dt.Rows[0][0] + " Data has been deleted";
                    return Json(cr);
                }
                else
                {
                    if (dt.Rows[0]["FAIL_OR_SUCCESS"].ToString() == "GRAND CONFIG EXISTS")
                        return BadRequest("Opps! Grand Config Exists");
                    else
                        return BadRequest("Opps! Data Not Found");
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());

            }

        }
        #endregion GrandExamMarkSetup  
        #region GrandSubExamMarkSetup
        [Route("GrandResult/GetSubExamMarkSetup/{MainExamMarkSetupId}/{mainExamId}")]
        [HttpGet]
        public IHttpActionResult GetSubExamMarkSetup(int MainExamMarkSetupId, int mainExamId)
        {
            CommonResponse cr = new CommonResponse();
            DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandGetAllSubExammarkSetup", new object[] { MainExamMarkSetupId, mainExamId });
            List<VMGrandSubExamMarkSetup> _SubExamMarkSetupVM = APIUitility.ConvertDataTable<VMGrandSubExamMarkSetup>(dt);
            if (_SubExamMarkSetupVM.Any())//P1 GET ALL SUB EXAM MARK SETUP BY SP GrandGetAllSubExammarkSetup
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = _SubExamMarkSetupVM;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/AddSubExamMarkSetup/{mainExamId}/{subjectID}")]
        [HttpPost]
        public IHttpActionResult AddSubExamMarkSetup(List<VMGrandSubExamMarkSetup> lstVMSubExamMarkSetup, int mainExamId, int subjectID)
        {
            lstVMSubExamMarkSetup = lstVMSubExamMarkSetup.Where(s => s.SubExamExamMarks != 0).ToList();     // P1 FILTER BY NOT EQUALS ZERO 
            GrandSubExamMarkSetup objsubExamMarkSetup = new GrandSubExamMarkSetup();
            CommonResponse cr = new CommonResponse();
            bool res = false;
            try
            {

                foreach (var objVMSubExamMarkSetup in lstVMSubExamMarkSetup)
                {
                    objsubExamMarkSetup.GrandExamMarkSetupId = objVMSubExamMarkSetup.MainExamMarkSetupId;
                    var checkExists = DataAccess.Instance.GrandSubExamMarkSetupService.Filter(s => s.GrandExamMarkSetupId == objVMSubExamMarkSetup.MainExamMarkSetupId
                       && s.SubExamId == objVMSubExamMarkSetup.SubExamId && s.SubExamFullMarks == objVMSubExamMarkSetup.SubExamFullMarks
                       && s.SubExamExamMarks == objVMSubExamMarkSetup.SubExamExamMarks && s.SubExamIsPassDepend == objVMSubExamMarkSetup.SubExamIsPassDepend
                       && s.SubExamPassMark == objVMSubExamMarkSetup.SubExamPassMark && s.SubExamPassMarkIsPercent == objVMSubExamMarkSetup.SubExamPassMarkIsPercent
                       && s.IsDeleted == false && s.SubExamIsEnable == objVMSubExamMarkSetup.SubExamIsEnable).ToList();
                    if (checkExists.Any())     //P2 CHECK ALREADY EXISTS MARKSETUP 
                        continue;

                    var result = DataAccess.Instance.MainExamMarksService.Filter(m => m.MainExamID == objVMSubExamMarkSetup.MainExamId && m.SubExamID == objVMSubExamMarkSetup.SubExamId && m.SubjectID == subjectID && m.IsDeleted == false);

                    if (result.Any() && (!User.IsInRole("Super")))  //P3 CHECK MARK ENTRY EXISTS AND USER ROLE SUPER          
                        continue;
                    #region TotalSubject MarkSetup
                    var MainExamSubjectID = DataAccess.Instance.GrandExamMarkSetupService.FirstOrDefault(m => m.GrandExamMarkSetupId == objVMSubExamMarkSetup.MainExamMarkSetupId && m.IsDeleted == false).ExamSubjectID;  

                    var TotalSubject = DataAccess.Instance.SubjectSetup.FirstOrDefault(s => s.IsDeleted == false && s.IsPair == true &&
                                      s.SubID == MainExamSubjectID && (s.FirstPairSubID != 0 && s.SecondPairSubID != 0));
                    var Pair = DataAccess.Instance.SubjectSetup.FirstOrDefault(sb => sb.SubID == MainExamSubjectID && sb.IsPair == true && sb.IsDeleted == false);
                    if (TotalSubject != null)     //P4 CHECK TOTAL SUBJECT
                    {

                        var TotalSubjectMarkSetup = DataAccess.Instance.GrandSubExamMarkSetupService.FirstOrDefault(s => s.SubExamId == objVMSubExamMarkSetup.SubExamId
                                                    && s.GrandSubExamMarkSetupId == objVMSubExamMarkSetup.Id && s.IsDeleted == false);
                        if (TotalSubjectMarkSetup != null)  // P5 CHECK TOTAL SUBJECT GRAND SUB EXAM MARK SETUP, IF EXISTS THEN UPDATE
                        {

                            TotalSubjectMarkSetup.SubExamIsPassDepend = objVMSubExamMarkSetup.SubExamIsPassDepend;
                            TotalSubjectMarkSetup.SubExamPassMark = objVMSubExamMarkSetup.SubExamPassMark;
                            TotalSubjectMarkSetup.SubExamPassMarkIsPercent = objVMSubExamMarkSetup.SubExamPassMarkIsPercent;
                            TotalSubjectMarkSetup.AddBy = TotalSubjectMarkSetup.AddBy;
                            TotalSubjectMarkSetup.AddDate = TotalSubjectMarkSetup.AddDate;
                            TotalSubjectMarkSetup.SubExamIsEnable = objVMSubExamMarkSetup.SubExamIsEnable;
                            TotalSubjectMarkSetup.IsDeleted = false;
                            TotalSubjectMarkSetup.UpdateBy = User.Identity.Name;
                            TotalSubjectMarkSetup.SetDate();
                            TotalSubjectMarkSetup.Status = "A";
                            res = DataAccess.Instance.GrandSubExamMarkSetupService.Update(TotalSubjectMarkSetup);
                            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                            cr.message = res ? Constant.UPDATED : Constant.FAILED;
                            objsubExamMarkSetup.GrandExamMarkSetupId = TotalSubjectMarkSetup.GrandExamMarkSetupId;
                        }
                    }
                    #endregion TotalSubject MarkSetup
                    else
                    {
                        if (objVMSubExamMarkSetup.Id == 0 && objVMSubExamMarkSetup.SubExamFullMarks != 0 && objVMSubExamMarkSetup.SubExamExamMarks != 0)
                        {
                            objsubExamMarkSetup.GrandExamMarkSetupId = objVMSubExamMarkSetup.MainExamMarkSetupId;
                            objsubExamMarkSetup.SubExamId = objVMSubExamMarkSetup.SubExamId;
                            objsubExamMarkSetup.SubExamFullMarks = objVMSubExamMarkSetup.SubExamFullMarks;
                            objsubExamMarkSetup.SubExamExamMarks = objVMSubExamMarkSetup.SubExamExamMarks;
                            objsubExamMarkSetup.SubExamIsPassDepend = objVMSubExamMarkSetup.SubExamIsPassDepend;
                            objsubExamMarkSetup.SubExamPassMark = objVMSubExamMarkSetup.SubExamPassMark;
                            objsubExamMarkSetup.SubExamPassMarkIsPercent = objVMSubExamMarkSetup.SubExamPassMarkIsPercent;
                            objsubExamMarkSetup.SubExamIsEnable = objVMSubExamMarkSetup.SubExamIsEnable;
                            objsubExamMarkSetup.IsDeleted = false;
                            objsubExamMarkSetup.AddBy = User.Identity.Name;
                            objsubExamMarkSetup.SetDate();
                            objsubExamMarkSetup.Status = "A";
                            res = DataAccess.Instance.GrandSubExamMarkSetupService.Add(objsubExamMarkSetup);
                            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                            cr.message = res ? Constant.SAVED : Constant.FAILED;
                            if (res && (Pair != null)) // P6 CHECK PAIR SUBJECT AND ADJUST TOTAL SUBJECT MARK SETUP BY SP GrandPairTotalAutoSubExamMarkSetup
                            {
                                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandPairTotalAutoSubExamMarkSetup",
                                new object[] {objsubExamMarkSetup.GrandExamMarkSetupId,objsubExamMarkSetup.SubExamId,
                            objsubExamMarkSetup.SubExamFullMarks,objsubExamMarkSetup.SubExamExamMarks,objsubExamMarkSetup.AddBy});
                            }
                        }   // P7 UPDATE GRAND SUB EXAM MARK SETUP
                        else if (objVMSubExamMarkSetup.Id != 0 && objVMSubExamMarkSetup.SubExamFullMarks != 0 && objVMSubExamMarkSetup.SubExamExamMarks != 0)
                        {
                            var ExistingMainExamMark = DataAccess.Instance.GrandSubExamMarkSetupService.Filter(s => s.GrandSubExamMarkSetupId == objVMSubExamMarkSetup.Id && s.SubExamFullMarks == objVMSubExamMarkSetup.SubExamFullMarks
                            && s.SubExamPassMark == objVMSubExamMarkSetup.SubExamPassMark && s.SubExamIsEnable == objVMSubExamMarkSetup.SubExamIsEnable && s.SubExamExamMarks == objVMSubExamMarkSetup.SubExamExamMarks
                            && s.SubExamIsPassDepend == objVMSubExamMarkSetup.SubExamIsPassDepend && s.SubExamPassMarkIsPercent == objVMSubExamMarkSetup.SubExamPassMarkIsPercent && s.IsDeleted == false).ToList();
                            if (!ExistingMainExamMark.Any())
                            {
                                objsubExamMarkSetup.GrandSubExamMarkSetupId = objVMSubExamMarkSetup.Id;
                                objsubExamMarkSetup.GrandExamMarkSetupId = objVMSubExamMarkSetup.MainExamMarkSetupId;
                                objsubExamMarkSetup.SubExamId = objVMSubExamMarkSetup.SubExamId;
                                objsubExamMarkSetup.SubExamFullMarks = objVMSubExamMarkSetup.SubExamFullMarks;
                                objsubExamMarkSetup.SubExamExamMarks = objVMSubExamMarkSetup.SubExamExamMarks;
                                objsubExamMarkSetup.SubExamIsPassDepend = objVMSubExamMarkSetup.SubExamIsPassDepend;
                                objsubExamMarkSetup.SubExamPassMark = objVMSubExamMarkSetup.SubExamPassMark;
                                objsubExamMarkSetup.SubExamPassMarkIsPercent = objVMSubExamMarkSetup.SubExamPassMarkIsPercent;
                                objsubExamMarkSetup.SubExamIsEnable = objVMSubExamMarkSetup.SubExamIsEnable;
                                objsubExamMarkSetup.IsDeleted = false;
                                objsubExamMarkSetup.UpdateBy = User.Identity.Name;
                                objsubExamMarkSetup.SetDate();
                                objsubExamMarkSetup.Status = "A";
                                res = DataAccess.Instance.GrandSubExamMarkSetupService.Update(objsubExamMarkSetup);
                                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                                cr.message = res ? Constant.UPDATED : Constant.FAILED;
                                if (res && (Pair != null))   // P8 ADJUST TOTAL SUBJECT SUB EXAM MARK SETUP 
                                {

                                    DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandPairTotalAutoSubExamMarkSetup",
                                    new object[] {objsubExamMarkSetup.GrandExamMarkSetupId,objsubExamMarkSetup.SubExamId,
                                objsubExamMarkSetup.SubExamFullMarks,objsubExamMarkSetup.SubExamExamMarks,objsubExamMarkSetup.AddBy});
                                }
                            }
                        }

                    }
                }           
                DataTable _result = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandGetAllSubExammarkSetup", new object[] { objsubExamMarkSetup.GrandExamMarkSetupId, mainExamId });
                List<VMGrandSubExamMarkSetup> _SubExamMarkSetupVM = APIUitility.ConvertDataTable<VMGrandSubExamMarkSetup>(_result);
                if (_SubExamMarkSetupVM.Any())   // P9 RETURN GRAND SUB EXAM MARK SETUP
                {
                    cr.results = _SubExamMarkSetupVM;
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.FAILED;
                }
            }
            catch (Exception ex)
            {
                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandGetAllSubExammarkSetup", new object[] { objsubExamMarkSetup.GrandExamMarkSetupId, mainExamId });
                List<VMGrandSubExamMarkSetup> _SubExamMarkSetupVM = APIUitility.ConvertDataTable<VMGrandSubExamMarkSetup>(dt);
                cr.results = _SubExamMarkSetupVM;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("GrandResult/DeleteSubExamMark/{id}/{MainExamID}/{SubjectID}")]
        [HttpDelete]
        public IHttpActionResult DeleteSubExamMark(int id, int MainExamID, int SubjectID)
        {
            CommonResponse cr = new CommonResponse();
            bool res = false;
            try
            {
                GrandSubExamMarkSetup oSubExamMarkSetup = new GrandSubExamMarkSetup();
                oSubExamMarkSetup = DataAccess.Instance.GrandSubExamMarkSetupService.FirstOrDefault(id);
                var result = DataAccess.Instance.MainExamMarksService.Filter(m => m.SubExamID == oSubExamMarkSetup.SubExamId && m.MainExamID == MainExamID && m.SubjectID == SubjectID && m.IsDeleted == false);
                 // P1 CHECK MARK ENTRY
                var TotalSubject = DataAccess.Instance.SubjectSetup.FirstOrDefault(s => s.IsDeleted == false && s.IsPair == true &&
                                  s.SubID == SubjectID && (s.FirstPairSubID != 0 && s.SecondPairSubID != 0));
                if(TotalSubject!=null)     // P2 CHECK TOTAL SUBJECT
                {
                    throw new Exception("Opps! This is Total subject you are not able to delete it");
                }
                else if (result.Any() && (!User.IsInRole("Super")))   // P3 CHECK MARK EXISTS AND SUPER USER
                {
                    throw new Exception("Opps! Marks Exists");
                }
                else if (DataAccess.Instance.GrandDividedExamMarkSetupService.Filter(d => d.SubExamMarkSetupId == oSubExamMarkSetup.GrandSubExamMarkSetupId && d.IsDeleted == false).Any() && (!User.IsInRole("Super")))  // P4 CHECK GRAND DIVIDED EXAM MARK SETUP AND SUPER USER
                {
                    throw new Exception("Opps! Divided Exam Mark Setup Exists");
                }
                else
                {
                    res = DataAccess.Instance.GrandSubExamMarkSetupService.Remove(oSubExamMarkSetup.GrandSubExamMarkSetupId);
                    if (res && TotalSubject != null)   //P5 ADJUST TOTAL SUBJECT GRAND SUB EXAM MARK SETUP 
                    {
                        DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandPairTotalAutoSubExamMarkSetup",
                           new object[] {oSubExamMarkSetup.GrandExamMarkSetupId,oSubExamMarkSetup.SubExamId,
                            0,0,oSubExamMarkSetup.AddBy});
                    }
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.DELETED : Constant.FAILED;
                    return Json(cr);
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        [Route("GrandResult/DeleteAllSubExamMarkSetup/{MainExamMarkSetupId}/{mainExamId}/{subexamID}/{subjectID}")]
        [HttpDelete]
        public IHttpActionResult DeleteAllSubExamMarkSetup(int MainExamMarkSetupId, int mainExamID, int subexamID, int subjectID)
        {
            CommonResponse cr = new CommonResponse();
            // P1 UPDATE DELETE STATUS AND ADJUST TOTAL SUBJECT GRAND SUBEXAM MARK SETUP BY THIS SP    GrandDeleteAllSubExamMark
            DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandDeleteAllSubExamMark", new object[] { MainExamMarkSetupId, mainExamID, subexamID, subjectID });
            if (dt.Rows[0]["FAIL_OR_SUCCESS"].ToString() != "MARKS EXISTS" && dt.Rows[0]["FAIL_OR_SUCCESS"].ToString() != "DIVIDED EXAM MARK SETUP EXISTS")
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = dt;
                cr.message = (int)dt.Rows[0][0] + " Data has been deleted";
            }
            else
            {
                if (dt.Rows[0]["FAIL_OR_SUCCESS"].ToString() == "MARKS EXISTS")
                    return BadRequest("Opps! Marks Exists");
                else if (dt.Rows[0]["FAIL_OR_SUCCESS"].ToString() == "DIVIDED EXAM MARK SETUP EXISTS")
                    return BadRequest("DIVIDED EXAM MARK SETUP EXISTS");
                else
                    return BadRequest("Opps! Data Not Found");
            }
            return Json(cr);
        }
        #endregion GrandSubExamMarkSetup 
        #region divided Exam mark setup
        [Route("GrandResult/AddDividedExamMark/{subExamID}/{mainExamID}/{subjectID}")]
        [HttpPost]
        public IHttpActionResult AddDividedExamMark(List<VMGrandDividedExamMarkSetup> dividedExamMarkSetupVM, int SubExamID, int mainExamID, int subjectID)
        {
            dividedExamMarkSetupVM = dividedExamMarkSetupVM.Where(s => s.DividedExamExamMarks != 0).ToList();   //P1 FILTER BY NOT EQUALS ZERO 
            GrandDividedExamMarkSetup divExamMark = new GrandDividedExamMarkSetup();
            CommonResponse cr = new CommonResponse();
            bool res = false;
            try
            {
                foreach (var dv in dividedExamMarkSetupVM)
                {
                    divExamMark.SubExamMarkSetupId = dv.SubExamMarkSetupId;
                    var checkExists = DataAccess.Instance.GrandDividedExamMarkSetupService.Filter(d => d.SubExamMarkSetupId == dv.SubExamMarkSetupId && d.DividedExamId == dv.DividedExamId
                      && d.DividedExamType == dv.DividedExamType && d.DividedExamFullMarks == dv.DividedExamFullMarks && d.DividedExamExamMarks == dv.DividedExamExamMarks
                      && d.DividedExamIsPassDepend == dv.DividedExamIsPassDepend && d.DividedExamPassMarks == dv.DividedExamPassMarks && d.DividedExamPassMarkIsPercent == dv.DividedExamPassMarkIsPercent
                      && d.IsDeleted == dv.IsDeleted && d.DividedExamIsEnable == dv.DividedExamIsEnable).ToList();
                    if (checkExists.Any()) // P2 CHECK GRAND EXAM MARK SETUP IF EXISTS THEN SKIP
                        continue;                      
                    var result = DataAccess.Instance.MainExamMarksService.Filter(m => m.DividedExamID == dv.DividedExamId && m.SubExamID == SubExamID && m.MainExamID == mainExamID && m.SubjectID == subjectID && m.IsDeleted == false);
                    if (result.Any() && (!User.IsInRole("Super")))   //P3 CHECK MARKS ENTRY AND SUPER USER
                        continue;

                    #region TotalSubject MarkSetup                
                    var SubExamMarksetup = DataAccess.Instance.GrandSubExamMarkSetupService.FirstOrDefault(s => s.GrandSubExamMarkSetupId == dv.SubExamMarkSetupId && s.IsDeleted == false);
                    //P4 GET GRAND SUB EXAM MARK SETUP FOR FURTHER CHECK 
                    var MainExamSubjectID = DataAccess.Instance.GrandExamMarkSetupService.FirstOrDefault(m => m.GrandExamMarkSetupId == SubExamMarksetup.GrandExamMarkSetupId && m.IsDeleted == false).ExamSubjectID;
                    // P5 GET GRANDEXAM MARKSETUP SUBJECT ID
                    var TotalSubject = DataAccess.Instance.SubjectSetup.FirstOrDefault(s => s.IsDeleted == false && s.IsPair == true &&
                                      s.SubID == MainExamSubjectID && (s.FirstPairSubID != 0 && s.SecondPairSubID != 0));
                    //P6 GET TOTAL SUBJECT
                    var Pair = DataAccess.Instance.SubjectSetup.FirstOrDefault(sb => sb.SubID == MainExamSubjectID && sb.IsPair == true && sb.IsDeleted == false);
                    //P7 GET PAIR SUBJECT FOR FURTHER CHECK
                    if (TotalSubject != null)
                    {

                        var TotalSubjectMarkSetup = DataAccess.Instance.GrandDividedExamMarkSetupService.FirstOrDefault(s => s.DividedExamId == dv.DividedExamId
                                                    && s.DividedExamMarkSetupId == dv.DividedExamMarkSetupId && s.IsDeleted == false);
                        if (TotalSubjectMarkSetup != null) //P8 CHECK TOTAL SUBJECT GRAND DIVIDED EXAM MARK SETUP IF EXISTS THEN UPDATE
                        {
                            TotalSubjectMarkSetup.DividedExamIsPassDepend = dv.DividedExamIsPassDepend;
                            TotalSubjectMarkSetup.DividedExamPassMarks = dv.DividedExamPassMarks;
                            TotalSubjectMarkSetup.DividedExamPassMarkIsPercent = dv.DividedExamPassMarkIsPercent;
                            TotalSubjectMarkSetup.DividedExamIsEnable = dv.DividedExamIsEnable;
                            TotalSubjectMarkSetup.IsDeleted = false;
                            TotalSubjectMarkSetup.AddBy = dv.AddBy;
                            TotalSubjectMarkSetup.UpdateBy = User.Identity.Name;
                            TotalSubjectMarkSetup.SetDate();
                            TotalSubjectMarkSetup.Status = "A";
                            res = DataAccess.Instance.GrandDividedExamMarkSetupService.Update(TotalSubjectMarkSetup);
                            divExamMark.SubExamMarkSetupId = TotalSubjectMarkSetup.SubExamMarkSetupId;
                        }
                    }
                    #endregion TotalSubject MarkSetup
                    else
                    {
                        if (dv.DividedExamMarkSetupId == 0 && dv.DividedExamFullMarks != 0 && dv.DividedExamExamMarks != 0) 
                        {
                            divExamMark.DividedExamMarkSetupId = dv.DividedExamMarkSetupId;
                            divExamMark.SubExamMarkSetupId = dv.SubExamMarkSetupId;
                            divExamMark.DividedExamId = dv.DividedExamId;
                            divExamMark.DividedExamType = dv.DividedExamType;
                            divExamMark.DividedExamFullMarks = dv.DividedExamFullMarks;
                            divExamMark.DividedExamExamMarks = dv.DividedExamExamMarks;
                            divExamMark.DividedExamIsPassDepend = dv.DividedExamIsPassDepend;
                            divExamMark.DividedExamPassMarks = dv.DividedExamPassMarks;
                            divExamMark.DividedExamPassMarkIsPercent = dv.DividedExamPassMarkIsPercent;
                            divExamMark.DividedExamIsEnable = dv.DividedExamIsEnable;
                            divExamMark.IsDeleted = false;
                            divExamMark.AddBy = User.Identity.Name;
                            divExamMark.SetDate();
                            divExamMark.Status = "A";
                            res = DataAccess.Instance.GrandDividedExamMarkSetupService.Add(divExamMark);
                            if (res && (Pair != null))
                            {
                                //P9 ADJUST TOTAL SUBJECT GRAND DIVIDED EXAM MARK SETUP  BY THIS SP  GrandPairTotalAutoDividedExamMarkSetup
                                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandPairTotalAutoDividedExamMarkSetup",
                                new object[] {divExamMark.SubExamMarkSetupId,divExamMark.DividedExamId,divExamMark.DividedExamType,
                            divExamMark.DividedExamFullMarks,divExamMark.DividedExamExamMarks,divExamMark.AddBy});
                            }
                        }
                        else if (dv.DividedExamMarkSetupId != 0 && dv.DividedExamFullMarks != 0 && dv.DividedExamExamMarks != 0)
                        {
                            var ExistingMainExamMark = DataAccess.Instance.GrandDividedExamMarkSetupService.Filter(s => s.DividedExamMarkSetupId == dv.DividedExamMarkSetupId
                            && s.DividedExamFullMarks == dv.DividedExamFullMarks && s.DividedExamIsEnable == dv.DividedExamIsEnable
                            && s.DividedExamType == dv.DividedExamType && s.DividedExamExamMarks == dv.DividedExamExamMarks && s.DividedExamPassMarks == dv.DividedExamPassMarks
                            && s.DividedExamIsPassDepend == dv.DividedExamIsPassDepend && s.DividedExamPassMarkIsPercent == dv.DividedExamPassMarkIsPercent && s.IsDeleted == false).ToList();
                            if (!ExistingMainExamMark.Any())   //P10 CHECK MARK SETUP EXISTS AND UPDATE
                            {
                                divExamMark.DividedExamMarkSetupId = dv.DividedExamMarkSetupId;
                                divExamMark.SubExamMarkSetupId = dv.SubExamMarkSetupId;
                                divExamMark.DividedExamId = dv.DividedExamId;
                                divExamMark.DividedExamType = dv.DividedExamType;
                                divExamMark.DividedExamFullMarks = dv.DividedExamFullMarks;
                                divExamMark.DividedExamExamMarks = dv.DividedExamExamMarks;
                                divExamMark.DividedExamIsPassDepend = dv.DividedExamIsPassDepend;
                                divExamMark.DividedExamPassMarks = dv.DividedExamPassMarks;
                                divExamMark.DividedExamPassMarkIsPercent = dv.DividedExamPassMarkIsPercent;
                                divExamMark.DividedExamIsEnable = dv.DividedExamIsEnable;
                                divExamMark.IsDeleted = false;
                                divExamMark.AddBy = dv.AddBy;
                                divExamMark.UpdateBy = User.Identity.Name;
                                divExamMark.SetDate();
                                divExamMark.Status = "A";
                                res = DataAccess.Instance.GrandDividedExamMarkSetupService.Update(divExamMark);
                                if (res && (Pair != null))
                                {       
                                    //P11 ADJUST TOTAL SUBJECT GRAND DIVIDED EXAM MARK SETUP  BY THIS SP  GrandPairTotalAutoDividedExamMarkSetup
                                    DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandPairTotalAutoDividedExamMarkSetup",
                                    new object[] {divExamMark.SubExamMarkSetupId,divExamMark.DividedExamId,divExamMark.DividedExamType,
                                                 divExamMark.DividedExamFullMarks,divExamMark.DividedExamExamMarks,divExamMark.AddBy});
                                }
                            }
                        }
                    }
                }

                object[] param = new object[] { SubExamID, divExamMark.SubExamMarkSetupId };   //P12 RETURN GRAND DIVIDED EXAM MARK SETUP
                DataTable t = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandGetAllExamMarkDivided", param);
                List<VMGrandDividedExamMarkSetup> _MainExamSubjectMark = APIUitility.ConvertDataTable<VMGrandDividedExamMarkSetup>(t);
                cr.results = _MainExamSubjectMark;
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;

            }
            catch (Exception ex)
            {
                object[] param = new object[] { SubExamID, divExamMark.SubExamMarkSetupId };
                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandGetAllExamMarkDivided", param);
                List<VMGrandDividedExamMarkSetup> _MainExamSubjectMark = APIUitility.ConvertDataTable<VMGrandDividedExamMarkSetup>(dt);
                cr.results = _MainExamSubjectMark;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("GrandResult/GetDividedExamMark/{subExamID}/{subExamMarkSetupID}/")]
        [HttpGet]
        public IHttpActionResult GetDividedExamMark(int subExamID, int subExamMarkSetupID)
        {
            CommonResponse cr = new CommonResponse();
            object[] param = new object[] { subExamID, subExamMarkSetupID };
            //P1 GET GRAND DIVIDED EXAM MARK SETUP BY THIS SP GrandGetAllExamMarkDivided
            DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandGetAllExamMarkDivided", param);
            List<VMGrandDividedExamMarkSetup> _MainExamSubjectMark = APIUitility.ConvertDataTable<VMGrandDividedExamMarkSetup>(dt);
            if (_MainExamSubjectMark.Any())
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = _MainExamSubjectMark;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/DeleteDividedExamMark/{id}/{SubjectID}/{SubExamID}/{MainExamID}")]
        [HttpDelete]
        public IHttpActionResult DeleteDividedExamMark(int id, int SubjectID, int SubExamID, int MainExamID)
         {
            CommonResponse cr = new CommonResponse();
            bool res = false;
            GrandDividedExamMarkSetup GrandDividedExamMarkSetup = new GrandDividedExamMarkSetup();
            GrandDividedExamMarkSetup = DataAccess.Instance.GrandDividedExamMarkSetupService.FirstOrDefault(id);  //P1 CHECK MARKSETUP
            var result = DataAccess.Instance.MainExamMarksService.Filter(m => m.DividedExamID == GrandDividedExamMarkSetup.DividedExamId
            && m.MainExamID == MainExamID && m.SubExamID == SubExamID && m.SubjectID == SubjectID && m.IsDeleted == false);
            //P2 CHECK MARK ENTRY
            var TotalSubject = DataAccess.Instance.SubjectSetup.FirstOrDefault(s => s.IsDeleted == false && s.IsPair == true &&
                                s.SubID == SubjectID && (s.FirstPairSubID != 0 && s.SecondPairSubID != 0));
            if (TotalSubject != null)       // P3 CHECK TOTAL SUBJECT
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = "Opps! This is Total subject you are not able to delete it";
                return Json(cr);
            }
            else if (result.Any() && (!User.IsInRole("Super")))    // P4 CHECK SUPER USER AND MARK ENTRY
            {
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = "Opps! Marks Exists";
                return Json(cr);
            }
            else
            {
                GrandDividedExamMarkSetup.UpdateBy = User.Identity.Name;
                GrandDividedExamMarkSetup.SetDate();
                GrandDividedExamMarkSetup.IsDeleted = true;
                res = DataAccess.Instance.GrandDividedExamMarkSetupService.Update(GrandDividedExamMarkSetup);
            
                if (res && TotalSubject != null)      // P5 IF SUCCESSFULLY CHANGE DELETE STATUS THEN ADJUST TOTAL GRAND DIVIDED EXAM MARK SETUP BY THIS SP    GrandPairTotalAutoDividedExamMarkSetup
                {
                    DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GrandPairTotalAutoDividedExamMarkSetup",
                            new object[] {GrandDividedExamMarkSetup.SubExamMarkSetupId,GrandDividedExamMarkSetup.DividedExamId,GrandDividedExamMarkSetup.DividedExamType,
                            0,0,GrandDividedExamMarkSetup.AddBy});
                }
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.DELETED : Constant.FAILED;
                return Json(cr);
            }
        }
        [Route("GrandResult/DeleteAllDividedGrandResult/{SubExamMarkSetupId}/{SubExamId}/{mainExamID}/{subjectID}")]
        [HttpDelete]
        public IHttpActionResult DeleteAllDividedExamMarkSetup(int SubExamMarkSetupId, int SubExamId, int mainExamID, int subjectID)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (DataAccess.Instance.MainExamMarksService.Filter(e=>e.MainExamID==mainExamID && e.SubExamID==SubExamId && e.SubjectID == subjectID).Any())
                {
                    throw new Exception("Opps! Marks Exists");
                }
                var GrandDividedExamMark = DataAccess.Instance.GrandDividedExamMarkSetupService.Filter(e=>e.SubExamMarkSetupId==SubExamMarkSetupId).ToList();
                foreach (var item in GrandDividedExamMark)
                {
                  var res=  DataAccess.Instance.GrandDividedExamMarkSetupService.Remove(item.DividedExamMarkSetupId);
                    if (!res)
                        throw new Exception("Opps! Marks Exists");
                    cr.message = " Data has been deleted";
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        #endregion     divided Exam mark setup   
        #region GrandVirtualExamSetup
      
        [Route("GrandResult/GetGrandVirtualExamSetup/")]
        [HttpPost]
        public IHttpActionResult GetGrandVirtualExamSetup([FromBody] StudentExamFilter fill)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //Get filter Data Res_GrandVirtualExamSetup join with Res_GrandSubExam  
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSubExamForGrandVirtual", new object[] { fill.VersionID, fill.SessionId, fill.ClassId, fill.GroupId, fill.GrandExamId, fill.SubjectID });
                List<GrandVirtualExamSetup> res = APIUitility.ConvertDataTable<GrandVirtualExamSetup>(dt);
                cr.results = res;
                if (res.Count() > 0)
                {
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = "Data Found";
                }
                else
                    cr.message = "Data Not Found";
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        [Route("GrandResult/CloneGrandVirtualExam/{clone}/{VersionId}/{SessionId}/{MainExamId}/{Id}")]
        [HttpGet]
        public IHttpActionResult CloneGrandVirtualExam(bool clone, int VersionId, int SessionId, int MainExamId, int GrandExamId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {

                if (!clone && VersionId == 0 && SessionId == 0 && MainExamId == 0 && GrandExamId == 0)
                {
                    cr.HasError = true;
                    cr.httpStatusCode = HttpStatusCode.BadRequest;
                    cr.message = Constant.INVAILD_DATA;
                    return Json(cr);
                }
                else
                {
                    var existing = DataAccess.Instance.GrandVirtualExamSetupService.Filter(e => e.VersionId == VersionId && e.SessionId == SessionId && e.GrandExamID == GrandExamId && e.IsDeleted == false).ToList();
                    if (existing.Any())
                    {
                        cr.HasError = true;
                        cr.httpStatusCode = HttpStatusCode.BadRequest;
                        cr.message = "Virtual Setup Already Exists";
                        return Json(cr);
                    }
                }

                var existingVirtualExam = DataAccess.Instance.aVirtualExamService.Filter(e => e.VersionId == VersionId && e.SessionId == SessionId && e.MainExamID == MainExamId && e.IsDeleted == false).ToList();
                List<int> sExamId = new List<int>();
                if (existingVirtualExam.Any())
                {
                    foreach (var v in existingVirtualExam)
                    {
                        var vdt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSubExamForGrandVirtual", new object[] { v.VersionId, v.SessionId, v.ClassId, v.GroupId, GrandExamId, v.SubjectID });
                        List<GrandVirtualExamSetup> result = APIUitility.ConvertDataTable<GrandVirtualExamSetup>(vdt);              
                        int subExamcounter = 0;
                        foreach (var vmv in result)
                        {
                            if (subExamcounter != 0)
                                break;
                            else if (sExamId.Contains(vmv.GrandSubExamID))
                                continue;
                            GrandVirtualExamSetup vs = new GrandVirtualExamSetup();
                            vs = vmv;
                            vs.Id = 0;
                            vs.GrandExamID = GrandExamId;
                            vs.AddBy = User.Identity.Name;
                            vs.SetDate();
                            vs.DivExamTypeVirtual1 = v.DivExamTypeVirtual1;
                            vs.VirtualPassMark1 = v.VirtualPassMark1;
                            vs.VirtualPassMarkIsPercent1 = v.VirtualPassMarkIsPercent1;
                            vs.VirtualPassMark2 = v.VirtualPassMark2;
                            vs.VirtualPassMarkIsPercent2 = v.VirtualPassMarkIsPercent2;
                            vs.DivExamTypeVirtual2 = v.DivExamTypeVirtual2;
                            DataAccess.Instance.GrandVirtualExamSetupService.Add(vs);
                            subExamcounter++;
                            sExamId.Add(vs.GrandSubExamID);
                        }

                    }
                }
                else
                {
                    cr.HasError = true;
                    cr.httpStatusCode = HttpStatusCode.BadRequest;
                    cr.message = "Source virtual exam setup not exists";
                    return Json(cr);

                }
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = "Clone Success";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }

            return Json(cr);
        }
        [Route("GrandResult/AddGrandVirtualExam/")]
        [HttpPost]
        public IHttpActionResult AddGrandVirtualExam(List<GrandVirtualExamSetup> lstGrandVirtualExam)
        {
            if (!lstGrandVirtualExam.Any())
                return BadRequest();
            //Get First row from list
            var data = lstGrandVirtualExam.FirstOrDefault();
            CommonResponse cr = new CommonResponse();
            //Remove Exist GrandVirtualExam Setup by paramater
            DataAccess.Instance.GrandVirtualExamSetupService.RemoveRange(data.VersionId, data.SessionId, data.ClassId, data.GroupId, data.GrandExamID, data.SubjectID);
            //Get data which are Virtual DividenExamType not null
            lstGrandVirtualExam = lstGrandVirtualExam.Where(e => e.DivExamTypeVirtual1 != "" || e.DivExamTypeVirtual2 != "").ToList();
            //if null Virtual DividenExamType more then 2 then return
            if (lstGrandVirtualExam.Count() < 2)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.INVAILD_DATA;
                return Json(cr);
            }
            bool results = false;
            // Add list Virtual DividenExam
            foreach (var item in lstGrandVirtualExam)
            {
                results = DataAccess.Instance.GrandVirtualExamSetupService.Add(item);
            }
            if (results)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.SAVED;
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSubExamForGrandVirtual", new object[] { lstGrandVirtualExam.FirstOrDefault().VersionId, lstGrandVirtualExam.FirstOrDefault().SessionId, lstGrandVirtualExam.FirstOrDefault().ClassId, lstGrandVirtualExam.FirstOrDefault().GroupId, lstGrandVirtualExam.FirstOrDefault().GrandExamID, lstGrandVirtualExam.FirstOrDefault().SubjectID });
                List<GrandVirtualExamSetup> res = APIUitility.ConvertDataTable<GrandVirtualExamSetup>(dt);
                cr.results = res;
            }
            else
                return BadRequest();
            return Json(cr);
        }
        [Route("GrandResult/DeleteGrandVirtualExam/")]
        [HttpPost]
        public IHttpActionResult DeleteGrandVirtualExam(List<GrandVirtualExamSetup> lstGrandVirtualExam)
        {
            // list of data not null
            if (!lstGrandVirtualExam.Any())
                return BadRequest();
            var data = lstGrandVirtualExam.FirstOrDefault();
            CommonResponse cr = new CommonResponse();
            //Delete of rang of data
            var results = DataAccess.Instance.GrandVirtualExamSetupService.RemoveRange(data.VersionId, data.SessionId, data.ClassId, data.GroupId, data.GrandExamID, data.SubjectID);
            if (results)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.DELETED;
            }
            else
                return BadRequest();
            return Json(cr);
        }
        #endregion GrandVirtualExamSetup
        #region GrandSetup      
        [Route("GrandResult/AddGrandSetup/")]
        [HttpPost]
        public IHttpActionResult AddGrandSetup(List<VMGrandSetup> grandSetup)
        {
            CommonResponse cr = new CommonResponse();
            // P1 Filtering which are more then zero
            grandSetup = grandSetup.Where(e => e.MainExamPercent > 0).ToList();
            try
            {
                //P2 check data not null
                if (!grandSetup.Any())
                    return BadRequest("Empty List");
                bool res = false;
                //P3 check setup exits in GrandConfig by MainExam
                foreach (var g in grandSetup)
                {
                    var ConfigCheck = DataAccess.Instance.GrandConfigService.Filter(c => c.MainExamId == g.MainExamId);
                    if (ConfigCheck.Any())
                    {
                        cr.httpStatusCode = HttpStatusCode.BadRequest;
                        cr.message = "One Of Main Exam Exit in Grand Config";
                        return Json(cr);
                    }
                }
                //P4 Add GrandSetup
                 foreach (var g in grandSetup)
                 {
                    GrandSetup GS = new GrandSetup();
                    GS.VersionId = g.VersionId;
                    GS.SessionId = g.SessionId;
                    GS.ClassId = g.ClassId;
                    GS.GroupId = g.GroupId;
                    GS.MainExamId = g.MainExamId;
                    GS.MainExamPercent = g.MainExamPercent;
                    GS.IsPassDependet = g.IsPassDependet;
                    GS.GrandExamId = g.GrandExamId;
                    GS.IsDeleted = false;
                    GS.Remarks = g.Remarks;
                    GS.Status = "A";                   
                    if (g.GrandSetupId == 0)
                    {
                        g.AddBy = User.Identity.Name;
                        g.SetDate();
                        res = DataAccess.Instance.GrandSetupService.Add(GS);
                        cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                        cr.message = res ? Constant.SAVED : Constant.FAILED;
                    }
                    else // P5 UPDATE GRANDSETUP
                    {
                        GS.MainExamPercent = g.MainExamPercent;
                        GS.IsPassDependet = g.IsPassDependet;
                        GS.GrandSetupId = g.GrandSetupId;
                        GS.AddBy = g.AddBy;
                        GS.AddDate = g.AddDate;
                        GS.UpdateBy = User.Identity.Name;
                        GS.IsDeleted = g.IsDeleted;
                        GS.Status = g.Status;
                        GS.SetDate();
                        res = DataAccess.Instance.GrandSetupService.Update(GS);
                        cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                        cr.message = res ? Constant.UPDATED : Constant.FAILED;
                    }
                }
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }        
        [Route("GrandResult/DeleteGrandSetup/")]
        [HttpPost]
        public IHttpActionResult DeleteGrandSetup(List<GrandSetup> lstVirtualExam)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (!lstVirtualExam.Any())
                    return BadRequest();
                foreach (var g in lstVirtualExam)
                {
                    //P1 Check Grandconfig Exits
                    var ConfigCheck = DataAccess.Instance.GrandConfigService.Filter(c => c.MainExamId == g.MainExamId);
                    if (ConfigCheck.Any() && (!User.IsInRole("Super")))
                    {
                        cr.httpStatusCode = HttpStatusCode.BadRequest;
                        cr.message = "One Of Main Exam Exits in Grand Config";
                        cr.HasError = true;
                        return Json(cr);
                    }
                }
                var data = lstVirtualExam.FirstOrDefault();
                //P2 Delete GrandSetup which are not assaign in GrandConfig
                var results = DataAccess.Instance.GrandSetupService.RemoveRange(data.VersionId, data.SessionId, data.ClassId, data.GroupId, data.MainExamId);
                if (results && (User.IsInRole("Super")))
                {
                    object[] param = new object[4];
                    param[0] = lstVirtualExam[0].VersionId;
                    param[1] = lstVirtualExam[0].SessionId;
                    param[2] = lstVirtualExam[0].ClassId;
                    param[3] = lstVirtualExam[0].GroupId;

                    var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("sp_GetGrandConfigDetail", param);
                    var result = Api.APIUitility.ConvertDataTable<VMGrandConfigDetail>(dt);
                    foreach (var g in result)
                    {
                        cr = GrandConfigurationDelete(g.MainExamId, g.SubExamId, g.DivExamId, g.GrandExamId, g.GrandSubExamId, g.GrandDivExamId);
                        if (cr.httpStatusCode.ToString() == "BadRequest")
                        {
                            cr.HasError = true;
                            return Json(cr);
                        }

                    }

                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = Constant.DELETED;
                } 

            }catch(Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
                cr.HasError = true;                  
            }
            
            return Json(cr);
        }
        [Route("GrandResult/GetGrandSetup/{versionId}/{sessionID}/{classId}/{groupId}")]
        [HttpGet]
        public IHttpActionResult GetGrandSetup(int VersionId, int SessionId, int ClassId, string GroupId)
        {
            object[] param = new object[4];
            param[0] = VersionId;
            param[1] = SessionId;
            param[2] = ClassId;
           
            if (GroupId == "null" || GroupId == "undefined")
            {
                param[3] = 0;
            }
            else
            {
                param[3] = Convert.ToInt32(GroupId);
            }
          
            CommonResponse cr = new CommonResponse();
            // P1 Get GrandSetup Data by Paramater
            var dt= DataAccess.Instance.CommonServices.GetBySpWithParam("sp_GrandSetup", param);
            cr.results=Api.APIUitility.ConvertDataTable<VMGrandSetup>(dt);  
            return Json(cr);
        }
        [Route("GrandResult/GetAllGrandSetup/")]
        [HttpGet]
        public IHttpActionResult GetAllGrandSetup()
        { 
            CommonResponse cr = new CommonResponse();
            // P1 Get AllGrandSetup
            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("sp_GrandSetup", DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value);
            cr.results = Api.APIUitility.ConvertDataTable<VMGrandSetup>(dt);
            return Json(cr);
        }
        [Route("GrandResult/SingleAddandUpdateGrandSetup")]
        [HttpPost]
        public IHttpActionResult SingleAddandUpdateGrandSetup(GrandSetup GrandSetup)
        {
            CommonResponse cr = new CommonResponse();
            // P1 CHECK GetGrandSetup EXISTS IN GrandConfig
            var ConfigCheck = DataAccess.Instance.GrandConfigService.Filter(c => c.MainExamId == GrandSetup.MainExamId);
            if (ConfigCheck.Any())
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = "Main Exam Exit in Grand Config";
                return Json(cr);
            }
            var res = false;
            if (GrandSetup.GrandSetupId == 0)
            {
                //P2 Add New GrandSetup
                GrandSetup gs = new GrandSetup();
                gs.AddBy = User.Identity.Name;
                gs.ClassId = GrandSetup.ClassId;
                gs.GrandExamId = GrandSetup.GrandExamId;
                gs.GrandSetupId = GrandSetup.GrandSetupId;
                gs.GroupId = GrandSetup.GroupId;
                gs.IsDeleted = GrandSetup.IsDeleted;
                gs.IsPassDependet = GrandSetup.IsPassDependet;
                gs.MainExamId = GrandSetup.MainExamId;
                gs.Remarks = GrandSetup.Remarks;
                gs.SessionId = GrandSetup.SessionId;
                gs.Status = GrandSetup.Status;
                gs.VersionId = GrandSetup.VersionId;
                GrandSetup.SetDate();
                res = DataAccess.Instance.GrandSetupService.Add(GrandSetup);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                return Json(cr);
            }
            else {
                // P3 Update GrandSetup
                var data = DataAccess.Instance.GrandSetupService.Get(GrandSetup.GrandSetupId);
                if (data != null)
                {
                    data.MainExamPercent = GrandSetup.MainExamPercent;
                    data.IsPassDependet = GrandSetup.IsPassDependet;
                    res = DataAccess.Instance.GrandSetupService.Update(data);
                }
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.FAILED;
                return Json(cr);
            }
        }
        [Route("GrandResult/SingleDeleteGrandSetup/{GrandId}")]
        [HttpPost]
        public IHttpActionResult SingleDeleteGrandSetup(int GrandId)
        {
            CommonResponse cr = new CommonResponse();
            //P1 Check Grandconfig Exits OR NOT
            var data = DataAccess.Instance.GrandSetupService.Get(GrandId);
            var ConfigCheck = DataAccess.Instance.GrandConfigService.Filter(c => c.MainExamId == data.MainExamId);
            if (ConfigCheck.Any())
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = "Main Exam Exit in Grand Config";
                return Json(cr);
            }
            var res = false;
            if (data != null) {
                data.IsDeleted = true;
                //P2 UPDATE GrandSetup
                res = DataAccess.Instance.GrandSetupService.Update(data);
            }
           
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
            return Json(cr);
        }
        [Route("GrandResult/GetGrandSetupByVCSG/{versionId}/{sessionID}/{classId}/{groupId}/{mainExamId}")]
        [HttpGet]
        public IHttpActionResult GetGrandSetupByVCSG(int VersionId, int SessionId, int ClassId,  string GroupId,int MainExamId)
        {
            int _groupID = 0;
            if (GroupId.ToLower().Trim() != "null" && GroupId != "undefined")
            {
                _groupID = Convert.ToInt32(GroupId);
            }
            else
            {
                return BadRequest("Invaild Request.");
            }
            CommonResponse cr = new CommonResponse();
            //P1 GET GRANDSETUP 
            var res = DataAccess.Instance.GrandSetupService.Filter(s => s.VersionId == VersionId
             && s.SessionId == SessionId && s.ClassId == ClassId && s.GroupId == _groupID && s.MainExamId == MainExamId && s.IsDeleted == false, null,null).ToList();
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
       
        #endregion GrandSetup 
        #region GrandConfig
        /// <summary>
        /// 
        /// </summary>
        /// <param name="versionID"></param>
        /// <param name="sessionID"></param>
        /// <param name="classID"></param>
        /// <param name="groupID"></param>
        /// <returns></returns>
        [Route("GrandResult/GetMainExamByGrandSetup/{versionId}/{sessionID}/{classId}/{groupId}")]  
        [HttpGet]
        public IHttpActionResult GetMainExamByGrandSetup(int versionID, int sessionID, int classID, string groupID)
        {
            CommonResponse cr = new CommonResponse();
            int _groupID = 0;
            //P1 check Group Id null and undefined
            if (groupID != "null" && groupID != "undefined")
            {
                _groupID = Convert.ToInt32(groupID);
            }
            //P2 Get GrandSetupList By VSCG
            var MExam = DataAccess.Instance.GrandSetupService.Filter(g => g.VersionId == versionID && g.SessionId == sessionID
              && g.ClassId == classID && g.GroupId == _groupID && g.IsDeleted==false).ToList();
            var MExam1 = DataAccess.Instance.GrandSetupService.GetAll().ToList();
            //P3 Get MainExamList By VSCG
            var res = DataAccess.Instance.MainExamService.Filter(s => s.VersionId == versionID
             && s.SessionId == sessionID && s.ClassId == classID && s.GroupId == _groupID && s.IsDeleted == false,
             o => o.OrderBy(i => i.MainExamId),null).ToList();
            //P4 Get Data By Join MainExam and GrandSetup
            res = (from r in res join M in MExam on r.MainExamId equals M.MainExamId where M.IsDeleted == false select r).ToList();
            //P5 check data  and return
            if (res.Any())
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
                cr.message = Constant.SUCCESS;
            }
            else
            {
                cr.message = "Grand Setup Not Found";
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }   
        [Route("GrandResult/ExamMapping/")]  
        [HttpPost]
        public IHttpActionResult ExamMapping(GrandConfig GrandConfig)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                // P1 CHECK VALID DATA
                if (GrandConfig.MainExamId == 0 && GrandConfig.SubExamId == 0 && GrandConfig.DivExamId == 0 && GrandConfig.GrandExamId == 0 && GrandConfig.GrandSubExamId == 0 && GrandConfig.GrandDivExamId == 0)
                {
                    cr.message = "Oops! Something went wrong please check";
                    cr.httpStatusCode = HttpStatusCode.BadRequest;
                    return Json(cr);
                }
                  
                //P3 CHECK EXAM MAPPING IF EXISTS OR NOT  
                var _r = DataAccess.Instance.GrandConfigService.Filter(e => e.MainExamId == GrandConfig.MainExamId && e.SubExamId == GrandConfig.SubExamId
                && e.DivExamId== GrandConfig.DivExamId && e.GrandExamId == GrandConfig.GrandExamId && e.GrandSubExamId == GrandConfig.GrandSubExamId
                && e.GrandDivExamId == GrandConfig.GrandDivExamId && e.DivExamPercentage== GrandConfig.DivExamPercentage && GrandConfig.GrandConfigId==0 && e.IsDeleted==false);
                if(_r.Any())
                {
                    cr.message = "Oops! Same Policy already exists";
                    cr.httpStatusCode = HttpStatusCode.BadRequest;
                    return Json(cr);
                }
                //P4 GET EXAM MARK SETUP DETAILS BY THIS SP   MainExamMarkSetupDetails
                var ExamDetails = DataAccess.Instance.GrandConfigService.getDatasetResponseBySp("MainExamMarkSetupDetails", new object[]
                {
                GrandConfig.MainExamId, GrandConfig.SubExamId,GrandConfig.DivExamId,
                GrandConfig.GrandExamId, GrandConfig.GrandSubExamId, GrandConfig.GrandDivExamId
                });
                DataSet ds = ExamDetails.results;
                DataTable mainExam = ds.Tables[0];
                DataTable grandExam = ds.Tables[1];
                List<MainExamMarkSetupDetails> M = Api.APIUitility.ConvertDataTable<MainExamMarkSetupDetails>(mainExam);
                List<GrandExamMarkSetupDetails> G = Api.APIUitility.ConvertDataTable<GrandExamMarkSetupDetails>(grandExam);
                  if(!M.Any())//P5 CHECK SOURCE EXAM 
                    {
                        cr.message ="Invalid Source ";
                        cr.httpStatusCode = HttpStatusCode.BadRequest;
                        return Json(cr);
                    }

                if (!G.Any()) // P6 CHECK TARGET EXAM
                {
                    cr.message = "Invalid Target";
                    cr.httpStatusCode = HttpStatusCode.BadRequest;
                    return Json(cr);
                }
                foreach (var m in M)
                {
                    GrandExamMarkSetupDetails gm = G.Where(s => s.SubID == m.SubID).FirstOrDefault();
                    #region  Grand Exam Mark Setup 
                    var GF = DataAccess.Instance.GrandConfigService.Filter(e => e.SubjectId==m.SubID && e.MainExamId == GrandConfig.MainExamId && e.GrandExamId == GrandConfig.GrandExamId && e.IsDeleted == false);
                    if (!GF.Any())  //P7 CHECK SUBJECT GRAND EXAM MARK SETUP MAPPING EXISTS IN GRAND CONFIG TABLE OR NOT
                    {
                        //P8 GET GRAND EXAM MARK SETUP AND UPDATE FULLMARKS BASED ON GRAND SETUP PERCENTAGE
                        var gs = DataAccess.Instance.GrandExamMarkSetupService.FirstOrDefault(e => e.GrandExamMarkSetupId == gm.GrandExamMarkSetupId);
                        gs.UpdateBy = User.Identity.Name;
                        gs.SetDate();
                        if (gs.Status == "P")
                        {
                            gs.ExamFullMarks = gs.ExamFullMarks + ((m.FullMarks * GrandConfig.DivExamPercentage) / 100);
                            gs.Remarks = "+" + GrandConfig.DivExamPercentage;
                        }
                        else
                        {
                            gs.ExamFullMarks = ((m.FullMarks * GrandConfig.DivExamPercentage) / 100);
                            gs.Remarks = GrandConfig.DivExamPercentage.ToString();
                            gs.Status = "P";
                        }
                        var gms = DataAccess.Instance.GrandExamMarkSetupService.Update(gs);
                    }

                    #endregion  Grand Exam Mark Setup

                    #region  Grand Sub Exam Mark Setup  
                    var SF = DataAccess.Instance.GrandConfigService.Filter(e => e.SubjectId == m.SubID && e.MainExamId == GrandConfig.MainExamId && 
                    e.SubExamId == GrandConfig.SubExamId &&  e.GrandExamId == GrandConfig.GrandExamId && e.GrandSubExamId == GrandConfig.GrandSubExamId && e.IsDeleted == false);
                    if(!SF.Any())   //P9 CHECK SUBEXAM EXAM MARK SETUP MAPPING EXISTS IN GRAND CONFIG TABLE OR NOT
                    {
                        //P10 GET SUB EXAM MARK SETUP AND UPDATE FULLMARKS BASED ON GRAND SETUP PERCENTAGE
                        var gss = DataAccess.Instance.GrandSubExamMarkSetupService.FirstOrDefault(e => e.GrandSubExamMarkSetupId == gm.GrandSubExamMarkSetupId);
                        gss.UpdateBy = User.Identity.Name;
                        gss.SetDate();
                        if (gss.Status == "P")
                        {
                            gss.SubExamFullMarks = gss.SubExamFullMarks + ((m.SubExamFullMarks * GrandConfig.DivExamPercentage) / 100);
                            gss.SubExamExamMarks = gss.SubExamExamMarks + ((m.SubExamExamMarks * GrandConfig.DivExamPercentage) / 100);
                            gss.Remarks = "+" + GrandConfig.DivExamPercentage;
                        }
                        else
                        {
                            gss.SubExamFullMarks = ((m.SubExamFullMarks * GrandConfig.DivExamPercentage) / 100);
                            gss.SubExamExamMarks = ((m.SubExamExamMarks * GrandConfig.DivExamPercentage) / 100);
                            gss.Remarks = GrandConfig.DivExamPercentage.ToString();
                            gss.Status = "P";
                        }
                        var gsm = DataAccess.Instance.GrandSubExamMarkSetupService.Update(gss);
                    }

                    #endregion  Grand Exam Mark Setup

                    #region  Grand Divided Exam Mark Setup
                    var DF = DataAccess.Instance.GrandConfigService.Filter(e => e.SubjectId == m.SubID && e.MainExamId == GrandConfig.MainExamId && e.SubExamId == GrandConfig.SubExamId
                            && e.DivExamId == GrandConfig.DivExamId && e.GrandExamId == GrandConfig.GrandExamId && e.GrandSubExamId == GrandConfig.GrandSubExamId
                            && e.GrandDivExamId == GrandConfig.GrandDivExamId && e.IsDeleted == false);
                    if(!DF.Any())    //P11 CHECK DIVIDED EXAM MARK SETUP MAPPING EXISTS IN GRAND CONFIG TABLE OR NOT
                    {
                        //P12 GET DIVIDED EXAM MARK SETUP AND UPDATE FULLMARKS BASED ON GRAND SETUP PERCENTAGE
                        var gds = DataAccess.Instance.GrandDividedExamMarkSetupService.FirstOrDefault(e => e.DividedExamMarkSetupId == gm.DividedExamMarkSetupId);
                        gds.UpdateBy = User.Identity.Name;
                        gds.SetDate();
                        if (gds.Status == "P")
                        {
                            gds.DividedExamFullMarks = gds.DividedExamFullMarks + ((m.DividedExamFullMarks * GrandConfig.DivExamPercentage) / 100);
                            gds.DividedExamExamMarks = gds.DividedExamExamMarks + ((m.DividedExamExamMarks * GrandConfig.DivExamPercentage) / 100);
                            gds.Remarks = "+" + GrandConfig.DivExamPercentage;
                        }
                        else
                        {
                            gds.DividedExamFullMarks = ((m.DividedExamFullMarks * GrandConfig.DivExamPercentage) / 100);
                            gds.DividedExamExamMarks = ((m.DividedExamExamMarks * GrandConfig.DivExamPercentage) / 100);
                            gds.Remarks = GrandConfig.DivExamPercentage.ToString();
                            gds.Status = "P";
                        }
                        var gdm = DataAccess.Instance.GrandDividedExamMarkSetupService.Update(gds);
                    }
             

                    #endregion  Grand Divided Exam Mark Setup

                    #region  Grand Config Table
                     //P13 ADD SUBJECT PERCENTAGE MAPPING IN GRAND CONFIG TABLE
                    GrandConfig.SubjectId = m.SubID;
                    GrandConfig.DivExamType = m.DividedExamType;
                    GrandConfig.GrandDivExamType = gm.DividedExamType;
                    GrandConfig.IsDeleted = false;
                    GrandConfig.AddBy = User.Identity.Name;
                    GrandConfig.SetDate();
                    GrandConfig.Status = "A";

                    var res = DataAccess.Instance.GrandConfigService.Add(GrandConfig);
                    cr.message = res ? Constant.SAVED : Constant.FAILED;
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;

                    #endregion  Grand Config Table
                }
             

            }
            catch (Exception ex)
            {

                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            
            return Json(cr);           
        }
        private CommonResponse GrandConfigurationDelete(int MainExamId, int SubExamId, int DivExamId, int GrandExamId, int GrandSubExamId, int GrandDivExamId)  
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //P14 CHECK GRAND RESULT PROCESS
                DataTable d = new DataTable();
                string sql = "SELECT [GrandExamId], [GrandSubExamId], [StudentIID] FROM [Res_GrandResultMarksDetails] WHERE GrandExamId=" + GrandExamId + " AND GrandSubExamId=" + GrandSubExamId + "";
                d = DataAccess.Instance.CommonServices.ExecuteSQLQUERY(sql);
                if (d.Rows.Count > 0 && (!User.IsInRole("Super")))
                {
                    cr.message = "Oops! Grand process exists and you have not super role";
                    cr.httpStatusCode = HttpStatusCode.BadRequest;
                    return cr;
                }  
                //P1 CHECK VALID DATA
                decimal DivExamPercentage = 0;
                //Check Paramater MainExam, SubExam, DividedExam, GrandExam, GrandSubExam, GrandDivided Exam Id are not null
                if (MainExamId == 0 && SubExamId == 0 && DivExamId == 0 && GrandExamId == 0 && GrandSubExamId == 0 && GrandDivExamId == 0)
                {
                    cr.message = "Oops! Something went wrong please check";
                    cr.httpStatusCode = HttpStatusCode.BadRequest;
                    return cr;
                }
                //Get GrandConfig By MainExamId, SubExamId, DividedExamId, GrandExamId, GrandSubExamId, GrandDividedExamId
                var _r = DataAccess.Instance.GrandConfigService.Filter(e => e.MainExamId == MainExamId && e.SubExamId == SubExamId
                && e.DivExamId == DivExamId && e.GrandExamId == GrandExamId && e.GrandSubExamId == GrandSubExamId
                && e.GrandDivExamId == GrandDivExamId && e.IsDeleted == false);
                if (!_r.Any())    //P2 CHECK EXAM MAPPING IF EXISTS OR NOT  
                {
                    cr.message = "Oops! Grand Policy not exists";
                    cr.httpStatusCode = HttpStatusCode.BadRequest;
                    return cr;
                }
                //Get fisrt Row DividedExam Percentage
                DivExamPercentage = _r.FirstOrDefault().DivExamPercentage;
                //P3 GET EXAM MARK SETUP DETAILS BY THIS SP  MainExamMarkSetupDetails
                var ExamDetails = DataAccess.Instance.GrandConfigService.getDatasetResponseBySp("MainExamMarkSetupDetails", new object[]
                {
                MainExamId, SubExamId,DivExamId,
                GrandExamId, GrandSubExamId, GrandDivExamId
                });
                DataSet ds = ExamDetails.results;
                DataTable mainExam = ds.Tables[0];
                DataTable grandExam = ds.Tables[1];
                List<MainExamMarkSetupDetails> M = Api.APIUitility.ConvertDataTable<MainExamMarkSetupDetails>(mainExam);
                List<GrandExamMarkSetupDetails> G = Api.APIUitility.ConvertDataTable<GrandExamMarkSetupDetails>(grandExam);
                if (!M.Any())  //P4 CHECK EXAM SOURCE
                {
                    cr.message = "Invalid Source";
                    cr.httpStatusCode = HttpStatusCode.BadRequest;
                    return cr;
                }
                if (!G.Any()) //P5 CHEK EXAM TARGET SOURCE
                {
                    cr.message = "Invalid Target";
                    cr.httpStatusCode = HttpStatusCode.BadRequest;
                    return cr;
                }
                foreach (var m in M)
                {
                    GrandExamMarkSetupDetails gm = G.Where(s => s.SubID == m.SubID).FirstOrDefault();
                    // P6 FILTER SUBJECT WISE GRAND EXAM MARKSETUP BASED ON MAIN EXAM MARK SETUP  
                    if (gm != null)
                    {
                        #region  Grand Exam Mark Setup 
                        var GF = DataAccess.Instance.GrandConfigService.Filter(e => e.SubjectId == m.SubID && e.MainExamId == MainExamId && e.GrandExamId == GrandExamId && e.IsDeleted == false);
                        if (GF.Count() == 1)    //P7 CHECK SUBJECT GRAND EXAM MARK SETUP MAPPING EXISTS IN GRAND CONFIG TABLE OR NOT
                        {
                            //P8 GET GRAND EXAM MARK SETUP AND DEDUCT FULLMARKS BASED ON GRAND SETUP PERCENTAGE
                            var gs = DataAccess.Instance.GrandExamMarkSetupService.FirstOrDefault(e => e.GrandExamMarkSetupId == gm.GrandExamMarkSetupId);
                            gs.UpdateBy = User.Identity.Name;
                            gs.SetDate();
                            if (gs.Status == "P")
                            {
                                gs.ExamFullMarks = gs.ExamFullMarks - ((m.FullMarks * DivExamPercentage) / 100);
                                gs.Remarks = "-" + DivExamPercentage;
                            }
                            var gms = DataAccess.Instance.GrandExamMarkSetupService.Update(gs);
                        }

                        #endregion  Grand Exam Mark Setup

                        #region  Grand Sub Exam Mark Setup  
                        var SF = DataAccess.Instance.GrandConfigService.Filter(e => e.SubjectId == m.SubID && e.MainExamId == MainExamId &&
                        e.SubExamId == SubExamId && e.GrandExamId == GrandExamId && e.GrandSubExamId == GrandSubExamId && e.IsDeleted == false);
                        if (SF.Count() == 1)      //P9 CHECK SUBJECT SUB EXAM MARK SETUP MAPPING EXISTS IN GRAND CONFIG TABLE OR NOT
                        {
                            //P10 GET SUB EXAM MARK SETUP AND DEDUCT FULLMARKS BASED ON GRAND SETUP PERCENTAGE
                            var gss = DataAccess.Instance.GrandSubExamMarkSetupService.FirstOrDefault(e => e.GrandSubExamMarkSetupId == gm.GrandSubExamMarkSetupId);
                            gss.UpdateBy = User.Identity.Name;
                            gss.SetDate();
                            if (gss.Status == "P")
                            {
                                gss.SubExamFullMarks = gss.SubExamFullMarks - ((m.SubExamFullMarks * DivExamPercentage) / 100);
                                gss.SubExamExamMarks = gss.SubExamExamMarks - ((m.SubExamExamMarks * DivExamPercentage) / 100);
                                gss.Remarks = "-" + DivExamPercentage;
                            }
                            var gsm = DataAccess.Instance.GrandSubExamMarkSetupService.Update(gss);
                        }

                        #endregion  Grand Exam Mark Setup

                        #region  Grand Divided Exam Mark Setup
                        var DF = DataAccess.Instance.GrandConfigService.Filter(e => e.SubjectId == m.SubID && e.MainExamId == MainExamId && e.SubExamId == SubExamId
                                && e.DivExamId == DivExamId && e.GrandExamId == GrandExamId && e.GrandSubExamId == GrandSubExamId
                                && e.GrandDivExamId == GrandDivExamId && e.IsDeleted == false);
                        if (DF.Any())   //P11 CHECK SUBJECT DIVIDED EXAM MARK SETUP MAPPING EXISTS IN GRAND CONFIG TABLE OR NOT
                        {
                            //P12 GET DIVIDED EXAM MARK SETUP AND DEDUCT FULLMARKS BASED ON GRAND SETUP PERCENTAGE
                            var gds = DataAccess.Instance.GrandDividedExamMarkSetupService.FirstOrDefault(e => e.DividedExamMarkSetupId == gm.DividedExamMarkSetupId);
                            gds.UpdateBy = User.Identity.Name;
                            gds.SetDate();
                            if (gds.Status == "P")
                            {
                                gds.DividedExamFullMarks = gds.DividedExamFullMarks - ((m.DividedExamFullMarks * DivExamPercentage) / 100);
                                gds.DividedExamExamMarks = gds.DividedExamExamMarks - ((m.DividedExamExamMarks * DivExamPercentage) / 100);
                                gds.Remarks = "-" + DivExamPercentage;
                            }
                            var gdm = DataAccess.Instance.GrandDividedExamMarkSetupService.Update(gds);
                        }


                        #endregion  Grand Divided Exam Mark Setup                   
                    }
                }
                #region  Grand Config Table                  

                //P13 REMOVE SUBJECT MAPPINGS FROM  GRAND CONFIG   TABLE
                var res = DataAccess.Instance.GrandConfigService.RemoveRange(_r.ToList());
                cr.message = res ? Constant.SAVED : Constant.FAILED;
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                #endregion  Grand Config Table


            }
            catch (Exception ex)
            {

                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }

            return cr;
        }
        [Route("GrandResult/GrandConfigDelete/{MainExamId}/{SubExamId}/{DivExamId}/{GrandExamId}/{GrandSubExamId}/{GrandDivExamId}")]
        [HttpGet]    
        public IHttpActionResult GrandConfigDelete(int MainExamId, int SubExamId, int DivExamId, int GrandExamId, int GrandSubExamId, int GrandDivExamId)
        {   
            CommonResponse cr = new CommonResponse();
            try
            {
                cr = GrandConfigurationDelete(MainExamId, SubExamId, DivExamId, GrandExamId, GrandSubExamId, GrandDivExamId);
                return Json(cr);
            }
            catch (Exception ex)
            {

                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }

            return Json(cr);
        }
        [Route("GrandResult/BulkGrandConfigDelete/")]
        [HttpPost]
        public IHttpActionResult BulkGrandConfigDelete(List<VMGrandConfigDetail> Grandconfigs)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                foreach(var g in Grandconfigs)
                {
                   cr= GrandConfigurationDelete(g.MainExamId, g.SubExamId, g.DivExamId, g.GrandExamId, g.GrandSubExamId, g.GrandDivExamId);
                    if (cr.httpStatusCode.ToString() == "BadRequest")
                    {
                        cr.HasError = true;
                        return Json(cr);
                    }
                  
                }
         
            }
            catch (Exception ex)
            {

                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }

            return Json(cr);
        }
        [Route("GrandResult/GetAllGrandSetupDetail")]  
        [HttpGet]
        public IHttpActionResult GetAllGrandSetupDetail()
        {
            CommonResponse cr = new CommonResponse();
              //P1 PULL ALL GRANDCONFIG DETAIL BY THIS SP                                              
            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("sp_GetGrandConfigDetail");
            cr.results = Api.APIUitility.ConvertDataTable<VMGrandConfigDetail>(dt); 
            if (cr.results == null)
            {
                return BadRequest(Constant.FAILED);
            }
            return Json(cr);
        }
        [Route("GrandResult/GetGrandSetupDetail/{versionId?}/{sessionId?}/{classId?}/{groupId?}")]  
        [HttpGet]
        public IHttpActionResult GetGrandSetupDetail(int VersionId, int SessionId, int ClassId, string GroupId)
        {
            CommonResponse cr = new CommonResponse();
            object[] param = new object[4]; 
            param[0] = VersionId;
            param[1] = SessionId;
            param[2] = ClassId;            
            if (GroupId == "null" || GroupId == "undefined")
            {
                param[3] = 0;
            }
            else
            {
                param[3] = Convert.ToInt32(GroupId);
            }
            //P1 PULL GRANDCONFIG DETAIL BY THIS SP  FILTER WITH VSCG 
            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("sp_GetGrandConfigDetail",param);
            cr.results = Api.APIUitility.ConvertDataTable<VMGrandConfigDetail>(dt);
            if (cr.results.Count==0) {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = "Data Not Found";
            }
            else
                cr.message = cr.results.Count + "Record Found";
            return Json(cr);
        }         
        [Route("GrandResult/UpdateGrandSetupDetail/")]  
        [HttpPost]
        public IHttpActionResult UpdateGrandSetupDetail(GrandConfig GrandConfig)
        {
            CommonResponse cr = new CommonResponse();
            var res = false;
            if (GrandConfig != null)     // P1 CHECK VALID DATA AND UPDATE GRANDCONFIG
            {
                //Updated GrandConfig
                GrandConfig.UpdateBy = User.Identity.Name;
                GrandConfig.IsDeleted = false;
                GrandConfig.Status = "A";
                GrandConfig.SetDate();
                res = DataAccess.Instance.GrandConfigService.Update(GrandConfig);
            }
            if (res)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.UPDATED;
            }
            else {
                return BadRequest(Constant.FAILED);
            }
            return Json(cr);
        }
        [Route("GrandResult/SingleDeleteGrandConfig/{GrandConfig}")]
        [HttpGet]
        public IHttpActionResult SingleDeleteGrandConfig(int GrandConfig)
        {
            CommonResponse cr = new CommonResponse();
            var res = false;
            if (GrandConfig != 0)   //P1 CHECK AND REMOVE GRANDCONFIG BY ID
            {
                //Delete Grandfig
                res = DataAccess.Instance.GrandConfigService.Remove(GrandConfig);
            }
            if (res)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.DELETED;
            }
            else
            {
                return BadRequest(Constant.DELETE_ERROR);
            }
            return Json(cr);
        }  
        #endregion GrandConfig
        #region GrandMeritListConfig
        [Route("GrandResult/GetGrandMeritListConfig/{VersionId}/{SessionId}/{ClassId}/{GroupId}")]
        [HttpPost]
        public IHttpActionResult GetGrandMeritListConfig(int VersionId, int SessionId, int ClassId, int GroupId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetGrandMeritListConfig", new object[] { VersionId, SessionId, ClassId, GroupId });
                List<GrandMeritListConfig> res = APIUitility.ConvertDataTable<GrandMeritListConfig>(dt);
                cr.results = res;
                if (res.Count() > 0)
                {
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = "Data Found";
                }
                else
                    cr.message = "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/GetGrandAllMeritListConfig/")]
        [HttpGet]
        public IHttpActionResult GetGrandAllMeritListConfig()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //Get All GrandMeritConfif List
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetGrandMeritListConfig");
                List<GrandMeritListConfig> res = APIUitility.ConvertDataTable<GrandMeritListConfig>(dt);
                cr.results = res;
                if (res.Count() > 0)
                {
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = "Data Found";
                }
                else
                    cr.message = "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/CloneGrandMeritListConfig/{clone}/{NewSessionId}/{SessionId}")]
        [HttpGet]
        public IHttpActionResult CloneGrandMeritListConfig(bool clone, int NewSessionId, int SessionId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (!clone && NewSessionId == 0 && SessionId == 0)
                {
                    cr.HasError = true;
                    cr.httpStatusCode = HttpStatusCode.BadRequest;
                    cr.message = Constant.INVAILD_DATA;
                    return Json(cr);
                }
                var exists = DataAccess.Instance.GrandMeritListConfigService.Filter(e => e.SessionId == NewSessionId && e.IsDeleted == false).Distinct().ToList();
                if (exists.Any())
                {
                    cr.HasError = true;
                    cr.httpStatusCode = HttpStatusCode.BadRequest;
                    cr.message = "GrandMeritListConfig Already Exists";
                    return Json(cr);
                }
                //Check Exist GrandMeritListConfig
                var lstml = DataAccess.Instance.GrandMeritListConfigService.Filter(e => e.SessionId == SessionId && e.IsDeleted == false).Distinct().ToList();
                if (lstml.Any())
                {                   
                    foreach (var m in lstml)
                    {
                        GrandMeritListConfig ml = new GrandMeritListConfig();
                        ml = m;
                        ml.MeritListConfigId = 0;
                        ml.SessionId = NewSessionId;
                        ml.AddBy = User.Identity.Name;
                        ml.Status = "A";
                        ml.SetDate();
                        ml.Remarks = "Clone";
                        DataAccess.Instance.GrandMeritListConfigService.Add(ml);
                    }
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = "Clone Successfully";
                }
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("GrandResult/AddGrandMeritListConfig/")]
        [HttpPost]
        public IHttpActionResult AddMeritListConfig(GrandMeritListConfig GrandMeritListConfig)
        {
            CommonResponse cr = new CommonResponse();
            var exists = DataAccess.Instance.GrandMeritListConfigService.Filter(e => e.VersionId == GrandMeritListConfig.VersionId
            && e.SessionId == GrandMeritListConfig.SessionId && e.ClassId == GrandMeritListConfig.ClassId
            && e.GroupId == GrandMeritListConfig.GroupId && e.IsDeleted == false);
            //check Exits
            if (exists.Any())
            {
                cr.message = "Oops! Policy Already Exists";
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return Json(cr);
            }
            //Add GrandMeritListConfig
            bool results = DataAccess.Instance.GrandMeritListConfigService.Add(GrandMeritListConfig);
            if (results)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.SAVED;
                return Json(cr);
            }
            else
            {
                cr.message = Constant.FAILED;
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return Json(cr);
            }
        }
        [Route("GrandResult/UpdateGrandMeritListConfig/")]
        [HttpPut]
        public IHttpActionResult UpdateMeritListConfig(GrandMeritListConfig GrandMeritListConfig)
        {
            CommonResponse cr = new CommonResponse();
            //GrandMeritListConfig Update
            bool results = DataAccess.Instance.GrandMeritListConfigService.Update(GrandMeritListConfig);
            if (results)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.UPDATED;
                return Json(cr);
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = Constant.FAILED;
                return Json(cr);
            }
        }
        [Route("GrandResult/DeleteGrandMeritListConfig/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteMeritListConfig(int id)
        {
            CommonResponse cr = new CommonResponse();
            //Delete GrandMeritListConfig by Id
            bool results = DataAccess.Instance.GrandMeritListConfigService.Remove(id);
            if (results)
            {
                cr.results = GetGrandAllMeritListConfig();
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.DELETED;
                return Json(cr);
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = Constant.FAILED;
                return Json(cr);
            }
        }
        #endregion GrandMeritListConfig
        #region GrandExamResultProces
        [Route("GrandResult/ProccessGrandExam/{versionId}/{sessionID}/{ShiftId}/{classId}/{groupId}/{GrandExamId}")] 
        [HttpGet]
        public IHttpActionResult ProccessGrandExam(int versionID, int sessionID, int ShiftID, int classID, int groupID,int GrandExamId)
        {
            CommonResponse cr = new CommonResponse();
            DataSet ds = DataAccess.Instance.CommonServices.GetDatasetBySp("GetGrandResultCheckUp", new object[] { GrandExamId, versionID, sessionID, ShiftID, classID, groupID });
            if (!Convert.ToBoolean(ds.Tables[ds.Tables.Count - 1].Rows[0]["IsSuccess"]))
            {
                return BadRequest("Error on Procces Checkup.Please Check Procces Check Up Result.");
            }

            var gs = DataAccess.Instance.GrandConfigService.Filter(e => e.GrandExamId == GrandExamId && e.IsDeleted == false).Select(g => g.MainExamId).Distinct().ToList();
            //var gs = DataAccess.Instance.GrandSetupService.Filter(e => e.GrandExamId == groupID && e.IsDeleted == true).ToList();
            if(gs.Any())
            {
                foreach(var mi in gs)
                {         
                    var _mainExamId = DataAccess.Instance.CommonServices.GetDatatableBySQL("SELECT TOP 1 MainExamId FROM Res_MainExamResult WHERE MainExamId=" + mi + "");
                    if((_mainExamId == null) || (_mainExamId.Rows.Count == 0))
                    {
                        cr.httpStatusCode = HttpStatusCode.BadRequest;
                        cr.message = "Main Exam not proceed yet "+mi+"";
                        return Json(cr);
                    }
                }
            }
            DataAccess.Instance.CommonServices.WriteLog(versionID, sessionID, ShiftID, classID, groupID, -1, "G", "Grand Result Proccess Start.", User.Identity.GetUserId());
            cr = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ClearMainExamResult", new object[] { GrandExamId, ShiftID, "G" });
            if (cr.HasError)
            {
                return BadRequest(cr.message);
            }
            else
            {
                DataAccess.Instance.CommonServices.WriteLog(versionID, sessionID, ShiftID, classID, groupID, -1, "G", "Data Cleared", User.Identity.GetUserName());

                var ListmainExam = DataAccess.Instance.GrandSetupService.Filter(e => e.GrandExamId == GrandExamId && e.IsDeleted == false).ToList();
                foreach (var M in ListmainExam)
                {
                    cr = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandExam", new object[] { versionID, sessionID, ShiftID, classID, M.MainExamId, GrandExamId });
                    string mainExamName = DataAccess.Instance.MainExamService.Get(M.MainExamId).MainExamName;
                    DataAccess.Instance.CommonServices.WriteLog(versionID, sessionID, ShiftID, classID, groupID, M.MainExamId, "G", mainExamName + " Procced.", User.Identity.GetUserId());
                }
                cr = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandAllSubjectMarks", new object[] { versionID, sessionID, ShiftID, classID, groupID, GrandExamId });

                if (!cr.HasError==true)
                {
                    cr.httpStatusCode = HttpStatusCode.OK; 
                    cr.results = null;
                    cr.message = Constant.SUCCESS;
                }
                else
                {
                    return BadRequest("Proccess Failed in SubjectDetails!");
                }

                if (DataAccess.Instance.CommonServices.IsExist("ProccessGrandVirtualMarks", "VersionId=" + versionID + " AND SessionId=" + sessionID + " AND ClassId=" + classID + " AND GroupId=" + groupID + " AND GrandExamId=" + GrandExamId))
                {
                    object[] paramVirtual = new object[6];
                    paramVirtual[0] = versionID;
                    paramVirtual[1] = sessionID;
                    paramVirtual[2] = ShiftID;
                    paramVirtual[3] = classID;
                    paramVirtual[4] = groupID;
                    paramVirtual[5] = GrandExamId;
                    cr = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandVirtualMarks", paramVirtual);
                    if (cr.HasError)
                    {
                        return BadRequest(cr.message + " >>> Problem ocurred in Virtual Proccess.");
                    }
                }
                object[] paramsubjectresult = new object[6];
                paramsubjectresult[0] = versionID;
                paramsubjectresult[1] = sessionID;
                paramsubjectresult[2] = ShiftID;
                paramsubjectresult[3] = classID;
                paramsubjectresult[4] = groupID;
                paramsubjectresult[5] = GrandExamId;

                cr = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandSubjectAndResult", paramsubjectresult);
                if (!cr.HasError)
                {
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.results = null;
                    cr.message = Constant.SUCCESS;
                }
                else
                {
                    return BadRequest("Proccess Failed in Result!");
                }

            }
            return Json(cr);
        }
        [Route("GrandResult/ClearProccess/{GrandExamId}/{ShiftId}")]
        [HttpGet]
        public IHttpActionResult ClearProccess(int GrandExamId, int ShiftId)    // Using for MainExam Marks Entry page Subject Dropdown
        {
            CommonResponse cr = new CommonResponse();
            cr = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ClearExamResult", new object[] { GrandExamId, ShiftId, "G" });
            cr.message = "Process cleared Succcessfully.";
            return Json(cr);
        }

        [Route("GrandResult/ProHighestMark/{versionId}/{sessionID}/{ShiftId}/{classId}/{groupId}/{GrandExamId}")]  
        [HttpGet]
        public IHttpActionResult ProHighestMark(int versionID, int sessionID, int ShiftID, int classID, string groupID, int GrandExamId)
        {
            object[] param = new object[6];
            param[0] = versionID;
            param[1] = sessionID;
            param[2] = ShiftID;
            param[3] = classID;
            param[4] = groupID;
            param[5] = GrandExamId;
            CommonResponse cr = new CommonResponse();
            cr = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProcessHighestMark_Grand", param);
            if (!cr.HasError)
                cr.message = "Highest Marks Processed Succcessfully.";
            return Json(cr);
        }
        [Route("GrandResult/ProMerit/{versionId}/{sessionID}/{ShiftId}/{classId}/{groupId}/{GrandExamId}")]
        [HttpGet]
        public IHttpActionResult ProMerit(int versionID, int sessionID, int ShiftId, int classID, string groupID, int GrandExamId)
        {
            string SchoolName = System.Configuration.ConfigurationManager.AppSettings["SchoolShortName"];

            CommonResponse cr = new CommonResponse();
            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetGrandMeritListConfig", new object[] { versionID, sessionID, classID, groupID });
            GrandMeritListConfig Configlist = APIUitility.ConvertDataTable<GrandMeritListConfig>(dt).ToList().FirstOrDefault();

            if (Configlist == null)
            {
                return BadRequest("Merit Configuration not found!");
            }

            var DicShortList = new Dictionary<int, string>();

            var OrderIsAssending = new Dictionary<int, bool>();

            if (Configlist.TotalIsFraction == true)
            {
                DicShortList.Add(Configlist.SortSerialByTotalMark, "TotalConvertedMarksFraction");
                OrderIsAssending.Add(Configlist.SortSerialByTotalMark, false);

                DicShortList.Add(Configlist.MainTotalMark, "MainTotalConvertedMarksFraction");
                OrderIsAssending.Add(Configlist.MainTotalMark, false);
            }
            else 
            {
                DicShortList.Add(Configlist.SortSerialByTotalMark, "TotalConvertedMarks");
                OrderIsAssending.Add(Configlist.SortSerialByTotalMark, false);

                DicShortList.Add(Configlist.MainTotalMark, "MainTotalConvertedMarks");
                OrderIsAssending.Add(Configlist.MainTotalMark, false);
            }

            DicShortList.Add(Configlist.SortSerialByGPAWith4th, "GPA");
            OrderIsAssending.Add(Configlist.SortSerialByGPAWith4th, false);
            DicShortList.Add(Configlist.MainGPAW4th, "MainGPA");
            OrderIsAssending.Add(Configlist.MainGPAW4th, false);


            //DicShortList.Add(Configlist[0].SortSerialByGPAWithout4th, "GPAWithOut4Sub");
            //DicOrderIsAssending.Add(Configlist[0].SortSerialByGPAWithout4th, false);

            if (SchoolName == "sos")
            {
                DicShortList.Add(Configlist.SortSerialByGPAWithout4th, "MyProperty");
                OrderIsAssending.Add(Configlist.SortSerialByGPAWithout4th, false);
            }
            else if (SchoolName == "glhs")
            {
                DicShortList.Add(Configlist.SortSerialByGPAWithout4th, "TotalGP");
                OrderIsAssending.Add(Configlist.SortSerialByGPAWithout4th, false);


            }
            else
            {
                DicShortList.Add(Configlist.SortSerialByGPAWithout4th, "GPAWithOut4Sub");
                OrderIsAssending.Add(Configlist.SortSerialByGPAWithout4th, false);
            }


            DicShortList.Add(Configlist.MainGPAWO4th, "MainGPAWithOut4Sub");
            OrderIsAssending.Add(Configlist.MainGPAWO4th, false);

            DicShortList.Add(Configlist.SortSerialByRoll, "RollNo");
            OrderIsAssending.Add(Configlist.SortSerialByRoll, true);
            DicShortList.Add(Configlist.SortSerialByName, "FullName");
            OrderIsAssending.Add(Configlist.SortSerialByName, true);

            DicShortList.Add(Configlist.SortSerialBySubjectId1, "MeritSubjectMarks1");
            DicShortList.Add(Configlist.SortSerialBySubjectId2, "MeritSubjectMarks2");
            DicShortList.Add(Configlist.SortSerialBySubjectId3, "MeritSubjectMarks3");

            OrderIsAssending.Add(Configlist.SortSerialBySubjectId1, false);
            OrderIsAssending.Add(Configlist.SortSerialBySubjectId2, false);
            OrderIsAssending.Add(Configlist.SortSerialBySubjectId3, false);

            DicShortList.Add(Configlist.NoOfAttendExam, "NumberOfExam");
            OrderIsAssending.Add(Configlist.NoOfAttendExam, false); 




            object[] param = new object[4]; 

            param[0] = sessionID;
            param[1] = classID;
            param[2] = groupID;
            param[3] = GrandExamId;
            var dtMerit = DataAccess.Instance.CommonServices.GetBySpWithParam("ProccessGrandMerit", param);
            List<GrandMeritVM> meritlist = new List<GrandMeritVM>();
            meritlist = APIUitility.ConvertDataTable<GrandMeritVM>(dtMerit).ToList();

            if (meritlist.Count > 0)
            {
                object[] paramReset = new object[4];
                paramReset[0] = sessionID;
                paramReset[1] = classID;
                paramReset[2] = groupID;
                paramReset[3] = GrandExamId;
                DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ResetGrandMerit", paramReset);

                if (SchoolName == "SCPSC")
                {
                            meritlist = meritlist.OrderBy(x => OrderIsAssending[1] ? x.GetType().GetProperty(DicShortList[1]).GetValue(x, null) : "0").
                            ThenByDescending(x => !OrderIsAssending[1] ? x.GetType().GetProperty(DicShortList[1]).GetValue(x, null) : "0").

                            ThenBy(x => OrderIsAssending[2] ? x.GetType().GetProperty(DicShortList[2]).GetValue(x, null) : "0").
                            ThenByDescending(x => !OrderIsAssending[2] ? x.GetType().GetProperty(DicShortList[2]).GetValue(x, null) : "0").

                            ThenBy(x => OrderIsAssending[3] ? x.GetType().GetProperty(DicShortList[3]).GetValue(x, null) : "0").
                            ThenByDescending(x => !OrderIsAssending[3] ? x.GetType().GetProperty(DicShortList[3]).GetValue(x, null) : "0").

                            ThenBy(x => OrderIsAssending[4] ? x.GetType().GetProperty(DicShortList[4]).GetValue(x, null) : "0").
                            ThenByDescending(x => !OrderIsAssending[4] ? x.GetType().GetProperty(DicShortList[4]).GetValue(x, null) : "0").

                            ThenBy(x => OrderIsAssending[5] ? x.GetType().GetProperty(DicShortList[5]).GetValue(x, null) : "0").
                            ThenByDescending(x => !OrderIsAssending[5] ? x.GetType().GetProperty(DicShortList[5]).GetValue(x, null) : "0").

                            ThenBy(x => OrderIsAssending[6] ? x.GetType().GetProperty(DicShortList[6]).GetValue(x, null) : "0").
                            ThenByDescending(x => !OrderIsAssending[6] ? x.GetType().GetProperty(DicShortList[6]).GetValue(x, null) : "0").

                            ThenBy(x => OrderIsAssending[7] ? x.GetType().GetProperty(DicShortList[7]).GetValue(x, null) : "0").
                            ThenByDescending(x => !OrderIsAssending[7] ? x.GetType().GetProperty(DicShortList[7]).GetValue(x, null) : "0").

                            ThenBy(x => OrderIsAssending[8] ? x.GetType().GetProperty(DicShortList[8]).GetValue(x, null) : "0").
                            ThenByDescending(x => !OrderIsAssending[8] ? x.GetType().GetProperty(DicShortList[8]).GetValue(x, null) : "0").

                            ThenBy(x => OrderIsAssending[9] ? x.GetType().GetProperty(DicShortList[9]).GetValue(x, null) : "0").
                           ThenByDescending(x => !OrderIsAssending[9] ? x.GetType().GetProperty(DicShortList[9]).GetValue(x, null) : "0").

                            ThenBy(x => OrderIsAssending[10] ? x.GetType().GetProperty(DicShortList[10]).GetValue(x, null) : "0").
                           ThenByDescending(x => !OrderIsAssending[10] ? x.GetType().GetProperty(DicShortList[10]).GetValue(x, null) : "0").

                           ThenBy(x => OrderIsAssending[11] ? x.GetType().GetProperty(DicShortList[11]).GetValue(x, null) : "0").
                           ThenByDescending(x => !OrderIsAssending[11] ? x.GetType().GetProperty(DicShortList[11]).GetValue(x, null) : "0").

                           ThenBy(x => OrderIsAssending[11] ? x.GetType().GetProperty(DicShortList[12]).GetValue(x, null) : "0").
                           ThenByDescending(x => !OrderIsAssending[11] ? x.GetType().GetProperty(DicShortList[12]).GetValue(x, null) : "0").ToList();

                    if (meritlist.Count > 20)
                    {
                        meritlist = meritlist.Take(20).ToList();
                    }
                }
               

                else
                {

                    meritlist = meritlist.OrderBy(x => OrderIsAssending[1] ? x.GetType().GetProperty(DicShortList[1]).GetValue(x, null) : "0").
                ThenByDescending(x => !OrderIsAssending[1] ? x.GetType().GetProperty(DicShortList[1]).GetValue(x, null) : "0").

                ThenBy(x => OrderIsAssending[2] ? x.GetType().GetProperty(DicShortList[2]).GetValue(x, null) : "0").
                ThenByDescending(x => !OrderIsAssending[2] ? x.GetType().GetProperty(DicShortList[2]).GetValue(x, null) : "0").

                ThenBy(x => OrderIsAssending[3] ? x.GetType().GetProperty(DicShortList[3]).GetValue(x, null) : "0").
                ThenByDescending(x => !OrderIsAssending[3] ? x.GetType().GetProperty(DicShortList[3]).GetValue(x, null) : "0").

                ThenBy(x => OrderIsAssending[4] ? x.GetType().GetProperty(DicShortList[4]).GetValue(x, null) : "0").
                ThenByDescending(x => !OrderIsAssending[4] ? x.GetType().GetProperty(DicShortList[4]).GetValue(x, null) : "0").

                ThenBy(x => OrderIsAssending[5] ? x.GetType().GetProperty(DicShortList[5]).GetValue(x, null) : "0").
                ThenByDescending(x => !OrderIsAssending[5] ? x.GetType().GetProperty(DicShortList[5]).GetValue(x, null) : "0").

                ThenBy(x => OrderIsAssending[6] ? x.GetType().GetProperty(DicShortList[6]).GetValue(x, null) : "0").
                ThenByDescending(x => !OrderIsAssending[6] ? x.GetType().GetProperty(DicShortList[6]).GetValue(x, null) : "0").

                ThenBy(x => OrderIsAssending[7] ? x.GetType().GetProperty(DicShortList[7]).GetValue(x, null) : "0").
                ThenByDescending(x => !OrderIsAssending[7] ? x.GetType().GetProperty(DicShortList[7]).GetValue(x, null) : "0").

                ThenBy(x => OrderIsAssending[8] ? x.GetType().GetProperty(DicShortList[8]).GetValue(x, null) : "0").
                ThenByDescending(x => !OrderIsAssending[8] ? x.GetType().GetProperty(DicShortList[8]).GetValue(x, null) : "0").

                ThenBy(x => OrderIsAssending[9] ? x.GetType().GetProperty(DicShortList[9]).GetValue(x, null) : "0").
               ThenByDescending(x => !OrderIsAssending[9] ? x.GetType().GetProperty(DicShortList[9]).GetValue(x, null) : "0").

                ThenBy(x => OrderIsAssending[10] ? x.GetType().GetProperty(DicShortList[10]).GetValue(x, null) : "0").
               ThenByDescending(x => !OrderIsAssending[10] ? x.GetType().GetProperty(DicShortList[10]).GetValue(x, null) : "0").

               ThenBy(x => OrderIsAssending[11] ? x.GetType().GetProperty(DicShortList[11]).GetValue(x, null) : "0").
               ThenByDescending(x => !OrderIsAssending[11] ? x.GetType().GetProperty(DicShortList[11]).GetValue(x, null) : "0").ToList();

                }

                #region OvaralMerit
                int OvaralPosition = 0;
                decimal lastMark = 0;
                foreach (var row in meritlist)
                {

                    OvaralPosition++;
                    object[] paramUpdate = new object[4];
                    paramUpdate[0] = row.GrandExamId;
                    paramUpdate[1] = row.StudentIID;
                    paramUpdate[2] = OvaralPosition;
                    paramUpdate[3] = "O";
                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                }
                #endregion

                #region ClassWiseMerit
                List<GrandMeritVM> ClassWisemeritlist1 = new List<GrandMeritVM>();
                List<GrandMeritVM> ClassWisemeritlist2 = new List<GrandMeritVM>();
                ClassWisemeritlist1 = meritlist.Where(x => x.ClassId == classID).ToList();
                ClassWisemeritlist2 = meritlist.Where(x => x.ClassId != classID).ToList();
                int classPosition1 = 0;
                int classPosition2 = 0;
                if (ClassWisemeritlist1.Count > 0)
                {
                    lastMark = 0;
                    foreach (var row in ClassWisemeritlist1)
                    {
                        classPosition1++;
                        if (Configlist.TotalMarkSameMerit)
                        {
                            if (lastMark == row.TotalConvertedMarks)
                                classPosition1 = classPosition1 - 1;
                        }

                       
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = classPosition1;
                        paramUpdate[3] = "C";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);
                        lastMark = row.TotalConvertedMarks;
                    }
                }

                if (ClassWisemeritlist2.Count > 0)
                {

                    foreach (var row in ClassWisemeritlist2)
                    {
                        classPosition2++;
                        if (Configlist.TotalMarkSameMerit)
                        {
                            if (lastMark == row.TotalConvertedMarks)
                                classPosition2 = classPosition2 - 1;
                        }
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = classPosition2;
                        paramUpdate[3] = "C";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);
                        lastMark = row.TotalConvertedMarks;
                    }
                }
                #endregion

                #region ShiftWiseMerit

                List<GrandMeritVM> ShiftWisemeritlist11 = new List<GrandMeritVM>();
                List<GrandMeritVM> ShiftWisemeritlist12 = new List<GrandMeritVM>();
                List<GrandMeritVM> ShiftWisemeritlist21 = new List<GrandMeritVM>();
                List<GrandMeritVM> ShiftWisemeritlist22 = new List<GrandMeritVM>();

                ShiftWisemeritlist11 = ClassWisemeritlist1.Where(x => x.ShiftID == ShiftId).ToList();
                ShiftWisemeritlist12 = ClassWisemeritlist1.Where(x => x.ShiftID != ShiftId).ToList();
                ShiftWisemeritlist21 = ClassWisemeritlist2.Where(x => x.ShiftID == ShiftId).ToList();
                ShiftWisemeritlist22 = ClassWisemeritlist2.Where(x => x.ShiftID != ShiftId).ToList();

                int ShiftPosition11 = 0;
                int ShiftPosition12 = 0;
                int ShiftPosition21 = 0;
                int ShiftPosition22 = 0;
                if (ShiftWisemeritlist11.Count > 0)
                {
                    foreach (var row in ShiftWisemeritlist11)
                    {

                        ShiftPosition11++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = ShiftPosition11;
                        paramUpdate[3] = "S";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }

                    #region SectionWiseMerit
                    object[] pramsec = new object[2];
                    pramsec[0] = classID;
                    pramsec[1] = groupID;
                    var dtSection = DataAccess.Instance.CommonServices.GetBySpWithParam("AllSectionClassWise", pramsec);

                    if (dtSection.Rows.Count > 0)
                    {
                        foreach (DataRow r in dtSection.Rows)
                        {
                            var sid = Convert.ToInt32(r["SectionId"].ToString());

                            List<GrandMeritVM> meritlistsection = new List<GrandMeritVM>();
                            meritlistsection = ShiftWisemeritlist11.Where(x => x.SectionId == sid).ToList();
                            int SectionPosition = 0;

                            if (meritlistsection.Count > 0)
                            {
                                foreach (var row in meritlistsection)
                                {
                                    SectionPosition++;
                                    object[] paramUpdate = new object[4];
                                    paramUpdate[0] = row.GrandExamId;
                                    paramUpdate[1] = row.StudentIID;
                                    paramUpdate[2] = SectionPosition;
                                    paramUpdate[3] = "E";
                                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                                }
                            }
                        }
                    }

                    #endregion
                }

                if (ShiftWisemeritlist12.Count > 0)
                {
                    foreach (var row in ShiftWisemeritlist12)
                    {

                        ShiftPosition12++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = ShiftPosition12;
                        paramUpdate[3] = "S";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }

                    #region SectionWiseMerit
                    object[] pramsec = new object[2];
                    pramsec[0] = classID;
                    pramsec[1] = groupID;
                    var dtSection = DataAccess.Instance.CommonServices.GetBySpWithParam("AllSectionClassWise", pramsec);

                    if (dtSection.Rows.Count > 0)
                    {
                        foreach (DataRow r in dtSection.Rows)
                        {
                            var sid = Convert.ToInt32(r["SectionId"].ToString());

                            List<GrandMeritVM> meritlistsection = new List<GrandMeritVM>();
                            meritlistsection = ShiftWisemeritlist12.Where(x => x.SectionId == sid).ToList();
                            int SectionPosition = 0;

                            if (meritlistsection.Count > 0)
                            {
                                foreach (var row in meritlistsection)
                                {
                                    SectionPosition++;
                                    object[] paramUpdate = new object[4];
                                    paramUpdate[0] = row.GrandExamId;
                                    paramUpdate[1] = row.StudentIID;
                                    paramUpdate[2] = SectionPosition;
                                    paramUpdate[3] = "E";
                                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                                }
                            }
                        }
                    }

                    #endregion
                }
                if (ShiftWisemeritlist21.Count > 0)
                {

                    foreach (var row in ShiftWisemeritlist21)
                    {

                        ShiftPosition21++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = ShiftPosition21;
                        paramUpdate[3] = "S";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }


                    #region SectionWiseMerit
                    object[] pramsec = new object[2];
                    pramsec[0] = classID;
                    pramsec[1] = groupID;
                    var dtSection = DataAccess.Instance.CommonServices.GetBySpWithParam("AllSectionClassWise", pramsec);

                    if (dtSection.Rows.Count > 0)
                    {
                        foreach (DataRow r in dtSection.Rows)
                        {
                            var sid = Convert.ToInt32(r["SectionId"].ToString());

                            List<GrandMeritVM> meritlistsection = new List<GrandMeritVM>();
                            meritlistsection = ShiftWisemeritlist21.Where(x => x.SectionId == sid).ToList();
                            int SectionPosition = 0;

                            if (meritlistsection.Count > 0)
                            {
                                foreach (var row in meritlistsection)
                                {
                                    SectionPosition++;
                                    object[] paramUpdate = new object[4];
                                    paramUpdate[0] = row.GrandExamId;
                                    paramUpdate[1] = row.StudentIID;
                                    paramUpdate[2] = SectionPosition;
                                    paramUpdate[3] = "E";
                                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                                }
                            }
                        }
                    }

                    #endregion
                }

                if (ShiftWisemeritlist22.Count > 0)
                {


                    foreach (var row in ShiftWisemeritlist22)
                    {

                        ShiftPosition22++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = ShiftPosition22;
                        paramUpdate[3] = "S";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }

                    #region SectionWiseMerit
                    object[] pramsec = new object[2];
                    pramsec[0] = classID;
                    pramsec[1] = groupID;
                    var dtSection = DataAccess.Instance.CommonServices.GetBySpWithParam("AllSectionClassWise", pramsec);

                    if (dtSection.Rows.Count > 0)
                    {
                        foreach (DataRow r in dtSection.Rows)
                        {
                            var sid = Convert.ToInt32(r["SectionId"].ToString());

                            List<GrandMeritVM> meritlistsection = new List<GrandMeritVM>();
                            meritlistsection = ShiftWisemeritlist22.Where(x => x.SectionId == sid).ToList();
                            int SectionPosition = 0;

                            if (meritlistsection.Count > 0)
                            {
                                foreach (var row in meritlistsection)
                                {
                                    SectionPosition++;
                                    object[] paramUpdate = new object[4];
                                    paramUpdate[0] = row.GrandExamId;
                                    paramUpdate[1] = row.StudentIID;
                                    paramUpdate[2] = SectionPosition;
                                    paramUpdate[3] = "E";
                                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                                }
                            }
                        }
                    }

                    #endregion
                }
                #endregion
               
            }

            if (SchoolName == "SCPSC")
            {

                ProMeritAtendExam( versionID,  sessionID,  ShiftId,  classID,  groupID,  GrandExamId);
            }

            if (SchoolName == "ZCPSC")
            {

                ProMeritGrouping(versionID, sessionID, ShiftId, classID, groupID, GrandExamId);
            }



            if (!cr.HasError)
                cr.message = "Merit Processed Succcessfully.";
            return Json(cr);
        }

        public IHttpActionResult ProMeritGrouping(int versionID, int sessionID, int ShiftId, int classID, string groupID, int GrandExamId)
        {
            CommonResponse cr = new CommonResponse();
            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetGrandMeritListConfig", new object[] { versionID, sessionID, classID, groupID });
            List<GrandMeritListConfig> Configlist = APIUitility.ConvertDataTable<GrandMeritListConfig>(dt);

            if (Configlist.Count == 0)
            {
                return BadRequest("Merit Configuration not found!");
            }

            var DicShortList = new Dictionary<int, string>();

            var DicOrderIsAssending = new Dictionary<int, bool>();

            if (Configlist[0].TotalIsFraction == true)
            {
                DicShortList.Add(Configlist[0].SortSerialByTotalMark, "TotalConvertedMarksFraction");
                DicOrderIsAssending.Add(Configlist[0].SortSerialByTotalMark, false);

                DicShortList.Add(Configlist[0].MainTotalMark, "MainTotalConvertedMarksFraction");
                DicOrderIsAssending.Add(Configlist[0].MainTotalMark, false);
            }
            else
            {
                DicShortList.Add(Configlist[0].SortSerialByTotalMark, "TotalConvertedMarks");
                DicOrderIsAssending.Add(Configlist[0].SortSerialByTotalMark, false);

                DicShortList.Add(Configlist[0].MainTotalMark, "MainTotalConvertedMarks");
                DicOrderIsAssending.Add(Configlist[0].MainTotalMark, false);
            }

            DicShortList.Add(Configlist[0].SortSerialByGPAWith4th, "GPA");
            DicOrderIsAssending.Add(Configlist[0].SortSerialByGPAWith4th, false);
            DicShortList.Add(Configlist[0].MainGPAW4th, "MainGPA");
            DicOrderIsAssending.Add(Configlist[0].MainGPAW4th, false);


            DicShortList.Add(Configlist[0].SortSerialByGPAWithout4th, "GPAWithOut4Sub");
            DicOrderIsAssending.Add(Configlist[0].SortSerialByGPAWithout4th, false);
            DicShortList.Add(Configlist[0].MainGPAWO4th, "MainGPAWithOut4Sub");
            DicOrderIsAssending.Add(Configlist[0].MainGPAWO4th, false);

            DicShortList.Add(Configlist[0].SortSerialByRoll, "RollNo");
            DicOrderIsAssending.Add(Configlist[0].SortSerialByRoll, true);
            DicShortList.Add(Configlist[0].SortSerialByName, "FullName");
            DicOrderIsAssending.Add(Configlist[0].SortSerialByName, true);

            DicShortList.Add(Configlist[0].SortSerialBySubjectId1, "MeritSubjectMarks1");
            DicShortList.Add(Configlist[0].SortSerialBySubjectId2, "MeritSubjectMarks2");
            DicShortList.Add(Configlist[0].SortSerialBySubjectId3, "MeritSubjectMarks3");

            DicOrderIsAssending.Add(Configlist[0].SortSerialBySubjectId1, true);
            DicOrderIsAssending.Add(Configlist[0].SortSerialBySubjectId2, true);
            DicOrderIsAssending.Add(Configlist[0].SortSerialBySubjectId3, true);


            object[] param = new object[4];

            param[0] = sessionID;
            param[1] = classID;
            param[2] = groupID;
            param[3] = GrandExamId;

            var dtMeritBothPass = DataAccess.Instance.CommonServices.GetBySpWithParam("ProccessGrandMerit", param);
            List<GrandMeritVM> meritlistBothPass = new List<GrandMeritVM>();
            meritlistBothPass = APIUitility.ConvertDataTable<GrandMeritVM>(dtMeritBothPass).ToList();

            var dtMerit = DataAccess.Instance.CommonServices.GetBySpWithParam("ProccessGrandMeritAttendExamGroup", param);
            List<GrandMeritVM> meritlist = new List<GrandMeritVM>();
            meritlist = APIUitility.ConvertDataTable<GrandMeritVM>(dtMerit).ToList();


            if (meritlist.Count > 0)
            {
            meritlist = meritlist.OrderBy(x => DicOrderIsAssending[1] ? x.GetType().GetProperty(DicShortList[1]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[1] ? x.GetType().GetProperty(DicShortList[1]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[2] ? x.GetType().GetProperty(DicShortList[2]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[2] ? x.GetType().GetProperty(DicShortList[2]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[3] ? x.GetType().GetProperty(DicShortList[3]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[3] ? x.GetType().GetProperty(DicShortList[3]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[4] ? x.GetType().GetProperty(DicShortList[4]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[4] ? x.GetType().GetProperty(DicShortList[4]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[5] ? x.GetType().GetProperty(DicShortList[5]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[5] ? x.GetType().GetProperty(DicShortList[5]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[6] ? x.GetType().GetProperty(DicShortList[6]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[6] ? x.GetType().GetProperty(DicShortList[6]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[7] ? x.GetType().GetProperty(DicShortList[7]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[7] ? x.GetType().GetProperty(DicShortList[7]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[8] ? x.GetType().GetProperty(DicShortList[8]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[8] ? x.GetType().GetProperty(DicShortList[8]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[9] ? x.GetType().GetProperty(DicShortList[9]).GetValue(x, null) : "0").
           ThenByDescending(x => !DicOrderIsAssending[9] ? x.GetType().GetProperty(DicShortList[9]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[10] ? x.GetType().GetProperty(DicShortList[10]).GetValue(x, null) : "0").
           ThenByDescending(x => !DicOrderIsAssending[10] ? x.GetType().GetProperty(DicShortList[10]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[11] ? x.GetType().GetProperty(DicShortList[11]).GetValue(x, null) : "0").
           ThenByDescending(x => !DicOrderIsAssending[11] ? x.GetType().GetProperty(DicShortList[11]).GetValue(x, null) : "0").ToList();



                meritlistBothPass = meritlistBothPass.OrderBy(x => DicOrderIsAssending[1] ? x.GetType().GetProperty(DicShortList[1]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[1] ? x.GetType().GetProperty(DicShortList[1]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[2] ? x.GetType().GetProperty(DicShortList[2]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[2] ? x.GetType().GetProperty(DicShortList[2]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[3] ? x.GetType().GetProperty(DicShortList[3]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[3] ? x.GetType().GetProperty(DicShortList[3]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[4] ? x.GetType().GetProperty(DicShortList[4]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[4] ? x.GetType().GetProperty(DicShortList[4]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[5] ? x.GetType().GetProperty(DicShortList[5]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[5] ? x.GetType().GetProperty(DicShortList[5]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[6] ? x.GetType().GetProperty(DicShortList[6]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[6] ? x.GetType().GetProperty(DicShortList[6]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[7] ? x.GetType().GetProperty(DicShortList[7]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[7] ? x.GetType().GetProperty(DicShortList[7]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[8] ? x.GetType().GetProperty(DicShortList[8]).GetValue(x, null) : "0").
            ThenByDescending(x => !DicOrderIsAssending[8] ? x.GetType().GetProperty(DicShortList[8]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[9] ? x.GetType().GetProperty(DicShortList[9]).GetValue(x, null) : "0").
           ThenByDescending(x => !DicOrderIsAssending[9] ? x.GetType().GetProperty(DicShortList[9]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[10] ? x.GetType().GetProperty(DicShortList[10]).GetValue(x, null) : "0").
           ThenByDescending(x => !DicOrderIsAssending[10] ? x.GetType().GetProperty(DicShortList[10]).GetValue(x, null) : "0").

            ThenBy(x => DicOrderIsAssending[11] ? x.GetType().GetProperty(DicShortList[11]).GetValue(x, null) : "0").
           ThenByDescending(x => !DicOrderIsAssending[11] ? x.GetType().GetProperty(DicShortList[11]).GetValue(x, null) : "0").ToList();

                #region OvaralMerit
                int OvaralPosition = meritlistBothPass.Count;
            
                foreach (var row in meritlist)
                {

                    OvaralPosition++;
                    object[] paramUpdate = new object[4];
                    paramUpdate[0] = row.GrandExamId;
                    paramUpdate[1] = row.StudentIID;
                    paramUpdate[2] = OvaralPosition;
                    paramUpdate[3] = "O";
                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                }
                #endregion

                #region ClassWiseMerit
                List<GrandMeritVM> ClassWisemeritlist1 = new List<GrandMeritVM>();
                List<GrandMeritVM> ClassWisemeritlist2 = new List<GrandMeritVM>();

                ClassWisemeritlist1 = meritlist.Where(x => x.ClassId == classID).ToList();
                ClassWisemeritlist2 = meritlist.Where(x => x.ClassId != classID).ToList();

                List<GrandMeritVM> ClassWisemeritlistBothPass1 = new List<GrandMeritVM>();
                List<GrandMeritVM> ClassWisemeritlistBothPass2 = new List<GrandMeritVM>();
                ClassWisemeritlistBothPass1 = meritlistBothPass.Where(x => x.ClassId == classID).ToList();
                ClassWisemeritlistBothPass2 = meritlistBothPass.Where(x => x.ClassId != classID).ToList();


                int classPosition1 = ClassWisemeritlistBothPass1.Count;
                int classPosition2 = ClassWisemeritlistBothPass2.Count;
                if (ClassWisemeritlist1.Count > 0)
                {
                    foreach (var row in ClassWisemeritlist1)
                    {

                        classPosition1++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = classPosition1;
                        paramUpdate[3] = "C";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }
                }

                if (ClassWisemeritlist2.Count > 0)
                {

                    foreach (var row in ClassWisemeritlist2)
                    {

                        classPosition2++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = classPosition2;
                        paramUpdate[3] = "C";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }
                }
                #endregion

                #region ShiftWiseMerit

                List<GrandMeritVM> ShiftWisemeritlist11 = new List<GrandMeritVM>();
                List<GrandMeritVM> ShiftWisemeritlist12 = new List<GrandMeritVM>();
                List<GrandMeritVM> ShiftWisemeritlist21 = new List<GrandMeritVM>();
                List<GrandMeritVM> ShiftWisemeritlist22 = new List<GrandMeritVM>();

                ShiftWisemeritlist11 = ClassWisemeritlist1.Where(x => x.ShiftID == ShiftId).ToList();
                ShiftWisemeritlist12 = ClassWisemeritlist1.Where(x => x.ShiftID != ShiftId).ToList();
                ShiftWisemeritlist21 = ClassWisemeritlist2.Where(x => x.ShiftID == ShiftId).ToList();
                ShiftWisemeritlist22 = ClassWisemeritlist2.Where(x => x.ShiftID != ShiftId).ToList();



                List<GrandMeritVM> ShiftWisemeritlistBothPass11 = new List<GrandMeritVM>();
                List<GrandMeritVM> ShiftWisemeritlistBothPass12 = new List<GrandMeritVM>();
                List<GrandMeritVM> ShiftWisemeritlistBothPass21 = new List<GrandMeritVM>();
                List<GrandMeritVM> ShiftWisemeritlistBothPass22 = new List<GrandMeritVM>();

                ShiftWisemeritlistBothPass11 = ClassWisemeritlistBothPass1.Where(x => x.ShiftID == ShiftId).ToList();
                ShiftWisemeritlistBothPass12 = ClassWisemeritlistBothPass1.Where(x => x.ShiftID != ShiftId).ToList();
                ShiftWisemeritlistBothPass21 = ClassWisemeritlistBothPass2.Where(x => x.ShiftID == ShiftId).ToList();
                ShiftWisemeritlistBothPass22 = ClassWisemeritlistBothPass2.Where(x => x.ShiftID != ShiftId).ToList();

                int ShiftPosition11 = ShiftWisemeritlistBothPass11.Count;
                int ShiftPosition12 = ShiftWisemeritlistBothPass12.Count;
                int ShiftPosition21 = ShiftWisemeritlistBothPass21.Count;
                int ShiftPosition22 = ShiftWisemeritlistBothPass22.Count;

                if (ShiftWisemeritlist11.Count > 0)
                {
                    foreach (var row in ShiftWisemeritlist11)
                    {

                        ShiftPosition11++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = ShiftPosition11;
                        paramUpdate[3] = "S";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }

                    #region SectionWiseMerit
                    object[] pramsec = new object[2];
                    pramsec[0] = classID;
                    pramsec[1] = groupID;
                    var dtSection = DataAccess.Instance.CommonServices.GetBySpWithParam("AllSectionClassWise", pramsec);

                    if (dtSection.Rows.Count > 0)
                    {
                        foreach (DataRow r in dtSection.Rows)
                        {
                            var sid = Convert.ToInt32(r["SectionId"].ToString());

                            List<GrandMeritVM> meritlistsection = new List<GrandMeritVM>();
                            meritlistsection = ShiftWisemeritlist11.Where(x => x.SectionId == sid).ToList();

                            List<GrandMeritVM> meritlistsectionBothPass = new List<GrandMeritVM>();
                            meritlistsectionBothPass = ShiftWisemeritlistBothPass11.Where(x => x.SectionId == sid).ToList();
                            int SectionPosition = meritlistsectionBothPass.Count;
                            if (meritlistsection.Count > 0)
                            {
                                foreach (var row in meritlistsection)
                                {
                                    SectionPosition++;
                                    object[] paramUpdate = new object[4];
                                    paramUpdate[0] = row.GrandExamId;
                                    paramUpdate[1] = row.StudentIID;
                                    paramUpdate[2] = SectionPosition;
                                    paramUpdate[3] = "E";
                                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                                }
                            }
                        }
                    }

                    #endregion
                }

                if (ShiftWisemeritlist12.Count > 0)
                {
                    foreach (var row in ShiftWisemeritlist12)
                    {

                        ShiftPosition12++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = ShiftPosition12;
                        paramUpdate[3] = "S";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }

                    #region SectionWiseMerit
                    object[] pramsec = new object[2];
                    pramsec[0] = classID;
                    pramsec[1] = groupID;
                    var dtSection = DataAccess.Instance.CommonServices.GetBySpWithParam("AllSectionClassWise", pramsec);

                    if (dtSection.Rows.Count > 0)
                    {
                        foreach (DataRow r in dtSection.Rows)
                        {
                            var sid = Convert.ToInt32(r["SectionId"].ToString());

                            List<GrandMeritVM> meritlistsection = new List<GrandMeritVM>();
                            meritlistsection = ShiftWisemeritlist12.Where(x => x.SectionId == sid).ToList();

                            List<GrandMeritVM> meritlistsectionBothPass = new List<GrandMeritVM>();
                            meritlistsectionBothPass = ShiftWisemeritlistBothPass12.Where(x => x.SectionId == sid).ToList();

                            int SectionPosition = meritlistsectionBothPass.Count;
                          
                            if (meritlistsection.Count > 0)
                            {
                                foreach (var row in meritlistsection)
                                {
                                    SectionPosition++;
                                    object[] paramUpdate = new object[4];
                                    paramUpdate[0] = row.GrandExamId;
                                    paramUpdate[1] = row.StudentIID;
                                    paramUpdate[2] = SectionPosition;
                                    paramUpdate[3] = "E";
                                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                                }
                            }
                        }
                    }

                    #endregion
                }
                if (ShiftWisemeritlist21.Count > 0)
                {

                    foreach (var row in ShiftWisemeritlist21)
                    {

                        ShiftPosition21++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = ShiftPosition21;
                        paramUpdate[3] = "S";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }

                    #region SectionWiseMerit
                    object[] pramsec = new object[2];
                    pramsec[0] = classID;
                    pramsec[1] = groupID;
                    var dtSection = DataAccess.Instance.CommonServices.GetBySpWithParam("AllSectionClassWise", pramsec);

                    if (dtSection.Rows.Count > 0)
                    {
                        foreach (DataRow r in dtSection.Rows)
                        {
                            var sid = Convert.ToInt32(r["SectionId"].ToString());

                            List<GrandMeritVM> meritlistsection = new List<GrandMeritVM>();
                            meritlistsection = ShiftWisemeritlist21.Where(x => x.SectionId == sid).ToList();

                            List<GrandMeritVM> meritlistsectionBothPass = new List<GrandMeritVM>();
                            meritlistsectionBothPass = ShiftWisemeritlistBothPass21.Where(x => x.SectionId == sid).ToList();

                            int SectionPosition = meritlistsectionBothPass.Count;
                          
                            if (meritlistsection.Count > 0)
                            {
                                foreach (var row in meritlistsection)
                                {
                                    SectionPosition++;
                                    object[] paramUpdate = new object[4];
                                    paramUpdate[0] = row.GrandExamId;
                                    paramUpdate[1] = row.StudentIID;
                                    paramUpdate[2] = SectionPosition;
                                    paramUpdate[3] = "E";
                                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                                }
                            }
                        }
                    }

                    #endregion


                }

                if (ShiftWisemeritlist22.Count > 0)
                {


                    foreach (var row in ShiftWisemeritlist22)
                    {

                        ShiftPosition22++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = ShiftPosition22;
                        paramUpdate[3] = "S";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }

                    #region SectionWiseMerit
                    object[] pramsec = new object[2];
                    pramsec[0] = classID;
                    pramsec[1] = groupID;
                    var dtSection = DataAccess.Instance.CommonServices.GetBySpWithParam("AllSectionClassWise", pramsec);

                    if (dtSection.Rows.Count > 0)
                    {
                        foreach (DataRow r in dtSection.Rows)
                        {
                            var sid = Convert.ToInt32(r["SectionId"].ToString());

                            List<GrandMeritVM> meritlistsection = new List<GrandMeritVM>();
                            meritlistsection = ShiftWisemeritlist22.Where(x => x.SectionId == sid).ToList();

                            List<GrandMeritVM> meritlistsectionBothPass = new List<GrandMeritVM>();
                            meritlistsectionBothPass = ShiftWisemeritlistBothPass22.Where(x => x.SectionId == sid).ToList();

                            int SectionPosition = meritlistsectionBothPass.Count;
                           
                            if (meritlistsection.Count > 0)
                            {
                                foreach (var row in meritlistsection)
                                {
                                    SectionPosition++;
                                    object[] paramUpdate = new object[4];
                                    paramUpdate[0] = row.GrandExamId;
                                    paramUpdate[1] = row.StudentIID;
                                    paramUpdate[2] = SectionPosition;
                                    paramUpdate[3] = "E";
                                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                                }
                            }
                        }
                    }

                    #endregion

                }
                #endregion

                //#region SectionWiseMerit
                //object[] pramsec = new object[2];
                //pramsec[0] = classID;
                //pramsec[1] = groupID;
                //var dtSection = DataAccess.Instance.CommonServices.GetBySpWithParam("AllSectionClassWise", pramsec);

                //if (dtSection.Rows.Count > 0)
                //{
                //    foreach (DataRow r in dtSection.Rows)
                //    {
                //        var sid = Convert.ToInt32(r["SectionId"].ToString());

                //        List<GrandMeritVM> meritlistsection = new List<GrandMeritVM>();
                //        meritlistsection = meritlist.Where(x => x.SectionId == sid).ToList();

                //        List<GrandMeritVM> meritlistsectionBothPass = new List<GrandMeritVM>();
                //        meritlistsectionBothPass = meritlistBothPass.Where(x => x.SectionId == sid).ToList();

                //        int SectionPosition = meritlistsectionBothPass.Count;

                //        if (meritlistsection.Count > 0)
                //        {
                //            foreach (var row in meritlistsection)
                //            {
                //                SectionPosition++;
                //                object[] paramUpdate = new object[4];
                //                paramUpdate[0] = row.GrandExamId;
                //                paramUpdate[1] = row.StudentIID;
                //                paramUpdate[2] = SectionPosition;
                //                paramUpdate[3] = "E";
                //                DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                //            }
                //        }
                //    }
                //}




                //#endregion
            } 

            if (!cr.HasError)
                cr.message = "Main Exam Pass Merit Processed Succcessfully.";
            return Json(cr);
        }
        public IHttpActionResult ProMeritAtendExam(int versionID, int sessionID, int ShiftId, int classID, string groupID, int GrandExamId)
        {
            CommonResponse cr = new CommonResponse();
            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetGrandMeritListConfig", new object[] { versionID, sessionID, classID, groupID });
            List<GrandMeritListConfig> Configlist = APIUitility.ConvertDataTable<GrandMeritListConfig>(dt);

            if (Configlist.Count == 0)
            {
                return BadRequest("Merit Configuration not found!");
            }

            var DicShortList = new Dictionary<int, string>();

            var DicOrderIsAssending = new Dictionary<int, bool>();

            if (Configlist[0].TotalIsFraction == true)
            {
                DicShortList.Add(Configlist[0].SortSerialByTotalMark, "TotalConvertedMarksFraction");
                DicOrderIsAssending.Add(Configlist[0].SortSerialByTotalMark, false);

                DicShortList.Add(Configlist[0].MainTotalMark, "MainTotalConvertedMarksFraction");
                DicOrderIsAssending.Add(Configlist[0].MainTotalMark, false);
            }
            else 
            {
                DicShortList.Add(Configlist[0].SortSerialByTotalMark, "TotalConvertedMarks");
                DicOrderIsAssending.Add(Configlist[0].SortSerialByTotalMark, false);

                DicShortList.Add(Configlist[0].MainTotalMark, "MainTotalConvertedMarks");
                DicOrderIsAssending.Add(Configlist[0].MainTotalMark, false);
            }

            DicShortList.Add(Configlist[0].SortSerialByGPAWith4th, "GPA");
            DicOrderIsAssending.Add(Configlist[0].SortSerialByGPAWith4th, false);
            DicShortList.Add(Configlist[0].MainGPAW4th, "MainGPA");
            DicOrderIsAssending.Add(Configlist[0].MainGPAW4th, false);


            DicShortList.Add(Configlist[0].SortSerialByGPAWithout4th, "GPAWithOut4Sub");
            DicOrderIsAssending.Add(Configlist[0].SortSerialByGPAWithout4th, false);
            DicShortList.Add(Configlist[0].MainGPAWO4th, "MainGPAWithOut4Sub");
            DicOrderIsAssending.Add(Configlist[0].MainGPAWO4th, false);

            DicShortList.Add(Configlist[0].SortSerialByRoll, "RollNo");
            DicOrderIsAssending.Add(Configlist[0].SortSerialByRoll, true);
            DicShortList.Add(Configlist[0].SortSerialByName, "FullName");
            DicOrderIsAssending.Add(Configlist[0].SortSerialByName, true);

            DicShortList.Add(Configlist[0].SortSerialBySubjectId1, "MeritSubjectMarks1");
            DicShortList.Add(Configlist[0].SortSerialBySubjectId2, "MeritSubjectMarks2");
            DicShortList.Add(Configlist[0].SortSerialBySubjectId3, "MeritSubjectMarks3");

            DicOrderIsAssending.Add(Configlist[0].SortSerialBySubjectId1, true);
            DicOrderIsAssending.Add(Configlist[0].SortSerialBySubjectId2, true);
            DicOrderIsAssending.Add(Configlist[0].SortSerialBySubjectId3, true);

            DicShortList.Add(Configlist[0].NoOfAttendExam, "NumberOfExam");
            DicOrderIsAssending.Add(Configlist[0].NoOfAttendExam, false);



            object[] param = new object[4];

            param[0] = sessionID;
            param[1] = classID;
            param[2] = groupID;
            param[3] = GrandExamId;
            var dtMerit = DataAccess.Instance.CommonServices.GetBySpWithParam("ProccessGrandMeritAttendExamGroup", param);
            List<GrandMeritVM> meritlist = new List<GrandMeritVM>();
            meritlist = APIUitility.ConvertDataTable<GrandMeritVM>(dtMerit).ToList();

            if (meritlist.Count > 0)
            {
                meritlist = meritlist.OrderBy(x => DicOrderIsAssending[1] ? x.GetType().GetProperty(DicShortList[1]).GetValue(x, null) : "0").
                ThenByDescending(x => !DicOrderIsAssending[1] ? x.GetType().GetProperty(DicShortList[1]).GetValue(x, null) : "0").

                ThenBy(x => DicOrderIsAssending[2] ? x.GetType().GetProperty(DicShortList[2]).GetValue(x, null) : "0").
                ThenByDescending(x => !DicOrderIsAssending[2] ? x.GetType().GetProperty(DicShortList[2]).GetValue(x, null) : "0").

                ThenBy(x => DicOrderIsAssending[3] ? x.GetType().GetProperty(DicShortList[3]).GetValue(x, null) : "0").
                ThenByDescending(x => !DicOrderIsAssending[3] ? x.GetType().GetProperty(DicShortList[3]).GetValue(x, null) : "0").

                ThenBy(x => DicOrderIsAssending[4] ? x.GetType().GetProperty(DicShortList[4]).GetValue(x, null) : "0").
                ThenByDescending(x => !DicOrderIsAssending[4] ? x.GetType().GetProperty(DicShortList[4]).GetValue(x, null) : "0").

                ThenBy(x => DicOrderIsAssending[5] ? x.GetType().GetProperty(DicShortList[5]).GetValue(x, null) : "0").
                ThenByDescending(x => !DicOrderIsAssending[5] ? x.GetType().GetProperty(DicShortList[5]).GetValue(x, null) : "0").

                ThenBy(x => DicOrderIsAssending[6] ? x.GetType().GetProperty(DicShortList[6]).GetValue(x, null) : "0").
                ThenByDescending(x => !DicOrderIsAssending[6] ? x.GetType().GetProperty(DicShortList[6]).GetValue(x, null) : "0").

                ThenBy(x => DicOrderIsAssending[7] ? x.GetType().GetProperty(DicShortList[7]).GetValue(x, null) : "0").
                ThenByDescending(x => !DicOrderIsAssending[7] ? x.GetType().GetProperty(DicShortList[7]).GetValue(x, null) : "0").

                ThenBy(x => DicOrderIsAssending[8] ? x.GetType().GetProperty(DicShortList[8]).GetValue(x, null) : "0").
                ThenByDescending(x => !DicOrderIsAssending[8] ? x.GetType().GetProperty(DicShortList[8]).GetValue(x, null) : "0").

                ThenBy(x => DicOrderIsAssending[9] ? x.GetType().GetProperty(DicShortList[9]).GetValue(x, null) : "0").
               ThenByDescending(x => !DicOrderIsAssending[9] ? x.GetType().GetProperty(DicShortList[9]).GetValue(x, null) : "0").

                ThenBy(x => DicOrderIsAssending[10] ? x.GetType().GetProperty(DicShortList[10]).GetValue(x, null) : "0").
               ThenByDescending(x => !DicOrderIsAssending[10] ? x.GetType().GetProperty(DicShortList[10]).GetValue(x, null) : "0").

                ThenBy(x => DicOrderIsAssending[11] ? x.GetType().GetProperty(DicShortList[11]).GetValue(x, null) : "0").
               ThenByDescending(x => !DicOrderIsAssending[11] ? x.GetType().GetProperty(DicShortList[11]).GetValue(x, null) : "0").

                ThenBy(x => DicOrderIsAssending[12] ? x.GetType().GetProperty(DicShortList[11]).GetValue(x, null) : "0").
               ThenByDescending(x => !DicOrderIsAssending[12] ? x.GetType().GetProperty(DicShortList[11]).GetValue(x, null) : "0").ToList();

                #region OvaralMerit
                int OvaralPosition = 20;

                foreach (var row in meritlist)
                {

                    OvaralPosition++;
                    object[] paramUpdate = new object[4];
                    paramUpdate[0] = row.GrandExamId;
                    paramUpdate[1] = row.StudentIID;
                    paramUpdate[2] = OvaralPosition;
                    paramUpdate[3] = "O";
                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                }
                #endregion

                #region ClassWiseMerit
                List<GrandMeritVM> ClassWisemeritlist1 = new List<GrandMeritVM>();
                List<GrandMeritVM> ClassWisemeritlist2 = new List<GrandMeritVM>();
                ClassWisemeritlist1 = meritlist.Where(x => x.ClassId == classID).ToList();
                ClassWisemeritlist2 = meritlist.Where(x => x.ClassId != classID).ToList();
                int classPosition1 = 20;
                int classPosition2 = 20;
                if (ClassWisemeritlist1.Count > 0)
                {
                    foreach (var row in ClassWisemeritlist1)
                    {

                        classPosition1++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = classPosition1;
                        paramUpdate[3] = "C";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }
                }

                if (ClassWisemeritlist2.Count > 0)
                {

                    foreach (var row in ClassWisemeritlist2)
                    {

                        classPosition2++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = classPosition2;
                        paramUpdate[3] = "C";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }
                }
                #endregion

                #region ShiftWiseMerit

                List<GrandMeritVM> ShiftWisemeritlist11 = new List<GrandMeritVM>();
                List<GrandMeritVM> ShiftWisemeritlist12 = new List<GrandMeritVM>();
                List<GrandMeritVM> ShiftWisemeritlist21 = new List<GrandMeritVM>();
                List<GrandMeritVM> ShiftWisemeritlist22 = new List<GrandMeritVM>();

                ShiftWisemeritlist11 = ClassWisemeritlist1.Where(x => x.ShiftID == ShiftId).ToList();
                ShiftWisemeritlist12 = ClassWisemeritlist1.Where(x => x.ShiftID != ShiftId).ToList();
                ShiftWisemeritlist21 = ClassWisemeritlist2.Where(x => x.ShiftID == ShiftId).ToList();
                ShiftWisemeritlist22 = ClassWisemeritlist2.Where(x => x.ShiftID != ShiftId).ToList();

                int ShiftPosition11 = 20;
                int ShiftPosition12 = 20;
                int ShiftPosition21 = 20;
                int ShiftPosition22 = 20;
                if (ShiftWisemeritlist11.Count > 0)
                {
                    foreach (var row in ShiftWisemeritlist11)
                    {

                        ShiftPosition11++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = ShiftPosition11;
                        paramUpdate[3] = "S";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }

                    #region SectionWiseMerit
                    object[] pramsec = new object[2];
                    pramsec[0] = classID;
                    pramsec[1] = groupID;
                    var dtSection = DataAccess.Instance.CommonServices.GetBySpWithParam("AllSectionClassWise", pramsec);

                    if (dtSection.Rows.Count > 0)
                    {
                        foreach (DataRow r in dtSection.Rows)
                        {
                            var sid = Convert.ToInt32(r["SectionId"].ToString());

                            List<GrandMeritVM> meritlistsection = new List<GrandMeritVM>();
                            meritlistsection = ShiftWisemeritlist11.Where(x => x.SectionId == sid).ToList();
                            int SectionPosition = 20;

                            if (meritlistsection.Count > 0)
                            {
                                foreach (var row in meritlistsection)
                                {
                                    SectionPosition++;
                                    object[] paramUpdate = new object[4];
                                    paramUpdate[0] = row.GrandExamId;
                                    paramUpdate[1] = row.StudentIID;
                                    paramUpdate[2] = SectionPosition;
                                    paramUpdate[3] = "E";
                                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                                }
                            }
                        }
                    }




                    #endregion
                }

                if (ShiftWisemeritlist12.Count > 0)
                {
                    foreach (var row in ShiftWisemeritlist12)
                    {

                        ShiftPosition12++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = ShiftPosition12;
                        paramUpdate[3] = "S";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }
                    #region SectionWiseMerit
                    object[] pramsec = new object[2];
                    pramsec[0] = classID;
                    pramsec[1] = groupID;
                    var dtSection = DataAccess.Instance.CommonServices.GetBySpWithParam("AllSectionClassWise", pramsec);

                    if (dtSection.Rows.Count > 0)
                    {
                        foreach (DataRow r in dtSection.Rows)
                        {
                            var sid = Convert.ToInt32(r["SectionId"].ToString());

                            List<GrandMeritVM> meritlistsection = new List<GrandMeritVM>();
                            meritlistsection = ShiftWisemeritlist12.Where(x => x.SectionId == sid).ToList();
                            int SectionPosition = 20;

                            if (meritlistsection.Count > 0)
                            {
                                foreach (var row in meritlistsection)
                                {
                                    SectionPosition++;
                                    object[] paramUpdate = new object[4];
                                    paramUpdate[0] = row.GrandExamId;
                                    paramUpdate[1] = row.StudentIID;
                                    paramUpdate[2] = SectionPosition;
                                    paramUpdate[3] = "E";
                                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                                }
                            }
                        }
                    }




                    #endregion
                }
                if (ShiftWisemeritlist21.Count > 0)
                {

                    foreach (var row in ShiftWisemeritlist21)
                    {

                        ShiftPosition21++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = ShiftPosition21;
                        paramUpdate[3] = "S";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }

                    #region SectionWiseMerit
                    object[] pramsec = new object[2];
                    pramsec[0] = classID;
                    pramsec[1] = groupID;
                    var dtSection = DataAccess.Instance.CommonServices.GetBySpWithParam("AllSectionClassWise", pramsec);

                    if (dtSection.Rows.Count > 0)
                    {
                        foreach (DataRow r in dtSection.Rows)
                        {
                            var sid = Convert.ToInt32(r["SectionId"].ToString());

                            List<GrandMeritVM> meritlistsection = new List<GrandMeritVM>();
                            meritlistsection = ShiftWisemeritlist21.Where(x => x.SectionId == sid).ToList();
                            int SectionPosition = 20;

                            if (meritlistsection.Count > 0)
                            {
                                foreach (var row in meritlistsection)
                                {
                                    SectionPosition++;
                                    object[] paramUpdate = new object[4];
                                    paramUpdate[0] = row.GrandExamId;
                                    paramUpdate[1] = row.StudentIID;
                                    paramUpdate[2] = SectionPosition;
                                    paramUpdate[3] = "E";
                                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                                }
                            }
                        }
                    }




                    #endregion
                }

                if (ShiftWisemeritlist22.Count > 0)
                {


                    foreach (var row in ShiftWisemeritlist22)
                    {

                        ShiftPosition22++;
                        object[] paramUpdate = new object[4];
                        paramUpdate[0] = row.GrandExamId;
                        paramUpdate[1] = row.StudentIID;
                        paramUpdate[2] = ShiftPosition22;
                        paramUpdate[3] = "S";
                        DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                    }

                    #region SectionWiseMerit
                    object[] pramsec = new object[2];
                    pramsec[0] = classID;
                    pramsec[1] = groupID;
                    var dtSection = DataAccess.Instance.CommonServices.GetBySpWithParam("AllSectionClassWise", pramsec);

                    if (dtSection.Rows.Count > 0)
                    {
                        foreach (DataRow r in dtSection.Rows)
                        {
                            var sid = Convert.ToInt32(r["SectionId"].ToString());

                            List<GrandMeritVM> meritlistsection = new List<GrandMeritVM>();
                            meritlistsection = ShiftWisemeritlist22.Where(x => x.SectionId == sid).ToList();
                            int SectionPosition = 20;

                            if (meritlistsection.Count > 0)
                            {
                                foreach (var row in meritlistsection)
                                {
                                    SectionPosition++;
                                    object[] paramUpdate = new object[4];
                                    paramUpdate[0] = row.GrandExamId;
                                    paramUpdate[1] = row.StudentIID;
                                    paramUpdate[2] = SectionPosition;
                                    paramUpdate[3] = "E";
                                    DataAccess.Instance.CommonServices.GetResponseBySpWithParam("UpdateGrandMerit", paramUpdate);

                                }
                            }
                        }
                    }




                    #endregion
                }
                #endregion

                
            }

            if (!cr.HasError)
                cr.message = "Leave Merit Processed Succcessfully.";
            return Json(cr);
        }

        [Route("GrandResult/ProTabulation/{versionId}/{sessionID}/{BranchId}/{ShiftId}/{classId}/{groupId}/{GrandExamId}")]
        [HttpGet]
        public IHttpActionResult ProTabulation(int versionID, int sessionID, int BranchId, int ShiftID, int classID, string groupID, int GrandExamId)
        {
            string DeleteQuery = "DELETE Res_Tabulation WHERE GrandExamId = " + GrandExamId;

            DataAccess.Instance.CommonServices.ExecuteSQL(DeleteQuery);


            var lstGrandSetup = DataAccess.Instance.GrandSetupService.Filter(e => e.GrandExamId == GrandExamId && e.IsDeleted == false).ToList();
            /// Get Main Exam tab Data
            if(lstGrandSetup.Count==0)
            {
                return BadRequest("Grand Setup Not Found.");
            }

            var defaultTabMainExamId = lstGrandSetup.FirstOrDefault().MainExamId;
            var lstTabConfig = DataAccess.Instance.TabConfigService.Filter(e => e.MainExamId == defaultTabMainExamId  && e.IsDeleted == false).ToList();
            var lstGrandConfig = DataAccess.Instance.GrandConfigService.Filter(e => e.GrandExamId == GrandExamId && e.IsDeleted == false).ToList();
            if(lstGrandConfig.Count==0)
            {
                return BadRequest("Grand Config Not Found.");
            }

            object[] param = new object[7];
            param[0] = GrandExamId;
            CommonResponse cr = new CommonResponse();
            var lstSubExam = DataAccess.Instance.GrandSubExamService.Filter(e => e.GrandExamId == GrandExamId && e.IsDeleted == false,o=>o.OrderBy(e=>e.GrandSubExamId)).ToList();
            int count = 0;
            foreach (GrandSubExam Subexam in lstSubExam)
            {
                var TabConfig = lstTabConfig[count];
                var lstDivExam = DataAccess.Instance.GrandDividedExamService.Filter(e => e.GrandSubExamId == Subexam.GrandSubExamId && e.IsDeleted == false).ToList();
                if (lstDivExam.Any()) /// If Grand Divided Exam Exists
                {

                    //int GsubId = Convert.ToInt32( Subexam.GrandSubExamId);
                    //    var GrnSubConfig = lstGrandConfig.Where(e => e.GrandSubExamId == GsubId).ToList();
                    //foreach (var item in collection)
                    //{

                    //}
                    //        TabConfig = lstTabConfig.Where(e=>e.SubExamId==GrnSubConfig.FirstOrDefault().SubExamId).FirstOrDefault();
                    
                    if (TabConfig != null)
                    {

                        foreach (var divExam in lstDivExam)
                        {
                            // var DivSetup = DataAccess.Instance.DividedExamMarkSetup.Filter(e=>e.DividedExamId)

                            param[1] = Subexam.GrandSubExamId;
                            param[2] = divExam.DividedExamName;
                            param[3] = divExam.DividedExamType;

                            if (divExam.DividedExamType == "W1")
                            {
                                param[4] = TabConfig.WrittenObt1;
                                param[5] = TabConfig.WrittenConv1;
                                param[6] = TabConfig.WrittenFrac1;
                                cr = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);

                            }
                            if (divExam.DividedExamType == "W2")
                            {
                                param[4] = TabConfig.WrittenObt2;
                                param[5] = TabConfig.WrittenConv2;
                                param[6] = TabConfig.WrittenFrac2;
                                DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);
                            }
                            if (divExam.DividedExamType == "W3")
                            {
                                param[4] = TabConfig.WrittenObt3;
                                param[5] = TabConfig.WrittenConv3;
                                param[6] = TabConfig.WrittenFrac3;
                                DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);
                            }
                            if (divExam.DividedExamType == "S")
                            {
                                param[4] = TabConfig.SubjectiveObt;
                                param[5] = TabConfig.SubjectiveConv;
                                param[6] = TabConfig.SubjectiveFrac;
                                DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);
                            }
                            if (divExam.DividedExamType == "O")
                            {
                                param[4] = TabConfig.ObjectiveObt;
                                param[5] = TabConfig.ObjectiveConv;
                                param[6] = TabConfig.ObjectiveFrac;
                                DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);
                            }
                            if (divExam.DividedExamType == "P")
                            {
                                param[4] = TabConfig.PracticalObt;
                                param[5] = TabConfig.PracticalConv;
                                param[6] = TabConfig.PracticalFrac;
                                DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);
                            }
                        }
                        /// Procces Subexam Total 
                        if (TabConfig.SubExamTotalObt)
                        {
                            param[1] = Subexam.GrandSubExamId;
                            param[2] = Subexam.GrandSubExamName + " SE Total";
                            param[3] = "SETM";

                            param[4] = false;
                            param[5] = false;
                            param[6] = false;
                            DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);
                        }
                        if (TabConfig.SubExamTotalConv)
                        {
                            param[1] = Subexam.GrandSubExamId;
                            param[2] = Subexam.GrandSubExamName + " SE Conv";
                            param[3] = "SECTM";

                            param[4] = false;
                            param[5] = false;
                            param[6] = false;
                            DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);
                        }
                    }
                }
                count++;
            }

            param[1] = 0;

            param[4] = false;
            param[5] = false;
            param[6] = false;


            if (DataAccess.Instance.TabConfigService.Filter(e => e.MainExamId == defaultTabMainExamId && e.IsDeleted == false && e.Virtual1 == true).ToList().Any())
            {
                param[2] = "Virtual 1";
                param[3] = "V1";
                var t = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);

            }
            if (DataAccess.Instance.TabConfigService.Filter(e => e.MainExamId == defaultTabMainExamId && e.IsDeleted == false && e.Virtual2 == true).ToList().Any())
            {
                param[2] = "Virtual 2";
                param[3] = "V2";
                var t = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);

            }

            if (DataAccess.Instance.TabConfigService.Filter(e => e.MainExamId == defaultTabMainExamId && e.IsDeleted == false && e.SubjectObtMarks == true).ToList().Any())
            {
                param[2] = "Total";
                param[3] = "STM";
                var t = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);

            }
            if (DataAccess.Instance.TabConfigService.Filter(e => e.MainExamId == defaultTabMainExamId && e.IsDeleted == false && e.SubjectConvertedMarks == true).ToList().Any())
            {
                param[2] = "Sub Conv";
                param[3] = "SCTM";
                var t = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);

            }
            if (DataAccess.Instance.TabConfigService.Filter(e => e.MainExamId == defaultTabMainExamId && e.IsDeleted == false && e.SubjectGL == true).ToList().Any())
            {
                param[2] = "GL";
                param[3] = "SGL";
                var t = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);

            }
            if (DataAccess.Instance.TabConfigService.Filter(e => e.MainExamId == defaultTabMainExamId && e.IsDeleted == false && e.SubjectGP == true).ToList().Any())
            {
                param[2] = "GP";
                param[3] = "SGP";
                var t = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);

            }
            param[2] = "TotalMarks";
            param[3] = "TM"; // TotalMarks
            DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);
            param[2] = "GPA";
            param[3] = "GPA"; // GPA
            DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);
            param[2] = "GL";
            param[3] = "GL"; // Grade Letter
            DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);
            param[2] = "Merit";
            param[3] = "ME"; 

            cr = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ProccessGrandTab", param);
            if (!cr.HasError)
                cr.message = "Tabulation Processed Succcessfully.";
            return Json(cr);
        }
        [Route("GrandResult/ClearProccess/{versionId}/{sessionID}/{BranchId}/{ShiftId}/{classId}/{groupId}/{GrandExamId}")]
        [HttpGet]
        public IHttpActionResult ClearProccess(int versionID, int sessionID, int BranchId, int ShiftID, int classID, string groupID, int GrandExamId)
        {
            CommonResponse cr = new CommonResponse();
            cr = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("ClearMainExamResult", new object[] { GrandExamId, ShiftID, "G" });
            if (cr.HasError)
            {
               
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = cr.message.ToString();
            }
            else
            {
                int _groupID = 0;
                if (groupID != "null" && groupID != "undefined")
                {
                    _groupID = Convert.ToInt32(groupID);
                }
                DataAccess.Instance.CommonServices.WriteLog(versionID, sessionID, ShiftID, classID, _groupID, -1, "G", "Data Cleared", User.Identity.GetUserName());

                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.SUCCESS;
            }
            
            return Json(cr);
        }
        [Route("GrandResult/GetProccesLog/{ShiftId}/{ClassId}/{GroupId}")]
        [HttpGet]
        public IHttpActionResult GetProccesLog(int ShiftId, int ClassId,int GroupId)
        {
            CommonResponse cr = new CommonResponse();
            cr.results = DataAccess.Instance.CommonServices.ReadLogGrand(ShiftId, ClassId, GroupId);
            cr.message = Constant.SUCCESS;
            return Json(cr);
        }
        #endregion GrandExamResultProces
        #region GrandExamAssessment
        [Route("GrandResult/GetAssessmentSubject/")]
        [HttpGet]
        public IHttpActionResult GetAssessmentSubject()
        {
            CommonResponse cr = new CommonResponse();
            try
            {   
                //P1 PULL ASSESSMENT SUBJECT NAME AND ID AND RETURN
                var res = from r in DataAccess.Instance.AssessmentSubjectService.Filter(e => e.IsDeleted == false).ToList()
                          select new { SubjectId = r.AId, r.SubjectName };
                cr.results = res;
                cr.httpStatusCode = res.Any() ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res.Any() ? Constant.SUCCESS : Constant.FAILED;


            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("GrandResult/GetAssessmentSubjectByVscg/{version}/{session}/{classid}/{groupid}")]
        [HttpGet]
        public IHttpActionResult GetAssessmentSubjectByVscg(int version, int session, int classid, int groupid)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //P1 PULL ASSESSMENT SUBJECT NAME AND ID AND RETURN FILTER BY VSCG
                var res = from r in DataAccess.Instance.AssessmentSubjectService.Filter(e => e.VersionId == version &&
                          e.SessionId == session && e.ClassId == classid && e.GroupId == groupid && e.IsDeleted==false).ToList()
                          select new { r.AId, r.SubjectName };
                cr.results = res;
                cr.httpStatusCode = res.Any() ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res.Any() ? Constant.SUCCESS : Constant.FAILED;


            }
            catch (Exception ex)
            {
                cr.httpStatusCode =  HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("GrandResult/GetAssessment/{GrandExamId}/{SubjectId}/{version}/{session}/{branch}/{shift}/{classid}/{groupid}/{section}")]
        [HttpGet]
        public IHttpActionResult GetAssessment(int GrandExamId, int SubjectId, int version, int session, int branch, int shift, int classid, int groupid, int section)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //P1 PULL SUBJECT WISE STUDENT ASSESSMENT MARK  FILTER WITH GRANDEXAMID, SUBJECTID, VSBSCG&SECTION
                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAssessmentMarks", new object[] { GrandExamId, SubjectId, version, session, branch, shift, classid, groupid, section });
                List<GrandStudentAssessment> res = APIUitility.ConvertDataTable<GrandStudentAssessment>(dt);
                cr.results = res;
                cr.httpStatusCode = res.Any() ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res.Any() ? Constant.SUCCESS : Constant.FAILED;
            }
            catch(Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("GrandResult/AddAssessment/")]
        [HttpPost]
        public IHttpActionResult AddAssessment(List<GrandStudentAssessment> lstgsa)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                int add = 0;
                int update = 0;
                foreach(var a in lstgsa)
                {
                    if (a.SubjectName == "Bangla" || a.SubjectName == "English")   //P1 SET ASSESSMENT MARK FOR BANGLA AND ENGLISH SUBJECT
                    {
                        a.Art = 0;
                        a.Music = 0;
                        a.ParticipationInGames = 0;
                        a.Obedience = 0;
                        a.Tolerance = 0;
                        a.SelfReliance = 0;
                        a.Leadership = 0;
                        a.Interaction_with_Teachers_and_Peers = 0;
                    }
                    else if (a.SubjectName == "Creativity")    //P2 SET  ASSESSMENT MARK FOR Creativity SUBJECT
                    {
                        a.Obedience = 0;
                        a.Tolerance = 0;
                        a.SelfReliance = 0;
                        a.Leadership = 0;
                        a.Interaction_with_Teachers_and_Peers = 0;
                        a.HandWriting = 0;
                        a.PicReading = 0;
                        a.Recitation = 0;
                        a.Conversation = 0;
                        a.ColourSense = 0;
                    }
                    else if (a.SubjectName == "SocialDevelopment")     //P3 SET ASSESSMENT MARK FOR SocialDevelopment SUBJECT
                    {
                        a.Art = 0;
                        a.Music = 0;
                        a.ParticipationInGames = 0;
                        a.HandWriting = 0;
                        a.PicReading = 0;
                        a.Recitation = 0;
                        a.Conversation = 0;
                        a.ColourSense = 0;
                    }
                    if (a.ID == 0)
                    {
                        a.AddBy = User.Identity.Name;
                        a.Status = "A";
                        a.IsDeleted = false;
                        a.SetDate();
                        a.IsDeleted = false;                     
                        var exist = DataAccess.Instance.GrandStudentAssessmentService.Filter(e => e.VersionID == a.VersionID && e.SessionID == a.SessionID
                                    && e.BranchID == a.BranchID && e.ShiftID == a.ShiftID && e.ClassID == a.ClassID && e.GroupID == a.GroupID
                                    && e.SectionID == a.SectionID && e.GrandExamId == a.GrandExamId && e.StudentID == a.StudentID
                                    && e.HandWriting == a.HandWriting && e.PicReading == a.PicReading && e.Recitation == a.Recitation
                                    && e.Conversation == a.Conversation && e.ColourSense == a.ColourSense && e.Art == a.Art
                                    && e.Music == a.Music && e.ParticipationInGames == a.ParticipationInGames && e.Obedience == a.Obedience
                                    && e.Tolerance == a.Tolerance && e.SelfReliance == a.SelfReliance && e.Leadership == a.Leadership
                                    && e.Interaction_with_Teachers_and_Peers == a.Interaction_with_Teachers_and_Peers && e.SubjectId==a.SubjectId &&  e.IsDeleted == false).ToList();
                        if(!exist.Any())
                        {
                            var r = DataAccess.Instance.GrandStudentAssessmentService.Add(a);
                            if (r)
                                add++;
                        }
                    }
                    else
                    {
                        if (a.SubjectName == "Bangla" || a.SubjectName == "English")  //P4 UPDATE ASSESSMENT MARK FOR BANGLA AND ENGLISH SUBJECT
                        {

                            var Existing = DataAccess.Instance.GrandStudentAssessmentService.Filter(e => e.ID == a.ID && e.HandWriting == a.HandWriting
                                               && e.PicReading == a.PicReading && e.Recitation == a.Recitation && e.Conversation == a.Conversation
                                               && e.ColourSense == a.ColourSense && e.IsDeleted == false).ToList();
                            if (Existing != null)
                            {
                                var olda = DataAccess.Instance.GrandStudentAssessmentService.Get(a.ID);
                                a.AddBy = olda.AddBy;
                                a.AddDate = olda.AddDate;
                                a.UpdateBy = User.Identity.Name;
                                a.IsDeleted = false;
                                a.SetDate();
                                var r = DataAccess.Instance.GrandStudentAssessmentService.Update(a);
                                if (r)
                                    update++;

                            }

                        }
                        else if (a.SubjectName == "Creativity")   //P5 UPDATE ASSESSMENT MARK FOR Creativity SUBJECT
                        {
                            var Existing = DataAccess.Instance.GrandStudentAssessmentService.Filter(e => e.ID == a.ID && e.Art == a.Art
                                               && e.Music == a.Music && e.ParticipationInGames == a.ParticipationInGames && e.IsDeleted == false).ToList();
                            if (Existing != null)
                            {
                                a.UpdateBy = User.Identity.Name;
                                a.SetDate();
                                var r = DataAccess.Instance.GrandStudentAssessmentService.Update(a);
                                if (r)
                                    update++;

                            }
                        }
                        else if (a.SubjectName == "SocialDevelopment")       //P6 UPDATE ASSESSMENT MARK FOR SocialDevelopment SUBJECT
                        {

                            var Existing = DataAccess.Instance.GrandStudentAssessmentService.Filter(e => e.ID == a.ID && e.HandWriting == a.HandWriting
                                               && e.PicReading == a.PicReading && e.Recitation == a.Recitation && e.Conversation == a.Conversation
                                               && e.ColourSense == a.ColourSense && e.IsDeleted == false).ToList();
                            if (Existing != null)
                            {
                                a.UpdateBy = User.Identity.Name;
                                a.SetDate();
                                var r = DataAccess.Instance.GrandStudentAssessmentService.Update(a);
                                if (r)
                                    update++;

                            }
                        }


                    } 
                }
                if(add!=0 || update !=0)
                {
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = "Add "+add +" and Update "+ update+" Records"; 
                }
              

            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        #endregion GrandExamAssessment
        #region MainExamLeaveStudent
        [Route("GrandResult/AddMainExamLeaveStudent/")]
        [HttpPost]
        public IHttpActionResult AddMainExamLeaveStudent(MainExamLeaveStudent mainExam)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //Get MainExamStudent list for Check Exits
                var ExistingExam = DataAccess.Instance.MainExamLeaveStudentService.Filter(s => s.VersionId == mainExam.VersionId
        && s.ClassId == mainExam.ClassId && s.SessionId == mainExam.SessionId && s.GroupId == mainExam.GroupId && s.SubjectID == mainExam.SubjectID && s.StudentIID == mainExam.StudentIID && s.IsDeleted == false).ToList();
                if (ExistingExam.Any())
                    return BadRequest("Exam Name Leave Student already exist");
                mainExam.IsDeleted = false;
                mainExam.AddBy = User.Identity.Name;
               
                mainExam.SetDate();
                mainExam.Status = "A";
                //Add MainExamStudent
                var res = DataAccess.Instance.MainExamLeaveStudentService.Add(mainExam);
                if (res)
                {
                    //var result = DataAccess.Instance.MainExamService.Get(mainExam.MainExamId);                
                    cr.results = mainExam;
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.FAILED;
                }
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }    

        [Route("GrandResult/GetMainExamLeaveStudent/{ID}")]     // Using for Exam Add Wizard Page
        [HttpGet]
        public IHttpActionResult GetMainExamLeaveStudent(int ID)
        {
            CommonResponse cr = new CommonResponse();
            // Get MainExamLeave By Id
            var res = DataAccess.Instance.MainExamLeaveStudentService.Get(ID);
            if (res != null)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }
        [Route("GrandResult/GetAllMainExamLeaveStudent/")]
        [HttpGet]
        public IHttpActionResult GetAllMainExamLeaveStudent()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                // Get List MainExamLeave
                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetMainExamStudentleave");
                List<VMMainExamLeaveStudent> res = APIUitility.ConvertDataTable<VMMainExamLeaveStudent>(dt);
                cr.results = res;
                cr.httpStatusCode = res.Any() ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res.Any() ? Constant.SUCCESS : Constant.FAILED;
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("GrandResult/UpdateMainExamLeaveStudent/")]
        [HttpPut]
        public IHttpActionResult UpdateMainExamLeaveStudent(MainExamLeaveStudent MainExamLeaveStudent)
        {
            CommonResponse cr = new CommonResponse();
            bool res = false;
            //Id is null then add MainExamLeaveStudent else Update 
            if (MainExamLeaveStudent.Id == 0)
            {
                return AddMainExamLeaveStudent(MainExamLeaveStudent);
            }
            else
            {
                MainExamLeaveStudent.UpdateBy = User.Identity.Name;
                MainExamLeaveStudent.SetDate();

                res = DataAccess.Instance.MainExamLeaveStudentService.Update(MainExamLeaveStudent);
                if (res)
                {
                    var Result = DataAccess.Instance.MainExamLeaveStudentService.Filter(s => s.Id == MainExamLeaveStudent.Id
                    && s.IsDeleted == false).ToList();
                    cr.results = Result;
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.UPDATED : Constant.FAILED;
                }
            }
            return Json(cr);
        }
        [Route("GrandResult/GetAllMainExamStudentleave/{VersionId}/{SessionId}/{BranchId}/{ShiftId}/{ClassId}/{GroupId}/{SectionId}/{GrandExamId}")]
        [HttpGet]
        public IHttpActionResult GetAllMainExamStudentleave( int VersionId, int SessionId, int BranchId, int ShiftId, int ClassId, int GroupId, int SectionId, int GrandExamId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                // Get List MainExamLeave By Parameter
                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetMainExamStudentleave", new object[] { VersionId, SessionId, BranchId, ShiftId, ClassId, GroupId, SectionId, GrandExamId });
                List<VMMainExamLeaveStudent> res = APIUitility.ConvertDataTable<VMMainExamLeaveStudent>(dt);
                cr.results = res;
                cr.httpStatusCode = res.Any() ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res.Any() ? Constant.SUCCESS : Constant.FAILED;
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("GrandResult/DeleteMainExamStudentleave/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteMainExamStudentleave(int id)
        {
            CommonResponse cr = new CommonResponse();
            // Delete MainExamLeaveStudent By Id 
            bool results = DataAccess.Instance.MainExamLeaveStudentService.Remove(id);
            if (results)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.DELETED;
                return Json(cr);
            }
            else
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = Constant.FAILED;
                return Json(cr);
            }
        }
        #endregion MainExamLeaveStudent
        [Route("GrandResult/MergeMainExamMark/")]
        [HttpPost]
        public IHttpActionResult MergeMainExamMark() 
        {
            CommonResponse cr = new CommonResponse();
            var lstGrandConfig = DataAccess.Instance.GrandConfigService.Filter(e => e.GrandExamId == 2 && e.IsDeleted == false).ToList();

            var lstGrandSetup = DataAccess.Instance.GrandSetupService.Filter(e => e.GrandExamId == 2 && e.IsDeleted == false).ToList();  
            // var
            return Json(cr); 
        }
    }
}


       
    
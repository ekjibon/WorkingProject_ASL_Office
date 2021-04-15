using OEMS.Api.Providers;
using OEMS.AppData;
using OEMS.Models.Model;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UI.WebClients.Controllers
{
    [ViewAuth]
    public class InstitutionSetupController : BaseController
    {
        // GET: InstitutionSetup
        public ActionResult MyInstitution()
        {
            //var School = DataAccess.Instance.SchoolSetupService.GetAll().FirstOrDefault();
           // if(School.SchoolLogo==null)
            return View();
        }
        [HttpPost]
        public ActionResult MyInstitution(SchoolSetup schoolSetup,HttpPostedFileBase logo)
        {
            var _school = DataAccess.Instance.SchoolSetupService.Get(schoolSetup.SchoolID);
            if(logo!=null)
            {
                using (Stream inputStream = logo.InputStream)
                {
                    MemoryStream memoryStream = inputStream as MemoryStream;
                    if (memoryStream == null)
                    {
                        memoryStream = new MemoryStream();
                        inputStream.CopyTo(memoryStream);
                    }
                    _school.SchoolLogo = memoryStream.ToArray();
                }
            }
            _school.SchoolID = schoolSetup.SchoolID;
            _school.SchoolName = schoolSetup.SchoolName;
            _school.SchoolNameBangla = schoolSetup.SchoolNameBangla;
            _school.Status = schoolSetup.Status;
            _school.WebURL = schoolSetup.WebURL;
            _school.Email = schoolSetup.Email;
            _school.Address = schoolSetup.Address;
            _school.ContactNumber = schoolSetup.ContactNumber;
            _school.UpdateBy = User.Identity.Name;
            _school.SetDate();
            DataAccess.Instance.SchoolSetupService.Update(_school);

            return RedirectToAction("MyInstitution");
        }

        public ActionResult Branch()
        { 
            return View();
        }

        public ActionResult Session() 
        {
            return View();
        }

        public ActionResult Shift()
        {
            return View();
        }

        public ActionResult Class()
        {

            return View();
        }
        public ActionResult Version()
        {

            return View();
        }
        public ActionResult Group()
        {

            return View();
        }

        public ActionResult AcademicBatch()
        {
            return View();
        }

        public ActionResult Section()
        {
            return View();
        }

        public ActionResult FeesBooth()
        {
            return View();
        }
        public ActionResult StudentIDSetup()
        {

            return View();
        }

        public ActionResult AdmitCard()
        {
            return View();
        }

        public ActionResult AdmitCardSetup()
        {
            return View();
        }

        public ActionResult SeatCardSetup()
        {
            return View();
        }
        public ActionResult SignatureSetup()
        {
            return View();
        }
        public ActionResult TTCTemplate()
        {
            return View();
        }
        public ActionResult StudentType()
        {
            return View();
        }
        public ActionResult StudentHouse()
        {
            return View();
        }
        public ActionResult ClassSubjectConfig()
        {
            return View();
        }
        public ActionResult Term()
        {
            return View();
        }

        public ActionResult ECAClub()
        {
            return View();
        }
        public ActionResult ClubConfig()
        {
            return View();
        }
        public ActionResult DocumentUpload()
        {
            return View();
        }
        public ActionResult CS()
        {
            return View();
        }
        public ActionResult ViewLogs()
        {
            return View();
        }
    }
}
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Newtonsoft.Json;
using OEMS.Api.Providers;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Constant;
using OEMS.Models.Model;
using OEMS.Models.Model.Employee;
using OEMS.Models.ViewModel;
using OEMS.Service.Services;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using UI.WebClients.Models;
using static OEMS.Models.Constant.Enums;

namespace UI.WebClients.Controllers
{
    //[CustomAuth]
    public class UsersController : Controller
    {
        private ApplicationUserManager _userManager;
        private ApplicationSignInManager _signInManager;

        public ApplicationUserManager UserManager
        {
            get
            {
                return _userManager ?? HttpContext.GetOwinContext().GetUserManager<ApplicationUserManager>();
            }
            private set
            {
                _userManager = value;
            }
        }
        public ApplicationSignInManager SignInManager
        {
            get
            {
                return _signInManager ?? HttpContext.GetOwinContext().Get<ApplicationSignInManager>();
            }
            private set
            {
                _signInManager = value;
            }
        }
        public ActionResult Dashboard()
        {
            Session["ModuleId"] = OEMSModule.User;
            return View();
        }

        [HttpPost]
        public ActionResult BulkEmpUserCreate(int[] Ids)
        {
            CommonResponse cr = new CommonResponse();

            try
            {
                RoleService Role = new RoleService();
                if (!Role.Filter(e => e.Name == "TeacherMarksEntry").Any())
                {
                    AspNetRole aspNetRole = new AspNetRole();
                    aspNetRole.Name = "TeacherMarksEntry";
                    aspNetRole.Id = Guid.NewGuid().ToString(); /// Point 1 Set GUID as Role ID
                    var res = Role.Add(aspNetRole);
                }
               
            int _SCount = 0;
            foreach (int Id in Ids)
            {
                var Emp = DataAccess.Instance.EmpBasicInfoService.Get(Id);
                if (DataAccess.Instance.Users.Filter(e => e.UserName == Emp.EmpID).Any())
                {
                        cr.message += Emp.FullName + " Already User ";
                        continue;
                 }
                 var user = new ApplicationUser
                 {
                    UserName = Emp.EmpID,
                    Email =string.IsNullOrEmpty( Emp.Email)?string.Concat(Emp.EmpID,"@User.com"):Emp.Email ,
                    FullName = Emp.FullName,
                    Address = Emp.PresentAddress,
                    Image = Emp.Image != null ? Emp.Image : System.IO.File.ReadAllBytes(HttpContext.Server.MapPath(Enums.NoImage)),
                    MobileNo = Emp.SMSNotificationNo,
                    PhoneNumber = Emp.MobileNo,
                    EmpId =  Emp.EmpBasicInfoID
                };
                Random rand = new Random();
                string pass = rand.Next(112233, 999999).ToString();  //System.Web.Security.Membership.GeneratePassword(7, 2).ToString();
                var result =  UserManager.Create(user, pass);
                if (result.Succeeded)
                {
                    UserManager.AddToRole(user.Id, "TeacherMarksEntry");
                    _SCount++;
                    Emp.Remarks = pass;
                        Emp.UpdateBy = User.Identity.Name;
                        Emp.SetDate();
                    DataAccess.Instance.EmpBasicInfoService.Update(Emp);
                    string MsgBody = "Dear "+Emp.FullName+",Your account has been created.User Id: " + Emp.EmpID + " Password : " + pass;
                    CommunicationService.SendSMSTosmstant(Emp.SMSNotificationNo, HttpUtility.UrlEncode(MsgBody) );
                }
                }
                cr.message += _SCount + " User Created Successfully";

                DataTable dt = new DataTable();
            }
            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                throw;
            }
            return Json(cr);
           
        }
    

        public ActionResult Users()
        {
           
            return View();
        }

        // GET: Users
        public ActionResult Roles()
        {
            return View();
        }
        [AllowAnonymous]
        public ActionResult RolePermission(string R)
        {
            ViewBag.id = R;
            var Role = DataAccess.Instance.Role.SingleOrDefault(e => e.Id == R);
            ViewBag.RoleName = Role.Name;
            return View();
        }        
        //[AllowAnonymous]
        [HttpGet]
        public ActionResult NewUser()
        {
            ViewBag.Roles = DataAccess.Instance.Role.GetAll();
            
            return View();
        }
       // [AllowAnonymous]
        [HttpPost]
        public async Task<ActionResult> NewUsers()
        {
            CommonResponse cr = new CommonResponse();
            EmpBasicInfo Emp = new EmpBasicInfo();
            try
            {

           
            if (ModelState.IsValid)
            {
                var img = HttpContext.Request.Files.Count > 0 ? HttpContext.Request.Files["img"] : null;
                string value = HttpContext.Request.Form["userinfo"] ?? "";
                RegisterViewModel model = JsonConvert.DeserializeObject<RegisterViewModel>(value); //  Deserialize Form Data
                    model.Email = new System.Net.Mail.MailAddress(model.Email).ToString();

                if (model.UserName.Contains(' '))
                {
                    cr.HasError = true;
                    cr.message = "No Space Allow in User Name";
                    return Json(cr, JsonRequestBehavior.AllowGet);
                }
                var r = Request.Form;
                // return RedirectToAction("NewUser");
                var user = new ApplicationUser
                {
                    UserName = model.UserName,
                    Email = model.Email,
                    FullName = model.FullName,
                    Address = model.Address,
                    Image = img != null ? Uitility.ToByte(img) : System.IO.File.ReadAllBytes(HttpContext.Server.MapPath(Enums.NoImage)),
                    MobileNo = model.MobileNo,
                    PhoneNumber = model.MobileNo,
                    EmpId = model.EmpId == null ? 0 : model.EmpId
                };
                Random rand = new Random();
                string pass = rand.Next(112233, 999999).ToString();  //System.Web.Security.Membership.GeneratePassword(7, 2).ToString();
                if (model.EmpId != null)
                {
                    if(DataAccess.Instance.CommonServices.IsExist("AspNetUsers", "EmpId = " + model.EmpId))
                    {
                        cr.HasError = true;
                        cr.message = "This Employee Already Exists in the Users List.";
                        return Json(cr, JsonRequestBehavior.AllowGet);
                    }
                    Emp = DataAccess.Instance.EmpBasicInfoService.Get(Convert.ToInt32(model.EmpId));
                    Emp.Remarks = pass;
                        Emp.UpdateBy = User.Identity.Name;
                        Emp.SetDate();
                    DataAccess.Instance.EmpBasicInfoService.Update(Emp);
                }
                var result = await UserManager.CreateAsync(user, pass);
                if (result.Succeeded)
                {
                    UserManager.AddToRole(user.Id, model.Role);
                    // For more information on how to enable account confirmation and password reset please visit http://go.microsoft.com/fwlink/?LinkID=320771
                    // Send an email with this link
                    string code = await UserManager.GenerateEmailConfirmationTokenAsync(user.Id);
                    var callbackUrl = Url.Action("ConfirmEmail", "Account", new { userId = user.Id, code = code }, protocol: Request.Url.Scheme);
                    EmailData frm = new EmailData();
                    frm.Name = model.FullName;
                    frm.Description = "Welcome to addie soft! Your Account has been Created.</br>";
                    frm.Description += "User Name : <strong> " + model.Email + " </strong></br>";
                    frm.Description += "Password  : <strong> " + pass + " </strong></br>";
                    frm.Description += "Please Click for confim your Account.";

                    frm.HasButton = true;
                    frm.ButtonText = "Confirm";
                    frm.ButtonLink = callbackUrl;
                    string body = Uitility.ViewToHtml("EmailTemplate", new ViewDataDictionary<EmailData>(frm), this.ControllerContext);

                    body = HttpUtility.HtmlDecode(body);
                    MailMessage email = new MailMessage();
                    email.To.Add(new MailAddress(model.Email));
                    email.CC.Add(new MailAddress("hr@addiesoft.com"));

                    email.Subject = "Account Confirmation";
                    email.Body = body;
                    email.IsBodyHtml = true;
                    SmtpClient client = new SmtpClient();
                    try
                    {
                        if (model.IsEmail == false && model.IsMobile == false) // Default By Email
                        {
                            client.Send(email);
                        }
                        if (model.IsEmail) //  By Email
                        {
                            client.Send(email);
                        }
                        if (model.IsMobile) // By SMS
                        {
                            string MsgBody = @"Dear " + Emp.FullName + ",Your account has been created.User Id: " + user.UserName + " Password: " + pass;
                            CommunicationService.SendSMSTosmstant(user.MobileNo, HttpUtility.UrlEncode(MsgBody));
                        }
                    }
                    catch (Exception ex)
                    {
                        cr.HasError = true;
                        cr.message = "User Created But Notification Send Failed!!" + " >> "+ ex.Message;
                        return Json(cr, JsonRequestBehavior.AllowGet);
                    }
                    cr.HasError = false;
                    cr.message = Constant.SAVED;
                    return Json(cr, JsonRequestBehavior.AllowGet);
                }
                cr.HasError = true;
                foreach (var item in result.Errors)
                {
                    cr.message += "\n" + item.ToString();
                }
            }
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest, ex.Message);

            }
            return Json(cr, JsonRequestBehavior.AllowGet);
        }

        private void AddErrors(IdentityResult result)
        {
            foreach (var error in result.Errors)
            {
                ModelState.AddModelError("", error);
            }
        }
        [HttpPost]
        public async Task<ActionResult> ResetPassword(string Password, string id, bool IsEmail, bool IsSMS)
        {
            CommonResponse cr = new CommonResponse();
            EmpBasicInfo Emp = new EmpBasicInfo();
            var user = await UserManager.FindByIdAsync(id);
            //var user = await UserManager.FindByNameAsync(model.Email);
            if (user == null)
            {
                // Don't reveal that the user does not exist or is not confirmed
                cr.ttype = Constant.TERROR;
                cr.message = Constant.NOT_FOUND;
                return Json(cr, JsonRequestBehavior.AllowGet);
            }

            string code = await UserManager.GeneratePasswordResetTokenAsync(user.Id);

            var result = await UserManager.ResetPasswordAsync(user.Id, code, Password);

            if (result.Succeeded)
            {


                if (user.EmpId != null && user.EmpId!=0)
                {
                   

                    Emp = DataAccess.Instance.EmpBasicInfoService.Get(Convert.ToInt32(user.EmpId));
                    Emp.Remarks = Password;
                    Emp.UpdateBy = User.Identity.Name;
                    Emp.SetDate();
                    DataAccess.Instance.EmpBasicInfoService.Update(Emp);
                }

                EmailData frm = new EmailData();

                frm.Name = user.FullName;
                frm.Description = "Welcome to addie soft! Your Password has been Changed.</br>";
                frm.Description += "User Name : <strong> " + user.UserName + "</strong></br>";
                frm.Description += "Password  : <strong> " + Password + "</strong></br>";


                frm.HasButton = false;
                frm.ButtonText = "Confirm";
                frm.ButtonLink = "";
                string body = Uitility.ViewToHtml("EmailTemplate", new ViewDataDictionary<EmailData>(frm), this.ControllerContext);

                body = HttpUtility.HtmlDecode(body);
                MailMessage email = new MailMessage();
                email.To.Add(new MailAddress(user.Email));

                email.Subject = "Password Reset";
                email.Body = body;
                email.IsBodyHtml = true;
                SmtpClient client = new SmtpClient();
                try
                {
                    if (IsEmail == false && IsSMS == false) // Default By Email
                    {
                        client.Send(email);
                    }

                    if (IsEmail) //  By Email
                    {
                        client.Send(email);
                    }
                    if (IsSMS) // By SMS
                    {

                        string MsgBody = "Dear " + user.FullName + ",Your password has been changed.User Name: " + user.UserName + "\n.New Password : " + Password;
                        CommunicationService.SendSMSTosmstant(user.MobileNo, HttpUtility.UrlEncode(MsgBody));
                    }
                }
                catch (Exception ex)
                {

                    cr.ttype = Constant.TERROR;
                    cr.message = "Password Changed !! Notification Send Failed!!" + " >> " + ex.Message;
                    return Json(cr, JsonRequestBehavior.AllowGet);
                }


                cr.ttype = Constant.TSUCCESS;
                cr.message = Constant.SUCCESS;
                return Json(cr, JsonRequestBehavior.AllowGet);
            }
            else
            {
                cr.ttype = Constant.TERROR;
                cr.message = result.Errors.FirstOrDefault();
                return Json(cr, JsonRequestBehavior.AllowGet);
            }


            cr.ttype = Constant.TERROR;
            cr.message = Constant.FAILED;
            return Json(cr, JsonRequestBehavior.AllowGet);
        }




        [HttpPost]
        public async Task< ActionResult> LockUser(string id)
        {


            if (!await UserManager.GetLockoutEnabledAsync(id))
            {
                await UserManager.SetLockoutEnabledAsync(id, true);
                return Json(true, JsonRequestBehavior.AllowGet);

            }

            return Json(false, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public async Task<ActionResult> UnLockUser(string id)
        {


            if (await UserManager.GetLockoutEnabledAsync(id))
            {
                await UserManager.SetLockoutEnabledAsync(id, false);
                return Json(true, JsonRequestBehavior.AllowGet);

            }

            return Json(false, JsonRequestBehavior.AllowGet);
        }
        // POST: /Users/Delete/5
        [HttpPost, ActionName("Delete")]
       
        public async Task<ActionResult> DeleteConfirmed(string id)
        {
            if (ModelState.IsValid)
            {
                if (id == null)
                {
                    return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
                }

                var user = UserManager.FindById(id);
                var logins = user.Logins;
                var rolesForUser = await UserManager.GetRolesAsync(id);

                  foreach (var login in logins.ToList())
                    {
                        await UserManager.RemoveLoginAsync(login.UserId, new UserLoginInfo(login.LoginProvider, login.ProviderKey));
                    }

                    if (rolesForUser.Count() > 0)
                    {
                        foreach (var item in rolesForUser.ToList())
                        {
                            // item should be the name of the role
                            var result = await UserManager.RemoveFromRoleAsync(user.Id, item);
                        }
                    }

                    await UserManager.DeleteAsync(user);
                  

                return Json(true);
            }
            else
            {
                return Json(false);
            }
        }
    }
}
using System;
using System.Globalization;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using UI.Portal.Models;
using OEMS.AppData;
using OEMS.Models.Model;
using OEMS.Models.ViewModel;
using System.Net.Mail;
using OEMS.Repository.Helpers;

namespace UI.Portal.Controllers
{
    [Authorize]
    public class AccountController : Controller
    {
        private ApplicationSignInManager _signInManager;
        private AspNetPortalUsersManager _userManager;
    
        public AccountController()
        {
          
        }

        public AccountController(AspNetPortalUsersManager userManager, ApplicationSignInManager signInManager)
        {
            UserManager = userManager;
            SignInManager = signInManager;
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

        public AspNetPortalUsersManager UserManager
        {
            get
            {
                return _userManager ?? HttpContext.GetOwinContext().GetUserManager<AspNetPortalUsersManager>();
            }
            private set
            {
                _userManager = value;
            }
        }

        [AllowAnonymous]
        [Route("Account/ResetPasswordByUserId/{UserId}/{newPass}")]
        public ActionResult ResetPasswordByUserId(string UserId, string newPass)
        {
           var remove = UserManager.RemovePassword(UserId);
          var newP =  UserManager.AddPassword(UserId, newPass);
            return Content("Done");
        }

        //
        // GET: /Account/Login
        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        //
        // POST: /Account/Login
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Login(LoginViewModel model, string returnUrl)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }
            //model.StudentInsId = model.StudentInsId.TrimStart(' ').TrimEnd(' ');
            ////var stu = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentInsID == model.StudentInsId).FirstOrDefault();
            //if (stu == null)
            //{
            //    ModelState.AddModelError("", "Student Id does not exits.");

            //    return View(model);
            //}
            //var user = new AspNetPortalUsers { UserName = model.StudentInsId, StudentId = (int)stu.StudentIID, PhoneNumber = stu.SMSNotificationNo };
            // This doesn't count login failures towards account lockout
            // To enable password failures to trigger account lockout, change to shouldLockout: true
            var result = await SignInManager.PasswordSignInAsync(model.StudentInsId, model.Password, model.RememberMe, shouldLockout: false);
            switch (result)
            {
                case SignInStatus.Success:
                    {
                        LogHelper.Information($"User:{model.StudentInsId} logged Succesfully.");
                        return RedirectToLocal(returnUrl);
                    }
                case SignInStatus.LockedOut:
                    return View("Lockout");
                case SignInStatus.RequiresVerification:
                    return RedirectToAction("SendCode", new { ReturnUrl = returnUrl, RememberMe = model.RememberMe });
                case SignInStatus.Failure:
                default:
                    ModelState.AddModelError("", "Student ID Or Password is wrong.");
                    return View(model);
            }
        }
        //public FileContentResult GetImage()
        //{
        //    StudentImage img = new StudentImage();
        //    string userid = User.Identity.GetUserId();
        //    var user = SignInManager.UserManager.Users.Where(u => u.Id == userid).FirstOrDefault();
        //    var student = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentIID == user.StudentId).FirstOrDefault();
        //    img = DataAccess.Instance.StudentImage.Filter(e => e.StudentIID == user.StudentId).FirstOrDefault();
        //    if (img == null)
        //    {
        //        img = new StudentImage();
        //        img.Photo = APIUitility.ToByte(System.Web.Hosting.HostingEnvironment.MapPath(Constant.NoImage));
        //    }
        //    return new FileContentResult(img.Photo, "image/jpeg");
        //}
       
        //
        // GET: /Account/VerifyCode
        [AllowAnonymous]
        public async Task<ActionResult> VerifyCode(string provider, string returnUrl, bool rememberMe)
        {
            // Require that the user has already logged in via username/password or external login
            if (!await SignInManager.HasBeenVerifiedAsync())
            {
                return View("Error");
            }
            return View(new VerifyCodeViewModel { Provider = provider, ReturnUrl = returnUrl, RememberMe = rememberMe });
        }

        //
        // POST: /Account/VerifyCode
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> VerifyCode(VerifyCodeViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            // The following code protects for brute force attacks against the two factor codes. 
            // If a user enters incorrect codes for a specified amount of time then the user account 
            // will be locked out for a specified amount of time. 
            // You can configure the account lockout settings in IdentityConfig
            var result = await SignInManager.TwoFactorSignInAsync(model.Provider, model.Code, isPersistent: model.RememberMe, rememberBrowser: model.RememberBrowser);
            switch (result)
            {
                case SignInStatus.Success:
                    return RedirectToLocal(model.ReturnUrl);
                case SignInStatus.LockedOut:
                    return View("Lockout");
                case SignInStatus.Failure:
                default:
                    ModelState.AddModelError("", "Invalid code.");
                    return View(model);
            }
        }

        //
        // GET: /Account/Register
        [AllowAnonymous]
        public ActionResult Register()
        {
            return View();
        }

        //
        // POST: /Account/Register
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Register(RegisterViewModel model)
        {
            try
            {


                if (ModelState.IsValid)
                {
                    //model.StudentInsId = model.StudentInsId.TrimStart(' ').TrimEnd(' ');
                    ////var studata = DataAccess.Instance.StudentBasicInfo.GetAll().Select(e => new RegisterViewModel { StudentInsId = e.StudentInsID.TrimStart(' ').TrimEnd(' '), StudentId = (int)e.StudentIID, PhoneNumber = e.SMSNotificationNo });
                    //model.StudentId = studata.Where(e => e.StudentInsId == model.StudentInsId && e.PhoneNumber == model.PhoneNumber).FirstOrDefault().StudentId;
                    //var user = new AspNetPortalUsers { UserName = model.StudentInsId, StudentId = model.StudentId, Email = "student" + model.StudentId + "@student.com", PhoneNumber = model.PhoneNumber };
                    //var result = await UserManager.CreateAsync(user, model.Password);
                    //if (result.Succeeded)
                    //{
                    //    await SignInManager.SignInAsync(user, isPersistent: false, rememberBrowser: false);

                    //    // For more information on how to enable account confirmation and password reset please visit http://go.microsoft.com/fwlink/?LinkID=320771
                    //    // Send an email with this link
                    //    // string code = await UserManager.GenerateEmailConfirmationTokenAsync(user.Id);
                    //    // var callbackUrl = Url.Action("ConfirmEmail", "Account", new { userId = user.Id, code = code }, protocol: Request.Url.Scheme);
                    //    // await UserManager.SendEmailAsync(user.Id, "Confirm your account", "Please confirm your account by clicking <a href=\"" + callbackUrl + "\">here</a>");

                    //    return RedirectToAction("Index", "Home");
                    //}
                    //AddErrors(result);
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", "Student ID or Mobile Number not Found");
                return View(model);
            }
            // If we got this far, something failed, redisplay form
            return View(model);
        }

        //
        // GET: /Account/ConfirmEmail
        [AllowAnonymous]
        public async Task<ActionResult> ConfirmEmail(string userId, string code)
        {
            if (userId == null || code == null)
            {
                return View("Error");
            }
            var result = await UserManager.ConfirmEmailAsync(userId, code);
            return View(result.Succeeded ? "ConfirmEmail" : "Error");
        }

        //
        // GET: /Account/ForgotPassword
        [AllowAnonymous]
        public ActionResult ForgotPassword()
        {
            return View();
        }

        //
        // POST: /Account/ForgotPassword
        [HttpPost]
        [AllowAnonymous]
        //  [ValidateAntiForgeryToken]
        public async Task<ActionResult> ForgotPassword(ForgotPasswordViewModel model)
        {
           
            if (ModelState.IsValid)
            {
                
                /////StudentBasicInfo stu = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentInsID == model.StudentInsId).FirstOrDefault();
                //var user = await UserManager.FindByNameAsync(model.StudentInsId);
                //if (user == null)
                //{
                //    // Don't reveal that the user does not exist or is not confirmed
                //    return Json(new { error = true, message = "Student Not Found!" }, JsonRequestBehavior.AllowGet);
                //}
                //StudentBasicInfo stud = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentInsID == model.StudentInsId).FirstOrDefault();
                //if (model.Type == "SMS")
                //{
                //     //&& e.SMSNotificationNo == model.PhoneNumber
                //    //if (stud==null) {
                //    //    return Json(new { error = true, message = "SMS Notificatio No Not Match!" }, JsonRequestBehavior.AllowGet);
                //    //}
                //    //else { 
                //    Random rand = new Random();
                //    //string pass = rand.Next(1122, 9999).ToString();
                //    string pass = rand.Next(112222, 999999).ToString();
                //    var token = await UserManager.GeneratePasswordResetTokenAsync(user.Id);
                //    stud.Remarks = pass;
                //    DataAccess.Instance.StudentBasicInfo.Update(stud);
                //    var result = await UserManager.ResetPasswordAsync(user.Id, token, pass);
                //    string Msg = "Your Pass has been changed,New Password: " + pass;
                //    //Emp.Remarks = pass;
                //    //DataAccess.Instance.EmpBasicInfoService.Update(Emp);
                //     CommunicationService.SendSMSTosmstant(model.PhoneNumber, HttpUtility.UrlEncode(Msg));

                //    //return RedirectToAction("ForgotPasswordConfirmation", "Account", new { Msg = "Please check your mobile.New password has been sent." });
                //    return Json(new { error = false, message = "" }, JsonRequestBehavior.AllowGet);
                //    //}
                //}
                //else if (model.Type == "EMAIL")
                //{
                //    string code = await UserManager.GeneratePasswordResetTokenAsync(user.Id);
                //    var callbackUrl = Url.Action("ResetPassword", "Account", new { userId = user.Id, code = code }, protocol: Request.Url.Scheme);
                //    //UserManager.SendEmail(user.Id, "Reset Password", "Please reset your password by clicking <a href=\"" + callbackUrl + "\">here</a>");
                //    EmailData frm = new EmailData();
                //    frm.Name = "Addie Soft Ltd";
                //    frm.Description = @" Please Click for reset password.";
                //    frm.HasButton = true;
                //    frm.ButtonText = "Reset Password";
                //    frm.ButtonLink = callbackUrl;
                //    string body = APIUitility.ViewToHtml("EmailTemplate", new ViewDataDictionary<EmailData>(frm), this.ControllerContext);
                //    StudentGuardianInfo guardian = DataAccess.Instance.aStudentGuardianService.Filter(e => e.StudentIID == stud.StudentIID).FirstOrDefault();
                //    MailMessage email = new MailMessage();
                //    //email.To.Add(new MailAddress(model.PhoneNumber)); ///Here It's Email But doesn't Give Email.
                //    email.To.Add(new MailAddress(guardian.F_Email));
                //    email.To.Add(new MailAddress(guardian.M_Email));
                    
                //    email.Subject = "Account Confirmation";
                //    email.Body = body;
                //    email.IsBodyHtml = true;
                //    SmtpClient client = new SmtpClient();
                    
                //    try
                //    {
                //        client.Send(email);
                //    }
                //    catch (Exception ex)
                //    {
                      
                //    }
                //    //client.Send(email);
                //    return RedirectToAction("ForgotPasswordConfirmation", "Account", new { Msg = "Please check your email to reset your password. " });
                //}


                // For more information on how to enable account confirmation and password reset please visit http://go.microsoft.com/fwlink/?LinkID=320771
                // Send an email with this link
                //
            }

            // If we got this far, something failed, redisplay form
            return Json(new { error = true, message = "Server Error!" }, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Account/ForgotPasswordConfirmation
        [AllowAnonymous]
        public ActionResult ForgotPasswordConfirmation()
        {
            return View();
        }

        //
        // GET: /Account/ResetPassword
        [AllowAnonymous]
        public ActionResult ResetPassword(string code)
        {
            return code == null ? View("Error") : View();
        }

        //
        // POST: /Account/ResetPassword
        [HttpPost]
        [AllowAnonymous]
        //[ValidateAntiForgeryToken]
        public async Task<ActionResult> ResetPassword(ResetPasswordViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }
            var s = User.Identity.Name;
            ///StudentBasicInfo stu = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentInsID == model.StudentInsId).FirstOrDefault();
            var user = await UserManager.FindByNameAsync(model.StudentInsId);
            if (user == null)
            {
                // Don't reveal that the user does not exist
                return RedirectToAction("ResetPasswordConfirmation", "Account");
            }
            var result = await UserManager.ResetPasswordAsync(user.Id, model.Code, model.Password);
            if (result.Succeeded)
            {
                return RedirectToAction("ResetPasswordConfirmation", "Account");
            }
            AddErrors(result);
            return View();
        }

        //
        // GET: /Account/ResetPasswordConfirmation
        [AllowAnonymous]
        public ActionResult ResetPasswordConfirmation()
        {
            return View();
        }

        //
        // POST: /Account/ExternalLogin
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult ExternalLogin(string provider, string returnUrl)
        {
            // Request a redirect to the external login provider
            return new ChallengeResult(provider, Url.Action("ExternalLoginCallback", "Account", new { ReturnUrl = returnUrl }));
        }

        //
        // GET: /Account/SendCode
        [AllowAnonymous]
        public async Task<ActionResult> SendCode(string returnUrl, bool rememberMe)
        {
            var userId = await SignInManager.GetVerifiedUserIdAsync();
            if (userId == null)
            {
                return View("Error");
            }
            var userFactors = await UserManager.GetValidTwoFactorProvidersAsync(userId);
            var factorOptions = userFactors.Select(purpose => new SelectListItem { Text = purpose, Value = purpose }).ToList();
            return View(new SendCodeViewModel { Providers = factorOptions, ReturnUrl = returnUrl, RememberMe = rememberMe });
        }

        //
        // POST: /Account/SendCode
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> SendCode(SendCodeViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View();
            }

            // Generate the token and send it
            if (!await SignInManager.SendTwoFactorCodeAsync(model.SelectedProvider))
            {
                return View("Error");
            }
            return RedirectToAction("VerifyCode", new { Provider = model.SelectedProvider, ReturnUrl = model.ReturnUrl, RememberMe = model.RememberMe });
        }

        //
        // GET: /Account/ExternalLoginCallback
        [AllowAnonymous]
        public async Task<ActionResult> ExternalLoginCallback(string returnUrl)
        {
            var loginInfo = await AuthenticationManager.GetExternalLoginInfoAsync();
            if (loginInfo == null)
            {
                return RedirectToAction("Login");
            }

            // Sign in the user with this external login provider if the user already has a login
            var result = await SignInManager.ExternalSignInAsync(loginInfo, isPersistent: false);
            switch (result)
            {
                case SignInStatus.Success:
                    return RedirectToLocal(returnUrl);
                case SignInStatus.LockedOut:
                    return View("Lockout");
                case SignInStatus.RequiresVerification:
                    return RedirectToAction("SendCode", new { ReturnUrl = returnUrl, RememberMe = false });
                case SignInStatus.Failure:
                default:
                    // If the user does not have an account, then prompt the user to create an account
                    ViewBag.ReturnUrl = returnUrl;
                    ViewBag.LoginProvider = loginInfo.Login.LoginProvider;
                    return View("ExternalLoginConfirmation", new ExternalLoginConfirmationViewModel { Email = loginInfo.Email });
            }
        }

        //
        // POST: /Account/ExternalLoginConfirmation
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> ExternalLoginConfirmation(ExternalLoginConfirmationViewModel model, string returnUrl)
        {
            if (User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Index", "Manage");
            }

            if (ModelState.IsValid)
            {
                // Get the information about the user from the external login provider
                var info = await AuthenticationManager.GetExternalLoginInfoAsync();
                if (info == null)
                {
                    return View("ExternalLoginFailure");
                }
                var user = new AspNetPortalUsers { UserName = model.Email, Email = model.Email };
                var result = await UserManager.CreateAsync(user);
                if (result.Succeeded)
                {
                    result = await UserManager.AddLoginAsync(user.Id, info.Login);
                    if (result.Succeeded)
                    {
                        await SignInManager.SignInAsync(user, isPersistent: false, rememberBrowser: false);
                        return RedirectToLocal(returnUrl);
                    }
                }
                AddErrors(result);
            }

            ViewBag.ReturnUrl = returnUrl;
            return View(model);
        }

        //
        // POST: /Account/LogOff
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LogOff()
        {
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            return RedirectToAction("Index", "Home");
        }

        //
        // GET: /Account/ExternalLoginFailure
        [AllowAnonymous]
        public ActionResult ExternalLoginFailure()
        {
            return View();
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (_userManager != null)
                {
                    _userManager.Dispose();
                    _userManager = null;
                }

                if (_signInManager != null)
                {
                    _signInManager.Dispose();
                    _signInManager = null;
                }
            }

            base.Dispose(disposing);
        }

        #region Helpers
        // Used for XSRF protection when adding external logins
        private const string XsrfKey = "XsrfId";

        private IAuthenticationManager AuthenticationManager
        {
            get
            {
                return HttpContext.GetOwinContext().Authentication;
            }
        }

        private void AddErrors(IdentityResult result)
        {
            foreach (var error in result.Errors)
            {
                ModelState.AddModelError("", error);
            }
        }

        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            return RedirectToAction("Index", "Home");
        }

        internal class ChallengeResult : HttpUnauthorizedResult
        {
            public ChallengeResult(string provider, string redirectUri)
                : this(provider, redirectUri, null)
            {
            }

            public ChallengeResult(string provider, string redirectUri, string userId)
            {
                LoginProvider = provider;
                RedirectUri = redirectUri;
                UserId = userId;
            }

            public string LoginProvider { get; set; }
            public string RedirectUri { get; set; }
            public string UserId { get; set; }

            public override void ExecuteResult(ControllerContext context)
            {
                var properties = new AuthenticationProperties { RedirectUri = RedirectUri };
                if (UserId != null)
                {
                    properties.Dictionary[XsrfKey] = UserId;
                }
                context.HttpContext.GetOwinContext().Authentication.Challenge(properties, LoginProvider);
            }
        }
        #endregion
    }
}
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.ModelBinding;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.OAuth;
using MobileApps.Api.Models;
using MobileApps.Api.Providers;
using MobileApps.Api.Results;
using OEMS.AppData;
using OEMS.Models.Model.Employee;
using System.Data;
using OEMS.Repository.Repositories;
using System.Linq;
using OEMS.Models.Model.SMS;

namespace MobileApps.Api.Controllers
{
    [Authorize]
    [RoutePrefix("api/Account")]
    public class AccountController : ApiController
    {
        private const string LocalLoginProvider = "Local";
        private ApplicationUserManager _userManager;

        public AccountController()
        {
        }



        public AccountController(ApplicationUserManager userManager,
            ISecureDataFormat<AuthenticationTicket> accessTokenFormat)
        {
            UserManager = userManager;
            AccessTokenFormat = accessTokenFormat;
        }

        public ApplicationUserManager UserManager
        {
            get
            {
                return _userManager ?? Request.GetOwinContext().GetUserManager<ApplicationUserManager>();
            }
            private set
            {
                _userManager = value;
            }
        }

        public ISecureDataFormat<AuthenticationTicket> AccessTokenFormat { get; private set; }

        // GET api/Account/UserInfo
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        [Route("UserInfo")]
        public UserInfoViewModel GetUserInfo()
        {
            ExternalLoginData externalLogin = ExternalLoginData.FromIdentity(User.Identity as ClaimsIdentity);
            CommonRepository commonRepository = new CommonRepository();
            ApplicationUser user1 =  UserManager.FindById(User.Identity.GetUserId());
            int empId = Convert.ToInt32(user1.EmpId);
            DataSet dt = commonRepository.getDatasetResponseBySp("GetEmpInfoDetailID", new object[] { empId }).results;
            EmpBasicInfo emp = CommonRepository.ConvertDataTable<EmpBasicInfo>(dt.Tables[0]).FirstOrDefault(); 


            return new UserInfoViewModel
            {
                Email = user1.Email,
                EmpId = user1.EmpId,
                FullName = user1.FullName,                
                MobileNo= user1.MobileNo,
                HasRegistered = externalLogin == null,
                LoginProvider = externalLogin != null ? externalLogin.LoginProvider : null,
                BloodGroup = emp.BloodGroup==null ? "" : emp.BloodGroup,
                DOB = emp.DateOfBirth,
                Religion = emp.Religion == null ? "" : emp.Religion,
                NID = emp.NationalID == null ? "" : emp.NationalID,
                EmgName =  emp.EmergencyContactName == null ? "" : emp.EmergencyContactName,
                EmgRelation = emp.EmergencyContactRelation == null ? "" : emp.EmergencyContactRelation,
                EmgMobile = emp.EmergencyContactNo == null ? "" : emp.EmergencyContactNo,
                EmgAddress = emp.EmergencyContactAddress == null ? "" : emp.EmergencyContactAddress,
                Address = emp.PresentAddress == null ? "" : emp.PresentAddress,
                DesignationName = emp.DesignationName,
                DepartmentName = emp.DepartmentName,
                EmployeeId = emp.EmpID ,
                FatherName = emp.FatherName,
                MotherName = emp.MotherName,
                Nationality = emp.Nationality,
                Gender = emp.Gender,
                MaritalStatus = emp.MaritalStatus,
                Image = emp.Image,
                PresentAddress = emp.PresentAddress,
                PermanentAddress = emp.PermanentAddress
            };
        }

        // POST api/Account/Logout
        [Route("Logout")]
        public IHttpActionResult Logout()
        {
            Authentication.SignOut(CookieAuthenticationDefaults.AuthenticationType);
            return Ok();
        }

        // GET api/Account/ManageInfo?returnUrl=%2F&generateState=true
        [Route("ManageInfo")]
        public async Task<ManageInfoViewModel> GetManageInfo(string returnUrl, bool generateState = false)
        {
            IdentityUser user = await UserManager.FindByIdAsync(User.Identity.GetUserId());

            if (user == null)
            {
                return null;
            }

            List<UserLoginInfoViewModel> logins = new List<UserLoginInfoViewModel>();

            foreach (IdentityUserLogin linkedAccount in user.Logins)
            {
                logins.Add(new UserLoginInfoViewModel
                {
                    LoginProvider = linkedAccount.LoginProvider,
                    ProviderKey = linkedAccount.ProviderKey
                });
            }

            if (user.PasswordHash != null)
            {
                logins.Add(new UserLoginInfoViewModel
                {
                    LoginProvider = LocalLoginProvider,
                    ProviderKey = user.UserName,
                });
            }

            return new ManageInfoViewModel
            {
                LocalLoginProvider = LocalLoginProvider,
                Email = user.UserName,
                Logins = logins,
                ExternalLoginProviders = GetExternalLogins(returnUrl, generateState)
            };
        }

        // POST api/Account/ChangePassword
        [Route("ChangePassword")]
        public async Task<IHttpActionResult> ChangePassword(ChangePasswordBindingModel model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            IdentityResult result = await UserManager.ChangePasswordAsync(User.Identity.GetUserId(), model.OldPassword,  model.NewPassword);
            
            if (!result.Succeeded)
            {
                return GetErrorResult(result);
            }

            return Ok();
        }

        // POST api/Account/SetPassword
        [Route("SetPassword")]
        public async Task<IHttpActionResult> SetPassword(SetPasswordBindingModel model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            IdentityResult result = await UserManager.AddPasswordAsync(User.Identity.GetUserId(), model.NewPassword);
            if (!result.Succeeded)
            {
                return GetErrorResult(result);
            }

            return Ok();
        }

        // POST: /Account/ForgotPassword
        [HttpPost]
        [AllowAnonymous]
        [Route("ForgotPassword")]
        //  [ValidateAntiForgeryToken]
        public async Task<IHttpActionResult> ForgotPassword(ForgotPasswordViewModel model)
        {

            try
            {
                if (ModelState.IsValid)
                {
                    var employeeId = model.EmployeeId.TrimStart(' ').TrimEnd(' ');
                    var empdata = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID == model.EmployeeId && e.SMSNotificationNo == model.PhoneNumber).FirstOrDefault();
                    if (empdata == null)
                    {

                        ModelState.AddModelError("Error", "Employee ID or Mobile Number not Found");
                        return BadRequest(ModelState);
                    }

                    var user = await UserManager.FindByNameAsync(employeeId);
                    // ViewBag.SMSNo = string.IsNullOrEmpty(user.PhoneNumber) ? null : $"******{ user.PhoneNumber.Substring(Math.Max(0, user.PhoneNumber.Length - 4))}";
                    //ViewBag.Email = string.IsNullOrEmpty(user.Email) ? null : $"******{ user.Email.Substring(Math.Max(0, user.Email.Length - 14))}";

                    if (user == null)
                    {
                        // Don't reveal that the user does not exist or is not confirmed
                        ModelState.AddModelError("Error", "Employee Id didn't exits.");
                        return BadRequest(ModelState);
                    }

                    else
                    {
                        string Key = StringCipher.Encrypt(empdata.EmpID.ToString(), "ABC9876");
                        string FullKey = string.Empty;
                        bool res = false;
                        string EmployeeIID = StringCipher.Decrypt(Key, "ABC9876");
                        var empData = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID == EmployeeIID).FirstOrDefault();

                        if (empData != null)
                        {
                            string OTP = APIUitility.GetOTP();
                            //ViewBag.resOTP = OTP;

                            FullKey = $"{empData.SMSNotificationNo}_{DateTime.Now.AddMinutes(5).ToString()}_{OTP}_{EmployeeIID}";
                            Key = StringCipher.Encrypt(FullKey, (Convert.ToInt32(OTP) * Convert.ToInt32(OTP)).ToString());
                            //ViewBag.HashKey = Key;
                            //ViewBag.StuInsID = empData.EmpID;
                            string Msg = "Your ASL OFFICE APPS OTP is " + OTP + ". Please use this OTP to reset your account Password.";
                            //CommunicationService.SendSMSTosmstant(Studata.SMSNotificationNo, Msg);
                            //---------------add by bapon ----2020-10-17--------
                            SMSSendHistroy SMSSendHistroy = new SMSSendHistroy();
                            SMSSendHistroy.StudentIId = empData.EmpBasicInfoID;
                            SMSSendHistroy.ReceiveNumber = empData.SMSNotificationNo;
                            SMSSendHistroy.SMSBody = Msg;
                            SMSSendHistroy.SMSPart = 1;
                            SMSSendHistroy.CategoryId = 11;
                            SMSSendHistroy.AddBy = User.Identity.Name;
                            SMSSendHistroy.AddDate = DateTime.Now;
                            SMSSendHistroy.SendDateTime = DateTime.Now;
                            SMSSendHistroy.Status = "A";
                            SMSSendHistroy.SendStatus = 2;
                            SMSSendHistroy.SetDate();
                            var sendSMS = CommunicationService.SendSMSTosmstant(empData.SMSNotificationNo, Msg);
                            if (sendSMS.FirstOrDefault().StatusCode == 1)
                            {
                                SMSSendHistroy.SendStatus = 1;
                                SMSSendHistroy.JobId = sendSMS.FirstOrDefault().MsgId;
                                try
                                {
                                    res = DataAccess.Instance.SMSSendHistroyService.Add(SMSSendHistroy);
                                }
                                catch (Exception ex)
                                {
                                    throw new Exception(ex.Message.ToString());
                                }
                            }
                            else
                            {
                                SMSSendHistroy.SendStatus = sendSMS.FirstOrDefault().StatusCode;
                                SMSSendHistroy.JobId = sendSMS.FirstOrDefault().MsgId;
                                try
                                {
                                    res = DataAccess.Instance.SMSSendHistroyService.Add(SMSSendHistroy);
                                }
                                catch (Exception ex)
                                {
                                    throw new Exception(ex.Message.ToString());
                                }

                            }

                            return Json(Key);
                        }

                    }

                }

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("Error", ex.Message.ToString());
                return BadRequest(ModelState);
            }

            // If we got this far, something failed, redisplay form
            ModelState.AddModelError("Error", "Something going wrong.Try with valid Id & Mobile no.");
            return BadRequest(ModelState);

            // return Json(new { error = true, message = "Server Error!" }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        [AllowAnonymous]
        [Route("ResetPassword")]
        //[ValidateAntiForgeryToken]
        public async Task<IHttpActionResult> ResetPassword(ResetPasswordViewModel model)
        {
            string DecryptKey = string.Empty;
            string key = (Convert.ToInt32(model.OTP) * Convert.ToInt32(model.OTP)).ToString();

            try
            {
                DecryptKey = StringCipher.Decrypt(model.Key, key);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("Error", ex.Message.ToString());
                // return View();
                return BadRequest(ModelState);
            }


            string[] Keyvalue = DecryptKey.Split('_');
            if (Keyvalue[2] == model.OTP)
            {
                string EmployeeID = Keyvalue[3];
                var Studata = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID == EmployeeID).FirstOrDefault();

                if (model.EmployeeId == Studata.EmpID)
                {
                    var user = await UserManager.FindByNameAsync(model.EmployeeId);

                    if (user != null)
                    {
                        var result = await UserManager.RemovePasswordAsync(user.Id);
                        if (result.Succeeded)
                        {
                            var passReset = await UserManager.AddPasswordAsync(user.Id, model.Password);
                            if (passReset.Succeeded)
                            {
                                return Ok();
                            }
                        }

                    }

                }


            }

            ModelState.AddModelError("Error", "Something is going wrong.Please Contact with Addie Soft Authority");
            return BadRequest(ModelState);

        }

       
        //[Route("ResetPassword")]
        //public async Task<IHttpActionResult> ResetPassword(ResetPasswordBindingModel model)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        return BadRequest(ModelState);
        //    }
        //    var user = await UserManager.FindByEmailAsync(model.Email);
        //    if (user == null)  //|| !(await UserManager.IsEmailConfirmedAsync(user.Id))
        //    {
        //        // Don't reveal that the user does not exist or is not confirmed
        //        return BadRequest();
        //    }
        //    string code = await UserManager.GeneratePasswordResetTokenAsync(user.Id);
        //    IdentityResult result = await UserManager.ResetPasswordAsync(User.Identity.GetUserId(), code, model.ConfirmPassword);
        //    if (!result.Succeeded)
        //    {
        //        return GetErrorResult(result);
        //    }

        //    return Ok();
        //}

        // POST api/Account/AddExternalLogin
        [Route("AddExternalLogin")]
        public async Task<IHttpActionResult> AddExternalLogin(AddExternalLoginBindingModel model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            Authentication.SignOut(DefaultAuthenticationTypes.ExternalCookie);

            AuthenticationTicket ticket = AccessTokenFormat.Unprotect(model.ExternalAccessToken);

            if (ticket == null || ticket.Identity == null || (ticket.Properties != null
                && ticket.Properties.ExpiresUtc.HasValue
                && ticket.Properties.ExpiresUtc.Value < DateTimeOffset.UtcNow))
            {
                return BadRequest("External login failure.");
            }

            ExternalLoginData externalData = ExternalLoginData.FromIdentity(ticket.Identity);

            if (externalData == null)
            {
                return BadRequest("The external login is already associated with an account.");
            }

            IdentityResult result = await UserManager.AddLoginAsync(User.Identity.GetUserId(),
                new UserLoginInfo(externalData.LoginProvider, externalData.ProviderKey));

            if (!result.Succeeded)
            {
                return GetErrorResult(result);
            }

            return Ok();
        }

        // POST api/Account/RemoveLogin
        [Route("RemoveLogin")]
        public async Task<IHttpActionResult> RemoveLogin(RemoveLoginBindingModel model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            IdentityResult result;

            if (model.LoginProvider == LocalLoginProvider)
            {
                result = await UserManager.RemovePasswordAsync(User.Identity.GetUserId());
            }
            else
            {
                result = await UserManager.RemoveLoginAsync(User.Identity.GetUserId(),
                    new UserLoginInfo(model.LoginProvider, model.ProviderKey));
            }

            if (!result.Succeeded)
            {
                return GetErrorResult(result);
            }

            return Ok();
        }

        // GET api/Account/ExternalLogin
        [OverrideAuthentication]
        [HostAuthentication(DefaultAuthenticationTypes.ExternalCookie)]
        [AllowAnonymous]
        [Route("ExternalLogin", Name = "ExternalLogin")]
        public async Task<IHttpActionResult> GetExternalLogin(string provider, string error = null)
        {
            if (error != null)
            {
                return Redirect(Url.Content("~/") + "#error=" + Uri.EscapeDataString(error));
            }

            if (!User.Identity.IsAuthenticated)
            {
                return new ChallengeResult(provider, this);
            }

            ExternalLoginData externalLogin = ExternalLoginData.FromIdentity(User.Identity as ClaimsIdentity);

            if (externalLogin == null)
            {
                return InternalServerError();
            }

            if (externalLogin.LoginProvider != provider)
            {
                Authentication.SignOut(DefaultAuthenticationTypes.ExternalCookie);
                return new ChallengeResult(provider, this);
            }

            ApplicationUser user = await UserManager.FindAsync(new UserLoginInfo(externalLogin.LoginProvider,
                externalLogin.ProviderKey));

            bool hasRegistered = user != null;

            if (hasRegistered)
            {
                Authentication.SignOut(DefaultAuthenticationTypes.ExternalCookie);
                
                 ClaimsIdentity oAuthIdentity = await user.GenerateUserIdentityAsync(UserManager,
                    OAuthDefaults.AuthenticationType);
                ClaimsIdentity cookieIdentity = await user.GenerateUserIdentityAsync(UserManager,
                    CookieAuthenticationDefaults.AuthenticationType);

                AuthenticationProperties properties = ApplicationOAuthProvider.CreateProperties(user.UserName);
                Authentication.SignIn(properties, oAuthIdentity, cookieIdentity);
            }
            else
            {
                IEnumerable<Claim> claims = externalLogin.GetClaims();
                ClaimsIdentity identity = new ClaimsIdentity(claims, OAuthDefaults.AuthenticationType);
                Authentication.SignIn(identity);
            }

            return Ok();
        }

        // GET api/Account/ExternalLogins?returnUrl=%2F&generateState=true
        [AllowAnonymous]
        [Route("ExternalLogins")]
        public IEnumerable<ExternalLoginViewModel> GetExternalLogins(string returnUrl, bool generateState = false)
        {
            IEnumerable<AuthenticationDescription> descriptions = Authentication.GetExternalAuthenticationTypes();
            List<ExternalLoginViewModel> logins = new List<ExternalLoginViewModel>();

            string state;

            if (generateState)
            {
                const int strengthInBits = 256;
                state = RandomOAuthStateGenerator.Generate(strengthInBits);
            }
            else
            {
                state = null;
            }

            foreach (AuthenticationDescription description in descriptions)
            {
                ExternalLoginViewModel login = new ExternalLoginViewModel
                {
                    Name = description.Caption,
                    Url = Url.Route("ExternalLogin", new
                    {
                        provider = description.AuthenticationType,
                        response_type = "token",
                        client_id = Startup.PublicClientId,
                        redirect_uri = new Uri(Request.RequestUri, returnUrl).AbsoluteUri,
                        state = state
                    }),
                    State = state
                };
                logins.Add(login);
            }

            return logins;
        }

        // POST api/Account/Register
        [AllowAnonymous]
        [Route("Register")]
        public async Task<IHttpActionResult> Register(RegisterBindingModel model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var user = new ApplicationUser() { UserName = model.Email, Email = model.Email };

            IdentityResult result = await UserManager.CreateAsync(user, model.Password);

            if (!result.Succeeded)
            {
                return GetErrorResult(result);
            }

            return Ok();
        }

        // POST api/Account/RegisterExternal
        [OverrideAuthentication]
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        [Route("RegisterExternal")]
        public async Task<IHttpActionResult> RegisterExternal(RegisterExternalBindingModel model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var info = await Authentication.GetExternalLoginInfoAsync();
            if (info == null)
            {
                return InternalServerError();
            }

            var user = new ApplicationUser() { UserName = model.Email, Email = model.Email };

            IdentityResult result = await UserManager.CreateAsync(user);
            if (!result.Succeeded)
            {
                return GetErrorResult(result);
            }

            result = await UserManager.AddLoginAsync(user.Id, info.Login);
            if (!result.Succeeded)
            {
                return GetErrorResult(result); 
            }
            return Ok();
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing && _userManager != null)
            {
                _userManager.Dispose();
                _userManager = null;
            }

            base.Dispose(disposing);
        }

        #region Helpers

        private IAuthenticationManager Authentication
        {
            get { return Request.GetOwinContext().Authentication; }
        }

        private IHttpActionResult GetErrorResult(IdentityResult result)
        {
            if (result == null)
            {
                return InternalServerError();
            }

            if (!result.Succeeded)
            {
                if (result.Errors != null)
                {
                    foreach (string error in result.Errors)
                    {
                        ModelState.AddModelError("", error);
                    }
                }

                if (ModelState.IsValid)
                {
                    // No ModelState errors are available to send, so just return an empty BadRequest.
                    return BadRequest();
                }

                return BadRequest(ModelState);
            }

            return null;
        }

        private class ExternalLoginData
        {
            public string LoginProvider { get; set; }
            public string ProviderKey { get; set; }
            public string UserName { get; set; }

            public IList<Claim> GetClaims()
            {
                IList<Claim> claims = new List<Claim>();
                claims.Add(new Claim(ClaimTypes.NameIdentifier, ProviderKey, null, LoginProvider));

                if (UserName != null)
                {
                    claims.Add(new Claim(ClaimTypes.Name, UserName, null, LoginProvider));
                }

                return claims;
            }

            public static ExternalLoginData FromIdentity(ClaimsIdentity identity)
            {
                if (identity == null)
                {
                    return null;
                }

                Claim providerKeyClaim = identity.FindFirst(ClaimTypes.NameIdentifier);

                if (providerKeyClaim == null || String.IsNullOrEmpty(providerKeyClaim.Issuer)
                    || String.IsNullOrEmpty(providerKeyClaim.Value))
                {
                    return null;
                }

                if (providerKeyClaim.Issuer == ClaimsIdentity.DefaultIssuer)
                {
                    return null;
                }

                return new ExternalLoginData
                {
                    LoginProvider = providerKeyClaim.Issuer,
                    ProviderKey = providerKeyClaim.Value,
                    UserName = identity.FindFirstValue(ClaimTypes.Name)
                };
            }
        }

        private static class RandomOAuthStateGenerator
        {
            private static RandomNumberGenerator _random = new RNGCryptoServiceProvider();

            public static string Generate(int strengthInBits)
            {
                const int bitsPerByte = 8;

                if (strengthInBits % bitsPerByte != 0)
                {
                    throw new ArgumentException("strengthInBits must be evenly divisible by 8.", "strengthInBits");
                }

                int strengthInBytes = strengthInBits / bitsPerByte;

                byte[] data = new byte[strengthInBytes];
                _random.GetBytes(data);
                return HttpServerUtility.UrlTokenEncode(data);
            }
        }

        #endregion
    }
}

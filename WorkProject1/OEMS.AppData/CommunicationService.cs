using Newtonsoft.Json;
using OEMS.Models.Constant;
using OEMS.Models.ViewModel;
using OEMS.Models.ViewModel.SetUp;
using OEMS.Models.ViewModel.SMS;
using OEMS.Models.ViewModel.TaskManagement;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using UI.Admin.Models.Task;
using static OEMS.Models.Constant.Enums;
using Newtonsoft.Json.Linq;
using OEMS.Models;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using RestSharp;

namespace OEMS.AppData
{
    public class CommunicationService
    {
        //public static void SendSMS(string To,string Message)
        //{
        //    string Url = string.Format("https://api.mobireach.com.bd/SendTextMessage?Username=addisoft&Password=$m$@R0b!4321&From=8801847169974&To={0}&Message={1}", To, Message);
        //    WebClient wc = new WebClient();
        //    var xmlstr = wc.DownloadString(Url);
        //    XmlDocument xmlDoc = new XmlDocument();
        //    xmlDoc.LoadXml(xmlstr);
        //}

        public static List<SendResponse> SendSMSTosmstant(string To, string Message)
        {

            string UserName = ConfigurationManager.AppSettings["SMSUserName"];
            string Password = ConfigurationManager.AppSettings["SMSPAssword"];
            string SMSBaseUrl = ConfigurationManager.AppSettings["SMSBaseUrl"];
            string Url = $"{SMSBaseUrl}/SendSMS?user={UserName}&password={Password}&Reciver={To}&SMSBody={Message}";
            WebClient wc = new WebClient();
            var xmlstr = wc.DownloadString(Url);
           return Converter.ToJsonList<SendResponse>(xmlstr);

        }

        public static dynamic SMSRecharge(string NoOfSMS)
        {
            try
            {
                string UserName = HttpUtility.UrlEncode(ConfigurationManager.AppSettings["SMSUserName"]);
                string Password = ConfigurationManager.AppSettings["SMSPAssword"];
                string SMSBaseUrl = ConfigurationManager.AppSettings["SMSBaseUrl"];
                string Url = $"{SMSBaseUrl}/SMSPortal/Pay2FeeCreateByOther?user={UserName}&password={Password}&NoOfSMS={NoOfSMS}";

                WebClient wc = new WebClient();
                var xmlstr = wc.DownloadString(Url);
                return JsonConvert.DeserializeObject<SendPaymentResponse>(xmlstr);
            }
            catch (Exception ex)
            {

                return ex;
            }


        }

        public static string GetWhereClause(IssueFilterVM issue)
        {
            string whereclause = $" I.IsDeleted = 0 AND I.StatusId = {issue.StatusId}";
            if (!String.IsNullOrEmpty(issue.Priority))
            {
                whereclause += $" AND I.Priority = '{issue.Priority}' ";
            }

            if (issue.IssueTypeId > 0)
            {
                whereclause += $" AND ISNULL(I.IssueTypeId,0) = {issue.IssueTypeId} ";
            }

            if (issue.ProjectId > 0)
            {
                whereclause += $" AND ISNULL(I.ProjectId,0) = {issue.ProjectId} ";
            }
            if (issue.ClientId > 0)
            {
                whereclause += $" AND ISNULL(I.ClientId,0) = {issue.ClientId} ";
            }

            if (issue.AssigneeId > 0)
            {
                whereclause += $" AND ISNULL(I.AssigneeId,0) = {issue.AssigneeId} ";
            }

            if (issue.ReporteId > 0)
            {
                whereclause += $" AND ISNULL(I.ReporterId,0) = {issue.ReporteId} ";
            }

            if (!String.IsNullOrEmpty(issue.DueDate))
            {
                whereclause += $" AND  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) IN (CAST(ISNULL('{issue.DueDate}', ISNULL(I.DueDate,I.AddDate)) AS DATE)) ";
            }
            return whereclause;
        }
        public static dynamic OnlinePayment(string DueAmount)
        {
            try
            {
                string UserName = HttpUtility.UrlEncode(ConfigurationManager.AppSettings["SMSUserName"]);
                string Password = ConfigurationManager.AppSettings["SMSPAssword"];
                string SMSBaseUrl = ConfigurationManager.AppSettings["SMSBaseUrl"];
                string Url = $"{SMSBaseUrl}/SMSPortal/Pay2FeeCreateByOther?user={UserName}&password={Password}&NoOfSMS={DueAmount}";

                //string UserName = HttpUtility.UrlEncode(ConfigurationManager.AppSettings["p2f_Username"]);
                //string Password = ConfigurationManager.AppSettings["p2f_Password"];
                //string BaseUrl = ConfigurationManager.AppSettings["baseUrl"];
                //string Url = $"{BaseUrl}/Pay2FeeCreateByOther?user={UserName}&password={Password}&Amount={DueAmount}";

                WebClient wc = new WebClient();
                var xmlstr = wc.DownloadString(Url);
                return JsonConvert.DeserializeObject<SendPaymentResponse>(xmlstr);
            }
            catch (Exception ex)
            {

                return ex;
            }


        }
        public static void AddIssueHistory(int issueId, string type, string description, int? parentId, int? sprinttId, int? PreviousId, int? PresentId,string UserId)
        {
            IssueHistory _issueHistory = new IssueHistory();
            _issueHistory.IssueId = issueId;
            _issueHistory.Type = type;
            _issueHistory.Description = description;
            _issueHistory.ParentId = parentId;
            _issueHistory.SprinttId = sprinttId;
            _issueHistory.PreviousId = PreviousId;
            _issueHistory.PresentId = PresentId;
            _issueHistory.UserId = UserId;
            _issueHistory.ModifyDate = DateTime.Now;
            var res = DataAccess.Instance.IssueHistoryService.Add(_issueHistory);

        }
        public static CustomerResponse GetCustomerInfo()
        {

            string UserName = ConfigurationManager.AppSettings["SMSUserName"];
            string Password = ConfigurationManager.AppSettings["SMSPAssword"];
            string SMSBaseUrl = ConfigurationManager.AppSettings["SMSBaseUrl"];
            string Url = $"{SMSBaseUrl}/GetCustomerInfo?user={UserName}&password={Password}";
            WebClient wc = new WebClient();
            var xmlstr = wc.DownloadString(Url);
            return Converter.ToJson<CustomerResponse>(xmlstr);
           
        }
        

        public static void SendEmail(string EmailType, string Body="",string To="", string CC = "" , string BCC="", params string[] Prams)
        {
           var EmailTemp= DataAccess.Instance.EmailTemplateService.Filter(e => e.EmailType == EmailType).FirstOrDefault();
            if (!string.IsNullOrEmpty(Body))
            {
                EmailTemp.BodyTemplate = Body;
            }
            if (Prams.Count() > 0)
            {
                EmailTemp.BodyTemplate = string.Format(EmailTemp.BodyTemplate, Prams);
            }
            SmtpClient client = new SmtpClient();
            MailMessage email = EmailTemp.GetMailMessage();
            if (!string.IsNullOrEmpty(To))
            {
                email.To.Add(To);
            }
            if (!string.IsNullOrEmpty(CC))
            {
                email.CC.Add(CC);
            }
            if (!string.IsNullOrEmpty(BCC))
            {
                email.Bcc.Add(BCC);
            }

            client.Send(email);

        }


        public static void PushNotifier(PushNotificationVM body)
        {
            try
            {
                var jsonBody = JsonConvert.SerializeObject(body);
                var client = new RestClient("https://fcm.googleapis.com/fcm/send");
                var request = new RestRequest(Method.POST);
                request.AddHeader("Postman-Token", "d8e28e11-fbb3-4e5c-8edb-4a67b675dddf");
                request.AddHeader("cache-control", "no-cache");
                request.AddHeader("Content-Type", "application/json");
                request.AddHeader("Authorization", "key=AAAAKb5H5CE:APA91bFjP1DPi_xsRg6PTWcf1JgIWAraNRBfPEOlhwsgW0JL2N_KZ0H7fFbBjcqTUE3FCaW2jpWW59-pjojkriXm4O9v_xaQXGC4fsAqTvGevjzn3cwFyScNf0c7AW9QCl1aPvX7mc2u");
                request.AddParameter("application/json", jsonBody, ParameterType.RequestBody);
                IRestResponse response = client.Execute(request);
            }
            catch (Exception)
            {

                throw;
            }
            // Using Newtonsoft.Json

        }

        public static void PushNotification(int empId, int type, string body, string title, int? sprinttId, int? PreviousId, int? PresentId)
        {
            PushNotificationVM notifyer = new PushNotificationVM()
            {
                to = "/topics/" + empId,
                notification = new NotificationVM { title = title, body = body }
                ,
                priority = "high"
                ,
                data = new NotificationDataVM { id = "1", title = title, body = body, status = "done", type = type, content_available = true, priority = "high" }
            };
            CommunicationService.PushNotifier(notifyer);

        }

    }


}

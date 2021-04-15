using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Company
{
    [Table("Com_EmailTemplate")]
    public class EmailTemplate:Entity
    {
       
        public EmailTemplate()
        {
           
        }

        [Key]
        public int Id { get; set; }
        public string EmailType { get; set; }// Value From ENUM
        public string Subject { get; set; }
        public string BodyTemplate { get; set; }
        public string From { get; set; }
        public string FromDisplayName { get; set; }
        public string To { get; set; }
        public string CC { get; set; }
        public string BCC { get; set; }
        public bool IsBodyHtml { get; set; }
        public bool HasAttachment { get; set; }

        


       public MailMessage GetMailMessage()
        {
            var mail = new MailMessage();
            mail.To.Add(To);
            mail.From = new MailAddress(From,FromDisplayName);
            mail.CC.Add(CC);
            mail.Bcc.Add(BCC);
            mail.Subject = Subject;
            mail.Body = BodyTemplate;
            mail.IsBodyHtml = IsBodyHtml;
            mail.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
            return mail;
        }
    }
}

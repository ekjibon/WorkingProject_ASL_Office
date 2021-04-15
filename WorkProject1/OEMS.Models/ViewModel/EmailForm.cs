using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
    public class EmailForm
    {
      
        public string From { get; set; }
        public  string Body { get; set; }
        
        public  List<MailAddress> Destination { get; set; }
       
        public  string Subject { get; set; }
        public List<MailAddress> CC { get; set; }
        public List<MailAddress> BCC { get; set; }
       
    }
}

using OEMS.Models.Model.Employee;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.SMS
{
   public class SendBulkSMSVM
    {       
        public List<EmpBasicInfo> EMPBulkSMS { get; set; }
        public int TemplateId { get; set; }
        public int length { get; set; }
        public int SMSPart { get; set; }
        public string SMSBody { get; set; }
    }
}

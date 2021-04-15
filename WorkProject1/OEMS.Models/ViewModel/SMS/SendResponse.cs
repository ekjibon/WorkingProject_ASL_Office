using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.SMS
{
    public class SendResponse
    {
        public int StatusCode { get; set; }
        public string Message { get; set; }
        public int MsgId { get; set; }
        public string MSISDN { get; set; }

    }
}

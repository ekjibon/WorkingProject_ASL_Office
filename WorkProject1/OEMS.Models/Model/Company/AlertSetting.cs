using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Company
{
    [Table("Common_AlertSetting")]
    [ClassName("Alert Setting")]
    public class AlertSetting: Entity
    {
        [Key]
        public int Id { get; set; }
        public string AlertType { get; set; }
        public string FromAddress { get; set; }
        public string ToAddress { get; set; }
        public string CCAddress { get; set; }
        public string BCCAddress { get; set; }
        public string Subject { get; set; }
        public string DestinationMobileNo { get; set; }
        public string Body { get; set; }
    }
}

using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Client
{
    [Table("CRM_Client")]
    [ClassName("Client")]
    public class Client : Entity
    {
        [Key]
        public int Id { get; set; }
        public string ClientId { get; set; }
        public string FullName { get; set; }
        public string ShortName { get; set; }
        public string Code { get; set; }
        public string Address { get; set; }
        public string BaseUrl { get; set; }
        public string Apps { get; set; }
        public string WebPortal { get; set; }
        public string SMS { get; set; }
        public string Subscription { get; set; }
        public string ActivityStatus { get; set; }
        //New Field Add
        public bool HasAppsService { get; set; }
        public bool HasWebPortal { get; set; }
        public bool HasSMS { get; set; }
        public int? DefaultDbId { get; set; }
        public int? LedgerId { get; set; }
        [NotMapped]
        [JsonIgnore]
        public virtual ICollection<Clients_db> Clients_db { get; set; }
    }
}

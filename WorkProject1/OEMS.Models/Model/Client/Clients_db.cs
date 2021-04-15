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
    [Table("CRM_Clients_db")]
    [ClassName("Clients_db")]
    public class Clients_db : Entity
    {
        [Key]
        public int ClientsDbId { get; set; }
        [ForeignKey("Clients")]
        public int ClientId { get; set; }
        [MaxLength(30)]
        [Required]
        public string Host { get; set; }
        public string DbName { get; set; }
        public string DbUserName { get; set; }
        public string DbPass { get; set; }
        [Required]
        [MaxLength(5)]
        public string Type { get; set; } /// O = Old Projects , N = New Projects
        public bool IsDefault { get; set; }
        [JsonIgnore]
        public Client Clients { get; set; }
    }
}

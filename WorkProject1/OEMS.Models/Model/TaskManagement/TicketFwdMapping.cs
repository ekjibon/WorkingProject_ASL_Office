using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_TicketFwdMapping")]
    [ClassName("Ticket Fwd Mapping")]
    public class TicketFwdMapping
    {
        [Key]
        public int Id { get; set; }
        public int CategoryId { get; set; } // Fk
        public string UserId { get; set; } // Fk
        public string UserName { get; set; }
        public string Status { get; set; }
    }
}
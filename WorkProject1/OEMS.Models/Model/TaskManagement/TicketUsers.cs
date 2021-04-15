using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_TicketUsers")]
    [ClassName("Ticket Users")]
    public class TicketUsers
    {
        [Key]
        public int Id { get; set; }
        public string UserId { get; set; }
        public int TicketId { get; set; }
    }
}
using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace OEMS.Models.Model
{
    [Table("CRM_MeetingPersons")]
    [ClassName("Meeting Persons")]
    public class MeetingPersons
    {
        [Key]
        public int Id { get; set; }
        public int MeetingId { get; set; } // Fk
        public string UserId { get; set; } // Fk
    }
}
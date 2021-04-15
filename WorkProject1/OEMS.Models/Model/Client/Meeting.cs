using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace OEMS.Models.Model
{
    [Table("CRM_Meeting")]
    [ClassName("Meeting")]
    public class Meeting : Entity
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string Title { get; set; }
        [Required]
        public string Topics { get; set; }
        public int? ClientId { get; set; }
        public DateTime MeetingDate { get; set; }
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }
        public string Notes { get; set; }
        [Required]
        public string Location { get; set; }
        public string MeetingPersonName { get; set; }
        public string MeetingPersonMobileNo { get; set; }
        [NotMapped]
        public DateTime StartDateTime { get; set; }
        [NotMapped]
        public DateTime EndDateTime { get; set; }

    }
}
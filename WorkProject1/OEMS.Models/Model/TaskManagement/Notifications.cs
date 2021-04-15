using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_Notifications")]
    [ClassName("Notifications")]
    public class Notifications
    {
        [Key]
        public long Id { get; set; }
        public int CategoryId { get; set; }//reference id like task,ticket id
        public int TypeId { get; set; }//task add=1,ticket add=2,task assign=3, task status change=4, ticket status change=5
        [Required]
        [MaxLength(30)]
        public string Title { get; set; }
        [MaxLength(200)]
        [Required]
        public string Message { get; set; }
        [MaxLength(200)]
        public string DetailsURL { get; set; }
        public string SentTo { get; set; }
        public DateTime AddDate { get; set; }
        public bool IsRead { get; set; }
        public bool IsDeleted { get; set; }
        public bool IsReminder { get; set; }


    }
}
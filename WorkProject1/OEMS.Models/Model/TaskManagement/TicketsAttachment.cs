using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_TicketsAttachment")]
    [ClassName("Tickets Attachment")]
    public class TicketsAttachment
    {
        [Key]
        public int Id { get; set; }
        public int TicketId { get; set; } // Fk
        public string FileName { get; set; } 
        public string FileType { get; set; }
        public int Size { get; set; }
        public string Path { get; set; }
        public byte[] File { get; set; }
        public string ImgUrl { get; set; }

    }
}
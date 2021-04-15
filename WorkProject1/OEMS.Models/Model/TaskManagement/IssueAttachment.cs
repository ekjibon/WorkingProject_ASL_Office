using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.TaskManagement
{
    [Table("Task_IssueAttachment")]
    [ClassName("Issue Attachment")]
    public class IssueAttachment
    {
        [Key]
        public int AttachmentId { get; set; }
        public int  IssueId { get; set; }
        public string FileName { get; set; }
        public string FileType { get; set; }
        public string ImageUrl { get; set; }
    }
}

﻿using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_BugAttachment")]
    [ClassName("Bug Attachment")]
    public class BugAttachment
    {
        [Key]
        public int Id { get; set; }
        public int BugId { get; set; }
        public string Path { get; set; }
    }
}
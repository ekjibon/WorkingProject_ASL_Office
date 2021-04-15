using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace UI.Admin.Models.Task
{
    [Table("Task_TestSite")]
    [ClassName("Test Site")]
    public class TestSite : Entity
    {
        [Key]
        public int Id { get; set; }
        public string SiteName { get; set; }
        public string Description { get; set; }
        public string URL { get; set; }
        public string TestingPerson { get; set; }
    }
}
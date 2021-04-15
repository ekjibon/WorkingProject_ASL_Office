namespace OEMS.Models.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    [ClassName("AspNet Api")]
    public partial class AspNetApi
    {
        [Key]
        public int ApiId { get; set; }
        public string Controller { get; set; }
        public string Action { get; set; }
        public string Route { get; set; }

    }
}

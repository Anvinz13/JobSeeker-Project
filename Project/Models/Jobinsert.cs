using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Project.Models
{
    public class Jobinsert
    {
        [Required(ErrorMessage = "Please enter the skill")]
        public string skill { get; set; }
        [Required(ErrorMessage = "Please enter the experience")]
        public string exp { get; set; }
        public string status { get; set; }
        [Required(ErrorMessage = "Please enter the last date")]
        public string ldate { get; set; }
        [Required(ErrorMessage = "Please enter the location")]
        public string loc { get; set; }
        public int sal { get; set; }
        public string msg { get; set; }


    }
}
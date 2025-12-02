using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Project.Models
{
    public class Employeecls
    {

        [Required(ErrorMessage = "Please enter the Name")]
        public string name { set; get; }
        [Required(ErrorMessage = "Please enter the Address")]
        public string addr { set; get; }
        [Required(ErrorMessage = "Please enter the Phone number")]
        [RegularExpression(@"(\d{10})$", ErrorMessage = "Enter a valid phone number")]
        public string phone { set; get; }
        [Required(ErrorMessage = "Please enter the web address")]
        public string webaddr { set; get; }
        [Required(ErrorMessage = "Please enter the desc")]
        public string desc { set; get; }
        public string username { set; get; }
        public string password { set; get; }
        [Compare("password", ErrorMessage = "password is matching")]
        public string cpassword { set; get; }
        public string compmsg { set; get; }
    }
}
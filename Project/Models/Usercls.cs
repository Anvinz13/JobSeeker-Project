using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Project.Models
{
    public class Usercls
    {
        public List<checkclass> MyQual { get; set; }
        public string[] selectedqual { get; set; }
        [Required(ErrorMessage = "Please enter your name")]
        public string name { set; get; }
        [Range(18, 50, ErrorMessage = "This age is not valid")]
        public int age { set; get; }
        [Required(ErrorMessage = "Please enter the Address")]
        public string address { set; get; }
        [Required(ErrorMessage = "Please enter the Phone number")]
        [RegularExpression(@"^(\d{10})$", ErrorMessage = "Enter a valid phone number")]
        public string phone { set; get; }
        [EmailAddress(ErrorMessage = "Enter a valid Email Id")]
        public string email { set; get; }
        public string gender { set; get; }
        public string qualification { set; get; }
        [Required(ErrorMessage = "Please enter your experience")]
        public string exp { set; get; }
        [Required(ErrorMessage = "Please enter your skills")]
        public string skill { set; get; }
        public string username { set; get; }
        public string password { set; get; }
        [Compare("password", ErrorMessage = "password is mismatching")]
        public string cpassword { set; get; }
        public string usermsg { set; get; }

    }
    public class checkclass
    {
        public string Value { get; set; }
        public string Text { get; set; }
        public bool IsChecked { get; set; }
    }
  
}
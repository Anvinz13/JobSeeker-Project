using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Project.Models
{
    public class applicationmodel
    {
        public int comp_id { get; set; }
        public int user_id { set; get; }
        public int Job_id { set; get; }
        public string Resume { set; get; }
        public string App_Date { set; get; }
        public string status { set; get; }
        public string msg { set; get; }
    }
}
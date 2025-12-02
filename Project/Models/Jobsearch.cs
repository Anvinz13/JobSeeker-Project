using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


namespace Project.Models
{
    public class Jobsearch
    {
        public Jobsearch()
        {
            selectjob = new List<jobList>();
            interse = new jobList();
        }
        public jobList interse { set; get; }
        public List<jobList> selectjob { set; get; }


    }

    public class jobList
    {
        public int Job_id { set; get; }
        public int Company_id { set; get; }
        public string skill { set; get; }
        public string exp { set; get; }
        public string job_status { set; get; }
        public string date { set; get; }
        public string location { set; get; }
        public int salary { set; get; }
    }
}

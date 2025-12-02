using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Project.Models;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;


namespace Project.Controllers
{
    public class JobsearchController : Controller
    {
        SaaaEntities obj = new SaaaEntities();
        // GET: Jobsearch
        public ActionResult jobview_load()
        {
            return View(getjoblist());
        }
        private Jobsearch getjoblist()
        {
            var joblists = new Jobsearch();
            var jobs = obj.sp_jobpost().ToList();


            foreach (var j in jobs)
            {

                var jobobj = new jobList
                {

                    Job_id = j.Job_id,
                    Company_id = j.Company_id,
                    skill = j.Skills,
                    exp = j.Experience,
                    job_status = j.Job_status,
                    date = j.Last_date,
                    location = j.Location,
                    salary = Convert.ToInt32(j.Job_salary)
                };



                joblists.selectjob.Add(jobobj);
            }


            return joblists;

        }
        [HttpPost]
        public ActionResult jobsearch_click(Jobsearch clsobj)
        {
            string qry = "";

            if (!string.IsNullOrWhiteSpace(clsobj.interse.exp))
                qry += " AND Experience LIKE '%" + clsobj.interse.exp + "%'";

            if (!string.IsNullOrWhiteSpace(clsobj.interse.skill))
                qry += " AND Skills LIKE '%" + clsobj.interse.skill + "%'";

            if (!string.IsNullOrWhiteSpace(clsobj.interse.location))
                qry += " AND Location LIKE '%" + clsobj.interse.location + "%'";

            return View("jobview_load", GetFilteredJobs(qry));
        }
        private Jobsearch GetFilteredJobs(string qry)
        {
            var joblist = new Jobsearch();

            using (var con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["importantdataconnection"].ToString()))
            {
                SqlCommand cmd = new SqlCommand("sp_search", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@qry", qry);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    var jobcls = new jobList
                    {
                        Job_id = Convert.ToInt32(dr["job_id"]),
                        Company_id = Convert.ToInt32(dr["company_id"]),
                        skill = dr["skills"].ToString(),
                        exp = dr["experience"].ToString(),
                        job_status = dr["job_status"].ToString(),
                        date = dr["Last_date"].ToString(),
                        location = dr["location"].ToString(),
                        salary = Convert.ToInt32(dr["job_salary"])
                    };

                    joblist.selectjob.Add(jobcls);
                }

                con.Close();
            }

            return joblist;
        }

    }
}
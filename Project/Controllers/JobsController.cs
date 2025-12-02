using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Project.Models;

namespace Project.Controllers
{
    public class JobsController : Controller
    {
        SaaaEntities obj = new SaaaEntities();
        // GET: Jobs
        public ActionResult Job_load()
        {
            return View();
        }

        public ActionResult Job_click(Jobcls clsobj)
        {

            if (ModelState.IsValid)
            {
                int jid = Convert.ToInt32(Session["id"]);
                obj.sp_job(jid, clsobj.skill, clsobj.exp, clsobj.status, clsobj.ldate, clsobj.loc, clsobj.sal);
                clsobj.msg = "Successfully Registered";
                return View("Job_load", clsobj);

            }
            return View("Job_load", clsobj);
        }
    }
}
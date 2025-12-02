using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Project.Models;

namespace Project.Controllers
{
    public class AppsController : Controller
    {
        SaaaEntities obj = new SaaaEntities();
        // GET: Apps
        public ActionResult app_load(int jid,int cid)
        {
            TempData["cid"] = cid;
            Session["jid"] = jid;
            TempData["Jid"] = jid;
            int userid = Convert.ToInt32(Session["id"]);
            int jobid = Convert.ToInt32(Session["jid"]);
            var i = obj.sp_countofappid(userid, jobid).FirstOrDefault();

            if (i == 1)
            {
                TempData["msg"] = "already applied";
                return RedirectToAction("jobview_load", "Jobsearch");
            }
            return View();

        }
        public ActionResult app_click(HttpPostedFileBase file, applicationmodel clsobj)
        {
            if (ModelState.IsValid)
            {
                if (file.ContentLength > 0)
                {
                    string fname = Path.GetFileName(file.FileName);
                    var s = Server.MapPath("~/resume");
                    string pa = Path.Combine(s, fname);
                    file.SaveAs(pa);//save 
                    var fullpath = Path.Combine("~/resume", fname);
                    clsobj.Resume = fullpath;
                }

                DateTime cdate = DateTime.Today;
                string App_date = Convert.ToString(cdate);
                clsobj.App_Date = App_date;
                clsobj.user_id = Convert.ToInt32(Session["id"]);
                clsobj.comp_id = Convert.ToInt32(TempData["cid"]);
                clsobj.Job_id = Convert.ToInt32(Session["jid"]);
                obj.sp_applicationposting(clsobj.comp_id, clsobj.user_id, clsobj.Job_id, clsobj.Resume, clsobj.App_Date, "apply");
                // Return the same view with the job details
                return RedirectToAction("jobview_load", "Jobsearch");
            }
            return View("app_load", clsobj);
        }
    }
}
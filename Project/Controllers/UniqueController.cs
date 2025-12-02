using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Project.Models;

namespace Project.Controllers
{
    public class UniqueController : Controller
    {
        // GET: Unique
        SaaaEntities obj = new SaaaEntities();

        public ActionResult company_load()
        {

            return View();
        }
        public ActionResult company_click(Employeecls clsobj)
        {
            if (ModelState.IsValid)
            {
                var getmaxid = obj.sp_maximum().FirstOrDefault();
                int mid = Convert.ToInt32(getmaxid);
                int regid = 0;
                if (mid == 0)
                {
                    regid = 1;
                }
                else
                {
                    regid = mid + 1;
                }
                obj.sp_company(regid, clsobj.name, clsobj.addr, clsobj.phone, clsobj.webaddr, clsobj.desc);
                obj.sp_insertlogin(regid, clsobj.username, clsobj.password, "company");
                clsobj.compmsg = "Successfully registered";
                return View("company_load", clsobj);

            }
            return View("company_load", clsobj);
        }
    }
}
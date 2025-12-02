using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Project.Models;

namespace Project.Controllers
{
    public class loginController : Controller
    {
        SaaaEntities obj = new SaaaEntities();
        // GET: login
        public ActionResult Login_load()
        {
            return View();
        }
        public ActionResult Userhome()
        {
            return View();
        }

        public ActionResult Adminhome()
        {
            return View();
        }
        public ActionResult Login_click(loginmodel clsobj)
        {
            if (ModelState.IsValid)
            {
                var val = obj.sp_login(clsobj.username, clsobj.pass).FirstOrDefault();
                if (val == 1)
                {
                    var uid = obj.sp_regid(clsobj.username, clsobj.pass).FirstOrDefault();
                    var lt = obj.sp_logintype(clsobj.username, clsobj.pass).FirstOrDefault();
                    Session["id"] = uid;
                    if (lt == "employee")
                    {
                        return RedirectToAction("Userhome");
                    }
                    else if (lt == "company")
                    {
                        return RedirectToAction("Adminhome");
                    }
                }
                else
                {
                    ModelState.Clear();
                    clsobj.logmsg = "invalid";
                    return View("Login_load", clsobj);
                }
            }
            else
            {

                ModelState.Clear();
                clsobj.logmsg = "invalid";
                return View("Login_load", clsobj);
            }
            return View("Login_load", clsobj);

        }
    }  
}

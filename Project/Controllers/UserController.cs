using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Project.Models;

namespace Project.Controllers
{
    public class UserController : Controller
    {
        SaaaEntities obj = new SaaaEntities();
        // GET: User
        public ActionResult user_load()
        {
            Usercls objcls = new Usercls();
            objcls.MyQual = qualification();

            return View(objcls);
        }
        public List<checkclass> qualification()
        {
            List<checkclass> sts = new List<checkclass>()
            {
             new checkclass {Value="SSLC",Text="SSLC",IsChecked=true},
             new checkclass {Value="PLUSTWO",Text="PLUSTWO",IsChecked=false},
             new checkclass {Value="BTECH",Text="BTECH",IsChecked=false},
             new checkclass {Value="MTECH",Text="MTECH",IsChecked=false},
             new checkclass {Value="MBA",Text="MBA",IsChecked=false},
             new checkclass {Value="DIPLOMA",Text="DIPLOMA",IsChecked=false},
             new checkclass {Value="BCA",Text="BCA",IsChecked=false},
             new checkclass {Value="MCA",Text="MCA",IsChecked=false},

            };
            return sts;
        }
        public ActionResult user_click(Usercls clsobj, FormCollection form)
        {
            if (ModelState.IsValid)
            {
                var quid = string.Join(",", clsobj.selectedqual);
                clsobj.qualification = quid;
                clsobj.MyQual = qualification();

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
                obj.sp_employ(regid, clsobj.name, clsobj.age, clsobj.address, clsobj.phone, clsobj.email, clsobj.gender, clsobj.qualification, clsobj.exp, clsobj.skill);
                obj.sp_insertlogin(regid, clsobj.username, clsobj.password, "employee");
                clsobj.usermsg = "Successfully Registered";
                return View("user_load", clsobj);

            }
            else
            {
                clsobj.MyQual = qualification();

            }
            return View("user_load", clsobj);
        }

    }
}
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz.bike_rentals.Areas.CMS.Controllers
{
    [Authorize]
    [Area("CMS")]
    public class HomeController : Controller
    {

        #region " Init "

        private readonly IConnectionService MyServer;
        private readonly IViewRenderService InjView;
        private readonly ICurrentUserService InjUser;

        public HomeController(IConnectionService _SrsServer, IViewRenderService _SrsView, ICurrentUserService _SrsUser)
        {
            MyServer = _SrsServer;
            InjView = _SrsView;
            InjUser = _SrsUser;
        }

        #endregion

        #region " Index"

        public IActionResult Index()
        {
            var Model = new Pages();
            var CurUser = InjUser.GetInfo();
            switch (CurUser.Role.ToUpper())
            {
                case "CUSTOMER":     return View("_Customer", Model);
                case "OWNER":     return View("_Owner", Model);
                case "DEVELOPER":     return View("_Admin", Model);
                default:    return View("_Guest", Model);
            }
        }

        #endregion

        #region " Page Not Found "

        [Route("cms/pnf/err404")]
        public IActionResult PageNotFound()
        {
            return View("_NotFound");
        }

        #endregion

    }
}
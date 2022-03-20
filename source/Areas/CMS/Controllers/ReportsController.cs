using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz.bike_rentals.Areas.CMS.Controllers
{

    [Authorize]
    [Area("CMS")]
    public class ReportsController : Controller
    {

        #region " Init "

        private readonly IConnectionService MyServer;
        private readonly IViewRenderService InjView;
        private readonly ICurrentUserService InjUser;

        public ReportsController(IConnectionService _SrsServer, IViewRenderService _SrsView, ICurrentUserService _SrsUser)
        {
            MyServer = _SrsServer;
            InjView = _SrsView;
            InjUser = _SrsUser;
        }

        #endregion

        #region " Transactions "

        public IActionResult Transactions()
        {
            var Model = new Pages();
            return View(Model);
        }

        #endregion

        #region " Sales "

        public IActionResult Sales()
        {
            var Get = new Fetch(MyServer);
            var Model = new Pages
            {
                Sales = Get.GetRentalSales()
            };
            return View(Model);
        }

        #endregion

        #region " GPS "

        public IActionResult GPS()
        {
            var Model = new Pages();
            return View(Model);
        }

        #endregion

    }
}
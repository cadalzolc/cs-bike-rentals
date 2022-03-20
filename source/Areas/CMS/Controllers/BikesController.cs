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
    public class BikesController : Controller
    {

        #region " Init "

        private readonly IConnectionService MyServer;
        private readonly IViewRenderService InjView;
        private readonly ICurrentUserService InjUser;

        public BikesController(IConnectionService _SrsServer, IViewRenderService _SrsView, ICurrentUserService _SrsUser)
        {
            MyServer = _SrsServer;
            InjView = _SrsView;
            InjUser = _SrsUser;
        }

        #endregion

        public IActionResult Index()
        {
            var Get = new Fetch(MyServer);
            var Model = new Pages();
            Model.List_Bikes = Get.GetBikes(100);
            return View(Model);
        }

    }
}
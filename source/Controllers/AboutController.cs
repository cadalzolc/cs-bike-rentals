using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz.bike_rentals.Controllers
{
    public class AboutController : Controller
    {

        #region " Init "

        private readonly IConnectionService MyServer;

        public AboutController(IConnectionService _MyServer)
        {
            MyServer = _MyServer;
        }

        #endregion

        #region " Index"

        public IActionResult Index()
        {
            var Model = new Pages();
            return View(Model);
        }

        #endregion

    }
}

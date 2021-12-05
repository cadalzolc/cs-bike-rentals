using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz.keto.Controllers
{
    public class HomeController : Controller
    {

        #region " Init "

        private readonly IConnectionService MyServer;

        public HomeController(IConnectionService _MyServer)
        {
            MyServer = _MyServer;
        }

        #endregion

        #region " Index"

        public IActionResult Index()
        {
            var Svr = new Fetch(MyServer);
            var Model = new Pages
            {
                List_Bikes = Svr.GetBikes(3)
            };
            return View(Model);
        }

        #endregion

        #region " Error "

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new Error { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        #endregion

        #region " Page Not Found "

        [Route("/pnf/err404")]
        public IActionResult PageNotFound()
        {
            return View("_NotFound");
        }

        #endregion


    }
}
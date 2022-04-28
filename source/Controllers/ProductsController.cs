using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz.bike_rentals.Controllers
{
    public class ProductsController : Controller
    {

        #region " Init "

        private readonly IConnectionService MyServer;

        public ProductsController(IConnectionService _MyServer)
        {
            MyServer = _MyServer;
        }

        #endregion

        #region " Info "

        public IActionResult Info(string d)
        {
            var ID = d.ToDecode().ToInt();

            if (ID.Equals(0)) return NotFound();

            var Fch = new Fetch(MyServer);
            var Model = Fch.GetBikesInfoRental(ID);

            return View("Info", Model);
        }

        #endregion

        #region  " Rentals "

        [HttpPost]
        public IActionResult Rentals(Rental Model)
        {
            var Crd = new Crud(MyServer);
            var Result = Crd.Rantals_Submit(Model);

            return View("_Rentals", Result);
        }

        #endregion

        #region " Search "

        [HttpPost]
        public IActionResult Search(string keywords, string keyrefs)
        {
            var Svr = new Fetch(MyServer);
            var Model = new Pages
            {
                KeyWord1 = keywords.ToNullString(),
                KeyWord2 = keyrefs.ToNullString(),
                List_Bikes = Svr.GetBikes(keywords.ToNullString().Replace("'", "''"), keyrefs.ToInt())
            };
            return View(Model);
        }

        #endregion

    }
}
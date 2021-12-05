﻿using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz.bike_rentals.Areas.CMS.Controllers
{

    [Authorize]
    [Area("CMS")]
    public class RentalsController : Controller
    {

        #region " Init "

        private readonly IConnectionService MyServer;
        private readonly IViewRenderService InjView;
        private readonly ICurrentUserService InjUser;

        public RentalsController(IConnectionService _SrsServer, IViewRenderService _SrsView, ICurrentUserService _SrsUser)
        {
            MyServer = _SrsServer;
            InjView = _SrsView;
            InjUser = _SrsUser;
        }

        #endregion

        #region " Reservation "

        public IActionResult Reservation()
        {
            var Fch = new Fetch(MyServer);
            var Model = new Pages
            {
                List_Rentals = Fch.GetRentalsByStatus("P")
            };
            return View(Model);
        }

        #endregion

        #region " Leased "

        public IActionResult Leased()
        {
            var Fch = new Fetch(MyServer);
            var Model = new Pages
            {
                List_Rentals = Fch.GetRentalsByStatus("L")
            };
            return View(Model);
        }

        #endregion

        #region " History "

        public IActionResult History()
        {
            var Fch = new Fetch(MyServer);
            var Model = new Pages
            {
                List_Rentals = Fch.GetRentalsByStatus("H")
            };
            return View(Model);
        }

        #endregion

        #region " Rejected "

        public IActionResult Rejected()
        {
            var Fch = new Fetch(MyServer);
            var Model = new Pages
            {
                List_Rentals = Fch.GetRentalsByStatus("X")
            };
            return View(Model);
        }

        #endregion

        #region " Review "

        public IActionResult Review(string Key)
        {
            var ID = Key.ToNullString().ToDecode().ToInt();

            if (ID.Equals(0)) return NotFound();

            var Fch = new Fetch(MyServer);
            var Model = Fch.GetRentalInfo(ID);

            return View("_Review", Model);
        }

        #endregion

        #region " Push To Lease "

        public JsonResult PushToLease(string Key)
        {

            if (Key.ToNullString().Equals("")) return Json(new Data_Response("No reference was found"));

            var Dkv = Key.ToDecode().Split('|');

            var VwName = Dkv[0].Equals("A") ? "_Accept" : "_Denied";
            var Fcj = new Fetch(MyServer);
            var Model = Fcj.GetRentalInfo(Dkv[1].ToInt());

            Model.Collections = Fcj.GetCollection(Dkv[2].ToInt());

            var html = Task.Run(async () => { return await InjView.RenderToString(VwName, Model); }).Result;
            var Results = new WebResult
            {
                Success = true,
                Message = "Load",
                Result = html
            };

            return Json(Results);
        }

        #endregion

        #region " Confirm Lease "

        [HttpPost]
        public IActionResult ConfirmLease(Rental Model)
        {
            var Usr = InjUser.GetInfo();
            var Crd = new Crud(MyServer);
            var Results = Crd.Rentals_Accept(Model.Rental_ID, Model.Collection_ID, Usr.ID.ToInt());

            if (Results.Success.Equals(true))
            {
                return RedirectToAction("reservation", "rentals", new { Area = "cms" });
            }

            return BadRequest(Results.Message);
        }

        #endregion

        #region " Denied "

        [HttpPost]
        public IActionResult DeniedLease(Rental Model)
        {
            var Usr = InjUser.GetInfo();
            var Crd = new Crud(MyServer);
            var Results = Crd.Rentals_Denied(Model.Rental_ID, Usr.ID.ToInt());

            if (Results.Success.Equals(true))
            {
                return RedirectToAction("reservation", "rentals", new { Area = "cms" });
            }

            return BadRequest(Results.Message);
        }

        #endregion

    }
}
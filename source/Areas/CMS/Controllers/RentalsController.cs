using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
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

        #region " Track "

        public IActionResult Track()
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

        #region " Maps "

        public IActionResult Maps(string Key)
        {

            try
            {
                if (Key.ToNullString().Equals("")) return Json(new Data_Response("No reference was found"));

                var ID = Key.ToDecode().ToInt();
                var Fcj = new Fetch(MyServer);
                var Model = Fcj.GetRentalInfo(ID);
                var Lst = Fcj.GetRentalsCollections(Model.Rental_ID);

                if (!Lst.Count().Equals(0))
                {
                    Model.GPS_Info = Lst.SingleOrDefault();

                    KnowLocation(Model.GPS_Info.Mobile_GPS);

                    //Wait for 30 seconds
                    System.Threading.Thread.Sleep(15000);

                    var RCL = new RestClient(string.Format("https://gsm.niftyappmakers.com/globe/logs?Mobile={0}", Model.GPS_Info.Mobile_GPS));
                    var RQT = new RestRequest(Method.GET);
                    var RES = RCL.Execute(RQT);

                    if (RES.IsSuccessful == true)
                    {

                        var PDL = JsonSerializer.Deserialize<GPS_Response>(RES.Content);
                        var BDY = PDL.body.Split(' ');

                        Model.GPS_Info.Map_URL = BDY[4];

                        return new RedirectResult(Model.GPS_Info.Map_URL);
                    }
                }
                return NotFound();
            }
            catch
            {
                return NotFound();
            }
        }

        //Send SMS 777 (Know Bike Location)
        void KnowLocation(string MobileNo)
        {
            try
            {
                var MDL = new GPS_Data
                {
                    provider = "GLOBE",
                    token = "xnYFNviSUwuhhpchTuQfxvErawmjhdM1Rdqq90YVnzI",
                    sender = "21660843",
                    to = MobileNo,
                    body = "777"
                };
                var RCL = new RestClient("https://gsm.niftyappmakers.com/globe/outbound");
                var RQT = new RestRequest(Method.POST);

                RQT.AddJsonBody(JsonSerializer.Serialize(MDL));
                RCL.Execute(RQT);
            }
            catch {}
        }

        #endregion

        #region " Return "

        public JsonResult Return(string Key)
        {

            if (Key.ToNullString().Equals("")) return Json(new Data_Response("No reference was found"));

            var ID = Key.ToDecode().ToInt();
            var Fcj = new Fetch(MyServer);
            var Model = Fcj.GetRentalCalculateInfo(ID);


            var html = Task.Run(async () => { return await InjView.RenderToString("_Return", Model); }).Result;
            var Results = new WebResult
            {
                Success = true,
                Message = "Load",
                Result = html
            };

            return Json(Results);
        }

        [HttpPost]
        public IActionResult Return(Rental_Sales Model)
        {
            var Usr = InjUser.GetInfo();
            var Crd = new Crud(MyServer);

            Model.Stamper_ID = Usr.ID.ToInt();

            var Results = Crd.Sales_Save(Model);

            if (Results.Success.Equals(true))
            {
                return RedirectToAction("track", "rentals", new { Area = "cms" });
            }

            return BadRequest(Results.Message);
        }

        #endregion

    }
}
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

        #region " Monthly - Sales "
        public JsonResult MonthlySales()
        {
            var Get = new Fetch(MyServer);
            var Model = new Pages();
            var Rpt = new SalesReport();
            var SalesInfo= Get.GetRentalSalesSummary(DateTime.Now.Year, DateTime.Now.Month).ToList();

            Model.SalesSummary = Rpt.CalculateMonthlySales(SalesInfo, DateTime.Now.Year, DateTime.Now.Month).AsEnumerable();
            Model.KeyWord1 = DateTime.Now.Month.ToString();
            Model.KeyWord2 = DateTime.Now.Year.ToString();

            var html = Task.Run(async () => { return await InjView.RenderToString("_Monthly", Model); }).Result;
            var RSP = new WebResult
            {
                Success = true,
                Message = "Load",
                Result = html
            };
            return Json(RSP.Result);
        }

        [HttpPost]
        public JsonResult MonthlySales(string Keyword1, string Keyword2)
        {
            var Get = new Fetch(MyServer);
            var Model = new Pages();
            var Rpt = new SalesReport();
            var SalesInfo = Get.GetRentalSalesSummary(Keyword2.ToInt(), Keyword1.ToInt()).ToList();

            Model.SalesSummary = Rpt.CalculateMonthlySales(SalesInfo, Keyword2.ToInt(), Keyword1.ToInt()).AsEnumerable();

            var html = Task.Run(async () => { return await InjView.RenderToString("_MonthlyCalculation", Model); }).Result;
            var RSP = new WebResult
            {
                Success = true,
                Message = "Load",
                Result = html
            };
            return Json(RSP.Result);
        }

        #endregion

    }
}
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Routing;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Security.Claims;
using System.Threading.Tasks;

namespace web.urapz.bike_rentals.Areas.CMS.Controllers
{
    [Area("CMS")]
    public class AccountController : Controller
    {

        #region " Init "

        private readonly ICurrentUserService CurrUser;
        private readonly IConnectionService MyServer;
        private readonly IViewRenderService ViewRender;

        public AccountController(ICurrentUserService _CurrUser, IConnectionService _MyServer, IViewRenderService _ViewRender)
        {
            CurrUser = _CurrUser;
            MyServer = _MyServer;
            ViewRender = _ViewRender;
        }

        #endregion

        #region " Login "

        public IActionResult Login(string ReturnUrl)
        {

            var User = CurrUser.GetInfo();

            if (User.ID != "") return RedirectToAction("index", "home", new { Area = "cms" });

            var NewUrl = Url.Action(new UrlActionContext
            {
                Protocol = Request.Scheme,
                Host = Request.Host.Value,
                Controller = "home",
                Action = "index",
                Values = new { Area = "cms" }
            });
            var Model = new User_Account
            {
                ReturnURL = (ReturnUrl == "" ? NewUrl : ReturnUrl)
            };
            return View(Model);
        }

        [HttpPost]
        public JsonResult Login(User_Account Model)
        {

            if (Model.Username.ToNullString().Equals("")) return Json(new WebResult(false, "Please provide username"));
            if (Model.Password.ToNullString().Equals("")) return Json(new WebResult(false, "Please provide password"));

            var Exec = new Crud(MyServer);
            var Results = Exec.Login(Model);

            if (Results.Success.Equals(false)) return Json(new WebResult(false, Results.Message));
           
            var UserInfo = Results.Result as User_Account;

            RefreshUserClaims(UserInfo);

            return Json(new WebResult(true, "Successful Login"));
        }

        #endregion

        #region " Logout "

        [Authorize]
        [HttpPost]
        public IActionResult Logout()
        {
            HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Index", "Home", new { Area = "CMS" });
        }

        #endregion

        #region " Change Password "

        [Authorize]
        public JsonResult PasswordChange()
        {
            var Model = new User_Account();
            var html = Task.Run(async () => { return await ViewRender.RenderToString("_PasswordChange", Model); }).Result;
            var Results = new WebResult
            {
                Success = true,
                Message = "Load",
                Result = html
            };
            return Json(Results);
        }

        [Authorize]
        [HttpPost]
        public JsonResult PasswordChange(User_Account Model)
        {
            var User = CurrUser.GetInfo();

            if (!Model.Password_Old.Equals(User.Password_Original)) return Json(new WebResult(false, "Invalid current password!"));
            if (Model.Password_New.ToNullString().Equals("")) return Json(new WebResult(false, "No new password provided!"));
            if (Model.Password_Confirm.ToNullString().Equals("")) return Json(new WebResult(false, "No confirm password provided!"));
            if (Model.Password_New.Length <= 7) return Json(new WebResult(false, "Password length should be greater than 7 characters!"));
            if (Model.Password_Confirm.Length <= 7) return Json(new WebResult(false, "Password length should be greater than 7 characters!"));

            if (!Model.Password_New.Equals(Model.Password_Confirm)) return Json(new WebResult(false, "Your password does not match!"));

            var UModel = new User_Account
            {
                ID = User.ID,
                Name = User.Name,
                Email = User.Username,
                Photo = User.Photo,
                Role = User.Role,
                Password = Model.Password_New
            };
            var Svr = new Crud(MyServer);
            var Results = Svr.PasswordChange(UModel);

            if (Results.Success.Equals(true))
            {
                var NewModel = Results.Result as User_Account;
                HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
                RefreshUserClaims(NewModel);
            }

            return Json(Results);
        }

        #endregion

        #region " Claims "

        public void RefreshUserClaims(User_Account Model)
        {
            var Claims = new List<Claim>()
            {
                new Claim(ClaimTypes.Name, Model.Name),
                new Claim(ClaimTypes.Email, Model.Username),
                new Claim(ClaimTypes.Surname, Model.Password),
                new Claim(ClaimTypes.Sid, Model.ID),
                new Claim(ClaimTypes.Role, Model.Role),
                new Claim(ClaimTypes.OtherPhone, Model.Photo)
            };
            var UserIdetity = new ClaimsIdentity(Claims, "Login");

            HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(UserIdetity));
        }

        #endregion

    }
}

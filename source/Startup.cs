using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.Extensions.Hosting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace web.urapz.bike_rentals
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }


        public void ConfigureServices(IServiceCollection services)
        {

            var _AppConfig = Configuration.GetSection("Config").Get<AppConfig>();

            services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
            .AddCookie(ck =>
            {
                ck.Cookie.IsEssential = true;
                ck.Cookie.SecurePolicy = CookieSecurePolicy.SameAsRequest;
                ck.Cookie.Name = _AppConfig.Cookie;
                ck.LoginPath = "/cms/account/login";
            });

            services.Configure<CookiePolicyOptions>(options =>
            {
                options.ConsentCookie.IsEssential = true;
                options.CheckConsentNeeded = context => false;
                options.MinimumSameSitePolicy = SameSiteMode.Strict;
            });


            services.AddHttpContextAccessor();

            var mvcBuilder = services.AddControllersWithViews();

#if DEBUG
            mvcBuilder.AddRazorRuntimeCompilation();
#endif

            services.AddMvc(options => options.EnableEndpointRouting = false);

            services.TryAddSingleton<IHttpContextAccessor, HttpContextAccessor>();
            services.AddScoped<ICurrentUserService, CurrentUserService>();
            services.AddScoped<IViewRenderService, ViewRenderService>();
            services.AddSingleton<IAppConfig>(Configuration.GetSection("Config").Get<AppConfig>());
            services.AddTransient<IEmailService, EmailService>();
            services.AddTransient<IConnectionService, ConnectionService>();
            services.AddTransient<ISettingService, SettingService>();
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");

                app.UseHsts();
            }

            app.UseStatusCodePagesWithReExecute("/Home/HandleError/{0}");
            app.UseHttpsRedirection();

            app.UseStaticFiles();

            app.Use(async (context, next) =>
            {
                await next();
                if (context.Response.StatusCode == 404)
                {
                    var IsCms = context.Request.Path.Value.Contains("cms");
                    context.Request.Path = IsCms.Equals(true) ? "/cms/pnf/err404" : "/pnf/err404";
                    await next();
                }
            });

            app.UseRouting();

            app.UseCookiePolicy();

            app.UseCookiePolicy();
            app.UseAuthentication();
            app.UseAuthorization();

            app.UseCors();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapAreaControllerRoute(
                    name: "cms",
                    areaName: "cms",
                    pattern: "cms/{controller=Home}/{action=Index}/{id?}");

                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller=Home}/{action=Index}/{id?}");
            });
        }
    }
}
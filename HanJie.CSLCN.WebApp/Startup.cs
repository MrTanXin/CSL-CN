using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SpaServices.AngularCli;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using HanJie.CSLCN.Models;
using Microsoft.EntityFrameworkCore;
using HanJie.CSLCN.Datas;
using HanJie.CSLCN.Models.Common;
using HanJie.CSLCN.Models.DataModels;
using System;
using System.Linq;
using HanJie.CSLCN.Services;
using HanJie.CSLCN.Common;
using Microsoft.AspNetCore.HttpOverrides;

namespace HanJie.CSLCN.WebApp
{
    public class Startup
    {
        public IConfiguration Configuration { get; }

        public Startup(IConfiguration configuration)
        {
            this.Configuration = configuration;
            Globalinitialize();
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2);

            // In production, the Angular files will be served from this directory
            //services.AddSpaStaticFiles(configuration =>
            //{
            //    configuration.RootPath = "ClientApp/dist";
            //});

            //https://stackoverflow.com/questions/38238043/how-and-where-to-call-database-ensurecreated-and-database-migrate
            //CSLDbContext.Instance.Database.EnsureCreated();
            //CSLDbContext.Instance.Database.Migrate();

            //�����ݿ������Ķ������DI����
            Console.WriteLine($"ConnStr:{GlobalConfigs.AppSettings.ConnectionString}");
            services.AddDbContext<CSLDbContext>
                (options => options.UseMySql(GlobalConfigs.AppSettings.ConnectionString));  //b => b.MigrationsAssembly("HanJie.CSLCN.WebApp"))

            //ע�ᵥ������
            this.RegisterSingletons(ref services);
            //ע�����������
            this.RegisterScoped(ref services);

            //�ṩ �����ṩ ����
            GlobalService.ServiceProvider = services.BuildServiceProvider();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Error");
            }

            app.UseFileServer();

            app.UseForwardedHeaders(new ForwardedHeadersOptions
            {
                ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto
            });

            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller}/{action=Index}/{id?}");
            });

            //app.UseSpa(spa =>
            //{
            //    // To learn more about options for serving an Angular SPA from ASP.NET Core,
            //    // see https://go.microsoft.com/fwlink/?linkid=864501

            //    spa.Options.SourcePath = "ClientApp";

            //    if (env.IsDevelopment())
            //    {
            //        spa.UseAngularCliServer(npmScript: "start");
            //    }
            //});

        }

        /// <summary>
        /// �� Startup ���캯�������ȫ����Ҫ�ĳ�ʼ��������
        /// </summary>
        private void Globalinitialize()
        {
            //�� AppSettings.json �����ļ��е�ֵ�󶨵�ǿ����ģ��
            GlobalConfigs.AppSettings = this.Configuration.GetSection("AppSettings").Get<AppSettings>();
        }

        /// <summary>
        /// ע�ᵥ������
        /// 
        /// ��ע��
        ///     ����ȫ��ȫ���Ա�ͷ��ʹ���������һ�Σ��κε��ýԷ���ͬһ������������Ϊ�������������������
        /// </summary>
        /// <param name="services"></param>
        private void RegisterSingletons(ref IServiceCollection services)
        {
            services.AddSingleton<MenuService>();
            services.AddSingleton<UserInfoService>();
            services.AddSingleton<UserStatuService>();
            services.AddSingleton<DonatorRankService>();
        }

        /// <summary>
        /// ע��������(scope)����
        /// 
        /// ��ע��
        ///     ������ÿ�������ڼ䴴��һ�Ρ�
        /// </summary>
        /// <param name="services"></param>
        private void RegisterScoped(ref IServiceCollection services)
        {
            services.AddScoped<WikiPassageService>();
        }
    }
}

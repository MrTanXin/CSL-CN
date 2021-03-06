﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HanJie.CSLCN.Common;
using HanJie.CSLCN.Models.Dtos;
using HanJie.CSLCN.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;

namespace HanJie.CSLCN.WebApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DownloadController : BaseController
    {
        private QiniuService _qiniuService;
        private StorageService _storageService;

        public DownloadController(QiniuService qiniuService,
            UserStatuService userStatuService,
            StorageService storageService) : base(userStatuService)
        {
            this._qiniuService = qiniuService;
            this._storageService = storageService;
        }

        [HttpGet()]
        [Route("/api/download")]
        public IActionResult LocalStorage(string fname)
        {
            FileStream fs = new FileStream(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "wwwroot", fname.Substring(1)), FileMode.Open);
            string contentType = string.Empty;
            bool isSuccess = new FileExtensionContentTypeProvider().TryGetContentType(fname, out contentType);

            if (!isSuccess)
                contentType = "*";

            return File(fs, contentType);
        }
    }
}
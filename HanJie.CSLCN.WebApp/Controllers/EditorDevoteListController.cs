﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HanJie.CSLCN.Models.DataModels;
using HanJie.CSLCN.Models.Dtos;
using HanJie.CSLCN.Services;
using Microsoft.AspNetCore.Mvc;

namespace HanJie.CSLCN.WebApp.Controllers
{
    [Route("api/[controller]")]
    public class EditorDevoteListController : Controller
    {
        private readonly UserInfoService _userInfoService;
        private readonly WikiPassageService _wikiPassageService;

        public EditorDevoteListController(UserInfoService userInfoService,
            WikiPassageService wikiPassageService)
        {
            _userInfoService = userInfoService;
            _wikiPassageService = wikiPassageService;
        }

        [HttpGet]
        public async Task<IActionResult> List()
        {
            List<EditorDevoteInfoDto> results = null;

            List<UserInfoDto> editors = await this._userInfoService.ListAllEditorsDto();
            foreach (UserInfoDto item in editors)
            {
                EditorDevoteInfoDto editorDevoteInfo = new EditorDevoteInfoDto();
                editorDevoteInfo.UserInfo = item;
                editorDevoteInfo.MainAuthPassages = await this._wikiPassageService.ListAsMainAuthorPassageDtoes(item.Id);
                editorDevoteInfo.CooAuthPassages = await this._wikiPassageService.ListAsCooperatePassageDtoes(item.Id);
            }

            return Json(results);
        }
    }

}
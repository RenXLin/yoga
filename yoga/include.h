//
//  include.h
//  yoga
//
//  Created by renxlin on 14-7-11.
//  Copyright (c) 2014年 任小林. All rights reserved.
//


//登录：
#define LOGIN_url  @"http://www.chinayogaonline.com/api/login"
//参数 username password

//注册：
#define REGIST_URL  @"http://www.chinayogaonline.com/api/reg"
//参数 mobile $email $password $code(短信验证码)

//查用户信息：
#define GETUSERINFO_Url  @"http://www.chinayogaonline.com/api/getUserInfo"
//参数 token(登录时获取)

//发送验证码：
#define SENDVERTIFY_URL    @"http://www.chinayogaonline.com/api/sendCode"
//参数：mobile（手机号）

//当前正要播放的FM
#define  GETCurrentFM_url   @"http://www.chinayogaonline.com/api/getCurrentFM"
//参数：无

//取某一天的FM节目单
#define GetOneDayFMfile_url   @"http://www.chinayogaonline.com/api/getFMPlayList"
//参数：无

//视频播放列表
#define VIDEOLIST_ULR @"http://www.chinayogaonline.com/api/getTVPlayList"
//参数：无

////当前正要播放的音乐
//#define CURRENTPLAYAUDIO_URL @"http://www.chinayogaonline.com/api/getCurrentMusic"
////参数：无
//
////音乐播放节目单
//#define AUDIOLIST_URL  @"http://www.chinayogaonline.com/api/getMusicPlayList"
////参数：无
//
////音频点播分类列表
//#define  http://www.chinayogaonline.com/api/getAodCategoryList
////参数：
//
////视频点播分类列表
//http://www.chinayogaonline.com/api/getVodCategoryList
////参数：
//
////音频点播列表
//#define AUDIOPICKLIST_URL @"http://www.chinayogaonline.com/api/getAodList"
////参数：cid（分类ID），keywords，limit，offset
//
////音频点播详情
//http://www.chinayogaonline.com/api/getAodById
////参数：aid(前一个接口，列表中返回的aid)
//
////获取下一首点播音频
//http://www.chinayogaonline.com/api/getNextAod
////参数：aid(当前正在播放的音频ID)
//
////视频点播列表
//http://www.chinayogaonline.com/api/getVodList
////参数：mobile
//
////视频点播详情
//http://www.chinayogaonline.com/api/getVodById
////参数：vid(前一个接口，列表中返回的vid)
//
////获取升级产品信息
//http://www.chinayogaonline.com/api/getMofangInfo
//
////获取在线人数
//http://www.chinayogaonline.com/api/getOnlineNumber
//
////创建订单，支付宝支付前调用
//http://www.chinayogaonline.com/api/createOrder
////参数 token(登录时获取)

//
//  include.h
//  yoga
//
//  Created by renxlin on 14-7-11.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


#define iOS7 ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)

//当前屏幕尺寸
#define KscreenHeight   [[UIScreen mainScreen] bounds].size.height
#define KscreenWidth    [[UIScreen mainScreen] bounds].size.width

#define Kdefaults  NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults]


//delegate
#define Kdelegate AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication]


//字体
#define Kfont(size) [UIFont systemFontOfSize:size]
#define KboldFont(boldSize) [UIFont boldSystemFontOfSize:boldSize]
//颜色
#define KCOLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define KUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


/* 警告框 */
#define KAlert(m)   UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:m delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show]

/* 风火轮普通 */
#define SVProgressHUDShow [SVProgressHUD showWithStatus:@"正在加载···" maskType:SVProgressHUDMaskTypeBlack]

/**
 风火轮自定义
 */
#define SVProgressHUDShow2(m) [SVProgressHUD showWithStatus:m maskType:SVProgressHUDMaskTypeBlack]


#define KDEVICE [UIDevice currentDevice].model



#define NOT_refreshOnlinePeople   @"Notification_refreshOnlinePeople"



//登录：

//#define LOGIN_url  @"http://www.chinayogaonline.com/api/login?"

#define LOGIN_url  @"http://www.chinayogaonline.com/api/login?username=%@&password=%@"

//参数 username password

//注册：
#define REGIST_URL  @"http://www.chinayogaonline.com/api/reg?"
//参数 mobile $email $password $code(短信验证码)

//查用户信息：
#define GETUSERINFO_Url  @"http://www.chinayogaonline.com/api/getUserInfo"
//参数 token(登录时获取)

//发送验证码：
#define GETVERTIFY_URL    @"http://www.chinayogaonline.com/api/sendCode?mobile="
//参数：mobile（手机号）

//当前正要播放的FM
#define  CURRENTPLAYFM_URL   @"http://www.chinayogaonline.com/api/getCurrentFM"
//#define  CURRENTPLAYFM_URL   @"http://www.chinayogaonline.com/api/getTestFm"
//参数：无


//取某一天的FM节目单

#define FMList_url   @"http://www.chinayogaonline.com/api/getFMPlayList"

//参数：无

//视频播放列表
#define VIDEOLIST_ULR @"http://www.chinayogaonline.com/api/getTVPlayList"
//参数：无

////当前正要播放的音乐

#define CURRENTPLAYAUDIO_URL @"http://www.chinayogaonline.com/api/getCurrentMusic"

//#define  CURRENTPLAYAUDIO_URL  @"http://www.chinayogaonline.com/api/getTestMusic"


////当前正要播放的视频
#define CURRENTPLAYVIDEO_URL   @"http://www.chinayogaonline.com/api/getCurrentTV"

//#define CURRENTPLAYVIDEO_URL   @"http://www.chinayogaonline.com/api/getTestTv"

////参数：无
//
////音乐播放节目单
#define AUDIOLIST_URL  @"http://www.chinayogaonline.com/api/getMusicPlayList"
////参数：无
//

////参数：
//获取九宫格图片的url
#define  GETFMpng_url   @"http://www.chinayogaonline.com/api/getYogafmAd"
//
#define  GETAudioPng_url   @"http://www.chinayogaonline.com/api/getAodAd"
#define  GETPickAudioPng_url   @"http://www.chinayogaonline.com/api/getMusicAd"


////参数：
//
////音频点播列表
#define AUDIOPICKLIST_URL   @"http://www.chinayogaonline.com/api/getAodList"

////音频点播分类列表
#define  SORT_AUDIOLIST_URL     @"http://www.chinayogaonline.com/api/getAodCategoryList"

////视频点播列表
#define VIDIOPICKLIST_URL @"http://www.chinayogaonline.com/api/getVodList"

////音频点播分类列表
#define  SORT_AUDIOPICKLIST_URL   @"http://www.chinayogaonline.com/api/getAodCategoryList"
////参数：
//
////视频点播分类列表
#define  SORT_VIDEOLIST_ULR    @"http://www.chinayogaonline.com/api/getVodCategoryList"
//#define  @"http://www.chinayogaonline.com/api/getVodCategoryList"
////参数：cid（分类ID），keywords，limit，offset
//
////音频点播详情
//http://www.chinayogaonline.com/api/getAodById
////参数：aid(前一个接口，列表中返回的aid)
//
////获取下一首点播音频
//http://www.chinayogaonline.com/api/getNextAod
////参数：aid(当前正在播放的音频ID)
///Users/cao/Desktop/yoga/yoga/include.h

////参数：mobile
//linker command failed with exit code 1 (use -v to see invocation)////视频点播详情
//http://www.chinayogaonline.com/api/getVodById
////参数：vid(前一个接口，列表中返回的vid)
//
////获取升级产品信息
//http://www.chinayogaonline.com/api/getMofangInfo
//
////获取在线人数
#define GETOnliePeople  @"http://www.chinayogaonline.com/api/getOnlineNumber"
//
////创建订单，支付宝支付前调用
//http://www.chinayogaonline.com/api/createOrder
////参数 token(登录时获取)


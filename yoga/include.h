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


//当前屏幕尺寸
#define KscreenHeight   [[UIScreen mainScreen] bounds].size.height
#define KscreenWidth    [[UIScreen mainScreen] bounds].size.width

#define Kdefaults  NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults]


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





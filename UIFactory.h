//
//  Factory.h
//  FreeDemo
//
//  Created by apple on 14-2-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

/*
 支持ARC和MRC
 */
#if __has_feature(objc_arc)

#define Retain(obj) (obj)
#define Release(obj) do { }while(0)
#define Autorelease(obj) (obj)
#define SuperDealloc do { }while(0)

#else

#define Retain(obj) [(obj) retain]
#define Release(obj) [(obj) release]
#define Autorelease(obj) [(obj) autorelease]
#define SuperDealloc [super dealloc]

#endif

typedef enum {
  left,
  center,
  ringht
}textAlignment_Type;

#import <Foundation/Foundation.h>

@interface UIFactory : NSObject

//创建label
+(UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color textFont:(UIFont *)font textAlignment:(textAlignment_Type)textAlignment;

/**
 @abstract
      活动指示器的大小不能通过frame调节，所以给中心点就行
 @param
      center:  中心点
 @param
      style:  活动指示器的风格
 */
+(UIActivityIndicatorView *)createActivityIndicatorViewWithCenter:(CGPoint)center style:(UIActivityIndicatorViewStyle)style;

//创建button
+(UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title bgImageName:(NSString *)imgName target:(id)target action:(SEL)action;

//创建警告框
+(UIAlertView *)createAlertViewWithTitle:(NSString *)title message:(NSString *)message;

//创建图片视图
+(UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)name;

//创建actionSheet
+(UIActionSheet *)createActionSheetWithTitle:(NSString *)title delegate:(id)deleagte otherButton1:(NSString *)otherButton1 otherButton2:(NSString *)otherButton2;

//创建textField
+(UITextField *)createTextFieldWithFrame:(CGRect)frame borderStyle:(UITextBorderStyle)style placeHolder:(NSString *)placeHolder secureEntry:(BOOL)secure delegate:(id)delegate;

@end

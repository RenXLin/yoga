//
//  Factory.m
//  FreeDemo
//
//  Created by apple on 14-2-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory

+(UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color textFont:(UIFont *)font textAlignment:(textAlignment_Type)textAlignment
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    Autorelease(label);
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = color;
    if(textAlignment == left)
    {
      label.textAlignment = NSTextAlignmentLeft;
    }
    else if(textAlignment == center)
    {
      label.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
      label.textAlignment = NSTextAlignmentRight;
    }
    label.font = font;
    return label;
}

+(UIActivityIndicatorView *)createActivityIndicatorViewWithCenter:(CGPoint)center style:(UIActivityIndicatorViewStyle)style
{
    UIActivityIndicatorView * aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    Autorelease(aiView);
    aiView.frame = CGRectZero;
  //活动指示器 大小是不能通过frame来调节的  所以设置中心点
  //可以通过affine来改变
    aiView.center = center;
    return aiView;
}

+(UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title bgImageName:(NSString *)imgName target:(id)target action:(SEL)action
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    //如果需要设置背景图片 才设置背景图片
    if(imgName && [imgName length] != 0)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+(UIAlertView *)createAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    Autorelease(alertView);
   [alertView show];
    return alertView;
}

+(UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)name
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
     Autorelease(imageView);
    if(name)
    {
        imageView.image = [UIImage imageNamed:name];
    }
    return imageView;
}

+(UIActionSheet *)createActionSheetWithTitle:(NSString *)title delegate:(id)deleagte otherButton1:(NSString *)otherButton1 otherButton2:(NSString *)otherButton2;
{
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:title delegate:deleagte cancelButtonTitle:@"取消" destructiveButtonTitle:nil   otherButtonTitles: otherButton1,otherButton2, nil];
    Autorelease(action);
    return action;
}

+(UITextField *)createTextFieldWithFrame:(CGRect)frame borderStyle:(UITextBorderStyle)style placeHolder:(NSString *)placeHolder secureEntry:(BOOL)secure delegate:(id)delegate
{
    UITextField * textField = [[UITextField alloc] initWithFrame:frame];
    Autorelease(textField);
    textField.delegate = delegate;
    textField.borderStyle = style;
    textField.placeholder = placeHolder;

    //不自动大写
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.secureTextEntry = secure;
    return textField;
}

@end

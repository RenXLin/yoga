//
//  GetBackPasswordViewController.h
//  yoga
//
//  Created by 123 on 15-2-4.
//  Copyright (c) 2015年 任小林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetBackPasswordViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
/*UITextField *_phoneNum;
 UITextField *_verifyNum;
 UITextField *_passWord;
 UITextField *_passWord2;
 UITextField *_name;
 UIButton *verify;
 NSTimer *_timer;*/

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *verifyNum;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *passWord2;

@property (weak, nonatomic) IBOutlet UIButton *verify;

- (IBAction)verifyBtn:(UIButton *)sender;

@end

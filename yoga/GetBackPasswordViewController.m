//
//  GetBackPasswordViewController.m
//  yoga
//
//  Created by 123 on 15-2-4.
//  Copyright (c) 2015年 任小林. All rights reserved.
//

#import "GetBackPasswordViewController.h"

@interface GetBackPasswordViewController ()
{
    NSTimer *_timer;
}
@end

@implementation GetBackPasswordViewController


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden =YES;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
}
-(BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0)
{
    return UIInterfaceOrientationPortrait;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    UIView *nav;
    if ([[UIDevice currentDevice].systemVersion intValue] >= 7) {
        nav = [self myNavgationBar:CGRectMake(0, 20, self.view.frame.size.width, 44) andTitle:@"忘记密码"];
    
       
    }else{
        nav = [self myNavgationBar:CGRectMake(0, 0, self.view.frame.size.width, 44) andTitle:@"忘记密码"];
    }
    [self.view addSubview:nav];
    nav.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    //    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    _verify.showsTouchWhenHighlighted = YES;

    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNum resignFirstResponder];
    [_passWord resignFirstResponder];
    [_passWord2 resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)verifyBtn:(UIButton *)sender {
    if (sender.tag == 1) {
        //获取验证码：
        if (_timer == nil) {
            
            AFHTTPRequestOperationManager *regsieMg = [AFHTTPRequestOperationManager manager];
            regsieMg.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",GETVERTIFY_URL,_phoneNum.text];
            NSLog(@"%@",url);
            [regsieMg GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                // NSLog(@"success:\n%@",[responseObject objectForKey:@"msg"]);
                if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                    
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
                    sender.alpha = 0.5;
                    sender.userInteractionEnabled = NO;
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码已发送" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }else{
                    NSString *message = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Failed:%@",error.localizedDescription);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码发送失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }];
        }
    }else if(sender.tag == 2){
        
        if ([_phoneNum.text length] == 0) {
            [self animateIncorrectMessage:_phoneNum];
            
            [SVProgressHUD showErrorWithStatus:@"请输入手机号！"];
            return;
        }
        
        if ([_verifyNum.text length] == 0) {
            [self animateIncorrectMessage:_verifyNum];
            [SVProgressHUD showErrorWithStatus:@"请输入验证码！"];
            return;
        }
        if ([_passWord.text length] == 0) {
            [self animateIncorrectMessage:_passWord];
            [SVProgressHUD showErrorWithStatus:@"请输入密码！" ];
            return;
        }
        
        if (![_passWord.text isEqualToString:_passWord2.text]) {
            [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致！"];
            [self animateIncorrectMessage:_passWord2];
            return;
        }
        
        
        if ([_passWord.text length]<6) {
            [SVProgressHUD showErrorWithStatus:@"密码长度必须大于6！"];
            [self animateIncorrectMessage:_passWord];
            [self animateIncorrectMessage:_passWord2];
            return;
        }

        [self request];
        
    }

    
    
}
- (void)request
{
    //    SVProgressHUDShow;
    NSString *urlString = [NSString stringWithFormat:@"%@mobile=%@&newpass=%@&code=%@%@",GETBACK_URL,_phoneNum.text,_passWord.text,_verifyNum.text,Kversion];
   
    NSLog(@"%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
//         [YXSpritesLoadingView dismiss];
         NSLog(@"%@",responseObject);
         if (responseObject != nil)
         {
             if ([responseObject isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary * dict=[NSDictionary dictionaryWithDictionary:responseObject];
                 if([[dict valueForKey:@"code"]intValue]==200) //请求成功
                 {
                     if([[dict objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
                     {
                       
                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码找回成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                         alert.tag = 456;
                         [alert show];
                     }
                     
                 }else
                 {
                     KAlert(dict[@"msg"]);
                 }
             }
             
             
         }
         
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
             KAlert(@"请求失败");
             
             NSLog(@"%@",error.localizedDescription);
         } ];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 456)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)timerTick
{
    static int second = 60;
    [_verify setTitle:[NSString stringWithFormat:@"重新获取(%d)", --second ] forState:UIControlStateNormal];
    if (second == 0) {
        second = 60;
        [_verify setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _verify.userInteractionEnabled = YES;
        _timer = nil;
        _verify.alpha = 1;
        _verify.selected = NO;
    }
}

-(UIView *)myNavgationBar:(CGRect)rect andTitle:(NSString *)tit
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title.png"]];
    
    //back button
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(2, 0, 40, view.frame.size.height);
    [back addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"title_icon.png"] forState:UIControlStateNormal];
    [view addSubview:back];
    
    //title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(back.frame.size.width, 0, 70, rect.size.height)];
    title.text = tit;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    [view addSubview:title];
    return view;
}
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//账户未输入动画
- (void)animateIncorrectMessage:(UIView *)view
{
    
    CGAffineTransform moveRight = CGAffineTransformTranslate(CGAffineTransformIdentity, 8, 0);
    CGAffineTransform moveLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -8, 0);
    CGAffineTransform resetTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    
    [UIView animateWithDuration:0.1 animations:^{
        view.transform = moveLeft;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            view.transform = moveRight;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                view.transform = moveLeft;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    view.transform = moveRight;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        view.transform = resetTransform;
                    }];
                }];
            }];
        }];
    }];
}

@end

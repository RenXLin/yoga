//
//  RL_LoginViewController.m
//  yoga
//
//  Created by renxlin on 14-7-12.
//  Copyright (c) 2014年 任小林. All rights reserved.
//  登陆

#import "RL_LoginViewController.h"
#import "AFNetworking.h"
#import "RL_RegistViewController.h"

#import "CountCenterViewController.h"
#import "AppDelegate.h"
@interface RL_LoginViewController ()

@end

@implementation RL_LoginViewController
{
    UITextField *_account;
    UITextField *_passWord;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    UIView *nav = [self myNavgationBar:CGRectMake(0, iOS7?20:0, self.view.frame.size.width, 44) andTitle:@"登陆"];
    [self.view addSubview:nav];
    


    self.view.autoresizesSubviews = YES;
    
    _account = [[UITextField alloc] init];
    _account.frame = CGRectMake(10, 70, self.view.frame.size.width-20, 50);
    _account.borderStyle = UITextBorderStyleRoundedRect;//设置边框样式
    _account.placeholder = @"请输入账号";
    _account.clearButtonMode = UITextFieldViewModeAlways;
    _account.textColor = [UIColor blackColor];
    _account.backgroundColor = [UIColor whiteColor];
    _account.delegate = self;
    _account.tag = 100;
    _account.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_account];
    _account.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    _passWord = [[UITextField alloc] init];
    _passWord.frame = CGRectMake(10, 130, self.view.frame.size.width-20, 50);
    _passWord.borderStyle = UITextBorderStyleRoundedRect;//设置边框样式
    Kdefaults;
    if([defaults valueForKey:@"accountAndPassword"])
    {
        _account.text = [[defaults valueForKey:@"accountAndPassword"]objectAtIndex:0];
        _passWord.text = [[defaults valueForKey:@"accountAndPassword"]objectAtIndex:1];
    }
    
    _passWord.placeholder = @"请输入密码";
    _passWord.clearButtonMode = UITextFieldViewModeAlways;
    _passWord.textColor = [UIColor blackColor];
    _passWord.backgroundColor = [UIColor whiteColor];
    _passWord.delegate = self;
    _passWord.secureTextEntry = YES;
    _passWord.tag = 100;
    _passWord.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_passWord];
    _passWord.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //btn 注册
    UIButton *assign = [UIButton buttonWithType:UIButtonTypeCustom];
    assign.frame = CGRectMake(10, 200, 140, 50);
    assign.showsTouchWhenHighlighted = YES;
    assign.layer.backgroundColor = [UIColor colorWithRed:0.07f green:0.63f blue:0.89f alpha:1.00f].CGColor;
    [assign setTitle:@"注册" forState:UIControlStateNormal];
    [assign setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    assign.tag = 1;
    [assign addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:assign];
    assign.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //btn 登陆
    UIButton *login_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    login_btn.showsTouchWhenHighlighted = YES;
    login_btn.frame = CGRectMake(self.view.frame.size.width - 150, 200, 140, 50);
    login_btn.layer.backgroundColor = [UIColor colorWithRed:0.49f green:0.81f blue:0.23f alpha:1.00f].CGColor;
    [login_btn setTitle:@"登陆" forState:UIControlStateNormal];
    [login_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login_btn.tag = 2;
    [login_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login_btn];
    login_btn.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_account resignFirstResponder];
    [_passWord resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)btnClick:(UIButton *)btn
{
    //NSLog(@"%ld",(long)btn.tag);
    if (btn.tag == 2) {
        
        if(_account.text.length == 0)
        {
            [self animateIncorrectMessage:_account];
            
        }
        
        if(_passWord.text.length == 0)
        {
            [self animateIncorrectMessage:_passWord];
        }
        
        
        if(_account.text.length!=0 && _passWord.text.length!=0)
        {
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSString *URLStr = [NSString stringWithFormat:LOGIN_url,_account.text,_passWord.text,Kversion];
            
            //待加入缓冲提示：
            [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"%@",responseObject);
                if ([[responseObject objectForKey:@"code"] intValue] == 200) {
                    //NSLog(@"登陆成功");
                    
                    UserInfo *userInfo = [UserInfo shareUserInfo];
                    userInfo.token = [[responseObject objectForKey:@"data"] objectForKey:@"token"];
                    userInfo.userName = [[responseObject objectForKey:@"data"] objectForKey:@"username"];
                    
                    
                    userInfo.userDict = [responseObject objectForKey:@"data"];
                    
                    
                    
                    for (NSDictionary *dic in [userInfo.userDict objectForKey:@"roleInfo"])
                    {
                        if((![[dic objectForKey:@"code"] isEqualToString:@""] && ![[dic objectForKey:@"code"] isEqualToString:@"user"]))
                        {
                            userInfo.ifbuy = [dic objectForKey:@"code"];
                        }
                    }
                    
                    
                    
                    
                    Kdefaults;
                    NSArray*arr=@[_account.text,_passWord.text];
                    [defaults setObject:arr forKey:@"accountAndPassword"];
                    [defaults synchronize];
                    
                    
                    if(self.fromStr.length == 0)
                    {
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                    }else
                    {
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                    }
                    
                    
                    
                    
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登陆失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登陆失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }];
        }

        
        
  
    }else if(btn.tag == 1){
        RL_RegistViewController *rvc =[[RL_RegistViewController alloc] init];
        [self.navigationController pushViewController:rvc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
             
             
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
    view.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    UIButton *forgetPassW = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPassW.frame = CGRectMake(rect.size.width - 100, 0, 100, rect.size.height);
    [forgetPassW setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgetPassW.titleLabel.font = [UIFont systemFontOfSize:13];
    forgetPassW.titleLabel.textAlignment = NSTextAlignmentRight;
    [forgetPassW addTarget:self action:@selector(forgetPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:forgetPassW];
    
    return view;
}
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//忘记密码：
-(void)forgetPassWord:(UIButton *)btn
{
    btn.alpha = 0.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.alpha = 1;
    });
    
    

}

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


//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0);
//{
//    return UIInterfaceOrientationPortrait;
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

         @end
//
//  RL_RegistViewController.m
//  yoga
//
//  Created by renxlin on 14-7-12.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "RL_RegistViewController.h"
#import "AFNetworking.h"

@interface RL_RegistViewController ()

@end

@implementation RL_RegistViewController
{
    UITextField *_phoneNum;
    UITextField *_verifyNum;
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
-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    UIView *nav = [self myNavgationBar:CGRectMake(0, 20, self.view.frame.size.width, 44) andTitle:@"登陆"];
    [self.view addSubview:nav];
    
    _phoneNum = [[UITextField alloc] init];
    _phoneNum.frame = CGRectMake(10, 70, self.view.frame.size.width- 120, 50);
    _phoneNum.borderStyle = UITextBorderStyleRoundedRect;//设置边框样式
    _phoneNum.layer.cornerRadius = 10;
    _phoneNum.placeholder = @"请输入手机号码";
    _phoneNum.clearButtonMode = UITextFieldViewModeAlways;
    _phoneNum.textColor = [UIColor redColor];
    _phoneNum.backgroundColor = [UIColor whiteColor];
    _phoneNum.delegate = self;
    _phoneNum.tag = 100;
    _phoneNum.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_phoneNum];
    
    UIButton *verify = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    verify.frame = CGRectMake(_phoneNum.frame.size.width+20, 70, 80, 50);
    verify.backgroundColor = [UIColor colorWithRed:0.23f green:0.90f blue:1.00f alpha:1.00f];
    [verify setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verify setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    verify.layer.cornerRadius = 10;
    verify.tag = 1;
    [verify addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verify];

    
    _verifyNum = [[UITextField alloc] init];
    _verifyNum.frame = CGRectMake(10, 130, 300, 50);
    _verifyNum.borderStyle = UITextBorderStyleRoundedRect;//设置边框样式
    _verifyNum.layer.cornerRadius = 10;
    _verifyNum.placeholder = @"验证码";
    _verifyNum.clearButtonMode = UITextFieldViewModeAlways;
    _verifyNum.textColor = [UIColor redColor];
    _verifyNum.backgroundColor = [UIColor whiteColor];
    _verifyNum.delegate = self;
    _verifyNum.tag = 100;
    _verifyNum.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_verifyNum];
    
    _passWord = [[UITextField alloc] init];
    _passWord.frame = CGRectMake(10, 190, 300, 50);
    _passWord.borderStyle = UITextBorderStyleRoundedRect;//设置边框样式
    _passWord.layer.cornerRadius = 10;
    _passWord.placeholder = @"请输入密码";
    _passWord.clearButtonMode = UITextFieldViewModeAlways;
    _passWord.textColor = [UIColor redColor];
    _passWord.backgroundColor = [UIColor whiteColor];
    _passWord.delegate = self;
    _passWord.tag = 100;
    _passWord.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_passWord];

    UIButton *assign = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    assign.frame = CGRectMake(10, 250, self.view.frame.size.width - 20, 50);
    assign.backgroundColor = [UIColor colorWithRed:0.23f green:0.90f blue:1.00f alpha:1.00f];
    [assign setTitle:@"注册" forState:UIControlStateNormal];
    [assign setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    assign.layer.cornerRadius = 10;
    assign.tag = 2;
    [assign addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:assign];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNum resignFirstResponder];
    [_passWord resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)btnClick:(UIButton *)btn
{
    NSLog(@"click %@",btn);
    if (btn.tag == 1) {
        //获取验证码：
        AFHTTPRequestOperationManager *regsieMg = [AFHTTPRequestOperationManager manager];
        regsieMg.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [regsieMg GET:[NSString stringWithFormat:@"%@%@",GETVERTIFY_URL,_phoneNum.text] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success:\n%@",[responseObject objectForKey:@"msg"]);
            if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码已发送" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                NSString *message = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed:%@",error);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码发送失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }else if(btn.tag == 2){
        //注册
        AFHTTPRequestOperationManager *registM = [AFHTTPRequestOperationManager manager];
        NSDictionary *paramterDic = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNum.text,@"mobile",
                                     _passWord.text,@"password",_verifyNum.text,@"code", nil];
        registM.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [registM POST:REGIST_URL parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success:\n%@",responseObject);
            NSLog(@"%@",[responseObject objectForKey:@"msg"]);
            if ([[[responseObject objectForKey:@"msg"] objectForKey:@"<#string#>"]isEqualToString:@"ok"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机格式错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed:%@",error);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码发送失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];
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
    title.textColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    [view addSubview:title];
    return view;
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end

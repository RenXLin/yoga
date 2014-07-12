//
//  RL_LoginViewController.m
//  yoga
//
//  Created by renxlin on 14-7-12.
//  Copyright (c) 2014年 任小林. All rights reserved.
//  登陆

#import "RL_LoginViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    UIView *nav = [self myNavgationBar:CGRectMake(0, 20, self.view.frame.size.width, 44) andTitle:@"登陆"];
    [self.view addSubview:nav];
    
    _account = [[UITextField alloc] init];
    _account.frame = CGRectMake(10, 70, self.view.frame.size.width-20, 50);
    _account.borderStyle = UITextBorderStyleRoundedRect;//设置边框样式
    _account.layer.cornerRadius = 10;
    _account.placeholder = @"please input your account";
    _account.clearButtonMode = UITextFieldViewModeAlways;
    _account.textColor = [UIColor redColor];
    _account.backgroundColor = [UIColor whiteColor];
    _account.delegate = self;
    _account.tag = 100;
    _account.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_account];
    
    _passWord = [[UITextField alloc] init];
    _passWord.frame = CGRectMake(10, 130, 300, 50);
    _passWord.borderStyle = UITextBorderStyleRoundedRect;//设置边框样式
    _passWord.layer.cornerRadius = 10;
    _passWord.placeholder = @"please input your text";
    _passWord.clearButtonMode = UITextFieldViewModeAlways;
    _passWord.textColor = [UIColor redColor];
    _passWord.backgroundColor = [UIColor whiteColor];
    _passWord.delegate = self;
    _passWord.tag = 100;
    _passWord.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_passWord];

    //btn 注册
    UIButton *assign = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    assign.frame = CGRectMake(10, 200, 150, 50);
    assign.backgroundColor = [UIColor blueColor];
    [assign setTitle:@"按钮" forState:UIControlStateNormal];
    [assign setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    assign.layer.cornerRadius = 10;
    assign.tag = 1;
    [assign addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:assign];
    
    //btn 登陆
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(self.view.frame.size.width - 150, 200, 150, 50);
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10;
    btn.tag = 2;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
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
    NSLog(@"%d",btn.tag);
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
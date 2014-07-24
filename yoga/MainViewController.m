//
//  MainViewController.m
//  yoga
//
//  Created by renxlin on 14-7-12.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "MainViewController.h"
#import "RL_FMViewController.h"
#import "RL_TVViewController.h"
#import "RL_LoginViewController.h"
#import "RL_SettingViewController.h"
#import "SC_AudioOnLineViewController.h"
#import "AFNetworking.h"
#import "UserInfo.h"
#import "SC_popView.h"

#define GAP_WITH  2.5  //定义白色边框的大小：

@interface MainViewController ()

@end

@implementation MainViewController
{
    //当前在线人数
    UILabel *_onlinePeople;

    //定时器定时刷新在线人数：
    NSTimer *_timer;
    
    
    UIButton *btn;
    UIButton *btn1;
    SC_popView *lplv;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
//刷新在线人数 method
-(void)refreshPeople
{
    UserInfo *info =[UserInfo shareUserInfo];
    _onlinePeople.text = info.onliePeople;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor grayColor];
    
    //5s刷新一次
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshOnlinePeople) userInfo:nil repeats:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPeople) name:NOT_refreshOnlinePeople object:nil];
    
    //标题
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2, 5, 100, 30)];
    label.text = @"瑜伽魔方";
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
    
    //添加白色底板
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(5, label.frame.origin.y + label.frame.size.height +10, [UIScreen mainScreen].bounds.size.width-10, [UIScreen mainScreen].bounds.size.width-10)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];

    NSMutableArray *colorArray =[[NSMutableArray alloc] init];
    UIColor *color1 = [UIColor colorWithRed:0.09f green:0.82f blue:1.00f alpha:1.00f];
    UIColor *color2 = [UIColor colorWithRed:0.04f green:0.91f blue:0.49f alpha:1.00f];
    UIColor *color3 = [UIColor colorWithRed:0.98f green:0.38f blue:0.31f alpha:1.00f];
    UIColor *color4 = [UIColor colorWithRed:1.00f green:0.50f blue:0.13f alpha:1.00f];
    UIColor *color5 = [UIColor colorWithRed:0.23f green:0.90f blue:1.00f alpha:1.00f];
    UIColor *color6 = [UIColor colorWithRed:0.09f green:0.82f blue:1.00f alpha:1.00f];
    UIColor *color7 = [UIColor colorWithRed:0.05f green:0.93f blue:0.38f alpha:1.00f];
    UIColor *color8 = [UIColor colorWithRed:0.09f green:0.82f blue:1.00f alpha:1.00f];
    UIColor *color9 = [UIColor colorWithRed:1.00f green:0.82f blue:0.11f alpha:1.00f];
    [colorArray addObject:color1];
    [colorArray addObject:color2];
    [colorArray addObject:color3];
    [colorArray addObject:color4];
    [colorArray addObject:color5];
    [colorArray addObject:color6];
    [colorArray addObject:color7];
    [colorArray addObject:color8];
    [colorArray addObject:color9];
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"YOGA FM",@"YOGA TV",@"瑜伽好声音",@"音频点播",@"视频点播", nil];
//    NSArray *imageArray = [NSArray arrayWithObjects:@"fm.png",@"string",@"<#string#>",@"<#string#>", nil];
    CGFloat rect_width = (whiteView.frame.size.width - GAP_WITH * 4) / 3;
    int count = 0;
    for (int i = 0; i < 3 ; i++) {
        
        for (int j = 0; j < 3; j++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(GAP_WITH *(j + 1) + j * rect_width, GAP_WITH *(i + 1) + i * rect_width , rect_width, rect_width)];
            view.tag = i * 3 + j+1; //(1 2...9)
            view.backgroundColor = [colorArray objectAtIndex:i * 3 +j];
            view.contentMode = UIViewContentModeScaleToFill;
            [whiteView addSubview:view];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
            [view addGestureRecognizer:tap];
            
            //加入名称或图标：
            if ((i * 3 + j + 1) %2 == 1) {
                [view addSubview:[self getLabelWithTitel:[titleArray objectAtIndex:count++] andRect:CGRectMake(0, view.frame.size.height/2 -15, view.frame.size.width, 30)]];
            }else{
                [view addSubview:[self getImageViewWithName:@"fm" andFrame:view.bounds]];
            }
            
        }
        
    }
    
    // logoView
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 150 )/2, whiteView.frame.origin.y +whiteView.frame.size.height + 20, 150, 40)];
    logoView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
    [self.view addSubview:logoView];
    
    //loginview
    UIButton *loginView = [UIButton buttonWithType:UIButtonTypeCustom];
    loginView.frame = CGRectMake((self.view.frame.size.width - 140 - 40*2)/2, logoView.frame.origin.y + logoView.frame.size.height + 20, 40, 40);
    [loginView addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue1" ofType:@"png"]] forState:UIControlStateNormal];
    [self.view addSubview:loginView];
    
    //当前在线人数
    _onlinePeople = [[UILabel alloc] initWithFrame:CGRectMake(loginView.frame.size.width + loginView.frame.origin.x, loginView.frame.origin.y, 140, loginView.frame.size.height)];
//    _onlinePeople.text = [NSString stringWithFormat:@"当前在线人数:%@",info.onliePeople];//暂定
    _onlinePeople.adjustsFontSizeToFitWidth = YES;
    _onlinePeople.textAlignment = NSTextAlignmentCenter;
    _onlinePeople.textColor = [UIColor whiteColor];
    [self.view addSubview:_onlinePeople];
    
    //settting View
    UIButton *settingView = [UIButton buttonWithType:UIButtonTypeCustom];
    settingView.frame = CGRectMake(loginView.frame.size.width+loginView.frame.origin.x + 140, logoView.frame.origin.y + logoView.frame.size.height + 20, 40, 40);
    [settingView addTarget:self action:@selector(SettingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [settingView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue" ofType:@"png"]] forState:UIControlStateNormal];
    [self.view addSubview:settingView];

    //获取当前在线人数；
    AFHTTPRequestOperationManager *ma = [AFHTTPRequestOperationManager manager];
    ma.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ma GET:GETOnliePeople parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _onlinePeople.text = [NSString stringWithFormat:@"当前在线人数:%@",[[responseObject objectForKey:@"data"] objectForKey:@"count"]];
        UserInfo *info = [UserInfo shareUserInfo];
        info.onliePeople = _onlinePeople.text;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}


//魔方功能视图切换：
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"gestuer tap");
    UIView *view = tap.view;
    NSLog(@"%ld",(long)view.tag);
    if (view.tag == 1) {
        //推出魔方FM视图控制器：
        RL_FMViewController * fmV= [[RL_FMViewController alloc] init];
        fmV.FM_AV = @"瑜伽FM";
        [self presentViewController:fmV animated:YES completion:nil];
    }else if(view.tag == 3){
        //瑜伽TV
        RL_TVViewController *TVV = [[RL_TVViewController alloc] init];
        [self presentViewController:TVV animated:YES completion:nil];

    }else if(view.tag == 4){
        //音频点播
        
        
        
        
        
        
        UserInfo *info = [UserInfo shareUserInfo];
        if(info.token.length == 0)
        {
            
            lplv = [[SC_popView alloc] initWithTitle:@"没有访问权限，请登录或升级位魔方会员" options:nil With:btn With:btn1];
            //lplv.delegate = self;
            [lplv showInView:self.view animated:YES];
            
            [self creatBtn];
            
            
            
            
        }else
        {
            SC_AudioOnLineViewController *audioView = [[SC_AudioOnLineViewController alloc]init];
            audioView.Title = @"音频点播";
            audioView.audio = @"audio";
            audioView.modalPresentationStyle = UIModalPresentationCustom;
            audioView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:audioView animated:YES completion:nil];
        }
        
        
        
    }else if (view.tag == 5){
        //瑜伽音乐
        RL_FMViewController * AV= [[RL_FMViewController alloc] init];
        AV.FM_AV = @"瑜伽音乐";
        [self presentViewController:AV animated:YES completion:nil];
    }else if(view.tag == 6){
        //音频点播
        
        
        UserInfo *info = [UserInfo shareUserInfo];
        if(info.token.length == 0)
        {
            
            lplv = [[SC_popView alloc] initWithTitle:@"没有访问权限，请登录或升级位魔方会员" options:nil With:btn With:btn1];
            //lplv.delegate = self;
            [lplv showInView:self.view animated:YES];
            
            [self creatBtn];
            
        }else
        {

        
        SC_AudioOnLineViewController *audioView = [[SC_AudioOnLineViewController alloc]init];
        audioView.Title = @"视屏点播";
        audioView.modalPresentationStyle = UIModalPresentationCustom;
        audioView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:audioView animated:YES completion:nil];
        }
        

    }else if (view.tag == 7){
        SC_AudioOnLineViewController *avc = [[SC_AudioOnLineViewController alloc]init];
        [self presentViewController:avc animated:YES completion:nil];

    }
    
    
    
    
    
    
}

//登录  升级按钮

- (void)creatBtn
{
    if(KscreenHeight == 568 || KscreenHeight == 480)
    {
        btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 80+5, (KscreenWidth-50)/2, 40)];
        btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20+btn.frame.size.width, 80+5, btn.frame.size.width, 40)];
        btn.titleLabel.font = Kfont(15);
        btn1.titleLabel.font = Kfont(15);
    }else
    {
        btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 80+10, (KscreenWidth - 60-20)/2, 60)];
        btn1 = [[UIButton alloc]initWithFrame:CGRectMake(40+(KscreenWidth - 60-20)/2,80+10, btn.frame.size.width, 60)];
        btn.titleLabel.font = Kfont(20);
        btn1.titleLabel.font = Kfont(20);
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:@"white_btn1.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    btn.tag = 110;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    
    [btn1 setBackgroundImage:[UIImage imageNamed:@"white_btn1.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"马上升级" forState:UIControlStateNormal];
    btn1.tag = 111;
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    [lplv.bgView addSubview:btn];
    [lplv.bgView addSubview:btn1];
}


- (void)back:(UIButton *)button
{
    switch (button.tag-110) {
        case 0:
        {
            
            RL_LoginViewController *login = [[RL_LoginViewController alloc]init];
            [self presentViewController:login animated:YES completion:nil];
            
        }
            break;
        case 1:
        {
            
        }
            break;
            
        default:
            break;
    }
    [UIView animateWithDuration:.35 animations:^{
        lplv.transform = CGAffineTransformMakeScale(1.3, 1.3);
        lplv.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [lplv removeFromSuperview];
        }
    }];

}

//登陆：
-(void)loginBtnClick
{
    RL_LoginViewController *login = [[RL_LoginViewController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}
//设置：
-(void)SettingBtnClick
{
    RL_SettingViewController *settingV = [[RL_SettingViewController alloc] init];
    [self presentViewController:settingV animated:YES completion:nil];

}

//生成label方法
-(UILabel *)getLabelWithTitel:(NSString *)title andRect:(CGRect)rect
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont systemFontOfSize:15];
    return label;
}
//生成背景视图方法
-(UIImageView *)getImageViewWithName:(NSString *)strName andFrame:(CGRect)rect
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:rect];
    imageV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:strName ofType:@"png"]];
    imageV.contentMode = UIViewContentModeScaleToFill;
    
    return imageV;
}

//本视图仅支持竖屏：
-(BOOL)shouldAutorotate
{
    return NO;
}
-(void)refreshOnlinePeople
{
    //获取当前在线人数；
    AFHTTPRequestOperationManager *ma = [AFHTTPRequestOperationManager manager];
    ma.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ma GET:GETOnliePeople parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _onlinePeople.text = [NSString stringWithFormat:@"当前在线人数:%@",[[responseObject objectForKey:@"data"] objectForKey:@"count"]];
        UserInfo *info = [UserInfo shareUserInfo];
        info.onliePeople = _onlinePeople.text;
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshOnlinePeople) userInfo:nil repeats:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOT_refreshOnlinePeople object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshOnlinePeople) userInfo:nil repeats:NO];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

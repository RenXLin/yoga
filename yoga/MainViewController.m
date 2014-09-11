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

#import "SVProgressHUD/SVProgressHUD.h"
#import "OrderViewController.h"
#import "CountCenterViewController.h"

#import "UIColor+expanded.h"
//#import "OrderViewController.h"

#define GAP_WITH  2.5  //定义白色边框的大小：

@interface MainViewController ()

@end

@implementation MainViewController
{
    //当前在线人数
    UILabel *_onlinePeople;

    //定时器定时刷新在线人数：
    NSTimer *_timer;
    
    
   
    
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

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //白色状态条：
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];

    self.navigationController.navigationBarHidden = YES;

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    self.view.autoresizesSubviews = YES;
    //5s刷新一次
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshOnlinePeople) userInfo:nil repeats:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPeople) name:NOT_refreshOnlinePeople object:nil];
    
    //标题
//    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2, 20, 100, 30)];
//    label.text = @"瑜伽魔方";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont systemFontOfSize:20];
//    [self.view addSubview:label];
//    label.autoresizingMask =
//    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
//    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleWidth;
    
    //添加白色底板
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(5, 25, [UIScreen mainScreen].bounds.size.width-10, [UIScreen mainScreen].bounds.size.width-10)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    whiteView.autoresizingMask=
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    NSMutableArray *colorArray =[[NSMutableArray alloc] init];
    UIColor *color1 = [UIColor colorWithRed:0.09f green:0.70f blue:0.91f alpha:1.00f];
    UIColor *color2 = [UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.00f];
    UIColor *color3 = [UIColor colorWithRed:0.53f green:0.45f blue:0.69f alpha:1.00f];
    UIColor *color4 = [UIColor colorWithRed:0.98f green:0.56f blue:0.17f alpha:1.00f];
    UIColor *color5 = [UIColor colorWithRed:0.98f green:0.88f blue:0.56f alpha:1.00f];
    UIColor *color6 = [UIColor colorWithRed:0.23f green:0.55f blue:0.38f alpha:1.00f];
    UIColor *color7 = [UIColor colorWithRed:0.53f green:0.45f blue:0.69f alpha:1.00f];
    UIColor *color8 = [UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.00f];
    UIColor *color9 = [UIColor colorWithRed:0.09f green:0.70f blue:0.91f alpha:1.00f];
    [colorArray addObject:color1];
    [colorArray addObject:color2];
    [colorArray addObject:color3];
    [colorArray addObject:color4];
    [colorArray addObject:color5];
    [colorArray addObject:color6];
    [colorArray addObject:color7];
    [colorArray addObject:color8];
    [colorArray addObject:color9];
    
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"瑜伽 FM",@"瑜伽 TV",@"魔方音乐台", nil];
    NSArray *clickArray = @[@"音频点播",@"视频点播"];
//    NSArray *imageArray = [NSArray arrayWithObjects:@"fm.png",@"string",@"<#string#>",@"<#string#>", nil];
    CGFloat rect_width = (whiteView.frame.size.width - GAP_WITH * 4) / 3;
    int count = 0;
    int count1 = 0;
    for (int i = 0; i < 3 ; i++) {
        
        for (int j = 0; j < 3; j++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(GAP_WITH *(j + 1) + j * rect_width, GAP_WITH *(i + 1) + i * rect_width , rect_width, rect_width)];
            view.tag = i * 3 + j+1; //(1 2...9)
            view.backgroundColor = [colorArray objectAtIndex:i * 3 +j];
            view.contentMode = UIViewContentModeScaleToFill;
            [whiteView addSubview:view];
//            if (i*3+j+1 != 2 && i*3 +j+1 != 7 && i*3+j+1 != 8 && i*3+j+1 != 9) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
                [view addGestureRecognizer:tap];
//            }
            view.autoresizingMask =
//            UIViewAutoresizingFlexibleBottomMargin |
//            UIViewAutoresizingFlexibleTopMargin |
//            UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleWidth;
            
            //加入名称或图标：
            if (i * 3 + j + 1 == 7 || i * 3 + j + 1 == 9) {
                  [view addSubview:[self getLabelWithTitel:[clickArray objectAtIndex:count1++] andRect:CGRectMake(0, view.frame.size.height/2 -15, view.frame.size.width, 30) andIsDisable:NO]];
                //[view addSubview:[self getLabelWithTitel:[titleArray objectAtIndex:count++] andRect:CGRectMake(0, view.frame.size.height/2 -15, view.frame.size.width, 30) andIsDisable:YES]];
            }else if ((i * 3 + j + 1) %2 == 1) {
                [view addSubview:[self getLabelWithTitel:[titleArray objectAtIndex:count++] andRect:CGRectMake(0, view.frame.size.height/2 -15, view.frame.size.width, 30) andIsDisable:NO]];
            }else if((i * 3 + j + 1) == 4 || (i * 3 + j + 1) == 6){
//                [view addSubview:[self getLabelWithTitel:[clickArray objectAtIndex:count1++] andRect:CGRectMake(0, view.frame.size.height/2 -15, view.frame.size.width, 30) andIsDisable:NO]];
            }else if (i*3 +j+1 == 2){
                [view addSubview:[self getImageViewWithName:@"222" andFrame:view.bounds]];

            } else{
                [view addSubview:[self getImageViewWithName:@"fm1" andFrame:view.bounds]];
            }
            
        }
        
    }
    
    // logoView
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 150 )/2, whiteView.frame.origin.y +whiteView.frame.size.height + 20, 150, 45)];
    logoView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
    [self.view addSubview:logoView];
    logoView.autoresizingMask=
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //loginview
    UIButton *loginView = [UIButton buttonWithType:UIButtonTypeCustom];
    loginView.frame = CGRectMake((self.view.frame.size.width - 140 - 40*2)/2, logoView.frame.origin.y + logoView.frame.size.height + 20, 40, 40);
    [loginView addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue1" ofType:@"png"]] forState:UIControlStateNormal];
    [self.view addSubview:loginView];
    loginView.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //当前在线人数
    _onlinePeople = [[UILabel alloc] initWithFrame:CGRectMake(loginView.frame.size.width + loginView.frame.origin.x, loginView.frame.origin.y, 140, loginView.frame.size.height)];
//    _onlinePeople.text = [NSString stringWithFormat:@"当前在线人数:%@",info.onliePeople];//暂定
    _onlinePeople.adjustsFontSizeToFitWidth = YES;
    _onlinePeople.backgroundColor = [UIColor clearColor];
    _onlinePeople.textAlignment = NSTextAlignmentCenter;
    _onlinePeople.textColor = [UIColor whiteColor];
    _onlinePeople.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_onlinePeople];
    _onlinePeople.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //settting View
    UIButton *settingView = [UIButton buttonWithType:UIButtonTypeCustom];
    settingView.frame = CGRectMake(loginView.frame.size.width+loginView.frame.origin.x + 140, loginView.frame.origin.y - 2, 40, 40);
    [settingView addTarget:self action:@selector(SettingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [settingView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue" ofType:@"png"]] forState:UIControlStateNormal];
    settingView.enabled = NO;
    settingView.alpha = 0.8;
    [self.view addSubview:settingView];
    settingView.autoresizingMask=
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //获取当前在线人数；
    AFHTTPRequestOperationManager *ma = [AFHTTPRequestOperationManager manager];
    ma.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ma GET:GETOnliePeople parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _onlinePeople.text = [NSString stringWithFormat:@"当前在线人数:%@",[[responseObject objectForKey:@"data"] objectForKey:@"count"]];
        UserInfo *info = [UserInfo shareUserInfo];
        info.onliePeople = _onlinePeople.text;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    if ([HttpConnectStatus isConnectToInitnet] == NO) {
        UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前未连接网络！" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [aleart show];
        return;
    }
    
}


//魔方功能视图切换：
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    //NSLog(@"gestuer tap");
    UIView *view = tap.view;
   // NSLog(@"%ld",(long)view.tag);
    if (view.tag == 1) {
        //推出魔方FM视图控制器：
        RL_FMViewController * fmV= [[RL_FMViewController alloc] init];
        fmV.FM_AV = @"瑜伽FM";
        [self.navigationController pushViewController:fmV animated:YES];
    }else if(view.tag == 3){
        //瑜伽TV
        RL_TVViewController *TVV = [[RL_TVViewController alloc] init];
        [self.navigationController pushViewController:TVV animated:YES];

    }else if(view.tag == 7){
        //音频点播
        
        SC_AudioOnLineViewController *audioView = [[SC_AudioOnLineViewController alloc]init];
        audioView.Title = @"音频点播";
        audioView.audio = @"audio";
        
        [self.navigationController pushViewController:audioView animated:YES];
        
   
    }else if (view.tag == 5){
        //瑜伽音乐
        RL_FMViewController * AV= [[RL_FMViewController alloc] init];
        AV.FM_AV = @"魔方音乐台";
        [self.navigationController pushViewController:AV animated:YES];
    }else if (view.tag == 9){
       
            SC_AudioOnLineViewController *audioView = [[SC_AudioOnLineViewController alloc]init];
            audioView.Title = @"视频点播";
            [self.navigationController pushViewController:audioView animated:YES];
        
    }else if(view.tag == 2 || view.tag == 8){
       //KAlert(@"暂未开发");
    }else if ( view.tag == 4 || view.tag == 6){
        
        //KAlert(@"暂未开发");
    }

}

//登陆：
-(void)loginBtnClick
{
     UserInfo *info = [UserInfo shareUserInfo];
    if(info.token.length!=0)
    {
        CountCenterViewController *count = [[CountCenterViewController alloc]init];
        [self.navigationController pushViewController:count animated:YES];
    }else
    {
        RL_LoginViewController *login = [[RL_LoginViewController alloc] init];
        login.fromStr  =@"fromStr";
        [self.navigationController pushViewController:login animated:YES];
    }
}
//设置：
-(void)SettingBtnClick
{
//    RL_SettingViewController *settingV = [[RL_SettingViewController alloc] init];
//    [self presentViewController:settingV animated:YES completion:nil];
    
    //KAlert(@"暂未开发");

}

//生成label方法
-(UILabel *)getLabelWithTitel:(NSString *)title andRect:(CGRect)rect andIsDisable:(BOOL)isDisable
{ 
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = title;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        label.font= [UIFont systemFontOfSize:15];
    }else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        label.font = [UIFont systemFontOfSize:28];
    }
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    if (isDisable) {

        label.textColor = [UIColor colorWithHexString:@"CCCCCC"];

        label.textColor = [UIColor colorWithRed:0.55f green:0.55f blue:0.55f alpha:1.00f];

    }
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;

    return label;
}
//生成背景视图方法
-(UIImageView *)getImageViewWithName:(NSString *)strName andFrame:(CGRect)rect
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:rect];
    imageV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:strName ofType:@"png"]];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    return imageV;
}

//本视图仅支持竖屏：
-(BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0)
{
    return UIInterfaceOrientationPortrait;
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

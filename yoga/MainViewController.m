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

#define GAP_WITH  2.5  //定义白色边框的大小：

@interface MainViewController ()

@end

@implementation MainViewController

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor grayColor];
    
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
    loginView.frame = CGRectMake((self.view.frame.size.width - 80 - 40*2)/2, logoView.frame.origin.y + logoView.frame.size.height + 20, 40, 40);
    [loginView addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue1" ofType:@"png"]] forState:UIControlStateNormal];
    [self.view addSubview:loginView];
    
    //settting View
    UIButton *settingView = [UIButton buttonWithType:UIButtonTypeCustom];
    settingView.frame = CGRectMake(loginView.frame.size.width+loginView.frame.origin.x + 80, logoView.frame.origin.y + logoView.frame.size.height + 20, 40, 40);
    [settingView addTarget:self action:@selector(SettingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [settingView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue" ofType:@"png"]] forState:UIControlStateNormal];
    [self.view addSubview:settingView];
    
}


//魔方功能视图切换：
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"gestuer tap");
    UIView *view = tap.view;
    NSLog(@"%d",view.tag);
    if (view.tag == 1) {
        //推出魔方FM视图控制器：
        RL_FMViewController * fmV= [[RL_FMViewController alloc] init];
        [self presentViewController:fmV animated:YES completion:nil];
    }else if(view.tag == 3){
        //瑜伽TV
        RL_TVViewController *TVV = [[RL_TVViewController alloc] init];
        [self presentViewController:TVV animated:YES completion:nil];
    }else if(view.tag == 4){
        //音频点播
        
        SC_AudioOnLineViewController *audioView = [[SC_AudioOnLineViewController alloc]init];
        audioView.Title = @"音频点播";
        audioView.modalPresentationStyle = UIModalPresentationCustom;
        audioView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:audioView animated:YES completion:nil];
        
    }else if(view.tag == 6){
        //音频点播
        
        SC_AudioOnLineViewController *audioView = [[SC_AudioOnLineViewController alloc]init];
        audioView.Title = @"视屏点播";
        audioView.modalPresentationStyle = UIModalPresentationCustom;
        audioView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:audioView animated:YES completion:nil];
        
    }
    
    
    
    
    
    
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

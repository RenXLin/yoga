//
//  RL_FMViewController.m
//  yoga
//
//  Created by renxlin on 14-7-12.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "RL_FMViewController.h"


#define GAP_WITH  2.5  //定义白色边框的大小：

@interface RL_FMViewController ()

@end

@implementation RL_FMViewController
{
    //当前节目
    UILabel *_currentProgram;
    //当前在线人数
    UILabel *_onlinePeople;
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

    UIScrollView *scrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    scrolView.backgroundColor =[UIColor grayColor];
    
    [self.view addSubview:scrolView];
    
    //自定义导航条
    UIView *nav = [self myNavgationBar:CGRectMake(0, 0, scrolView.frame.size.width, 44) andTitle:@"瑜伽FM"];
    [scrolView addSubview:nav];
    
    
    //添加白色底板
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(5, nav.frame.origin.y + nav.frame.size.height +10, [UIScreen mainScreen].bounds.size.width-10, [UIScreen mainScreen].bounds.size.width-10)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [scrolView addSubview:whiteView];
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
    CGFloat rect_width = (whiteView.frame.size.width - GAP_WITH * 4) / 3;
    for (int i = 0; i < 3 ; i++) {
        for (int j = 0; j < 3; j++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(GAP_WITH *(j + 1) + j * rect_width, GAP_WITH *(i + 1) + i * rect_width , rect_width, rect_width)];
            view.tag = i * 3 + j+1; //(1 2...9)
            view.backgroundColor = [colorArray objectAtIndex:i * 3 +j];
            view.contentMode = UIViewContentModeScaleToFill;
            [whiteView addSubview:view];
        }
    }
    //加入当前节目label
    _currentProgram = [[UILabel alloc] initWithFrame:CGRectMake(0,whiteView.frame.origin.y + whiteView.frame.size.height +30, self.view.frame.size.width, 30)];
    _currentProgram.text = @"瑜伽 FM ————当前无节目";
    _currentProgram.textColor = [UIColor whiteColor];
    _currentProgram.textAlignment = NSTextAlignmentCenter;
    [scrolView addSubview:_currentProgram];
    
    //加入imageView
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 100 )/2, _currentProgram.frame.origin.y +_currentProgram.frame.size.height + 40, 100, 100)];
    imageV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fm" ofType:@"png"]];
    [scrolView addSubview:imageV];
    
    //显示节目菜单按钮
    UIButton *fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fileBtn.frame = CGRectMake(scrolView.frame.size.width - 55, imageV.frame.origin.y, 35, 35);
    [fileBtn setImage:[UIImage imageNamed:@"title_icon4.png"] forState:UIControlStateNormal];
    [scrolView addSubview:fileBtn];
    
    //loginview
    UIButton *loginView = [UIButton buttonWithType:UIButtonTypeCustom];
    loginView.frame = CGRectMake((self.view.frame.size.width - 140 - 40*2)/2, imageV.frame.origin.y + imageV.frame.size.height + 20, 40, 40);
    [loginView addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue1" ofType:@"png"]] forState:UIControlStateNormal];
    [scrolView addSubview:loginView];
    
    //当前在线人数
    _onlinePeople = [[UILabel alloc] initWithFrame:CGRectMake(loginView.frame.size.width + loginView.frame.origin.x, loginView.frame.origin.y, 140, loginView.frame.size.height)];
    _onlinePeople.text = @"当前在线人数：1234";//暂定
    _onlinePeople.adjustsFontSizeToFitWidth = YES;
    _onlinePeople.textAlignment = NSTextAlignmentCenter;
    _onlinePeople.textColor = [UIColor whiteColor];
    [scrolView addSubview:_onlinePeople];
    
    //settting View
    UIButton *settingView = [UIButton buttonWithType:UIButtonTypeCustom];
    settingView.frame = CGRectMake(loginView.frame.size.width+loginView.frame.origin.x + 140, imageV.frame.origin.y + imageV.frame.size.height + 20, 40, 40);
    [settingView addTarget:self action:@selector(SettingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [settingView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue" ofType:@"png"]] forState:UIControlStateNormal];
    [scrolView addSubview:settingView];

    
    scrolView.contentSize = CGSizeMake(self.view.frame.size.width, settingView.frame.origin.y + settingView.frame.size.height + 10);
    scrolView.bounces = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loginBtnClick
{

}
-(void)SettingBtnClick
{
    
    
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
    
    //分享：
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(view.frame.size.width - 30, 2, 35, view.frame.size.height-4);
    [share setImage:[UIImage imageNamed:@"title_icon1.png"] forState:UIControlStateNormal];
    [view addSubview:share];
    
    //好评数
    UILabel *goodTimes = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width - share.frame.size.width - 45, 2, 45, rect.size.height)];
    goodTimes.text = @"123";//暂定
    goodTimes.adjustsFontSizeToFitWidth = YES;
    goodTimes.textColor = [UIColor whiteColor];
    [view addSubview:goodTimes];

    //点赞
    UIButton *good = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    good.frame = CGRectMake(view.frame.size.width - goodTimes.frame.size.width - share.frame.size.width - 35, 0, 35, view.frame.size.height);
    [good setImage:[UIImage imageNamed:@"title_icon2.png"] forState:UIControlStateNormal];
    [good setImage:[UIImage imageNamed:@"title_icon2_1.png"] forState:UIControlStateHighlighted];
    [view addSubview:good];
    
    return view;
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

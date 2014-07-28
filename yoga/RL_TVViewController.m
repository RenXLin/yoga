//
//  RL_TVViewController.m
//  yoga
//
//  Created by renxlin on 14-7-12.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "RL_TVViewController.h"
#import "MarqueeLabel.h"
#import "AFNetworking.h"
#import "CurrentProgram.h"


@interface RL_TVViewController ()
{
    VMediaPlayer *_mMpayer;
}

@end

@implementation RL_TVViewController
{
    //当前广告
     MarqueeLabel *_ad;
    //当前在线人数
    UILabel *_onlinePeople;
    //存储当前节目数据类型实例
    CurrentProgram *_programMode;
    
    UIScrollView *_scrollView;
    
    UIView *_TVPlayView;
    
    NSMutableArray *_fileList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)to duration:(NSTimeInterval)duration
{
	if (UIInterfaceOrientationIsLandscape(to)) {
        
        [_TVPlayView removeFromSuperview];
        [_scrollView removeFromSuperview];
        _TVPlayView.frame = self.view.bounds;
        [self.view addSubview:_TVPlayView];
        
        NSLog(@"%@",NSStringFromCGRect(_TVPlayView.frame));
        
	} else {
        
        [_TVPlayView removeFromSuperview];
        _TVPlayView.frame = CGRectMake(1, 70, self.view.frame.size.width, self.view.frame.size.width *3/4);
        [_scrollView addSubview:_TVPlayView];
        [self.view addSubview:_scrollView];
        
	}
	NSLog(@"NAL 1HUI &&&&&&&&& frame=%@", NSStringFromCGRect(self.view.frame));
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPeople) name:NOT_refreshOnlinePeople object:nil];

    self.view.backgroundColor = [UIColor blackColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    _scrollView.backgroundColor =[UIColor grayColor];
    
    [self.view addSubview:_scrollView];
    
    //自定义导航条
    UIView *nav = [self myNavgationBar:CGRectMake(0, 0, _scrollView.frame.size.width, 44) andTitle:@"瑜伽TV"];
    [_scrollView addSubview:nav];
    
    //添加视频播放视图
    _TVPlayView = [[UIView alloc] initWithFrame:CGRectMake(2, 70, self.view.frame.size.width-4, self.view.frame.size.width * 3 / 4)];
    _TVPlayView.backgroundColor = [UIColor blackColor];
//    TVPlayView.alpha = 0.2;
    [_scrollView addSubview:_TVPlayView];
    
    //当前节目
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_TVPlayView.frame.origin.y + _TVPlayView.frame.size.height +30, self.view.frame.size.width, 30)];
    titleLabel.text = @"瑜伽 TV ";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:titleLabel];
    
    //加入imageView
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 100 )/2, titleLabel.frame.origin.y +titleLabel.frame.size.height + 20, 100, 100)];
    imageV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"]];
    [_scrollView addSubview:imageV];
    
    //显示节目菜单按钮
    UIButton *fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fileBtn.frame = CGRectMake(_scrollView.frame.size.width - 55, imageV.frame.origin.y, 35, 35);
    [fileBtn setImage:[UIImage imageNamed:@"title_icon4.png"] forState:UIControlStateNormal];
    [_scrollView addSubview:fileBtn];
    [fileBtn addTarget:self action:@selector(getCurrentFile) forControlEvents:UIControlEventTouchUpInside];
    
    //加入当前节目label 走马灯显示
    _ad = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0,imageV.frame.origin.y + imageV.frame.size.height +30, self.view.frame.size.width, 30) rate:50.0f andFadeLength:10.0f];
    _ad.numberOfLines = 1;
    _ad.opaque = NO;
    _ad.enabled = YES;
    _ad.shadowOffset = CGSizeMake(0.0, -1.0);
    _ad.textAlignment = NSTextAlignmentCenter;
    _ad.textColor = [UIColor whiteColor];
    _ad.backgroundColor = [UIColor clearColor];
    _ad.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.000];
    _ad.text = @" 当 前 无 节 目         当 前 无 节 目          当 前 无 节 目          当 前 无 节 目";
    [_scrollView addSubview:_ad];
    
    // logoView
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 150 )/2, _ad.frame.origin.y +_ad.frame.size.height + 30, 150, 40)];
    logoView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
    [_scrollView addSubview:logoView];
    
    //loginview
    UIButton *loginView = [UIButton buttonWithType:UIButtonTypeCustom];
    loginView.frame = CGRectMake((self.view.frame.size.width - 140 - 40*2)/2, logoView.frame.origin.y + logoView.frame.size.height + 20, 40, 40);
    [loginView addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue1" ofType:@"png"]] forState:UIControlStateNormal];
    [_scrollView addSubview:loginView];
    
    //当前在线人数
    _onlinePeople = [[UILabel alloc] initWithFrame:CGRectMake(loginView.frame.size.width + loginView.frame.origin.x, loginView.frame.origin.y, 140, loginView.frame.size.height)];
    UserInfo *info = [UserInfo shareUserInfo];
    _onlinePeople.text = info.onliePeople;//暂定
    _onlinePeople.adjustsFontSizeToFitWidth = YES;
    _onlinePeople.textAlignment = NSTextAlignmentCenter;
    _onlinePeople.textColor = [UIColor whiteColor];
    
    //settting View
    UIButton *settingView = [UIButton buttonWithType:UIButtonTypeCustom];
    settingView.frame = CGRectMake(loginView.frame.size.width+loginView.frame.origin.x + 140, logoView.frame.origin.y + logoView.frame.size.height + 20, 40, 40);
    [settingView addTarget:self action:@selector(SettingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [settingView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue" ofType:@"png"]] forState:UIControlStateNormal];
    [_scrollView addSubview:settingView];
    
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, settingView.frame.origin.y + settingView.frame.size.height + 10);
    _scrollView.bounces = NO;

    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:CURRENTPLAYVIDEO_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success:%@",responseObject);
        _programMode = [[CurrentProgram alloc] init];
        [_programMode setValuesForKeysWithDictionary:[responseObject objectForKey:@"data"]];
        _ad.text = _programMode.ad;
        NSString *urlStr = [self removeSpace:_programMode.path];
        //加入FM播放器：
        if (!_mMpayer && urlStr) {
            _mMpayer = [VMediaPlayer sharedInstance];
            [_mMpayer setupPlayerWithCarrierView:_TVPlayView withDelegate:self];
            [_mMpayer setDataSource:[NSURL URLWithString:urlStr] header:nil];
            [_mMpayer prepareAsync];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed:%@",error);
        
    }];
    
}

-(NSString *)removeSpace:(NSString *)str
{
    NSArray *arr = [str componentsSeparatedByString:@" "];
    NSString *resultStr = [arr componentsJoinedByString:@"%20"];
    return resultStr;
}

#pragma mark VMediaPlayerDelegate methods Required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    [player start];
    NSLog(@"start>>>>>>>>>>>>");
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    NSLog(@"player complete");
    [player reset];
    [player unSetupPlayer];
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
	NSLog(@"player error");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)backBtnClick
{
    [_mMpayer reset];
    [_mMpayer unSetupPlayer];

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

//获取当天节目列表:
-(void)getFileList
{
    [self getCurrentFile];
}
-(void)getCurrentFile
{
    if (!_fileList) {
        _fileList = [[NSMutableArray alloc] init];
    }
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:GetOneDayFMfile_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success:%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed:%@",error);
    }];
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

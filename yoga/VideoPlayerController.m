//
//  VideoPlayerController.m
//  yoga
//
//  Created by renxlin on 14-7-16.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "VideoPlayerController.h"
#import "RL_LoginViewController.h"
#import "CountCenterViewController.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "MarqueeLabel.h"
#import "AFNetworking.h"
#import "CurrentProgram.h"
#import "MedioPlayTool.h"
#import "UMSocial.h"
#import "UIImageView+AFNetworking.h"
#import <AVFoundation/AVFoundation.h>

#define GAP_WITH    0


@interface VideoPlayerController ()<UIGestureRecognizerDelegate,UMSocialUIDelegate>
{
    UIScrollView *_scrollView;
    UIView *_carryView_portrait;
    UIView *_carryView_landscape;
    VMediaPlayer *_mPlayer;
    MedioPlayTool *_mTools;
    NSTimer *_seekTimser;
    UIActivityIndicatorView *_activityView;
    long _duration;
    BOOL isFullScreen;
    UILabel *goodTimes;
    BOOL _fullTOfull;
    BOOL _isCanChangeProgrom;
}
@end

@implementation VideoPlayerController
{
    //当前广告
    MarqueeLabel *_ad;
    //当前在线人数
    UILabel *_onlinePeople;
    //存储当前节目数据类型实例
    CurrentProgram *_programMode;
    
    UIView *_TVPlayView;
    NSArray *_urlDic;
    
    long lastDuration;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)shouldAutorotate
{
    if ([self.titleName isEqualToString:@"音频点播"]) {
        return NO;
    }
    return YES;
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
        [_scrollView removeFromSuperview];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];

        if (isFullScreen == NO) {
//            从纵屏的状态转向横屏：
            
            //非全屏的时候选择切换全屏：

            [_TVPlayView removeFromSuperview];
            _TVPlayView.frame = self.view.bounds;
            [self.view addSubview:_TVPlayView];
            [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon4" ofType:@"png"]] forState:UIControlStateNormal];
            [_TVPlayView addSubview:_mTools];
            _mTools.frame = CGRectMake(0, _TVPlayView.frame.size.height - 60, _TVPlayView.frame.size.width, 60);
            
        }else{
            //已经旋转了视图，全屏显示视图，但未横过来，用户旋转成横向视频：
            
            _mTools.isHidden = NO;
//            _mTools.hidden = NO;
            _fullTOfull = YES;
            
            _TVPlayView.transform = CGAffineTransformRotate(_TVPlayView.transform, -M_PI_2);
            [_TVPlayView removeFromSuperview];
            _TVPlayView.frame = self.view.bounds;
            
            [self.view addSubview:_TVPlayView];
            _mTools.frame = CGRectMake(0, _TVPlayView.frame.size.height - 60, _TVPlayView.frame.size.width, 60);

        }
        
	}
    else if(UIInterfaceOrientationIsPortrait(to)){
//            从横屏的状态转向纵屏：（不管原来的状态均变为非全屏）
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.view addSubview:_scrollView];

        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7) {
            _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 20);
            if (_fullTOfull) {
                _fullTOfull = NO;
                _scrollView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 0);
            }
        }else
        {
            _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- 20);
        }
        
        _mTools.hidden = NO;
        isFullScreen = NO;
        [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon3" ofType:@"png"]] forState:UIControlStateNormal];
        
        [_TVPlayView removeFromSuperview];
        [_mTools removeFromSuperview];
        
        _TVPlayView.frame = CGRectMake(1, 50, self.view.frame.size.width, self.view.frame.size.width * self.view.frame.size.width / self.view.frame.size.height);
        [_scrollView addSubview:_TVPlayView];
        
        
        _mTools.frame = CGRectMake(0, _TVPlayView.frame.size.height + _TVPlayView.frame.origin.y, _TVPlayView.frame.size.width, 60);
        [_scrollView addSubview:_mTools];
	}

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	NSLog(@"NAL 2HUI &&&&&&&&& frame=%@", NSStringFromCGRect(self.view.frame));
}

//刷新在线人数 method
-(void)refreshPeople
{
    UserInfo *info =[UserInfo shareUserInfo];
    _onlinePeople.text = info.onliePeople;
}

-(void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.titleName isEqualToString:@"音频点播"]) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }else {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    self.navigationController.navigationBarHidden = YES;
    _isCanChangeProgrom = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOT_refreshOnlinePeople object:nil];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self greet];
    _itemMode = [_sourceArray objectAtIndex:_index];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPeople) name:NOT_refreshOnlinePeople object:nil];
    
    self.view.autoresizesSubviews = YES;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
    }else{
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 20)];
    }
    _scrollView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_scrollView];
    _scrollView.autoresizesSubviews = YES;
    _scrollView.autoresizingMask =
//    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //自定义导航条
    UIView *nav;
//    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) {
//        nav = [self myNavgationBar:CGRectMake(0, 0, _scrollView.frame.size.width, 44) andTitle:self.titleName];
//    }else
    {
        nav = [self myNavgationBar:CGRectMake(0, 0, _scrollView.frame.size.width, 44) andTitle:self.titleName];
        nav.tag = 222;
    }
    [_scrollView addSubview:nav];
    nav.autoresizingMask=
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //添加负载播放器和进度条视图；
    _carryView_portrait = [[UIView alloc] initWithFrame:CGRectMake(2, 50, self.view.frame.size.width, 250)];
    _carryView_portrait.backgroundColor = [UIColor blackColor];
//    [_scrollView addSubview:_carryView_portrait];
    _carryView_portrait.autoresizesSubviews = YES;
    
    //添加视频播放视图
    _TVPlayView = [[UIView alloc] initWithFrame:CGRectMake(1, 50, self.view.frame.size.width, self.view.frame.size.width * self.view.frame.size.width / self.view.frame.size.height)];
    _TVPlayView.backgroundColor = [UIColor blackColor];
    _TVPlayView.userInteractionEnabled = YES;
    _TVPlayView.autoresizesSubviews = YES;
    [_scrollView addSubview:_TVPlayView];
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
						  UIActivityIndicatorViewStyleWhiteLarge];
	[_TVPlayView addSubview:_activityView];
    _activityView.center = _TVPlayView.center;
    _activityView.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    _TVPlayView.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    UITapGestureRecognizer *signleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTap)];
    signleTap.numberOfTapsRequired = 1;
    [_TVPlayView addGestureRecognizer:signleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [_TVPlayView addGestureRecognizer:doubleTap];
    
    if ([self.titleName isEqualToString:@"音频点播"]) {
        
        _TVPlayView.frame = CGRectMake(1, 70, self.view.frame.size.width, self.view.frame.size.width);
        _TVPlayView.tag = 5000;
        
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
        
        CGFloat rect_width = (_TVPlayView.frame.size.width - GAP_WITH * 4 ) / 3;
        for (int i = 0; i < 3 ; i++) {
            
            for (int j = 0; j < 3; j++) {
                UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(GAP_WITH *(j + 1) + (j) * rect_width, GAP_WITH *(i + 1) + i * rect_width , rect_width, rect_width)];
                view.tag = i * 3 + j + 200; //(0 1 2...8)
                view.backgroundColor = [colorArray objectAtIndex:i * 3 +j];
                view.contentMode = UIViewContentModeScaleToFill;
                [_TVPlayView addSubview:view];
                
                view.layer.borderColor = [UIColor whiteColor].CGColor;
                view.layer.borderWidth = 3;
                view.autoresizingMask =
                UIViewAutoresizingFlexibleLeftMargin |
                UIViewAutoresizingFlexibleRightMargin |
                UIViewAutoresizingFlexibleWidth;
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picTap:)];
                view.userInteractionEnabled = YES;
                [view addGestureRecognizer:tap];
            }
        }
        [self getPNGurl];
    }
    //添加工具条：
//    if ([self.titleName isEqualToString:@"音频点播"])
    {
        _mTools = [[MedioPlayTool alloc] initWithFrame:CGRectMake(0, _TVPlayView.frame.origin.y+_TVPlayView.frame.size.height , _TVPlayView.frame.size.width, 60)];
    }
//    else
//    {
//        _mTools = [[MedioPlayTool alloc] initWithFrame:CGRectMake(0, _TVPlayView.frame.size.height - 60, _TVPlayView.frame.size.width, 60)];
//    }

    [_mTools setBtnDelegate:self andSEL:@selector(playSettingChange:) andSliderSel:@selector(sliderChange:) andTapGesture:@selector(tapGesture:)];
    _mTools.tag = 10;
    _mTools.autoresizingMask =
//    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
//    if ([self.titleName isEqualToString:@"音频点播"])
    {
        [_scrollView addSubview:_mTools];
    }
//    else
//    {
//        [_TVPlayView addSubview:_mTools];
//    }
    
    //当前节目
    UILabel * titleLabel;
//    if ([self.titleName isEqualToString:@"音频点播"])
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_mTools.frame.origin.y + _mTools.frame.size.height + 5, self.view.frame.size.width, 30)];
    }
//    else{
//        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_TVPlayView.frame.origin.y + _TVPlayView.frame.size.height + 5, self.view.frame.size.width, 30)];
//    }
    titleLabel.text = self.titleName;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:titleLabel];
//    titleLabel.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
//    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleWidth;
    
    //加入imageView
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 80 )/2, titleLabel.frame.origin.y +titleLabel.frame.size.height, 80, 80)];
    
    if ([self.titleName isEqualToString:@"音频点播"]) {
        imageV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fm" ofType:@"png"]];
        imageV.frame = CGRectMake((self.view.frame.size.width - 60 )/2, titleLabel.frame.origin.y +titleLabel.frame.size.height, 60, 60);
        [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon" ofType:@"png"]] forState:UIControlStateNormal];

    }else{
        imageV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"333" ofType:@"png"]];
        [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon3" ofType:@"png"]] forState:UIControlStateNormal];

    }
    
    [_scrollView addSubview:imageV];
//    imageV.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
//    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleWidth;
    
    
    //加入当前节目label 走马灯显示
    _ad = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0,imageV.frame.origin.y + imageV.frame.size.height + 5, self.view.frame.size.width, 30) rate:50.0f andFadeLength:10.0f];
    _ad.numberOfLines = 1;
    _ad.opaque = NO;
    _ad.enabled = YES;
    _ad.shadowOffset = CGSizeMake(0.0, -1.0);
    _ad.textAlignment = NSTextAlignmentCenter;
    _ad.textColor = [UIColor whiteColor];
    _ad.backgroundColor = [UIColor clearColor];
    _ad.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.500];
    _ad.text = [NSString stringWithFormat:@"%@                        %@                           %@",_itemMode.ad,_itemMode.ad,_itemMode.ad];
    [_scrollView addSubview:_ad];
//    _ad.autoresizingMask =
//    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
//    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleWidth;
    
    // logoView
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 150 )/2, _ad.frame.origin.y +_ad.frame.size.height , 150, 45)];
    logoView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
    [_scrollView addSubview:logoView];
//    logoView.autoresizingMask =
//    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
//    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleWidth;
    
    //loginview
    UIButton *loginView = [UIButton buttonWithType:UIButtonTypeCustom];
    loginView.frame = CGRectMake((self.view.frame.size.width - 140 - 40*2)/2, logoView.frame.origin.y + logoView.frame.size.height + 5, 40, 40);
    loginView.alpha = 0.8;
    loginView.enabled = NO;
    [loginView addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue1" ofType:@"png"]] forState:UIControlStateNormal];
    [_scrollView addSubview:loginView];
//    loginView.autoresizingMask =
//    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
//    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleWidth;
    
    //当前在线人数
    _onlinePeople = [[UILabel alloc] initWithFrame:CGRectMake(loginView.frame.size.width + loginView.frame.origin.x, loginView.frame.origin.y, 140, loginView.frame.size.height)];
    UserInfo *info = [UserInfo shareUserInfo];
    _onlinePeople.text = info.onliePeople;//暂定
    _onlinePeople.backgroundColor = [UIColor clearColor];
    _onlinePeople.adjustsFontSizeToFitWidth = YES;
    _onlinePeople.font = [UIFont systemFontOfSize:15];
    _onlinePeople.textAlignment = NSTextAlignmentCenter;
    _onlinePeople.textColor = [UIColor whiteColor];
    [_scrollView addSubview:_onlinePeople];
//    _onlinePeople.autoresizingMask =
//    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
//    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleWidth;
    
    
    //settting View
    UIButton *settingView = [UIButton buttonWithType:UIButtonTypeCustom];
    settingView.frame = CGRectMake(loginView.frame.size.width+loginView.frame.origin.x + 140, logoView.frame.origin.y + logoView.frame.size.height + 3, 40, 40);
    [settingView addTarget:self action:@selector(SettingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    settingView.alpha = 0.8;
    settingView.enabled = NO;
    [settingView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue" ofType:@"png"]] forState:UIControlStateNormal];
    [_scrollView addSubview:settingView];
//    settingView.autoresizingMask =
//    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
//    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleWidth;
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, settingView.frame.origin.y + settingView.frame.size.height + 10);
    _scrollView.bounces = NO;
    
//    NSString *urlStr = [self removeSpace:self.itemMode.path];
//    NSString * urlStr = [self.itemMode.path stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    
    if ([HttpConnectStatus isConnectToInitnet] == NO) {
        UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前未连接网络！" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [aleart show];
        return;
    }
    

    NSString * pathUrl = [self.itemMode.path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString * urlStr = UrlEncodedString(pathUrl);
    NSLog(@"encode url :  %@",urlStr);
    
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];

    if (!_mPlayer) {
        [_activityView startAnimating];
        _mPlayer = [VMediaPlayer sharedInstance];
        [_mPlayer setupPlayerWithCarrierView:_TVPlayView withDelegate:self];
        if ([self.titleName isEqualToString:@"音频点播"]) {
            [_mPlayer setDataSource:[NSURL URLWithString:urlStr] header:nil];
        }else{
            [_mPlayer setDataSource:[NSURL URLWithString:pathUrl] header:nil];
        }
        NSLog(@"%@",self.itemMode.path);
        [_mPlayer prepareAsync];
    }
}

#pragma mark 请求获取九宫格图片url
-(void)getPNGurl
{
    AFHTTPRequestOperationManager *pngMg = [[AFHTTPRequestOperationManager alloc] init];
    pngMg.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [pngMg GET:GETPickAudioPng_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        _urlDic = [responseObject objectForKey:@"data"];
        for (int i = 0; i < [_urlDic count]; i++) {
            NSDictionary *pngUrlDic = [_urlDic objectAtIndex:i];
            UIImageView *imgV = (UIImageView *)[_TVPlayView viewWithTag:(i+200)];
            
            NSURL *url;
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
                url = [NSURL URLWithString:[pngUrlDic objectForKey:@"small"]];
            }else{
                url = [NSURL URLWithString:[pngUrlDic objectForKey:@"big"]];
            }

            if ([imgV isKindOfClass:[UIImageView class]]) {
                [imgV setImageWithURL:url placeholderImage:nil];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed: %@",error);
        
    }];
}
-(void)picTap:(UITapGestureRecognizer *)tap
{
    UIView *view = tap.view;
    UIImageView *bigImag = [[UIImageView alloc] initWithFrame:_TVPlayView.bounds];
    [bigImag setImageWithURL:[NSURL URLWithString:[[_urlDic objectAtIndex:(view.tag - 200)] objectForKey:@"big"]] placeholderImage:nil];
    UITapGestureRecognizer *Bigtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigPicTap:)];
    bigImag.userInteractionEnabled = YES;
    [bigImag addGestureRecognizer:Bigtap];
    [_TVPlayView addSubview:bigImag];
    
    _mTools.isHidden = NO;
    _mTools.hidden = NO;
    [_TVPlayView bringSubviewToFront:_mTools];

}
-(void)bigPicTap:(UITapGestureRecognizer *)tap
{
    [tap.view removeFromSuperview];
    
    _mTools.isHidden = NO;
    _mTools.hidden = NO;
    [_TVPlayView bringSubviewToFront:_mTools];

}

NSString* UrlEncodedString(NSString* sourceText)
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)sourceText,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    return result;
}

-(void)signleTap
{
    if (_mTools.isHidden &&
        (isFullScreen ||
         [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft ||
         [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight)) {
        _mTools.isHidden = NO;
        _mTools.hidden = NO;
        
    }else if( !_mTools.isHidden &&
             (isFullScreen ||
              [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft ||
              [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight)){
        _mTools.isHidden = YES;
        _mTools.hidden = YES;
    }
}
-(void)doubleTap
{

    if ([self.titleName isEqualToString:@"视频点播"]) {

        NSLog(@"%d",self.interfaceOrientation);
    
        if (isFullScreen == NO && (
            self.interfaceOrientation == UIInterfaceOrientationPortrait ||
            self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            )) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];

            isFullScreen = YES;
            
            [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon4" ofType:@"png"]] forState:UIControlStateNormal];
            [_TVPlayView removeFromSuperview];
            [_scrollView removeFromSuperview];
            
            _TVPlayView.frame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
            
            [_mTools removeFromSuperview];
            _mTools.frame = CGRectMake(0, _TVPlayView.frame.size.height - 60, _TVPlayView.frame.size.width, 60);
            [_TVPlayView addSubview:_mTools];
            
            [self.view addSubview:_TVPlayView];
            _TVPlayView.center = self.view.center;
            
            _TVPlayView.transform = CGAffineTransformRotate(_TVPlayView.transform, M_PI_2);
            

        }else{
            if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
                 self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                return;
            }
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

            NSLog(@"非全屏播放");
            isFullScreen = NO;
            _mTools.isHidden = NO;
            _mTools.hidden = NO;
            
            [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon3" ofType:@"png"]] forState:UIControlStateNormal];
            
            _TVPlayView.transform = CGAffineTransformRotate(_TVPlayView.transform, -M_PI_2);
            [_TVPlayView removeFromSuperview];
            _TVPlayView.frame = CGRectMake(1, 50, self.view.frame.size.width, self.view.frame.size.width * self.view.frame.size.width / self.view.frame.size.height);
            [_scrollView addSubview:_TVPlayView];
           
            
            [self.view addSubview:_scrollView];
            if ([[UIDevice currentDevice].systemVersion floatValue] >= 7) {
                _scrollView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height -20);
            }else{
                _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 20);
            }
            
            [_mTools removeFromSuperview];
            _mTools.frame = CGRectMake(0, _TVPlayView.frame.origin.y+_TVPlayView.frame.size.height , _TVPlayView.frame.size.width, 60);
            [_scrollView addSubview:_mTools];

        }
    }
}
#pragma mark VMediaPlayerDelegate methods Required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{

    [SVProgressHUD dismiss];
    
    NSLog(@"start>>>>>>>>>>>>");
    lastDuration = 0;
    _duration  = [player getDuration];
    long second = _duration / 1000;
    
    int hour = second / (60 * 60);
    int min = second % 3600 /60;
    int sec = second % 3600 % 60;
    
    _mTools.totalPlay.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];
    [player start];
    [_activityView stopAnimating];
    _seekTimser = [NSTimer scheduledTimerWithTimeInterval:1.0/3 target:self selector:@selector(syncUIStatus) userInfo:nil repeats:YES];
    
    _isCanChangeProgrom = YES;

    if ([self.titleName isEqualToString:@"音频点播"]) {
        return;
    }
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    NSLog(@"player complete");
    [_mPlayer reset];
    [player unSetupPlayer];
    _mPlayer = nil;
    
    
    NSString * pathUrl = [self.itemMode.path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString * urlStr = UrlEncodedString(pathUrl);
    NSLog(@"encode url :  %@",urlStr);
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    _isCanChangeProgrom = YES;
    
    [self playLastOrNextProgram];
    

}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
	NSLog(@"player error %@",arg);
    UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"提示" message:@"播放失败！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [aleart show];
    
    _isCanChangeProgrom = YES;

}

- (void)mediaPlayer:(VMediaPlayer *)player seekComplete:(id)arg
{
    NSLog(@"跳转完成！");
    [_activityView stopAnimating];
    [_mPlayer start];
}
#pragma mark 定时更新进度条：
-(void)syncUIStatus
{
    long current;
    static int aaa = 0;
    current = [_mPlayer getCurrentPosition];
    
    NSLog(@">>>>>>>>>>%ld  , %ld",current,lastDuration);
    if (current == -1 && lastDuration ==-1) {
        aaa ++;
        if (aaa > 50) {
            aaa=0;
            _isCanChangeProgrom = YES;
            
            [self playLastOrNextProgram];

        }
    }else{
        aaa = 0;
    }
    NSLog(@"%d",aaa);
    if (current > lastDuration)
    {

        if (current - lastDuration > 5000) {
            if (current>lastDuration) {
                lastDuration = current;
            }
            return;
        }

        float precrnt = (float)current / _duration;
        _mTools.playProgress.value = precrnt;
       
        long second = current / 1000;
        
        int hour = second / (60 * 60);
        int min = second % 3600 /60;
        int sec = second % 3600 % 60;
        
        _mTools.havePlay.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];
        
    }else{
    
        lastDuration = current;
    
    }
   
}

-(void)stopPlayMedio
{
    [_mPlayer reset];
    
}
-(void)tapGesture:(UIGestureRecognizer *)g
{
    //跳跃点击
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted)
        return;
    CGPoint pt = [g locationInView:s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    long seek = percentage * _duration;
	NSLog(@"seek = %ld", seek);
	[_activityView startAnimating];
    [_mPlayer seekTo:seek];
}
-(void)sliderChange:(UISlider*)slider
{
    //拖到
    [_activityView startAnimating];
    long seek = _duration * slider.value;
    [_mPlayer seekTo:seek];
    
    
}
-(void)playSettingChange:(UIButton *)btn
{
    NSLog(@"%ld",(long)btn.tag);
    if (btn.tag == 1) {

        //当为视频界面时切换全屏
        if ([self.titleName isEqualToString:@"视频点播"]) {
            [self doubleTap];
        }else{
            //音频界面；
            _mTools.fullScreenOrNot.selected = !_mTools.fullScreenOrNot.selected;
            
            [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon" ofType:@"png"]] forState:UIControlStateNormal];
            
            [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon1" ofType:@"png"]] forState:UIControlStateSelected];
        }

        
    }else if (btn.tag == 2){
        //last program
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            [SVProgressHUD showWithStatus:@"上一节目！"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//            });
        }
        if (_index > 0) {
            _index --;
        }else{
            _index = [_sourceArray count] - 1;
        }
        _itemMode = [_sourceArray objectAtIndex:_index];
        [self playLastOrNextProgram];

    }else if (btn.tag == 3){
        //play or pause
        btn.selected = !btn.selected;
        
        if ([_mPlayer isPlaying]) {
            [btn setSelected:YES];

            [_mPlayer pause];
        }else{
            [btn setSelected:NO];

            [_mPlayer start];
        }
        
    }else if (btn.tag == 4){
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            [SVProgressHUD showWithStatus:@"下一节目！"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//            });
        }

        //next program
        if (_index < [_sourceArray count] - 1) {
            _index ++;
        }else{
            _index = 0;
        }
        _itemMode = [_sourceArray objectAtIndex:_index];
        
        [self playLastOrNextProgram];
        
    }
}
-(void)playLastOrNextProgram
{
    
    if (!_isCanChangeProgrom) {
        return;
    }
    _isCanChangeProgrom = NO;
    
    NSString * pathUrl = [self.itemMode.path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString * urlStr = UrlEncodedString(pathUrl);
    NSLog(@"encode url :  %@",urlStr);
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
//    _mPlayer = [VMediaPlayer sharedInstance];
    [_mPlayer reset];
    [_mPlayer unSetupPlayer];
    [_mPlayer setupPlayerWithCarrierView:_TVPlayView withDelegate:self];
    if ([self.titleName isEqualToString:@"音频点播"]) {
        [_mPlayer setDataSource:[NSURL URLWithString:urlStr] header:nil];
    }else{
        [_mPlayer setDataSource:[NSURL URLWithString:pathUrl] header:nil];
    }
    NSLog(@"%@",self.itemMode.path);
    [_mPlayer prepareAsync];

}

-(void)videoPause
{
    if ([_mPlayer isPlaying]) {
        [_mPlayer pause];
    }
}
-(void)videoStart
{
    if (_mPlayer) {
        [_mPlayer start];
    }
}
-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
            //			if ([mMPayer isPlaying]) {
            //				[mMPayer pause];
            //			} else {
            //				[mMPayer start];
            //			}
			break;
		case UIEventSubtypeRemoteControlPlay:
            //			[mMPayer start];
			break;
		case UIEventSubtypeRemoteControlPause:
            //			[mMPayer pause];
			break;
		case UIEventSubtypeRemoteControlPreviousTrack:
            //			[self prevButtonAction:nil];
			break;
		case UIEventSubtypeRemoteControlNextTrack:
            //			[self nextButtonAction:nil];
			break;
		default:
			break;
	}
}

-(void)backBtnClick
{
    [_mPlayer reset];
    [_mPlayer unSetupPlayer];
    _mPlayer = nil;
    [_seekTimser invalidate];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

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
-(void)SettingBtnClick
{
    
    
}
-(UIView *)myNavgationBar:(CGRect)rect andTitle:(NSString *)tit
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title.png"]];
    view.autoresizesSubviews = YES;

    //back button
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(2, 0, 40, view.frame.size.height);
    [back addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"title_icon.png"] forState:UIControlStateNormal];
    [view addSubview:back];
    
    //title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(back.frame.size.width, 0, 100, rect.size.height)];
    title.text = tit;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    [view addSubview:title];
    
    //分享：
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(view.frame.size.width - 40, 2, 35, view.frame.size.height-4);
    [share setImage:[UIImage imageNamed:@"title_icon1.png"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(TitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    share.tag = 1;
    [view addSubview:share];
    share.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
    //好评数
   goodTimes = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width - share.frame.size.width - 45, 2, 45, rect.size.height)];
    goodTimes.textAlignment = NSTextAlignmentCenter;
    goodTimes.adjustsFontSizeToFitWidth = YES;
    goodTimes.textColor = [UIColor whiteColor];
    [view addSubview:goodTimes];
    goodTimes.backgroundColor = [UIColor clearColor];
    goodTimes.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;

    //点赞
    UIButton *good = [UIButton buttonWithType:UIButtonTypeCustom];
    good.frame = CGRectMake(view.frame.size.width - goodTimes.frame.size.width - share.frame.size.width - 35, 0, 35, view.frame.size.height);
    [good setImage:[UIImage imageNamed:@"title_icon2.png"] forState:UIControlStateNormal];
    [good setImage:[UIImage imageNamed:@"title_icon2_1.png"] forState:UIControlStateHighlighted];
    [good addTarget:self action:@selector(TitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    good.tag= 2;
    [view addSubview:good];
    good.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;

    return view;
}


-(void)TitleBtnClick:(UIButton *)btn
{
   
    if (btn.tag == 1) {
        NSString *shareStr = [NSString stringWithFormat:@"分享一款实用和内容丰富的瑜伽APP《瑜伽魔方》，这里有我喜欢的%@:%@", self.audoOrNot,_itemMode.title];
        
        NSLog(@"%@",shareStr);

        //分享
       // [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"http://www.chinayogaonline.com/upload/ad/001.jpg"];
        
        //自定义各平台分享内容：
        //[UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@http://www.chinayogaonline.com/app",shareStr];
        
        
        //[UMSocialData defaultData].extConfig.sinaData.shareImage = [UIImage imageNamed:@"icon.png"]; //分享到新浪微博图片
        
         [[UMSocialData defaultData].extConfig.sinaData.urlResource setResourceType:UMSocialUrlResourceTypeDefault url:@"http://www.chinayogaonline.com/app"];
        
        
        [UMSocialData defaultData].extConfig.tencentData.shareImage = [UIImage imageNamed:@"icon.png"]; //分享到腾讯微博图片
        [UMSocialData defaultData].extConfig.tencentData.shareText = shareStr;
        
        [UMSocialData defaultData].extConfig.doubanData.shareImage = [UIImage imageNamed:@"icon.png"]; //分享到豆瓣
        [UMSocialData defaultData].extConfig.doubanData.shareText = shareStr;
        
//        [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource setResourceType:UMSocialUrlResourceTypeVideo url:_programMode.path];  //设置微信好友分享url图片
//        [[UMSocialData defaultData].extConfig.wechatTimelineData.urlResource setResourceType:UMSocialUrlResourceTypeVideo url:_programMode.path]; //设置微信朋友圈分享视频
//        //设置wx分享类型
        
       
        [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
        
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title = shareStr;
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.title=shareStr;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url=nil;
        
        [UMSocialData defaultData].extConfig.sinaData.urlResource.url=nil;
        
        //qq
        
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
        [UMSocialData defaultData].extConfig.qqData.title = shareStr;
        [UMSocialData defaultData].extConfig.qqData.shareImage = [UIImage imageNamed:@"icon.png"];
        [UMSocialData defaultData].extConfig.qqData.urlResource.url=nil;
        
        [UMSocialData defaultData].extConfig.qzoneData.title=shareStr;
        [UMSocialData defaultData].extConfig.qzoneData.shareImage = [UIImage imageNamed:@"icon.png"];
       
        

        
        
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"53d4c20456240b2af4103c08" shareText:nil shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToQQ,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToDouban, nil] delegate:self];

        
    }else if(btn.tag == 2){
        //点赞
        
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"identifier"];
        UMSocialDataService *socialDataService = [[UMSocialDataService alloc] initWithUMSocialData:socialData];
//        BOOL isLike = socialData.isLike;
        [socialDataService postAddLikeOrCancelWithCompletion:^(UMSocialResponseEntity *response){
            //获取请求结果
            NSLog(@"resposne is %@",response);
        }];
        
        
        //socialDataService为设置评论内容中初始化的对象
        [socialDataService requestSocialDataWithCompletion:^(UMSocialResponseEntity *response){
            // 下面的方法可以获取保存在本地的评论数，如果app重新安装之后，数据会被清空，可能获取值为0
            int likeNumber = [socialDataService.socialData getNumber:UMSNumberLike];
            goodTimes.text = [NSString stringWithFormat:@"%d",likeNumber];
            
        }];
    }
}





- (void)greet
{
    UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"identifier"];
    UMSocialDataService *socialDataService = [[UMSocialDataService alloc] initWithUMSocialData:socialData];
//    BOOL isLike = socialData.isLike;
//    [socialDataService postAddLikeOrCancelWithCompletion:^(UMSocialResponseEntity *response){
//        //获取请求结果
//        NSLog(@"resposne is %@",response);
//    }];
    
    
    //socialDataService为设置评论内容中初始化的对象
    [socialDataService requestSocialDataWithCompletion:^(UMSocialResponseEntity *response){
        // 下面的方法可以获取保存在本地的评论数，如果app重新安装之后，数据会被清空，可能获取值为0
        int likeNumber = [socialDataService.socialData getNumber:UMSNumberLike];
        goodTimes.text = [NSString stringWithFormat:@"%d",likeNumber];
        
    }];

}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    
    NSString *shareStr = [NSString stringWithFormat:@"分享一款实用和内容丰富的瑜伽APP《瑜伽魔方》，这里有我喜欢的%@:%@", self.audoOrNot,_itemMode.title];
    
    socialData.shareText = [NSString stringWithFormat:@"%@http://www.chinayogaonline.com/app",shareStr];
}



-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:[NSString stringWithFormat:@"已分享到%@",[[response.data allKeys] objectAtIndex:0]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
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

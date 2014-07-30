//
//  VideoPlayerController.m
//  yoga
//
//  Created by renxlin on 14-7-16.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "VideoPlayerController.h"
#import "MarqueeLabel.h"
#import "AFNetworking.h"
#import "CurrentProgram.h"
#import "MedioPlayTool.h"
#import "UMSocial.h"

@interface VideoPlayerController ()
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
    return YES;
}
-(BOOL)prefersStatusBarHidden
{
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

        [_TVPlayView removeFromSuperview];
        [_scrollView removeFromSuperview];
        _TVPlayView.frame = self.view.bounds;
        [self.view addSubview:_TVPlayView];
        [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon4" ofType:@"png"]] forState:UIControlStateNormal];
        isFullScreen = YES;
        NSLog(@"%@",NSStringFromCGRect(_TVPlayView.frame));

	} else {
        isFullScreen = NO;
        [_TVPlayView removeFromSuperview];
        _TVPlayView.frame = CGRectMake(1, 70, self.view.frame.size.width, self.view.frame.size.width *3/4);
        [_scrollView addSubview:_TVPlayView];
        [self.view addSubview:_scrollView];
        [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon3" ofType:@"png"]] forState:UIControlStateNormal];

	}
	NSLog(@"NAL 1HUI &&&&&&&&& frame=%@", NSStringFromCGRect(self.view.frame));
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
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOT_refreshOnlinePeople object:nil];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self greet];
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPeople) name:NOT_refreshOnlinePeople object:nil];
    
    self.view.autoresizesSubviews = YES;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    _scrollView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_scrollView];
    _scrollView.autoresizesSubviews = YES;
    _scrollView.autoresizingMask =
//    UIViewAutoresizingFlexibleBottomMargin |
////    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //自定义导航条
    UIView *nav = [self myNavgationBar:CGRectMake(0, 0, _scrollView.frame.size.width, 44) andTitle:@"瑜伽TV"];
    [_scrollView addSubview:nav];
    nav.autoresizingMask=
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //添加负载播放器和进度条视图；
    _carryView_portrait = [[UIView alloc] initWithFrame:CGRectMake(2, 70, self.view.frame.size.width, 250)];
    _carryView_portrait.backgroundColor = [UIColor blackColor];
//    [_scrollView addSubview:_carryView_portrait];
    _carryView_portrait.autoresizesSubviews = YES;
    
    //添加视频播放视图
    _TVPlayView = [[UIView alloc] initWithFrame:CGRectMake(1, 70, self.view.frame.size.width, self.view.frame.size.width *3/4)];
    _TVPlayView.backgroundColor = [UIColor clearColor];
    _TVPlayView.userInteractionEnabled = YES;
    _TVPlayView.autoresizesSubviews = YES;
    [_scrollView addSubview:_TVPlayView];
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
						  UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.center = _TVPlayView.center;
	[_TVPlayView addSubview:_activityView];
    [_activityView startAnimating];
    _activityView.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    _TVPlayView.autoresizingMask =
//    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
//    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    UITapGestureRecognizer *signleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTap)];
    signleTap.numberOfTapsRequired = 1;
    [_TVPlayView addGestureRecognizer:signleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [_TVPlayView addGestureRecognizer:doubleTap];
    //添加工具条：
    _mTools = [[MedioPlayTool alloc] initWithFrame:CGRectMake(0, _TVPlayView.frame.size.height -60, _TVPlayView.frame.size.width, 60)];
    [_mTools setBtnDelegate:self andSEL:@selector(playSettingChange:) andSliderSel:@selector(sliderChange:) andTapGesture:@selector(tapGesture:)];
    [_TVPlayView addSubview:_mTools];
    _mTools.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //当前节目
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_TVPlayView.frame.origin.y + _TVPlayView.frame.size.height + 40, self.view.frame.size.width, 30)];
    titleLabel.text = @"瑜伽视频";
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
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 100 )/2, titleLabel.frame.origin.y +titleLabel.frame.size.height + 20, 100, 100)];
    imageV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"]];
    [_scrollView addSubview:imageV];
//    imageV.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
//    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleWidth;
    
    
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
    _ad.text = self.itemMode.ad;
    [_scrollView addSubview:_ad];
//    _ad.autoresizingMask =
//    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
//    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleWidth;
    
    // logoView
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 150 )/2, _ad.frame.origin.y +_ad.frame.size.height + 30, 150, 40)];
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
    loginView.frame = CGRectMake((self.view.frame.size.width - 140 - 40*2)/2, logoView.frame.origin.y + logoView.frame.size.height + 20, 40, 40);
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
    _onlinePeople.textAlignment = NSTextAlignmentCenter;
    _onlinePeople.textColor = [UIColor whiteColor];
//    _onlinePeople.autoresizingMask =
//    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleHeight |
//    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleWidth;
    
    
    //settting View
    UIButton *settingView = [UIButton buttonWithType:UIButtonTypeCustom];
    settingView.frame = CGRectMake(loginView.frame.size.width+loginView.frame.origin.x + 140, logoView.frame.origin.y + logoView.frame.size.height + 20, 40, 40);
    [settingView addTarget:self action:@selector(SettingBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
    
    NSString *urlStr = [self removeSpace:self.itemMode.path];
    if (!_mPlayer) {
        _mPlayer = [VMediaPlayer sharedInstance];
        [_mPlayer setupPlayerWithCarrierView:_TVPlayView withDelegate:self];
        [_mPlayer setDataSource:[NSURL URLWithString:urlStr] header:nil];
        NSLog(@"%@",self.itemMode.path);
        [_mPlayer prepareAsync];
    }
}

-(NSString *)removeSpace:(NSString *)str
{
    NSArray *arr = [str componentsSeparatedByString:@" "];
    NSString *resultStr = [arr componentsJoinedByString:@"%20"];
    return resultStr;
}

-(void)signleTap
{
    if (!_mTools.isHidden) {
        _mTools.isHidden = YES;
        _mTools.hidden = YES;
    }else{
        _mTools.isHidden = NO;
        _mTools.hidden = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _mTools.isHidden = YES;
            _mTools.hidden = YES;
        });
    }
}
-(void)doubleTap
{
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        if (isFullScreen == NO) {
            isFullScreen = YES;
            [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon4" ofType:@"png"]] forState:UIControlStateNormal];
            
            [_TVPlayView removeFromSuperview];
            [_scrollView removeFromSuperview];
            _TVPlayView.frame = self.view.bounds;
            [self.view addSubview:_TVPlayView];
            
        }else{
            isFullScreen = NO;
            [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon3" ofType:@"png"]] forState:UIControlStateNormal];
            [_TVPlayView removeFromSuperview];
            _TVPlayView.frame = CGRectMake(1, 70, self.view.frame.size.width, self.view.frame.size.width *3/4);
            [_scrollView addSubview:_TVPlayView];
            [self.view addSubview:_scrollView];
        }
        
    }else {
        if (isFullScreen == NO) {
            isFullScreen = YES;
            
            [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon4" ofType:@"png"]] forState:UIControlStateNormal];
            [_TVPlayView removeFromSuperview];
            [_scrollView removeFromSuperview];
            _TVPlayView.frame = self.view.bounds;
            [self.view addSubview:_TVPlayView];
            
        }else{
            NSLog(@"非全屏播放");
            isFullScreen = NO;
            [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon3" ofType:@"png"]] forState:UIControlStateNormal];
            
            [_TVPlayView removeFromSuperview];
            _TVPlayView.frame = CGRectMake(1, 70, self.view.frame.size.width, self.view.frame.size.width *3/4);
            [_scrollView addSubview:_TVPlayView];
            [self.view addSubview:_scrollView];
            
        }
    }
}
#pragma mark VMediaPlayerDelegate methods Required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    NSLog(@"start>>>>>>>>>>>>");
    _duration  = [player getDuration];
    long second = _duration / 1000;
    
    int hour = second / (60 * 60 * 60);
    int min = second % 3600 /60;
    int sec = second % 3600 % 60;
    
    _mTools.totalPlay.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];
    [player start];
    [_activityView stopAnimating];
    _seekTimser = [NSTimer scheduledTimerWithTimeInterval:1.0/2 target:self selector:@selector(syncUIStatus) userInfo:nil repeats:YES];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _mTools.isHidden = YES;
        _mTools.hidden = YES;
    });

}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    NSLog(@"player complete");
    [_mPlayer reset];
    [player unSetupPlayer];
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
	NSLog(@"player error");
}

- (void)mediaPlayer:(VMediaPlayer *)player seekComplete:(id)arg
{
    NSLog(@"跳转完成！");
    [_activityView stopAnimating];
}
#pragma mark 定时更新进度条：
-(void)syncUIStatus
{
    static long lastDuration;
    long current = [_mPlayer getCurrentPosition];
//    if (current > lastDuration)
    {
        lastDuration = current;
        float precrnt = (float)current / _duration;
        _mTools.playProgress.value = precrnt;
        NSLog(@">>>>>>>>>>%ld/%ld",current,_duration)
        long second = current / 1000;
        
        int hour = second/(60 * 60 * 60);
        int min = second % 3600 /60;
        int sec = second % 3600 % 60;
        dispatch_async(dispatch_get_main_queue(), ^{
            _mTools.havePlay.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];
        });
        
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
        //full screen or not
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {

            if (isFullScreen == NO) {
                isFullScreen = YES;
                [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon4" ofType:@"png"]] forState:UIControlStateNormal];

                [_TVPlayView removeFromSuperview];
                [_scrollView removeFromSuperview];
                _TVPlayView.frame = self.view.bounds;
                [self.view addSubview:_TVPlayView];

            }else{
                isFullScreen = NO;
                [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon3" ofType:@"png"]] forState:UIControlStateNormal];
                [_TVPlayView removeFromSuperview];
                _TVPlayView.frame = CGRectMake(1, 70, self.view.frame.size.width, self.view.frame.size.width *3/4);
                
                [_scrollView addSubview:_TVPlayView];
                [self.view addSubview:_scrollView];
            }
            
        }else {
            if (isFullScreen == NO) {
                isFullScreen = YES;

                [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon4" ofType:@"png"]] forState:UIControlStateNormal];
                [_TVPlayView removeFromSuperview];
                [_scrollView removeFromSuperview];
                _TVPlayView.frame = self.view.bounds;
                [self.view addSubview:_TVPlayView];
                
            }else{
                NSLog(@"非全屏播放");
                isFullScreen = NO;
                [_mTools.fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon3" ofType:@"png"]] forState:UIControlStateNormal];
                [_TVPlayView removeFromSuperview];
                _TVPlayView.frame = CGRectMake(1, 70, self.view.frame.size.width, self.view.frame.size.width *3/4);
                [_scrollView addSubview:_TVPlayView];
                [self.view addSubview:_scrollView];

            }
        }
    }else if (btn.tag == 2){
        //last program
    
    }else if (btn.tag == 3){
        //play or pause
        btn.selected = !btn.selected;
        
        if ([_mPlayer isPlaying]) {
            [_mPlayer pause];
            [btn setSelected:YES];
        }else{
            [_mPlayer start];
        }
        
    }else if (btn.tag == 4){
        //next program
        
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
    [_seekTimser invalidate];
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
    view.autoresizesSubviews = YES;

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
    
    //分享：
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(view.frame.size.width - 30, 2, 35, view.frame.size.height-4);
    [share setImage:[UIImage imageNamed:@"title_icon1.png"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(TitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    share.tag = 1;
    [view addSubview:share];
    share.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
    //好评数
   goodTimes = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width - share.frame.size.width - 45, 2, 45, rect.size.height)];
    
    goodTimes.adjustsFontSizeToFitWidth = YES;
    goodTimes.textColor = [UIColor whiteColor];
    [view addSubview:goodTimes];
    goodTimes.backgroundColor = [UIColor clearColor];
    goodTimes.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;

    //点赞
    UIButton *good = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
        //分享
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"http://www.chinayogaonline.com/upload/ad/001.jpg"];
        
        //自定义各平台分享内容：
        [UMSocialData defaultData].extConfig.sinaData.shareText = @"中国瑜伽在线";
        [UMSocialData defaultData].extConfig.sinaData.shareImage = [UIImage imageNamed:@"icon.png"]; //分享到新浪微博图片
        
        
        [UMSocialData defaultData].extConfig.tencentData.shareImage = [UIImage imageNamed:@"icon.png"]; //分享到腾讯微博图片
        [UMSocialData defaultData].extConfig.tencentData.shareText = @"中国瑜伽在线";
        
        [UMSocialData defaultData].extConfig.doubanData.shareImage = [UIImage imageNamed:@"icon.png"]; //分享到豆瓣
        [UMSocialData defaultData].extConfig.doubanData.shareText = @"中国瑜伽在线";
        
        [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:@""];  //设置微信好友分享url图片
        [[UMSocialData defaultData].extConfig.wechatTimelineData.urlResource setResourceType:UMSocialUrlResourceTypeVideo url:@"http://v.youku.com/v_show/id_XNjQ1NjczNzEy.html?f=21207816&ev=2"]; //设置微信朋友圈分享视频
        
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"53d4c20456240b2af4103c08" shareText:@"renxlin" shareImage:[UIImage imageNamed:@"icon.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToQQ,UMShareToTencent,UMShareToDouban, nil] delegate:self];
        
        
    }else if(btn.tag == 2){
        //点赞
        
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"identifier"];
        UMSocialDataService *socialDataService = [[UMSocialDataService alloc] initWithUMSocialData:socialData];
        BOOL isLike = socialData.isLike;
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
//弹出列表方法presentSnsIconSheetView需要设置delegate为self
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
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

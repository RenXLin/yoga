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

@interface VideoPlayerController ()
{
    UIScrollView *_scrollView;
    UIView *_carryView;
    VMediaPlayer *_mPlayer;
    MedioPlayTool *_mTools;
    NSTimer *_seekTimser;
    UIActivityIndicatorView *_activityView;
    long _duration;
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
        _carryView.frame = self.view.bounds;
        [_carryView removeFromSuperview];
        [self.view addSubview:_carryView];
        _TVPlayView.frame = _carryView.bounds;
        [_mTools removeFromSuperview];
        _mTools.frame = CGRectMake(0, _carryView.frame.size.height - 50, _carryView.frame.size.width, 50);
        [_TVPlayView addSubview:_mTools];
        NSLog(@"%@",NSStringFromCGRect(_carryView.frame));
        
	} else {
        _carryView.frame = CGRectMake(2, 70, self.view.frame.size.width-4, 300);
        [_carryView removeFromSuperview];
        [_scrollView addSubview:_carryView];
        _TVPlayView.frame = CGRectMake(1, 1, _carryView.frame.size.width-2, _carryView.frame.size.height-70);
        [_mTools removeFromSuperview];
        _mTools.frame = CGRectMake(0, _carryView.frame.size.height -60, _carryView.frame.size.width, 60);
        [_scrollView addSubview:_mTools];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPeople) name:NOT_refreshOnlinePeople object:nil];
    
    self.view.backgroundColor = [UIColor blackColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    _scrollView.backgroundColor =[UIColor grayColor];
    
    [self.view addSubview:_scrollView];
    
    //自定义导航条
    UIView *nav = [self myNavgationBar:CGRectMake(0, 0, _scrollView.frame.size.width, 44) andTitle:@"瑜伽TV"];
    [_scrollView addSubview:nav];
    
    //添加负载播放器和进度条视图；
    _carryView = [[UIView alloc] initWithFrame:CGRectMake(2, 70, self.view.frame.size.width-4, 300)];
    _carryView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_carryView];
    
    //添加工具条：
    _mTools = [[MedioPlayTool alloc] initWithFrame:CGRectMake(0, _carryView.frame.size.height -60, _carryView.frame.size.width, 60)];
    [_mTools setBtnDelegate:self andSEL:@selector(playSettingChange:) andSliderSel:@selector(sliderChange:) andTapGesture:@selector(tapGesture:)];
    [_carryView addSubview:_mTools];
    
    //添加视频播放视图
    _TVPlayView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, _carryView.frame.size.width-2, _carryView.frame.size.height-70)];
    _TVPlayView.backgroundColor = [UIColor blackColor];
    //    TVPlayView.alpha = 0.2;
    [_carryView addSubview:_TVPlayView];
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
						  UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.center = _TVPlayView.center;
	[_TVPlayView addSubview:_activityView];
    [_activityView startAnimating];
    
    //当前节目
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_carryView.frame.origin.y + _carryView.frame.size.height +30, self.view.frame.size.width, 30)];
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
    

    if (!_mPlayer) {
        _mPlayer = [VMediaPlayer sharedInstance];
        [_mPlayer setupPlayerWithCarrierView:_TVPlayView withDelegate:self];
        [_mPlayer setDataSource:[NSURL URLWithString:self.itemMode.path] header:nil];
        [_mPlayer prepareAsync];
    }
}
#pragma mark VMediaPlayerDelegate methods Required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    NSLog(@"start>>>>>>>>>>>>");
    _duration  = [player getDuration];
    int hour = _duration/(60 * 60 * 60);
    int min = _duration / 3600;
    int sec = _duration % 3600 / 60;
    _mTools.totalPlay.text = [NSString stringWithFormat:@"%2d:%2d:%2d",hour,min,sec];
    [player start];
    [_activityView stopAnimating];
    _seekTimser = [NSTimer scheduledTimerWithTimeInterval:1.0/2 target:self selector:@selector(syncUIStatus) userInfo:nil repeats:YES];
    
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    NSLog(@"player complete");
    [_mPlayer reset];
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
    long current = [_mPlayer getCurrentPosition];
    float precrnt = (float)current / _duration;
    _mTools.playProgress.value = precrnt;
    NSLog(@">>>>>>>>>>%ld/%ld",current,_duration)
    int hour = current/(60 * 60 * 60);
    int min = current / 3600;
    int sec = current % 3600 / 60;
    _mTools.havePlay.text = [NSString stringWithFormat:@"%2d:%2d:%2d",hour,min,sec];
    
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
    NSLog(@"%d",btn.tag);
    if (btn.tag == 1) {
        //full screen or not
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//            _carryView.frame = self.view.bounds;
//            [_carryView removeFromSuperview];
//            [self.view addSubview:_carryView];
//            _TVPlayView.frame = _carryView.bounds;
//            [_mTools removeFromSuperview];
//            _mTools.frame = CGRectMake(0, _carryView.frame.size.height - 50, _carryView.frame.size.width, 50);
//            [_TVPlayView addSubview:_mTools];
//            NSLog(@"%@",NSStringFromCGRect(_carryView.frame));
            
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
            
            _carryView.transform = CGAffineTransformMakeRotation(-M_PI/2);

        }else {
//            _carryView.frame = CGRectMake(2, 70, self.view.frame.size.width-4, 300);
//            [_carryView removeFromSuperview];
//            [_scrollView addSubview:_carryView];
//            _TVPlayView.frame = CGRectMake(1, 1, _carryView.frame.size.width-2, _carryView.frame.size.height-70);
//            [_mTools removeFromSuperview];
//            _mTools.frame = CGRectMake(0, _carryView.frame.size.height -60, _carryView.frame.size.width, 60);
//            [_scrollView addSubview:_mTools];
            
//            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
//            
//            _carryView.transform = CGAffineTransformMakeRotation(M_PI/2);
            
        }
        
    }else if (btn.tag == 2){
        //last program
    
    }else if (btn.tag == 3){
        //play or pause
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

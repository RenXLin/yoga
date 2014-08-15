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
#import "UMSocial.h"
#import "OneDayProgram.h"
#import "OneDayProgramCell.h"
#import "SVProgressHUD.h"

@interface RL_TVViewController ()<UIGestureRecognizerDelegate,UMSocialUIDelegate>
{
    VMediaPlayer *_mMpayer;
    UITableView *fileTable;
    UILabel *goodTimes;
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
    
    UIActivityIndicatorView *_activityView;
    
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

- (BOOL)shouldAutorotate
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self greet];//获取点赞数
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPeople) name:NOT_refreshOnlinePeople object:nil];
    NSLog(@"%@",[UIDevice currentDevice].systemVersion);
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    }else{
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 20)];
    }
    _scrollView.backgroundColor =[UIColor clearColor];
    
    [self.view addSubview:_scrollView];
    
    //自定义导航条
    UIView *nav = [self myNavgationBar:CGRectMake(0, 0, _scrollView.frame.size.width, 44) andTitle:@"瑜伽TV"];
    [_scrollView addSubview:nav];
    
    //添加视频播放视图
    _TVPlayView = [[UIView alloc] initWithFrame:CGRectMake(2, nav.frame.size.height + nav.frame.origin.y + 10, self.view.frame.size.width-4, self.view.frame.size.width * 3 / 4)];
    _TVPlayView.backgroundColor = [UIColor blackColor];
//    TVPlayView.alpha = 0.2;
    [_scrollView addSubview:_TVPlayView];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                     UIActivityIndicatorViewStyleWhiteLarge];
	[_TVPlayView addSubview:_activityView];
    _activityView.center = _TVPlayView.center;
    [_activityView startAnimating];
    _activityView.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;

    
    //当前节目
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_TVPlayView.frame.origin.y + _TVPlayView.frame.size.height +10, self.view.frame.size.width, 30)];
    titleLabel.text = @"瑜伽 TV ";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:titleLabel];
    
    //加入imageView
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 80 )/2, titleLabel.frame.origin.y +titleLabel.frame.size.height + 3, 80, 80)];
    imageV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"333" ofType:@"png"]];
    [_scrollView addSubview:imageV];
    
    //显示节目菜单按钮
    UIButton *fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fileBtn.frame = CGRectMake(_scrollView.frame.size.width - 55, titleLabel.frame.origin.y, 35, 35);
    [fileBtn setImage:[UIImage imageNamed:@"title_icon4.png"] forState:UIControlStateNormal];
    [_scrollView addSubview:fileBtn];
    [fileBtn addTarget:self action:@selector(getFileList) forControlEvents:UIControlEventTouchUpInside];
    
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
    _ad.text = @" 当 前 无 节 目         当 前 无 节 目          当 前 无 节 目          当 前 无 节 目";
    [_scrollView addSubview:_ad];
    
    // logoView
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 150 )/2, _ad.frame.origin.y +_ad.frame.size.height + 10, 150, 45)];
    logoView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
    [_scrollView addSubview:logoView];
    logoView.autoresizingMask =
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
    [_scrollView addSubview:loginView];
    loginView.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    
    //当前在线人数
    _onlinePeople = [[UILabel alloc] initWithFrame:CGRectMake(loginView.frame.size.width + loginView.frame.origin.x, loginView.frame.origin.y, 140, loginView.frame.size.height)];
    UserInfo *info = [UserInfo shareUserInfo];
    _onlinePeople.backgroundColor = [UIColor clearColor];
    _onlinePeople.text = info.onliePeople;//暂定
    _onlinePeople.adjustsFontSizeToFitWidth = YES;
    _onlinePeople.font = [UIFont systemFontOfSize:15];
    _onlinePeople.textAlignment = NSTextAlignmentCenter;
    _onlinePeople.textColor = [UIColor whiteColor];
    [_scrollView addSubview:_onlinePeople];
    _onlinePeople.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //settting View
    UIButton *settingView = [UIButton buttonWithType:UIButtonTypeCustom];
    settingView.frame = CGRectMake(loginView.frame.size.width+loginView.frame.origin.x + 140, logoView.frame.origin.y + logoView.frame.size.height + 17, 40, 40);
    [settingView addTarget:self action:@selector(SettingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [settingView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue" ofType:@"png"]] forState:UIControlStateNormal];
    [_scrollView addSubview:settingView];
    settingView.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, settingView.frame.origin.y + settingView.frame.size.height + 10);
    _scrollView.bounces = NO;

    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:CURRENTPLAYVIDEO_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success:%@",responseObject);
        _programMode = [[CurrentProgram alloc] init];
        [_programMode setValuesForKeysWithDictionary:[responseObject objectForKey:@"data"]];
        if ([[responseObject objectForKey:@"data"] count] > 0) {
            _ad.text = [NSString stringWithFormat:@"%@                     %@                           %@",_programMode.ad,_programMode.ad,_programMode.ad];
            
            NSString * pathUrl = [_programMode.path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            NSString *urlStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)pathUrl,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
            
            //加入FM播放器：
            if (!_mMpayer && urlStr) {
                _mMpayer = [VMediaPlayer sharedInstance];
                [_mMpayer setupPlayerWithCarrierView:_TVPlayView withDelegate:self];
                [_mMpayer setDataSource:[NSURL URLWithString:pathUrl] header:nil];
                [_mMpayer prepareAsync];
            }
        }else{
            [SVProgressHUD showWithStatus:@"当前无TV"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
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
    [_activityView stopAnimating];
    NSLog(@"start>>>>>>>>>>>>");
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    NSLog(@"player complete");
    [player reset];
    [player unSetupPlayer];
    
    player = nil;
    
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:CURRENTPLAYVIDEO_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success:%@",responseObject);
        _programMode = [[CurrentProgram alloc] init];
        [_programMode setValuesForKeysWithDictionary:[responseObject objectForKey:@"data"]];
        if ([[responseObject objectForKey:@"data"] count] > 0) {
            _ad.text = [NSString stringWithFormat:@"%@                     %@                           %@",_programMode.ad,_programMode.ad,_programMode.ad];
            
            NSString * pathUrl = [_programMode.path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            NSString *urlStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)pathUrl,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
            
            //加入FM播放器：
            if (!_mMpayer && urlStr) {
                _mMpayer = [VMediaPlayer sharedInstance];
                [_mMpayer setupPlayerWithCarrierView:_TVPlayView withDelegate:self];
                [_mMpayer setDataSource:[NSURL URLWithString:pathUrl] header:nil];
                [_mMpayer prepareAsync];
            }
        }else{
            [SVProgressHUD showWithStatus:@"当前无TV"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed:%@",error);
        
    }];

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
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    [view addSubview:title];
    
    //分享：
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(view.frame.size.width - 40, 2, 35, view.frame.size.height-4);
    [share setImage:[UIImage imageNamed:@"title_icon1.png"] forState:UIControlStateNormal];
    [view addSubview:share];
    share.tag = 1;
    [share addTarget:self action:@selector(TitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //好评数
    goodTimes = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width - share.frame.size.width - 45, 2, 45, rect.size.height)];
    goodTimes.textAlignment = NSTextAlignmentCenter;
    goodTimes.backgroundColor = [UIColor clearColor];
    goodTimes.adjustsFontSizeToFitWidth = YES;
    goodTimes.textColor = [UIColor whiteColor];
    [view addSubview:goodTimes];
    
    //点赞
    UIButton *good = [UIButton buttonWithType:UIButtonTypeCustom];
    good.frame = CGRectMake(view.frame.size.width - goodTimes.frame.size.width - share.frame.size.width - 35, 0, 35, view.frame.size.height);
    [good setImage:[UIImage imageNamed:@"title_icon2.png"] forState:UIControlStateNormal];
    [good setImage:[UIImage imageNamed:@"title_icon2_1.png"] forState:UIControlStateHighlighted];
    [view addSubview:good];
    good.tag = 2;
    [good addTarget:self action:@selector(TitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    return view;
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

-(void)TitleBtnClick:(UIButton *)btn
{
    
    if (btn.tag == 1) {
        
      
        NSString *shareStr = [NSString stringWithFormat:@"分享一款实用和丰富内容的瑜伽APP《瑜伽魔方》，这里有我喜欢的瑜伽TV:%@",_programMode.title];
        
        NSLog(@"%@",shareStr);
        
        //分享
        // [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"http://www.chinayogaonline.com/upload/ad/001.jpg"];
        
        //自定义各平台分享内容：
        [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@http://www.chinayogaonline.com/app",shareStr];
        
        
        //[UMSocialData defaultData].extConfig.sinaData.shareImage = [UIImage imageNamed:@"icon.png"]; //分享到新浪微博图片
        
        
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
        [UMSocialData defaultData].extConfig.qzoneData.shareImage = [UIImage imageNamed:@"icon.png"];
        [UMSocialData defaultData].extConfig.qqData.urlResource.url=nil;
          [UMSocialData defaultData].extConfig.qzoneData.title=shareStr;
        
        
        
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"53d4c20456240b2af4103c08" shareText:nil shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToQQ,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToDouban, nil] delegate:self];
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

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    
    NSString *shareStr = [NSString stringWithFormat:@"分享一款实用和丰富内容的瑜伽APP《瑜伽魔方》，这里有我喜欢的瑜伽TV:%@",_programMode.title];
    
    socialData.shareText = [NSString stringWithFormat:@"%@:http://www.chinayogaonline.com/app",shareStr];
    
    
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

//获取当天节目列表:
-(void)getFileList
{
    if (!_fileList) {
        
        _fileList = [[NSMutableArray alloc] init];
        
        [self getCurrentFile];
        
        UIView *white = [[UIView alloc] initWithFrame:_TVPlayView.bounds];
        white.backgroundColor = [UIColor whiteColor];
        white.alpha = 0.5;
        white.tag = 100;
        [_TVPlayView addSubview:white];
        
        fileTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _TVPlayView.frame.size.width, _TVPlayView.frame.size.height) style:UITableViewStylePlain];
        fileTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        fileTable.backgroundColor = [UIColor clearColor];
        fileTable.dataSource = self;
        fileTable.delegate = self;
        [_TVPlayView addSubview:fileTable];
        

        _TVPlayView.autoresizesSubviews = YES;
        
        fileTable.autoresizingMask =
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleWidth;
        
    }else{
        fileTable.hidden = !fileTable.hidden;
        [fileTable.superview viewWithTag:100].hidden = ![fileTable.superview viewWithTag:100].hidden;
    }
}
-(void)getCurrentFile
{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    _fileList = [[NSMutableArray alloc] init];

    [manager GET:VIDEOLIST_ULR parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success:%@",responseObject);
        NSArray *dataArr = [responseObject objectForKey:@"data"];
        for (NSDictionary *dic in dataArr) {
            OneDayProgram *oneProgram = [[OneDayProgram alloc] init];
            [oneProgram setValuesForKeysWithDictionary:dic];
            [_fileList addObject:oneProgram];
        }
        [fileTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed:%@",error);
    }];
}
-(OneDayProgramCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FileCell";
    OneDayProgramCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OneDayProgramCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    OneDayProgram *program = (OneDayProgram *)[_fileList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
    
    int startHour = [[program.starttime substringToIndex:2] intValue];
    int startMin = [[program.starttime substringWithRange:NSMakeRange(3, 2)] intValue];
    int startSec = [[program.starttime substringWithRange:NSMakeRange(6, 2)] intValue];
    
    int endleng = startHour * 3600 + startMin * 60 + startSec + [program.timelength intValue];
    
    int endHour = endleng / 3600;
    int endMin = endleng % 3600 / 60;
    int endSec = endleng % 60;
    
    
    cell.label_Time.text = [NSString stringWithFormat:@"%@-%02d:%02d:%02d",program.starttime,endHour,endMin,endSec];
    cell.label_Title.text = program.title;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_fileList count];
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

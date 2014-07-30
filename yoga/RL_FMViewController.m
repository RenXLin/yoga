//
//  RL_FMViewController.m
//  yoga
//
//  Created by renxlin on 14-7-12.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "RL_FMViewController.h"
#import "MarqueeLabel.h"
#import "AFNetworking.h"
#import "CurrentProgram.h"
#import "UMSocial.h"
#import "OneDayProgram.h"
#import "OneDayProgramCell.h"

#define GAP_WITH  2.5  //定义白色边框的大小：

@interface RL_FMViewController ()
{
    VMediaPlayer *_mMpayer;
    MPMoviePlayerController *_mp3;
    NSMutableArray *_fileList;
    UITableView *fileTable;
    UILabel *goodTimes;
}
@end

@implementation RL_FMViewController
{
    //ad
    MarqueeLabel *_ad;
    //当前在线人数
    UILabel *_onlinePeople;
    //存储当前节目数据类型实例
    CurrentProgram *_programMode;
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
-(BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0);
{
    return UIInterfaceOrientationPortrait;
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
    
    [self greet];//获取点赞数
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.view.autoresizesSubviews = YES;
    
    //刷新当前人数通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPeople) name:NOT_refreshOnlinePeople object:nil];
    
    UIScrollView *scrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    scrolView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:scrolView];
    scrolView.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //自定义导航条
    UIView *nav = [self myNavgationBar:CGRectMake(0, 0, scrolView.frame.size.width, 44) andTitle:self.FM_AV];
    [scrolView addSubview:nav];
    
    
    //添加白色底板
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(5, nav.frame.origin.y + nav.frame.size.height +10, [UIScreen mainScreen].bounds.size.width-10, [UIScreen mainScreen].bounds.size.width-10)];
    whiteView.tag = 5000;
    whiteView.backgroundColor = [UIColor whiteColor];
    [scrolView addSubview:whiteView];
    whiteView.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
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
            view.autoresizingMask =
            UIViewAutoresizingFlexibleBottomMargin |
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleWidth;
        }
    }
    
    //当前节目
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,whiteView.frame.origin.y + whiteView.frame.size.height +30, self.view.frame.size.width, 30)];
    titleLabel.text = @"瑜伽 FM ";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [scrolView addSubview:titleLabel];
    titleLabel.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //加入imageView
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 100 )/2, titleLabel.frame.origin.y +titleLabel.frame.size.height + 20, 100, 100)];
    imageV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fm" ofType:@"png"]];
    [scrolView addSubview:imageV];
    imageV.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //显示节目菜单按钮
    UIButton *fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fileBtn.frame = CGRectMake(scrolView.frame.size.width - 55, imageV.frame.origin.y, 35, 35);
    [fileBtn setImage:[UIImage imageNamed:@"title_icon4.png"] forState:UIControlStateNormal];
    [scrolView addSubview:fileBtn];
    [fileBtn addTarget:self action:@selector(getFileList) forControlEvents:UIControlEventTouchUpInside];
    fileBtn.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
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
    [scrolView addSubview:_ad];
    _ad.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    // logoView
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 150 )/2, _ad.frame.origin.y +_ad.frame.size.height + 30, 150, 40)];
    logoView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
    [scrolView addSubview:logoView];
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
    [scrolView addSubview:loginView];
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
    _onlinePeople.textAlignment = NSTextAlignmentCenter;
    _onlinePeople.textColor = [UIColor whiteColor];
    [scrolView addSubview:_onlinePeople];
    _onlinePeople.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //settting View
    UIButton *settingView = [UIButton buttonWithType:UIButtonTypeCustom];
    settingView.frame = CGRectMake(loginView.frame.size.width+loginView.frame.origin.x + 140, logoView.frame.origin.y + logoView.frame.size.height + 20, 40, 40);
    [settingView addTarget:self action:@selector(SettingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [settingView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue" ofType:@"png"]] forState:UIControlStateNormal];
    [scrolView addSubview:settingView];
    settingView.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    scrolView.contentSize = CGSizeMake(self.view.frame.size.width, settingView.frame.origin.y + settingView.frame.size.height + 10);
    scrolView.bounces = NO;
    
    NSString *url;
    if ([self.FM_AV isEqualToString:@"瑜伽FM"]) {
        url = CURRENTPLAYFM_URL;
    }else{
        url = CURRENTPLAYVIDEO_URL;
    }
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success:%@",responseObject);
        _programMode = [[CurrentProgram alloc] init];
        [_programMode setValuesForKeysWithDictionary:[responseObject objectForKey:@"data"]];
        _ad.text = _programMode.ad;
        
        NSString *pathUrl = [[responseObject objectForKey:@"data"] objectForKey:@"path"];
        NSLog(@"%@",pathUrl);
        pathUrl = [self removeSpace:pathUrl];
       
        if (!_mMpayer && pathUrl) {
            _mMpayer = [VMediaPlayer sharedInstance];
            [_mMpayer setupPlayerWithCarrierView:whiteView withDelegate:self];
            [_mMpayer setDataSource:[NSURL URLWithString:pathUrl] header:nil];
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
-(void)playMovieAtURL:(NSString*)theURLStr
{
    _mp3 = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:theURLStr]];
    _mp3.view.frame = CGRectMake(0, 64, 320, 200);
    [self.view addSubview:_mp3.view];
    _mp3.shouldAutoplay = YES;
    [_mp3 play];

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
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
	NSLog(@"player error");
    UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"提示" message:@"播放失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [aleart show];
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
    view.autoresizesSubviews = YES;
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title.png"]];
    view.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //back button
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(2, 0, 40, view.frame.size.height);
    [back addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"title_icon.png"] forState:UIControlStateNormal];
    [view addSubview:back];
    back.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(back.frame.size.width, 0, 70, rect.size.height)];
    title.text = tit;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    [view addSubview:title];
    title.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //分享：
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(view.frame.size.width - 30, 2, 35, view.frame.size.height-4);
    [share setImage:[UIImage imageNamed:@"title_icon1.png"] forState:UIControlStateNormal];
    [view addSubview:share];
    share.tag = 1;
    [share addTarget:self action:@selector(TitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    share.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //好评数
    goodTimes = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width - share.frame.size.width - 45, 2, 45, rect.size.height)];
    
    goodTimes.adjustsFontSizeToFitWidth = YES;
    goodTimes.textColor = [UIColor whiteColor];
    [view addSubview:goodTimes];
    goodTimes.backgroundColor  = [UIColor clearColor];
    goodTimes.autoresizingMask=
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
    
    //点赞
    UIButton *good = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    good.frame = CGRectMake(view.frame.size.width - goodTimes.frame.size.width - share.frame.size.width - 35, 0, 35, view.frame.size.height);
    [good setImage:[UIImage imageNamed:@"title_icon2.png"] forState:UIControlStateNormal];
    [good setImage:[UIImage imageNamed:@"title_icon2_1.png"] forState:UIControlStateHighlighted];
    [view addSubview:good];
    good.tag = 2;
    [good addTarget:self action:@selector(TitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    good.backgroundColor = [UIColor clearColor];
    good.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleWidth;
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
        //分享
        //    1. 支持分享编辑页和授权页面横屏，必须要在出现列表页面前设置:
        //    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
        
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"http://www.baidu.com/img/bdlogo.gif"];
        
        //自定义各平台分享内容：
        [UMSocialData defaultData].extConfig.sinaData.shareText = @"分享到新浪微博内容";
        [UMSocialData defaultData].extConfig.tencentData.shareImage = [UIImage imageNamed:@"icon"]; //分享到腾讯微博图片
        [UMSocialData defaultData].extConfig.tencentData.shareText = @"友盟社会化分享让您快速实现分享等社会化功能，www.umeng.com/social";
        [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"http://www.baidu.com/img/bdlogo.gif"];  //设置微信好友分享url图片
        [[UMSocialData defaultData].extConfig.wechatTimelineData.urlResource setResourceType:UMSocialUrlResourceTypeVideo url:@"http://v.youku.com/v_show/id_XNjQ1NjczNzEy.html?f=21207816&ev=2"]; //设置微信朋友圈分享视频
        
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"532af38e56240b2cdc01b9c6" shareText:@"renxlin" shareImage:[UIImage imageNamed:@"www.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToSms,UMShareToQzone,UMShareToQQ,UMShareToFacebook, nil] delegate:self];
        
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

//获取当天节目列表:
-(void)getFileList
{
    if (!_fileList) {
        _fileList = [[NSMutableArray alloc] init];
        [self getCurrentFile];
        
        UIView *backView = [self.view viewWithTag:5000];
        
        fileTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height) style:UITableViewStylePlain];
        fileTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        fileTable.backgroundColor = [UIColor clearColor];
        fileTable.dataSource = self;
        fileTable.delegate = self;
        [backView addSubview:fileTable];
        
        backView.autoresizesSubviews = YES;
        
        fileTable.autoresizingMask =
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleWidth;
        
    }else{
        fileTable.hidden = !fileTable.hidden;
    }
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
    
    int startHour = [[program.starttime substringToIndex:1] intValue];
    int startMin = [[program.starttime substringWithRange:NSMakeRange(3, 2)] intValue];
    int startSec = [[program.starttime substringWithRange:NSMakeRange(6, 2)] intValue];

    int addHour = [program.timelength intValue] / 3600;
    int addMin = [program.timelength intValue] % 3600 / 60;
    int addSec = [program.timelength intValue] % 60;
    
    int endHour = startHour + addHour;
    int endMin = startMin + addMin;
    int endSec = startSec + addSec;
    
    
    cell.label_Time.text = [NSString stringWithFormat:@"%@-%d:%d:%d",program.starttime,endHour,endMin,endSec];
    cell.label_Title.text = program.title;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [_fileList count];
}
-(void)getCurrentFile
{

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url;
    if ([_FM_AV isEqualToString:@"瑜伽FM"]) {
        url = FMList_url;
    }else
        url = AUDIOLIST_URL;
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

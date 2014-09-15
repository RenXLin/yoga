//
//  RL_SettingViewController.m
//  yoga
//
//  Created by renxlin on 14-7-12.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "RL_SettingViewController.h"

@interface RL_SettingViewController ()

@end

@implementation RL_SettingViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

    UIView *nav;
    if ([[UIDevice currentDevice].systemVersion intValue] >= 7) {
        nav = [self myNavgationBar:CGRectMake(0, 20, self.view.frame.size.width, 44) andTitle:@"关于"];
    }else{
        nav = [self myNavgationBar:CGRectMake(0, 0, self.view.frame.size.width, 44) andTitle:@"关于"];    }
    [self.view addSubview:nav];

    //loginview
//    UIButton *loginView = [UIButton buttonWithType:UIButtonTypeCustom];
//    loginView.frame = CGRectMake((self.view.frame.size.width - 140 - 40*2)/2, self.view.frame.size.height - 60, 40, 40);
//    [loginView addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [loginView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue1" ofType:@"png"]] forState:UIControlStateNormal];
//    [self.view addSubview:loginView];
//    
//    //当前在线人数
//    UILabel * _onlinePeople = [[UILabel alloc] initWithFrame:CGRectMake(loginView.frame.size.width + loginView.frame.origin.x, loginView.frame.origin.y, 140, loginView.frame.size.height)];
//    UserInfo *info = [UserInfo shareUserInfo];
//    _onlinePeople.backgroundColor = [UIColor clearColor];
//    _onlinePeople.text = info.onliePeople;//暂定
//    _onlinePeople.adjustsFontSizeToFitWidth = YES;
//    _onlinePeople.textAlignment = NSTextAlignmentCenter;
//    _onlinePeople.textColor = [UIColor whiteColor];
//    [self.view addSubview:_onlinePeople];
//    
//    //settting View
//    UIButton *settingView = [UIButton buttonWithType:UIButtonTypeCustom];
//    settingView.frame = CGRectMake(loginView.frame.size.width+loginView.frame.origin.x + 140, loginView.frame.origin.y , 40, 40);
//    [settingView addTarget:self action:@selector(SettingBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [settingView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue" ofType:@"png"]] forState:UIControlStateNormal];
//    [self.view addSubview:settingView];

    
    UILabel *aboutLab = [[UILabel alloc]initWithFrame:CGRectMake(10, iOS7?44:44, KscreenWidth-20, KscreenHeight-(iOS7?44:64))];
    aboutLab.textAlignment = NSTextAlignmentLeft;
    aboutLab.textColor = [UIColor whiteColor];
    aboutLab.backgroundColor = [UIColor clearColor];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        aboutLab.font = [UIFont systemFontOfSize:20];
    }else
    {
        aboutLab.font = [UIFont systemFontOfSize:15];
    }
   
    [self.view addSubview:aboutLab];
    
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    NSString *URLStr = [NSString stringWithFormat:@"http://www.chinayogaonline.com/api/about"];
    //      待加入缓冲提示：
    if(iOS7)
    {
        SVProgressHUDShow;
    }
    [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] == 200) {
            
            if(iOS7)
            {
                [SVProgressHUD dismiss];
            }
           
            
            dataDict = responseObject ;
            
           

            NSLog(@"%@",dataDict);
            
            if(dataDict)
            {
                aboutLab.text = [dataDict objectForKey:@"data"];
            }
            
            aboutLab.numberOfLines = 0;
           
            
            
   
        }else{
            if(iOS7)
            {
                [SVProgressHUD dismiss];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         if(iOS7)
         {
             [SVProgressHUD dismiss];
         }
         
         
     }];
    
   
  

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return view;
}

-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loginBtnClick
{

}
-(void)SettingBtnClick
{

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

//
//  CountCenterViewController.m
//  yoga
//
//  Created by cao on 14-7-27.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "CountCenterViewController.h"
#import "OrderViewController.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "SC_AudioOnLineViewController.h"
@interface CountCenterViewController ()

@end

@implementation CountCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden =YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    UserInfo *info = [UserInfo shareUserInfo];
    NSString *URLStr = [NSString stringWithFormat:@"http://www.chinayogaonline.com/api/createOrder?token=%@",info.token];
    //      待加入缓冲提示：
    [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] == 200) {
            
            
            
            dataDict = [responseObject objectForKey:@"data"];
            
                        
            
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    
   
    
}
- (void)createUI
{
    UIImageView *bgImgView = [UIFactory createImageViewWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) imageName:@"bg.png"];
    bgImgView.userInteractionEnabled = YES;
    [self.view addSubview:bgImgView];
    
    
    //自定义导航条
    UIView *nav = [self myNavgationBar:CGRectMake(0,iOS7?20:0, KscreenWidth, 44) andTitle:@"账号中心"];
    [bgImgView addSubview:nav];
    //bgimgview
    
    
    //bgimgview1
    UIImageView *bgImgView1 = [[UIImageView alloc]init];
    bgImgView1.frame = CGRectMake(10,nav.frame.size.height + 20, KscreenWidth-20, 130);
    bgImgView1.image = [UIImage imageNamed:@""];
    bgImgView1.backgroundColor = [UIColor colorWithRed:240/250.0f green:240/250.0f blue:240/250.0f alpha:0.3];
    [bgImgView addSubview:bgImgView1];
    //lab
    NSArray *arr = @[@"用户名：",@"邮箱：",@"会员类型："];
    for (int i=0; i<3; i++) {
        UILabel *lab = [UIFactory createLabelWithFrame:CGRectMake(10, 10+30*i, 80, 20) text:[arr objectAtIndex:i] textColor:[UIColor whiteColor] textFont:Kfont(13) textAlignment:0];
        lab.backgroundColor = [UIColor clearColor];
        [bgImgView1 addSubview:lab];
        
        
        
    }

    
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *userName = [delegate.userDict objectForKey:@"username"];
    NSString *email = [[delegate.userDict objectForKey:@"new_email"] description];
    
    NSArray *Rrr = [delegate.userDict objectForKey:@"roleInfo"];
    NSString *normalUSer = [NSString stringWithFormat:@"%@:(到期：%@)",[[Rrr objectAtIndex:0] objectForKey:@"description"],[[Rrr objectAtIndex:0] objectForKey:@"expiry_date"]];
    
    NSString *VipUSer = [NSString stringWithFormat:@"%@:(到期：%@)",[[Rrr objectAtIndex:1] objectForKey:@"description"],[[Rrr objectAtIndex:1] objectForKey:@"expiry_date"]];
    
    NSLog(@"%@",delegate.userDict);
    
    NSArray *countArray = [NSArray arrayWithObjects:userName,email,normalUSer,VipUSer, nil];
    
    for (int i=0; i<4; i++) {
        
        UILabel *lab1 = [UIFactory createLabelWithFrame:CGRectMake(100, 10+30*i, 180, 20) text:[countArray objectAtIndex:i] textColor:[UIColor whiteColor] textFont:Kfont(13) textAlignment:0];
        lab1.backgroundColor = [UIColor clearColor];
        [bgImgView1 addSubview:lab1];
    }
    
    //button
    UIButton *btn = [[UIButton alloc]init];
    //退出登录
    UIButton *btn1 = [[UIButton alloc]init];
    if(KscreenHeight == 568 || KscreenHeight == 480)
    {
        
        btn.frame = CGRectMake(10, bgImgView1.frame.origin.y+bgImgView1.frame.size.height+20, KscreenWidth-20, 50);
        btn1.frame = CGRectMake(10, bgImgView1.frame.origin.y+bgImgView1.frame.size.height+20+btn.frame.size.height+20, KscreenWidth-20, 50);
    }else
    {
        btn.frame = CGRectMake(10, bgImgView1.frame.origin.y+bgImgView1.frame.size.height+20, KscreenWidth-20, 80);
        btn1.frame = CGRectMake(10, bgImgView1.frame.origin.y+bgImgView1.frame.size.height+20+btn.frame.size.height+20, KscreenWidth-20, 80);
    }
    
    [btn setTitle:@"升级魔方会员" forState:UIControlStateNormal];
    
    [btn1 setTitle:@"退出登录" forState:UIControlStateNormal];
    
    
    
    
    
    [btn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnblue3.png"] forState:UIControlStateNormal];
    
    [btn1 addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"btnblue3.png"] forState:UIControlStateNormal];
    [bgImgView addSubview:btn];
    [bgImgView addSubview:btn1];
    
    btn.tag = 1231;
    btn1.tag = 1232;

    

    
}
//支付
- (void)pay:(UIButton *)btn
{
    
    switch (btn.tag-1231) {
        case 0:
        {
            OrderViewController *order = [[OrderViewController alloc]init];
            //[self presentViewController:order animated:YES completion:nil];
            order.oid = [dataDict objectForKey:@"oid"];
            order.price = [dataDict objectForKey:@"price"];
            [self.navigationController pushViewController:order animated:YES];
            
        }
            break;
        case 1:
        {
            UserInfo *info = [UserInfo shareUserInfo];
            info.token = @"";
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark 自定义导航条
-(UIView *)myNavgationBar:(CGRect)rect andTitle:(NSString *)tit
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title.png"]];
    
    //back button
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(2, 0, 40, view.frame.size.height);
    [back addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"title_icon.png"] forState:UIControlStateNormal];
    [view addSubview:back];
    
    //title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(back.frame.size.width, 0, 200, rect.size.height)];
    title.text = tit;
    title.textColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    title.backgroundColor = [UIColor clearColor];
    [view addSubview:title];
    
    
    
    return view;
}
//返回
-(void)backBtnClick:(UIButton *)btn
{
    NSArray *temArray = self.navigationController.viewControllers;
    
    for(UIViewController *temVC in temArray)
        
    {
        
        if ([temVC isKindOfClass:[SC_AudioOnLineViewController class]])
            
        {
            SC_AudioOnLineViewController*owr = (SC_AudioOnLineViewController *)temVC;
            [self.navigationController popToViewController:owr animated:YES];
            
        }else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
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

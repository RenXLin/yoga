//
//  OrderViewController.m
//  yoga
//
//  Created by cao on 14-7-23.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "OrderViewController.h"


#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "UserInfo.h"

#import "RL_LoginViewController.h"

@implementation Product
@synthesize price = _price;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize orderId = _orderId;

@end
@interface OrderViewController ()

@end

@implementation OrderViewController
{
    UIImageView *bgImgView;
    UIImageView *bgImgView1;
}
@synthesize result = _result;
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
    [self request];
    
    if([[UIDevice currentDevice].systemVersion doubleValue]>7)
    {
        
    }
   
    _result = @selector(paymentResult:);
    [self generateData];

}
- (void)request
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    NSString *URLStr = [NSString stringWithFormat:@"http://www.chinayogaonline.com/api/getMoFangInfo"];
    //      待加入缓冲提示：
    [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] == 200) {
            
            
            
            dataDict = [responseObject objectForKey:@"data"];
            
            [self createUI1];
            [self createUI];     
            
            
            
            
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

- (void)createUI1
{
    bgImgView = [UIFactory createImageViewWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) imageName:@"bg.png"];
    bgImgView.userInteractionEnabled = YES;
    [self.view addSubview:bgImgView];
    
    
    //自定义导航条
    UIView *nav = [self myNavgationBar:CGRectMake(0, iOS7?20:0, KscreenWidth, 44) andTitle:@"升级魔方会员"];
    [bgImgView addSubview:nav];
    //bgimgview
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(5, 64+5, KscreenWidth-10, 95)];
//    bgView.backgroundColor = KCOLOR(240, 240, 240, 1);
//    UIImageView *lineImg = [UIFactory createImageViewWithFrame:CGRectMake(0,bgView.frame.size.height/2, 310, 1) imageName:@""];
//    lineImg.backgroundColor = KCOLOR(214, 214, 214, 1);
//    [bgView addSubview:lineImg];
    
    //[bgImgView addSubview:bgView];
    
    //bgimgview1
    bgImgView1 = [[UIImageView alloc]init];
    bgImgView1.frame = CGRectMake(0,nav.frame.size.height + 20, KscreenWidth, 160);
    bgImgView1.image = [UIImage imageNamed:@""];
    bgImgView1.backgroundColor = [UIColor grayColor];
    [bgImgView addSubview:bgImgView1];
    bgImgView1.backgroundColor = [UIColor colorWithRed:240/250.0f green:240/250.0f blue:240/250.0f alpha:0.3];
    //lab
    
        
        NSString *str1 = [NSString stringWithFormat:@"魔方会员"];
        NSString *str2 = [NSString stringWithFormat:@"价格"];
        NSString *str3 = [NSString stringWithFormat:@"%@",[[dataDict objectForKey:@"price"] description]];
        NSString *str4 = [NSString stringWithFormat:@"说明"];
        NSString *str5 = [NSString stringWithFormat:@"瑜伽魔方"];
        
        NSArray *arr = [NSArray arrayWithObjects:str1,str2,str3,str4,str5, nil];
        
        for (int i=0; i<5; i++) {
            UILabel *lab  = [UIFactory createLabelWithFrame:CGRectMake(10, 10+30*i, 200, 20) text:[arr objectAtIndex:i] textColor:[UIColor whiteColor] textFont:Kfont(13) textAlignment:0];
            [bgImgView1 addSubview:lab];
        
        
        
        
    }
    
    
}
- (void)createUI
{

    //button
    UIButton *btn = [[UIButton alloc]init];
    
    if(KscreenHeight == 568 || KscreenHeight == 480)
    {
       
        btn.frame = CGRectMake(0, bgImgView1.frame.origin.y+bgImgView1.frame.size.height+30, KscreenWidth, 50);
    }else
    {
        btn.frame = CGRectMake(0, bgImgView1.frame.origin.y+bgImgView1.frame.size.height+30, KscreenWidth, 80);
    }
    
    
    
    UserInfo *info = [UserInfo shareUserInfo];
    if(info.token.length == 0)
    {
        [btn setTitle:@"尚未登录，请先登录" forState:UIControlStateNormal];
    }else
    {
     [btn setTitle:@"支付宝付款" forState:UIControlStateNormal];
    }
    
    [btn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnblue3.png"] forState:UIControlStateNormal];
    [bgImgView addSubview:btn];
    
}
//支付
- (void)pay
{
    
    UserInfo *info = [UserInfo shareUserInfo];
    if(info.token.length == 0)
    {
        RL_LoginViewController *login = [[RL_LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    }else
    {
        
        /*
         *生成订单信息及签名
         *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
         */
        
        NSString *appScheme = @"yoga";
        NSString* orderInfo = [self getOrderInfo:0];
        NSString* signedStr = [self doRsa:orderInfo];
        
        NSLog(@"%@",signedStr);
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                 orderInfo, signedStr, @"RSA"];
        
        [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
        
    }
    

}

/*
 *产生商品列表数据
 */
- (void)generateData{
	NSArray *subjects = [[NSArray alloc] initWithObjects:@"魔方会员",nil];
	NSArray *body = [[NSArray alloc] initWithObjects:@"瑜伽魔方",
					 nil];
	
	_products = [[NSMutableArray alloc] init];
    
	for (int i = 0; i < [subjects count]; ++i) {
		Product *product = [[Product alloc] init];
		product.subject = [subjects objectAtIndex:i];
		product.body = [body objectAtIndex:i];
		if (0==i) {
			product.price = [self.price floatValue];
		}
				
		[_products addObject:product];
#if ! __has_feature(objc_arc)
		[product release];
#endif
	}
	
#if ! __has_feature(objc_arc)
	[subjects release], subjects = nil;
	[body release], body = nil;
#endif
}

-(NSString*)getOrderInfo:(NSInteger)index
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
	Product *product = [_products objectAtIndex:index];
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
	order.productName = product.subject; //商品标题
	order.productDescription = product.body; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
	order.notifyURL =  @"http://www.chinayogaonline.com/api/notify_url"; //回调URL
	
	return [order description];
}

- (NSString *)generateTradeNO
{
	const int N = 10;
	
	NSString *sourceString = @"0123456789";
	NSMutableString *result = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
    
    
    const int M = 4;
	
	NSString *sourceString1 = @"0123456789";
	NSMutableString *result1 = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < M; i++)
	{
		unsigned index = rand() % [sourceString1 length];
		NSString *s = [sourceString1 substringWithRange:NSMakeRange(index, 1)];
		[result1 appendString:s];
	}

    
    
    
    	return [NSString stringWithFormat:@"%@-%@-%@",self.oid,result,result1];
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"%@",result);
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}


//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                
                NSLog(@"123");
			}
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
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

//
//  IAPHelper.m
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "IAPHelper.h"
#define ITMS_SANDBOX_VERIFY_RECEIPT_URL     @"https://sandbox.itunes.apple.com/verifyReceipt"
@implementation IAPHelper
@synthesize productIdentifiers = _productIdentifiers;
@synthesize products = _products;
@synthesize purchasedProducts = _purchasedProducts;
@synthesize request = _request;

- (void)initWithProductIdentifiers:(NSSet *)productIdentifiers {
//    if ((self = [super init])) {
    
        // Store product identifiers
        _productIdentifiers = [productIdentifiers retain];
        
        // Check for previously purchased products
        NSMutableSet * purchasedProducts = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [purchasedProducts addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            }
            NSLog(@"Not purchased: %@", productIdentifier);
        }
        self.purchasedProducts = purchasedProducts;
                        
//    }
//    return self;
}


#pragma mark - 从iTunes Connect里面提取产品列表
- (void)requestProducts {
    
    NSLog(@"++++++ %@",_productIdentifiers);
    
    self.request = [[[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers]
                   autorelease];
    // _productIdentifiers ，它包含了一串产品标识符
    //SKProductsRequest实例，那是苹果公司写的一个类，它里面包含从iTunes Connect里面提取信息的代码
    _request.delegate = self;
    [_request start];
    
}
#pragma mark--返回产品列表函数
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Received products results：%@",response.invalidProductIdentifiers);
    self.products = response.products;
    self.request = nil;    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];    
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    // TODO: Record the transaction on the server side...
    

}

- (void)provideContent:(NSString *)productIdentifier {
    
    NSLog(@"Toggling flag for: %@", productIdentifier);
    _productId = [NSString stringWithFormat:@"%@",productIdentifier];
    
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_purchasedProducts addObject:productIdentifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:productIdentifier];
    
}
- (void)request1With:(NSString *)receiptdata
{
     UserInfo *userinfo = [UserInfo shareUserInfo];
    NSString *urlString = [NSString stringWithFormat:@"http://www.chinayogaonline.com/api/IPAValidate?token=%@",[userinfo.userDict objectForKey:@"token"]];
    NSLog(@"%@",urlString);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setValue:receiptdata forKey:@"receiptdata"];
    [dict setValue:_productId forKey:@"productId"];
     NSLog(@"%@",dict);
    
    
    NSLog(@"%@--%@--%@",[userinfo.userDict objectForKey:@"id"],receiptdata,_productId);
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"%@",responseObject);
         if (responseObject != nil)
         {
             if ([responseObject isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary * dict=[NSDictionary dictionaryWithDictionary:responseObject];
                 if([[dict valueForKey:@"code"]intValue]==200) //请求成功
                 {
                     userinfo.role = _productId;
                     
                 }
                 
                 
             }
         }
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             KAlert(@"请求失败");
             
             
             NSLog(@"%@",error.localizedDescription);
             
         } ];
    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"completeTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    NSLog(@"ppppppp%@",[transaction transactionReceipt]);
    
    NSString*encodingStr = [[transaction transactionReceipt] base64Encoding];
//    encodingStr = [encodingStr cs];
  
    
    [self request1With:encodingStr];
    
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"restoreTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)buyProductIdentifier:(NSString *)productIdentifier {
    
    NSLog(@"Buying %@...", productIdentifier);
    
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)dealloc
{
    [_productIdentifiers release];
    _productIdentifiers = nil;
    [_products release];
    _products = nil;
    [_purchasedProducts release];
    _purchasedProducts = nil;
    [_request release];
    _request = nil;
    [super dealloc];
}

@end

//
//  OrderViewController.h
//  yoga
//
//  Created by cao on 14-7-23.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Product : NSObject{
@private
	float _price;
	NSString *_subject;
	NSString *_body;
	NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *orderId;

@end

@interface OrderViewController : UIViewController
{
    NSMutableArray *_products;
    SEL _result;
    
    
    NSMutableDictionary *dataDict;
}
@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
@property (nonatomic,assign) NSString *oid;
@property (nonatomic,assign) NSString *price;

@end

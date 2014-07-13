//
//  SC_AudioOnLineViewController.h
//  yoga
//
//  Created by 123 on 14-7-13.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SC_AudioOnLineViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray *dataArray;
}
@property (nonatomic,copy) NSString *Title;

@end

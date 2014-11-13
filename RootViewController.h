//
//  RootViewController.h
//  yoga
//
//  Created by 123 on 14-11-1.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

@interface RootViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate> {
    MBProgressHUD *_hud;
    UITableView *TableView;
}

@property (retain) MBProgressHUD *hud;


@end

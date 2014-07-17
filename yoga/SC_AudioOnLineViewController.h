//
//  SC_AudioOnLineViewController.h
//  yoga
//
//  Created by 123 on 14-7-13.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLTableAlert;
@interface SC_AudioOnLineViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIAlertViewDelegate>

{
    
    NSMutableArray *dataArray;
    NSMutableArray *searchResults;
    NSMutableArray *sortArray;
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
    
    
    
}

@property (strong, nonatomic) MLTableAlert *alert;
@property (nonatomic,copy) NSString *Title;
@property (nonatomic,copy) NSString *audio;
@end

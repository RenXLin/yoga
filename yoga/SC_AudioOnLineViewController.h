//
//  SC_AudioOnLineViewController.h
//  yoga
//
//  Created by 123 on 14-7-13.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SC_AudioOnLineViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

{
   
        NSMutableArray *dataArray;
        NSMutableArray *dataArray1;
        NSMutableArray *searchResults;
        UISearchBar *mySearchBar;
        UISearchDisplayController *searchDisplayController;
        
    

}

@property (strong, nonatomic) NSMutableArray *options;
@property (nonatomic,copy) NSString *Title;
@property (nonatomic,copy) NSString *audio;
@end

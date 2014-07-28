//
//  RL_FMViewController.h
//  yoga
//
//  Created by renxlin on 14-7-12.
//  Copyright (c) 2014年 任小林. All rights reserved.
//  瑜伽FM视图控制器

#import <UIKit/UIKit.h>
#import "Vitamio.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RL_FMViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,VMediaPlayerDelegate,MPMediaPickerControllerDelegate>

//用于区分是fm还是音乐，公用一个视图控制器：
@property (nonatomic,strong)NSString *FM_AV;


@end

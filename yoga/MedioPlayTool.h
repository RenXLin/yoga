//
//  MedioPlayTool.h
//  yoga
//
//  Created by renxlin on 14-7-20.
//  Copyright (c) 2014年 任小林. All rights reserved.
//  媒体播放控制器视图：

#import <UIKit/UIKit.h>

@interface MedioPlayTool : UIView

@property(nonatomic,strong)UILabel *havePlay;
@property(nonatomic,strong)UILabel *totalPlay;
@property(nonatomic,strong)UISlider *playProgress;

@property(nonatomic,strong)UIButton *lastProgram;
@property(nonatomic,strong)UIButton *isPlayOrPause;
@property(nonatomic,strong)UIButton *nextProgram;
@property(nonatomic,strong)UIButton *fullScreenOrNot;



-(void)setBtnDelegate:(id)target andSEL:(SEL)sel;



@end

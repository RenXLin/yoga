//
//  MedioPlayTool.m
//  yoga
//
//  Created by renxlin on 14-7-20.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "MedioPlayTool.h"

#define TimeLabel_whide  70
#define TimeLabel_height  10
#define self_Height    60

@implementation MedioPlayTool


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setAutoresizesSubviews:YES];
        
        self.backgroundColor = [UIColor clearColor];
        //已播放的时间显示label；

        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self_Height);
        self.backgroundColor = [UIColor blackColor];
        _havePlay = [[UILabel alloc] init];
        _havePlay.backgroundColor = [UIColor clearColor];
        _havePlay.font = [UIFont systemFontOfSize:15];
        _havePlay.text = @"00:00:00";
        _havePlay.frame = CGRectMake(0, 4, TimeLabel_whide,TimeLabel_height);
        _havePlay.textColor = [UIColor whiteColor];
        _havePlay.textAlignment = NSTextAlignmentLeft;
        _havePlay.numberOfLines = 1;
        _havePlay.tag = 1;
        [self addSubview:_havePlay];
        
        [_havePlay setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |
         UIViewAutoresizingFlexibleTopMargin |
         UIViewAutoresizingFlexibleWidth];
        
        //媒体总时间显示label：
        _totalPlay = [[UILabel alloc] init];
        _totalPlay.backgroundColor = [UIColor clearColor];
        _totalPlay.font = [UIFont systemFontOfSize:15];
        _totalPlay.text = @"00:00:00";
        _totalPlay.frame = CGRectMake(self.frame.size.width - TimeLabel_whide, 4, TimeLabel_whide,TimeLabel_height);
        _totalPlay.textColor = [UIColor whiteColor];
        _totalPlay.textAlignment = NSTextAlignmentRight;
        _totalPlay.numberOfLines = 1;
        _totalPlay.tag = 1;
        [self addSubview:_totalPlay];
        [_totalPlay setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |
         UIViewAutoresizingFlexibleTopMargin |
         UIViewAutoresizingFlexibleWidth];
        
        //添加进度条：
        _playProgress = [[UISlider alloc] initWithFrame:CGRectMake(TimeLabel_whide, 4, self.frame.size.width - 2 * TimeLabel_whide, TimeLabel_height)];
        _playProgress.backgroundColor = [UIColor clearColor];
        _playProgress.minimumTrackTintColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_jg" ofType:@"png"]]];
        [_playProgress setThumbImage:[UIImage imageNamed:@"video_icon8.png"] forState:UIControlStateNormal];
        _playProgress.maximumTrackTintColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_jg1" ofType:@"png"]]];
        [self addSubview:_playProgress];
        [_playProgress setAutoresizingMask: 
         UIViewAutoresizingFlexibleTopMargin |
         UIViewAutoresizingFlexibleWidth];
        
        //添加播放控制按钮
        _fullScreenOrNot = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreenOrNot.frame = CGRectMake(0, TimeLabel_height, self_Height - TimeLabel_height, self_Height - TimeLabel_height);
        _fullScreenOrNot.backgroundColor = [UIColor clearColor];
//        [_fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon3" ofType:@"png"]] forState:UIControlStateNormal];
//        [_fullScreenOrNot setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon3_1" ofType:@"png"]] forState:UIControlStateHighlighted];
        [self addSubview:_fullScreenOrNot];
        _fullScreenOrNot.tag = 1;
        [_fullScreenOrNot setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |
         UIViewAutoresizingFlexibleBottomMargin |
         UIViewAutoresizingFlexibleWidth];
        
        //下一首
        _nextProgram = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextProgram.frame = CGRectMake(self.frame.size.width - 50, TimeLabel_height, self_Height - TimeLabel_height, self_Height - TimeLabel_height);
        _nextProgram.backgroundColor = [UIColor clearColor];
        [_nextProgram setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon6" ofType:@"png"]] forState:UIControlStateNormal];
        [_nextProgram setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon6_1" ofType:@"png"]] forState:UIControlStateHighlighted];
        [self addSubview:_nextProgram];
        _nextProgram.tag = 4;
        [_nextProgram setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |
         UIViewAutoresizingFlexibleBottomMargin |
         UIViewAutoresizingFlexibleWidth];
        
        //播放或暂停
        _isPlayOrPause = [UIButton buttonWithType:UIButtonTypeCustom];
        _isPlayOrPause.frame = CGRectMake(self.frame.size.width - 100, TimeLabel_height, self_Height - TimeLabel_height, self_Height - TimeLabel_height);
        _isPlayOrPause.backgroundColor = [UIColor clearColor];
        [_isPlayOrPause setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_pause" ofType:@"png"]] forState:UIControlStateNormal];
        [_isPlayOrPause setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_play" ofType:@"png"]] forState:UIControlStateSelected];
        [self addSubview:_isPlayOrPause];
        _isPlayOrPause.showsTouchWhenHighlighted = YES;
        _isPlayOrPause.tag = 3;
        [_isPlayOrPause setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |
         UIViewAutoresizingFlexibleBottomMargin |
         UIViewAutoresizingFlexibleWidth];
        
        //上一首
        _lastProgram = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastProgram.frame = CGRectMake(self.frame.size.width - 150, TimeLabel_height, self_Height - TimeLabel_height, self_Height - TimeLabel_height);
        _lastProgram.backgroundColor = [UIColor clearColor];
        [_lastProgram setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon5" ofType:@"png"]] forState:UIControlStateNormal];
        [_lastProgram setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_icon5_1" ofType:@"png"]] forState:UIControlStateHighlighted];
        [self addSubview:_lastProgram];
        _lastProgram.tag = 2;
        [_lastProgram setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |
         UIViewAutoresizingFlexibleBottomMargin |
         UIViewAutoresizingFlexibleWidth];
    }
    return self;
}
-(void)setBtnDelegate:(id)target andSEL:(SEL)sel andSliderSel:(SEL)sliderChange andTapGesture:(SEL)GestureSel
{
    [_fullScreenOrNot addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [_lastProgram addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [_isPlayOrPause addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [_nextProgram addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];   
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc]
								   initWithTarget:target
								   action:GestureSel];
    [_playProgress addGestureRecognizer:gr];
    [_playProgress addTarget:target action:sliderChange forControlEvents:UIControlEventValueChanged];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

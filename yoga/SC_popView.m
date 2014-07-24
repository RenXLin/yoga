//
//  SC_popView.m
//  yoga
//
//  Created by 123 on 14-7-22.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "SC_popView.h"
#import "RL_LoginViewController.h"
@interface SC_popView (private)

- (void)fadeIn;
- (void)fadeOut;
@end

@implementation SC_popView
{
    UIView *bgView;
    UIImageView *img;
    
    UILabel *lab;
}
@synthesize delegate;
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions With:(UIButton *)btn With:(UIButton *)btn1
{

    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor colorWithRed:240 green:240 blue:240 alpha:0.3];
        
        
        if(KscreenHeight == 568 ||KscreenHeight == 480)
        {
           self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10, (KscreenHeight-130)/2, KscreenWidth-20, 130)];
            img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth-20, 130)];
            lab = [[UILabel alloc]initWithFrame:CGRectMake(2, 2, KscreenWidth-24, 80)];
            lab.numberOfLines = 0;
        }else
        {
            self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10, (KscreenHeight-400)/2, KscreenWidth-20, 400)];
            img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth-20, 400)];
            lab = [[UILabel alloc]initWithFrame:CGRectMake(2, 2, KscreenWidth-24, 80)];
            
        }
        [self addSubview:self.bgView];
        
        
        img.image = [UIImage imageNamed:@"inut.png"];
        [self.bgView addSubview:img];
        
        
        lab.textColor = [UIColor whiteColor];
        lab.backgroundColor = [UIColor blackColor];
        [self.bgView addSubview:lab];
        _title = [aTitle copy];
        
        lab.text = [NSString stringWithFormat:@"%@",_title];
        
        if(KscreenHeight == 480 || KscreenHeight == 568)
        {
            
            lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.];
            
        }else
        {
            lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:37.];
            
        }
        
        _options = [aOptions copy];
        
               
    }
    return self;

}
#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - TouchTouchTouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tell the delegate the cancellation
      // dismiss self
    [self fadeOut];
}


#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
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

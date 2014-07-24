//
//  SC_popView.h
//  yoga
//
//  Created by 123 on 14-7-22.
//  Copyright (c) 2014年 任小林. All rights reserved.
//


@protocol PopListViewDelegate;
@interface SC_popView : UIView
{
    NSString *_title;
    NSArray *_options;
}
@property (strong,nonatomic) UIView *bgView;
@property (nonatomic, assign) id<PopListViewDelegate> delegate;

// The options is a NSArray, contain some NSDictionaries, the NSDictionary contain 2 keys, one is "img", another is "text".
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions With:(UIButton *)btn With:(UIButton *)btn1;
// If animated is YES, PopListView will be appeared with FadeIn effect.
- (void)showInView:(UIView *)aView animated:(BOOL)animated;


@end
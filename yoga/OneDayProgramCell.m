//
//  OneDayProgramCell.m
//  yoga
//
//  Created by renxlin on 14-7-30.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "OneDayProgramCell.h"

@implementation OneDayProgramCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.autoresizesSubviews = YES;
        
        _label_Time = [[UILabel alloc] init];
        _label_Time.backgroundColor = [UIColor clearColor];
        _label_Time.font = [UIFont systemFontOfSize:12];
        _label_Time.lineBreakMode = NSLineBreakByTruncatingTail;
        //UILabel 自适应大小（IOS7 方法）;
        _label_Time.frame = CGRectMake(0, 0, self.frame.size.width / 3,self.frame.size.height);
        _label_Time.layer.cornerRadius = 10;
        _label_Time.textColor = [UIColor blackColor];
        _label_Time.textAlignment = NSTextAlignmentCenter;
        _label_Time.numberOfLines = 1;
        _label_Time.tag = 0;
        _label_Time.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_label_Time];
        
        _label_Time.autoresizingMask =
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleWidth;

        
        
        _label_Title = [[UILabel alloc] init];
        _label_Title.frame = CGRectMake(self.frame.size.width / 3+10, 0, self.frame.size.width * 2 / 3, self.frame.size.height);
        _label_Title.backgroundColor = [UIColor clearColor];
        _label_Title.font = [UIFont systemFontOfSize:13];
        _label_Title.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_Title.layer.cornerRadius = 5;
        _label_Title.textColor = [UIColor blackColor];
        _label_Title.textAlignment = NSTextAlignmentLeft;
        _label_Title.numberOfLines = 0;
        _label_Title.tag = 0;
        _label_Title.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_label_Title];
        
        _label_Title.autoresizingMask =
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleWidth;

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

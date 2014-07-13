//
//  AudioCell.m
//  yoga
//
//  Created by cao on 14-7-13.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "AudioCell.h"
#import "SC_Model.h"
@interface AudioCell()

@property (nonatomic,weak) UILabel *titleLab;
@property (nonatomic,weak) UILabel *timeLab;
@end

@implementation AudioCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        UILabel *titleLab = [UIFactory createLabelWithFrame:CGRectMake(10, 0, 150, 37) text:@"" textColor:[UIColor darkGrayColor] textFont:Kfont(14) textAlignment:0];
        titleLab.numberOfLines = 0;
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
        
        UILabel *timeLab = [UIFactory createLabelWithFrame:CGRectMake(165, 0, 100, 37) text:@"" textColor:[UIColor darkGrayColor] textFont:Kfont(14) textAlignment:0];
        [self.contentView addSubview:timeLab];
        
        self.timeLab = timeLab;
        
        
        
    }
    return self;
}

- (void)setModel:(SC_Model *)model
{
    _model = model;
    [self setingData];
    [self setingFrame];
}
- (void)setingData
{
    self.titleLab.text = _model.title;
    self.timeLab.text = _model.timelength;
    
}
- (void)setingFrame
{
    
    
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

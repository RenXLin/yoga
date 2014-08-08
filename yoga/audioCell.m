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

@end

@implementation AudioCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
        self.frame = CGRectMake(0, 0, KscreenWidth, 80);
            
            UILabel *cgLab = [UIFactory createLabelWithFrame:CGRectMake(0, 0, 280, 80) text:@"" textColor:[UIColor darkGrayColor] textFont:Kfont(28) textAlignment:1];
            [self.contentView addSubview:cgLab];
            cgLab.backgroundColor = [UIColor clearColor];
            self.cgLab = cgLab;
            
            
            UILabel *titleLab = [UIFactory createLabelWithFrame:CGRectMake(10, 0, 250, 80) text:@"" textColor:[UIColor darkGrayColor] textFont:Kfont(28) textAlignment:0];
            titleLab.numberOfLines = 0;
            titleLab.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:titleLab];
            self.titleLab = titleLab;
            
            UILabel *timeLab = [UIFactory createLabelWithFrame:CGRectMake(285, 0, 200, 80) text:@"" textColor:[UIColor darkGrayColor] textFont:Kfont(28) textAlignment:0];
            [self.contentView addSubview:timeLab];
            titleLab.backgroundColor = [UIColor clearColor];
            self.timeLab = timeLab;
            

        }else
        {
          self.frame = CGRectMake(0, 0, KscreenWidth, 50);
            
            UILabel *cgLab = [UIFactory createLabelWithFrame:CGRectMake(0, 0, 280, 50) text:@"" textColor:[UIColor darkGrayColor] textFont:Kfont(14) textAlignment:1];
            [self.contentView addSubview:cgLab];
            self.cgLab = cgLab;
            
            
            UILabel *titleLab = [UIFactory createLabelWithFrame:CGRectMake(10, 0, 150, 50) text:@"" textColor:[UIColor darkGrayColor] textFont:Kfont(14) textAlignment:0];
            titleLab.numberOfLines = 0;
            titleLab.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:titleLab];
            self.titleLab = titleLab;
            
            UILabel *timeLab = [UIFactory createLabelWithFrame:CGRectMake(165, 0, 100, 50) text:@"" textColor:[UIColor darkGrayColor] textFont:Kfont(14) textAlignment:0];
            [self.contentView addSubview:timeLab];
            timeLab.backgroundColor = [UIColor clearColor];
            self.timeLab = timeLab;
            

        }
        
        
        
        
        
        
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
    self.timeLab.text = [self turnWith:_model.timelength];
    self.cgLab.text = _model.cname;
    
}
- (void)setingFrame
{
    
    
}

- (NSString *)turnWith:(NSString *)str
{
    
    if([str intValue]>=3600)
    {
        return [NSString stringWithFormat:@"%d:%d:%d",[str intValue]/3600,([str intValue]%3600)/60,([str intValue]%3600)%60%60];
    }else if ([str intValue]<3600 && [str intValue]>60)
    {
        return [NSString stringWithFormat:@"%d:%d",[str intValue]/60,([str intValue]%60)%60];
    }else
    {
        return str;
    }
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

//
//  LeveyPopListView.m
//  LeveyPopListViewDemo
//
//  Created by Levey on 2/21/12.
//  Copyright (c) 2012 Levey. All rights reserved.
//

#import "LeveyPopListView.h"
#import "LeveyPopListViewCell.h"
#import "SC_Model.h"
#define POPLISTVIEW_SCREENINSET 20.
#define POPLISTVIEW_HEADER_HEIGHT 80.
#define RADIUS 5.

@interface LeveyPopListView (private)

- (void)fadeIn;
- (void)fadeOut;
@end

@implementation LeveyPopListView
{
    UIView *bgView;
    UIImageView *img;
    UIButton *btn;
    UILabel *lab;
}
@synthesize delegate;
#pragma mark - initialization & cleaning up
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor colorWithRed:240 green:240 blue:240 alpha:0.3];
        
        
        if(KscreenHeight == 568 ||KscreenHeight == 480)
        {
            bgView = [[UIView alloc]initWithFrame:CGRectMake(10, (KscreenHeight-250)/2, KscreenWidth-20, 250)];
            img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth-20, 250)];
            lab = [[UILabel alloc]initWithFrame:CGRectMake(2, 2, KscreenWidth-24, 50)];
        }else
        {
            bgView = [[UIView alloc]initWithFrame:CGRectMake(10, (KscreenHeight-400)/2, KscreenWidth-20, 400)];
            img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth-20, 400)];
            lab = [[UILabel alloc]initWithFrame:CGRectMake(2, 2, KscreenWidth-24, 80)];
            
        }
        [self addSubview:bgView];
        
        
        
        img.image = [UIImage imageNamed:@"inut.png"];
        [bgView addSubview:img];
        
        
        lab.textColor = [UIColor whiteColor];
        lab.backgroundColor = [UIColor blackColor];
        [bgView addSubview:lab];
        _title = [aTitle copy];
        
        lab.text = [NSString stringWithFormat:@"   %@",_title];
        
        if(KscreenHeight == 480 || KscreenHeight == 568)
        {
            
            lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.];
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50,KscreenWidth-20,150)];
        }else
        {
          lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:37.];
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,80,KscreenWidth-20,240)];
        }

        _options = [aOptions copy];
        
        
        _tableView.separatorColor = [UIColor colorWithWhite:0 alpha:.2];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [bgView addSubview:_tableView];
        
        if(KscreenHeight == 568 || KscreenHeight == 480)
        {
             btn = [[UIButton alloc]initWithFrame:CGRectMake((bgView.frame.size.width-180)/2, lab.frame.size.height+_tableView.frame.size.height+5, 180, 40)];
        }else
        {
           btn = [[UIButton alloc]initWithFrame:CGRectMake((bgView.frame.size.width-300)/2, lab.frame.size.height+_tableView.frame.size.height+10, 300, 60)];
        }
        
        [btn setBackgroundImage:[UIImage imageNamed:@"white_btn1.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = Kfont(20);
        [bgView addSubview:btn];
        

    }
    return self;    
}

- (void)back
{
    [self fadeOut];
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

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"PopListViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        cell = [[LeveyPopListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    NSInteger row = [indexPath row];
    //cell.imageView.image = [[_options objectAtIndex:row] objectForKey:@"img"];
    SC_Model *model = [_options objectAtIndex:row];
    cell.textLabel.text = model.cname;
    if(KscreenHeight == 480 || KscreenHeight == 568)
    {
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    }else
    {
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:37]];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // tell the delegate the selection
    if (self.delegate && [self.delegate respondsToSelector:@selector(leveyPopListView:didSelectedIndex:)]) {
        [self.delegate leveyPopListView:self didSelectedIndex:[indexPath row]];
    }
    
    // dismiss self
    [self fadeOut];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(KscreenHeight == 480 || KscreenHeight == 568)
    {
        return 50;
    }else
    {
        return 80;
    }
    
}
#pragma mark - TouchTouchTouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tell the delegate the cancellation
    if (self.delegate && [self.delegate respondsToSelector:@selector(leveyPopListViewDidCancel)]) {
        [self.delegate leveyPopListViewDidCancel];
    }
    
    // dismiss self
    [self fadeOut];
}

#pragma mark - DrawDrawDraw
- (void)drawRect:(CGRect)rect
{
//    CGRect bgRect = CGRectInset(rect,20, 200);
//    CGRect titleRect = CGRectMake(POPLISTVIEW_SCREENINSET + 10, POPLISTVIEW_SCREENINSET + 10 + 5,
//                                  rect.size.width -  2 * (POPLISTVIEW_SCREENINSET + 10), 30);
//    CGRect separatorRect = CGRectMake(POPLISTVIEW_SCREENINSET, POPLISTVIEW_SCREENINSET + POPLISTVIEW_HEADER_HEIGHT - 2,
//                                      rect.size.width - 2 * POPLISTVIEW_SCREENINSET, 2);
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw the background with shadow
//    CGContextSetShadowWithColor(ctx, CGSizeZero, 6., [UIColor colorWithWhite:0 alpha:.75].CGColor);
    //CGContextSetShadowWithColor(ctx, CGSizeZero, 6., [UIColor blackColor].CGColor);
    //[[UIColor colorWithWhite:0 alpha:.75] setFill];
//    [[UIColor blackColor] setFill];
//
//    
//    float x = POPLISTVIEW_SCREENINSET;
//    float y = POPLISTVIEW_SCREENINSET;
//    float width = bgRect.size.width;
//    float height = bgRect.size.height;
//    CGMutablePathRef path = CGPathCreateMutable();
//	CGPathMoveToPoint(path, NULL, x, y + RADIUS);
//	CGPathAddArcToPoint(path, NULL, x, y, x + RADIUS, y, RADIUS);
//	CGPathAddArcToPoint(path, NULL, x + width, y, x + width, y + RADIUS, RADIUS);
//	CGPathAddArcToPoint(path, NULL, x + width, y + height, x + width - RADIUS, y + height, RADIUS);
//	CGPathAddArcToPoint(path, NULL, x, y + height, x, y + height - RADIUS, RADIUS);
//	CGPathCloseSubpath(path);
//	CGContextAddPath(ctx, path);
//    CGContextFillPath(ctx);
//    CGPathRelease(path);
//    
//    // Draw the title and the separator with shadow
//    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0.5f, [UIColor blackColor].CGColor);
//    [[UIColor whiteColor] setFill];
//    if(KscreenHeight == 480 || KscreenHeight == 568)
//    {
//      [_title drawInRect:titleRect withFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.]];
//    }else
//    {
//      [_title drawInRect:titleRect withFont:[UIFont fontWithName:@"Helvetica-Bold" size:37.]];
//    }
    
//    CGContextFillRect(ctx, separatorRect);
}

@end

//
//  MainViewController.m
//  yoga
//
//  Created by renxlin on 14-7-12.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "MainViewController.h"






#define GAP_WITH  2.5  //定义白色边框的大小：

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor grayColor];
    
    //添加白色底板
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, [UIScreen mainScreen].bounds.size.width-10, [UIScreen mainScreen].bounds.size.width-10)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];

    CGFloat rect_width = (whiteView.frame.size.width - GAP_WITH * 4) / 3;
    for (int i = 0; i < 3 ; i++) {
        
        for (int j = 0; j < 3; j++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(GAP_WITH *(j + 1) + j * rect_width, GAP_WITH *(i + 1) + i * rect_width , rect_width, rect_width)];
            view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"color_bg" ofType:@"png"]]];
            view.tag = i * 3 + j+1; //(1 2...9)
            view.contentMode = UIViewContentModeScaleToFill;
            [whiteView addSubview:view];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
            [view addGestureRecognizer:tap];
        }
        
        
        
//        [whiteView addSubview:btn_FM];

    }
    
    
}

-(void)tapClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"gestuer tap");
    UIView *view = tap.view;
    NSLog(@"%d",view.tag);
}







//本视图仅支持竖屏：
-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

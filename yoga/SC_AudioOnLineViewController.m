//
//  SC_AudioOnLineViewController.m
//  yoga
//
//  Created by 123 on 14-7-13.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "SC_AudioOnLineViewController.h"

@interface SC_AudioOnLineViewController ()
{
    //当前在线人数
    UILabel *_onlinePeople;
}
@end

@implementation SC_AudioOnLineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KCOLOR(57, 61, 64, 1);
    
   
    [self creatUI];
    
}

- (void)creatUI
{
    UIImageView *bgImgView = [UIFactory createImageViewWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) imageName:@"bg.png"];
    bgImgView.userInteractionEnabled = YES;
    [self.view addSubview:bgImgView];
    
    
    //自定义导航条
    UIView *nav = [self myNavgationBar:CGRectMake(0, 20, KscreenWidth, 44) andTitle:self.Title];
    [bgImgView addSubview:nav];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(5, 64+5, KscreenWidth-10, 95)];
    bgView.backgroundColor = KCOLOR(240, 240, 240, 1);
    UIImageView *lineImg = [UIFactory createImageViewWithFrame:CGRectMake(0,bgView.frame.size.height/2, 310, 1) imageName:@""];
    lineImg.backgroundColor = KCOLOR(214, 214, 214, 1);
    [bgView addSubview:lineImg];
    
    [bgImgView addSubview:bgView];
    
    
    UILabel *audioLab = [UIFactory createLabelWithFrame:CGRectMake(bgView.frame.origin.x+5,bgView.frame.origin.y+(bgView.frame.size.height/2-20)/2,75,20) text:self.Title textColor:[UIColor blackColor] textFont:Kfont(17) textAlignment:0];
    [bgImgView addSubview:audioLab];
    
    
    //分类筛选按钮
    UIButton *sortBtn = [UIFactory createButtonWithFrame:CGRectMake(205, (bgView.frame.size.height/2-35)/2, 100, 35) title:@"选择分类筛选" bgImageName:@"xlk.png" target:self action:@selector(sortBtnClick:)];
    [sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sortBtn.titleLabel.font = Kfont(11);
    sortBtn.tag = 110;
    [bgView addSubview:sortBtn];
    
    UIImageView *sortImg = [UIFactory createImageViewWithFrame:CGRectMake(295,(bgView.frame.size.height/2-10)/2+64+4, 10,10) imageName:@"a1.png"];
    [bgImgView addSubview:sortImg];
    
    
    UIImageView *iputImg = [UIFactory createImageViewWithFrame:CGRectMake(5,(bgView.frame.size.height/2+(bgView.frame.size.height/2-35)/2), 260,35) imageName:@"white_btn.png"];
    [bgView addSubview:iputImg];
    
    UITextField *inputTf = [UIFactory createTextFieldWithFrame:CGRectMake(10,(bgView.frame.size.height/2+(bgView.frame.size.height/2-35)/2), 250,35) borderStyle:UITextBorderStyleNone placeHolder:@"输入关键词搜索" secureEntry:NO delegate:self];
    inputTf.font = Kfont(13);
    
    [bgView addSubview:inputTf];
    
    
    UIButton *searchBtn = [UIFactory createButtonWithFrame:CGRectMake(270, bgView.frame.size.height/2+(bgView.frame.size.height/2-30)/2, 30, 30) title:@"" bgImageName:@"btnblue.png" target:self action:@selector(sortBtnClick:)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"btnblue_press.png"] forState:UIControlStateHighlighted];
    searchBtn.tag = 111;
    [bgView addSubview:searchBtn];
    
    UIImageView *searchImg = [UIFactory createImageViewWithFrame:CGRectMake(5,5, 25,25)imageName:@"放大镜0017.png"];
    [searchBtn addSubview:searchImg];
    
    
    UITableView *TableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 5+95+64, 310, 350) style:UITableViewStylePlain];
    TableView.delegate = self;
    TableView.dataSource = self;
    [bgImgView addSubview:TableView];
    
    
    
    //loginview
    UIButton *loginView = [UIButton buttonWithType:UIButtonTypeCustom];
    loginView.frame = CGRectMake(40, TableView.frame.origin.y+TableView.frame.size.height+5, 40, 40);
    [loginView addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue1" ofType:@"png"]] forState:UIControlStateNormal];
    loginView.tag = 112;
    [bgImgView addSubview:loginView];
    
    //当前在线人数
    _onlinePeople = [[UILabel alloc] initWithFrame:CGRectMake(loginView.frame.size.width + loginView.frame.origin.x, loginView.frame.origin.y, KscreenWidth -(loginView.frame.size.width + loginView.frame.origin.x)*2 , loginView.frame.size.height)];
    UserInfo *info = [UserInfo shareUserInfo];
    _onlinePeople.text = info.onliePeople;//暂定
    _onlinePeople.font = Kfont(12);
    _onlinePeople.textAlignment = NSTextAlignmentCenter;
    _onlinePeople.adjustsFontSizeToFitWidth = YES;
    _onlinePeople.textAlignment = NSTextAlignmentCenter;
    _onlinePeople.textColor = [UIColor whiteColor];
    [bgImgView addSubview:_onlinePeople];
    
    //settting View
    UIButton *settingView = [UIButton buttonWithType:UIButtonTypeCustom];
    settingView.frame = CGRectMake(KscreenWidth-74, TableView.frame.origin.y+TableView.frame.size.height+5, 40, 40);
    [settingView addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [settingView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue" ofType:@"png"]] forState:UIControlStateNormal];
    settingView.tag = 113;
    [bgImgView addSubview:settingView];
}


#pragma mark 分类筛选按钮点击事件
- (void)sortBtnClick:(UIButton *)btn
{
    switch (btn.tag - 110) {
            //分类筛选
        case 0:
        {
            
        }
            break;
            //search
        case 1:
        {
            
        }
            break;
            //login
        case 2:
        {
            
        }
            break;
            //setting
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark 自定义导航条
-(UIView *)myNavgationBar:(CGRect)rect andTitle:(NSString *)tit
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title.png"]];
    
    //back button
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(2, 0, 40, view.frame.size.height);
    [back addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"title_icon.png"] forState:UIControlStateNormal];
    [view addSubview:back];
    
    //title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(back.frame.size.width, 0, 70, rect.size.height)];
    title.text = tit;
    title.textColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    [view addSubview:title];
    

    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37;
}


-(void)backBtnClick:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

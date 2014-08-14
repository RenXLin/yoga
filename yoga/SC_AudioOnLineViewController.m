//
//  SC_AudioOnLineViewController.m
//  yoga
//
//  Created by 123 on 14-7-13.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "SC_AudioOnLineViewController.h"
#import "SC_Model.h"
#import "AudioCell.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "VideoPlayerController.h"
#import "LeveyPopListView.h"

#import "SC_popView.h"

#import "RL_LoginViewController.h"
#import "OrderViewController.h"
#import "MJRefresh.h"
@interface SC_AudioOnLineViewController ()<LeveyPopListViewDelegate>
{
    //当前在线人数
    UILabel *_onlinePeople;
    UITableView *TableView;
    UITextField *inputTf;
    UITableView *TableView1;
    UIButton *sortBtn;
    
    UIButton *Lbtn;
    UIButton *Rbtn1;
    SC_popView *lplv;
    
    NSString *cid;
    NSInteger  limit;
    
    BOOL isloading;
    UIView *bgView;
}

@end

@implementation SC_AudioOnLineViewController
@synthesize options = _options;
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

//刷新在线人数 method
-(void)refreshPeople
{
    UserInfo *info =[UserInfo shareUserInfo];
    _onlinePeople.text = info.onliePeople;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"--------------%@",KDEVICE);
    self.view.backgroundColor = KCOLOR(57, 61, 44, 1);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPeople) name:NOT_refreshOnlinePeople object:nil];
    
    //数据源初始化
    dataArray = [[NSMutableArray alloc]init];
    pageDataArray = [[NSMutableArray alloc]init];
    dataArray1 = [[NSMutableArray alloc]init];
    [self creatUI];
    [self request];
    
    [self  setupRefresh];
    
    limit = 10;
    
    [NSThread detachNewThreadSelector:@selector(request1) toTarget:self withObject:nil];
    
}
- (void)request1
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *URLStr = [NSString stringWithFormat:@"%@",self.audio!=nil?SORT_AUDIOPICKLIST_URL:SORT_VIDEOLIST_ULR];
    //      待加入缓冲提示：
    SVProgressHUDShow;
    [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] == 200) {
            
            [SVProgressHUD dismiss];
            NSLog(@"%@",responseObject);
            
            if([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]&&[responseObject objectForKey:@"data"]!=nil)
            {
                
                for(NSDictionary *dict in [responseObject objectForKey:@"data"])
                {
                    
                    
                    SC_Model *model = [[SC_Model alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [dataArray1 addObject:model];
                    
                    _options = dataArray1;
                    if(dataArray1.count!=0)
                    {
                        
                    }
                }
                
            }
            
            [TableView1 reloadData];
            
            
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    //                }
    //                btn.selected = YES;
    //               [self show];
    
    


}
- (void)request
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *URLStr = [NSString stringWithFormat:@"%@",self.audio!=nil?AUDIOPICKLIST_URL:VIDIOPICKLIST_URL];
    //      待加入缓冲提示：
    [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] == 200) {
            
            NSLog(@"%@",responseObject);
            [pageDataArray removeAllObjects];
            [dataArray removeAllObjects];
            if([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]&&[responseObject objectForKey:@"data"]!=nil)
            {
                
                for(NSDictionary *dict in [responseObject objectForKey:@"data"])
                {
                    SC_Model *model = [[SC_Model alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [pageDataArray addObject:model];
                    
                    if(dataArray.count<10)
                    {
                        [dataArray addObject:model];
                    }
                    
                }
                
            }
            
            [TableView headerEndRefreshing];
            [TableView reloadData];
        }else{
            [TableView headerEndRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TableView headerEndRefreshing];
    }];
    

}

- (void)creatUI
{
    UIImageView *bgImgView = [UIFactory createImageViewWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) imageName:@"bg.png"];
    bgImgView.userInteractionEnabled = YES;
    [self.view addSubview:bgImgView];
    
    
    //自定义导航条
    UIView *nav = [self myNavgationBar:CGRectMake(0,iOS7?20:0, KscreenWidth, 44) andTitle:self.Title];
    [bgImgView addSubview:nav];
    
    //
    
   
    
    
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        bgView = [[UIView alloc]initWithFrame:CGRectMake(5, 44+5+(iOS7?20:0), KscreenWidth-10, 130)];
        bgView.backgroundColor = KCOLOR(240, 240, 240, 1);
        UIImageView *lineImg = [UIFactory createImageViewWithFrame:CGRectMake(0,bgView.frame.size.height/2, 310, 1) imageName:@""];
        lineImg.backgroundColor = KCOLOR(214, 214, 214, 1);
        [bgView addSubview:lineImg];
        
        [bgImgView addSubview:bgView];
        
        
        
         UILabel *audioLab = [UIFactory createLabelWithFrame:CGRectMake(bgView.frame.origin.x+5,bgView.frame.origin.y,200,bgView.frame.size.height/2) text:self.Title textColor:[UIColor blackColor] textFont:Kfont(20) textAlignment:0];
        [bgImgView addSubview:audioLab];
        audioLab.backgroundColor = [UIColor clearColor];
        
        
        //分类筛选按钮
        sortBtn = [UIFactory createButtonWithFrame:CGRectMake(600,bgView.frame.origin.y+10,130,bgView.frame.size.height/2-20) title:@"选择分类筛选" bgImageName:@"xlk.png" target:self action:@selector(sortBtnClick:)];
        [sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        sortBtn.titleLabel.font = Kfont(15);
        sortBtn.tag = 110;
        [bgImgView addSubview:sortBtn];
        
        
        UIImageView *iputImg = [UIFactory createImageViewWithFrame:CGRectMake(5,bgView.frame.size.height/2, 260,bgView.frame.size.height/2) imageName:@"white_btn.png"];
        [bgView addSubview:iputImg];
        
        
        mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,bgView.frame.size.height/2, KscreenWidth-10,44)];
        
//        inputTf = [UIFactory createTextFieldWithFrame:CGRectMake(5,bgView.frame.size.height/2, KscreenWidth-10,bgView.frame.size.height/2) borderStyle:UITextBorderStyleNone placeHolder:@"输入关键词搜索" secureEntry:NO delegate:self];
        
//        inputTf.font = Kfont(20);
//        
//        [bgView addSubview:inputTf];
//        UIButton *searchBtn = [UIFactory createButtonWithFrame:CGRectMake(600, bgView.frame.size.height/2, 45, 45) title:@"" bgImageName:@"btnblue.png" target:self action:@selector(sortBtnClick:)];
//        [searchBtn setBackgroundImage:[UIImage imageNamed:@"btnblue_press.png"] forState:UIControlStateHighlighted];
//        searchBtn.tag = 111;
//        [bgView addSubview:searchBtn];
//        
//        UIImageView *searchImg = [UIFactory createImageViewWithFrame:CGRectMake(5,5, 25,25)imageName:@"放大镜0017.png"];
//        [searchBtn addSubview:searchImg];
        
        
    }else
    {
        bgView = [[UIView alloc]initWithFrame:CGRectMake(5, 44+5+(iOS7?20:0), KscreenWidth-10, 95)];
        bgView.backgroundColor = KCOLOR(240, 240, 240, 1);
        UIImageView *lineImg = [UIFactory createImageViewWithFrame:CGRectMake(0,bgView.frame.size.height/2, 310, 1) imageName:@""];
        lineImg.backgroundColor = KCOLOR(214, 214, 214, 1);
        [bgView addSubview:lineImg];
        
        [bgImgView addSubview:bgView];
        
        
        
        UILabel *audioLab = [UIFactory createLabelWithFrame:CGRectMake(bgView.frame.origin.x+5,bgView.frame.origin.y+(bgView.frame.size.height/2-20)/2,75,20) text:self.Title textColor:[UIColor blackColor] textFont:Kfont(17) textAlignment:0];
        [bgImgView addSubview:audioLab];
        audioLab.backgroundColor = [UIColor clearColor];
        
        
         //分类筛选按钮
        sortBtn = [UIFactory createButtonWithFrame:CGRectMake(205, (bgView.frame.size.height/2-35)/2, 100, 35) title:@"选择分类筛选" bgImageName:@"xlk.png" target:self action:@selector(sortBtnClick:)];
        [sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        sortBtn.titleLabel.font = Kfont(11);
        sortBtn.tag = 110;
        [bgView addSubview:sortBtn];
        
        
        UIImageView *iputImg = [UIFactory createImageViewWithFrame:CGRectMake(5,(bgView.frame.size.height/2+(bgView.frame.size.height/2-35)/2), 260,35) imageName:@"white_btn.png"];
        [bgView addSubview:iputImg];
        
        
        mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,bgView.frame.size.height/2, KscreenWidth-10,44)];
    }
   
    
    
   
  
    
//    UIImageView *sortImg = [UIFactory createImageViewWithFrame:CGRectMake(295,(bgView.frame.size.height/2-10)/2+44+4, 10,10) imageName:@"a1.png"];
//    [bgImgView addSubview:sortImg];
    
    
    
    
   
    
    
    
    

    mySearchBar.delegate = self;
    mySearchBar.backgroundImage = [UIImage imageNamed:@"white_btn.png"];
    [mySearchBar setPlaceholder:@"请输入关键词搜索"];
    
    [mySearchBar setContentMode:UIViewContentModeLeft];
    
    [bgView addSubview:mySearchBar];
    //searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    //mySearchBar.barTintColor = KCOLOR(240, 240, 240, 1);
    
    //searchDisplayController.active = NO;
    
//    searchDisplayController.searchResultsDelegate = self;
//    searchDisplayController.searchResultsDataSource =  self;
   // searchDisplayController.searchResultsTableView.frame = CGRectMake(5, 5+95+64, 310, 350);
        
//
    
   
   
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        TableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 5+130+44, KscreenWidth-10, KscreenHeight -5-130-64-40 ) style:UITableViewStylePlain];
    }else
    {
        
        TableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 5+95+44+(iOS7?20:0), KscreenWidth -10, KscreenHeight -5-95-64 - 50 ) style:UITableViewStylePlain];
    }
    
    TableView.delegate = self;
    TableView.dataSource = self;
    TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    TableView.backgroundColor = KCOLOR(240, 240, 240, 1);
    [bgImgView addSubview:TableView];
    
    
    
    //loginview
    UIButton *loginView = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginView addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue1" ofType:@"png"]] forState:UIControlStateNormal];
    loginView.tag = 112;
    [bgImgView addSubview:loginView];
    
        //settting View
    UIButton *settingView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [settingView addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [settingView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_blue" ofType:@"png"]] forState:UIControlStateNormal];
    settingView.tag = 113;
    [bgImgView addSubview:settingView];
    
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        loginView.frame = CGRectMake(40, TableView.frame.origin.y+TableView.frame.size.height+5, 40, 40);
        settingView.frame = CGRectMake(KscreenWidth-74, TableView.frame.origin.y+TableView.frame.size.height+5, 40, 40);
        _onlinePeople.font = Kfont(20);
        
    }else{
        loginView.frame = CGRectMake(40, TableView.frame.origin.y+TableView.frame.size.height+5, 40, 40);
        settingView.frame = CGRectMake(KscreenWidth-74, TableView.frame.origin.y+TableView.frame.size.height+5, 40, 40);
        
        _onlinePeople.font = Kfont(15);
        
    }
    
    //当前在线人数
    _onlinePeople = [[UILabel alloc] initWithFrame:CGRectMake(loginView.frame.size.width + loginView.frame.origin.x, loginView.frame.origin.y, KscreenWidth -(loginView.frame.size.width + loginView.frame.origin.x)*2 , loginView.frame.size.height)];
    UserInfo *info = [UserInfo shareUserInfo];
    _onlinePeople.backgroundColor = [UIColor clearColor];
    _onlinePeople.text = info.onliePeople;//暂定
    
    _onlinePeople.textAlignment = NSTextAlignmentCenter;
    _onlinePeople.adjustsFontSizeToFitWidth = YES;
    _onlinePeople.textAlignment = NSTextAlignmentCenter;
    _onlinePeople.textColor = [UIColor whiteColor];
    [bgImgView addSubview:_onlinePeople];
    


}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    if(cid == nil)
    {
        cid = @"";
    }
    
    NSString *URLStr = [NSString stringWithFormat:@"%@?cid=%@&keywords=%@",self.audio!=nil?AUDIOPICKLIST_URL:VIDIOPICKLIST_URL,cid,searchBar.text];
    NSLog(@"%@",URLStr);
    URLStr = [URLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSLog(@"%@",URLStr);
    //      待加入缓冲提示：
    SVProgressHUDShow;
    [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] == 200) {
            
            [SVProgressHUD dismiss];
            NSLog(@"%@",responseObject);
            
            [pageDataArray removeAllObjects];
            [dataArray removeAllObjects];
            
            if([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]&&[responseObject objectForKey:@"data"]!=nil)
            {
                
                for(NSDictionary *dict in [responseObject objectForKey:@"data"])
                {
                    
                    
                    SC_Model *model = [[SC_Model alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [pageDataArray addObject:model];
                    
                    if(dataArray.count<10)
                    {
                        [dataArray addObject:model];
                    }
                    
                    
                    
                }
                
            }
            
            [TableView reloadData];
            
            
        }else{
            [SVProgressHUD dismiss];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];

    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [mySearchBar resignFirstResponder];
}

#pragma mark 分类筛选按钮点击事件
- (void)sortBtnClick:(UIButton *)button
{
    switch (button.tag - 110) {
            //分类筛选
        case 0:
        {
            if(dataArray1.count!=0)
            {
                LeveyPopListView *lplv1 = [[LeveyPopListView alloc] initWithTitle:@"分类选择" options:_options];
                lplv1.delegate = self;
                [lplv1 showInView:self.view animated:YES];
            }
            
  
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


- (void)show
{
    
    
    
    
//    [UIView animateWithDuration:0.3 animations:^{
//        
////        UIImageView *aniImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 200, 280, 200)];
////        
////        [self.view addSubview:aniImg];
////        
//        
//       
//        
//    }];
    
    [UIView animateWithDuration:.35 animations:^{
        
        
        
        TableView1 = [[UITableView alloc]initWithFrame:CGRectMake(20, 200,280 , 171) style:UITableViewStylePlain];
        TableView1.delegate = self;
        TableView1.dataSource  = self;
        TableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        TableView1.layer.cornerRadius = 5;
        TableView1.layer.masksToBounds = YES;
        TableView1.alpha = 1;
        TableView1.transform = CGAffineTransformMakeScale(1, 1);
        [self.view addSubview:TableView1];
    }];

    
    

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == TableView1)
    {
      UILabel *Lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TableView1.frame.size.width, 30)];
        Lab.textAlignment = NSTextAlignmentCenter
        ;
        Lab.backgroundColor = KCOLOR(233, 238, 250, 1);
        Lab.text = self.audio!=nil?@"音频分类":@"视频分类";
        
        return Lab;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(tableView == TableView1)
    {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, TableView1.frame.size.width, 30)];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        btn.backgroundColor = KCOLOR(233, 238, 250, 1);
        btn.titleLabel.font = Kfont(17);
        btn.titleLabel.textColor = KCOLOR(12, 128, 254, 1);
        [btn addTarget:self action:@selector(cancekBtn:) forControlEvents:UIControlEventTouchUpInside];
        return btn;
    }
    
    return nil;
    
}

- (void)cancekBtn:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        TableView1.frame = CGRectMake(160, 160, 0, 0);
        
    }];
    
    sortBtn.selected = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == TableView1)
    {
       return 30;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView == TableView1)
    {
        return 30;
    }
    return 0;
}
#pragma mark 自定义导航条
-(UIView *)myNavgationBar:(CGRect)rect andTitle:(NSString *)tit
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title.png"]];
    
    //back button
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(2, 0, 40, rect.size.height);
    [back addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"title_icon.png"] forState:UIControlStateNormal];
    [view addSubview:back];
    
    //title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(back.frame.size.width, 0, 70, rect.size.height)];
    title.text = tit;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    [view addSubview:title];
    

    
    return view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == searchDisplayController.searchResultsTableView) {
        return searchResults.count;
        
        NSLog(@"%lu",(unsigned long)searchResults.count);
    }else if (tableView == TableView1)
    {
        return dataArray1.count;
    }
    else {
        return dataArray.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellName = @"cellName";
    AudioCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[AudioCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        
        
        UIImageView *lineImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,cell.frame.size.width, 1)];
        
        
        lineImg1.backgroundColor = KCOLOR(227, 227, 227, 1);
        
        [cell.contentView addSubview:lineImg1];
        ;
        cell.backgroundColor = KCOLOR(240, 240, 240, 1);
    }
    
    if (tableView == searchDisplayController.searchResultsTableView) {
        cell.model = [searchResults objectAtIndex:indexPath.row];
    }else if (tableView == TableView1)
    {
     
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.model = [dataArray1 objectAtIndex:indexPath.row];
    }
    else {
        if(dataArray.count>0)
        {
            cell.model = [dataArray objectAtIndex:indexPath.row];
        }
       
    }
    return cell;
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        return 80;
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UserInfo *info = [UserInfo shareUserInfo];
    if(info.token.length == 0)
    {
        
        lplv = [[SC_popView alloc] initWithTitle:@"没有访问权限，请登录或升级位魔方会员" options:nil With:Lbtn With:Rbtn1];
        //lplv.delegLbtnnn = self;
        [lplv showInView:self.view animated:YES];
        
        [self creatBtn];
        
    }else
    {
        if(tableView == searchDisplayController.searchResultsTableView)
        {
            //推出播放器视图：
            VideoPlayerController *vpc = [[VideoPlayerController alloc] init];
            vpc.itemMode = [searchResults  objectAtIndex:indexPath.row];
            vpc.titleName = self.Title;
            [self presentViewController:vpc animated:YES completion:nil];
            
        }else if (tableView == TableView){
            //推出播放器视图：
            VideoPlayerController *vpc = [[VideoPlayerController alloc] init];
            vpc.itemMode = [dataArray objectAtIndex:indexPath.row];
            vpc.titleName = self.Title;
            [self presentViewController:vpc animated:YES completion:nil];
            
        }
        
   
    }
    
}


//登录  升级按钮

- (void)creatBtn
{
    if(KscreenHeight == 568 || KscreenHeight == 480)
    {
        Lbtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 80+5, (KscreenWidth-50)/2, 40)];
        Rbtn1 = [[UIButton alloc]initWithFrame:CGRectMake(20+Lbtn.frame.size.width, 80+5, Lbtn.frame.size.width, 40)];
        Lbtn.titleLabel.font = Kfont(15);
        Rbtn1.titleLabel.font = Kfont(15);
    }else
    {
        Lbtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 140+30, (KscreenWidth - 80)/2, 80)];
        Rbtn1 = [[UIButton alloc]initWithFrame:CGRectMake(40+(KscreenWidth - 80)/2,140+30, Lbtn.frame.size.width, 80)];
        Lbtn.titleLabel.font = Kfont(30);
        Rbtn1.titleLabel.font = Kfont(30);
    }
    
    [Lbtn setBackgroundImage:[UIImage imageNamed:@"white_btn1.png"] forState:UIControlStateNormal];
    [Lbtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [Lbtn setTitle:@"登录" forState:UIControlStateNormal];
    Lbtn.tag = 110;
    [Lbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    
    [Rbtn1 setBackgroundImage:[UIImage imageNamed:@"white_btn1.png"] forState:UIControlStateNormal];
    [Rbtn1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [Rbtn1 setTitle:@"马上升级" forState:UIControlStateNormal];
    Rbtn1.tag = 111;
    [Rbtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    [lplv.bgView addSubview:Lbtn];
    [lplv.bgView addSubview:Rbtn1];
}


- (void)back:(UIButton *)button
{
    switch (button.tag-110) {
        case 0:
        {
            
            RL_LoginViewController *login = [[RL_LoginViewController alloc]init];
            //[self presentViewController:login animated:YES completion:nil];
            
            [self.navigationController pushViewController:login animated:YES];
            
        }
            break;
        case 1:
        {
            OrderViewController *orderView = [[OrderViewController alloc]init];
            // [self presentViewController:orderView animated:YES completion:nil];
            
            [self.navigationController pushViewController:orderView animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    [UIView animateWithDuration:.35 animations:^{
        lplv.transform = CGAffineTransformMakeScale(1.3, 1.3);
        lplv.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [lplv removeFromSuperview];
        }
    }];
    
}



-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma UISearchDisplayDelegate


#pragma mark - LeveyPopListView delegates
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    if(dataArray.count!= 0)
    {
        [dataArray removeAllObjects];
    }
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    SC_Model *model = [dataArray1 objectAtIndex:anIndex];
    
    NSString *URLStr = [NSString stringWithFormat:@"%@?cid=%@",self.audio!=nil?AUDIOPICKLIST_URL:VIDIOPICKLIST_URL,model.Id];
    //      待加入缓冲提示：
    [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] == 200) {
            
            NSLog(@"%@",responseObject);
            
            [pageDataArray removeAllObjects];
            
            if([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]&&[responseObject objectForKey:@"data"]!=nil)
            {
                
                for(NSDictionary *dict in [responseObject objectForKey:@"data"])
                {
                    SC_Model *model = [[SC_Model alloc]init];
                
                    [model setValuesForKeysWithDictionary:dict];
                    cid = model.cid;
                    [pageDataArray addObject:model];
                    if(dataArray.count<10)
                    {
                        [dataArray addObject:model];
                    }
                
                }
                
            }
            
            
            [TableView reloadData];
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    


}
- (void)leveyPopListViewDidCancel
{
    
    
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





/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [TableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    //[TableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    if(limit<=pageDataArray.count)
    {
      [TableView addFooterWithTarget:self action:@selector(footerRereshing)];  
    }
    
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    TableView.headerPullToRefreshText = @"下拉可以刷新了";
//    TableView.headerReleaseToRefreshText = @"松开马上刷新了";
//    TableView.headerRefreshingText = @"MJ哥正在帮你刷新中,不客气";
//    
//    TableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
//    TableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
//    TableView.footerRefreshingText = @"MJ哥正在帮你加载中,不客气";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
    limit =10;
    [self request];
    
    
    // 2.2秒后刷新表格UI
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [TableView reloadData];
//        
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [TableView headerEndRefreshing];
//    });
}

- (void)footerRereshing
{
    
    [dataArray removeAllObjects];
    limit+=10;
    if(limit>pageDataArray.count)
    {
        limit = pageDataArray.count;
        
    }
    for (int i=0; i<limit; i++) {
        
        [dataArray addObject:[pageDataArray objectAtIndex:i]];
    }
    
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [TableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [TableView footerEndRefreshing];
    });
}


@end

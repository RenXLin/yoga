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


@interface SC_AudioOnLineViewController ()
{
    //当前在线人数
    UILabel *_onlinePeople;
    UITableView *TableView;
    UITextField *inputTf;
    UITableView *TableView1;
    UIButton *sortBtn;
    
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
    
    
    self.view.backgroundColor = KCOLOR(57, 61, 64, 1);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPeople) name:NOT_refreshOnlinePeople object:nil];
    
    //数据源初始化
    dataArray = [[NSMutableArray alloc]init];
    dataArray1 = [[NSMutableArray alloc]init];
    [self creatUI];
    [self request];
    
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
            
            if([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]&&[responseObject objectForKey:@"data"]!=nil)
            {
                
                for(NSDictionary *dict in [responseObject objectForKey:@"data"])
                {
                    SC_Model *model = [[SC_Model alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [dataArray addObject:model];
                }
                
            }
            
            
            [TableView reloadData];
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    

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
    sortBtn = [UIFactory createButtonWithFrame:CGRectMake(205, (bgView.frame.size.height/2-35)/2, 100, 35) title:@"选择分类筛选" bgImageName:@"xlk.png" target:self action:@selector(sortBtnClick:)];
    [sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sortBtn.titleLabel.font = Kfont(11);
    sortBtn.tag = 110;
    [bgView addSubview:sortBtn];
    
    UIImageView *sortImg = [UIFactory createImageViewWithFrame:CGRectMake(295,(bgView.frame.size.height/2-10)/2+64+4, 10,10) imageName:@"a1.png"];
    [bgImgView addSubview:sortImg];
    
    
    UIImageView *iputImg = [UIFactory createImageViewWithFrame:CGRectMake(5,(bgView.frame.size.height/2+(bgView.frame.size.height/2-35)/2), 260,35) imageName:@"white_btn.png"];
    [bgView addSubview:iputImg];
    
//    inputTf = [UIFactory createTextFieldWithFrame:CGRectMake(10,(bgView.frame.size.height/2+(bgView.frame.size.height/2-35)/2), 250,35) borderStyle:UITextBorderStyleNone placeHolder:@"输入关键词搜索" secureEntry:NO delegate:self];
//    
//    inputTf.font = Kfont(13);
//    
//    [bgView addSubview:inputTf];
    
    
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,bgView.frame.size.height/2, KscreenWidth-10,44)];
    mySearchBar.barTintColor = KCOLOR(240, 240, 240, 1);
    mySearchBar.delegate = self;
    //mySearchBar.backgroundImage = [UIImage imageNamed:@"white_btn.png"];
    [mySearchBar setPlaceholder:@"请输入关键词搜索"];
    [bgView addSubview:mySearchBar];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    mySearchBar.barTintColor = KCOLOR(240, 240, 240, 1);

    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    
    
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsTableView.frame = CGRectMake(5, 5+95+64, 310, 350);
    
//    
//    UIButton *searchBtn = [UIFactory createButtonWithFrame:CGRectMake(270, bgView.frame.size.height/2+(bgView.frame.size.height/2-30)/2, 30, 30) title:@"" bgImageName:@"btnblue.png" target:self action:@selector(sortBtnClick:)];
//    [searchBtn setBackgroundImage:[UIImage imageNamed:@"btnblue_press.png"] forState:UIControlStateHighlighted];
//    searchBtn.tag = 111;
//    [bgView addSubview:searchBtn];
//    
//    UIImageView *searchImg = [UIFactory createImageViewWithFrame:CGRectMake(5,5, 25,25)imageName:@"放大镜0017.png"];
//    [searchBtn addSubview:searchImg];
    
    
    TableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 5+95+64, 310, 350) style:UITableViewStylePlain];
    TableView.delegate = self;
    TableView.dataSource = self;
    TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    TableView.backgroundColor = KCOLOR(240, 240, 240, 1);
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
            if(btn.selected==NO)
            {
                if(dataArray1.count == 0)
                {
                    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                    
                    NSString *URLStr = [NSString stringWithFormat:@"%@",self.audio!=nil?SORT_AUDIOPICKLIST_URL:SORT_VIDEOLIST_ULR];
                    //      待加入缓冲提示：
                    [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"%@",responseObject);
                        if ([[responseObject objectForKey:@"code"] intValue] == 200) {
                            
                            
                            NSLog(@"%@",responseObject);
                            
                            if([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]&&[responseObject objectForKey:@"data"]!=nil)
                            {
                                
                                for(NSDictionary *dict in [responseObject objectForKey:@"data"])
                                {
                                    SC_Model *model = [[SC_Model alloc]init];
                                    [model setValuesForKeysWithDictionary:dict];
                                    [dataArray1 addObject:model];
                                    
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

                }
                btn.selected = YES;
                [self show];
                
  
            }else
            {
                btn.selected = NO;
                if(btn.selected == NO)
                {
                    [UIView animateWithDuration:0.3 animations:^{
                        TableView1.frame = CGRectMake(160, 160, 0, 0);
                        
                    }];
                    
                }
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
    
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
//        UIImageView *aniImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 200, 280, 200)];
//        
//        [self.view addSubview:aniImg];
//        
        
        TableView1 = [[UITableView alloc]initWithFrame:CGRectMake(20, 200,280 , 171) style:UITableViewStylePlain];
        TableView1.delegate = self;
        TableView1.dataSource  = self;
        TableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        TableView1.layer.cornerRadius = 5;
        TableView1.layer.masksToBounds = YES;
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
        cell.model = [dataArray objectAtIndex:indexPath.row];
    }
    return cell;
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == TableView1)
    {
       if(dataArray.count!= 0)
       {
           [dataArray removeAllObjects];
           
           AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
           manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
           SC_Model *model = [dataArray1 objectAtIndex:indexPath.row];
           
           NSString *URLStr = [NSString stringWithFormat:@"%@?cid=%@",self.audio!=nil?AUDIOPICKLIST_URL:VIDIOPICKLIST_URL,model.Id];
           //      待加入缓冲提示：
           [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSLog(@"%@",responseObject);
               if ([[responseObject objectForKey:@"code"] intValue] == 200) {
                   
                   NSLog(@"%@",responseObject);
                   
                   if([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]&&[responseObject objectForKey:@"data"]!=nil)
                   {
                       
                       for(NSDictionary *dict in [responseObject objectForKey:@"data"])
                       {
                           SC_Model *model = [[SC_Model alloc]init];
                           [model setValuesForKeysWithDictionary:dict];
                           [dataArray addObject:model];
                       }
                       
                   }
                   
                   
                   [TableView reloadData];
               }else{
                   
               }
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               
           }];
           
           

       }
        [UIView animateWithDuration:0.3 animations:^{
            TableView1.frame = CGRectMake(160, 160, 0, 0);
            
        }];
        
        sortBtn.selected = NO;
    }else if (tableView == TableView){
        //推出播放器视图：
        VideoPlayerController *vpc = [[VideoPlayerController alloc] init];
        vpc.itemMode = [dataArray objectAtIndex:indexPath.row];
        [self presentViewController:vpc animated:YES completion:nil];

    }
    
    
}

-(void)backBtnClick:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [inputTf resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchResults = [[NSMutableArray alloc]init];
    if (mySearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (int i=0; i<dataArray.count; i++) {
            
            SC_Model *model = (SC_Model *)[dataArray objectAtIndex:i];
            if ([ChineseInclude isIncludeChineseInString:model.title]) {
                
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:model.title];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:dataArray[i]];
                }
            }
            else {
                NSRange titleResult=[model.title rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:dataArray[i]];
                }
            }
        }
    } else if (mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (SC_Model *model in dataArray) {
            NSRange titleResult=[model.title rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:model];
            }
        }
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.frame = CGRectMake(5, 5+95+64, 310, 350);
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

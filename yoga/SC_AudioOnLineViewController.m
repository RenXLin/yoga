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
#import "MLTableAlert.h"
@interface SC_AudioOnLineViewController ()
{
    //当前在线人数
    UILabel *_onlinePeople;
    UITableView *TableView;
    UITextField *inputTf;
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
    sortArray = [[NSMutableArray alloc]init];
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
    UIButton *sortBtn = [UIFactory createButtonWithFrame:CGRectMake(205, (bgView.frame.size.height/2-35)/2, 100, 35) title:@"选择分类筛选" bgImageName:@"xlk.png" target:self action:@selector(sortBtnClick:)];
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
            
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
            NSString *URLStr = [NSString stringWithFormat:@"%@",self.audio!=nil?SORT_AUDIOLIST_URL:SORT_VODLIST_URL];
            //      待加入缓冲提示：
            [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                if ([[responseObject objectForKey:@"code"] intValue] == 200) {
                    
                    
                    
                    if([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]&&[responseObject objectForKey:@"data"]!=nil)
                    {
                        
                        for(NSDictionary *dict in [responseObject objectForKey:@"data"])
                        {
                            SC_Model *model = [[SC_Model alloc]init];
                            [model setValuesForKeysWithDictionary:dict];
                            [sortArray addObject:model];
                            
                            
                            // create the alert
                            self.alert = [MLTableAlert tableAlertWithTitle:@"Choose an option..." cancelButtonTitle:@"Cancel" numberOfRows:^NSInteger (NSInteger section)
                                          {
                                              return 1;
                                          }
                                                                  andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                                          {
                                              static NSString *CellIdentifier = @"CellIdentifier";
                                              UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                                              if (cell == nil)
                                                  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                                              
                                              
                                              
                                              return cell;
                                          }];
                            
                            
                            self.alert.height = 350;
                            
                            [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
                                //self.resultLabel.text = [NSString stringWithFormat:@"Selected Index\nSection: %d Row: %d", selectedIndex.section, selectedIndex.row];
                            } andCompletionBlock:^{
                                //self.resultLabel.text = @"Cancel Button Pressed\nNo Cells Selected";
                            }];
                            
                            // show the alert
                            [self.alert show];
                        }
                    }
                    
                    
                   
                }else{
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            

            
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
    if (tableView == searchDisplayController.searchResultsTableView) {
        return searchResults.count;
        
        NSLog(@"%lu",(unsigned long)searchResults.count);
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

#pragma mark UISearchDisplayDelegate

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
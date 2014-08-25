//
//  moreTableViewController.m
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-9.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import "moreTableViewController.h"

@interface moreTableViewController ()
//重点说明
//2014-5-25  Created By Robin
//定义可配置的数据参数（对于简单查询只需1组配置）
//命名规则： i 表示实例变量；P 表示 页面变量； s 表示 数据类型为String；
//初始化统一调用方法：initPage
#pragma mark- declare 声明变量
@property (strong, nonatomic) NSString *iPs_PageName; //页面名称(用于标记参数组)
@property (strong, nonatomic) NSString *iPs_URL; //请求数据接口模板--地址
@property (strong, nonatomic) NSString *iPs_PAGE; //请求数据接口模板--页面
@property (strong, nonatomic) NSString *iPs_POST; //请求数据POST参数模板
@property (strong, nonatomic) NSString *iPs_POSTAction; //请求数据POST参数Action

//传入变化的参数组,参数数目根据接口需要而变化
@property (strong, nonatomic) NSString *iPs_POSTID; //请求数据POST参数ID1
@property (strong, nonatomic) NSString *iPs_POSTQueryOption; //请求数据POST参数ID2
@property (strong, nonatomic) NSString *iPs_POSTQueryRegion; //请求数据POST参数ID3

//页面内部变量(由程序控制实际值)
@property (nonatomic) int iPageIndex;
@property (nonatomic) Boolean isConnected;

@end

@implementation moreTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //用户登录的消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginCompletion:)
                                                 name:@"LoginCompletionNotification"
                                               object:nil];
    
    //用户注册消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerCompletion:)
                                                 name:@"RegisterCompletionNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//页面即将展示
-(void) viewWillAppear:(BOOL)animated{
    //如果页面没有初始化则先用初始值
    /*
     if (_iPs_PageName==nil) {
     [self initPage];
     }
     if (_isConnected == false) {
     NSLog(@"尝试重新加载数据...");
     //重新加载数据
     [self startRequest];
     }
     */
    
    //主动查一下积分、余额信息 （以后改为消息触发）
    washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
    _userid = delegate.userid;
    _username  = delegate.username;
    _businessname = delegate.businessname;
    
    
    /*
     if ((delegate.userbonus > 0)&&(![delegate.userid isEqualToString:@""])){
     _menuBonus.text = [[NSString alloc] initWithFormat:@"红包 [ %1.0f ]",delegate.userbonus];
     
     }else{
     
     _menuBonus.text = @"红包";
     }*/
    
    if (([delegate.userid isEqualToString:@""])||(_businessname == nil)) {
        _btnQuit.titleLabel.text = @"登录";
        _menuName.text = @"请登录";
    }else{
    
        _menuName.text = [[NSString alloc] initWithFormat:@"%@", _businessname ];
    }
    
    
}

#pragma mark- ActionEvent 触发控制逻辑
//登录返回
-(void)loginCompletion:(NSNotification*)notification {
    
    NSDictionary *theData = [notification userInfo];
    _userid = [theData objectForKey:@"ID"];
    _username = [theData objectForKey:@"name"];
    _businessname = [theData objectForKey:@"businessname"];
    
    NSLog(@"登录页面返回,username = %@", _username);
    NSString *lsLogin = [theData objectForKey:@"isLogin"];
    
    
    //页面显示用户登录信息
    //washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
    //if (false==delegate.isLogin) {
    if ([lsLogin isEqual:@"0"]) {
        
        NSLog(@"未登录状态");
        _menuName.text = @"请登录";
    }else{
        
        //delegate.userid = _userid;
        //delegate.username = _username;
        //delegate.usermoney = _usermoney;
        //delegate.userpoints = _userpoints;
        
        _iPs_POSTID = _userid;
        
        _menuName.text = [[NSString alloc] initWithFormat:@"%@", _businessname ];
        
        //_btnLogin.titleLabel.text = @"退出";
        //_lbUsername.text = _username;
        
        //跳转到验证首页
        self.tabBarController.selectedIndex = 0;
        
    }
    
    
}
//注册返回
-(void)registerCompletion:(NSNotification*)notification {
    
    NSDictionary *theData = [notification userInfo];
    
    NSString *isRegist = [theData objectForKey:@"isRegist"];
    if ([isRegist isEqualToString:@"0"]) {
        //注册失败
        NSLog(@"注册无效！");
        return;
    }else if ([isRegist isEqualToString:@"1"]){
        NSLog(@"注册成功！");
        
    }
    
    _userid = [theData objectForKey:@"ID"];
    
    _username = [theData objectForKey:@"name"];
    
    NSLog(@"注册用户返回,username = %@",_username);
    
    if (([_userid isEqualToString:@""])||(_userid==nil)) {
        NSLog(@"注册用户ID无效");
        return;
    }
    
    //更新用户信息
    
    
}

#pragma mark - Button Clicked

- (IBAction)btnQuitClicked:(id)sender {
    //退出
    if ([_btnQuit.titleLabel.text isEqualToString:@"退出"]) {
        //退出
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出账户"
                                                            message:@"您确实要退出当前账户吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"退出",nil];
        [alertView show];
        
        
    }else{
        //登录
        [self performSegueWithIdentifier:@"useractlogin" sender:self];
        
    }

    
}

//退出 询问操作结果
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //退出
        _isQuitCurrent = true;
        
        
        washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
        
        delegate.isLogin= false;
        delegate.userid = @"";
        
        delegate.password = @"";
        delegate.isAutoLogin = false;
        
        delegate.usermoney = 0;
        delegate.userpoints = 0;
        
        //存档配置
        [delegate SaveConfig];
        
        NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"isLogin",@"", @"ID",@"", @"name", nil];
        
        //传递消息
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"LoginCompletionNotification"
         object:nil
         userInfo:dataDict];
        _btnQuit.titleLabel.text = @"登录";
        //重要：主动调用 Segue 呈现页面
        NSLog(@"退出登录");
        [self performSegueWithIdentifier:@"useractlogin" sender:self];
        
        
    }else{
        _isQuitCurrent = false;
        //
        _btnQuit.titleLabel.text = @"退出";
        
        NSLog(@"取消退出");
    }
    
}

#pragma mark - Navigation
//页面发生跳转，进入明细
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.tintColor=[UIColor colorWithRed:129/255.0 green:129/255.0  blue:129/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem = backItem;
    
    if([segue.identifier isEqualToString:@""])
    {
        //salesDetailListViewController *itemdetail = segue.destinationViewController;
        //NSInteger selectedRow = [[self.tableView indexPathForSelectedRow] row];

        
        
        
    }
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

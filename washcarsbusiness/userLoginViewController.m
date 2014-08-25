//
//  userLoginViewController.m
//  tabswashcars
//
//  Created by Robinpad on 14-6-9.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import "userLoginViewController.h"
#import "washcarsAppDelegate.h"


@interface userLoginViewController ()
//重点说明
//2014-5-25  Created By Robin
//定义可配置的数据参数（对于简单查询只需1组配置）
//命名规则： i 表示实例变量；P 表示 页面变量； s 表示 数据类型为String；
//初始化统一调用方法：initPage
@property (strong, nonatomic) NSString *iPs_PageName; //页面名称(用于标记参数组)
@property (strong, nonatomic) NSString *iPs_URL; //请求数据接口模板--地址
@property (strong, nonatomic) NSString *iPs_PAGE; //请求数据接口模板--页面
@property (strong, nonatomic) NSString *iPs_POST; //请求数据POST参数模板
@property (strong, nonatomic) NSString *iPs_POSTAction; //请求数据POST参数Action
@property (strong, nonatomic) NSString *iPs_POSTAction2; //请求数据POST参数Action2
//传入变化的参数组,参数数目根据接口需要而变化
@property (strong, nonatomic) NSString *iPs_POSTID; //请求数据POST参数ID1
@property (strong, nonatomic) NSString *iPs_POSTQueryOption; //请求数据POST参数ID2
@property (strong, nonatomic) NSString *iPs_POSTQueryRegion; //请求数据POST参数ID3
@end

@implementation userLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initPage];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerCompletion:)
                                                 name:@"RegisterCompletionNotification"
                                               object:nil];
    
    //[self.btnOK dangerStyle];
    [self.btnOK successStyle];
    
    [self.btnOK addAwesomeIcon:FAIconUser  beforeTitle:YES];
    
    //[self.btnRegist successStyle];
    
    //[self.btnRegist addAwesomeIcon:FAIconKey beforeTitle:YES];
    
    if(_isDebug){
        _txtUserName.text = @"syb_ceshi";
        _txtPassword.text = @"sunyubin";
    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//页面即将展示
-(void) viewWillAppear:(BOOL)animated{
    //如果页面没有初始化则先用初始值
    if (_iPs_PageName==nil) {
        [self initPage];
    }
    if (_isConnected == false) {
        NSLog(@"尝试重新加载数据...");
        //重新加载数据
    }
    
    //预设参数，自动填写用户名和密码，节省测试时间
    if(_isDebug){
        _txtUserName.text = @"syb_ceshi";
        _txtPassword.text = @"sunyubin";
        
    }
}

//初始化页面变量组和参数
- (void)initPage
{
    //根据页面类型不同需要配置的部分
    washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
    _iPs_URL=delegate.iPs_URL; //请求数据接口模板--地址
    _txtUserName.text=delegate.username;

    _swcAutoLogin.on =delegate.isAutoLogin;
    if (delegate.isAutoLogin == true) {
        _txtPassword.text=delegate.password;
    }

    _iPs_PageName=@"商家登录"; //页面名称(用于标记页面参数配置)

    _iPs_PAGE=@"business_app.php"; //请求数据接口模板--页面1
    _iPs_POST=@"act=%@&business_name=%@&password=%@"; //请求数据POST参数模板，md5加密密码
    _iPs_POSTAction =@"login_submit";   //登录
    _iPs_POSTAction2 =@"";//
    _iPs_POSTID=@"0"; //请求数据POST参数ID1
    _iPs_POSTQueryOption=@"0"; //请求数据POST参数ID2
    _iPs_POSTQueryRegion=@""; //请求数据POST参数ID3

    _isDebug = false;
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

//注册返回
-(void)registerCompletion:(NSNotification*)notification {
    
    NSDictionary *theData = [notification userInfo];
    
    NSString *isRegist = [theData objectForKey:@"isRegist"];
    if ([isRegist isEqualToString:@"0"]) {
        //注册失败
        NSLog(@"注册无效！");
        _isLogin = false;
        return;
    }else if ([isRegist isEqualToString:@"1"]){
        NSLog(@"注册成功！回到登录页面");
        _isLogin = true;
    }
    
    _userid = [theData objectForKey:@"ID"];
    
    _username = [theData objectForKey:@"name"];
    _password = [theData objectForKey:@"password"];
    
    _userphone = [theData objectForKey:@"phone"];
    
    NSLog(@"注册用户返回,username = %@",_username);
    
    if (([_userid isEqualToString:@""])||(_userid==nil)) {
        NSLog(@"注册用户ID无效");
        return;
    }
    
    _txtUserName.text=_username;
    if (_isLogin == true) {
        _txtPassword.text=_password;
        //直接登录
        NSLog(@"注册用户首次登录");
        [self btnLogin:_btnOK];
    }
}


- (IBAction)txtNameEditReturn:(id)sender {
    [sender resignFirstResponder];
    [_txtPassword becomeFirstResponder];
}

- (IBAction)txtPassEditReturn:(id)sender {
    [sender resignFirstResponder];
    [self btnLogin:_btnOK];
}

- (IBAction)switchChanged:(id)sender {
    _isAutoLogin = _swcAutoLogin.isOn;
}
- (IBAction)btnReturn:(id)sender {
    //逻辑需要禁止返回，必须登录后才允许使用
    if(false==_isLogin){
        [self userLogout];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            //构造消息
            NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"isLogin",_userid, @"ID",_username, @"name", nil];
            //传递消息
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"LoginCompletionNotification"
             object:nil
             userInfo:dataDict];
        }];
    }
    
}

- (IBAction)btnClose:(id)sender {
    
    
    //exit(0); //退出应用
    
}

//用户注册
- (IBAction)btnRegist:(id)sender {
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *registerViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"registerViewController"];
    
    registerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:registerViewController animated:YES completion:^{
        NSLog(@"打开注册新用户界面");
    }];

    
}


- (IBAction)btnLogin:(id)sender {
    
    _username = _txtUserName.text;
    _password = _txtPassword.text;
    //去除空格
    _username = [_username stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    _iPs_POSTID=_username; //请求数据POST参数ID1
     //请求数据POST参数ID2
    
    if ([_username  isEqual: @""]||[_password isEqual:@""]) {
        washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate showNotify:@"用户名和密码不能为空！" HoldTimes:2];
        return;
    }
    
    _lbReturn.text = @"正在提交服务器验证，请稍候……";
    
    //加密传送
    _password = [self md5Encrypt:_password];
    _iPs_POSTQueryOption=_password;
    
    //加载数据
    [self startRequest];
    
    
    //[self.Login _username Password:_password];
}


- (IBAction)btnFindPassword:(id)sender {
    
    
}

//md5 32位 加密 （小写）

- (NSString *)md5Encrypt:(NSString *)str {
    
    const char *original_str = [str UTF8String];
    
    unsigned char result[16];//32
    
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];//
    return [hash lowercaseString];
}

//将登录信息跟新到全局变量供页面共享
- (BOOL)userLogin{
    
    _isAutoLogin = _swcAutoLogin.isOn ;
    
    washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    delegate.isLogin= _isLogin;
    delegate.userid = _userid;
    delegate.username = _username;
    delegate.password = _password;
    delegate.isAutoLogin = _isAutoLogin;
    delegate.businessname = _businessname;
    
    //存档配置
    [delegate SaveConfig];
    
    NSString *strMoney = [[NSString alloc]initWithFormat:@"%1.2f",_usermoney];
    NSString *strpoints = [[NSString alloc]initWithFormat:@"%1.0f",_userpoints];
    [self dismissViewControllerAnimated:YES completion:^{
        //构造消息
        NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"isLogin",_userid, @"ID",_username, @"name",_password,@"user_pass",strMoney,@"user_money",strpoints,@"pay_points",_businessname,@"businessname", nil];
        //传递消息
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"LoginCompletionNotification"
         object:nil
         userInfo:dataDict];
    }];

    
    return true;

}

//退出
- (BOOL)userLogout{
    
    _isAutoLogin = false ;
    
    washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    delegate.isLogin= false;
    delegate.userid = @"";
    delegate.username = @"";
    delegate.password = @"";
    delegate.isAutoLogin = false;
    
    //存档配置
    [delegate SaveConfig];
    
    [self dismissViewControllerAnimated:YES completion:^{
        //NSLog(@"Modal View done");
        //构造消息
        
        NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"isLogin",@"", @"ID",@"", @"name", nil];
        //传递消息
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"LoginCompletionNotification"
         object:nil
         userInfo:dataDict];
    }];
    
    
    return true;
    
}

//自动验证用户身份
-(BOOL)autoLogin:(NSString *)name password:(NSString *)password{

    [self initPage];
    _isAutoValidate = true;
    
    if (([password isEqualToString:@""])||(password ==nil)) {
        NSLog(@"自动登录无效的密码");
        return false;
    }
    
    if (([name isEqualToString:@""])||(name ==nil)) {
        NSLog(@"自动登录无效的用户名");
        return false;
    }
    
    _username = name;
    _password = password;
    
    _iPs_POSTID= name; //请求数据POST参数ID1
    _iPs_POSTQueryOption= password; //请求数据POST参数ID2
    
    [self startRequest];
    
    return true;
}

/*
 * 开始请求Web Service
 */
-(void)startRequest
{
    _isConnected = false;
    NSString *strURL = [[NSString alloc] initWithFormat:@"%@%@",_iPs_URL,_iPs_PAGE];
    
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    
    
    //NSString *post = [NSString stringWithFormat:@"act=wash_list&cat_id=139&page=%d&sel_attr=0&region_id=%@",_iPageIndex,@"298"];
    NSString *post = [NSString stringWithFormat:_iPs_POST,_iPs_POSTAction,_iPs_POSTID,_iPs_POSTQueryOption];
    
	NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:postData];
	
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request delegate:self];
	
    if (connection) {
        _isConnected = true;    //由于请求异步，并不能确定本次连接成功，但要防止重复请求
        _datas = [NSMutableData new];
        NSLog(@"发出数据请求:%@  POST=%@",strURL,post);
        //[self setPageNext];//下次请求换页
        
    }else{
        NSLog(@"无法建立数据连接！%@ POST=%@", strURL , post);
        _isConnected = false;
    }
}

/*
 * 开始请求Web Service 方法的参数改造(依赖参数传递)
 */
-(void)startRequest:(NSString *)paramURL POST:(NSString *)postString
{
    _isConnected = false;
    NSString *strURL = paramURL;
    
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSString *post = postString;
    
	NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:postData];
	
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request delegate:self];
	
    if (connection) {
        _isConnected = true;    //由于请求异步，并不能确定本次连接成功，但要防止重复请求
        _datas = [NSMutableData new];
        NSLog(@"发出数据请求:%@  POST=%@",strURL,post);
        //转到拖拉翻页[self setPageNext];//下次请求换页
        
    }else{
        NSLog(@"无法建立数据连接！%@ POST=%@", strURL , post);
        _isConnected = false;
    }
}

#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_datas appendData:data];
}


-(void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    
    _isConnected = false;
    NSLog(@"连接失败：%@",[error localizedDescription]);
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSLog(@"请求数据完成接收,准备解析");
    _isConnected = true;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:_datas options:NSJSONReadingAllowFragments error:nil];
    
    NSNumber *resultCodeObj = [dict objectForKey:@"is_err"];
    if ([resultCodeObj integerValue] ==0)
    {
        _userid = [dict objectForKey:@"business_id"];
        _username = [dict objectForKey:@"business_loginname"];
        
        //business_displayname
        //message
        _businessname = [dict objectForKey:@"business_displayname"];
        NSString * message = [dict objectForKey:@"message"];
        
        _isLogin = true;
        
        _lbReturn.text = [[NSString alloc] initWithFormat:@"欢迎您！%@",_businessname];
        NSLog(@"成功登录！%@ , id =%@ msg=%@", _username , _userid , message);
        
        //更新用户状态
        [self userLogin];
        
    }else
    {
        _isLogin = false;
        _lbReturn.text = @"请输入用户名和密码";
        NSString * err_msg = [dict objectForKey:@"err_msg"];
        NSLog(@"登录失败！%@ %@ %@",_username,_password , err_msg);
        if (_isAutoValidate == true) {
            //自动登录需要重置账户信息
            [self userLogout];
            
            return;
        }
        UIAlertView*alert1 = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"用户名或密码错误！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert1 show];
    }
    
    //NSLog( @"Result: %@", [dict description] );
    //激活数据列表的刷新
    //[self reloadView:dict];
}



@end

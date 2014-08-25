//
//  checkViewController.m
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-9.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import "checkViewController.h"
#import "userLoginViewController.h"

@interface checkViewController ()
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

@implementation checkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark- ShowEvent 页面显示方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_iPs_PageName==nil) {
        [self initPage];
    }
    if (_isConnected == false) {
        NSLog(@"尝试重新加载数据...");
        //重新加载数据
        //[self startRequest];
    }

    //用户登录的消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginCompletion:)
                                                 name:@"LoginCompletionNotification"
                                               object:nil];
    //刷新列表的消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AccountRefresh:)
                                                 name:@"AccountRefreshNotification"
                                               object:nil];
    
    //扫描二维码的消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(CodeRefresh:)
                                                 name:@"CodeRefreshNotification"
                                               object:nil];
    
    //用户注册消息
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerCompletion:)
                                                 name:@"RegisterCompletionNotification"
                                               object:nil];
    */
    [self LayoutKeyPosition];
    
    

    [self.scrollMainView addSubview:self.subKeyView];
    
    //像这种控件的长按事件有些地方是有系统自带的。但有些时候用起来也不太方便。下面这个可能以后能用到
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    
    longPressReger.minimumPressDuration = 0.8;
    
    [_btnDelete addGestureRecognizer:longPressReger];
    
    
    /*
    _txtCode.layer.cornerRadius = 6;
    _txtCode.layer.masksToBounds = YES;
    _txtCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtCode.layer.borderWidth = 1;
    _txtCode.delegate = self ;
     */
    
    if([self.navigationController.navigationBar  respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed:@"标题背景.png"] forBarMetrics:UIBarMetricsDefault];
    }
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:48.0/255.0 green:120.0/255.0 blue:172.0/255.0 alpha:0.8];
    
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
    
    //首页已显示，检查一下网络状况
    //务必在首页展示完成后再启动其它逻辑，否则会导致载入迟缓影响体验
    if(_isInital == false){
        //初始化逻辑只能执行一次
        NSLog(@"√已载入首页");
        washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate LoadConfig];
        
        [delegate NetworkReachability];
        //[delegate LoadMapManger];
        
        
        
        //判断用户是否需要定位信息，如果已有存档则不执行定位。
        //延迟执行定位
        /*if (!delegate.isLimited ) {
            //非限制版有自动定位
            if((delegate.userAreaID==nil)||([delegate.userAreaID isEqualToString:@""]))
            {
                [self performSelector:@selector(DelayLocation) withObject:nil afterDelay:1.8f];
            }
        }*/
        
        if ((delegate.userid!=nil)&&(![delegate.userid isEqualToString:@""] )) {
            //存在userid 说明有记录登录用户，允许自动登录校验身份
            _iPs_POSTID= delegate.userid ; //请求数据POST参数ID1
            _userid = _iPs_POSTID;
            [self performSelector:@selector(DelayLogin) withObject:nil afterDelay:0.8f];
            //[self performSegueWithIdentifier:@"useractlogin" sender:self];
        }else{
            //登录页面
            [self performSegueWithIdentifier:@"useractlogin" sender:self];
        }
        
        _isInital = true;
    }else{
        washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
        _userid = delegate.userid;
        _username  = delegate.username;
        _iPs_POSTID = _userid;
    }
    
}

#pragma mark- initial Event 初始化
//初始化页面变量组和参数
- (void)initPage
{
    //根据页面类型不同需要配置的部分
    _iPs_PageName=@"验证消费码"; //页面名称(用于标记页面参数配置)
    //_iPs_URL=@"http://114.112.73.223:8080/"; //请求数据接口模板--地址
    washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
    _iPs_URL=delegate.iPs_URL; //请求数据接口模板--地址
    
    _iPs_PAGE=@"business_app.php"; //请求数据接口模板--页面
    _iPs_POST=@"act=%@&business_id=%@&code=%@"; //请求数据POST参数模板
    
    _iPs_POSTID= delegate.userid ; //请求数据POST参数ID1
    _userid = _iPs_POSTID;
    
    _iPs_POSTAction =@"confirm_code"; //验证消费码
    
    _iPs_POSTQueryOption=@"0"; //请求数据POST参数ID2：0 详情 1评论 2销售记录
    _iPs_POSTQueryRegion=@""; //请求数据POST参数ID3
    
    
    //不随页面类型改变的部分
    _iPageIndex = 1;//初始化页面序号
    _CellBgColor =[UIColor colorWithRed:49/255.0 green:155/255.0 blue:205/255.0 alpha:0.15];
    
    if (([_iPs_POSTID isEqualToString:@""])||(_iPs_POSTID == nil)) {
        //[delegate showNotify:@"欢迎使用去洗车商家版！请使用商家账户登录" HoldTimes:2];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Layout 显示布局
- (void)LayoutKeyPosition{
    //自动布局的逻辑，主要对按键排列 iphone4比iphone5短
    CGRect ScreenRect = [ UIScreen mainScreen ].applicationFrame;
    CGSize size = ScreenRect.size;
    CGFloat Screenwidth = size.width;
    CGFloat Screenheight = size.height;
    NSLog(@"屏幕 宽：%f 高：%f",Screenwidth,Screenheight );
    
    if(Screenheight <= 460){
        //较短的布局方式
        //webView的宽度和高度
        //frame.size = CGSizeMake(300, content_height+40);
        //aWebView.frame = frame;
        
        //NSLog(@"-----%d",(int) frame.size.height);
        
        //移动按钮的位置并改变按钮大小
        //int ypos = aWebView.frame.origin.y + frame.size.height + 20;
        self.scrollMainView.contentSize = CGSizeMake(320,310);
        
        [self resizeButton:_btn0];
        [self resizeButton:_btn1];
        [self resizeButton:_btn2];
        [self resizeButton:_btn3];
        [self resizeButton:_btn4];
        [self resizeButton:_btn5];
        [self resizeButton:_btn6];
        [self resizeButton:_btn7];
        [self resizeButton:_btn8];
        [self resizeButton:_btn9];
        
        //验证按钮单独控制
        float height = _btnSubmit.frame.size.height;
        float width = _btnSubmit.frame.size.width;
        
        int ResizeUnit = 26;
        int posx = _btnSubmit.frame.origin.x;
        int posy = _btnSubmit.frame.origin.y;
        posy = (height - ResizeUnit) * 3 + 3;
        _btnSubmit.frame = CGRectMake( posx, posy, width, height - ResizeUnit);
        
        //处理水平分割线
        
        //处理垂直分割线
        _Vertical3.frame = CGRectMake( _Vertical3.frame.origin.x, _Vertical3.frame.origin.y, 3, _btnSubmit.frame.origin.y - 1);
        
    
    }else if(Screenheight >= 540){
        //默认布局方式
        self.scrollMainView.contentSize = CGSizeMake(320,360);
    }
}

- (void)resizeButton:(UIButton *)keyButton{

    int key = 0;
    key = [keyButton.titleLabel.text intValue];
    
    
    float width = keyButton.frame.size.width;
    
    float height = keyButton.frame.size.height;
    
    int ResizeUnit = 26;
    int posx = keyButton.frame.origin.x;
    int posy = keyButton.frame.origin.y;
    
    //NSLog(@"KEY= %d ", key);
    //按钮文字的位置提高
    //[keyButton setContentEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
    
    //逐一调整按钮的高度
    switch (key) {
        case 0:

            posy = (height - ResizeUnit) * 3 + 3;

            keyButton.frame = CGRectMake( posx, posy, width, height - ResizeUnit);
            
            posx = _Horizontal4.frame.origin.x;
            
            width = _Horizontal4.frame.size.width;
            _Horizontal4.frame = CGRectMake( posx, posy - 2, width, 3);
            
            posx = _Horizontal5.frame.origin.x;
            posy = posy + height - ResizeUnit ;
            
            width = _Horizontal5.frame.size.width;
            _Horizontal5.frame = CGRectMake( posx, posy, width, 3);

            
            break;
        case 1:
            posy = (height - ResizeUnit) * 0 + 0;
            
            keyButton.frame = CGRectMake( posx, posy, width, height - ResizeUnit);
            
            
            
            break;
        case 2:
            posy = (height - ResizeUnit) * 0 + 0;
            
            keyButton.frame = CGRectMake( posx, posy, width, height - ResizeUnit);
            break;
        case 3:
            posy = (height - ResizeUnit) * 0 + 0;
            
            keyButton.frame = CGRectMake( posx, posy, width, height - ResizeUnit);
            break;
        case 4:
            posy = (height - ResizeUnit) * 1 + 1;
            
            keyButton.frame = CGRectMake( posx, posy, width, height - ResizeUnit);
            
            
            posx = _Horizontal2.frame.origin.x;
            posy = posy - 2;
            height = _Horizontal2.frame.size.height;
            width = _Horizontal2.frame.size.width;
            _Horizontal2.frame = CGRectMake( posx, posy, width, height);
            
            
            break;
        case 5:
            posy = (height - ResizeUnit) * 1 + 1;
            
            keyButton.frame = CGRectMake( posx, posy, width, height - ResizeUnit);
            break;
        case 6:
            posy = (height - ResizeUnit) * 1 + 1;
            
            keyButton.frame = CGRectMake( posx, posy, width, height - ResizeUnit);
            break;
        case 7:
            posy = (height - ResizeUnit) * 2 + 2;
            
            keyButton.frame = CGRectMake( posx, posy, width, height - ResizeUnit);
            
            posx = _Horizontal3.frame.origin.x;
            posy = posy - 2;
            height = 3;
            width = _Horizontal3.frame.size.width;
            _Horizontal3.frame = CGRectMake( posx, posy, width, height);
            

            break;
        case 8:
            posy = (height - ResizeUnit) * 2 + 2;
            
            keyButton.frame = CGRectMake( posx, posy, width, height - ResizeUnit);
            
            break;
        case 9:
            posy = (height - ResizeUnit) * 2 + 2;
            
            keyButton.frame = CGRectMake( posx, posy, width, height - ResizeUnit);
            break;
        default:
            break;
    }
    

    
}

#pragma mark- ButtonClicked 按钮事件
//点击任意数字键，将根据按钮的数字来识别
- (IBAction)numberClicked:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSString *key = button.titleLabel.text;
    _delcount = 0;
    if (_txtCode.text.length>=12) {
        _txtCode.text = [_txtCode.text substringToIndex:_txtCode.text.length - 1];
    }
    
    _txtCode.text = [_txtCode.text stringByAppendingString:key];
}

- (IBAction)btnDeleteClicked:(id)sender {
    if (![_txtCode.text isEqualToString:@""]) {
        _txtCode.text = [_txtCode.text substringToIndex:_txtCode.text.length - 1];
        _delcount = _delcount + 1;
        if ((_delcount > 3)&&(_txtCode.text.length>3)) {
            _delcount = 0;
            
            washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
            [delegate showNotify:@"长按删除键1秒可快速清空消费码。" HoldTimes:1.2f];
        }
    }
}

//长按删除
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([_txtCode.text isEqualToString:@""]) {
        return;
    }
    
    NSLog(@"长按删除键");
    _txtCode.text = @"";
    _code = @"";
    _delcount = 0;
}

- (IBAction)btnCheckCodeClicked:(id)sender {
    //验证
    washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    if ((_userid == nil)||([_userid isEqualToString:@""])) {
        //登录页面
        //_userid = delegate.userid;
        //_iPs_POSTID = _userid;
        
        [self performSegueWithIdentifier:@"useractlogin" sender:self];
        return;
    }
    
    
    _code = _txtCode.text;
    
    if (_code.length == 0) {
        
        [delegate showNotify:@"请输入消费码后再进行验证。" HoldTimes:1.2f];
        return;
    }
    
    [self startRequest];
    
}

- (IBAction)btnScanCodeClicked:(id)sender {
    //扫描二维码 scancode
    [self performSegueWithIdentifier:@"scancode" sender:self];
    
}


//由于数字键盘没有Return键，当点击界面其它元素自动释放焦点以隐藏键盘
- (void)touchesBegan: (NSSet *)touches withEvent:(UIEvent *)event
{
    // do the following for all textfields in your current view
    [self.txtCode resignFirstResponder];
    //[self txtInputChanged:_txtuserinput];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    /*
    if (1 == range.length) {//按下删除键
        _txtlength.titleLabel.text = [[NSString alloc]initWithFormat:@"%d/%d",[textView.text length], _essaylimit];
        return YES;
    }*/
    
    if ([text isEqualToString:@"\n"]) {//按下return键
        //这里隐藏键盘，不做任何处理
        [textView resignFirstResponder];
        return NO;
    }else {
        if ([textView.text length] <= 20) {//判断字符个数
            return YES;
        }else{
            /*
            textView.text = [textView.text substringToIndex:_essaylimit+1];
            _txtlength.titleLabel.text = [[NSString alloc]initWithFormat:@"%d/%d",[textView.text length], _essaylimit];*/
            //这里隐藏键盘，不做任何处理
            [textView resignFirstResponder];
            return NO;
        }
    }
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"inputChanged：%@", textView.text);
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
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

#pragma mark- ActionEvent 触发控制逻辑
//延迟登录
- (void)DelayLogin
{
    
    //根据本地存储的位置信息判断是否有必要执行以下逻辑
    
    //询问用户是否继续
    NSLog(@"启动延迟登录");
    washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
    //[delegate showNotify:@"欢迎您安装了去洗车应用，本地服务需要定位您当前的位置。" HoldTimes:1.8f];
    //self.tabBarController.selectedIndex = 1;
    
    userLoginViewController *LoginView = [userLoginViewController alloc];
    
    [LoginView autoLogin:delegate.username password:delegate.password ];
    
    
    //NSLog(@"启动延迟登录完毕");
    //页面显示用户登录信息
    if (false==delegate.isLogin) {
        _iPs_POSTID = @"";
        _userid = @"";
        NSLog(@"未登录状态");
        
    }else{
        
        _userid = delegate.userid;
        _username = delegate.username;
        //delegate.usermoney = _usermoney;
        //delegate.userpoints = _userpoints;
        
        _iPs_POSTID = _userid;
        NSLog(@"%@ 已登录",_username);
        //_btnLogin.titleLabel.text = @"退出";
        //_lbUsername.text = _username;
    }

}

//登录返回
-(void)loginCompletion:(NSNotification*)notification {
    
    NSDictionary *theData = [notification userInfo];
    _userid = [theData objectForKey:@"ID"];
    _username = [theData objectForKey:@"name"];
    
    
    NSLog(@"登录页面返回,username = %@", _username);
    NSString *lsLogin = [theData objectForKey:@"isLogin"];
    
    
    //页面显示用户登录信息
    washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
    //if (false==delegate.isLogin) {
    if ([lsLogin isEqual:@"0"]) {
        _iPs_POSTID = @"";
        NSLog(@"未登录状态");
        
    }else{
        
        delegate.userid = _userid;
        delegate.username = _username;
        //delegate.usermoney = _usermoney;
        //delegate.userpoints = _userpoints;
        
        _iPs_POSTID = _userid;
        //_btnLogin.titleLabel.text = @"退出";
        //_lbUsername.text = _username;
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

//更新账户信息
- (void)AccountRefresh:(NSNotification*)notification
{
    NSLog(@"更新账户信息");
    washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    userLoginViewController *LoginView = [userLoginViewController alloc];
    
    [LoginView autoLogin:delegate.username password:delegate.password ];
}

//更新二维码信息
- (void)CodeRefresh:(NSNotification*)notification
{
    NSDictionary *theData = [notification userInfo];
    
    NSString *isScan = [theData objectForKey:@"isScanCode"];
    if ([isScan isEqualToString:@"0"]) {
        //扫描失败
        NSLog(@"扫描无效！");
        return;
    }else if ([isScan isEqualToString:@"1"]){
        NSLog(@"扫描成功！");
        
    }
    
    _code = [theData objectForKey:@"Code"];
    _txtCode.text = _code;
    [self btnCheckCodeClicked:_btnSubmit];
}


#pragma mark- GotoPage 页面跳转方法
//页面发生跳转，进入明细
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"useractlogin"])
    {
        NSLog(@"进入登录页面" );
        
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title=@"";
        backItem.tintColor=[UIColor colorWithRed:129/255.0 green:129/255.0  blue:129/255.0 alpha:1.0];
        self.navigationItem.backBarButtonItem = backItem;
        
    }
}


#pragma mark- POST Request 发送网络请求方法
/*
 * 开始请求Web Service
 */
-(void)startRequest
{
    _isConnected = false;
    
    
    
    NSString *strURL = [[NSString alloc] initWithFormat:@"%@%@",_iPs_URL,_iPs_PAGE];
    
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSString *post = [NSString stringWithFormat:_iPs_POST,_iPs_POSTAction,_iPs_POSTID,_code];
    
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
        if(_iPageIndex <= 0)
        {_iPageIndex = 1;}
        
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
    
    NSLog( @"Result: %@", [dict description] );
    //激活数据列表的刷新
    [self reloadView:dict];
}

#pragma mark - Page Data


//重新加载表视图
-(void)reloadView:(NSDictionary*)res
{
    @try{
        
        NSNumber *resultCodeObj = [res objectForKey:@"is_err"];
        if (resultCodeObj==nil) {
            //无法处理的结果
            
            resultCodeObj = [[NSNumber alloc] initWithInt:1];
        }
        if ([resultCodeObj integerValue] ==0){

            //解析订单明细：
            NSDictionary* code_info = [res objectForKey:@"code_info"];
            _code  = [code_info objectForKey:@"code"];
            _userid  = [code_info objectForKey:@"business_id"];
            _customerid  = [code_info objectForKey:@"user_id"];
            _status  = [code_info objectForKey:@"status"];
            _goods_id  = [code_info objectForKey:@"goods_id"];
            _goods_name= [code_info objectForKey:@"goods_name"];
            
            NSString *goods_price = [code_info objectForKey:@"goods_price"];
            NSString *business_displayname = [code_info objectForKey:@"business_displayname"];
            
            NSString *lsMsg = [[NSString alloc]initWithFormat:@"消费码：%@ 验证成功！\n%@  价格：%@ 元，\n%@", _code, _goods_name , goods_price , business_displayname];

            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证完成"
                                                                message:lsMsg
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            _txtCode.text = @"";
            
            
        } else {
            NSLog(@"验证错误：%@",_code);
            NSString *Errormsg = [res objectForKey:@"err_msg"];

            
            NSString *lsMsg = [[NSString alloc]initWithFormat:@"消费码：%@ 验证错误！\n%@", _code, Errormsg];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证未通过"
                                                                message:lsMsg
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            

        }
        
    }@catch(NSException *exp1){
        
    }
    
    
    
}

//控制Page页面数据翻页
- (int)setPageNext
{
	const int N = 15;
	int nextPage = 0;
    nextPage = _iPageIndex + 1;
    if (nextPage>N) {
        nextPage = 1;
    }
    _iPageIndex = nextPage;
    NSLog(@"NextPage=%d",_iPageIndex);
    return nextPage;
}

#pragma mark- End
@end

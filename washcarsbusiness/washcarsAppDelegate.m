//
//  washcarsAppDelegate.m
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-7.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import "washcarsAppDelegate.h"

@implementation washcarsAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Override point for customization after application launch.
    //初始化所有的全局变量
    NSLog(@"å应用启动标记");
    //_iPs_URL=@"http://www.2345mall.com:8080/"; //请求数据接口模板--地址
    //_iPs_URL=@"http://58.96.169.123/yz/"; //请求数据接口模板--地址
    _iPs_URL=staticURL;
    //更新初始化用户数据 //用户配置文件将使用PList存储
    _userid = @"";
    _username = @"";
    _password = @"";
    _userpoints = 0;
    _usermoney = 0;
    _isLogin = true;
    _isbusiness = false;
    _phone = @"";
    _isAutoLogin = true;
    _isreachChanged = false;        //网络连接变更
    _reachStatus=@"";               //网络连接状态
    
    _userServiceName = @"洗车服务";
    //_userAreaID = @"298";
    //禁止加载应用的过程中做复杂的业务，以防卡死在黑屏阶段
    //首页加载完成以后再去处理初始化工作
    _isLimited = false;
    _userAreaID = @"298";
    _userCitySupported = @"1";
    _userCity = @"枣庄";
    _userDistrict = @"枣庄";
    _userServiceName = @"洗车服务";
    
    //修改导航样式
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:48.0/255.0 green:120.0/255.0 blue:172.0/255.0 alpha:0.8]];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"•应用挂起转至后台");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"ç应用活动状态");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"¶应用退出标记");
    [self SaveConfig];
}

//侦测网络连接
- (void)NetworkReachability
{
	//Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"www.baidu.com";
    NSLog(@"检测可用的网络：%@",remoteHostName);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //开启网络状况的监听
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
	[self.hostReachability startNotifier];
	[self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	[self updateInterfaceWithReachability:self.internetReachability];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
	[self.wifiReachability startNotifier];
	[self updateInterfaceWithReachability:self.wifiReachability];
    
}

//存档本地配置信息
- (void)saveUserDefaults{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_userid forKey:@"userid"];
    
}

//读取本地配置信息
- (void)readUserDefaults{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _userid = [ud objectForKey:@"userid"];
}

//读取某个参数
- (NSString*)readUserDefaults:(NSString*)getKey
{
    if (![getKey isEqual:@""]) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        return [ud objectForKey:getKey];
    }
    return @"";
}

//修改某个参数
- (void)saveUserDefaults:(NSString*)ItemKey setValue:(NSString*)ParamValue
{
    if (![ItemKey isEqual:@""]) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:ParamValue forKey:ItemKey];
    }
    
}

//读取某个参数-- BOOL 类型
- (BOOL)readBOOLDefaults:(NSString*)getKey
{
    if (![getKey isEqual:@""]) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        return [ud boolForKey:getKey];
    }
    return false;
}

//修改某个参数-- BOOL 类型
- (void)saveBOOLDefaults:(NSString*)ItemKey setValue:(BOOL)ParamValue
{
    if (![ItemKey isEqual:@""]) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setBool:ParamValue forKey:ItemKey];
    }
    
}

//统一存取用户数据 -- 读取
- (void)LoadConfig
{
    NSString *lsValue = @"";
    NSLog(@"加载配置信息");
    lsValue = [self readUserDefaults:@"URL"];
    if (([lsValue isEqual:@""])|(lsValue ==nil)) {
        _iPs_URL = staticURL; //请求数据接口模板--地址
    }else{
        _iPs_URL = lsValue;
    }
    
    
    //更新初始化用户数据 //用户配置文件将使用PList存储
    _userid = [self readUserDefaults:@"userid"];
    _username = [self readUserDefaults:@"username"];
    _password = [self readUserDefaults:@"password"];
    _businessname = [self readUserDefaults:@"businessname"];
    
    _isLogin = [self readBOOLDefaults:@"islogin"];
    _isbusiness = [self readBOOLDefaults:@"isbusiness"];
    
    _phone = [self readUserDefaults:@"phone"];
    _isAutoLogin = [self readBOOLDefaults:@"isautologin"];
    
    _userpoints = [[self readUserDefaults:@"userpoints"] doubleValue];
    _usermoney = [[self readUserDefaults:@"usermoney"] doubleValue];
    _userbonus = [[self readUserDefaults:@"userbonus"] doubleValue];
    
    //位置信息
    _userProvince = [self readUserDefaults:@"userprovince"];
    _userCity = [self readUserDefaults:@"usercity"];
    _userDistrict = [self readUserDefaults:@"userdistrict"];
    _userAddress  = [self readUserDefaults:@"useraddress"];
    _userAreaID  = [self readUserDefaults:@"userareaid"];
    
    _userCitySupported = [self readUserDefaults:@"usercitysupported"];
    //[self ReadUserLocation];
}

//统一存取用户数据 -- 保存
- (void)SaveConfig
{
    NSLog(@"保存配置信息");
    //更新初始化用户数据 //用户配置文件将使用PList存储
    [self saveUserDefaults:@"userid" setValue:_userid];
    [self saveUserDefaults:@"username" setValue:_username];
    [self saveUserDefaults:@"password" setValue:_password];
    [self saveUserDefaults:@"businessname" setValue:_businessname];
    
    [self saveBOOLDefaults:@"islogin" setValue:_isLogin];
    [self saveBOOLDefaults:@"isbusiness" setValue:_isbusiness];
    [self saveUserDefaults:@"phone" setValue:_phone];
    [self saveBOOLDefaults:@"isautologin" setValue:_isAutoLogin];
    
    NSString *lsValue = [NSString  stringWithFormat:@"%f",_userpoints];
    [self saveUserDefaults:@"userpoints" setValue:lsValue];
    lsValue = [NSString  stringWithFormat:@"%f",_usermoney];
    [self saveUserDefaults:@"usermoney" setValue:lsValue];
    
    lsValue = [NSString  stringWithFormat:@"%f",_userbonus];
    [self saveUserDefaults:@"userbonus" setValue:lsValue];
    
    [self saveUserDefaults:@"userlatitude" setValue:_userlatitude];
    [self saveUserDefaults:@"userlongitude" setValue:_userlongitude];
    
    [self saveUserDefaults:@"userprovince" setValue:_userProvince];
    [self saveUserDefaults:@"usercity" setValue:_userCity];
    [self saveUserDefaults:@"userdistrict" setValue:_userDistrict];
    [self saveUserDefaults:@"useraddress" setValue:_userAddress];
    [self saveUserDefaults:@"userareaid" setValue:_userAreaID];
    
    [self saveUserDefaults:@"usercitysupported" setValue:_userCitySupported];
}

//更新坐标
- (void)SetUserLocation:(NSString *)Pmlatitude longitude:(NSString *)Pmlongitude
{
    NSLog(@"保存用户位置信息");
    
    _userlatitude = Pmlatitude;
    _userlongitude = Pmlongitude;
    
}

/*
- (void)SetUserLocation:(CLLocationCoordinate2D)PmUserpt
{
    NSLog(@"保存用户位置信息");
    
    _Userpt = PmUserpt;
    
    _userlatitude = [[NSString alloc] initWithFormat:@"%f" ,PmUserpt.latitude ];
    _userlongitude = [[NSString alloc] initWithFormat:@"%f" ,PmUserpt.longitude ];
    
    [self saveUserDefaults:@"userlatitude" setValue:_userlatitude];
    [self saveUserDefaults:@"userlongitude" setValue:_userlongitude];
    
}*/

/*
- (void)ReadUserLocation
{
    
    _userlatitude = [self readUserDefaults:@"userlatitude"];
    _userlongitude = [self readUserDefaults:@"userlongitude"];
    
    if ((_userlatitude == nil)||([_userlatitude isEqualToString:@""])) {
        //无定位
        
        
        
        
        return;
    }
    
    CLLocationCoordinate2D PmUserpt;
    PmUserpt.latitude = [_userlatitude doubleValue];
    PmUserpt.longitude = [_userlongitude doubleValue];
    _Userpt = PmUserpt;
    
}*/

//
/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
    _isreachChanged = true;        //网络连接变更
    
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (_isreachChanged == false){
        return;
    }
    if (reachability == self.hostReachability)
	{
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        //BOOL connectionRequired = [reachability connectionRequired];
        
        switch (netStatus) {
            case NotReachable:
                //没有连接到网络就弹出提示
                [self showNotify:@"没有发现可用的网络连接！" HoldTimes:3 ];
                NSLog(@"没有发现可用的网络连接！");
                _reachStatus=@"0";               //网络连接状态
                break;
                
            case ReachableViaWiFi:
                NSLog(@"当前网络模式：Wifi");
                _reachStatus=@"2";               //网络连接状态
                break;
                
            case ReachableViaWWAN:
                [self showNotify:@"连接使用网络2G/3G模式，请注意流量" HoldTimes:2.5 ];
                NSLog(@"当前网络模式：WLAN 2G/3G");
                _reachStatus=@"1";               //网络连接状态
                break;
            default:
                break;
        }
    }
    /*
     if (reachability == self.internetReachability)
     {
     NSLog(@"当前网络模式：WLAN 2G/3G");
     [self showNotify:@"连接使用网络2G/3G模式，请注意流量" HoldTimes:2.5 ];
     }
     
     if (reachability == self.wifiReachability)
     {
     NSLog(@"当前网络模式：Wifi");
     }
     */
}

//弹出消息框延时、后自动消失
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    
    promptAlert =NULL;
}

//弹出通知消息  延时关闭
- (void)showNotify:(NSString*)MessageContent HoldTimes:(double)holdseconds
{
    if ([MessageContent isEqual:@""]) {
        return;
    }
    
    if (0<=holdseconds) {
        holdseconds = 1.5f;
    }
    
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:MessageContent delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:holdseconds
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:NO];
    
    [promptAlert show];
}

@end

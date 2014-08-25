//
//  serviceTableViewController.m
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-9.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import "serviceTableViewController.h"
#import "MJRefresh.h"
#import "salesCountViewCell.h"
#import "salesDayListViewController.h"

@interface serviceTableViewController (){
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
#pragma mark- Declare 声明变量
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

//传入变化的参数组,参数数目根据接口需要而变化
@property (strong, nonatomic) NSString *iPs_POSTID; //请求数据POST参数ID1
@property (strong, nonatomic) NSString *iPs_POSTQueryOption; //请求数据POST参数ID2
@property (strong, nonatomic) NSString *iPs_POSTQueryRegion; //请求数据POST参数ID3

//页面内部变量(由程序控制实际值)
@property (nonatomic) int iPageIndex;
@property (nonatomic) Boolean isConnected;




@end
//页面控制流程说明：
//1.初始化 viewWillAppear,initPage,viewDidLoad
//2.请求数据 startRequest
//3.数据返回解析 connectionDidFinishLoading , reloadView , tableView.reloadData
//4.数据展示 cellForRowAtIndexPath
//5.页面跳转 prepareForSegue

@implementation serviceTableViewController
#pragma mark- ShowEvent 页面显示方法
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self initPage];
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
    if (_iPs_PageName==nil) {
        [self initPage];
    }
    if (_isConnected == false) {
        NSLog(@"尝试重新加载数据...");
        //重新加载数据
        //[self startRequest];
    }
    // 3.2.上拉加载更多
    [self addFooter];
    [self addHeader];
    
    //加载数据 -- 如果从外部传入了 listData 可直接刷新Table
    //[self.tableView reloadData];
    
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
        [self startRequest];
    }
    
    
    washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    _iPs_POSTID= delegate.userid ; //请求数据POST参数ID1
    
    _txtName.text = delegate.businessname;
    
    if ((_iPs_POSTID == nil)||([_iPs_POSTID isEqualToString:@""])) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户未登录"
                                                            message:@"请登录后查看上线的项目"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [_listData removeAllObjects ];
    // Dispose of any resources that can be recreated.
}

//初始化页面变量组和参数
- (void)initPage
{
    //根据页面类型不同需要配置的部分
    _iPs_PageName=@"所有产品消费统计"; //页面名称(用于标记页面参数配置)
    //_iPs_URL=@"http://114.112.73.223:8080/"; //请求数据接口模板--地址
    washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
    _iPs_URL=delegate.iPs_URL; //请求数据接口模板--地址
    
    _iPs_PAGE=@"business_app.php"; //请求数据接口模板--页面
    _iPs_POST=@"act=%@&business_id=%@"; //请求数据POST参数模板
    
    _iPs_POSTID= delegate.userid ; //请求数据POST参数ID1
    
    _iPs_POSTAction =@"search_goods"; //销售记录
    
    _iPs_POSTQueryOption=@"0"; //请求数据POST参数ID2：0 详情 1评论 2销售记录
    _iPs_POSTQueryRegion=@""; //请求数据POST参数ID3
    
    
    //不随页面类型改变的部分
    _iPageIndex = 1;//初始化页面序号
    _CellBgColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.55];
}
#pragma mark - Table Action 上下滑动Cell
//增加向下滑动刷新下页功能
- (void)addFooter
{
    __unsafe_unretained serviceTableViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        NSLog(@"下拉请求更多数据 %d",_iPageIndex);
        [self setPageNext];
        //加载数据
        [self startRequest];
        
        
        //[vc->_fakeData addObject:[NSString stringWithFormat:@"随机数据---%d", random]];
        
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.1];
        
        //NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}

//滑动调用的刷新事件
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    NSLog(@"滑动展示数据表格");
    // 刷新表格
    [self.tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

//增加向上滑动返回上页功能
- (void)addHeader
{
    
    __unsafe_unretained serviceTableViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        NSLog(@"上拉请求翻页数据 %d",_iPageIndex);
        if (_iPageIndex<=1) {
            _iPageIndex = 1;
            NSLog(@"当前的数据列表没有历史缓存 %d",_iPageIndex);
            
        }else{
            //翻页控制逻辑这里后退1页
            _iPageIndex = _iPageIndex - 1;
            //加载数据
            [self startRequest];
        }
        
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.5];
        
        //NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        //NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                //NSLog(@"切换到：普通状态");
                break;
                
            case MJRefreshStatePulling:
                //NSLog(@"松开即可刷新的状态");
                break;
                
            case MJRefreshStateRefreshing:
                //NSLog(@"正在刷新状态");
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.listData.count;
}

//表格的定制化操作
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"sellscell";
    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier  forIndexPath:indexPath];
    //使用自定义的单元格
    salesCountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier  forIndexPath:indexPath];
    
    if (cell == nil) {
        NSLog(@"表格初始化错误");
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"sellscell" owner:self options:nil] ;
        
        cell = [nib objectAtIndex:0];
    }
    
    //
    NSString *lsName = @"";
    NSString *lsgoodsid = @"";
    NSString *lsprice = @"";
    NSString *lsDate = @"";
    NSString *lsgoods_image = @"";
    NSString *lscount = @"";
    NSString *lsconsume = @"";
    
    
    //开始解析数据
    NSMutableDictionary*  dict = self.listData[indexPath.row];
    
    @try {
        //修改单元格背景色
        UIView *bgColorView = [[UIView alloc] init];
        
        bgColorView.backgroundColor = _CellBgColor;
        bgColorView.layer.masksToBounds = YES;
        cell.selectedBackgroundView = bgColorView;
        
        
        lsName = [dict objectForKey:@"goods_name"];
        if ((lsName == nil)||([lsName isEqualToString:@""])) {
            lsName = @"未命名";
        }
        
        //填充Detail数据字段
        lsgoodsid =[dict objectForKey:@"goods_id"];
        lsDate =[dict objectForKey:@"add_time"];
        
        lsprice =[dict objectForKey:@"shop_price"];
        
        lsgoods_image =[dict objectForKey:@"goods_image"];
        lscount =[dict objectForKey:@"total"];
        lsconsume =[dict objectForKey:@"had"];
        
        
        if ((lsgoodsid == nil)||([lsgoodsid isEqualToString:@""])) {
            lsgoodsid = @"0";
        }
        
        if ([lsName length]>16) {
            lsName = [lsName substringToIndex:16];
        }
        
        cell.txtName.text =lsName;
        cell.txtPrice.text = lsprice;
        cell.txtDate.text = lsDate;
        cell.txtConsume.text = lsconsume;
        cell.txtSaled.text = lscount;
        
        //带有缓存机制的图片加载
        NSString *strImgName = [dict objectForKey:@"goods_image"];
        
        if (([strImgName isEqualToString:@""])||(strImgName == nil)){
            strImgName = @"洗车.png";
            cell.imgService.image = [UIImage imageNamed:strImgName];
            return cell;
        }
        
        NSString *strImgURL = [[NSString alloc] initWithFormat:@"%@%@",_iPs_URL,strImgName];
        //没有必要每次都从网络获取图片，应该建立图片缓存，优先查找本地缓存
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *imgurl = [[NSURL alloc] initWithString: strImgURL];
        
        //异步加载图片
        
        [manager downloadWithURL:imgurl
                         options:0
                        progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
             //NSLog(@"%d.正在下载图片 %d / %d", indexPath.row , receivedSize , expectedSize);
             
         }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (image)
             {
                 // do something with image
                 cell.imgService.image = image;
                 //NSLog(@"异步载入图片 %@",strImgURL);
             }
         }];
        
    }@catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    //以上已完成单元格修改
    return cell;
}
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
#pragma mark - Navigation
//页面发生跳转，进入明细
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"showsalsday"])
    {
        salesDayListViewController *itemdetail = segue.destinationViewController;
        NSInteger selectedRow = [[self.tableView indexPathForSelectedRow] row];
        
        NSMutableDictionary*  dict = self.listData[selectedRow];
        
        NSString *strName = [dict objectForKey:@"goods_name"];
        //itemdetail.title = [dict objectForKey:@"goods_name"];
        
        itemdetail.itemname = strName;
        
        itemdetail.itemid = [dict objectForKey:@"goods_id"];
        itemdetail.itemdate = [dict objectForKey:@"add_time"];
        
        itemdetail.itemconsume = [dict objectForKey:@"had"];
        itemdetail.itemcount = [dict objectForKey:@"total"];
        
//        itemdetail.itemRank = [dict objectForKey:@"goods_com_rank"];
//        
//        itemdetail.itemName = strName;
//        itemdetail.title = strName;
        NSLog(@"进入消费量列表 %d %@", selectedRow ,strName);
        
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title=@"";
        backItem.tintColor=[UIColor colorWithRed:129/255.0 green:129/255.0  blue:129/255.0 alpha:1.0];
        self.navigationItem.backBarButtonItem = backItem;
        
    }
}


#pragma mark- POST Data 页面请求数据
/*
 * 开始请求Web Service
 */
-(void)startRequest
{
    _isConnected = false;
    
    
    
    NSString *strURL = [[NSString alloc] initWithFormat:@"%@%@",_iPs_URL,_iPs_PAGE];
    
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSString *post = [NSString stringWithFormat:_iPs_POST,_iPs_POSTAction,_iPs_POSTID];
    
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
            NSDictionary* code_info = [res objectForKey:@"goods_list"];
            NSEnumerator *enumerator = [code_info objectEnumerator];
            
            NSArray *results = [enumerator allObjects];
            
            _listData = [NSMutableArray arrayWithArray:results];
            
            NSString *lsTotal;
            NSString *lsConsume;
            
            int itotal = 0;
            int iConsume = 0;
            
            for (int i = 0; i < results.count; i++) {
                lsTotal = [[results objectAtIndex:i]objectForKey:@"total"];
                lsConsume = [[results objectAtIndex:i]objectForKey:@"had"];
                
                itotal += [lsTotal intValue];
                
                iConsume += [lsConsume intValue];
 
            }
            _txtSaled.text = [[NSString alloc]initWithFormat:@"%d", itotal];
            _txtconsume.text = [[NSString alloc]initWithFormat:@"%d", iConsume];
            
            //_code  = [code_info objectForKey:@"goods_id"];
            //_userid  = [code_info objectForKey:@"goods_name"];
            NSLog(@"列表视图加载数据...共 %d 条",results.count);
            
            [self.tableView reloadData];
        } else {
            _iPageIndex = 0;
            NSString *Errormsg = [res objectForKey:@"err_msg"];
            NSLog(@"数据请求错误：%@",Errormsg);
            
            NSString *lsMsg = [[NSString alloc]initWithFormat:@"暂无对商家的评论\n%@", Errormsg];
            washcarsAppDelegate *delegate=(washcarsAppDelegate*)[[UIApplication sharedApplication]delegate];
            
            [delegate showNotify:lsMsg HoldTimes:2.0];
            
            
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

//图片的处理
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"获取网络图片 %@",fileURL);
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

//保存图片
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件类型无法支持，请选择 jpeg，png格式");
    }
}

//文件路径，url/Image.png
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

@end

//
//  notifyViewController.m
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-22.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import "notifyViewController.h"

@interface notifyViewController ()

@property (strong, nonatomic) NSString *iPs_WebPAGE;
@property (strong, nonatomic) NSString *iPs_WebGet;

@end

@implementation notifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _iPs_WebGet = @"message_id=";
    _subWebContent.delegate = self;
    [self loadWebContent];
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

//加载基于Web页面的描述信息
- (void)loadWebContent{
    //http://www.2345mall.com/description_app.php?act=goodsdesc&goods_id=",参数传商品ID
    
    NSString *strURL = [[NSString alloc] initWithFormat:@"%@?%@%@",_weburl,_iPs_WebGet,_notifyid];
    
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_subWebContent loadRequest:request];
    
    
}

#pragma mark ---- 数据加载完调用webView代理方法
- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    NSLog(@"加载基于Web页面的描述信息");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    /*
    CGRect frame = aWebView.frame;
    //webView的宽度
    frame.size = CGSizeMake(300, 0);
    aWebView.frame = frame;
    float content_height = [[aWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    frame = aWebView.frame;
    //webView的宽度和高度
    frame.size = CGSizeMake(300, content_height+40);
    aWebView.frame = frame;
    
    //NSLog(@"-----%d",(int) frame.size.height);
    
    
    //移动下面两个View的位置
    int ypos = aWebView.frame.origin.y + frame.size.height + 20;
    
    _subViewComment.frame = CGRectMake( 0, ypos, _subViewComment.frame.size.width, _subViewComment.frame.size.height ); // set new position exactly
    
    ypos = ypos + _subViewComment.frame.size.height;
    
    _subViewDescribe.frame = CGRectMake( 0, ypos, _subViewDescribe.frame.size.width, _subViewDescribe.frame.size.height ); // set new position exactly
    
    self.detailscrollview.contentSize = CGSizeMake(320,ypos + _subViewDescribe.frame.size.height - 100);
     */
}

@end

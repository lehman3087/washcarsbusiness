//
//  checkViewController.h
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-9.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "washcarsAppDelegate.h"
#import "NSString+URLEncoding.h"

@interface checkViewController : UIViewController <UITextViewDelegate>

@property (nonatomic) BOOL isInital;           //初始化不能多次调用

@property (weak, nonatomic) IBOutlet UITextView *txtCode;


@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollMainView;

@property (weak, nonatomic) IBOutlet UIView *subKeyView;

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIButton *btn4;

@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (weak, nonatomic) IBOutlet UIButton *btn6;

@property (weak, nonatomic) IBOutlet UIButton *btn7;

@property (weak, nonatomic) IBOutlet UIButton *btn8;

@property (weak, nonatomic) IBOutlet UIButton *btn9;

@property (weak, nonatomic) IBOutlet UIButton *btn0;

@property (weak, nonatomic) IBOutlet UIImageView *Horizontal1;

@property (weak, nonatomic) IBOutlet UIImageView *Horizontal2;

@property (weak, nonatomic) IBOutlet UIImageView *Horizontal3;

@property (weak, nonatomic) IBOutlet UIImageView *Horizontal4;

@property (weak, nonatomic) IBOutlet UIImageView *Horizontal5;

@property (weak, nonatomic) IBOutlet UIImageView *Vertical1;

@property (weak, nonatomic) IBOutlet UIImageView *Vertical2;

@property (weak, nonatomic) IBOutlet UIImageView *Vertical3;

@property (weak, nonatomic) IBOutlet UIImageView *Vertical4;


//保存数据列表[表现层所依赖的内部数据集合]
@property (nonatomic,strong) NSMutableArray* listData;  //商品列表
//接收从服务器返回数据 Json包
@property (strong,nonatomic) NSMutableData *datas;

@property (nonatomic) int delcount;
@property (strong, nonatomic) NSString *code;           //返回参数code
@property (strong, nonatomic) NSString *goods_id;           //返回参数商品id
@property (strong, nonatomic) NSString *goods_name;
@property (strong, nonatomic) NSString *order_id;           //返回参数订单id

@property (strong, nonatomic) NSString *userid;    //商户
@property (strong, nonatomic) NSString *username;    //商户名

@property (strong, nonatomic) NSString *customerid;    //用户

//@property (strong, nonatomic) NSString *business_id;
@property (strong, nonatomic) NSString *status;           //返回参数code状态

@property (strong, nonatomic)UIColor *CellBgColor;  //单元格背景色
//重新加载表视图
-(void)reloadView:(NSDictionary*)res;

//开始请求Web Service
-(void)startRequest;

//翻页
- (int)setPageNext;




@end

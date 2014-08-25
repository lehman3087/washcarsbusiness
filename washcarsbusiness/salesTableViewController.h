//
//  salesTableViewController.h
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-9.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+URLEncoding.h"
#import "washcarsAppDelegate.h"
#import "UIImageView+WebCache.h"

@interface salesTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *txtName;

@property (weak, nonatomic) IBOutlet UILabel *txtconsume;

@property (weak, nonatomic) IBOutlet UILabel *txtSaled;


//保存数据列表[表现层所依赖的内部数据集合]
@property (nonatomic,strong) NSMutableArray* listData;  //商品列表
//接收从服务器返回数据 Json包
@property (strong,nonatomic) NSMutableData *datas;

@property (strong, nonatomic) NSString *itemid;             //传入参数id
@property (strong, nonatomic) NSString *itemname;           //传入参数--名称
@property (strong, nonatomic) NSString *itemcount;          //传入参数--销量
@property (strong, nonatomic) NSString *itemconsume;        //传入参数--消费量
@property (strong, nonatomic) NSString *itemdate;           //传入参数--上架日期
@property (strong, nonatomic) NSString *itemprice;          //传入参数--单价

@property (strong, nonatomic)UIColor *CellBgColor;  //单元格背景色
//重新加载表视图
-(void)reloadView:(NSDictionary*)res;

//开始请求Web Service
-(void)startRequest;

//翻页
- (int)setPageNext;



@end

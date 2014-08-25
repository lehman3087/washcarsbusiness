//
//  moreTableViewController.h
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-9.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "washcarsAppDelegate.h"
#import "NSString+URLEncoding.h"
@interface moreTableViewController : UITableViewController


@property (weak, nonatomic) IBOutlet UIButton *btnQuit;

@property (weak, nonatomic) IBOutlet UILabel *menuName;

@property (weak, nonatomic) IBOutlet UILabel *menuMsg;

@property (weak, nonatomic) IBOutlet UILabel *menuServices;

@property (weak, nonatomic) IBOutlet UILabel *menuRecommend;

@property (weak, nonatomic) IBOutlet UILabel *menuSuggestion;



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
@property (strong, nonatomic) NSString *businessname;       //商铺名称

@property (strong, nonatomic) NSString *customerid;    //用户

@property (nonatomic) BOOL isQuitCurrent;           //退出登录
@end

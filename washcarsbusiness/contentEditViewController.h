//
//  contentEditViewController.h
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-20.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+URLEncoding.h"
#import "washcarsAppDelegate.h"

@interface contentEditViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtContent;

@property (weak, nonatomic) IBOutlet UILabel *txtlength;

@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

//接收从服务器返回数据 Json包
@property (strong,nonatomic) NSMutableData *datas;

@property (strong, nonatomic) NSString *itemid;           //传入参数id
@property (strong, nonatomic) NSString *itemcontent;           //传入的回复原文
@property (strong, nonatomic) NSString *itemcommit;           //传入的评论原文

@property (strong, nonatomic) NSString *newcontent;           //新的评价回复

@property (nonatomic) int wordslimit;

//重新加载表视图
-(void)reloadView:(NSDictionary*)res;

//开始请求 Web Service
-(void)startRequest;

@end

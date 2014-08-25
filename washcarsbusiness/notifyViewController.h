//
//  notifyViewController.h
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-22.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+URLEncoding.h"

@interface notifyViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) NSString *notifyid;           //参数id
@property (strong, nonatomic) NSString *weburl;           //
@property (strong, nonatomic) NSString *name;           //
@property (weak, nonatomic) IBOutlet UIWebView *subWebContent;

@end

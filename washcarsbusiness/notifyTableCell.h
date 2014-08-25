//
//  notifyTableCell.h
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-22.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notifyTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *txtNumber;

@property (weak, nonatomic) IBOutlet UILabel *txtTitle;

@property (weak, nonatomic) IBOutlet UILabel *txtDate;

@property (weak, nonatomic) IBOutlet UITextView *txtContent;

@property (strong, nonatomic) NSString *notifyid;
@property (strong, nonatomic) NSString *url;

@end

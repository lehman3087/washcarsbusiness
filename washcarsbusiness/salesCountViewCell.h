//
//  salesCountViewCell.h
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-19.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface salesCountViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgService;

@property (weak, nonatomic) IBOutlet UILabel *txtName;

@property (weak, nonatomic) IBOutlet UILabel *txtPrice;

@property (weak, nonatomic) IBOutlet UILabel *txtDate;

@property (weak, nonatomic) IBOutlet UILabel *txtConsume;

@property (weak, nonatomic) IBOutlet UILabel *txtSaled;

@end

//
//  commitTableCell.h
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-13.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface commitTableCell : UITableViewCell<RatingViewDelegate>{
    RatingView *starView;
}



@property (weak, nonatomic) IBOutlet UILabel *txtScore;

@property (weak, nonatomic) IBOutlet UIView *bgScore;

@property (weak, nonatomic) IBOutlet UILabel *txtName;

@property (weak, nonatomic) IBOutlet UILabel *txtPrice;

@property (weak, nonatomic) IBOutlet UILabel *txtDate;

@property (weak, nonatomic) IBOutlet UILabel *txtMemo;

@property (weak, nonatomic) IBOutlet RatingView *starView;

-(void)setRating:(float)newRating;

-(void)initstarRating;

@end

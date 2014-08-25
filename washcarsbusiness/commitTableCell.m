//
//  commitTableCell.m
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-13.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import "commitTableCell.h"

@implementation commitTableCell
@synthesize starView =_starView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark- ActionEvent 触发控制逻辑

-(void)ratingChanged:(float)newRating {
	//_ratingLabel.text = [NSString stringWithFormat:@"%1.1f", newRating];
}

-(void)setRating:(float)newRating {
    
    
    [_starView displayRating:newRating];
}

-(void)initstarRating{
    //星星评级
    [_starView setImagesDeselected:@"Star0.png" partlySelected:@"Star1.png" fullSelected:@"Star2.png" andDelegate:self];

    [_starView displayRating:[_txtScore.text floatValue]];
}

@end

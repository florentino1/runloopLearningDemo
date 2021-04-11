//
//  MealTableViewCell.m
//  FoodTracker
//
//  Created by 莫玄 on 2021/2/21.
//  Copyright © 2021 莫玄. All rights reserved.
//

#import "MealTableViewCell.h"

@implementation MealTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.namelabel.text=@"mealName";
    self.photoImageView.image=[UIImage imageNamed:@"DefaultImage"];
   // self.ratingControl=[[RatingControl alloc]init];//这一条千万不能添加到代码中；critical
 

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end

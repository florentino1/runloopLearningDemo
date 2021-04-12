//
//  tableViewCell.m
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/11.
//

#import "tableViewCell.h"
#import "ratingController.h"

@implementation tableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.text=@"mealName";
    self.imageView.image=[UIImage imageNamed:@"placeholderPic"];
    self.ratingController.userInteractionEnabled=NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

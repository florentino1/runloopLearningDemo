//
//  MealTableViewCell.h
//  FoodTracker
//
//  Created by 莫玄 on 2021/2/21.
//  Copyright © 2021 莫玄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingControl.h"
#import "Meal.h"

NS_ASSUME_NONNULL_BEGIN

@interface MealTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *namelabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet RatingControl *ratingControl;

@end

NS_ASSUME_NONNULL_END

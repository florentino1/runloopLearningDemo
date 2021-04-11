//
//  ViewController.h
//  FoodTracker
//
//  Created by 莫玄 on 2021/1/29.
//  Copyright © 2021 莫玄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meal.h"

@interface MealViewController : UIViewController
@property (nonatomic,nullable)Meal *NewMeal;//用户添加新的meal页时用作信息储存；

@end


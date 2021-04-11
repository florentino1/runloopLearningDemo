//
//  singleMeal.m
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/10.
//

#import "singleMeal.h"

@implementation singleMeal
-(instancetype)initWithName:(NSString *)name Photo:(UIImage *)photo andRating:(NSUInteger)rating
{
    self=[super init];
    if(self)
    {
        _mealName=name;
        _mealPhoto=photo;
        _mealRating=rating;
    }
    return self;
}
@end

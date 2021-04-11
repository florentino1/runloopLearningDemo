//
//  singleMeal.m
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/10.
//

#import "singleMeal.h"

@implementation singleMeal
-(nullable instancetype)initWithName:(NSString *)name Photo:(UIImage *)photo andRating:(NSUInteger)rating
{
    self=[super init];
    if(name==NULL)
        return NULL;
    else if (rating<0 || rating>5)
        return NULL;
    else
    {
        _mealName=name;
        _mealPhoto=photo;
        _mealRating=rating;
    }
    return self;
}
@end

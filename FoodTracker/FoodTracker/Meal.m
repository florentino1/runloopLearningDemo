//
//  Meal.m
//  FoodTracker
//
//  Created by 莫玄 on 2021/2/20.
//  Copyright © 2021 莫玄. All rights reserved.
//

#import "Meal.h"

@implementation Meal

-(nullable instancetype)initWithMealName:(NSString *)mealname mealPhoto:(UIImage *)mealphoto rating:(NSUInteger)rating
{
    self=[super init];
    if(mealname==NULL)
    {
        return NULL;
    }
    else if (rating<0 || rating>5) {
        return NULL;
    }
    self->mealName=mealname;
    self->mealPhoto=mealphoto;
    self->rating=rating;
    return self;
}

#pragma mark-NSCoding
-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self->mealName forKey:@"propertyKey.name"];
    [coder encodeObject:self->mealPhoto forKey:@"propertyKey.photo"];
    [coder encodeInteger:self->rating forKey:@"propertyKey.rating"];
}
-(instancetype)initWithCoder:(NSCoder *)coder
{
    NSString *name=[coder decodeObjectForKey:@"propertyKey.name"];
    if(!name)
        return nil;
    UIImage *photo=[coder decodeObjectForKey:@"propertyKey.photo"];
    NSUInteger rating=[coder decodeIntegerForKey:@"propertyKey.rating"];
    self=[self initWithMealName:name mealPhoto:photo rating:rating];
    return self;

}
@end

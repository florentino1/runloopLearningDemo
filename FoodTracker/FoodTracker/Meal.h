//
//  Meal.h
//  FoodTracker
//
//  Created by 莫玄 on 2021/2/20.
//  Copyright © 2021 莫玄. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef struct {
    NSString *name;
    UIImage *photo;
    NSUInteger rating;
}propertyKey;

@interface Meal : NSObject<NSCoding>
{
    @public
NSString *mealName;
UIImage * _Nullable mealPhoto;
NSUInteger rating;
}

-(nullable instancetype)initWithMealName:(NSString *)mealname mealPhoto:(UIImage *)mealphoto rating:(NSUInteger)rating;
@end

NS_ASSUME_NONNULL_END

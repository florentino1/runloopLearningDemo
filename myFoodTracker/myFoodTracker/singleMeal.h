//
//  singleMeal.h
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface singleMeal : NSObject
@property (nonatomic,strong)NSString *mealName;
@property (nonatomic,strong)UIImage *mealPhoto;
@property (nonatomic,assign)NSUInteger mealRating;
-(instancetype)initWithName:(NSString *)name Photo:(UIImage *)photo andRating:(NSUInteger)rating;
@end

NS_ASSUME_NONNULL_END

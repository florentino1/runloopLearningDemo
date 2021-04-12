//
//  ratingController.h
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ratingController : UIStackView
@property (nonatomic,assign)IBInspectable NSUInteger starCount;  //当前星星的数量
@property (nonatomic,assign)IBInspectable float starWeith;//星星的宽度
@property (nonatomic,assign)IBInspectable float starHeight;//单个星星的高度
@property (nonatomic,assign)NSUInteger currentRating;//当前的评分

@end

NS_ASSUME_NONNULL_END

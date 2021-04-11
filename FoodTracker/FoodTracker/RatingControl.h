//
//  RatingControl.h
//  FoodTracker
//
//  Created by 莫玄 on 2021/2/1.
//  Copyright © 2021 莫玄. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RatingControl : UIStackView
@property(assign,nonatomic)NSUInteger rating;
@property(assign,nonatomic)IBInspectable int starCount;
@property(assign,nonatomic)IBInspectable float starSizeHeight;
@property(assign,nonatomic)IBInspectable float starSizeWidth;
-(void)updateButtonSelectionStates;
@end

NS_ASSUME_NONNULL_END

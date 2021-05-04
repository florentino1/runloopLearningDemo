//
//  stackViewController.h
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class myUIImageView;
@interface stackViewController : UIStackView
-(instancetype)initWithCoder:(NSCoder *)coder;
-(instancetype)initWithFrame:(CGRect)frame;
-(void)refreshSingleImageViewColor;
@end

NS_ASSUME_NONNULL_END

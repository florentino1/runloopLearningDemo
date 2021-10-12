//
//  myUIImageView.h
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface myUIImageView : UIImageView
@property (assign,nonatomic)CGFloat positionX;//该imageView的中心点X坐标持续的变化值
@property (assign,nonatomic)CGFloat positionY;//该imageView的中心点Y坐标
@property (assign,nonatomic)CGFloat positionXCurrent;//该imageView的中心点x坐标的暂时值
@property (assign,nonatomic)CGFloat positionXOriginX;//该imageView的中心点x坐标的初始值
@property (strong,nonatomic)RGBColor *colorInfo;//用于储存当前背景颜色的信息

@end

NS_ASSUME_NONNULL_END

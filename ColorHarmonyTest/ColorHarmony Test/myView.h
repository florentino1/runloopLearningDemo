//
//  myView.h
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface myView : UIView
@property (assign,nonatomic)CGFloat positionOriginX;//该imageView的中心点x坐标的初始值
@property (assign,nonatomic)CGFloat positionOriginY;//该imageView的中心点Y坐标
@property (assign,nonatomic)CGFloat positionCurrentX;//该imageView的中心点x坐标持续值
@property (assign,nonatomic)CGFloat positionCurrentY;//该imageView的中心点y坐标持续值
@property (strong,nonatomic)RGBColor *colorInfo;//用于储存当前背景颜色的信息

-(instancetype)initWithTag:(NSUInteger)tag;
@end

NS_ASSUME_NONNULL_END

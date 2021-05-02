//
//  myUIImageView.h
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface myUIImageView : UIImageView
@property (assign,nonatomic)CGFloat positionX;//该imageView的中心点X坐标原始值
@property (assign,nonatomic)CGFloat positionY;//该imageView的中心点Y坐标
@property (assign,nonatomic)CGFloat positionXTEM;//该imageView的中心点x坐标的暂时值

@end

NS_ASSUME_NONNULL_END

//
//  mainViewController.h
//  myWhitePonyWeather
//
//  Created by 莫玄 on 2021/4/18.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface mainViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIStackView *stackView;
@property (strong, nonatomic) IBOutlet UILabel *weatherLabel;
@property (strong, nonatomic) IBOutlet UILabel *highlowtempretureLabel;
@property (strong, nonatomic) IBOutlet UILabel *mismoLabel;
@property (strong, nonatomic) IBOutlet UILabel *updateTimeLabel;

@end

NS_ASSUME_NONNULL_END

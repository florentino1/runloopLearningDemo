//
//  ViewController.h
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/10.
//

#import <UIKit/UIKit.h>
@class singleMeal;
@interface editViewController : UIViewController
@property (strong,nonatomic)singleMeal *prepredMeal;
@property (strong,nonatomic)singleMeal *tem;//新的已经做过更改的singlemeal


@end


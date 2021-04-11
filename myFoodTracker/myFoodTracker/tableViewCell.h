//
//  tableViewCell.h
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ratingController;
@interface tableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet ratingController *ratingController;

@end

NS_ASSUME_NONNULL_END



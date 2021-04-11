//
//  singleMenuViewController.m
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/10.
//

#import "singleMenuViewController.h"
#import "singleMeal.h"
#import "ratingController.h"

@interface singleMenuViewController ()<UINavigationBarDelegate>
@property (strong,nonatomic)UIImageView *imageView;
@property (strong,nonatomic)ratingController *ratingController;
@end

@implementation singleMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

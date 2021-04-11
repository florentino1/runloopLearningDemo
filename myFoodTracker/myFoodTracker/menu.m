//
//  menu.m
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/10.
//

#import "menu.h"
#import "DBManager.h"
#import "singleMeal.h"
#import "tableViewCell.h"
#import "ratingController.h"
#import "singleMenuViewController.h"

@interface menu ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)NSArray *arrayFromFMDB;
@end

@implementation menu

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getFMDBData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)getFMDBData
{
    DBManager *manager=[DBManager sharedDBManager];
    [manager initDB];
    self.arrayFromFMDB=[manager getAll];
    /*数据库测试代码
        DBManager *manager=[DBManager sharedDBManager];
        [manager initDB];
        UIImage *photo1=[UIImage imageNamed:@"test"];
        UIImage *photo2=[UIImage imageNamed:@"placeholderPic"];
        singleMeal *meal1=[[singleMeal alloc]initWithName:@"testMeal1" Photo:photo1 andRating:3];
        singleMeal *meal2=[[singleMeal alloc]initWithName:@"testMeal2" Photo:photo2 andRating:5];
        [manager insertMealName:meal1.mealName mealRating:meal1.mealRating mealPhoto:meal1.mealPhoto];
        [manager insertMealName:meal2.mealName mealRating:meal2.mealRating mealPhoto:meal2.mealPhoto];
     */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.arrayFromFMDB count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSInteger index=indexPath.row;
    singleMeal *meal=self.arrayFromFMDB[index];
    cell.imageView.image=meal.mealPhoto;
    cell.nameLabel.text=meal.mealName;
    cell.ratingController.currentRating=meal.mealRating;
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [super prepareForSegue:segue sender:sender];
    if([segue.identifier isEqualToString:@"showSingleMenu"])
    {
        NSUInteger selectedMealIndex=[self.tableView indexPathForCell:sender].row;
        singleMeal *selectedMeal=self.arrayFromFMDB[selectedMealIndex];
        UINavigationController *vc=segue.destinationViewController;
        singleMenuViewController *singleMealController=vc.viewControllers.lastObject;
        singleMealController.meal=selectedMeal;

    }
}

@end

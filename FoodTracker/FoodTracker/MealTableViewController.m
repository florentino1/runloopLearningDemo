//
//  MealTableViewController.m
//  FoodTracker
//
//  Created by 莫玄 on 2021/2/21.
//  Copyright © 2021 莫玄. All rights reserved.
//

#import "MealTableViewController.h"
#import "Meal.h"
#import "MealTableViewCell.h"
#import "MealViewController.h"

@interface MealTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *Meals;//用于存储当前数据源中存在多少资源；
@property (nonatomic,strong)NSURL *ArchiveURl;
@end

@implementation MealTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Meals=[[NSMutableArray alloc]init];
    NSURL *DocumentsDirectory=[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    self.ArchiveURl=[DocumentsDirectory URLByAppendingPathComponent:@"meals"];
    NSArray *savedMeals=[self loadMeals];
    if(savedMeals)
        [self.Meals addObjectsFromArray:savedMeals];
    else
    {
        [self loadSampleMeals];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
}
#pragma mark-NScoding
-(void)saveMeals//对self.Meals进行归档
{
    BOOL isSuccessfulSave=[NSKeyedArchiver archiveRootObject:self.Meals toFile:self.ArchiveURl.path];
    if(isSuccessfulSave)
    {
        NSLog(@"Meals Save successfully");
    }
    else
        NSLog(@"Meals save failed");
}
-(nullable NSArray *)loadMeals//对存储路径中的内容进行逆归档;
{
    NSString *path=self.ArchiveURl.path;
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if(array)
    {
        NSLog(@"unarchive successfully");
        return array;
    }
    else
        return NULL;

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.Meals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MealTableViewCell" forIndexPath:indexPath];
    NSUInteger index=indexPath.row;
    Meal *mealInTable=self.Meals[index];
    cell.namelabel.text=mealInTable->mealName;
    cell.photoImageView.image=mealInTable->mealPhoto;
  //  cell.ratingControl=[[RatingControl alloc]init];
    cell.ratingControl.rating=mealInTable->rating;
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.Meals  removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self saveMeals];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view

    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)loadSampleMeals
{
    UIImage *photo1=[UIImage imageNamed:@"Meal1"];
    UIImage *photo2=[UIImage imageNamed:@"Meal2"];
    UIImage *photo3=[UIImage imageNamed:@"Meal3"];

    Meal *meal1=[[Meal alloc]initWithMealName:@"Caprese Salad" mealPhoto:photo1 rating:4];
    if(meal1)
        [self.Meals addObject:meal1];
    else
        NSLog(@"Unable to instantiate meal1");
    Meal *meal2=[[Meal alloc]initWithMealName:@"Chicken and Potatoes" mealPhoto:photo2 rating:5];
    if(meal2)
        [self.Meals addObject:meal2];
    else
        NSLog(@"Unable to instantiate meal2");
    Meal *meal3=[[Meal alloc]initWithMealName:@"Pasta with Meatballs" mealPhoto:photo3 rating:3];
    if(meal3)
        [self.Meals addObject:meal3];
    else
        NSLog(@"Unable to instantiate meal3");
}

#pragma mark-actions
-(IBAction)unwindToMealList:(UIStoryboardSegue *)sender//松耦合形式的segue
{
    NSIndexPath *selectedIndexPath=[self.tableView indexPathForSelectedRow];
    MealViewController *sourceViewController=sender.sourceViewController;
    Meal *NewMeal=sourceViewController.NewMeal;
    NSMutableArray *indexPaths=[[NSMutableArray alloc]init];
    if(selectedIndexPath)//修改已经存在的单元格
    {
        self.Meals[selectedIndexPath.row]=NewMeal;
        [indexPaths addObject:selectedIndexPath];
        [self saveMeals];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    else//增加新的单元格
    {
        NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:self.Meals.count inSection:0];
        [indexPaths addObject:newIndexPath];
        [self.Meals addObject:NewMeal];
        [self saveMeals];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self.tableView endUpdates];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if([segue.identifier isEqualToString:@"AddItem"])
    {
        NSLog(@"add new meal");
    }
    else if([segue.identifier isEqualToString:@"showDetail"])
    {
        MealViewController *mealDetailViewController=segue.destinationViewController;
        MealTableViewCell *selecetedMealCell=sender;
        NSIndexPath *indexPath=[self.tableView indexPathForCell:selecetedMealCell];
        Meal *selectedMeal=self.Meals[indexPath.row];
        mealDetailViewController.NewMeal=selectedMeal;
    }
}
@end

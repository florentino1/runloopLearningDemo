//
//  leftViewController.m
//  myWhitePonyWeather
//
//  Created by 莫玄 on 2021/4/17.
//

#import "leftViewController.h"
#import "leftTableViewCell.h"
#import "locationViewController.h"

@interface leftViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (strong, nonatomic) IBOutlet UIView *containerView;
//@property (strong, nonatomic) IBOutlet UIImageView *userIcon;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *userIcon;
@property (strong,nonatomic)NSArray *cellImageArray;
@end

@implementation leftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   self.userIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"userIcon"]];
  //  self.tableView=[[UITableView alloc]init];

    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.cellImageArray=@[
        @{@"image":@"location_icon",@"text":@"地点管理"},
        @{@"image":@"chart_icon",@"text":@"天气趋势"},
        @{@"image":@"share_icon",@"text":@"分享天气"},
        @{@"image":@"theme_icon",@"text":@"主题定制"},
        @{@"image":@"activity_icon",@"text":@"精彩推荐"},
        @{@"image":@"feedback_icon",@"text":@"反馈建议"},
        @{@"image":@"settings_icon",@"text":@"系统设置"}
        ];
self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}
#pragma mark-tableView datasource delegate
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.cellImageArray count];
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    leftTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"leftTableViewCell" owner:self options:nil];
        cell = (leftTableViewCell *)[nibArr objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.cellImage setImage:[UIImage imageNamed:[self.cellImageArray objectAtIndex:indexPath.row][@"image"]]];
    NSString *string=[self.cellImageArray objectAtIndex:indexPath.row][@"text"];
    cell.cellLabel.text=string;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        locationViewController *lvc=[[locationViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:lvc];
        [self presentViewController:nav animated:TRUE completion:nil];
    });
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

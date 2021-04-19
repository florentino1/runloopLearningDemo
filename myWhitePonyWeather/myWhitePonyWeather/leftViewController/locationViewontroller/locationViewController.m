//
//  locationViewController.m
//  myWhitePonyWeather
//
//  Created by 莫玄 on 2021/4/19.
//

#import "locationViewController.h"
#import "DBManager.h"
#import "userInfo.h"
#import "location.h"

@interface locationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *locationTableView;
@property (strong,nonatomic)NSMutableArray *cityInfo;//来自于数据库的城市坐标信息;
//@property (strong,nonatomic)NSArray *cityDesc;//将表格分为两个区，一个热门城市，一个来自cityInfoFromDB；

@end

@implementation locationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"地点管理";
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;

    _locationTableView.delegate=self;
    _locationTableView.dataSource=self;
    [self initNavButton];

    _cityInfo=[[DBManager sharedDB] getAllLocations];


    //_cityDesc=@[@"当前定位：",@"全国热门城市："];

}
- (void)initNavButton{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20 , 44, 44)];
    button.showsTouchWhenHighlighted = YES;
    button.backgroundColor = [UIColor clearColor];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [button setImage:[UIImage imageNamed:@"back_button_image"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backPage:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (void)backPage:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark-UITableViewDelegate/datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 1;
    }
    else
        return _cityInfo.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        NSString *string=@"当前定位：";
        return string;
    }
    else
        return @"您关注的城市：";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"CELL_SYSTEM";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section==1) {
        userInfo *userLocation=[userInfo sharedUserInfo];
        cell.textLabel.text=userLocation.address;
    }
    else
    {
        NSUInteger index=indexPath.row;
        location *loc=_cityInfo[index];
        cell.textLabel.text=loc.address;
    }
    return cell;
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

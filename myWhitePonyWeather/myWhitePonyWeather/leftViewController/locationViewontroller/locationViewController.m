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
#import "AppDelegate.h"

@interface locationViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
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
    _searchBar.delegate=self;
    [self initNavButton];
    //_cityDesc=@[@"当前定位：",@"全国热门城市："];
}
-(void)viewWillAppear:(BOOL)animated
{
    _cityInfo=[[DBManager sharedDB] getAllLocations];
}
- (void)initNavButton{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20 , 44, 44)];
    button.showsTouchWhenHighlighted = YES;
    button.backgroundColor = [UIColor clearColor];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [button setImage:[UIImage imageNamed:@"back_button_image"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backPage:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, -20, 44, 44)];
    rightButton.backgroundColor=[UIColor clearColor];
    rightButton.showsTouchWhenHighlighted=YES;
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
   // [rightButton setImage:[UIImage imageNamed:@"theme_icon"] forState:UIControlStateNormal];
    [rightButton setTitle:@"new" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addNewCity) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
}
- (void)backPage:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)addNewCity
{
    [_searchBar becomeFirstResponder];

}
#pragma mark-searchBar delegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *string=self.searchBar.searchTextField.text;
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:string forKey:@"address"];
    [self beginSearch:dic];
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:true completion:^{
        AppDelegate *del=[[UIApplication sharedApplication] delegate];
        [del hideLeftViewController];
    }];
}
-(void)beginSearch:(NSMutableDictionary *)dic
{
    NSNotification *nt=[[NSNotification alloc]initWithName:@"search" object:nil userInfo:dic];
    NSNotificationCenter *defaultCenter=[NSNotificationCenter defaultCenter];
    [defaultCenter postNotification:nt];
    NSLog(@">>>开始进行地理位置反编码获取天气信息");
}
#pragma mark-UITableViewDelegate/datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0 ) {
        return 1;
    }
    else
        return _cityInfo.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_cityInfo.count==0)
        return 1;
    else
        return 2;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
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
    if (indexPath.section==0) {
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
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        return NO;
    else
        return YES;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        return NO;
    else
        return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section!=0)
    {
        if(editingStyle==UITableViewCellEditingStyleDelete)
        {
            location *loc=_cityInfo[indexPath.row];
            [_cityInfo removeObject:loc];
            [[DBManager sharedDB] deletLoctionWithAddress:loc.address latitude:loc.latitude longitude:loc.longitude];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if (indexPath.section==0) {
        userInfo *userDefaults=[userInfo sharedUserInfo];
        [dic setObject:userDefaults.latitude forKey:@"latitude"];
        [dic setObject:userDefaults.longitude forKey:@"longitude"];
        [dic setObject:userDefaults.address forKey:@"address"];
    }
    else
    {
        location *loc=_cityInfo[indexPath.row];
        [dic setObject:[NSNumber numberWithDouble:loc.latitude ] forKey:@"latitude"];
        [dic setObject:[NSNumber numberWithDouble:loc.longitude] forKey:@"longitude"];
        [dic setObject:loc.address forKey:@"address"];
    }
    NSNotification *nt=[NSNotification notificationWithName:@"tapAddress" object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter]postNotification:nt];
    [self dismissViewControllerAnimated:TRUE completion:^{
        AppDelegate *del=[[UIApplication sharedApplication] delegate];
        [del hideLeftViewController];
    }];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
@end

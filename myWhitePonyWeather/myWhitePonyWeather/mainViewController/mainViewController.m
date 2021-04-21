//
//  mainViewController.m
//  myWhitePonyWeather
//
//  Created by 莫玄 on 2021/4/18.
//

#import "mainViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "location.h"
#import "userInfo.h"
#import <AFNetworking.h>
#import "weather.h"
#import "DBManager.h"
#import "AppDelegate.h"

@interface mainViewController ()<CLLocationManagerDelegate>
@property  (strong,nonatomic)CLLocationManager *locationManager;
@property (strong,nonatomic)CLGeocoder *geoCoder;
@property (strong,nonatomic)location *backLocation;//通过GPS定位返回得到的location

@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initGPSComponent];
    self.backLocation=[[location alloc]init];
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCoordinateByAddress:) name:@"search" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(predelivery:) name:@"tapAddress" object:nil];

}
-(void)predelivery:(NSNotification *)notification
{
    NSDictionary *dic=notification.userInfo;
    CLLocationDegrees lat=[[dic objectForKey:@"latitude"] doubleValue];
    CLLocationDegrees lon=[[dic objectForKey:@"longitude"] doubleValue];
    NSString *address=[dic objectForKey:@"address"];
    self.backLocation.address=address;
    self.backLocation.latitude=lat;
    self.backLocation.longitude=lon;
    [self requestWeatherByLatitude:lat longitude:lon];
}
-(void)initUI
{
    NSLog(@">>>开始进行UI初始化");
    NSString *path=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"userDefaults"];
    NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:path];
    userInfo *userlocation=[userInfo sharedUserInfo];
    [userlocation updateFromDic:dic];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    [self initRefreshButton];
    [self initMoreButton];
/*  CLLocationDegrees latitude=[userlocation.latitude doubleValue];
    CLLocationDegrees longitude=[userlocation.longitude doubleValue];
    if((int)latitude==(int)self.backLocation.latitude && (int)longitude==(int)self.backLocation.longitude)
    {
        NSLog(@">>>当前定位地址为用户缓存地址");
        self.weatherLabel.text=@"";
        self.highlowtempretureLabel.text=@"";
    }
    else
    {
        NSLog(@"当前地址为用户新地址");
        self.weatherLabel.text=self.backLocation.address;
        self.highlowtempretureLabel.text=[NSString stringWithFormat:@"当前位置的经纬度为：%f %f",self.backLocation.latitude,self.backLocation.longitude];
    }
   */
}
-(void)updateUserDefault
{
    //判断是否更新用户默认的地址userInfo
    userInfo *userlocation=[userInfo sharedUserInfo];
    CLLocationDegrees latitude=[userlocation.latitude doubleValue];
    CLLocationDegrees longitude=[userlocation.longitude doubleValue];
    if(latitude==0 && longitude==0 )
    {
        NSLog(@">>>userDefaults 为0,进行初始化");
        [self updateCurrentLocationwithLatitude:self.backLocation.latitude longitude:self.backLocation.longitude];

    }
    else if((int)latitude==(int)self.backLocation.latitude && (int)longitude==(int)self.backLocation.longitude)
        NSLog(@">>>当前定位信息与用户默认地址相同，不更新userInfo");
    else
        NSLog(@">>>显示额外地点天气信息，不更新userDefaults");
   //     [self updateCurrentLocationwithLatitude:self.backLocation.latitude longitude:self.backLocation.longitude];
}
-(void)initRefreshButton
{
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    button.showsTouchWhenHighlighted=YES;
    button.backgroundColor=[UIColor clearColor];
    [button setTitle:@"refresh" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    [button addTarget:self action:@selector(fresh) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)initMoreButton
{
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [button setImage:[UIImage imageNamed:@"settings_icon"] forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted=YES;
    button.backgroundColor=[UIColor clearColor];
    button.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    [button addTarget:self action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)showLeftView
{
    AppDelegate *del=[[UIApplication sharedApplication] delegate];
    [del showLeftViewController];
}
-(void)fresh
{
    [self.locationManager startUpdatingLocation];
    self.navigationItem.title=@"正在进行定位";
}
-(void)freshUIWithWeather:(weather *)currentWeather
{
    [self updateUserDefault];
    NSLog(@"刷新UI");
    self.weatherLabel.text=currentWeather.currentTempreture;
    self.highlowtempretureLabel.text=currentWeather.highAndLowTempreture;
    self.mismoLabel.text=currentWeather.mismo;
    self.updateTimeLabel.text=currentWeather.updateTime;
    self.navigationItem.title=self.backLocation.address;
}
#pragma mark-location
-(void)initGPSComponent
{
    NSLog(@">>>开始进行GPS模块初始化");
    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    CLLocationDistance distance=10.0;
    self.locationManager.distanceFilter=distance;

    self.geoCoder=[[CLGeocoder alloc]init];

    if(![CLLocationManager locationServicesEnabled])
    {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"请先打开定位功能" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:true completion:nil];
    }
}
-(void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager
{
    CLAuthorizationStatus status=manager.authorizationStatus;
    NSLog(@">>auth status:%d",status);
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            //用户没有同意，需要请求定位
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            //用户同意定位。开始定位

            //[self configLocationManager];
            //启动跟踪定位
            [self.locationManager startUpdatingLocation];
            NSLog(@">>>开始进行定位");
            self.navigationItem.title=@"正在进行定位...";
            break;
        }

        default:
            break;
    }

}
//已通过定位服务获取到经纬度信息
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location=[locations firstObject];
    CLLocationCoordinate2D coordinate=location.coordinate;
    NSLog(@"定位成功! >>> 当前位置经度：%f,纬度：%f",coordinate.longitude,coordinate.latitude);
    [self.locationManager stopUpdatingLocation];
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
}
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
   // CLPlacemark __block *p=nil;
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks,NSError *error){
        if(error)
        {
            NSLog(@">>>地理位置反编码失败");
            NSLog(@"%@",[error description]);
            return;
        }
        else
        {
            CLPlacemark *placemark=[placemarks firstObject];
            if(placemark)
                NSLog(@">>>已获取经纬度所标识位置信息");
            //p=placemark;
            [self updateBackLocationwithLatitude:latitude longitude:longitude address:placemark.locality];
            [self requestWeatherByLatitude:latitude longitude:longitude];
        }
    }];
    //return p;
}
//通过地名获取经纬度坐标
-(void)getCoordinateByAddress:(NSNotification *)notification
{
    NSDictionary *userInfo=notification.userInfo;
    [_geoCoder geocodeAddressString:[userInfo objectForKey:@"address"] completionHandler:^(NSArray * placemarks,NSError *error){
        CLPlacemark *placemark=[placemarks firstObject];
        if(placemark==nil)
        {
            NSLog(@">>>地理位置反编译失败");
            return;
        }
        CLLocation *loc=placemark.location;
        CLLocationDegrees lat=loc.coordinate.latitude;
        CLLocationDegrees lon=loc.coordinate.longitude;
        NSString *name=placemark.locality;
        self.backLocation.latitude=lat;
        self.backLocation.longitude=lon;
        self.backLocation.address=name;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[DBManager sharedDB]insertLocationWithAddress:name latitude:lat longitude:lon];
        });
        [self requestWeatherByLatitude:lat longitude:lon];
    }];
}
//更新Userinfo中的当前位置信息；
-(void)updateCurrentLocationwithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    userInfo *userlocation=[userInfo sharedUserInfo];
    NSString *path=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"userDefaults"];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    userlocation.latitude=[NSNumber numberWithDouble:latitude];
    userlocation.longitude=[NSNumber numberWithDouble:longitude];
    userlocation.address=self.backLocation.address;
    [dic setObject:userlocation.address forKey:@"address"];
    [dic setObject:userlocation.latitude forKey:@"latitude"];
    [dic setObject:userlocation.longitude forKey:@"longitude"];
    [dic writeToFile:path atomically:YES];
        NSLog(@">>>已更新用户缓存地址");
}
-(void)updateBackLocationwithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude address:(NSString *)address
{
    if (!self.backLocation) {
        location *newLocation= [[location alloc]initWithLat:latitude lon:longitude address:address];
        self.backLocation=newLocation;
    }
    else
    {
        [self.backLocation updateWithLat:latitude lon:longitude address:address];
    }
}

#pragma mark-请求服务器获取当前位置的天气信息
-(void)requestWeatherByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    NSString *mUrl = [NSString stringWithFormat:@"%@weather?lat=%f&lon=%f&units=metric&appid=%@",@"http://api.openweathermap.org/data/2.5/", latitude, longitude, @"0b0b4a71f90a8dd37c74fe8f38af9f3d"];

    NSLog(@">>>请求当前地点天气情况,请求地址：%@", mUrl);
    NSURL *url=[NSURL URLWithString:mUrl];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *defaultConfig=[NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager=[[AFURLSessionManager alloc]initWithSessionConfiguration:defaultConfig];
    NSURLSessionDownloadTask *task=[manager downloadTaskWithRequest:request
                                                           progress:nil
                                                        destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *stringName=[NSString stringWithFormat:@"%f+%f",latitude,longitude];
        NSString *filePathString=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:stringName];
        NSLog(@"%@",filePathString);
        return [NSURL fileURLWithPath:filePathString];
    }
                                                  completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        NSData *data=[NSData dataWithContentsOfURL:filePath options:NSDataReadingMappedIfSafe error:&error];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:&error];
        if(dic)
            NSLog(@">>>请求当地的天气信息已获取");
        [self initWithcurrentweatherInfo:dic];
    }];
    [task resume];
}
-(void)initWithcurrentweatherInfo:(NSDictionary *)dic
{
    NSDictionary *main=[dic objectForKey:@"main"];
    NSString *currentTem=[NSString stringWithFormat:@"当前：%@° 体感：%@°",[main objectForKey:@"temp"],[main objectForKey:@"feels_like"]];
    NSString *hltemp=[NSString stringWithFormat:@"最高：%@° 最低：%@°",[main objectForKey:@"temp_max"],[main objectForKey:@"temp_min"]];
    NSString *mismo=[NSString stringWithFormat:@"大气压：%@ pa 湿度：%@",[main objectForKey:@"pressure"],[main objectForKey:@"humidity"]];
    NSDate *time=[NSDate date];
    NSString *timenow=[NSString stringWithFormat:@"%@",time];
    weather *currentWeather=[[weather alloc]initWithCurrentTem:currentTem hLtem:hltemp mismo:mismo updateTime:timenow];
    [self freshUIWithWeather:currentWeather];
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

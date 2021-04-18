//
//  mainViewController.m
//  myWhitePonyWeather
//
//  Created by 莫玄 on 2021/4/18.
//

#import "mainViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "location.h"

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

}
-(void)initUI
{
    NSLog(@">>>开始进行UI初始化");
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    CLLocationDegrees latitude=[userDefault doubleForKey:@"latitude"];
    CLLocationDegrees longitude=[userDefault doubleForKey:@"longitude"];
    if((int)latitude==(int)self.backLocation.latitude && (int)longitude==(int)self.backLocation.longitude)
    {
        NSLog(@">>>当前定位地址为用户缓存地址");
        self.weatherLabel.text=[userDefault objectForKey:@"address"];
        self.highlowtempretureLabel.text=[NSString stringWithFormat:@"当前位置的经纬度为：%f %f",latitude,longitude];
    }
    else
    {
        NSLog(@"当前地址为用户新地址");
        self.weatherLabel.text=self.backLocation.address;
        self.highlowtempretureLabel.text=[NSString stringWithFormat:@"当前位置的经纬度为：%f %f",self.backLocation.latitude,self.backLocation.longitude];
    }
}
-(void)freshUI
{
    NSLog(@"用新地址刷新UI");
    self.weatherLabel.text=self.backLocation.address;
    self.highlowtempretureLabel.text=[NSString stringWithFormat:@"当前位置的经纬度为：%f %f",self.backLocation.latitude,self.backLocation.longitude];
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
        }
    }];
    //return p;
}
//更新NSUserDefault中的当前位置信息；
-(void)updateCurrentLocationwithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setDouble:longitude forKey:@"longitude"];
    [userDefault setDouble:latitude forKey:@"latitude"];
    [userDefault setObject:self.backLocation.address forKey:@"address"];
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
    [self freshUI];
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

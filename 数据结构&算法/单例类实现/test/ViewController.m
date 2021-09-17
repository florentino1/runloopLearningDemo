//
//  ViewController.m
//  test
//
//  Created by 莫玄 on 2021/8/21.
//

#import "ViewController.h"
#import "singleton.h"
#import "singleton2.h"
@interface ViewController ()

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
    printf("5\n");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    printf("6\n");
    singleton *a=[singleton sharedSingleton];
    NSLog(@"%@\n",a.name);
}


@end

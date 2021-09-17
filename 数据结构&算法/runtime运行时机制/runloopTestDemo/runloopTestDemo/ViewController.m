//
//  ViewController.m
//  runloopTestDemo
//
//  Created by 莫玄 on 2021/9/16.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *thirdThreadButton;
@property (weak, nonatomic) IBOutlet UIButton *mybutton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (IBAction)startRunLoop:(UIButton *)sender {
    AppDelegate *del=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *string=@"hello runloop";
    [del.command addObject:string];
    [del commandBufferChanged];
}
- (IBAction)sendmessagetothirdthread:(UIButton *)sender {
    AppDelegate *del=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [del sendToThirdThead];
}


@end

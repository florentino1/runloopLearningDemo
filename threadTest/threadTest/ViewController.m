//
//  ViewController.m
//  threadTest
//
//  Created by 莫玄 on 2021/5/29.
//

#import "ViewController.h"
#import "RLAppDelegate.h"

@interface ViewController ()<UITextFieldDelegate>
@property (strong,nonatomic)UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textField=[[UITextField alloc]initWithFrame:CGRectMake(44, 44, 150, 60)];
    self.textField.backgroundColor=[UIColor greenColor];
    self.textField.delegate=self;
    [self.view addSubview:self.textField];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark-textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   // [textField becomeFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *command=textField.text;
    RLAppDelegate *del=[RLAppDelegate sharedAppDelegate];
    [del callClientCommand:command];
    return YES;
}
@end

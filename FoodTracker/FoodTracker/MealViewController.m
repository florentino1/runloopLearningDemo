//
//  ViewController.m
//  FoodTracker
//
//  Created by 莫玄 on 2021/1/29.
//  Copyright © 2021 莫玄. All rights reserved.
//

#import "MealViewController.h"
#import "RatingControl.h"


@interface MealViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *MealNameTextField;
//@property (weak, nonatomic) IBOutlet UIButton *DefaultButton;
//@property (weak, nonatomic) IBOutlet UILabel *MealNameLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *MealImage;
@property (weak, nonatomic) IBOutlet RatingControl *RatingControlStackView;
@end

@implementation MealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  /*  if(self.MealNameTextField.text.length==0)
    {
        self.MealNameLabel.text=@"Meal Name";
    }
    else
    {
        self.MealNameLabel.text=self.MealNameTextField.text;
    }*/
    self.MealNameTextField.delegate=self;
    if(self.NewMeal!=nil)//self.NewMeal在没有showDetail的segue进行数据传入时为nil；
    {
        self.navigationItem.title=self.NewMeal->mealName;
        self.MealNameTextField.text=self.NewMeal->mealName;
        self.MealImage.image=self.NewMeal->mealPhoto;
        self.RatingControlStackView.rating=self.NewMeal->rating;
    }
    [self updateSaveButton];
}
- (IBAction)Cancel:(UIBarButtonItem *)sender {
    BOOL isPresentingInAddMealMode=[self.presentingViewController isKindOfClass:[UINavigationController class]];
    //新增meal时进行退出，此时为modal模式进行显示
    if (isPresentingInAddMealMode) {
        [self dismissViewControllerAnimated:TRUE completion:nil];
    }
    //编辑模式中进行退出，此时以新场景scene的形式呈现视图
    else
    {
        UINavigationController *owningNavigationController=self.navigationController;
        if(owningNavigationController)
        {
            [owningNavigationController popViewControllerAnimated:true];
        }
    }

}
/*- (IBAction)DefaultTheMealNameLabel:(id)sender {
    if(self.MealNameTextField.text.length!=0)
    {
        self.MealNameLabel.text=self.MealNameTextField.text;
        self.MealNameTextField.text=@"";
    }
    else
    {
        self.MealNameLabel.text=@"Meal Name";
    }
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"APP已经开始启动了哦！" message:@"你现在可以做的就是想好自己的菜名。。。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"想好了" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *actionNO=[UIAlertAction actionWithTitle:@"我还没有想好" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:actionNO];
    [controller addAction:actionOK];
    [self presentViewController:controller animated:true completion:nil];

}*/
- (IBAction)saveNewMeal:(id)sender {

}
- (IBAction)selectImageFromPhotoLibrary:(UITapGestureRecognizer *)sender {
    [self.MealNameTextField resignFirstResponder];
    UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]init];
    imagePickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate=self;
    [self presentViewController:imagePickerController animated:true completion:nil];
}

#pragma mark-UITextFieldDelegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//在文字编辑栏为空时禁用save按钮；
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.saveButton setEnabled:false];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateSaveButton];
    self.navigationItem.title=self.MealNameTextField.text;
}
-(void)updateSaveButton
{
    NSString *text=self.MealNameTextField.text;
    if(text.length==0)
        [self.saveButton setEnabled:false];
    else
        [self.saveButton setEnabled:TRUE];
}
#pragma mark-UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    UIImage *imageSelected=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.MealImage.image=imageSelected;
    [self dismissViewControllerAnimated:true completion:nil];
}
#pragma mark-Naviation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
   /* if(!([segue.identifier isEqualToString:@"AddNewMeal"]&& sender==self.saveButton))
    {
        NSLog(@"The save button was not pressed ,cancelling");
        return;
    }
    else
    {*/
        NSString *name=self.MealNameTextField.text;
        UIImage *photo=self.MealImage.image;
        NSUInteger rating=self.RatingControlStackView.rating;
        self.NewMeal=[[Meal alloc]initWithMealName:name mealPhoto:photo rating:rating];
    //}
}
@end

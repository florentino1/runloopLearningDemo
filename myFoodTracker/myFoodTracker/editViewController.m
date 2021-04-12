//
//  ViewController.m
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/10.
//

#import "editViewController.h"
#import "ratingController.h"
#import "singleMeal.h"
#import "DBManager.h"

@interface editViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textfield;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet ratingController *ratingContoller;
@property (assign,nonatomic)NSUInteger saveFlag;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation editViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.saveFlag=0;
    self.textfield.delegate=self;
    if(self.prepredMeal!=nil)
    {
        self.textfield.text=self.prepredMeal.mealName;
        self.imageView.image=self.prepredMeal.mealPhoto;
        self.ratingContoller.currentRating=self.prepredMeal.mealRating;
        self.tem=[[singleMeal alloc]initWithName:self.textfield.text Photo:self.imageView.image andRating:self.ratingContoller.currentRating];
    }
    else
    {
        self.tem=[[singleMeal alloc]init];
        self.textfield.text=@"请输入菜品名称";
        self.imageView.image=[UIImage imageNamed:@"placeholderPic"];
        self.ratingContoller.currentRating=0;
    }
    [self addObserver:self forKeyPath:@"self.ratingContoller.currentRating" options:NSKeyValueObservingOptionNew context:nil];
    [self saveButtonStatusTest];
}
- (IBAction)selectNewMealImage:(UITapGestureRecognizer *)sender {
    [self.textfield resignFirstResponder];
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate=self;
    [self presentViewController:imagePicker animated:TRUE completion:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"self.ratingContoller.currentRating"])
    {
        self.tem.mealRating=self.ratingContoller.currentRating;
        self.saveFlag+=1;
        [self saveButtonStatusTest];
    }
}
- (IBAction)save:(UIBarButtonItem *)sender {
    DBManager *manager=[DBManager sharedDBManager];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSNotificationCenter *notification=[NSNotificationCenter defaultCenter];
        NSString *notificationName=[NSString stringWithFormat:@"The saveButton has been pressed"];
        NSNotification *nf=[NSNotification notificationWithName:notificationName object:nil];
        [notification postNotification:nf];
    });
    //插入新的singleMeal
    if(self.prepredMeal==nil)
        [manager insertMealName:self.tem.mealName mealRating:self.tem.mealRating mealPhoto:self.tem.mealPhoto];
    //修改已有的singleMeal 需要更新tableviewcell
    else
    {
        [manager deleteMeal:self.prepredMeal.mealName];
        [manager insertMealName:self.tem.mealName mealRating:self.tem.mealRating mealPhoto:self.tem.mealPhoto];
    }
    self.saveFlag=0;
    [self saveButtonStatusTest];
   // [self dismissViewControllerAnimated:TRUE completion:nil];
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
   // [self dismissViewControllerAnimated:TRUE completion:nil];
}
#pragma mark-textField delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
   if (![self.textfield.text isEqualToString:self.prepredMeal.mealName])
        self.saveFlag+=1;
    self.tem.mealName=self.textfield.text;
    [self saveButtonStatusTest];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textfield resignFirstResponder];
    return TRUE;
}
-(void)saveButtonStatusTest
{
    if(self.saveFlag<=0)
        self.saveButton.enabled=NO;
    else
    {
        [self.saveButton setEnabled:TRUE];
        self.saveFlag=0;
    }

}
#pragma mark-UIImagePickerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    UIImage *imageSelected=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image=imageSelected;
    self.tem.mealPhoto=imageSelected;
    self.saveFlag+=1;
    [self saveButtonStatusTest];
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

@end

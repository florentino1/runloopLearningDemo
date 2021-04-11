//
//  dataBase.h
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject
+(instancetype)sharedDBManager;
-(void)initDB;
-(void)creatTable;
-(void)insertMealName:(NSString *)name mealRating:(NSUInteger)rating mealPhoto:(UIImage *)photo;
-(void)deleteMeal:(NSString *)mealName;
-(NSMutableArray *)getAll;
@end

NS_ASSUME_NONNULL_END

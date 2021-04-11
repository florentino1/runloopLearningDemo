//
//  FoodTrackerTests.m
//  FoodTrackerTests
//
//  Created by 莫玄 on 2021/1/29.
//  Copyright © 2021 莫玄. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Meal.h"


@interface FoodTrackerTests : XCTestCase

@end

@implementation FoodTrackerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


-(void)test001Test{
    Meal *meal1=[[Meal alloc]initWithMealName:@"okfine" mealPhoto:nil rating:4];
    XCTAssertNotNil(meal1);
}
-(void)test002Test{
    Meal *meal2=[[Meal alloc]initWithMealName:NULL mealPhoto:NULL rating:3];
    XCTAssertNil(meal2);
}
@end

//
//  ViewController.m
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import "ViewController.h"
#import "UserObject.h"
//#import "WXCardModelKit.h"
#import "NSObject+WXCardKeyValue.h"
//#import "NSObject+MJKeyValue.h"
@interface ViewController ()
@property (nonatomic,strong) UserObject *userObject;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dict = @{
                           @"name" : @"Jack",
                           @"icon" : @"lufy.png",
                           @"age" : @20,
                           @"height" : @"1.55",
                           @"money" : @100.9,
                           @"sex" : @(SexFemale)
                           };
    
     self.userObject  = [UserObject wx_objectWithKeyValues:dict];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"UserObject:%@",self.userObject);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

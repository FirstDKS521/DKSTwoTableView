//
//  RootViewController.m
//  DKSTwoTableView
//
//  Created by aDu on 2018/3/21.
//  Copyright © 2018年 DuKaiShun. All rights reserved.
//

#import "RootViewController.h"
#import "DKSTableController.h"
#import "DKSTabCollController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联动";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark ====== 两个TableView联动方法一 ======
- (IBAction)twoTableView:(id)sender {
    DKSTableController *tabVC = [DKSTableController new];
    [self.navigationController pushViewController:tabVC animated:YES];
}

#pragma mark ====== TableView与CollectionView联动 ======
- (IBAction)collectionAndTable:(id)sender {
    DKSTabCollController *tabVC = [DKSTabCollController new];
    [self.navigationController pushViewController:tabVC animated:YES];
}

@end

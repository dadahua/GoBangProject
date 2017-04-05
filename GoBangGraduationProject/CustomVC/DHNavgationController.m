//
//  DHNavgationController.m
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/5/30.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "DHNavgationController.h"

@interface DHNavgationController ()

@end

@implementation DHNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor brownColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
}
@end

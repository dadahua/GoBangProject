//
//  ViewController.m
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/5/10.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "ViewController.h"
#import "ChessBoardView.h"
#import "DHMCTool.h"
#import "PersonViewController.h"

@interface ViewController ()<UIAlertViewDelegate,DHMCToolDelegate> {
    
    
}
@property (nonatomic, strong) DHMCTool *mcTool;

@end

@implementation ViewController

- (DHMCTool *)mcTool {
    
    if (!_mcTool) {
        _mcTool = [DHMCTool tool];
        _mcTool.delegate = self;
    }
    return _mcTool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  测试
     */
    for (int i = 0; i < -1; i ++) {
        NSLog(@"i == %d",i);
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (IBAction)twoPersonClick:(UIButton *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择以下场景" message:@"蓝牙对战要先打开蓝牙，或者同一局域网内" delegate:sender cancelButtonTitle:@"稳一手" otherButtonTitles:@"同屏对战",@"蓝牙对战", nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"ppSegue" sender:@1];
    } else if (buttonIndex == 2) {
        
        self.mcTool.browser = [self.mcTool browser];
        [self presentViewController:self.mcTool.browser animated:YES completion:^{
            
        }];
    }
}

#pragma mark - DHMCToolDelegate
- (void)browserControllerCancleAndDone {
    
    [self performSegueWithIdentifier:@"ppSegue" sender:@2];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ppSegue"]) {
        PersonViewController *p = segue.destinationViewController;
        p.isBlueTooth = ([sender integerValue] == 1 ? NO:YES);
    }
}

@end

//
//  DHMenuVC.m
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/5/30.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "DHMenuVC.h"
#import "LLSwitch.h"
#import "DHNSUserdefault.h"

@interface DHMenuVC ()<LLSwitchDelegate>

@end

@implementation DHMenuVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:({
        UIImageView *imagView = [[UIImageView alloc] initWithFrame:self.view.frame];
        imagView.image = [UIImage imageNamed:@"bottom.jpg"];
        imagView;

    })];
    for (int i = 0; i < 3; i ++) {
        [self.view addSubview:({
            UILabel *lab = [[UILabel alloc] init];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.backgroundColor = [UIColor brownColor];
            lab.layer.cornerRadius = 5;
            lab.layer.masksToBounds = YES;
            lab.frame = CGRectMake(SCREEN_W / 2.0 - 100, 80 + 60 * i, 80, 40);
            lab.text = (i == 0 ? @"白旗先手":(i == 1 ? @"玩家先手":@"开关声音"));
            lab;
        })];
        [self.view addSubview:({
            CGRect frame = CGRectMake(SCREEN_W / 2.0 + 20, 85 + i * 60, 60, 30);
            LLSwitch *swith = [[LLSwitch alloc] initWithFrame:frame];
            swith.delegate = self;
            swith.tag = 100 + i;
            swith.on = (i == 0 ? [DHNSUserdefault getTheIsWhiteSente]:
                        (i == 1 ? [DHNSUserdefault getTheIsPlayerSente]:
                         [DHNSUserdefault getTheIsSounds]));
            swith.onColor = [UIColor brownColor];
            swith;
        })];
    }
}


- (void)didTapLLSwitch:(LLSwitch *)llSwitch {
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    LLSwitch *whiteSwith = [self.view viewWithTag:100];
//    LLSwitch *AISwith = [self.view viewWithTag:101];
//    if (llSwitch == whiteSwith) {
//        [defaults setBool:YES forKey:IsWhiteSente];
//    } else if (llSwitch == AISwith) {
//        [defaults setBool:YES forKey:IsPlayerSente];
//    } else {
//        [defaults setBool:YES forKey:IsSounds];
//    }
}


- (void)animationDidStopForLLSwitch:(LLSwitch *)llSwitch {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    LLSwitch *whiteSwith = [self.view viewWithTag:100];
    LLSwitch *AISwith = [self.view viewWithTag:101];
    if (llSwitch == whiteSwith) {
        [defaults setBool:llSwitch.on forKey:IsWhiteSente];
    } else if (llSwitch == AISwith) {
        [defaults setBool:llSwitch.on forKey:IsPlayerSente];
    } else {
        [defaults setBool:llSwitch.on forKey:IsSounds];
    }
}

@end

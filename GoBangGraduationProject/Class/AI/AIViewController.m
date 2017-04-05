//
//  AIViewController.m
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/5/30.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "AIViewController.h"
#import "HBPlaySoundUtil.h"
#import "ChessBoardView.h"
#import "SFDraggableDialogView.h"
#import "DHNSUserdefault.h"

@interface AIViewController ()<SFDraggableDialogViewDelegate> {
    
    __weak IBOutlet UIImageView *backgroundImgView;
    ChessBoardView *boardView;
    __weak IBOutlet UIButton *soundBtn;
}

@end

@implementation AIViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AIWhoWinNotify object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     通知
     */
    soundBtn.selected = ![DHNSUserdefault getTheIsSounds];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whoWin:) name:AIWhoWinNotify object:nil];
    boardView = [[ChessBoardView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_W, SCREEN_W)];
    backgroundImgView.userInteractionEnabled = YES;
    [backgroundImgView addSubview:boardView];
}
- (IBAction)startAgainClick:(UIButton *)sender {
    
    [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"start.wav"] play];
    [boardView reset];
}
- (IBAction)undoClick:(UIButton *)sender {
    
    [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"regret.wav"] play];
    [boardView undo];
}
- (IBAction)soundClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [DHNSUserdefault setupIsSounds:!sender.isSelected];
}

- (void)whoWin:(NSNotification *)notify {
    
    OccupyType type = [notify.userInfo[@"type"] integerValue];
    SFDraggableDialogView *v = [[SFDraggableDialogView alloc] init];
    if (type == OccupyTypeAI) {
        NSLog(@"收到通知，AI赢了");
        v = [SFDraggableDialogView drgViewWith:self titleText:@"游戏结束了" photo:[UIImage imageNamed:@"lostPic.jpg"] message:@"电脑都搞不赢"];
        v.delegate = self;
    } else if (type == OccupyTypeUser) {
        NSLog(@"收到通知，你赢了");
        v = [SFDraggableDialogView drgViewWith:self titleText:@"游戏结束了" photo:[UIImage imageNamed:@"winPic.png"] message:@"诶吆，不错了"];
        v.delegate = self;
    }
    
    [self.view addSubview:v];
}

- (void)draggableDialogView:(SFDraggableDialogView *)dialogView didPressFirstButton:(UIButton *)firstButton {
    
    [boardView reset];
    [dialogView dismissWithDrop:YES];
}
@end

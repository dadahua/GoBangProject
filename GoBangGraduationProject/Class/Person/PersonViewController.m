//
//  PersonViewController.m
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/5/30.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "PersonViewController.h"
#import "DHPPChessBoardView.h"
#import "DHMCTool.h"
#import "HBPlaySoundUtil.h"
#import "DHNSUserdefault.h"
#import "SFDraggableDialogView.h"

@interface PersonViewController ()<DHPPChessDelegate,UIAlertViewDelegate,DHMCToolDelegate,SFDraggableDialogViewDelegate>{
    
    __weak IBOutlet UIImageView *bgImgView;
    __weak IBOutlet UIButton *soundBtn;
}

@property (nonatomic, strong) DHPPChessBoardView *chessView;
@property (nonatomic, strong) DHMCTool *mcTool;

@end

@implementation PersonViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PPWhoWinNotify object:nil];
}

- (DHMCTool *)mcTool {
    
    if (!_mcTool) {
        _mcTool = [DHMCTool tool];
        _mcTool.delegate = self;
    }
    return _mcTool;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.isBlueTooth) {
        self.mcTool.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [bgImgView addSubview:({
        self.chessView = [[DHPPChessBoardView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_W, SCREEN_W)];
        self.chessView.isBlueTooth = self.isBlueTooth;
        self.chessView.delegate = self;
        self.chessView.isAbleClick = YES;
        self.chessView;
    })];
    [self.view sendSubviewToBack:bgImgView];
    bgImgView.userInteractionEnabled = YES;
    soundBtn.selected = ![DHNSUserdefault getTheIsSounds];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whoWinWith:) name:PPWhoWinNotify object:nil];
}
- (IBAction)resetClick:(UIButton *)sender {
//    if (!self.isBlueTooth) {
        [self.chessView reset];
//    }
}
- (IBAction)undoClick:(UIButton *)sender {
    
    if (!self.isBlueTooth) {
        [self.chessView undo];
    } else {
        /**
         *  你下完了后
         */
        if (!self.chessView.isAbleClick) {
            [self.mcTool sendMessage:@"undo" error:nil];
        } else if (self.chessView.isAbleClick) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"你下棋了后才能马上点击悔棋 " delegate:nil cancelButtonTitle:@"明白" otherButtonTitles: nil];
            [alert show];
        }
    }
}
- (IBAction)soundsClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [DHNSUserdefault setupIsSounds:!sender.isSelected];
}
- (IBAction)quiklyClick:(UIButton *)sender {
    
    if (self.isBlueTooth) {
        [self.mcTool sendMessage:@"quikly" error:nil];
    } else {
        [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"quikly.wav"] play];
    }
}

#pragma mark - DHMCToolDelegate
- (void)session:(MCSession *)session didReceiveString:(NSString *)str fromPeer:(MCPeerID *)peer {
    
    NSLog(@"我收到的数据是:%@",str);
    /**
     *  棋子
     */
    if (str.length == 9 && ([[str substringToIndex:5] isEqualToString:@"black"] || [[str substringToIndex:5] isEqualToString:@"white"])) {
        // 1.判断黑白棋
        BOOL isBlack;
        NSInteger x,y;
        isBlack = [[str substringToIndex:5] isEqualToString:@"black"] ? YES : NO;
        x = [[str substringWithRange:NSMakeRange(5, 2)] integerValue];
        y = [[str substringWithRange:NSMakeRange(7, 2)] integerValue];
        [self.chessView addChessWithX:x y:y isBlack:isBlack type:OccupyTypeAI];
        self.chessView.isAbleClick = YES;
    }
    if ([str isEqualToString:@"quikly"]) {
        [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"quikly.wav"] play];
    }
    if ([str isEqualToString:@"undo"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"对方想悔棋，是否同意" delegate:self cancelButtonTitle:@"没门" otherButtonTitles:@"同意", nil];
        [alert show];
        self.chessView.isAbleClick = NO;
    }
    if ([str isEqualToString:@"sureUndo"]) {
        [self.chessView undo];
        self.chessView.isAbleClick = YES;
    }
    if ([str isEqualToString:@"dontUndo"]) {
        self.chessView.isAbleClick = NO;
    }
    
    
}
- (void)session:(MCSession *)session didChangeState:(MCSessionState)state fromPeer:(MCPeerID *)peer {
    
    
}

#pragma mark - DHPPChessDelegate
- (void)touchThePoint:(DHPoint *)point isWhite:(BOOL)isWhiteChess {
    
    if (!self.isBlueTooth) {
        return;
    }
    NSString *chessType = isWhiteChess ? @"white" : @"black";
    NSMutableString *dataString = [NSMutableString stringWithFormat:@"%@%02ld%02ld",chessType,point.x,point.y];
    NSError *error;
    [self.mcTool sendMessage:dataString error:error];
    self.chessView.isAbleClick = NO;
    if (error) {
        NSLog(@"发送消息错误%@",[error localizedDescription]);
    }
}

#pragma mark notify
- (void)whoWinWith:(NSNotification *)notify {
    
    OccupyType type = [notify.userInfo[@"type"] integerValue];
    switch (type) {
        case OccupyTypeUser:
        {
            SFDraggableDialogView *v = [SFDraggableDialogView drgViewWith:self titleText:@"你赢了" photo:[UIImage imageNamed:@"winPic.jpg"] message:@"路还长，莫骄傲"];
            v.delegate = self;
            [self.view addSubview:v];
        }
            break;
        case OccupyTypeAI:
        {
            SFDraggableDialogView *v = [SFDraggableDialogView drgViewWith:self titleText:@"你输了" photo:[UIImage imageNamed:@"lostPic.jpg"] message:@"哪里跌倒那里爬起"];
            v.delegate = self;
            [self.view addSubview:v];

        }
            break;
        case OccupyTypeWhite:
        {
            SFDraggableDialogView *v = [SFDraggableDialogView drgViewWith:self titleText:@"白棋赢了" photo:[UIImage imageNamed:@"winPic.jpg"] message:@"路还长，莫骄傲"];
            v.delegate = self;
            [self.view addSubview:v];
        }
            break;
        case OccupyTypeBlack:
        {
            SFDraggableDialogView *v = [SFDraggableDialogView drgViewWith:self titleText:@"黑棋赢了" photo:[UIImage imageNamed:@"winPic.jpg"] message:@"路还长，莫骄傲"];
            v.delegate = self;
            [self.view addSubview:v];
        }
            break;
            
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self.mcTool sendMessage:@"dontUndo" error:nil];
        self.chessView.isAbleClick = YES;
    } else {
        [self.chessView undo];
        [self.mcTool sendMessage:@"sureUndo" error:nil];
        self.chessView.isAbleClick = NO;
    }
}

- (void)draggableDialogView:(SFDraggableDialogView *)dialogView didPressFirstButton:(UIButton *)firstButton {
    
    self.view.userInteractionEnabled = YES;
    self.chessView.isAbleClick = YES;
    [self.chessView reset];
    [dialogView dismissWithDrop:YES];
}
@end

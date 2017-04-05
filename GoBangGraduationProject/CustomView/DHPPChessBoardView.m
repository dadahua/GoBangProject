//
//  DHPPChessBoardView.m
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/6/1.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "DHPPChessBoardView.h"
#import "DHGobangTool.h"
#import "DHNSUserdefault.h"
#import "HBPlaySoundUtil.h"


@interface DHPPChessBoardView () {
    
    
}
@property (nonatomic, strong) NSMutableArray *places; //记录所有位置的棋盘
@property (nonatomic, strong) NSMutableArray *totalChess; //记录所有棋子
@property (nonatomic, assign) BOOL isWhiteChess; //是否该白旗落子

@end

@implementation DHPPChessBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addLines];
        [self initilizeData];
    }
    return self;
}

- (void)addLines {
    
    for (int i = 0; i < DHBoardSize + 2; i ++) {
        CALayer *hLayer = [CALayer layer];
        hLayer.frame = CGRectMake(0, i * SCREEN_W / (DHBoardSize + 1), SCREEN_W, 0.5);
        hLayer.backgroundColor = [UIColor blackColor].CGColor;
        
        CALayer *vLayer = [CALayer layer];
        vLayer.frame = CGRectMake(i * SCREEN_W / (DHBoardSize + 1), 0, 0.5, SCREEN_W);
        vLayer.backgroundColor = [UIColor blackColor].CGColor;
        
        [self.layer addSublayer:hLayer];
        [self.layer addSublayer:vLayer];
    }
}

- (void)initilizeData {
    
    self.places = [NSMutableArray array];
    self.totalChess = [NSMutableArray array];
    
    for (int i = 0; i < DHBoardSize; i ++) {
        NSMutableArray *horArr = [NSMutableArray array]; //横向
        for (int j = 0; j < DHBoardSize; j ++) {
            [horArr addObject:@(OccupyTypeEmpty)]; //竖向
        }
        [self.places addObject:horArr];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    DHPoint *puppetPoint = [DHGobangTool getTouchPointWith:point];
    NSInteger h,v;
    h = puppetPoint.x;
    v = puppetPoint.y;
    
    // 1.如果不是空的话就不准下棋
    if ([DHGobangTool getType:puppetPoint array:self.places] != OccupyTypeEmpty) {
        return;
    }
    
    // 2.如果是蓝牙的话，在点击下棋后没收到对手落子前是不能点击棋盘的
    if (self.isBlueTooth && !self.isAbleClick) {
        return;
    }
    
    // 3.判断是否是白色棋子
    _isWhiteChess = (self.totalChess.count % 2 == 0 ? YES:NO);
    _isWhiteChess = [DHNSUserdefault getTheIsWhiteSente] ? _isWhiteChess : !_isWhiteChess;
    
    // 4.代理出去
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchThePoint:isWhite:)]) {
        [self.delegate touchThePoint:puppetPoint isWhite:_isWhiteChess];
    }
    if (self.isBlueTooth) {
        [self addChessWithX:h y:v isBlack:!_isWhiteChess type:OccupyTypeUser];
    } else {
        OccupyType type;
        /**
         *  玩家先手，ai后手
         */
        type = (self.totalChess.count % 2 == 0 ? OccupyTypeUser:OccupyTypeAI);
        [self addChessWithX:h y:v isBlack:!_isWhiteChess type:type];
    }
}

- (void)winWithPoint:(DHPoint *)point {
    
    OccupyType myType;
    NSInteger type = [self.places[point.x - 1][point.y - 1] integerValue];
    if (self.isBlueTooth) {
        
        if (type == OccupyTypeAI) {
            NSLog(@"你输了");
            [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"lost.wav"] play];
            myType = OccupyTypeAI;
        } else if (type == OccupyTypeUser) {
            NSLog(@"你赢了");
            [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"win.wav"] play];
            myType = OccupyTypeUser;
        }
    } else {
        
        [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"win.wav"] play];
        if (type == OccupyTypeAI) {
            myType = [DHNSUserdefault getTheIsWhiteSente] ? OccupyTypeBlack:OccupyTypeWhite;
        } else if (type == OccupyTypeUser) {
            myType = [DHNSUserdefault getTheIsWhiteSente] ? OccupyTypeWhite:OccupyTypeBlack;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PPWhoWinNotify object:nil userInfo:@{@"type":@(myType)}];
}


/**
 *  在h，v这个点添加个棋子
 */
- (void)addChessWithX:(NSInteger)x y:(NSInteger)y isBlack:(BOOL)isBlack type:(OccupyType)type{
    
    [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"down.wav"] play];
    CGFloat boardWidth = SCREEN_W / (DHBoardSize + 1);
    if ([self.places[x - 1][y - 1] integerValue] == OccupyTypeEmpty) {
        UIImageView *chessImg = [UIImageView new];
        chessImg.image = [UIImage imageNamed:isBlack?@"stone_black":@"stone_white"];
        chessImg.bounds = CGRectMake(0, 0, boardWidth, boardWidth);
        CGFloat centerX = x * boardWidth;
        CGFloat centerY = y * boardWidth;
        chessImg.center = CGPointMake(centerX, centerY);
        [self addSubview:chessImg];
        
        /**
         *  棋子添加成功后做的操作
         */
        // 0.添加到数组里面
        NSMutableArray *puppetArr = self.places[x - 1];
        [puppetArr replaceObjectAtIndex:y - 1 withObject:@(type)];
        
        // 1.判断是否胜利
        DHPoint *resultPoint = [[DHPoint alloc] initPointWith:x y:y];
        if ([DHGobangTool isVictory:resultPoint array:self.places]) {
            [self winWithPoint:resultPoint];
        }
        
        // 2.加到记录棋子的数组
        [self.totalChess addObject:[[DHPoint alloc] initPointWith:x y:y]];
    }
}

#pragma mark - public
- (void)reset {
    
    [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"start.wav"] play];
    for (UIImageView *imgView in self.subviews) {
        [imgView removeFromSuperview];
    }
    [self initilizeData];
}

- (void)undo {
    
    [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"regret.wav"] play];
    if (self.totalChess.count > 1) {
        DHPoint *lastPoint = [self.totalChess objectAtIndex:self.totalChess.count - 1];
        UIImageView *lastChess = [DHGobangTool foundChessWithPoint:lastPoint superView:self];
        if (lastChess) {
            [lastChess removeFromSuperview];
            [self.totalChess removeObject:lastPoint];
            [self.places[lastPoint.x - 1] replaceObjectAtIndex:lastPoint.y - 1 withObject:@0];
        }
    }
}



@end

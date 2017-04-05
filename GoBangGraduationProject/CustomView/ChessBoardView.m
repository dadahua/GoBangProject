//
//  ChessBoardView.m
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/5/10.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "ChessBoardView.h"
#import "DHAI.h"
#import "DHGobangTool.h"
#import "DHNSUserdefault.h"
#import "HBPlaySoundUtil.h"

@interface ChessBoardView () {
    
    void(^xyBlock)(NSInteger x,NSInteger y);
    BOOL isMePlay;
}
@property (nonatomic, strong) NSMutableArray *places; //记录所有位置的棋盘
@property (nonatomic, strong) NSMutableArray *totalChess; //记录所有棋子

@end

@implementation ChessBoardView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addLines];
        [self initilizeData];
        [self isPlayerSente];
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

- (void)isPlayerSente {
    
    BOOL isPlayerSente = [DHNSUserdefault getTheIsPlayerSente];
    BOOL isWhite = [DHNSUserdefault getTheIsWhiteSente];
    if (!isPlayerSente) {
        DHPoint *aiPoint = [[DHPoint alloc] init];
        aiPoint = [DHAI SearchTheGreat:self.places type:OccupyTypeAI];
        [self addChessWithX:aiPoint.x y:aiPoint.y isBlack:!isWhite type:OccupyTypeAI];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    DHPoint *puppetPoint = [DHGobangTool getTouchPointWith:point];
    NSInteger h,v;
    h = puppetPoint.x;
    v = puppetPoint.y;
    /**
     *  如果不是空的话就不准下棋
     */
    if ([DHGobangTool getType:puppetPoint array:self.places] != OccupyTypeEmpty) {
        return;
    }
    BOOL isPlayerSente = [DHNSUserdefault getTheIsPlayerSente];
    BOOL isWhite = [DHNSUserdefault getTheIsWhiteSente];
    [self addChessWithX:h y:v isBlack:isPlayerSente ? !isWhite : isWhite type:OccupyTypeUser];
    DHPoint *aiPoint = [[DHPoint alloc] init];
    aiPoint = [DHAI SearchTheGreat:self.places type:OccupyTypeAI];
    [self addChessWithX:aiPoint.x y:aiPoint.y isBlack:isPlayerSente ? isWhite : !isWhite type:OccupyTypeAI];
}

- (void)winWithPoint:(DHPoint *)point {
    
    NSInteger type = [self.places[point.x - 1][point.y - 1] integerValue];
    OccupyType myType;
    if (type == OccupyTypeAI) {
        NSLog(@"电脑赢了");
        [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"lost.wav"] play];
        myType = OccupyTypeAI;
    } else if (type == OccupyTypeUser) {
        NSLog(@"你赢了");
        [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"win.wav"] play];
        myType = OccupyTypeUser;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AIWhoWinNotify object:nil userInfo:@{@"type":@(myType)}];
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
    
    for (UIImageView *imgView in self.subviews) {
        [imgView removeFromSuperview];
    }
    [self initilizeData];
}

- (void)undo {
    
    if (self.totalChess.count >= 2) {
        DHPoint *lastPoint = [self.totalChess objectAtIndex:self.totalChess.count - 1];
        DHPoint *lastTwoPoint = [self.totalChess objectAtIndex:self.totalChess.count - 2];
        UIImageView *lastChess = [DHGobangTool foundChessWithPoint:lastPoint superView:self];
        UIImageView *lastTwoChess = [DHGobangTool foundChessWithPoint:lastTwoPoint superView:self];
        if (lastChess) {
            [lastChess removeFromSuperview];
            [self.totalChess removeObject:lastPoint];
            [self.places[lastPoint.x - 1] replaceObjectAtIndex:lastPoint.y - 1 withObject:@0];
        }
        if (lastTwoPoint) {
            [lastTwoChess removeFromSuperview];
            [self.totalChess removeObject:lastTwoPoint];
            [self.places[lastTwoPoint.x - 1] replaceObjectAtIndex:lastTwoPoint.y - 1 withObject:@0];
        }
    }
}


@end

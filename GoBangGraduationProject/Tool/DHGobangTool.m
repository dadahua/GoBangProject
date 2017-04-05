//
//  DHGobangTool.m
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/5/30.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "DHGobangTool.h"


@implementation DHGobangTool

+ (BOOL)isVictory:(DHPoint *)point array:(NSArray *)places {
    
    NSInteger x = point.x;
    NSInteger y = point.y;
    OccupyType type = [places[x - 1][y - 1] integerValue];
    if (type == OccupyTypeEmpty) return NO;
    
    // 判断改点是否超出边界
    
    DHPoint *textLeft = [[DHPoint alloc] initPointWith:point.x y:point.y];
    DHPoint *textRight = [[DHPoint alloc] initPointWith:point.x y:point.y];
    for (int i = 1; point.x - i >= 1 && [places[point.x - i - 1][point.y - 1] integerValue] == type; i ++) {
        textLeft = [[DHPoint alloc] initPointWith:point.x - i y:textLeft.y];
    }
    for (int i = 1; point.x + i <= DHBoardSize && [places[point.x + i - 1][point.y - 1] integerValue] == type; i ++) {
        textRight = [[DHPoint alloc] initPointWith:point.x + i y:textRight.y];
    }
    if (textRight.x - textLeft.x >= 4) return YES;
    
    DHPoint *textTop = [[DHPoint alloc] initPointWith:point.x y:point.y];
    DHPoint *textDown = [[DHPoint alloc] initPointWith:point.x y:point.y];
    for (int i = 1; point.y - i >= 1 && [places[point.x - 1][point.y - i - 1] integerValue] == type; i ++) {
        textTop = [[DHPoint alloc] initPointWith:point.x y:point.y - i];
    }
    for (int i = 1; point.y + i <= DHBoardSize && [places[point.x - 1][point.y + i - 1] integerValue] == type; i ++) {
        textDown = [[DHPoint alloc] initPointWith:point.x y:point.y + i ];
    }
    if (textDown.y - textTop.y >= 4) return YES;
    
    DHPoint *textEN = [[DHPoint alloc] initPointWith:point.x y:point.y]; //东北
    DHPoint *textWS = [[DHPoint alloc] initPointWith:point.x y:point.y]; //西南
    for (int i = 1; point.y + i <= DHBoardSize && point.x - i > 0 && [places[point.x - i - 1][point.y + i - 1] integerValue] == type; i ++) {
        textWS = [[DHPoint alloc] initPointWith:point.x - i y:point.y + i];
    }
    for (int i = 1; point.y - i > 0 && point.x + i <= DHBoardSize && [places[point.x + i - 1][point.y - i - 1] integerValue] == type; i ++) {
        textEN = [[DHPoint alloc] initPointWith:point.x + i y:point.y - i];
    }
    if  (textEN.x - textWS.x >= 4 && textWS.y - textEN.y >= 4) return YES;
    
    DHPoint *textWN = [[DHPoint alloc] initPointWith:point.x y:point.y]; //西北
    DHPoint *textES = [[DHPoint alloc] initPointWith:point.x y:point.y]; //东南
    for (int i = 1; point.y - i > 0 && point.x - i > 0 && [places[point.x - i - 1][point.y - i - 1] integerValue] == type; i ++) {
        textWN = [[DHPoint alloc] initPointWith:point.x - i y:point.y - i];
    }
    for (int i = 1; point.y + i <= DHBoardSize && point.x + i <= DHBoardSize && [places[point.x + i - 1][point.y + i - 1] integerValue] == type; i ++) {
        textES = [[DHPoint alloc] initPointWith:point.x + i y:point.y + i];
    }
    if  (textES.x - textWN.x >= 4 && textES.y - textWN.y >= 4) return YES;
    return NO;

}

/**
 *  获取某个点的种类
 */
+ (OccupyType)getType:(DHPoint *)point array:(NSMutableArray *)places {
    
    if (point.x >0 && point.y >0 && point.x <= DHBoardSize && point.y <= DHBoardSize) {
        return [places[point.x - 1][point.y - 1] integerValue];
    }
    return OccupyTypeEmpty;
}

+ (DHPoint *)getTouchPointWith:(CGPoint)point {
    
    CGFloat touchX = point.x, touchY = point.y;
    CGFloat boardWidth = SCREEN_W / (DHBoardSize + 1);
    /**
     *  h:水平第几个点
     *  W:垂直第几个点
     */
    NSInteger h,v;
    h = (NSInteger)(touchX / boardWidth);
    v = (NSInteger)(touchY / boardWidth);
    /**
     *  如果点大于棋格的一半就落下一个点,边界不允许下棋
     */
    if (fmod(touchX, boardWidth) > boardWidth / 2.0 || touchX <= boardWidth / 2) {
        h ++;
    }
    if (fmod(touchY, boardWidth) > boardWidth / 2.0 || touchY <= boardWidth / 2) {
        v ++;
    }
    if (touchX >= SCREEN_W - boardWidth / 2) {
        h --;
    }
    if (touchY >= SCREEN_W - boardWidth / 2) {
        v --;
    }
    return [[DHPoint alloc] initPointWith:h y:v];

}

+ (UIImageView *)foundChessWithPoint:(DHPoint *)point superView:(UIView *)view {
    
    NSInteger x = point.x;
    NSInteger y = point.y;
    CGFloat boardWidth = SCREEN_W / (DHBoardSize + 1);
    for (UIImageView *imgView in view.subviews) {
        if (imgView.center.x == x * boardWidth && imgView.center.y == y * boardWidth) {
            return imgView;
        }
    }
    return nil;
}


@end

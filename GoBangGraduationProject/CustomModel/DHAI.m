//
//  DHAI.m
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/5/18.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "DHAI.h"

@implementation DHPointData

- (instancetype)init {
    
    if (self = [super init]) {
        self.p = [[DHPoint alloc] initPointWith:0 y:0];
        self.count = 0;
    }
    return self;
}

- (instancetype)initWithPoint:(DHPoint *)point count:(int)count {
    
    self = [self init];
    if (self) {
        self.p = point;
        self.count = count;
    }
    return self;
}

@end



@implementation DHOmni

- (instancetype)init {
    
    if (self = [super init]) {
        self.userType = OccupyTypeEmpty;
        self.aiType = OccupyTypeEmpty;
    }
    return self;
}

- (id)initWithArr:(NSMutableArray *)ar user:(OccupyType)user ai:(OccupyType)ai {
    
    if (self = [self init]) {
        self.totalChesses = ar;
        self.userType = user;
        self.aiType = ai;
    }
    return self;
}

/**
 *  改点的四个方向
 *
 *  @param point <#point description#>
 *  @param num   <#num description#>
 *  @param type  <#type description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)isStepEmergent:(DHPoint *)point num:(int)num type:(OccupyType)type {
    
    if ([self isUsefulPonint:point]) { // 判断改点是否超出边界

        DHPoint *originalPoint = [[DHPoint alloc] initPointWith:point.x y:point.y];
        
        
        DHPoint *textLeft = [[DHPoint alloc] initPointWith:point.x y:point.y];
        DHPoint *textRight = [[DHPoint alloc] initPointWith:point.x y:point.y];
        for (int i = 1; originalPoint.x - i >= 1 && [self.totalChesses[originalPoint.x - i - 1][originalPoint.y - 1] integerValue] == type; i ++) {
            textLeft = [[DHPoint alloc] initPointWith:textLeft.x - 1 y:textLeft.y];
        }
        for (int i = 1; originalPoint.x + i <= DHBoardSize && [self.totalChesses[originalPoint.x + i - 1][originalPoint.y - 1] integerValue] == type; i ++) {
            textRight = [[DHPoint alloc] initPointWith:textRight.x + 1 y:textRight.y];
        }
        if ([self isStepEmergentWithStart:textLeft end:textRight direction:DirectionTypeRight num:num]) {
            return YES;
        };
        
        
        DHPoint *textTop = [[DHPoint alloc] initPointWith:point.x y:point.y];
        DHPoint *textDown = [[DHPoint alloc] initPointWith:point.x y:point.y];
        for (int i = 1; originalPoint.y - i >= 1 && [self.totalChesses[point.x - 1][point.y - 1 - i] integerValue] == type; i ++) {
            textTop = [[DHPoint alloc] initPointWith:textTop.x y:textTop.y - 1];
        }
        for (int i = 1; originalPoint.y + i <= DHBoardSize && [self.totalChesses[point.x - 1][point.y + i - 1] integerValue] == type; i ++) {
            textDown = [[DHPoint alloc] initPointWith:textDown.x y:textDown.y + 1];
        }
        if ([self isStepEmergentWithStart:textTop end:textDown direction:DirectionTypeTop num:num]) {
            return YES;
        }
        

        DHPoint *textEN = [[DHPoint alloc] initPointWith:point.x y:point.y]; //东北
        DHPoint *textWS = [[DHPoint alloc] initPointWith:point.x y:point.y]; //西南
        for (int i = 1; originalPoint.y + i <= DHBoardSize && originalPoint.x - i > 0 && [self.totalChesses[point.x - i - 1][point.y + i - 1] integerValue] == type; i ++) {
            textWS = [[DHPoint alloc] initPointWith:textWS.x - 1 y:textWS.y + 1];
        }
        for (int i = 1; originalPoint.y - i > 0 && originalPoint.x + i <= DHBoardSize && [self.totalChesses[point.x + i - 1][point.y - i - 1] integerValue] == type; i ++) {
            textEN = [[DHPoint alloc] initPointWith:textEN.x + 1 y:textEN.y - 1];
        }
        if ([self isStepEmergentWithStart:textWS end:textEN direction:DirectionTypeRightTop num:num]) {
            return YES;
        }
        
        
        DHPoint *textWN = [[DHPoint alloc] initPointWith:point.x y:point.y]; //西北
        DHPoint *textES = [[DHPoint alloc] initPointWith:point.x y:point.y]; //东南
        for (int i = 1; originalPoint.y - i > 0 && originalPoint.x - i > 0 && [self.totalChesses[point.x - i - 1][point.y - i - 1] integerValue] == type; i ++) {
            textWN = [[DHPoint alloc] initPointWith:textWN.x - i y:textWN.y - i];
        }
        for (int i = 1; originalPoint.y + i <= DHBoardSize && originalPoint.x + i <= DHBoardSize && [self.totalChesses[point.x + i - 1][point.y + i - 1] integerValue] == type; i ++) {
            textES = [[DHPoint alloc] initPointWith:textES.x + 1 y:textES.y + 1];
        }
        if ([self isStepEmergentWithStart:textWN end:textES direction:DirectionTypeRightDown num:num]) {
            return YES;
        }
        
//        DHPoint *textLeft = [[DHPoint alloc] initPointWith:point.x y:point.y];
//        DHPoint *textRight = [[DHPoint alloc] initPointWith:point.x y:point.y];
//        
//        for (int i = 1; textLeft.x - i >= 1 && [self.totalChesses[textLeft.x - 1][textLeft.y - 1] integerValue] == type; i ++) {
//            textLeft = [[DHPoint alloc] initPointWith:textLeft.x - i y:textLeft.y];
//        }
//        for (int i = 1; textRight.x + i <= DHBoardSize && [self.totalChesses[textRight.x - 1][textRight.y - 1] integerValue] == type; i ++) {
//            textRight = [[DHPoint alloc] initPointWith:textRight.x + i y:textRight.y];
//        }
//        if (textRight.x - textLeft.x > num) {
//            if ([self isUsefulPonint:textLeft] && [self isUsefulPonint:textRight]) {
//                if ([self.totalChesses[textRight.x - 1][textRight.y - 1] integerValue] == OccupyTypeEmpty && [self.totalChesses[textLeft.x - 1][textLeft.y - 1] integerValue] == OccupyTypeEmpty) {
//                    return YES;
//                }
//            }
//        }
        
        
    }
    return NO;
}

/**
 *  判断两个点是否是满足条件的
 */
- (BOOL)isStepEmergentWithStart:(DHPoint *)startPoint end:(DHPoint *)endPoint direction:(DirectionType)direction num:(NSInteger)num {
    
    /**
     找到传进来的点的上一个点
     
     - eg: ￥***￥，找到*之前的￥
     */
    DHPoint *start = [[DHPoint alloc] initPointWith:startPoint.x y:startPoint.y];
    DHPoint *end = [[DHPoint alloc] initPointWith:endPoint.x y:endPoint.y];
    switch (direction) {
        case DirectionTypeTop:
        {
            start.y --;
            end.y ++;
        }
            break;
        case DirectionTypeRightTop:
        {
            start.x --,start.y ++;
            end.x ++,end.y --;
        }
            break;
        case DirectionTypeRight:
        {
            start.x --,end.x ++;
        }
            break;
        case DirectionTypeRightDown:
        {
            start.x --,start.y --;
            end.x ++,end.y ++;
        }
            break;
            
        default:
            break;
    }
    
    if ([self isUsefulPonint:start] && [self isUsefulPonint:end]) {
        if ([self.totalChesses[start.x - 1][start.y - 1] integerValue] == OccupyTypeEmpty && [self.totalChesses[end.x - 1][end.y - 1] integerValue] == OccupyTypeEmpty) {
            switch (direction) {
                case DirectionTypeTop:
                {
                    if (end.y - start.y >= num) {
                        return YES;
                    }
                }
                    break;
                case DirectionTypeRightTop:
                {
                    if (end.x - start.x >= num && start.y - end.y >= num) {
                        return YES;
                    }
                }
                    break;
                case DirectionTypeRight:
                {
                    if (end.x - start.x >= num) {
                        return YES;
                    }
                }
                    break;
                case DirectionTypeRightDown:
                {
                    if (end.y - start.y >= num && end.x - start.x >= num) {
                        return YES;
                    }
                }
                    break;
                    
                default:
                    break;
            }

//            return YES;
        }
    }
    return NO;
}

/**
 *  检查改点是否可以用
 */
- (BOOL)isUsefulPonint:(DHPoint *)point {
    
    if (point.x <= 15 && point.y <= 15 && point.x >0 && point.y > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - 下一步
/**
 *  在某个方向上找到threshold的连珠，并且有可能成为num的连珠
 *
 *  @param direction 方向
 *  @param point     原始点
 *  @param type      类型
 *  @param num       可能成为num的连珠
 *  @param threshold 已经有threshold的连珠
 */
- (DHPoint *)direction:(DirectionType)direction
         originalPoint:(DHPoint *)point
                  type:(OccupyType)type
                   num:(int)num
             threshold:(int)threshold {
    
    if (![self isUsefulPonint:point]) {
        return point;
    }
    DHPoint *resultPoint = [[DHPoint alloc] init];
    int count = 0;
    NSInteger x = 0,y = 0;
    for (int i = 0; i < num; i ++) {
        switch (direction) {
            case DirectionTypeTop:
            {
                x = point.x;
                y = point.y + i;
            }
                break;
            case DirectionTypeRightTop:
            {
                x = point.x + i;
                y = point.y - i;
            }
                break;
            case DirectionTypeRight:
            {
                x = point.x + i;
                y = point.y;
            }
                break;
            case DirectionTypeRightDown:
            {
                x = point.x + i;
                y = point.y + i;
            }
                break;
                
            default:
                break;
        }
        if (y > 0 && x > 0 && y <= DHBoardSize && x <= DHBoardSize) {
            if ([self.totalChesses[x - 1][y - 1] integerValue] == type) {
                count ++;
            }
            if ([self.totalChesses[x - 1][y - 1] integerValue] == OccupyTypeEmpty) {
                resultPoint.x = x;
                resultPoint.y = y;
            }
        }
    }
    if (count >= threshold && [self isUsefulPonint:resultPoint]) {
        return resultPoint;
    }
    return [self direction:direction originalPoint:[self nextPoint:point] type:type num:num threshold:threshold];
}

- (DHPoint *)nextPoint:(DHPoint *)point {
    
    DHPoint *resultPoint = [[DHPoint alloc] initPointWith:point.x y:point.y];
    if (point.x >=DHBoardSize) {
        resultPoint.x = 1,resultPoint.y ++;
    } else {
        resultPoint.x ++;
    }
    return resultPoint;
}

/**
 *  从（x，y）点开始便利四周有threshold连珠并且即将形成num连珠的位置
 */
- (DHPoint *)nextStep:(OccupyType)type num:(int)num threshold:(int)threshold x:(int)startX y:(int)startY {
    
    DHPoint *search = [[DHPoint alloc] initPointWith:startX y:startY];
    DHPoint *topPoint;
    DHPoint *rightTopPoint;
    DHPoint *rightPoint;
    DHPoint *rightDownPoint;
    /**
     *  在竖直方向上便利是否有threshold连珠并且即将形成num连珠的点
     */
    topPoint = [self direction:DirectionTypeTop originalPoint:search type:type num:num threshold:threshold];
    /**
     *  在东北方向上便利是否有threshold连珠并且即将形成num连珠的点
     */
    rightTopPoint = [self direction:DirectionTypeRightTop originalPoint:search type:type num:num threshold:threshold];
    /**
     *  在纵向方向上便利是否有threshold连珠并且即将形成num连珠的点
     */
    rightPoint = [self direction:DirectionTypeRight originalPoint:search type:type num:num threshold:threshold];
    /**
     *  在东南方向上便利是否有threshold连珠并且即将形成num连珠的点
     */
    rightDownPoint = [self direction:DirectionTypeRightDown originalPoint:search type:type num:num threshold:threshold];
    if (num == 5) { //找到胜利的棋子
        if ([self isUsefulPonint:topPoint]) return topPoint;
        if ([self isUsefulPonint:rightTopPoint]) return rightTopPoint;
        if ([self isUsefulPonint:rightPoint]) return rightPoint;
        if ([self isUsefulPonint:rightDownPoint]) return rightDownPoint;
    } else {
        
//        while ([self isUsefulPonint:topPoint] && ![self isStepEmergent:topPoint num:num type:type]) {
//            // 在顶部寻找threshold连续且可以形成num连续的点
//            topPoint = [self direction:DirectionTypeTop
//                         originalPoint:[self nextPoint:topPoint]
//                                  type:type
//                                   num:num
//                             threshold:threshold];
//        }
        if ([self isStepEmergent:topPoint num:num type:type]) return topPoint;
        
        
//        while ([self isUsefulPonint:rightTopPoint] && ![self isStepEmergent:rightTopPoint num:num type:type]) {
//            // 在东北寻找threshold连续且可以形成num连续的点
//            rightTopPoint = [self direction:DirectionTypeRightTop
//                              originalPoint:[self nextPoint:rightTopPoint]
//                                       type:type
//                                        num:num
//                                  threshold:threshold];
//        }
        if ([self isStepEmergent:rightTopPoint num:num type:type]) return rightTopPoint;
        
        
//        while ([self isUsefulPonint:rightDownPoint] && ![self isStepEmergent:rightDownPoint num:num type:type]) {
//            // 在顶部寻找threshold连续且可以形成num连续的点
//            rightDownPoint = [self direction:DirectionTypeRightDown
//                               originalPoint:[self nextPoint:rightDownPoint]
//                                        type:type
//                                         num:num
//                                   threshold:threshold];
//        }
        if ([self isStepEmergent:rightDownPoint num:num type:type]) return rightDownPoint;
        
        
//        while ([self isUsefulPonint:rightPoint] && ![self isStepEmergent:rightPoint num:num type:type]) {
//            // 在顶部寻找threshold连续且可以形成num连续的点
//            rightPoint = [self direction:DirectionTypeRight
//                           originalPoint:[self nextPoint:rightPoint]
//                                    type:type
//                                     num:num
//                               threshold:threshold];
//        }
        if ([self isStepEmergent:rightPoint num:num type:type]) return rightPoint;
    }
    DHPoint *invalid = [[DHPoint alloc] init];
    return invalid;
}

@end



@implementation DHAI

+ (DHPoint *)SearchTheGreat:(NSMutableArray *)board type:(OccupyType)type {
    
    DHOmni *omni = [[DHOmni alloc] init];
    if (type == OccupyTypeUser) {
        omni = [[DHOmni alloc] initWithArr:board user:OccupyTypeAI ai:OccupyTypeUser];
    } else {
        omni = [[DHOmni alloc] initWithArr:board user:OccupyTypeUser ai:OccupyTypeAI];
    }
    
    DHPoint *luck = [[DHPoint alloc] init];
    for (int i = 5; i > 1; i --) {
        // AI以自己的角度观察场上形势，从（1， 1）点开始遍历，寻找用户棋子排放是否有(i - 1)子连珠并且可以形成i子连珠的点
        luck = [omni nextStep:omni.aiType num:i threshold:i - 1 x:1 y:1];
        if ([omni isUsefulPonint:luck]) return luck;
        
        // AI以用户的角度观察场上形势，从（0， 0）点开始遍历，寻找用户棋子排放是否有(i - 1)子连珠并且可以形成i子连珠的点
        luck = [omni nextStep:omni.userType num:i threshold:i - 1 x:1 y:1];
        if ([omni isUsefulPonint:luck]) return luck;
    }
    
    DHPoint *sad = [[DHPoint alloc] initPointWith:(DHBoardSize + 1) / 2 y:(DHBoardSize + 1) / 2];
    return sad;
    
}

@end

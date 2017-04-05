//
//  Config.h
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/5/18.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, OccupyType) {
    OccupyTypeEmpty = 0, //空
    OccupyTypeUser,      //用户
    OccupyTypeAI,        //电脑
    OccupyTypeEnemy,     //对手
    OccupyTypeUnknown,   //未知
    OccupyTypeWhite,     //白旗
    OccupyTypeBlack,     //黑旗
};

typedef NS_ENUM(NSInteger, DirectionType) {
    
    DirectionTypeTop = 0,
    DirectionTypeRightTop,
    DirectionTypeRight,
    DirectionTypeRightDown,
    DirectionTypeDown,
    DirectionTypeLeftDown,
    DirectionTypeLeft,
    DirectionTypeLeftTop,
};
static NSInteger const DHBoardSize = 15;
static NSString * const ServiceType = @"dh-gobang";

/**
 *  沙河
 */
#define IsSounds @"isSounds"
#define IsWhiteSente @"isWhiteSente"
#define IsPlayerSente @"isPlayerSente"
#define IsHaveUsed @"isFirstUse"

/**
 *  通知
 */
#define AIWhoWinNotify @"AIWhoWinNotify"
#define PPWhoWinNotify @"PPWhoWinNotify"


@interface Config : NSObject



@end

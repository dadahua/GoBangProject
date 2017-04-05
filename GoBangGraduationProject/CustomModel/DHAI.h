//
//  DHAI.h
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/5/18.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHPoint.h"





/**
 *  记录所有点的数据
 */
@interface DHPointData : NSObject

@property (nonatomic, strong) DHPoint *p;
@property (nonatomic, assign) int count;

- (instancetype)initWithPoint:(DHPoint *)point count:(int)count;

@end



/**
 *  电脑下棋
 */
@interface DHOmni : NSObject

@property (nonatomic, strong) NSMutableArray *totalChesses;
@property (nonatomic, assign) OccupyType userType;
@property (nonatomic, assign) OccupyType aiType;

- (id)initWithArr:(NSMutableArray *)ar user:(OccupyType)user ai:(OccupyType)ai;
- (BOOL)isStepEmergent:(DHPoint *)point num:(int)num type:(OccupyType)type;

@end



/**
 *  电脑找点
 */
@interface DHAI : NSObject

+ (DHPoint *)SearchTheGreat:(NSMutableArray *)board type:(OccupyType)type;

@end

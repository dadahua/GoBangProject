//
//  DHPPChessBoardView.h
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/6/1.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHPoint.h"

@protocol DHPPChessDelegate <NSObject>

- (void)touchThePoint:(DHPoint *)point isWhite:(BOOL)isWhiteChess;

@end

@interface DHPPChessBoardView : UIView

@property (nonatomic, assign) id<DHPPChessDelegate> delegate;
@property (nonatomic, assign) BOOL isBlueTooth;
@property (nonatomic, assign) BOOL isAbleClick;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)reset;
- (void)undo;

/**
 *  添加棋子
 *
 *  @param x       x坐标
 *  @param y       y坐标
 *  @param isBlack 是否黑白
 */
- (void)addChessWithX:(NSInteger)x y:(NSInteger)y isBlack:(BOOL)isBlack type:(OccupyType)type;

@end

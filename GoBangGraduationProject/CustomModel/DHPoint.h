//
//  DHPoint.h
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/5/18.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHPoint : NSObject

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;

- (instancetype)initPointWith:(NSInteger)X y:(NSInteger)Y;

@end

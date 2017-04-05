//
//  DHPoint.m
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/5/18.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "DHPoint.h"

@implementation DHPoint

- (instancetype)init {
    
    if (self = [super init]) {
        self.x = -1;
        self.y = -1;
    }
    return self;
}

- (instancetype)initPointWith:(NSInteger)X y:(NSInteger)Y {
    
    if (self = [self init]) {
        self.x = X;
        self.y = Y;
    }
    return self;
}

@end

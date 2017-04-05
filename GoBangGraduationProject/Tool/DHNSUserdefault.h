//
//  DHNSUserdefault.h
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/6/1.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHNSUserdefault : NSObject

+ (BOOL)getTheIsWhiteSente;
+ (BOOL)getTheIsSounds;
+ (BOOL)getTheIsPlayerSente;

+ (void)setupIsWhiteSente:(BOOL)bools;
+ (void)setupIsSounds:(BOOL)bools;
+ (void)setupIsPlayerSente:(BOOL)bools;

@end

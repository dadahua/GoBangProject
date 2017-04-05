//
//  DHMCTool.h
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/5/31.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@protocol DHMCToolDelegate <NSObject>

@optional
- (void)session:(MCSession *)session didReceiveString:(NSString *)str fromPeer:(MCPeerID *)peer;
- (void)session:(MCSession *)session didChangeState:(MCSessionState)state fromPeer:(MCPeerID *)peer;
- (void)browserControllerCancleAndDone;

@end

@interface DHMCTool : NSObject

@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, assign) id<DHMCToolDelegate> delegate;
+ (instancetype)tool;

/**
 *  开启广播和初始化peer 和 session 和 advertiser
 */
- (void)setupPeerSessionAdvertiser;

/**
 *  关闭广播
 */
- (void)closeAdvertiser;

/**
 *  发送数据
 */
- (void)sendMessage:(NSString *)message error:(NSError *)error;
@end

//
//  DHLaunchVC.m
//  GoBangGraduationProject
//
//  Created by 刘人华 on 16/6/3.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "DHLaunchVC.h"
#import "DHNavgationController.h"

@interface DHLaunchVC ()<UIScrollViewDelegate> {
    
    UIScrollView *scrollView; // 滚动试图
    UIPageControl *pageControl; // 分页控制器
    NSInteger pages;
}

@end

@implementation DHLaunchVC
- (BOOL)prefersStatusBarHidden {
    
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    pages = 10; // 页面数
    [self createUI];
}
/**
 *  创建UI
 */
- (void)createUI {
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    scrollView.contentSize = CGSizeMake(SCREEN_W * pages, 0);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO; // 关闭弹性滑动；
    scrollView.delegate = self;
    
    
    // 添加图片
    for (NSInteger i = 0; i < pages; i ++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W * i, 0, SCREEN_W, SCREEN_H)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_W * (i + 1) - 55, 5, 50, 25);
        [btn addTarget:self action:@selector(getBackToHomeView) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"lappover"] forState:UIControlStateNormal];
        NSString *imgStr = [NSString stringWithFormat:@"%d.jpg",i + 1];
        imgView.image = [UIImage imageNamed:imgStr];
        [scrollView addSubview:imgView];
        [scrollView addSubview:btn];
    }
    
    // 添加退出btn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.center = CGPointMake(SCREEN_W * (pages - 1) + SCREEN_W / 2, SCREEN_H / 6.0 * 5.5);
    btn.bounds = CGRectMake(0, 0, 80, 30);
    [btn setTitle:@"进入游戏" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 2;
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(getBackToHomeView) forControlEvents:UIControlEventTouchUpInside];
    
    // 创建分页器
    pageControl = [[UIPageControl alloc] init];
    pageControl.center = CGPointMake(SCREEN_W / 2, SCREEN_H / 6.0 * 5.2);
    pageControl.bounds = CGRectMake(0, 0, 80, 37);
    pageControl.numberOfPages = pages;
    pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    
    [scrollView addSubview:btn];
    [self.view addSubview:scrollView];
    [self.view addSubview:pageControl];
}
#pragma mark 按钮点击
/**
 *  回到主界面
 */
- (void)getBackToHomeView {
    
    // 让登陆界面成为根控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     DHNavgationController *loginVC = [loginStoryboard instantiateViewControllerWithIdentifier:@"DHNavgationController"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IsHaveUsed];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [window setRootViewController:loginVC];
    [window makeKeyAndVisible];
    
}
/**
 *  scrollView代理
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollViewss {
    
    /**
     round():如果参数是小数，则对自身四舍五入
     ceil():如果参数是小数，则求最大整数
     floor():如果参数是小数，则求最小整数
     */
    NSInteger index = round(scrollViewss.contentOffset.x / SCREEN_W);
    pageControl.currentPage = index;
}



@end

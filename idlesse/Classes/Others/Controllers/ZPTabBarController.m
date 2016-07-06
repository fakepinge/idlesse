//
//  ZPTabBarController.m
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPTabBarController.h"
#import "ZPNavigationController.h"
#import "ZPEnjoyReadViewController.h"
#import "ZPMusicViewController.h"
#import "ZPMoiveViewController.h"
#import "ZPMeViewController.h"
#import "ZPGuideScrollView.h"


@interface ZPTabBarController ()

@end

@implementation ZPTabBarController


+ (void)initialize {
    
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attri[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectAttri = [NSMutableDictionary dictionary];
    selectAttri[NSFontAttributeName] = attri[NSFontAttributeName];
    selectAttri[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:attri forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:selectAttri forState:UIControlStateSelected];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
    
    [self setupControllers];
    
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"];
    
    if (isFirst) return;
    
    [self setupGuideViews];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirst"];

}

#pragma mark - 添加视图控制器
- (void) setupControllers {
    
    [self setupChildVC:[[ZPEnjoyReadViewController alloc] initWithStyle:UITableViewStylePlain] tTitle:@"美文" nTitle:@"暖心美文" imageName:@"tabbar_read" selectedImageName:@"tabbar_read_click"];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZPMoiveViewController *musicVC = [sb instantiateViewControllerWithIdentifier:@"ZPMusicViewController"];
    [self setupChildVC:musicVC tTitle:@"音乐" nTitle:@"音乐资讯" imageName:@"tabbar_music" selectedImageName:@"tabbar_music_click"];
    
    [self setupChildVC:[[ZPMoiveViewController alloc] initWithStyle:UITableViewStylePlain] tTitle:@"电影" nTitle:@"电影资讯" imageName:@"tabbar_moive" selectedImageName:@"tabbar_moive_click"];
    
    ZPMeViewController *meVC = [sb instantiateViewControllerWithIdentifier:@"ZPMeViewController"];
    [self setupChildVC:meVC tTitle:@"我的" nTitle:@"我的" imageName:@"tabbar_me" selectedImageName:@"tabbar_me_click"];
    
    
}

#pragma mark - 添加引导页
- (void) setupGuideViews {
    
    ZPGuideScrollView *guide = [[ZPGuideScrollView alloc] initWithFrame:SCREEN_FRAME];
    guide.pageController.center = CGPointMake(SCREEN_FRAME.size.width * 0.5, SCREEN_FRAME.size.height - 60);
    [self.view addSubview:guide];
    [self.view addSubview:guide.pageController];
    [self.view bringSubviewToFront:guide];
    [self.view bringSubviewToFront:guide.pageController];
    
}

#pragma mark - 初始化子控制器
- (void) setupChildVC:(UIViewController *) vc tTitle:(NSString *) tTitle  nTitle:(NSString *) nTitle imageName:(NSString *) imageName selectedImageName:(NSString *) selectedImageName {
    
    vc.navigationItem.title = nTitle;
    vc.tabBarItem.title = tTitle;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // ----包装导航控制器
    ZPNavigationController *nav = [[ZPNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
    
}

@end

//
//  ZPMeViewController.m
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPMeViewController.h"
#import "ZPVertialButton.h"
#import "ZPLoginRegisterViewController.h"
#import "ZPUserModel.h"
#import "ZPMeCollectionViewController.h"
#import "ZPUserAgreementController.h"

@interface ZPMeViewController () <ZPLoginRegisterViewControllerDelegate, ZPMeCollectionViewControllerDelagate>

/**headerView*/
@property (nonatomic, strong) UIView *headerView;

@property  (strong,nonatomic)  UIImageView  *imageView;

/**头像*/
@property (nonatomic, strong) ZPVertialButton *loginButton;

/**model*/
@property (nonatomic, strong) ZPUserModel *user;

@end

#define HEADER_VIEW_HEIGHT 160

@implementation ZPMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
    
    self.user = [NSKeyedUnarchiver unarchiveObjectWithFile:[localDocumentPath stringByAppendingPathComponent:@"user.data"]];
    [self setupLoginButton];
}

- (void)showIconAndname:(ZPUserModel *)model name:(NSString *)name {
    
    [_loginButton setTitle:name forState:UIControlStateNormal];
    self.user = model;
}

#pragma mark - 初始化headerView
- (void) setupView {
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_VIEW_HEIGHT)];
    _imageView.image = [UIImage imageNamed:@"me_center_1"];
    _imageView.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _imageView.clipsToBounds=YES;
    _imageView.contentMode=UIViewContentModeScaleAspectFill;
    self.headerView = [[UIView alloc] initWithFrame:_imageView.frame];
    [self.headerView addSubview:_imageView];
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - 创建登陆头像
- (void) setupLoginButton {
    
    _loginButton = [[ZPVertialButton alloc] init];
    _loginButton.height = 100;
    _loginButton.width = 70;
    _loginButton.center = self.headerView.center;
    
    UIImageView *imageView = [_loginButton valueForKey:@"imageView"];
    imageView.layer.cornerRadius = 35;
    imageView.layer.masksToBounds = YES;
    
    [_loginButton setImage:[UIImage imageNamed:@"defaultUserIcon" ] forState:UIControlStateNormal];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        [_loginButton setTitle:self.user.user_name forState:UIControlStateNormal];
    } else {
        [_loginButton setTitle:@"请登录" forState:UIControlStateNormal];
    }
    
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:_loginButton];
    
}

#pragma mark - 登陆按钮点击事件
- (void) loginAction {
    
    BOOL ret = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if (ret) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ZPMeCollectionViewController *meVC = [sb instantiateViewControllerWithIdentifier:@"ZPMeCollectionViewController"];
        meVC.user = self.user;
        meVC.delegate = self;
        [self.navigationController pushViewController:meVC animated:YES];
    } else {
        
        ZPLoginRegisterViewController *loginRegister = [[ZPLoginRegisterViewController alloc] init];
        loginRegister.delegate = self;
        
        [self presentViewController:loginRegister animated:YES completion:nil];
    }
    
    
}

- (void)showLoginButtonMessage {
    
    [self.loginButton setTitle:@"请登录" forState:UIControlStateNormal];
}

#pragma mark - 下拉方法headerView效果
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        CGRect rect = self.headerView.frame;
        rect.origin.y = offset.y;
        rect.size.height = CGRectGetHeight(rect) - offset.y;
        self.imageView.frame = rect;
        self.headerView.clipsToBounds = NO;
    }
}

#pragma mark - 提示用户的文本框
- (void) showRemindUserText:(NSString *) text {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    [hud showAnimated:YES whileExecutingBlock:^{
        
        sleep(2);
    } completionBlock:^{
        
        [hud removeFromSuperview];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            
            [self showRemindUserText:@"敬请期待!"];
            break;
        }
        case 1:{
            
            [self showRemindUserText:@"敬请期待!"];
            break;
        }
        case 2:{
            
            [self showRemindUserText:@"敬请期待!"];
            break;
        }
        case 3:{
            
            ZPUserAgreementController *userAgreement = [[ZPUserAgreementController alloc] init];
            [self.navigationController pushViewController:userAgreement animated:YES];
            
            break;
        }
        case 4:{
            // ----清除缓存
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"真的要清除缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            break;  
        }
    }
    
}

@end

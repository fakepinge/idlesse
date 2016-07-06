//
//  ZPMeCollectionViewController.m
//  idlesse
//
//  Created by 胡知平 on 16/6/7.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPMeCollectionViewController.h"
#import "ZPVertialButton.h"
#import "ZPUserModel.h"
#import "ZPMeRequestManager.h"

@interface ZPMeCollectionViewController ()

/**headerView*/
@property (nonatomic, strong) UIView *headerView;

@property  (strong,nonatomic)  UIImageView  *imageView;

/**token*/
@property (nonatomic, copy) NSString *token;
@end

#define HEADER_VIEW_HEIGHT 330

@implementation  ZPMeCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人主页";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
    [self setupLoginButton];
    [self setupLeftItem];
    [self requesttoken];
}

#pragma mark - 初始化headerView
- (void) setupView {
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_VIEW_HEIGHT)];
    _imageView.image = [UIImage imageNamed:@"me_center_2"];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerView = [[UIView alloc] initWithFrame:_imageView.frame];
    [self.headerView addSubview:_imageView];
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - 创建头像
- (void) setupLoginButton {
    

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.layer.cornerRadius = 25;
    imageView.layer.masksToBounds = YES;
    imageView.center = CGPointMake(self.headerView.center.x - 25 , 70);
    imageView.height = 50;
    imageView.width = 50;
       [imageView sd_setImageWithURL:[NSURL URLWithString:self.user.web_url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    [self.headerView addSubview:imageView];
    
    UILabel *nameLable = [[UILabel alloc] init];
    nameLable.center = CGPointMake(self.headerView.center.x - 75, 120);
    nameLable.height = 30;
    nameLable.width = 150;
    nameLable.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:nameLable];
    nameLable.text = self.user.user_name;
    nameLable.font = [UIFont systemFontOfSize:14];
    nameLable.textColor = [UIColor whiteColor];
    nameLable.backgroundColor = [UIColor clearColor];

    
    UILabel *label = [[UILabel alloc] init];
    [self.headerView addSubview:label];
    label.text = [NSString stringWithFormat:@"分数 %@", self.user.score];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(self.headerView.center.x - 75, 150);
    label.height = 20;
    label.width = 150;
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    
    
    ZPVertialButton *leftButton = [[ZPVertialButton alloc] init];
    leftButton.height = 130;
    leftButton.width = 100;
    leftButton.center = CGPointMake(self.headerView.center.x / 2, 250);

    [leftButton setImage:[UIImage imageNamed:@"me_note"] forState:UIControlStateNormal];
    [leftButton setTitle:@"小记" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.headerView addSubview:leftButton];
    
    ZPVertialButton *rightButton = [[ZPVertialButton alloc] init];
    rightButton.height = 130;
    rightButton.width = 100;
    rightButton.center = CGPointMake(self.headerView.center.x / 2 * 3, 250);
    
    [rightButton setImage:[UIImage imageNamed:@"me_music"] forState:UIControlStateNormal];
    [rightButton setTitle:@"歌单" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.headerView addSubview:rightButton];
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

#pragma mark - 创建返回item
- (void) setupLeftItem {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    button.size = CGSizeMake(70, 30);
    [button sizeToFit];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

- (void) back {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 请求token
- (void) requesttoken {
    
    __weak typeof(self) weakSelf = self;
    [[ZPMeRequestManager manager] requestLogincomplete:^(NSString *token, BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.token = token;
        }
        
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
            
            [self showRemindUserText:@"敬请期待!"];
            
            break;
        }
        case 4:{
            
                // ----退出登录
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"真的要退出吗?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
                    
                    [self.delegate showLoginButtonMessage];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    [[NSFileManager defaultManager] removeItemAtPath:[localDocumentPath stringByAppendingPathComponent:@"user.data"] error:nil];
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

@end

//
//  ZPEnjoyReadViewController.m
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPEnjoyReadViewController.h"
#import "ZPReadArticleModel.h"
#import "ZPArticleListCell.h"
#import "ZPBigImageViewController.h"
#import "ZPFavoritesViewController.h"
#import "CBStoreHouseRefreshControl.h"
#import "ZPCustomActivity.h"

@interface ZPEnjoyReadViewController () <ZPArticleListCellDelegate, UIScrollViewDelegate, ZPBigImageViewControllerDelegate, ZPFavoritesViewControllerDelegate>

/**leftButton*/
@property (nonatomic, strong) UIButton *leftButton;
/**rightButton*/
@property (nonatomic, strong) UIButton *rightButton;
/**文章列表模型数组*/
@property (nonatomic, strong) NSMutableArray *articles;

/**数据请求*/
@property (nonatomic, strong) AFHTTPSessionManager *manager;

/**收藏文章的模型数组*/
@property (nonatomic, strong) NSMutableArray *favoritesArray;

/**刷新控件*/
@property (nonatomic, strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;

/**缓存文件地址*/
@property (nonatomic, copy) NSString *localPath;

@end

NSString *const articleListCellIdentifer = @"articleListCell";



@implementation ZPEnjoyReadViewController


#pragma mark - 懒加载
- (NSMutableArray *) articles {
    
    if(!_articles) {
        
        _articles = [NSMutableArray array];
    }
    
    return _articles;
}
#pragma mark - 懒加载
- (NSMutableArray *) favoritesArray {
    
    if(!_favoritesArray) {
        
        _favoritesArray = [NSMutableArray array];
    }
    
    return _favoritesArray;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    // ----初始化tableView
    [self setupTableView];
    // ----初始化button
    [self setupTabBarButton];
    // ----初始化rightItem
    [self setupRightItem];
    // ----数据请求对象
    _manager = [ZPAFNetworkingMangager manager].manager;
    [self requestArticleData];
    [self getPath];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.leftButton.hidden = !self.tabBarController.tabBar.hidden;
    self.rightButton.hidden = !self.tabBarController.tabBar.hidden;
    
    //读取数据 本地或者网络请求
    [self getOutData];
}

#pragma mark - 缓存路径
- (void) getPath {
    
//    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *path = searchPaths.lastObject;
    NSString *savePath = [localCachePath stringByAppendingPathComponent:@"articlesData.data"];
    self.localPath = savePath;
}

#pragma mark - 读取数据 本地或者网络请求
- (void) getOutData {
    
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    Reachability *contect = [Reachability reachabilityForInternetConnection];
    
    if ([wifi currentReachabilityStatus] != NotReachable) {
        
        ZPLog(@"wifi连接");
//        // ----请求数据
//        [self requestArticleData];
    } else if([contect currentReachabilityStatus] != NotReachable){
        
        ZPLog(@"手机流量连接");
//        // ----请求数据
//        [self requestArticleData];
    } else {
        
        ZPLog(@"没有网络");
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:self.localPath];
        ZPLog(@"%@", array);
        [self.articles removeAllObjects];
        [self.articles addObjectsFromArray:array];
        [self.tableView reloadData];
        [self showRemindUserText:@"没有网络连接"];
    }
    
}

#pragma mark - 提示用户的文本框
- (void) showRemindUserText:(NSString *) text {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    [hud showAnimated:YES whileExecutingBlock:^{
        
        sleep(2.5);
    } completionBlock:^{
        
        [hud removeFromSuperview];
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [[_manager operationQueue] cancelAllOperations];
    [SVProgressHUD dismiss];
    
}

#pragma mark - 创建rightItem 
- (void) setupRightItem {
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"favoriteEntranceBtn" highImageName:nil target:self action:@selector(pushFavioursViewController)];
}
- (void) pushFavioursViewController {
    
    ZPFavoritesViewController *favori = [[ZPFavoritesViewController alloc] initWithStyle:UITableViewStylePlain];
    favori.delegate = self;
    favori.favorites = self.favoritesArray;
    [self.navigationController pushViewController:favori animated:YES];
}

#pragma mark - 初始化tableView
- (void) setupTableView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = ZPGlobalBgcolor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZPArticleListCell class]) bundle:nil] forCellReuseIdentifier:articleListCellIdentifer];
    
    // 设置tableView的inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    // ----设置下拉刷新
    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor colorWithRed:0.000 green:0.476 blue:0.759 alpha:1.000] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
}

#pragma mark - 初始化button
- (void) setupTabBarButton {
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setImage:[UIImage imageNamed:@"up_xx"] forState:UIControlStateNormal];
    [_leftButton sizeToFit];
    //_leftButton.translatesAutoresizingMaskIntoConstraints = NO;
    _leftButton.hidden = !self.tabBarController.tabBar.hidden;
    [_leftButton addTarget:self action:@selector(backTop) forControlEvents:UIControlEventTouchUpInside];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setImage:[UIImage imageNamed:@"out_xx"] forState:UIControlStateNormal];
    [_rightButton sizeToFit];
    //_rightButton.translatesAutoresizingMaskIntoConstraints = NO;
    _rightButton.hidden = !self.tabBarController.tabBar.hidden;
    [_rightButton addTarget:self action:@selector(showTabBar) forControlEvents:UIControlEventTouchUpInside];
    
    
    _rightButton.frame = CGRectMake(SCREEN_WIDTH - _rightButton.currentImage.size.width - 10, SCREEN_HEIGHT - _rightButton.currentImage.size.height - 10, _rightButton.currentImage.size.width, _rightButton.currentImage.size.height);
    
    _leftButton.frame = CGRectMake(10, SCREEN_HEIGHT - _leftButton.currentImage.size.height - 10, _rightButton.currentImage.size.width, _rightButton.currentImage.size.height);

    [self.navigationController.view addSubview:_leftButton];
    [self.navigationController.view addSubview:_rightButton];
}
- (void) backTop {
    
    self.tableView.contentOffset = CGPointMake(0, -64);
    [UIView animateWithDuration:1 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}
- (void) showTabBar {
    
    self.tabBarController.tabBar.hidden = NO;
    self.leftButton.hidden = !self.tabBarController.tabBar.hidden;
    self.rightButton.hidden = !self.tabBarController.tabBar.hidden;
}

#pragma mark - 请求数据
- (void) requestArticleData {

    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"daystr"] = enjoyReadingDayStr;
    parameter[@"count"] = @(20);
    
    __weak typeof(self) weakSelf = self;
    [_manager POST:ZPEnjoyReading parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        if ([responseObject count] < 5) {
            
            [weakSelf requestArticleData];
        } else {
            
            [weakSelf.articles removeAllObjects];

            [weakSelf.articles addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ZPReadArticleModel class] json:responseObject]];
            
            // ----数据本地化缓存,覆盖原来的数据
           [NSKeyedArchiver archiveRootObject:weakSelf.articles toFile:self.localPath];
            
            //更新视图
            dispatch_async(dispatch_get_main_queue(), ^{
                // 刷新UITableView
                [weakSelf.tableView reloadData];
            });
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        });

    }];
}

#pragma mark - 下拉刷新的协议方法
- (void) refreshTriggered:(id) sender {
    
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:0.5 inModes:@[NSRunLoopCommonModes]];
}

#pragma mark - Notifying refresh control of scrolling
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

#pragma mark - Listening for the user to trigger a refresh
- (void)finishRefreshControl {

    [self requestArticleData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.storeHouseRefreshControl finishingLoading];
    });
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // ----下拉
    [self.storeHouseRefreshControl scrollViewDidScroll];
    
    self.tabBarController.tabBar.hidden = YES;
    self.leftButton.hidden = !self.tabBarController.tabBar.hidden;
    self.rightButton.hidden = !self.tabBarController.tabBar.hidden;

}

#pragma mark - ZPFavoritesViewControllerDelegate
- (void)reloadDataIndexPath:(NSArray<NSIndexPath *> *)indexPaths {
    ZPLogFunc;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    });
}

#pragma mark - ZPBigImageViewControllerDelegate
- (void)showIsScuess:(BOOL)isScuess {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [XLPromptController showPromptBoxWithText:isScuess?@"保存成功":@"保存失败"];
    });
}

#pragma mark - ZPArticleListCellDelegate
- (void)presentBigImage:(NSString *)realUrl value:(CGFloat) value{
    
    ZPBigImageViewController *bigImageVC = [[ZPBigImageViewController alloc] init];
    bigImageVC.realUrl = realUrl;
    bigImageVC.imageValue = value;
    bigImageVC.delegete = self;
    bigImageVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    bigImageVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:bigImageVC animated:YES completion:nil];
    
}
- (void)showremind {

    [XLPromptController showPromptBoxWithText:@"文字已复制,快去发状态吧"];
    
}
- (void)addArticleModel:(ZPReadArticleModel *)model {
    [XLPromptController showPromptBoxWithText:@"添加收藏成功"];
    [self.favoritesArray addObject:model];
    
}
- (void)removeArticleModel:(ZPReadArticleModel *)model {
    [XLPromptController showPromptBoxWithText:@"取消收藏成功"];
    [self.favoritesArray removeObject:model];

}
- (void) shareContentText:(NSString *)text image:(UIImage *)image  {
    
//
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UMAPPKey
//                                      shareText:text
//                                     shareImage:image
//                                shareToSnsNames:@[UMShareToEmail, UMShareToQzone, UMShareToSms]
//                                       delegate:nil];
    
    SLComposeViewController *svc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    SLComposeViewControllerCompletionHandler myblock = ^(SLComposeViewControllerResult result){
        if(result == SLComposeViewControllerResultCancelled){
            ZPLog(@"cancel");
        }else{
            ZPLog(@"done");
        }
        [svc dismissViewControllerAnimated:YES completion:nil];
    };
    svc.completionHandler = myblock;
    [svc setInitialText:text];
    [svc addImage:image];
    [self presentViewController:svc animated:YES completion:nil];

//    ZPCustomActivity *activity = [[ZPCustomActivity alloc] initWithImage:image atURL:nil atTitle:text atShareContentArray:@[text, image]];
//    UIActivityViewController *shareVC = [[UIActivityViewController alloc]initWithActivityItems:@[text,image] applicationActivities:@[activity]];
//    shareVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeMessage];
//    [self presentViewController:shareVC animated:YES completion:nil];
    
}

- (void)reportMessageModel:(ZPReadArticleModel *)model {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"举报" message:@"不宜出现在『闲时』上,你确定要屏蔽该条信息？" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         
         [weakSelf.articles removeObject:model];
         [weakSelf.tableView reloadData];
     }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.articles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZPArticleListCell *cell = [tableView dequeueReusableCellWithIdentifier:articleListCellIdentifer forIndexPath:indexPath];
    
    ZPReadArticleModel *model = self.articles[indexPath.row];
    model.indexPath = indexPath;
    cell.articleModel = model;
    
    CGFloat scale = model.Width / (SCREEN_WIDTH - 20) * 1.0f;
    CGFloat imageHeight = model.Height / scale * 1.0f;
    cell.articleImageViewHieghtConstraints.constant = imageHeight;
    cell.delegate = self;
    
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZPReadArticleModel *model = self.articles[indexPath.row];

    CGFloat labelHeight = [model.Title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    
    CGFloat scale = model.Width / (SCREEN_WIDTH - 20) * 1.0f;
    CGFloat imageHeight = model.Height / scale * 1.0f;
    
    return labelHeight + imageHeight + 70;
}





@end

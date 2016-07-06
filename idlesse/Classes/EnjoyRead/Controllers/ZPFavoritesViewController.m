//
//  ZPFavoritesViewController.m
//  idlesse
//
//  Created by 胡知平 on 16/6/2.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPFavoritesViewController.h"
#import "ZPArticleListCell.h"
#import "ZPReadArticleModel.h"

@interface ZPFavoritesViewController () <ZPArticleListCellDelegate>


@property (nonatomic, strong) UILabel *nofavoritesLabel;

/**取消收藏的cell的下标数组*/
@property (nonatomic, strong) NSMutableArray *indexPaths;

@end

NSString *const favoritesCellIdentifier = @"favorites";

@implementation ZPFavoritesViewController


#pragma mark - 懒加载
- (NSMutableArray *) favorites {
    
    if(!_favorites) {
        
        _favorites = [NSMutableArray array];
    }
    
    return _favorites;
}
#pragma mark - 懒加载
- (NSMutableArray *) indexPaths {
    
    if(!_indexPaths) {
        
        _indexPaths = [NSMutableArray array];
    }
    
    return _indexPaths;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的收藏";
    [self setupLeftItem];
    [self setupRightItem];
    [self setupTableView];
    [self setupNoFavoritesView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self isShowLabelAndRight];
    
}

#pragma mark - 是否显示暂无收藏和清空按钮
- (void) isShowLabelAndRight {
    
    if (self.favorites.count == 0) {
        self.nofavoritesLabel.hidden = NO;
        self.tableView.scrollEnabled = NO;
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    } else {
        self.nofavoritesLabel.hidden = YES;
        self.tableView.scrollEnabled = YES;
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }
    
}

#pragma mark - 创建没有收藏的显示的View
- (void) setupNoFavoritesView {
    
    _nofavoritesLabel = [[UILabel alloc] init];
    [self.view addSubview:_nofavoritesLabel];
    _nofavoritesLabel.textAlignment = NSTextAlignmentCenter;
    _nofavoritesLabel.hidden = YES;
    _nofavoritesLabel.textColor = [UIColor lightGrayColor];
    _nofavoritesLabel.text = @"暂无收藏";
    _nofavoritesLabel.frame = SCREEN_FRAME;
    _nofavoritesLabel.height -= 64;
}

#pragma mark - 创建rightItem
- (void) setupRightItem {
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"trash" highImageName:nil target:self action:@selector(isRemoveAllFavorites)];
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    
}

- (void) isRemoveAllFavorites {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"确定把所有收藏的美文都吗？" preferredStyle:UIAlertControllerStyleAlert];
    
     __weak typeof(self) weakSelf = self;
    UIAlertAction *cleanAction = [UIAlertAction actionWithTitle:@"立即清空" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf.favorites enumerateObjectsUsingBlock:^(ZPReadArticleModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.isFavorite = NO;
        }];
        
        // ----添加到下标数组中
        [weakSelf.favorites enumerateObjectsUsingBlock:^(ZPReadArticleModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
           
            [weakSelf.indexPaths addObject:model.indexPath];
            
        }];
        [weakSelf.favorites removeAllObjects];
        
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView reloadData];
            [weakSelf isShowLabelAndRight];
        });
    }];
    
    UIAlertAction *noCleanAction = [UIAlertAction actionWithTitle:@"我点错了" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:cleanAction];
    [alert addAction:noCleanAction];
    [self presentViewController:alert animated:YES completion:nil];
    
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
    
    [self.delegate reloadDataIndexPath:self.indexPaths];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 在初始化tableView 
- (void) setupTableView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = ZPGlobalBgcolor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZPArticleListCell class]) bundle:nil] forCellReuseIdentifier:favoritesCellIdentifier];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.favorites.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZPReadArticleModel *model = self.favorites[indexPath.row];
    
    CGFloat labelHeight = [model.Title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    
    CGFloat scale = model.Width / (SCREEN_WIDTH - 20) * 1.0f;
    CGFloat imageHeight = model.Height / scale * 1.0f;
    
    return labelHeight + imageHeight + 63;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZPArticleListCell *cell = [tableView dequeueReusableCellWithIdentifier:favoritesCellIdentifier forIndexPath:indexPath];
    
    ZPReadArticleModel *model = self.favorites[indexPath.row];
    cell.articleModel = model;
    cell.favoritesButton.selected = YES;
    CGFloat scale = model.Width / (SCREEN_WIDTH - 20) * 1.0f;
    CGFloat imageHeight = model.Height / scale * 1.0f;
    cell.articleImageViewHieghtConstraints.constant = imageHeight;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - ZPArticleListCellDelegate
- (void)showremind {
    
    [XLPromptController showPromptBoxWithText:@"文字已复制,快去发状态吧"];
}



- (void)removeArticleModel:(ZPReadArticleModel *)model {
    
    
    for (ZPReadArticleModel *faModel in self.favorites) {
        
        if ([faModel.ItemID isEqualToString:model.ItemID] ) {
            faModel.isFavorite = NO;
            [self.favorites removeObject:faModel];
            // ----添加到下标数组中
            [self.indexPaths addObject:faModel.indexPath];
            break;
        }
    }
    __weak typeof(self) weakSelf = self;
   dispatch_async(dispatch_get_main_queue(), ^{
       
       [weakSelf.tableView reloadData];
       [self isShowLabelAndRight];
   });
}


- (void) shareContentText:(NSString *)text image:(UIImage *)image  {
    
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
    
}



@end

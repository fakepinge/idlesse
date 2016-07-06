//
//  ZPMoiveViewController.m
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPMoiveViewController.h"
#import "ZPMovieListModel.h"
#import "ZPMovieListCell.h"
#import "ZPMovieDetailViewController.h"

@interface ZPMoiveViewController ()

/**电影模型数组*/
@property (nonatomic, strong) NSMutableArray *movies;
/**请求数据对象*/
@property (nonatomic, strong) AFHTTPSessionManager *manager;

/**电影的id*/
@property (nonatomic, copy) NSString *movieId;

@end

NSString *const movieListCellIdentifer = @"movieListCell";

@implementation ZPMoiveViewController

#pragma mark - 懒加载
- (NSMutableArray *) movies {
    
    if(!_movies) {
        
        _movies = [NSMutableArray array];
    }
    
    return _movies;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    //[self setupRefreshButton];
    [self requestMovieData:self.movieId];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[_manager operationQueue] cancelAllOperations];
    [SVProgressHUD dismiss];
    
}

#pragma mark - 初始化tableView
- (void) setupTableView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = ZPGlobalBgcolor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZPMovieListCell class]) bundle:nil] forCellReuseIdentifier:movieListCellIdentifer];
    
    // 设置tableView的inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    self.tableView.rowHeight = 145;
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.movieId = @"0";
        [weakSelf.movies removeAllObjects];
        [weakSelf requestMovieData:self.movieId];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf requestMovieData:self.movieId];
    }];
    
    // 显示指示器
    [SVProgressHUD show];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    
    _manager = [ZPAFNetworkingMangager manager].manager;
    self.movieId = @"0";
    
}

//#pragma mark - 定制刷新按钮
//- (void) setupRefreshButton {
//    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"refresh" highImageName:nil target:self action:@selector(refreshData)];
//    
//}
//
//- (void) refreshData {
//    
//    // 显示指示器
//    [SVProgressHUD show];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
//    self.tableView.contentOffset = CGPointMake(0, 0);
//    self.movieId = @"0";
//    [self.movies removeAllObjects];
//    [self requestMovieData:self.movieId];
//    
//    
//}

#pragma mark - 请求数据
- (void) requestMovieData:(NSString *) movieId{
    
    NSString *requestStr = [NSString stringWithFormat:ZPMoiveList, movieId];
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:requestStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
  
        [SVProgressHUD dismiss];
        NSArray *array = [NSArray yy_modelArrayWithClass:[ZPMovieListModel class] json:responseObject[@"data"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (array.count == 0) {
                
                 [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            [weakSelf.movies addObjectsFromArray:array];
            weakSelf.movieId = [array.lastObject movieId];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            
        });

    }];
    
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    tableView.mj_footer.hidden = self.movies.count ? NO : YES;
    return self.movies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPMovieListCell *cell = [tableView dequeueReusableCellWithIdentifier:movieListCellIdentifer forIndexPath:indexPath];
    
    cell.model = self.movies[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZPMovieDetailViewController *movieDetail = [[ZPMovieDetailViewController alloc] init];
    movieDetail.movieId = [self.movies[indexPath.row] movieId];
    movieDetail.movieTitle = [self.movies[indexPath.row] title];
    movieDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:movieDetail animated:YES];
}



@end

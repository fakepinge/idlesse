//
//  ZPMusicViewController.m
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPMusicViewController.h"
#import "ZPMusicNewsCell.h"
#import "ZPEquipmentOrStrategyCell.h"
#import "ZPMusicRequestManager.h"
#import "DVSwitch.h"
#import "ZPMusicNewsDetailController.h"
#import "ZPMusicNewsModel.h"



@interface ZPMusicViewController () <UITableViewDelegate, UITableViewDataSource>

#pragma mark - scrollView和三个tableView属性
/**scroolView*/
@property (weak, nonatomic) IBOutlet UIScrollView *musicScrollView;
@property (weak, nonatomic) IBOutlet UIView *segmentView;

@property (weak, nonatomic) IBOutlet UITableView *musicNewsTableView;
@property (weak, nonatomic) IBOutlet UITableView *musicEquipmentTableView;
@property (weak, nonatomic) IBOutlet UITableView *musicStrategyTableView;
/**DVSwitch*/
@property (nonatomic, strong) DVSwitch *segmentSwitch;
/**当前下标*/
@property (nonatomic, assign) NSInteger currentIndex;


/**第一个当前页*/
@property (nonatomic, assign) NSInteger firstCurrentPage;
/**第二个当前页*/
@property (nonatomic, assign) NSInteger secondCurrentPage;
/**第三个当前页*/
@property (nonatomic, assign) NSInteger thirdCurrentPage;

/**第一个数组元*/
@property (nonatomic, strong) NSArray *firstModelArray;
/**第二个数组元*/
@property (nonatomic, strong) NSArray *secondModelArray;
/**第三个数组元*/
@property (nonatomic, strong) NSArray *thirdModelArray;

/**缓存路径*/
@property (nonatomic, copy) NSString *musicFirstDataPath;
@property (nonatomic, copy) NSString *musicSecondDataPath;
@property (nonatomic, copy) NSString *musicThirdDataPath;
@end

NSString *const musicNewsIdentifier = @"first";
NSString *const musicEquipmentIdentifier = @"second";
NSString *const musicStrategyIdentifier = @"third";


@implementation ZPMusicViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZPGlobalBgcolor;
    [self setupTableView];
    [self addGeGesture];
    [self setupSwitch];
    [self setupRefreshButton];
    
//    self.musicNewsTableView.mj_footer.hidden = YES;
//    self.musicEquipmentTableView.mj_footer.hidden = YES;
//    self.musicStrategyTableView.mj_footer.hidden = YES;
    [self requestFirstDataPage:self.firstCurrentPage type:musicNewsType];
    [self getPath];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.musicScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * self.currentIndex, 0);
    [self getOutData];
}


#pragma mark - 缓存路径
- (void) getPath {
    
    NSString *saveFirstPath = [localCachePath stringByAppendingPathComponent:@"musicFirstData.data"];
    NSString *saveSecondPath = [localCachePath stringByAppendingPathComponent:@"musicSecondData.data"];
    NSString *saveThirdPath = [localCachePath stringByAppendingPathComponent:@"musicThirdData.data"];
    self.musicFirstDataPath = saveFirstPath;
    self.musicSecondDataPath = saveSecondPath;
    self.musicThirdDataPath = saveThirdPath;
    ZPLog(@"%@", localCachePath);
}

#pragma mark - 读取数据 本地或者网络请求
- (void) getOutData {
    
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    Reachability *contect = [Reachability reachabilityForInternetConnection];
    
    if ([wifi currentReachabilityStatus] != NotReachable) {
        
        ZPLog(@"wifi连接");
    } else if([contect currentReachabilityStatus] != NotReachable){
        
        ZPLog(@"手机流量连接");
    } else {
        
        if (self.currentIndex == 0) {
           
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:self.musicFirstDataPath];
            self.firstModelArray = array;
            [self.musicNewsTableView reloadData];
        } else if(self.currentIndex == 1) {
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:self.musicSecondDataPath];
            self.secondModelArray = array;
            [self.musicEquipmentTableView reloadData];
        } else {
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:self.musicThirdDataPath];
            self.thirdModelArray = array;
            [self.musicStrategyTableView reloadData];
        }
        [self showRemindUserText:@"没有网络连接"];
    }
}
#pragma mark - 提示用户的文本框
- (void) showRemindUserText:(NSString *) text {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = text;
    hud.yOffset = 50;
    hud.mode = MBProgressHUDModeText;
    [hud showAnimated:YES whileExecutingBlock:^{
        
        sleep(2.5);
    } completionBlock:^{
        
        [hud removeFromSuperview];
    }];
}


#pragma mark - DVSwitch
- (void) setupSwitch {
    
    self.segmentSwitch = [[DVSwitch alloc] initWithStringsArray:@[@"乐坛资讯", @"装备测评", @"攻略知识"]];
    __weak typeof(self) weakSelf = self;
    self.segmentSwitch.size = CGSizeMake(SCREEN_WIDTH - 40, 38);
    self.segmentSwitch.x = 20;
    self.segmentSwitch.y = 1;
    self.segmentSwitch.backgroundColor = [UIColor whiteColor];
    self.segmentSwitch.font = [UIFont systemFontOfSize:16];
    self.segmentSwitch.sliderColor = ZPRGBColor(58, 61, 255);
    self.segmentSwitch.labelTextColorOutsideSlider =  ZPRGBColor(58, 61, 255);
    self.segmentSwitch.labelTextColorInsideSlider = [UIColor whiteColor];
    [self.segmentView addSubview:self.segmentSwitch];
    [self.segmentSwitch setPressedHandler:^(NSUInteger index) {
        
        [weakSelf segmentVslueChanged:index];
        
    }];
}

#pragma mark - 初始化tableView
- (void) setupTableView {
    
    [self.musicNewsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZPMusicNewsCell class]) bundle:nil] forCellReuseIdentifier:musicNewsIdentifier];
    [self.musicEquipmentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZPEquipmentOrStrategyCell class]) bundle:nil] forCellReuseIdentifier:musicEquipmentIdentifier];
    [self.musicStrategyTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZPEquipmentOrStrategyCell class]) bundle:nil] forCellReuseIdentifier:musicStrategyIdentifier];
    
    [self setupRefresh];
}

- (void) remind {
    
    [SVProgressHUD show];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
}

#pragma mark - 实现tableView之间的切换
- (void)segmentVslueChanged:(NSUInteger) index {
    
    self.currentIndex = index;
    [self didOffset];
}

- (void) didOffset {
    
 
    [UIView animateWithDuration:0.5 animations:^{
 
        self.musicScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * self.currentIndex, 0);
    }];
    
    switch (self.currentIndex) {
        case 0:{
            if (self.firstModelArray) return;
            [self requestFirstDataPage:self.firstCurrentPage type:musicNewsType];
            [self getOutData];
            break;
        }
        case 1:{
            if (self.secondModelArray) return;
            [self requestSecondDataPage:self.secondCurrentPage type:musicEquipmentType];
            [self getOutData];
            break;
        }
        case 2:{
            if (self.thirdModelArray) return;
            [self requestThirdDataPage:self.thirdCurrentPage type:musicStrategyType];
            [self getOutData];
            break;
        }
        default:
            break;
    }
    
}

- (void) addGeGesture {
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipe.numberOfTouchesRequired = 1;
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    rightSwipe.numberOfTouchesRequired = 1;
    
    self.musicScrollView.gestureRecognizers = @[leftSwipe, rightSwipe];
    
}

- (void) leftSwipe:(UISwipeGestureRecognizer *) sender {
    
    NSInteger index = self.currentIndex + 1;
    
    if (index > 3 - 1) {
        
        self.currentIndex = 3 - 1;
    } else {
        
        self.currentIndex = index;
    }
    
    [self.segmentSwitch forceSelectedIndex:self.currentIndex animated:YES];
    [self didOffset];
    
}

- (void) rightSwipe:(UISwipeGestureRecognizer *) sender {
    
    NSInteger index = self.currentIndex - 1;
    
    if (index < 0) {
        
        self.currentIndex = 0;
    } else {
        
        self.currentIndex = index;
    }
    
    [self.segmentSwitch forceSelectedIndex:self.currentIndex animated:YES];
    [self didOffset];
    
    
}

#pragma mark - 定制刷新按钮
- (void) setupRefreshButton {
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"refresh" highImageName:nil target:self action:@selector(refreshData)];
    
}

- (void) refreshData {
    
    switch (self.segmentSwitch.selectedIndex) {
        case 0:{
            
            self.firstCurrentPage = 0;
            [self requestFirstDataPage:self.firstCurrentPage type:musicNewsType];
            self.musicNewsTableView.contentOffset = CGPointMake(0, 0);
            break;
        }
        case 1:{
            
            self.secondCurrentPage = 0;
            [self requestSecondDataPage:self.secondCurrentPage type:musicEquipmentType];
             self.musicEquipmentTableView.contentOffset = CGPointMake(0, 0);
            break;
        }
        case 2:{
            
            self.thirdCurrentPage = 0;
            [self requestThirdDataPage:self.thirdCurrentPage type:musicStrategyType];
            self.musicStrategyTableView.contentOffset = CGPointMake(0, 0);
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - tableView 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count;
    if (tableView.tag == 101) {
        
        count = self.firstModelArray.count;
    } else if(tableView.tag == 102) {
        
        count = self.secondModelArray.count;
    } else if (tableView.tag == 103) {
        
        count = self.thirdModelArray.count;
    }
    
    tableView.mj_footer.hidden = count ? NO : YES;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 101) {
        
        return 345;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 101) {
        
        ZPMusicNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:musicNewsIdentifier forIndexPath:indexPath];
        
        cell.model = self.firstModelArray[indexPath.row];
        
        return cell;
    } else if (tableView.tag == 102) {
        
        ZPEquipmentOrStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:musicEquipmentIdentifier forIndexPath:indexPath];
       
        cell.model = self.secondModelArray[indexPath.row];
        return cell;
    } else if (tableView.tag == 103) {
        
        ZPEquipmentOrStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:musicStrategyIdentifier forIndexPath:indexPath];

        cell.model = self.thirdModelArray[indexPath.row];
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZPMusicNewsModel *model;
    if (tableView.tag == 101) {
        
        model = self.firstModelArray[indexPath.row];
    } else if (tableView.tag == 102) {
        
        model = self.secondModelArray[indexPath.row];
    } else {
        
        model = self.thirdModelArray[indexPath.row];
    }
    ZPMusicNewsDetailController *detail = [[ZPMusicNewsDetailController alloc] init];
    detail.musicNewsId = [NSString stringWithFormat:@"%ld", model.ID];
    
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}

#pragma mark - 请求数据
- (void) requestFirstDataPage:(NSInteger) page type:(NSString *) type {
    
    [self remind];
    [[ZPMusicRequestManager manager] requestDataPage:page type:type complete:^(NSArray *modelArray, NSInteger count, BOOL isSuccess) {
        
        [SVProgressHUD dismiss];
        if (!isSuccess) {
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.musicNewsTableView.mj_footer endRefreshing];
                //weakSelf.musicNewsTableView.mj_footer.hidden = NO;
            });
            return;
        }
        
        
        if (self.firstModelArray.count == count) {
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.musicNewsTableView.mj_footer endRefreshingWithNoMoreData];
                //weakSelf.musicNewsTableView.mj_footer.hidden = NO;
            });
            return;
        }
        self.firstModelArray = [modelArray copy];
        
        // ----归档到本地
        [NSKeyedArchiver archiveRootObject:self.firstModelArray toFile:self.musicFirstDataPath];
        
        self.firstCurrentPage += 1;
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [weakSelf.musicNewsTableView.mj_footer endRefreshing];
            //weakSelf.musicNewsTableView.mj_footer.hidden = NO;
            [weakSelf.musicNewsTableView reloadData];
        });
        
    }];
}

- (void) requestSecondDataPage:(NSInteger) page type:(NSString *) type {
    
    [self remind];
    [[ZPMusicRequestManager manager] requestDataPage:page type:type complete:^(NSArray *modelArray, NSInteger count, BOOL isSuccess) {
        
        [SVProgressHUD dismiss];
        if (!isSuccess) {
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.musicEquipmentTableView.mj_footer endRefreshing];
                //weakSelf.musicEquipmentTableView.mj_footer.hidden = NO;
            });
            return;
        }
        
        
        if (self.secondModelArray.count == count) {
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.musicEquipmentTableView.mj_footer endRefreshingWithNoMoreData];
                //weakSelf.musicEquipmentTableView.mj_footer.hidden = NO;
                
            });
            return;
        }
        
        self.secondModelArray = [modelArray copy];
        // ----归档到本地
        [NSKeyedArchiver archiveRootObject:self.secondModelArray toFile:self.musicSecondDataPath];
        
        self.secondCurrentPage += 1;
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [weakSelf.musicEquipmentTableView.mj_footer endRefreshing];
            //weakSelf.musicEquipmentTableView.mj_footer.hidden = NO;
            [weakSelf.musicEquipmentTableView reloadData];
        });
        
    }];
}

- (void) requestThirdDataPage:(NSInteger) page type:(NSString *) type {
    
    [self remind];
    [[ZPMusicRequestManager manager] requestDataPage:page type:type complete:^(NSArray *modelArray, NSInteger count, BOOL isSuccess) {
        
        [SVProgressHUD dismiss];
        if (!isSuccess) {
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.musicStrategyTableView.mj_footer endRefreshing];
               // weakSelf.musicStrategyTableView.mj_footer.hidden = NO;
            });
            return;
        }
        
        if (self.thirdModelArray.count == count) {
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.musicStrategyTableView.mj_footer endRefreshingWithNoMoreData];
                //weakSelf.musicStrategyTableView.mj_footer.hidden = NO;
                
            });
            return;
        }
        
        self.thirdModelArray = [modelArray copy];
        // ----归档到本地
        [NSKeyedArchiver archiveRootObject:self.thirdModelArray toFile:self.musicThirdDataPath];
        self.thirdCurrentPage += 1;
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [weakSelf.musicStrategyTableView.mj_footer endRefreshing];
           // weakSelf.musicStrategyTableView.mj_footer.hidden = NO;
            [weakSelf.musicStrategyTableView reloadData];
        });
        
    }];
}

#pragma mark - 上拉加载更多
- (void) setupRefresh {
    
    __weak typeof(self) weakSelf = self;
    self.musicNewsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf requestFirstDataPage:self.firstCurrentPage type:musicNewsType];
    }];
    self.musicEquipmentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf requestSecondDataPage:self.secondCurrentPage type:musicEquipmentType];
    }];
    self.musicStrategyTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf requestThirdDataPage:self.thirdCurrentPage type:musicStrategyType];
    }];
}



@end

//
//  ZPMovieDetailViewController.m
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPMovieDetailViewController.h"
#import "ZPMovieDetailModel.h"
#import "ZPMovieStoryModel.h"
#import "ZPMovieCommentModel.h"
#import "ZPMovieCommentCell.h"
#import "ZPMoviePlayerViewController.h"
#import "ZPOtherUserMessageController.h"
#import "ZPUserModel.h"

@interface ZPMovieDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, ZPMovieCommentCellDalegate>

/**请求数据对象*/
@property (nonatomic, strong) AFHTTPSessionManager *manager;

#pragma mark - 电影View
/**电影详情model*/
@property (nonatomic, strong) ZPMovieDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *scoreOfImageLabel;

#pragma mark - 故事view
/**故事的总数量*/
@property (nonatomic, copy) NSString *storyCount;
/**故事的模型*/
@property (nonatomic, strong) ZPMovieStoryModel *storyModel;

@property (weak, nonatomic) IBOutlet UILabel *storyCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *stroyContentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stroyContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *datelabel;
/**点赞数喜欢数*/
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

#pragma mark - 电影表View

@property (weak, nonatomic) IBOutlet UILabel *movieTableTitleTabel;
@property (weak, nonatomic) IBOutlet UIButton *keyButton;
@property (weak, nonatomic) IBOutlet UIButton *phtotButton;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;

@property (weak, nonatomic) IBOutlet UIView *movieView;

/**keyView*/
@property (nonatomic, strong) UIView *keyView;
/**detailView*/
@property (nonatomic, strong) UILabel *detailView;
@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;




#pragma mark - 评论tableView
/**当前页数*/
@property (nonatomic, copy) NSString *commentId;
/**评论的总数量*/
@property (nonatomic, assign) NSInteger commentCount;
/**电影评论模型数组*/
@property (nonatomic, strong) NSMutableArray *movieComments;

@property (strong, nonatomic) IBOutlet UITableView *commentTableView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstrint;


@end

static NSString * const movieCommentCellIdentifier = @"movieCommentCell";

@implementation ZPMovieDetailViewController

#pragma mark - 电影View上的button事件
- (IBAction)buyAction:(UIButton *)sender {
    
    [self showRemindUserText:@"敬请期待"];
}
- (IBAction)evaluationScoreAction:(UIButton *)sender {
    
    [self showRemindUserText:@"敬请期待"];
}
- (IBAction)shareAction:(UIButton *)sender {
    NSString *appName = @"『闲时』";
    NSString *webUrl = self.detailModel.web_url;
    NSString *title = [NSString stringWithFormat:@"%@ 电影《%@》 %@", appName, self.detailModel.title, webUrl];
    
//    NSArray *activityItems = @[appName, title, webUrl];
//    UIActivityViewController *shareVC = [[UIActivityViewController alloc]initWithActivityItems:@[activityItems] applicationActivities:nil];
////    shareVC.excludedActivityTypes = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr];
//    [self presentViewController:shareVC animated:YES completion:nil];
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
    [svc setInitialText:title];
    [svc addImage:self.movieImageView.image];
    [self presentViewController:svc animated:YES completion:nil];
    
}
// ----播放视频
- (void) playMovieVideo:(UITapGestureRecognizer *) tap {
    ZPLogFunc;
    ZPMoviePlayerViewController *playerVC = [[ZPMoviePlayerViewController alloc] init];
    playerVC.videoString = self.detailModel.video;
    [self.navigationController pushViewController:playerVC animated:YES];
    
}

#pragma mark - 故事view上的事件
- (IBAction)storyHeaderButtonAction:(UIButton *)sender {
    ZPLogFunc;
}
// ----进入全部故事界面
- (IBAction)storyFooterAllAction:(UIButton *)sender {
   [self showRemindUserText:@"敬请期待"];
}

- (void) otherUserMessage {
 
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZPOtherUserMessageController *otherVC = [sb instantiateViewControllerWithIdentifier:@"ZPOtherUserMessageController"];
    otherVC.userId = self.storyModel.user.user_id;
    [self.navigationController pushViewController:otherVC animated:YES];
    
}

- (IBAction)likerAction:(UIButton *)sender {
    
    if (sender.selected == NO) {
        
        sender.selected = YES;
        self.likeLabel.text = [NSString stringWithFormat:@"%ld", [self.likeLabel.text integerValue] + 1];
    } else {
        
        sender.selected = NO;
        self.likeLabel.text = [NSString stringWithFormat:@"%ld", [self.likeLabel.text integerValue] - 1];
    }
}


#pragma mark - 电影表View上的事件
- (IBAction)keyAction:(UIButton *)sender {
    
    sender.selected = YES;
    self.detailButton.selected = NO;
    self.phtotButton.selected = NO;
    self.movieTableTitleTabel.text = @"一个电影表";
    self.keyView.hidden = NO;
    self.detailView.hidden = YES;
    self.photoScrollView.hidden = YES;
}
- (IBAction)photoAction:(UIButton *)sender {
    
    sender.selected = YES;
    self.detailButton.selected = NO;
    self.keyButton.selected = NO;
    self.movieTableTitleTabel.text = @"剧照";
    self.keyView.hidden = YES;
    self.detailView.hidden = YES;
    self.photoScrollView.hidden = NO;
    
}
- (IBAction)detailAction:(UIButton *)sender {
    
    sender.selected = YES;
    self.keyButton.selected = NO;
    self.phtotButton.selected = NO;
    self.movieTableTitleTabel.text = @"演职人员";
    self.keyView.hidden = YES;
    self.detailView.hidden = NO;
    self.photoScrollView.hidden = YES;
}


#pragma mark - 评论按钮
- (IBAction)commentAction:(UIButton *)sender {
    [self showRemindUserText:@"敬请期待"];
}


#pragma mark - 懒加载
- (NSMutableArray *) movieComments {
    
    if(!_movieComments) {
        
        _movieComments = [NSMutableArray array];
    }
    
    return _movieComments;
}
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftItem];
    self.title = self.movieTitle;
    self.view.backgroundColor = ZPGlobalBgcolor;
    self.commentId = @"0";
    self.keyButton.selected = YES;
    // ----初始化评论tableView
    [self setupTableView];
    // ----电影图片添加事件
    [self movieImageAddGesture];
    [self iconImageAddGesture];
    // ----请求电影详情
    [self requestMovieData:self.movieId];
    // ----加载电影表的View
    [self setupView];
    // ----请求one故事
    [self requestoneStoryData:self.movieId];
    // ----请求评论数据
    [self requestoneMovieCommentData:self.movieId page:self.commentId];
    
    
}

#pragma mark - 用户头像添加单击手势
- (void) iconImageAddGesture{
    
    UITapGestureRecognizer *tapHandel = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(otherUserMessage)];
    [self.userIconImageView addGestureRecognizer:tapHandel];
}
#pragma mark - 电影图片添加单击手势
- (void) movieImageAddGesture {
    
    UITapGestureRecognizer *tapHandel = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(playMovieVideo:)];
    [self.movieImageView addGestureRecognizer:tapHandel];
    
}

#pragma mark - 加载电影表的View
- (void) setupView {
    
    self.keyView = [[NSBundle mainBundle] loadNibNamed:@"ZPMovieKeyView" owner:nil options:nil].firstObject;
    [self.movieView addSubview: self.keyView];
     self.keyView.layer.borderWidth = 2;
     self.keyView.layer.borderColor = ZPRGBColor(139, 180, 249).CGColor;
     self.keyView.layer.masksToBounds = YES;
    
    UIView *view = self.keyView.subviews.firstObject;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = ZPRGBColor(139, 180, 249).CGColor;
    view.layer.masksToBounds = YES;
    for (UILabel *label in self.keyView.subviews.firstObject.subviews) {
        
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = ZPRGBColor(139, 180, 249).CGColor;
        label.layer.masksToBounds = YES;
    }
    
   
    __weak typeof(self) weakSelf = self;
    
    [ self.keyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(weakSelf.movieView);
    }];
    
    _detailView = [[NSBundle mainBundle] loadNibNamed:@"ZPDetailView" owner:nil options:nil].firstObject;
    [self.movieView addSubview:_detailView];
    _detailView.hidden = YES;
    
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(weakSelf.movieView);
    }];
    
    // 初始化scrollView
    self.photoScrollView.hidden = YES;
    
}
#pragma mark - 创建返回item
- (void) setupLeftItem {
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"电影" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    button.size = CGSizeMake(70, 30);
    [button sizeToFit];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.manager = [ZPAFNetworkingMangager manager].manager;
}

#pragma mark - 返回上一级界面
- (void) back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 提示用户的文本框
- (void) showRemindUserText:(NSString *) text {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    hud.yOffset = 50;
    [hud showAnimated:YES whileExecutingBlock:^{
        
        sleep(2);
    } completionBlock:^{
        
        [hud removeFromSuperview];
    }];
}

#pragma mark - 初始化tableView
- (void) setupTableView {
    
   [self.commentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZPMovieCommentCell class]) bundle:nil] forCellReuseIdentifier:movieCommentCellIdentifier];
    
    UILongPressGestureRecognizer * ge =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cancelScroll:)];
    [ge setDelegate:self];
    [ge setMinimumPressDuration:0.1];//这里为了让他在tableview还是能够进行整个scroll的拖动所以用了0.1给用户一个快速拖动
    [self.commentTableView addGestureRecognizer:ge];
    
    __weak typeof(self) weakSelf = self;
    self.commentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

        //weakSelf.commentTableView.mj_footer.hidden = NO;
        [weakSelf requestoneMovieCommentData:self.movieId page:self.commentId];
        [[SDImageCache sharedImageCache] clearMemory];
    }];
    

}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //切记这个代理必须要设置、因为scroll的拖动说白了也是一个gesture、为了流畅性必须要两个触碰事件同时触发
    return YES;
}
-(void)cancelScroll:(UIGestureRecognizer*)gesture
{
    //这里就是让背景的拖动定死这样就不冲突了
    if ([gesture state]==UIGestureRecognizerStateBegan) {
        [self.scrollView setScrollEnabled:NO];
    }
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //拖动完再恢复
    [self.scrollView setScrollEnabled:YES];
}



#pragma mark - 请求电影详情数据
- (void) requestMovieData:(NSString *) movieId{
    
    NSString *requestStr = [NSString stringWithFormat:ZPMoiveDetail, movieId];
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:requestStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        weakSelf.detailModel = [ZPMovieDetailModel yy_modelWithDictionary:responseObject[@"data"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        });
    }];
    
    
}

#pragma mark - 请求一个故事数据
- (void) requestoneStoryData:(NSString *) movieId{
    
    NSString *requestStr = [NSString stringWithFormat:ZPMovieOneStory, movieId];
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:requestStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        weakSelf.storyCount = responseObject[@"data"][@"count"];
        NSDictionary *modelDict = [responseObject[@"data"][@"data"] firstObject];
        weakSelf.storyModel = [ZPMovieStoryModel yy_modelWithDictionary:modelDict];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
       dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
       });
        
    }];
    
}

#pragma mark - 请求电影评论数据
- (void) requestoneMovieCommentData:(NSString *) movieId page:(NSString *) page{
    
    NSString *requestStr = [NSString stringWithFormat:ZPMovieComment, movieId, page];
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:requestStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        NSArray *commnetArray = [NSArray yy_modelArrayWithClass:[ZPMovieCommentModel class] json:responseObject[@"data"][@"data"]];
        weakSelf.commentId = [commnetArray.lastObject ID];
        [weakSelf.movieComments addObjectsFromArray:commnetArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if ((commnetArray.count == 0)) {
                
                 [weakSelf.commentTableView.mj_footer endRefreshingWithNoMoreData];
                
            } else {
                
                [weakSelf.commentTableView reloadData];
                [weakSelf.commentTableView.mj_footer endRefreshing];
                
            }

        });

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            [weakSelf.commentTableView.mj_footer endRefreshing];
            
        });

    }];
    
}

#pragma mark - cell的协议方法
- (void)pushOtherUserMessage:(NSString *)userId {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZPOtherUserMessageController *otherVC = [sb instantiateViewControllerWithIdentifier:@"ZPOtherUserMessageController"];
    otherVC.userId = userId;
    [self.navigationController pushViewController:otherVC animated:YES];
}

#pragma mark - UItableViewData UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    tableView.mj_footer.hidden = self.movieComments.count ? NO : YES;
    return self.movieComments.count;

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZPMovieCommentModel *model = self.movieComments[indexPath.row];
    CGFloat labelHeight = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 85, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    
    return 70 + labelHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZPMovieCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:movieCommentCellIdentifier forIndexPath:indexPath];

    cell.model = self.movieComments[indexPath.row];
    cell.delegate = self;
    return cell;
}


#pragma mark - 重写电影详情model
- (void)setDetailModel:(ZPMovieDetailModel *)detailModel {
    
    _detailModel = detailModel;
    [self.movieImageView sd_setImageWithURL:[NSURL URLWithString:_detailModel.detailcover]];
 
    // ----处理分数
    if ([_detailModel.scoretime isEqualToString:@"等候评分"]) {
        
        self.scoreOfImageLabel.text = @"等候评分";
    } else if ([_detailModel.scoretime isEqualToString:@"即将上映"]) {
        self.scoreOfImageLabel.text = @"即将上映";
    } else {
        
        self.scoreOfImageLabel.attributedText = [self scorewithFontName:movieScoreListFont fontSize:40 isUnderlines:YES score:_detailModel.score];

    }
    
    // ----设置电影表上的数据
    UILabel *detailLabel = self.detailView.subviews.firstObject;
    detailLabel.text = _detailModel.info;
    
    NSArray *keyArray = [_detailModel.keywords componentsSeparatedByString:@";"];
    NSArray *labelArray = self.keyView.subviews.firstObject.subviews;
    
    for (int i = 0; i < keyArray.count; i++) {
        
        UILabel *label = labelArray[i];
        label.text = keyArray[i];
    }
    
    // 下载电影表的图片
    int i = 0;
    self.photoScrollView.contentSize = CGSizeMake(self.detailModel.photo.count * 125, 120);

    for (NSString *photoStr in _detailModel.photo) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(125 * i, 0, 120, 120)];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        [view addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:photoStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [self.photoScrollView addSubview:view];
            
        }];
        i++;
    }
    
}


#pragma mark - 富文本显示分数
- (NSMutableAttributedString *) scorewithFontName:(NSString *) fontName fontSize:(NSInteger) fontSize isUnderlines:(BOOL) isUnderlines score:(NSString *) score{
    
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = [UIFont fontWithName:fontName size:fontSize];
    
    if (isUnderlines) {
        
        attri[NSForegroundColorAttributeName] = [UIColor redColor];
        attri[NSUnderlineStyleAttributeName] = @(50);
    }
    
    return [[NSMutableAttributedString alloc] initWithString:score attributes:attri];
}

#pragma mark - 重写故事详情model
- (void)setStoryModel:(ZPMovieStoryModel *)storyModel {
    
    _storyModel = storyModel;
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:_storyModel.user.web_url]];
    self.stroyContentTitleLabel.text = _storyModel.title;
    self.stroyContentLabel.text = _storyModel.content;
    self.storyCountLabel.text = [NSString stringWithFormat:@"共有%@个故事", self.storyCount];
    self.userNameLabel.text = _storyModel.user.user_name;
    self.likeLabel.text = [NSString stringWithFormat:@"%ld", _storyModel.praisenum];
    
    NSArray *strArray = [[[_storyModel.input_date componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"];
    self.datelabel.text = [strArray componentsJoinedByString:@"."];
    
}

- (void)dealloc {
    
    [[_manager operationQueue] cancelAllOperations];
}

@end

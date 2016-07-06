//
//  ZPMusicNewsDetailController.m
//  idlesse
//
//  Created by 胡知平 on 16/6/4.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPMusicNewsDetailController.h"
#import "ZPMusicNewsDetailModel.h"
#import "ZPMusicRequestManager.h"


@interface ZPMusicNewsDetailController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *musicNewsWebView;

/**文章url*/
@property (nonatomic, copy) NSString *url;

@end

@implementation ZPMusicNewsDetailController

#pragma mark - toolbarbutton点击事件

- (IBAction)musicLikeAction:(UIBarButtonItem *)sender {
    
    static BOOL isLike = NO;
    if (isLike) {
        
        self.musicLikeButton.tintColor = [UIColor lightGrayColor];
        isLike = NO;
    } else {
        
        self.musicLikeButton.tintColor = [UIColor redColor];
        isLike = YES;
    }
    
    
}
- (IBAction)commentAction:(UIBarButtonItem *)sender {
    
    ZPLogFunc;
}

- (IBAction)shareAction:(UIBarButtonItem *)sender {
    
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UMAPPKey
//                                      shareText:self.url
//                                     shareImage:nil
//                                shareToSnsNames:@[UMShareToEmail, UMShareToQzone]
//                                       delegate:nil];
//        ZPCustomActivity *activity = [[ZPCustomActivity alloc] initWithImage:image atURL:nil atTitle:text atShareContentArray:@[text, image]];
    
    UIActivityViewController *shareVC = [[UIActivityViewController alloc]initWithActivityItems:@[self.url] applicationActivities:nil];
    shareVC.excludedActivityTypes = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr];
    [self presentViewController:shareVC animated:YES completion:nil];
    /*
     UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
     UIActivityTypePostToWeibo,
     UIActivityTypeMessage, UIActivityTypeMail,
     UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
     UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
     UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
     UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo
     */
    
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLayoutView];
    [self setupLeftItem];
    [self requestMusicNewsDetail];
}

#pragma mark - 初始化控件
- (void) initLayoutView {
    
    self.musicNewsWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.musicNewsWebView.allowsLinkPreview = YES;
    self.musicNewsWebView.delegate = self;
    
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


#pragma mark - 请求数据
- (void) requestMusicNewsDetail {

    [[ZPMusicRequestManager manager] requestMusicDetialId:self.musicNewsId complete:^(ZPMusicNewsDetailModel *model, BOOL isSuccess) {
       
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [SVProgressHUD dismiss];
            if (!isSuccess) {
                
                [SVProgressHUD showErrorWithStatus:@"加载文章详情失败"];
                return;
            }
            
            weakSelf.url = model.content.url;
            [weakSelf webViewRequest];
        });
        
        
    }];
    
}

#pragma mark - 显示文章
- (void) webViewRequest {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.musicNewsWebView loadRequest:request];
}


#pragma mark - webView协议方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [request URL];
        NSString *urlStr = url.absoluteString;
        NSArray *array = [urlStr componentsSeparatedByString:@"="];
        
        if (array.count == 2) {
            
            self.musicNewsId = array.lastObject;
            [self requestMusicNewsDetail];
        }

//        if([[UIApplication sharedApplication]canOpenURL:url])
//        {
//            [[UIApplication sharedApplication]openURL:url];
//        }
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.title = @"加载中^_^";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.title = @"详情";
}

- (void)dealloc {
    
    [[ZPMusicRequestManager manager] cancelAllRequest];
    
}





@end

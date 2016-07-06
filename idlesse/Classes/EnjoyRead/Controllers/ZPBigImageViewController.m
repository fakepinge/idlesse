//
//  ZPBigImageViewController.m
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPBigImageViewController.h"
#import "DragView.h"

@interface ZPBigImageViewController ()

/**图片*/
@property (nonatomic, strong) DragView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation ZPBigImageViewController


- (IBAction)closeAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)saveAction:(UIButton *)sender {
    
    // ----保存图片
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 耗时操作,同步请求数据
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.realUrl]];
        
        // 回到主队列中保存图片
        dispatch_async(dispatch_get_main_queue(), ^{
            // 将二进制转换为图片
            // 参数2（对象） 参数3（方法） 保存完成后的对象回调的方法 方法不是随便写的，必须是这样的格式
            // 参数4：上下文环境
            UIImage *image = [UIImage imageWithData:imageData];
            UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(bigPicImage:didFinishSavingWithError:contextInfo:), nil);
        });
    });

    [self dismissViewControllerAnimated:YES completion:nil];


    
}

- (void)bigPicImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error) {
        
        [self.delegete showIsScuess:NO];
        
    } else {
        
        [self.delegete showIsScuess:YES];
    }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.saveButton.layer.borderWidth = 1;
    self.saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self setupImageView];
}


- (void) setupImageView {
    
    _imageView = [[DragView alloc] init];
    [self.view addSubview:_imageView];
    [self.view sendSubviewToBack:_imageView];
    //_imageView.translatesAutoresizingMaskIntoConstraints = NO;
    //CGFloat height = SCREEN_HEIGHT - SCREEN_WIDTH * self.imageValue;
    ;
    
    __weak typeof(self) weakSelf = self;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.realUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGFloat height = SCREEN_WIDTH * weakSelf.imageValue;
        _imageView.height = height;
        _imageView.width = SCREEN_WIDTH;
        _imageView.center = weakSelf.view.center;
    }];
    
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

@end

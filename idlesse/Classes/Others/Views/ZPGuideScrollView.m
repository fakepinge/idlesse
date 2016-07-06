//
//  ZPGuideScrollView.m
//  yingdaoye
//
//  Created by 胡知平 on 16/5/27.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPGuideScrollView.h"


#define GUIDE_COUNT 3


@interface ZPGuideScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger number;



@end

@implementation ZPGuideScrollView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:SCREEN_FRAME];
    
    if (self) {
        
        self.number = 1;
        
        self.bounces = NO;
        
        self.contentSize = CGSizeMake(SCREEN_WIDTH * GUIDE_COUNT, SCREEN_HEIGHT);
        
        self.backgroundColor = [UIColor blackColor];
        
        self.showsHorizontalScrollIndicator = NO;
        
        self.pagingEnabled = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.delegate = self;
        
        for (int i = 0; i < GUIDE_COUNT; i++) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH ,SCREEN_HEIGHT)];
            
            [imageView setBackgroundColor:[UIColor redColor]];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:[NSString stringWithFormat:@"boot%d",i + 1]], 0.5) ;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [imageView setImage:[UIImage imageWithData:imageData]];
                });
            });
            
            
            
            [self addSubview:imageView];
            
            /** 在最后一页的图片上添加点击进入的按钮 */
            
            if (i == GUIDE_COUNT - 1) {

                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110, 35)];
                button.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT - 100);
                [button setTitle:@"开启闲时之旅" forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:16];
                [button setTitleColor:ZPRGBColor(15, 117, 224) forState:UIControlStateNormal];
                button.backgroundColor = [UIColor clearColor];
                button.layer.cornerRadius = 6;
                button.layer.masksToBounds = YES;
                button.layer.borderWidth = 1;
                [button.layer setBorderColor:ZPRGBColor(15, 117, 224).CGColor];
                
                [button addTarget:self action:@selector(beginClick) forControlEvents:UIControlEventTouchUpInside];
                
                imageView.userInteractionEnabled = YES;
                
                [imageView addSubview:button];
                
            }
            
            /** 实现点击能更改图片 */
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
            
            imageView.userInteractionEnabled = YES;
            
            [imageView addGestureRecognizer:tap];
            
            
            _pageController= [[UIPageControl alloc]init];
            _pageController.pageIndicatorTintColor = [UIColor whiteColor];
            _pageController.currentPageIndicatorTintColor = [UIColor colorWithRed:0.011 green:0.560 blue:0.915 alpha:1.000];
            CGSize size = [_pageController sizeForNumberOfPages:GUIDE_COUNT];
            
            self.pageController.bounds = CGRectMake(0, 0, size.width, size.height);
            ;
            self.pageController.numberOfPages = GUIDE_COUNT;
            
            
        }
        
    }
    
    return self;
    
}

#pragma mark - 点击事件

- (void)beginClick {
    
    /** 关闭scroll的用户交互 */
    
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0.0;
        self.pageController.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        /** 进入VC后将scroll销毁 */
        
        [self removeFromSuperview];
        [self.pageController removeFromSuperview];
        
    }];
    
}

-(void)handleTapAction:(UITapGestureRecognizer *)tap {
    
    /** 判断用户是在第几张图片以免越界 */
    
    if (self.number < GUIDE_COUNT) {
        
        CGPoint scrollPoint = CGPointMake(SCREEN_WIDTH * self.number, 0);
        
        [self setContentOffset:scrollPoint animated:YES];
        
        
        self.number++;
        
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.pageController.currentPage = self.number - 1;
    });
    
    
}

#pragma mark - 设置

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    /** 滑动引导页的时候更改number的值以确保下次点击图片的时候能实现滑动 */
    
    self.number = (int)(scrollView.contentOffset.x / SCREEN_WIDTH) + 1;
    
    self.pageController.currentPage = self.number - 1;


    
}

@end

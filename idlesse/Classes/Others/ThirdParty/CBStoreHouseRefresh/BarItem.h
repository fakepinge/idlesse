//
//  BarItem.h
//  CBStoreHouseRefreshControl
//
//  Created by coolbeet on 10/30/14.
//  Copyright (c) 2014 Suyu Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarItem : UIView

@property (nonatomic) CGFloat translationX;

- (instancetype)initWithFrame:(CGRect)frame startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(UIColor *)color lineWidth:(CGFloat)lineWidth;
- (void)setupWithFrame:(CGRect)rect;
- (void)setHorizontalRandomness:(int)horizontalRandomness dropHeight:(CGFloat)dropHeight;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

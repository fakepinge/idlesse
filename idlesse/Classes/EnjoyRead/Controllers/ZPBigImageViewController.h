//
//  ZPBigImageViewController.h
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZPBigImageViewControllerDelegate <NSObject>

- (void) showIsScuess:(BOOL) isScuess;

@end

@interface ZPBigImageViewController : UIViewController

/**真实图片*/
@property (nonatomic, copy) NSString *realUrl;

/** 比值 */
@property (nonatomic, assign) CGFloat imageValue;

/**代理*/
@property (nonatomic, weak) id<ZPBigImageViewControllerDelegate> delegete;

@end

//
//  ZPLoginRegisterViewController.h
//  budejie
//
//  Created by 胡知平 on 16/5/26.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPUserModel;
@class ZPNavigationController;
@protocol ZPLoginRegisterViewControllerDelegate <NSObject>

- (void) showIconAndname:(ZPUserModel *) model name:(NSString *) name;

@end
@interface ZPLoginRegisterViewController : UIViewController

/**代理*/
@property (nonatomic, weak) id<ZPLoginRegisterViewControllerDelegate> delegate;



@end

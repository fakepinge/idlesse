//
//  ZPMeCollectionViewController.h
//  idlesse
//
//  Created by 胡知平 on 16/6/7.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPUserModel;

@protocol ZPMeCollectionViewControllerDelagate <NSObject>

- (void) showLoginButtonMessage;

@end

@interface ZPMeCollectionViewController : UITableViewController

/**model*/
@property (nonatomic, strong) ZPUserModel *user;
/**代理*/
@property (nonatomic, weak) id<ZPMeCollectionViewControllerDelagate> delegate;
@end

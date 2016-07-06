//
//  ZPFavoritesViewController.h
//  idlesse
//
//  Created by 胡知平 on 16/6/2.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZPFavoritesViewControllerDelegate <NSObject>

- (void) reloadDataIndexPath: (NSArray <NSIndexPath *> *)indexPaths;

@end

@interface ZPFavoritesViewController : UITableViewController

/**模型数组*/
@property (nonatomic, strong) NSMutableArray *favorites;

/**daili*/
@property (nonatomic, weak) id<ZPFavoritesViewControllerDelegate> delegate;

@end

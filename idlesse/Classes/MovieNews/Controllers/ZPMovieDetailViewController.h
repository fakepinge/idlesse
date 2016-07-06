//
//  ZPMovieDetailViewController.h
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPMovieDetailViewController : UIViewController

/**电影的id*/
@property (nonatomic, copy) NSString *movieId;

/**电影标题*/
@property (nonatomic, copy) NSString *movieTitle;

@end

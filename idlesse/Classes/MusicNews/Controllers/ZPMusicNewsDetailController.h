//
//  ZPMusicNewsDetailController.h
//  idlesse
//
//  Created by 胡知平 on 16/6/4.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPMusicNewsDetailController : UIViewController

/**文章id*/
@property (nonatomic, copy) NSString *musicNewsId;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *musicLikeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *musicCommentButton;

@end

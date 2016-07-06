//
//  ZPOtherUserMessageController.h
//  idlesse
//
//  Created by 胡知平 on 16/6/7.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZPOtherUserMessageController : UITableViewController

/**model*/
@property (nonatomic, copy) NSString *userId;
/**name*/
@property (nonatomic, copy) NSString *name;
/**url*/
@property (nonatomic, copy) NSString *url;

@end

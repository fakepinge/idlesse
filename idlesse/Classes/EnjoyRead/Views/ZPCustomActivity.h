//
//  ZPCustomActivity.h
//  idlesse
//
//  Created by 胡知平 on 16/6/7.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPCustomActivity : UIActivity

@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *shareContentArray;

-(instancetype)initWithImage:(UIImage *)shareImage
                       atURL:(NSString *)URL
                     atTitle:(NSString *)title
         atShareContentArray:(NSArray *)shareContentArray;



@end

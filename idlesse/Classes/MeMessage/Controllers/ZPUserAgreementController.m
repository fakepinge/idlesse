//
//  ZPUserAgreementController.m
//  idlesse
//
//  Created by 胡知平 on 16/6/7.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPUserAgreementController.h"

@interface ZPUserAgreementController ()

@end

@implementation ZPUserAgreementController
- (IBAction)backAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZPGlobalBgcolor;
    
    
}



@end

//
//  ZPRegisterPasswordViewController.m
//  idlesse
//
//  Created by 胡知平 on 16/6/5.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPRegisterPasswordViewController.h"
#import "ZPTextField.h"
#import "ZPLoginRegisterViewController.h"

@interface ZPRegisterPasswordViewController ()
@property (weak, nonatomic) IBOutlet ZPTextField *settingPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *completeResigterButton;
@end

@implementation ZPRegisterPasswordViewController


- (IBAction)completeResigterAction:(UIButton *)sender {
    
    if (![self passwordDigits]) return;
    
    // ----账号密码上传到leanCloud
    [self uploadUserMessage];
    // ----跳转到登陆界面
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void) uploadUserMessage {
    
    AVObject *todo = [AVObject objectWithClassName:@"user"];
    [todo setObject:self.phoneNumber forKey:@"phoneNumber"];
    [todo setObject:self.settingPasswordTextField.text forKey:@"password"];
    [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) return [self showRemindUserText:@"注册成功"];
    }];
}




- (IBAction)backAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 提示用户的文本框
- (void) showRemindUserText:(NSString *) text {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    hud.yOffset = 50;
    [hud showAnimated:YES whileExecutingBlock:^{
        
        sleep(2);
    } completionBlock:^{
        
        [hud removeFromSuperview];
    }];
}

#pragma mark - 判断密码位数
- (BOOL) passwordDigits {
    
    NSInteger passwordLenth = self.settingPasswordTextField.text.length;
    
    if (passwordLenth == 0) {
        
        [self showRemindUserText:@"请设置密码"];
    } else if ( passwordLenth < 8 ||  passwordLenth > 16) {
        
        [self showRemindUserText:@"设置密码的位数是8-16位"];
    } else {
        
        return YES;
    }
    
    return NO;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    // ----调用完成按钮的点击事件
    return YES;
}



@end

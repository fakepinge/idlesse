//
//  ZPLoginRegisterViewController.m
//  budejie
//
//  Created by 胡知平 on 16/5/26.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPLoginRegisterViewController.h"
#import "ZPRegisterPasswordViewController.h"
#import "ZPTextField.h"
#import "ZPMeRequestManager.h"
#import "ZPMeCollectionViewController.h"
#import "ZPUserModel.h"
#import "ZPUserAgreementController.h"
#import "ZPNavigationController.h"
#import "ZPVertialButton.h"

@interface ZPLoginRegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginLendingConstraint;


// ----注册
@property (weak, nonatomic) IBOutlet ZPTextField *registerPhoneNumberTextField;
@property (weak, nonatomic) IBOutlet ZPTextField *registerSmsMessageTextField;
@property (weak, nonatomic) IBOutlet UIButton *smsMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *registerNextButton;

// ----登录
@property (weak, nonatomic) IBOutlet ZPTextField *loginPhoneNumberTextField;
@property (weak, nonatomic) IBOutlet ZPTextField *loginSmsMessageTextField;

@property (weak, nonatomic) IBOutlet ZPVertialButton *QQLoginButton;

@property (weak, nonatomic) IBOutlet UIView *fastLoginView;

@end

@implementation ZPLoginRegisterViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view sendSubviewToBack:self.bgImageView];
    [self QQIsInstall];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _loginLendingConstraint.constant = 0;
    _registerPhoneNumberTextField.text = @"";
    _registerSmsMessageTextField.text = @"";
}

#pragma mark - 判断是否安装了QQ 
- (void) QQIsInstall {
    
    self.fastLoginView.hidden  = ![AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSQQ];
}


#pragma mark - 登陆和注册的切换
- (IBAction)loginRegisterAction:(UIButton *)sender {
    
    if (_loginLendingConstraint.constant == 0) {
        
        _loginLendingConstraint.constant = -self.view.width;
        sender.selected = YES;
    } else {
        
        _loginLendingConstraint.constant = 0;
        sender.selected = NO;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
       
        [self.view layoutIfNeeded];
    }];
    
    
}
#pragma mark - 返回
- (IBAction)closeAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 判断手机号码格式
- (BOOL) phoneNumberStyle:(ZPTextField *) sender {
    
    NSString *phoneNumber = sender.text;
    if (phoneNumber.length == 11) return YES;
    return NO;
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

#pragma mark - 获取验证码
- (IBAction)getSmsMessageAction:(UIButton *)sender {
    
    // ----判断手机号码格式位数是否正确
    if (![self phoneNumberStyle:self.registerPhoneNumberTextField]) {
        
        [self showRemindUserText:@"手机号格式不正确"];
        return;
    }
    // ----判断手机号是否已经注册
    AVQuery *query = [AVQuery queryWithClassName:@"user"];
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        int temp = 0;
        for (AVObject *todo in objects) {
            
            if ([[todo valueForKey:@"phoneNumber"] isEqualToString:weakSelf.registerPhoneNumberTextField.text] ) {
                
                temp = 1;
                break;
            }
        }
        
        if (temp) {
            
            [weakSelf showRemindUserText:@"该手机号已注册"];
        } else {
            
            [self.view endEditing:YES];
            //展示获取验证码界面，SMSGetCodeMethodSMS:表示通过文本短信方式获取验证码
            __weak typeof(self) weakSelf = self;
            [AVOSCloud requestSmsCodeWithPhoneNumber:self.registerPhoneNumberTextField.text callback:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    //发送成功
                    [weakSelf showRemindUserText:@"获取验证码成功"];
                    weakSelf.registerNextButton.enabled = YES;
                    weakSelf.smsMessageButton.userInteractionEnabled = YES;
                    // ----验证码倒计时
                    [weakSelf countDown];
                } else {
                   
                    ZPLog(@"%@", error.localizedDescription);
                    [weakSelf showRemindUserText:@"获取验证码失败"];
                }
            }];
            
//            __weak typeof(self) weakSelf = self;
//            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.registerPhoneNumberTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
//                
//                if (!error) {
//                    
//                    [weakSelf showRemindUserText:@"获取验证码成功"];
//                    weakSelf.registerNextButton.enabled = YES;
//                    weakSelf.smsMessageButton.userInteractionEnabled = YES;
//                    // ----验证码倒计时
//                    [weakSelf countDown];
//                    
//                } else {
//                    
//                    [weakSelf showRemindUserText:@"获取验证码失败"];
//                }
//            }];
        }
        
    }];
}

#pragma mark - 验证码60s倒计时
- (void) countDown {
    
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
          //  dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [weakSelf.smsMessageButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                weakSelf.smsMessageButton.userInteractionEnabled = YES;
            });
        } else {
            

            NSString *strTime = [NSString stringWithFormat:@"%d秒后重新获取验证码", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [weakSelf.smsMessageButton setTitle:strTime forState:UIControlStateNormal];
                weakSelf.smsMessageButton.userInteractionEnabled = NO;
            });
            timeout--;
            
        }  
    });  
    dispatch_resume(_timer);
    
}

#pragma mark - 点击下一步按钮事件
- (IBAction)registerNext:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:self.registerPhoneNumberTextField.text smsCode:self.registerSmsMessageTextField.text block:^(AVUser *user, NSError *error) {
        
        if (error) {
            ZPLog(@"%@", error.localizedDescription);
            [weakSelf showRemindUserText:@"验证码错误"];
        } else {
            //验证成功
            ZPRegisterPasswordViewController *settingPassword = [[ZPRegisterPasswordViewController alloc] init];
            settingPassword.phoneNumber = self.registerPhoneNumberTextField.text;
            [weakSelf presentViewController:settingPassword animated:YES completion:nil];
        }
    }];
    
//    [SMSSDK commitVerificationCode:self.registerSmsMessageTextField.text phoneNumber:self.registerPhoneNumberTextField.text zone:@"86" result:^(NSError *error) {
//        
//        if (!error) {
//            
//            ZPRegisterPasswordViewController *settingPassword = [[ZPRegisterPasswordViewController alloc] init];
//            settingPassword.phoneNumber = self.registerPhoneNumberTextField.text;
//            [self presentViewController:settingPassword animated:YES completion:nil];
//        } else {
//            
//           [self showRemindUserText:@"验证码错误"];
//        }
//    }];
    
}

#pragma mark - 登录按钮点击事件
- (IBAction)loginAction:(UIButton *)sender {
    
    // ----判断手机号码格式位数是否正确
    if (![self phoneNumberStyle:self.loginPhoneNumberTextField]) {
        
        [self showRemindUserText:@"手机号格式不正确"];
        return;
    }
    
    AVQuery *query = [AVQuery queryWithClassName:@"user"];
    __weak typeof(self) weakSelf = self;
   
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        ZPLog(@"%@", objects);
        int temp = 0;
        for (AVObject *todo in objects) {
            
            if ([[todo valueForKey:@"phoneNumber"] isEqualToString:weakSelf.loginPhoneNumberTextField.text]) {
                temp = 1;
                [weakSelf showRemindUserText:@"登陆中"];
                if ([[todo valueForKey:@"password"] isEqualToString:weakSelf.loginSmsMessageTextField.text]) {
                    
                    // ----登录
                    [weakSelf loginAuthentication];
                    break;
                } else {
                    
                    [weakSelf showRemindUserText:@"密码错误"];
                    
                }
            }
        }
        if (temp == 0) {
            
            [weakSelf showRemindUserText:@"该手机号未注册"];
        }
    }];

    
 
}

#pragma mark - 验证登录请求
- (void) loginAuthentication {
    
    
    __weak typeof(self) weakSelf = self;
    [[ZPMeRequestManager manager] requestUserId:nil complete:^(ZPUserModel *model, BOOL isSuccess) {
        
        if (isSuccess) {
            
            [weakSelf showRemindUserText:@"登陆成功"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
            
            [NSKeyedArchiver archiveRootObject:model toFile:[localDocumentPath stringByAppendingPathComponent:@"user.data"]];
            
            [weakSelf.delegate showIconAndname:model name:model.user_name];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [weakSelf showRemindUserText:@"登陆失败"];
        }
        
    }];
    

}


//- (IBAction)weiboLoginAction:(UIButton *)sender {
//    
//    __weak typeof(self) weakSelf = self;
//    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:weiboAppId andAppSecret:weiboAppSecret andRedirectURI:@""];
//    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
//        if (error) {
//            
//            ZPLog(@"====%@===", error.localizedDescription);
//        } else {
//            
//            ZPUserModel  *model = [[ZPUserModel alloc] init];
//            model.user_name = object[@"username"];
//            model.web_url = object[@"avatar"];
//            model.score = @"500";
//            [weakSelf thirdLogin:model];
//            ZPLog(@"====%@===", object);
//
//          
//        }
//    } toPlatform:AVOSCloudSNSSinaWeibo];
//    
//}


- (IBAction)QQLoginAction:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSQQ withAppKey:QQAppId andAppSecret:QQAppKey andRedirectURI:@""];
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if (error) {
            
            ZPLog(@"%@", error.localizedDescription);
        } else {
            
            ZPUserModel  *model = [[ZPUserModel alloc] init];
            model.user_name = object[@"username"];
            model.web_url = object[@"avatar"];
            model.score = @"500";
            [weakSelf thirdLogin:model];
        }
    } toPlatform:AVOSCloudSNSQQ];
}

- (void) thirdLogin:(ZPUserModel *) model {
    
    [self.delegate showIconAndname:model name:model.user_name];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
    [NSKeyedArchiver archiveRootObject:model toFile:[localDocumentPath stringByAppendingPathComponent:@"user.data"]];
    
}


- (IBAction)registerDelegateAction:(UIButton *)sender {
    
    ZPUserAgreementController *userAgreement = [[ZPUserAgreementController alloc] init];
    [self presentViewController:userAgreement animated:YES completion:nil];
}



@end

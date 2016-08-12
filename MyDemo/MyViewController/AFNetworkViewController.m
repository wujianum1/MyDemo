//
//  AFNetworkViewController.m
//  MyDemo
//
//  Created by Joker on 16/7/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "AFNetworkViewController.h"

#import "APPWebService.h"

#import "WJJToolFactory.h"
#import "WJJProgressHUD.h"

@interface AFNetworkViewController ()<UITextFieldDelegate>
{
    UITextField *editedTF; // 标记当前编辑的textfield
    WJJProgressHUD *proHud; // 数据加载指示器
}

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (nonatomic,strong)APPWebService *webService;
@end

@implementation AFNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /**
     * 关闭UITextView编辑和长按选择功能
     */
    self.contentTextView.editable = NO;
    self.contentTextView.selectable = NO;
    
    
    // textfield
    self.passWordTextField.secureTextEntry = YES;
    
    self.userNameTextField.returnKeyType = UIReturnKeyNext;
    self.passWordTextField.returnKeyType = UIReturnKeyGo;
    
    self.userNameTextField.delegate = self;
    self.passWordTextField.delegate = self;
    
    
    self.webService = [[APPWebService alloc]init];
}

-(void)loginUser{
    
    if ([editedTF isFirstResponder]) {
        [editedTF resignFirstResponder];
    }
    
    NSString *userName = self.userNameTextField.text;
    NSString *passWord = self.passWordTextField.text;
    
    if ([WJJToolFactory isBlankWithString:userName]) {
        [WJJProgressHUD showTipTextWithView:self.navigationController.view text:@"账号不能为空"];
        return;
    }
    
    if ([WJJToolFactory isBlankWithString:passWord]) {
        [WJJProgressHUD showTipTextWithView:self.navigationController.view text:@"密码不能为空"];
        return;
    }
    
    proHud = [WJJProgressHUD showLoadingWithView:self.navigationController.view text:@"登录中..."];
    [self.webService userLogin:userName passWord:passWord reslut:^(id reslut, NSError *error) {
        if (error) {
            NSLog(@"%@:%@ 错误代码",self.class,error.description);
            return;
        }
        if ([reslut intValue] == 1) {
            [self getUserInfo:userName];
        }
//        NSLog(@"%@:%@",self.class,reslut);
    }];
}

#pragma mark -- 响应事件 --
- (IBAction)login:(id)sender {
    [self loginUser];
}

#pragma mark -- 网络请求 --
/** 获取用户数据 */
-(void)getUserInfo:(NSString *)userName{
    __block AFNetworkViewController *blockSelf = self;
    [self.webService getUserInfoWithUserName:userName reslut:^(id reslut, NSError *error) {
//        NSLog(@"UserInfo:%@",reslut);
        _contentTextView.text = [NSString stringWithFormat:@"%@",reslut];
        
        [blockSelf->proHud hideHUD];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 代理 --
#pragma mark -- UITextFeild -- 
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userNameTextField) {
        [self.passWordTextField becomeFirstResponder];
    }else{
        [self loginUser];
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    editedTF = textField;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

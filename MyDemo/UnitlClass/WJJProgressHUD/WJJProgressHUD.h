//
//  WJJProgressHUD.h
//  MyDemo
//
//  Created by 吴嘉佳 on 16/8/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface WJJProgressHUD : MBProgressHUD

/** 显示正在加载 */
+(WJJProgressHUD *)showLoadingWithView:(UIView *)targetView;
/** 显示加载框并制定显示文字 */
+(WJJProgressHUD *)showLoadingWithView:(UIView *)targetView text:(NSString *)tipText;
/** 只显示文字提示框 */
+(void)showTipTextWithView:(UIView *)targetView text:(NSString *)tipText;

/** 隐藏加载器 */
-(void)hideHUD;
@end

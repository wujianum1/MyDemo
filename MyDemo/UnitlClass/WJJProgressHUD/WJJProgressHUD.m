//
//  WJJProgressHUD.m
//  MyDemo
//
//  Created by 吴嘉佳 on 16/8/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "WJJProgressHUD.h"

@implementation WJJProgressHUD

/** 显示正在加载 */
+(WJJProgressHUD *)showLoadingWithView:(UIView *)targetView{
    
    return [WJJProgressHUD showLoadingWithView:targetView text:@"Loading..."];
}

/** 显示加载框并制定显示文字 */
+(WJJProgressHUD *)showLoadingWithView:(UIView *)targetView text:(NSString *)tipText{
    WJJProgressHUD *proHUD = [WJJProgressHUD showHUDAddedTo:targetView animated:YES];
    
    proHUD.label.text = NSLocalizedString(tipText, @"HUD loading title");
    
    return proHUD;
}

/** 只显示文字提示框 */
+(void)showTipTextWithView:(UIView *)targetView text:(NSString *)tipText{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(tipText, @"HUD message title");
    
    // Move to bottm center.
    float offsetY = [UIScreen mainScreen].bounds.size.height/2.0-50.0;
    hud.offset = CGPointMake(0.f, offsetY);
  
    // 提示框背景色、内容颜色
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.90];
    hud.contentColor = [UIColor whiteColor];
    
    hud.label.font = [UIFont systemFontOfSize:14.0];
    
    hud.margin = 12.0;
    
    [hud hideAnimated:YES afterDelay:1.5f];
}


-(void)hideHUD
{
    if (self) {
        [self hideAnimated:YES];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

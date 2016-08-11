//
//  ViewController.m
//  MyDemo
//
//  Created by Joker on 16/7/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ViewController.h"

#define TABLE_CELL_NAMES @[@"AFNetworkViewController"]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initViewUI];
}


// 初始化视图控件
-(void)initViewUI{
    UITableView *contentView = [[UITableView alloc]init];
    contentView.delegate = self;
    contentView.dataSource = self;
    [self.view addSubview:contentView];
    
    // 自动布局前先对子视图进行调整
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    /*
     * 参数说明: 
     * 第一个参数:指定约束左边的视图view1
     * 第二个参数:指定view1的属性attr1，具体属性见文末。
     * 第三个参数:指定左右两边的视图的关系relation，具体关系见文末。
     * 第四个参数:指定约束右边的视图view2
     * 第五个参数:指定view2的属性attr2，具体属性见文末。
     * 第六个参数:指定一个与view2属性相乘的乘数multiplier
     * 第七个参数:指定一个与view2属性相加的浮点数constant,相对偏移量
     *
     */
    NSLayoutConstraint *widthLayout = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *heightLayout = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    NSLayoutConstraint *centerXLayout = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *centerYLayout = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    [self.view addConstraint:widthLayout];
    [self.view addConstraint:heightLayout];
    [self.view addConstraint:centerXLayout];
    [self.view addConstraint:centerYLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDelegate、UITableViewDataSource -- 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TABLE_CELL_NAMES.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"demoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text = TABLE_CELL_NAMES[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            [self performSegueWithIdentifier:@"NetworkSegue" sender:nil];
            }
            break;
            
        default:
            break;
    }
}
@end

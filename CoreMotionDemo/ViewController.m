//
//  ViewController.m
//  CoreMotionDemo
//
//  Created by wujie on 2017/12/12.
//  Copyright © 2017年 wujie. All rights reserved.
//



// 参考资料 http://www.jianshu.com/p/233be81b8ead

#import "ViewController.h"
#import "AccelerometerViewController.h"
#import "GyroViewController.h"
#import "MagnetometerViewController.h"
@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *motionArray;
@property (nonatomic, strong) NSArray *controllerArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.motionArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:self.controllerArray[indexPath.row] animated:YES];
}

- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[UITableViewCell classForCoder] forCellReuseIdentifier:@"cell"];
    }
    return _myTableView;
}

- (NSArray *)motionArray
{
    if (!_motionArray) {
        _motionArray = @[@"加速计",@"陀螺仪",@"磁力计"];
    }
    return _motionArray;
}

- (NSArray *)controllerArray
{
    if (!_controllerArray) {
        _controllerArray = @[[AccelerometerViewController new],[GyroViewController new],[MagnetometerViewController new]];
    }
    return _controllerArray;
}
@end

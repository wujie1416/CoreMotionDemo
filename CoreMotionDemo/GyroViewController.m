//
//  GyroViewController.m
//  CoreMotionDemo
//
//  Created by wujie on 2017/12/12.
//  Copyright © 2017年 wujie. All rights reserved.
//

#import "GyroViewController.h"
#import "BallView.h"
#import <CoreMotion/CoreMotion.h>
@interface GyroViewController ()
@property (nonatomic, strong) CMMotionManager *manager;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) BallView *ballView;
@end

@implementation GyroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"陀螺仪";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    [self.view addSubview:self.ballView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self useGyroPush];
    [self playBall];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_manager stopGyroUpdates];
}

//陀螺仪使用Pull方式获取
- (void)useGyroPull
{
    //判断陀螺仪可不可用
    if ([self.manager isGyroAvailable]) {
        //告诉manager，更新频率是100Hz
        _manager.gyroUpdateInterval = 0.01;
        //开始更新，后台线程开始运行。这是Pull方式。
        [_manager startGyroUpdates];
    } else {
        NSLog(@"该设备不支持获取陀螺仪");
    }
    //获取并处理陀螺仪数据
    //陀螺仪数据：该数据通过CMGyroData对象来表示。该对象只有一个CMRotationRate结构体类型的rotationRate属性，该结构体属性值包含x、y、z三个字段，分别代表设备围绕X、Y、Z轴转动的速度；
    CMGyroData *newestAccel = _manager.gyroData;
    _label.text = [NSString stringWithFormat:@"X = %.04f,Y = %.04f,Z = %.04f",newestAccel.rotationRate.x,newestAccel.rotationRate.y,newestAccel.rotationRate.z];
}

//陀螺仪使用Push方式获取
- (void)useGyroPush
{
    //判断陀螺仪可不可用
    if ([self.manager isGyroAvailable]) {
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        //告诉manager，更新频率是100Hz
        _manager.gyroUpdateInterval = 0.01;
        //Push方式获取和处理数据
        [_manager startGyroUpdatesToQueue:queue withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            _label.text = [NSString stringWithFormat:@"X = %.04f,Y = %.04f,Z = %.04f",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z];
        }];
    } else {
        NSLog(@"该设备不支持获取陀螺仪");
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    CMGyroData *newestAccel = _manager.gyroData;
//    _label.text = [NSString stringWithFormat:@"X = %.04f,Y = %.04f,Z = %.04f",newestAccel.rotationRate.x,newestAccel.rotationRate.y,newestAccel.rotationRate.z];
//}

- (void)playBall
{
    if ([self.manager isGyroAvailable]) {
        self.manager.deviceMotionUpdateInterval = 0.01;
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        [self.manager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable    error) {
            self.ballView.acceleration  = motion.gravity;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.ballView updateLocation];
            });
        }];
    } else {
    NSLog(@"该设备不支持获取陀螺仪");
    }
}


- (CMMotionManager *)manager
{
    if (!_manager) {
        _manager = [[CMMotionManager alloc] init];
    }
    return _manager;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 300, 200)];
        _label.numberOfLines = 0;
    }
    return _label;
}

- (BallView *)ballView
{
    if (!_ballView) {
        _ballView = [[BallView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    }
    return _ballView;
}
@end

//
//  MagnetometerViewController.m
//  CoreMotionDemo
//
//  Created by wujie on 2017/12/12.
//  Copyright © 2017年 wujie. All rights reserved.
//

#import "MagnetometerViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface MagnetometerViewController ()
@property (nonatomic ,strong) CMMotionManager *manager;
@property (nonatomic ,strong) UILabel *label;
@end

@implementation MagnetometerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"磁力计";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self useMagnetometerPush];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_manager stopMagnetometerUpdates];
}

//磁力计使用Pull方式获取
- (void)useMagnetometerPull
{
    //判断磁力计可不可用
    if ([self.manager isMagnetometerAvailable]) {
        //告诉manager，更新频率是100Hz
        _manager.magnetometerUpdateInterval = 0.01;
        //开始更新，后台线程开始运行。这是Pull方式。
        [_manager startMagnetometerUpdates];
    } else {
        NSLog(@"该设备不支持获取磁力计");
    }
    //获取并处理磁力计数据
    //陀螺仪数据：该数据通过CMGyroData对象来表示。该对象只有一个CMRotationRate结构体类型的rotationRate属性，该结构体属性值包含x、y、z三个字段，分别代表设备围绕X、Y、Z轴转动的速度；
    CMMagnetometerData *newestAccel = _manager.magnetometerData;
    _label.text = [NSString stringWithFormat:@"X = %.04f,Y = %.04f,Z = %.04f",newestAccel.magneticField.x,newestAccel.magneticField.y,newestAccel.magneticField.z];
}

//磁力计使用Push方式获取
- (void)useMagnetometerPush
{
    //判断磁力计可不可用
    if ([self.manager isMagnetometerAvailable]) {
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        //告诉manager，更新频率是100Hz
        _manager.magnetometerUpdateInterval = 0.01;
        //Push方式获取和处理数据
        [_manager startMagnetometerUpdatesToQueue:queue withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
            _label.text = [NSString stringWithFormat:@"X = %.04f,Y = %.04f,Z = %.04f",magnetometerData.magneticField.x,magnetometerData.magneticField.y,magnetometerData.magneticField.z];
        }];
    } else {
        NSLog(@"该设备不支持获取磁力计");
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    CMMagnetometerData *newestAccel = _manager.magnetometerData;
//    _label.text = [NSString stringWithFormat:@"X = %.04f,Y = %.04f,Z = %.04f",newestAccel.magneticField.x,newestAccel.magneticField.y,newestAccel.magneticField.z];
//}

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
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        _label.center = self.view.center;
        _label.numberOfLines = 0;
    }
    return _label;
}
@end

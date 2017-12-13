//
//  AccelerometerViewController.m
//  CoreMotionDemo
//
//  Created by wujie on 2017/12/12.
//  Copyright © 2017年 wujie. All rights reserved.
//

#import "AccelerometerViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface AccelerometerViewController ()
@property (nonatomic, strong) CMMotionManager *manager;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation AccelerometerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加速计";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    [self.view addSubview:self.imageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self useAccelerometerPush];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_manager stopAccelerometerUpdates];
}

//加速计使用Pull方式获取
- (void)useAccelerometerPull
{
    //判断加速计可不可用
    if ([self.manager isAccelerometerAvailable]) {
        //告诉manager，更新频率是100Hz
        _manager.accelerometerUpdateInterval = 0.01;
        //开始更新，后台线程开始运行。这是Pull方式。
        [_manager startAccelerometerUpdates];
    } else {
        NSLog(@"该设备不支持获取加速计");
    }
    //获取并处理加速计数据
    //加速度数据：该数据通过CMAccelerometerData对象来表示。该对象只有一个CMAcceleration结构体类型的acceleration属性，该结构体属性值包含x、y、z三个字段，分别代表设备在X、Y、Z轴方向检测到的加速度值；
    CMAccelerometerData *newestAccel = _manager.accelerometerData;
    _label.text = [NSString stringWithFormat:@"X = %.04f,Y = %.04f,Z = %.04f",newestAccel.acceleration.x,newestAccel.acceleration.y,newestAccel.acceleration.z];
}

//加速计使用Push方式获取
- (void)useAccelerometerPush
{
    //判断加速计可不可用
    if ([self.manager isAccelerometerAvailable]) {
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        //告诉manager，更新频率是100Hz
        _manager.accelerometerUpdateInterval = 0.1;
        //Push方式获取和处理数据
        [_manager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            _label.text = [NSString stringWithFormat:@"X = %.04f,Y = %.04f,Z = %.04f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z];
            //防止平躺抖动
            if (!(accelerometerData.acceleration.y == 0)) {
                double rotation = atan2(accelerometerData.acceleration.x, accelerometerData.acceleration.y) -M_PI;
                self.imageView.transform = CGAffineTransformMakeRotation(rotation);
            }
        }];
    } else {
        NSLog(@"该设备不支持获取加速计");
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    CMAccelerometerData *newestAccel = _manager.accelerometerData;
//    _label.text = [NSString stringWithFormat:@"X = %.04f,Y = %.04f,Z = %.04f",newestAccel.acceleration.x,newestAccel.acceleration.y,newestAccel.acceleration.z];
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
        _label = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 300, 200)];
        _label.numberOfLines = 0;
    }
    return _label;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _imageView.center = self.view.center;
        _imageView.image = [UIImage imageNamed:@"1"];
    }
    return _imageView;
}

@end

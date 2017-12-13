//
//  BallView.m
//  CoreMotionDemo
//
//  Created by wujie on 2017/12/13.
//  Copyright © 2017年 wujie. All rights reserved.
//

#import "BallView.h"
@interface BallView ()
//图片的宽高
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, strong) UIImageView *imageView;
//当前imageView的位置
@property (nonatomic, assign) CGPoint currentPoint;
//X方向速度
@property (nonatomic, assign) CGFloat XVelocity;
//y方向速度
@property (nonatomic, assign) CGFloat YVelocity;

@end

@implementation BallView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutIfNeeded];
    }
    return self;
}

- (void)layoutSubviews
{
    self.imageView.frame = CGRectMake(0, 0, self.imageWidth, self.imageHeight);
}

- (void)setCurrentPoint:(CGPoint)currentPoint
{
    _currentPoint = currentPoint;
    
    //    判断球是否在X轴方向碰触到了左侧边缘。如果碰触到了，不让其出界，同时将X方向的加速度反向减半
    if (_currentPoint.x <= self.imageWidth / 2) {
        _currentPoint.x = self.imageWidth / 2;
        self.XVelocity = - self.XVelocity / 2;
    }
    
    //    判断球是否在X轴方向碰触到了右侧边缘。如果碰触到了，不让其出界，同时将X方向的加速度反向减半
    if (_currentPoint.x >= self.bounds.size.width - self.imageWidth / 2 ) {
        _currentPoint.x = self.bounds.size.width - self.imageWidth / 2 ;
        self.XVelocity = - self.XVelocity / 2;
    }
    
    //    判断球是否在Y轴方向碰触到了上侧边缘。如果碰触到了，不让其出界，同时将X方向的加速度反向减半
    if (_currentPoint.y <= self.imageHeight / 2) {
        _currentPoint.y = self.imageHeight / 2;
        self.YVelocity = - self.YVelocity / 2;
    }
    
    //    判断球是否在Y轴方向碰触到了下侧边缘。如果碰触到了，不让其出界，同时将X方向的加速度反向减半
    if (_currentPoint.y >= self.bounds.size.height - self.imageHeight / 2) {
        _currentPoint.y = self.bounds.size.height - self.imageHeight / 2;
        self.YVelocity = - self.YVelocity / 2;
    }
    
    //    重新设置imageView的位置
    self.imageView.center = _currentPoint;
}

- (void)updateLocation
{
    static NSDate *lastUpdateTime = nil;
    if (lastUpdateTime) {
        //        计算两次更新之间有多长时间
        NSTimeInterval updatePeriod = [[NSDate date] timeIntervalSinceDate:lastUpdateTime];
        
        //        计算球现在的速度。速度= 速度 + 加速度*时间
        self.XVelocity = self.XVelocity + (self.acceleration.x * updatePeriod);
        self.YVelocity = self.YVelocity + (self.acceleration.y * updatePeriod);
        
        //设置当前的imageView的中心点。后面乘以1000，是为了让小球位移的快一些，很明显能够看到效果。
        self.currentPoint = CGPointMake(self.currentPoint.x + self.XVelocity * updatePeriod * 5000, self.currentPoint.y - self.YVelocity * updatePeriod * 5000);
        NSLog(@"currentPoint.x = %f",self.currentPoint.x);
    }
    
    //    更新时间
    lastUpdateTime = [NSDate date];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ball"]];
        self.currentPoint = self.center;
        self.imageView.center = self.currentPoint;
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (CGFloat)imageWidth
{
    return 50;
}

- (CGFloat)imageHeight
{
    return 50;
}

@end

//
//  BallView.h
//  CoreMotionDemo
//
//  Created by wujie on 2017/12/13.
//  Copyright © 2017年 wujie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface BallView : UIView
// X Y Z轴的力度值结构体
@property (nonatomic, assign) CMAcceleration acceleration;
- (void)updateLocation;

@end

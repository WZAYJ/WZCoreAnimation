//
//  ViewController.m
//  CoreAnimation
//
//  Created by baixunios on 17/6/5.
//  Copyright © 2017年 BaiXun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/*
 主要用到的动画主要在UIKir层 和 CoreAnimation的实现
 
 */
/*

 1.UIKit层  主要是 UIViewAnimation
 # 创建一个动画, 传递上下文等信息
 + (void)beginAnimations:(nullable NSString *)animationID context:(nullable void *)context;
 # 设置完动画参数后, 开始动画
 + (void)commitAnimations;
 # 设置代理, 代理可以遵循也可以不
 + (void)setAnimationDelegate:(nullable id)delegate;                 // default = nil
 # 动画将要开始时,触发的方法
 + (void)setAnimationWillStartSelector:(nullable SEL)selector;       // default = NULL. -animationWillStart:(NSString *)animationID context:(void *)context
 # 动画结束后执行的方法
 + (void)setAnimationDidStopSelector:(nullable SEL)selector;         // default = NULL. -animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
 # 设置动画执行的持续时间
 + (void)setAnimationDuration:(NSTimeInterval)duration;              // default = 0.2
 # 设置动画开始执行的延迟时间
 + (void)setAnimationDelay:(NSTimeInterval)delay;                    // default = 0.0
 + (void)setAnimationStartDate:(NSDate *)startDate;                  // default = now ([NSDate date])
 # 设置动画块中的动画属性变化的曲线 ,动画进入/退出视图的效果
 + (void)setAnimationCurve:(UIViewAnimationCurve)curve;              // default = UIViewAnimationCurveEaseInOut
 # 设置动画执行的次数
 + (void)setAnimationRepeatCount:(float)repeatCount;                 // default = 0.0.  May be fractional
 # 设置动画是否会"按原动画路径执行返回的动画"
 + (void)setAnimationRepeatAutoreverses:(BOOL)repeatAutoreverses;    // default = NO. used if repeat count is non-zero
 # 设置动画从当前状态开始播放
 + (void)setAnimationBeginsFromCurrentState:(BOOL)fromCurrentState;  // default = NO. If YES, the current view position is always used for new animations -- allowing animations to "pile up" on each other. Otherwise, the last end state is used for the animation (the default).
 
*/




/**
 
 2. core Animation 是直接作用在CALayer上的  并非（UIView上），coreAnimation的动画执行过程都是在后台操作的，不会阻塞主线程
 
 
 CoreAnimation 分为四种
---------------------------------------------
 1.CABasicAnimation
 
 通过设定起始点，终点，时间，动画会沿着你这设定点进行移动。可以看做特殊的CAKeyFrameAnimation

 
 keyPath附录表：
 
------------------------------------
 
 2. CAKeyframeAnimation 关键帧动画
 
 1.创建CAKeyframeAnimation对象
 
 + (instancetype)animationWithKeyPath:(nullable NSString *)path;
 通过设置方法的参数path去设置动画的keyPath属性
 
 2.设置动画的时间
 
 @property CFTimeInterval duration;
 
 3.设置动画开始的时间
 
 @property CFTimeInterval beginTime;
 
 4.设置每一关键帧的值
 
 @property(nullable, copy) NSArray *values;
 
 5.设置一个关键帧到另一个关键帧的时间(值为0-1)
 @property(nullable, copy) NSArray<CAMediaTimingFunction *> *timingFunctions;
 

 
 ------------------------------------------
 
 3.CAAnimationGroup
 组动画，是CAAnimation的子类
 可以保存一组动画对象，将CAAnimationGroup对象加入层后，组中所有动画对象可以同时并发运行,可以通过设置动画对象的beginTime属性来更改动画的开始时间
 
 ---------------------------------------------
 4.CATransition的实现
 
 转场动画，是CAAnimation的子类，，能够为层提供移出屏幕和移入屏幕的动画效果。
 UINavigationController就是通过CATransition实现了将控制器的视图推入屏幕的动画效果
 有以下效果可以使用：
 cube 方块
 suckEffect 三角
 rippleEffect 水波抖动
 pageCurl 上翻页
 pageUnCurl 下翻页
 oglFlip 上下翻转
 cameraIrisHollowOpen 镜头快门开
 cameraIrisHollowClose 镜头快门开
 
 
 
 
 
 
 -------------------------------
 停止动画
 
 CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
 
 // 让CALayer的时间停止走动
 layer.speed = 0.0;
 // 让CALayer的时间停留在pausedTime这个时刻
 layer.timeOffset = pausedTime;
 
 
 恢复动画
 
 CFTimeInterval pausedTime = layer.timeOffset;
 // 1. 让CALayer的时间继续行走
 layer.speed = 1.0;
 // 2. 取消上次记录的停留时刻
 layer.timeOffset = 0.0;
 // 3. 取消上次设置的时间
 layer.beginTime = 0.0;
 // 4. 计算暂停的时间(这里也可以用CACurrentMediaTime()-pausedTime)
 CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
 // 5. 设置相对于父坐标系的开始时间(往后退timeSincePause)
 layer.beginTime = timeSincePause;
 
 */


- (IBAction)CABasicAnimation:(id)sender {
    
    CALayer*scaleLayer = [[CALayer alloc] init];
    
    scaleLayer.backgroundColor = [UIColor blueColor].CGColor;
    scaleLayer.frame = CGRectMake(60, 20, 50, 50);
    scaleLayer.cornerRadius = 10;
    [self.view.layer addSublayer:scaleLayer];
    
    //动画类型
    CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //动画的起始状态
    scaleAnimation.fromValue = @1.0;
    //动画的结束状态
    scaleAnimation.toValue = @1.5;
    //如果设置为YES,代表动画每次重复执行的效果会跟上一次相反
    scaleAnimation.autoreverses = YES;
    /**
     * fillMode决定当前对象在非active时间段的行为。（要想fillMode有效，最好设置removedOnCompletion = NO）
     **/
    scaleAnimation.fillMode = kCAFillModeForwards;
    //动画重复次数
    scaleAnimation.repeatCount = MAXFLOAT;
    //动画持续时间
    scaleAnimation.duration = 0.8;
    //将动画添加到layer上面
    [scaleLayer addAnimation:scaleAnimation forKey:@"scaleAnimation"];

}


- (IBAction)CAKeyframeAnimation:(id)sender {
    
    CALayer* blackPoint = [[CALayer alloc]init];
    blackPoint.frame = CGRectMake(20, 180, 20, 20);
    blackPoint.backgroundColor = [UIColor blackColor].CGColor;
    blackPoint.cornerRadius = 10;
    [self.view.layer addSublayer:blackPoint];
    
    CGFloat originY = blackPoint.frame.origin.y;

    CAKeyframeAnimation* keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //记录每一个关键帧
    keyAnimation.values = @[[NSValue valueWithCGPoint:blackPoint.frame.origin],[NSValue valueWithCGPoint:CGPointMake(220, originY)],[NSValue valueWithCGPoint:blackPoint.frame.origin]];
    //可以为对应的关键帧指定对应的时间点，其取值范围为0到1.0，keyTimes中的每一个时间值都对应values中的每一帧。如果没有设置keyTimes，各个关键帧的时间是平分的
    keyAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1]];
    //指定时间函数
   // keyAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                      //               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    keyAnimation.repeatCount = 1000;
    keyAnimation.autoreverses = YES;
    keyAnimation.calculationMode = kCAAnimationLinear;
    keyAnimation.duration = 4;
    [blackPoint addAnimation:keyAnimation forKey:@"rectRunAnimation"];
}

- (IBAction)CAAnimationGroup:(id)sender {
    

}


- (IBAction)CATransition:(id)sender {
    
    
    CATransition* animation = [CATransition animation];
    animation.duration = 1.0f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //执行完是否移除
  //  animation.removedOnCompletion = NO;
    //过渡效果
    animation.type = @"suckEffect";
    //过渡方向
    animation.subtype = kCATransitionFromRight;
    //设置之后endProgress才有效
    animation.fillMode = kCAFillModeForwards;
    animation.endProgress = 1;
    [self.view.layer addAnimation:animation forKey:nil];
}

-(void)CABasicAnimation
{
    
    
   }

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    // Do any additional setup after loading the view, typically from a nib.
}




@end

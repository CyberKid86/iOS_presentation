//
//  VE_SettingsVC.m
//  ios_presentation
//
//  Created by Vasiliy Erema on 11/24/13.
//  Copyright (c) 2013 Vasil Erema. All rights reserved.
//

#warning NO_Autolayouts NO_ARC CAAnimation atomicProperty

#import "VE_SettingsVC.h"
#import "VE_AppSettings.h"
#import "VE_DataBase.h"

#import "QuartzCore/QuartzCore.h"

@interface VE_SettingsVC ()
{
    UIColor *_mistycColor;
}
@property (nonatomic, assign) IBOutlet UIButton *btnRandomColor;
@property (nonatomic, assign) IBOutlet UIButton *btnSaveColor;
@property (nonatomic, retain) UIColor *color;
@property (retain) UIColor *mistycColor;//unused
@end

@implementation VE_SettingsVC

- (void)setMistycColor:(UIColor *)color
{
    @synchronized(self)
    {
        [color retain];
        [_color release];
        color = color;
    }
}

- (UIColor *)mistycColor
{
    UIColor *retColor = nil;
    @synchronized(self)
    {
        retColor = [[_mistycColor retain] autorelease];
    }
    return retColor;
}


- (void)dealloc
{
    [_mistycColor release];
    [_color release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"AppSettings";//NSStringFromClass(self.class);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.color = [[VE_AppSettings sharedSettings] appColor];
    self.view.backgroundColor = _color;
    // Do any additional setup after loading the view from its nib.
}

- (UIColor *)randomColor
{
    return [UIColor colorWithRed:(arc4random()%255)/255.
                           green:(arc4random()%255)/255.
                            blue:(arc4random()%255)/255.
                           alpha:128/255.];
}

- (IBAction)saveColorAsDefault:(UIButton *)sender
{
    [VE_AppSettings sharedSettings].appColor = self.color;
    [[VE_DataBase sharedDataBase] saveData];
    [self btnTouchUp:sender];
}

- (IBAction)changeAndSaveAppColor:(UIButton *)sender
{
    UIColor *color = [self randomColor];
    self.view.backgroundColor = color;
    [self btnTouchUp:sender];
}

- (IBAction)btnTouchUp:(UIButton *)sender
{
    if (sender == self.btnRandomColor)
    {
        [sender.layer removeAnimationForKey:@"shakeAnimationGroup"];
    }
    else
    {
        CFTimeInterval duration = 0.07;
    
        CABasicAnimation *resizeAnimation =  [CABasicAnimation animationWithKeyPath: @"transform.scale"];
        resizeAnimation.removedOnCompletion = YES;
        resizeAnimation.fillMode = kCAFillModeForwards;
        resizeAnimation.duration = 4*duration;
        resizeAnimation.beginTime = 0;
        resizeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [resizeAnimation setFromValue:[NSNumber numberWithFloat:0.95]];
        [resizeAnimation setToValue:[NSNumber numberWithFloat: 1]];
        
        [sender.layer addAnimation:resizeAnimation
                            forKey:@"resizeAnimation"];
    }
}

- (IBAction)btnTouchDown:(UIButton *)sender
{
    CFTimeInterval duration = 0.07;
    
    if (sender == self.btnRandomColor)
    {
        CABasicAnimation* rotateAnimationRight =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
        rotateAnimationRight.removedOnCompletion = YES;
        rotateAnimationRight.fillMode = kCAFillModeForwards;
        rotateAnimationRight.duration = duration;
        rotateAnimationRight.beginTime = 0;
        rotateAnimationRight.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        rotateAnimationRight.autoreverses = YES;
        //    rotateAnimationRight.repeatCount = 1;
        [rotateAnimationRight setToValue:[NSNumber numberWithFloat: -M_PI_4/32]];
        
        CABasicAnimation *rotateAnimationLeft =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
        rotateAnimationLeft.removedOnCompletion = YES;
        rotateAnimationLeft.fillMode = kCAFillModeForwards;
        rotateAnimationLeft.duration = duration;
        rotateAnimationLeft.beginTime = 2*duration;
        rotateAnimationLeft.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        rotateAnimationLeft.autoreverses = YES;
        //    rotateAnimationLeft.repeatCount = 1;
        [rotateAnimationLeft setToValue:[NSNumber numberWithFloat: M_PI_4/32]];
        
        CAAnimationGroup *shakeAnimationGroup = [CAAnimationGroup animation];
        shakeAnimationGroup.duration = 4*duration;
        shakeAnimationGroup.removedOnCompletion = NO;
        shakeAnimationGroup.fillMode = kCAFillModeForwards;
        [shakeAnimationGroup setAnimations: @[rotateAnimationRight, rotateAnimationLeft]];
        shakeAnimationGroup.repeatCount = HUGE_VALF;
        //    shakeAnimationGroup.autoreverses = YES;
        shakeAnimationGroup.speed = 1;//0.1;
        
        [sender.layer addAnimation:shakeAnimationGroup
                            forKey:@"shakeAnimationGroup"];
    }
    else
    {
        CABasicAnimation *resizeAnimation =  [CABasicAnimation animationWithKeyPath: @"transform.scale"];
        resizeAnimation.removedOnCompletion = NO;
        resizeAnimation.fillMode = kCAFillModeForwards;
        resizeAnimation.duration = 4*duration;
        resizeAnimation.beginTime = 0;
        resizeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [resizeAnimation setToValue:[NSNumber numberWithFloat: 0.95]];
        
        [sender.layer addAnimation:resizeAnimation
                            forKey:@"resizeAnimation"];
    }
}

@end

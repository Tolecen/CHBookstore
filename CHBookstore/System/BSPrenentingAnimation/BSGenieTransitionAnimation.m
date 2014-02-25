//
//  BSGenieTransitionAnimation.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSGenieTransitionAnimation.h"
#import "WIBackdropBlurEffect.h"

@interface BSGenieTransitionAnimation ()
@property (nonatomic,weak) WIBackdropView *dimmingView;
@end

@implementation BSGenieTransitionAnimation

- (id)init {
    if (self = [super init]) {
        self.duration = 0.4;
    }
    return self;
}

- (CGRect)fromViewRectToPresentingViewControllerView {
    return [self.fromView convertRect:self.fromView.bounds toView:self.presentingViewController.view];
}

- (void)animatePresentViewController:(UIViewController *)presentedController completion:(void (^)(void))completion {
    NSParameterAssert(self.fromView);
    
    WIBackdropView *dimmingView = [[WIBackdropView alloc] initWithFrame:self.presentingViewController.view.bounds];
    dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    dimmingView.alpha = 0;
    dimmingView.contentMode = UIViewContentModeScaleAspectFill;
    dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dimmingView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)];
    [dimmingView addGestureRecognizer:tapGestureRecognizer];
    [presentedController.view.superview insertSubview:dimmingView belowSubview:presentedController.view];
    dimmingView.renderScale = 1;
    dimmingView.contentView = self.presentingViewController.view;
    dimmingView.effect = [[WIBackdropBlurEffect alloc] init];
    self.dimmingView = dimmingView;
    
    presentedController.view.frame = CGRectMake(0, self.presentingViewController.view.frame.size.height - presentedController.view.frame.size.height, presentedController.view.frame.size.width, presentedController.view.frame.size.height);
    presentedController.view.center = CGPointMake(self.presentingViewController.view.frame.size.width/2, self.presentingViewController.view.frame.size.height/2);
    if (self.snapToEdge) {
        CGRect frame = presentedController.view.frame;
        switch (self.edge) {
            case BCRectEdgeBottom:
                frame.origin.y = CGRectGetMaxY(self.fromViewRectToPresentingViewControllerView);
                break;
            case BCRectEdgeTop:
                frame.origin.y = CGRectGetMinY(self.fromViewRectToPresentingViewControllerView);
                break;
            case BCRectEdgeLeft:
                frame.origin.x = CGRectGetMinX(self.fromViewRectToPresentingViewControllerView);
                break;
            case BCRectEdgeRight:
                frame.origin.x = CGRectGetMaxX(self.fromViewRectToPresentingViewControllerView);
                break;
            default:
                break;
        }
        presentedController.view.frame = frame;
    }
    presentedController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    if ([UIInterpolatingMotionEffect class]) {
        UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        xAxis.minimumRelativeValue = [NSNumber numberWithFloat:-10.0];
        xAxis.maximumRelativeValue = [NSNumber numberWithFloat:10.0];
        
        UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        yAxis.minimumRelativeValue = [NSNumber numberWithFloat:-10.0];
        yAxis.maximumRelativeValue = [NSNumber numberWithFloat:10.0];
        
        UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
        group.motionEffects = @[xAxis, yAxis];
        [presentedController.view addMotionEffect:group];
    }
    
    [presentedController.view genieOutTransitionWithDuration:self.duration startRect:self.fromViewRectToPresentingViewControllerView startEdge:self.edge completion:^{
        if (completion) completion();
    }];
    
    [UIView animateWithDuration:self.duration animations:^{
        self.dimmingView.alpha = 1;
    }];
}

- (void)dimmingViewTapped:(UITapGestureRecognizer *)sender {
    if (self.dimmingViewTappedBlock) {
        self.dimmingViewTappedBlock(self);
    }
}

- (void)animateDismissViewController:(UIViewController *)dismissedViewController completion:(void (^)(void))completion {
    [dismissedViewController.view genieInTransitionWithDuration:self.duration destinationRect:self.fromViewRectToPresentingViewControllerView destinationEdge:self.edge completion:^{
        if (completion) completion();
    }];
    [UIView animateWithDuration:self.duration animations:^{
        self.dimmingView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.dimmingView removeFromSuperview];
    }];
}

@end

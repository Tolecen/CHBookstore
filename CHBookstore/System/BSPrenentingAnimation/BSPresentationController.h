//
//  BSPresentationController.h
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSPresentationControllerTransitionAnimation;
@interface BSPresentationController : NSObject


- (NSArray *)presentedViewControllers;

+ (instancetype)presentationControllerWithViewController:(UIViewController *)viewController;

- (void)presentViewController:(UIViewController *)viewControllerToPresent
					animation:(BSPresentationControllerTransitionAnimation *)animation
				   completion:(void (^)(void))completion;

- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end

@interface BSPresentationControllerTransitionAnimation : NSObject

@property (nonatomic,readonly,weak) BSPresentationController *presentationController;
@property (nonatomic,readonly,weak) UIViewController *presentingViewController;

@property (nonatomic) NSTimeInterval duration; //default 0.3

+ (instancetype)animation;

- (void)animatePresentViewController:(UIViewController *)presentedController completion:(void (^)(void))completion;
- (void)animateDismissViewController:(UIViewController *)dismissedViewController completion:(void (^)(void))completion;

@end

@interface UIViewController (BSPresentationController)

@property (nonatomic,readonly) BSPresentationController *presentationController;

@end

//
//  BSPresentationController.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSPresentationController.h"

#pragma mark - Transition Animation

@interface BSPresentationControllerTransitionAnimation ()
@property (nonatomic,readwrite,weak) BSPresentationController *presentationController;
@property (nonatomic,readwrite,weak) UIViewController *presentingViewController;
@end

@implementation BSPresentationControllerTransitionAnimation

+ (instancetype)animation {
    return [[self alloc] init];
}

- (id)init {
    if (self = [super init]) {
        self.duration = 0.3;
    }
    return self;
}

- (void)animatePresentViewController:(UIViewController *)presentedController completion:(void (^)(void))completion {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ Incomplete implementation. animatePresentViewController:completion:", NSStringFromClass([self class])] userInfo:nil];
}

- (void)animateDismissViewController:(UIViewController *)dismissedViewController completion:(void (^)(void))completion {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ Incomplete implementation. animateDismissViewController:completion:", NSStringFromClass([self class])] userInfo:nil];
	
}

@end

#pragma mark - Controller State

@interface BSPresentationControllerState : NSObject

@property (nonatomic,weak) UIViewController *presentedViewController;
@property (nonatomic,strong) BSPresentationControllerTransitionAnimation *animation;
+ (instancetype)presentationControllerStateWithPresentedViewController:(UIViewController *)presentedViewController animation:(BSPresentationControllerTransitionAnimation *)animation;

@end

@implementation BSPresentationControllerState

+ (instancetype)presentationControllerStateWithPresentedViewController:(UIViewController *)presentedViewController animation:(BSPresentationControllerTransitionAnimation *)animation {
    BSPresentationControllerState *state = [[BSPresentationControllerState alloc] init];
    state.presentedViewController = presentedViewController;
    state.animation = animation;
    return state;
}

@end

#pragma mark - WIPresentationController

static BOOL WIPresentationControllerSizeIsEmpty(CGSize size) {
    if (size.width > 0 && size.height > 0) return NO;
    else return YES;
}

@interface BSPresentationController ()
@property (nonatomic,weak) UIViewController *presentingViewController;
@property (nonatomic,strong) NSArray *presentationStateStack;
@property (nonatomic,strong) NSArray *presentedViewControllerViewInitialFrames;
@end

@implementation BSPresentationController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ Failed to call designated initializer. Invoke `+initWithViewController:` instead.", NSStringFromClass([self class])] userInfo:nil];
}

- (id)initWithViewController:(UIViewController *)viewController{
    if (self = [super init]) {
        self.presentingViewController = viewController;
    }
    return self;
}

+ (instancetype)presentationControllerWithViewController:(UIViewController *)viewController {
    return [[self alloc] initWithViewController:viewController];
}

- (NSArray *)presentedViewControllers {
    if (self.presentationStateStack) {
        return [self.presentationStateStack valueForKeyPath:@"presentedViewController"];
    }
    return nil;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent
                    animation:(BSPresentationControllerTransitionAnimation *)animation
                   completion:(void (^)(void))completion
{
    CGSize contentSize;
    if ([viewControllerToPresent respondsToSelector:@selector(preferredContentSize)] && !WIPresentationControllerSizeIsEmpty(viewControllerToPresent.preferredContentSize)) {
        contentSize = viewControllerToPresent.preferredContentSize;
    } else if (!WIPresentationControllerSizeIsEmpty(viewControllerToPresent.contentSizeForViewInPopover)) {
        contentSize = viewControllerToPresent.contentSizeForViewInPopover;
    } else {
        contentSize = self.presentingViewController.view.frame.size;
    }
    CGFloat maxWidth = CGRectGetWidth(self.presentingViewController.view.frame);
    CGFloat maxHeight = CGRectGetHeight(self.presentingViewController.view.frame);
    
    if (contentSize.width > maxWidth) contentSize.width = maxWidth;
    if (contentSize.height > maxHeight) contentSize.height = maxHeight;
    
    animation.presentationController = self;
    animation.presentingViewController = self.presentingViewController;
    
    [self.presentingViewController addChildViewController:viewControllerToPresent];
    
    [viewControllerToPresent beginAppearanceTransition:YES animated:animation?YES:NO];
    
    viewControllerToPresent.view.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    viewControllerToPresent.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.presentingViewController.view addSubview:viewControllerToPresent.view];
    
    BSPresentationControllerState *state = [BSPresentationControllerState presentationControllerStateWithPresentedViewController:viewControllerToPresent animation:animation];
    self.presentationStateStack = [[NSArray arrayWithArray:self.presentationStateStack] arrayByAddingObject:state];
    
    __weak __typeof(&*self)weakSelf = self;
    void (^animationCompletionBlock)(void) = ^{
        [viewControllerToPresent endAppearanceTransition];
        [viewControllerToPresent didMoveToParentViewController:weakSelf.presentingViewController];
        
        weakSelf.presentedViewControllerViewInitialFrames = [[NSArray arrayWithArray:weakSelf.presentedViewControllerViewInitialFrames] arrayByAddingObject:[NSValue valueWithCGRect:viewControllerToPresent.view.frame]];
        
        if (completion) completion();
    };
    
    if (animation) {
        [animation animatePresentViewController:viewControllerToPresent completion:^{
            animationCompletionBlock();
        }];
    } else {
        animationCompletionBlock();
    }
}

- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    BSPresentationControllerState *currentState = [self.presentationStateStack lastObject];
    NSMutableArray *stateStack = [NSMutableArray arrayWithArray:self.presentationStateStack];
    [stateStack removeObject:currentState];
    self.presentationStateStack = stateStack.copy;
    
    if (currentState) {
        UIViewController *viewControllerToDismiss = currentState.presentedViewController;
        BSPresentationControllerTransitionAnimation *animation = currentState.animation;
        [viewControllerToDismiss willMoveToParentViewController:nil];
		
        __weak __typeof(&*self)weakSelf = self;
        
        void (^animationCompletionBlock)(void) = ^{
            [viewControllerToDismiss.view removeFromSuperview];
            [viewControllerToDismiss endAppearanceTransition];
            [viewControllerToDismiss removeFromParentViewController];
            
            NSMutableArray *presentedViewControllerViewInitialFrames = [NSMutableArray arrayWithArray:weakSelf.presentedViewControllerViewInitialFrames];
            [presentedViewControllerViewInitialFrames removeObject:presentedViewControllerViewInitialFrames.lastObject];
            weakSelf.presentedViewControllerViewInitialFrames = presentedViewControllerViewInitialFrames.copy;
            
            if (completion) completion();
        };
        
        if (animated && animation) {
            [viewControllerToDismiss beginAppearanceTransition:NO animated:YES];
            [animation animateDismissViewController:viewControllerToDismiss completion:^{
                animationCompletionBlock();
            }];
        } else {
            [viewControllerToDismiss beginAppearanceTransition:NO animated:NO];
            animationCompletionBlock();
        }
    }
}

@end

#pragma mark - UIViewController (WIPresentationController)

#import <objc/runtime.h>

NSString * const WIViewControllerPresentationControllerAssocationKey = @"WIViewControllerPresentationControllerAssocationKey";

@implementation UIViewController (WIPresentationController)
- (BSPresentationController *)presentationController {
    BSPresentationController *_presentationController = objc_getAssociatedObject(self, &WIViewControllerPresentationControllerAssocationKey);
    if (!_presentationController) {
        _presentationController = [BSPresentationController presentationControllerWithViewController:self];
        objc_setAssociatedObject(self, &WIViewControllerPresentationControllerAssocationKey, _presentationController, OBJC_ASSOCIATION_RETAIN);
    }
    return _presentationController;
}

@end

//
//  BSGenieTransitionAnimation.h
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSPresentationController.h"
#import <BCGenieEffect/UIView+Genie.h>

@interface BSGenieTransitionAnimation : BSPresentationControllerTransitionAnimation

@property (nonatomic) BCRectEdge edge;

@property (nonatomic,weak) UIView *fromView;

@property (nonatomic) BOOL snapToEdge;

@property (nonatomic,copy) void (^dimmingViewTappedBlock)(BSPresentationControllerTransitionAnimation *sender);


@end

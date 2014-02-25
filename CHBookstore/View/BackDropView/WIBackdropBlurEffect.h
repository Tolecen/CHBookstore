//
//  WIBackdropBlurEffect.h
//  Weico
//
//  Created by YuAo on 6/27/13.
//  Copyright (c) 2013 北京微酷奥网络技术有限公司. All rights reserved.
//

#import "WIBackdropView.h"

typedef NS_ENUM(NSInteger, WIBackdropBlurEffectStyle) {
    WIBackdropBlurEffectStyleDark,
    WIBackdropBlurEffectStyleLight,
    WIBackdropBlurEffectStyleExtraLight
};

@interface WIBackdropBlurEffect : WIBackdropEffect

@property (nonatomic) WIBackdropBlurEffectStyle blurStyle;

@end

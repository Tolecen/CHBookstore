//
//  WIBackdropBlurEffect.m
//  Weico
//
//  Created by YuAo on 6/27/13.
//  Copyright (c) 2013 北京微酷奥网络技术有限公司. All rights reserved.
//

#import "WIBackdropBlurEffect.h"
#import "UIImage+BlurEffects.h"

@implementation WIBackdropBlurEffect

- (id)init {
    if (self = [super init]) {
        self.blurStyle = WIBackdropBlurEffectStyleDark;
    }
    return self;
}

- (UIImage *)imageByApplyingEffectToInputImage:(UIImage *)inputImage {
    UIImage *image;
    switch (self.blurStyle) {
        case WIBackdropBlurEffectStyleLight:
            image = [inputImage imageByApplyingLightBlurEffect];
            break;
        case WIBackdropBlurEffectStyleDark:
            image = [inputImage imageByApplyingDarkBlurEffect];
            break;
        case WIBackdropBlurEffectStyleExtraLight:
            image = [inputImage imageByApplyingExtraLightBlurEffect];
            break;
        default:
            break;
    }
    return image;
}

@end

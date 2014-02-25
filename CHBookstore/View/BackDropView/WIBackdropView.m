//
//  WIBackdropView.m
//  Weico
//
//  Created by YuAo on 6/27/13.
//  Copyright (c) 2013 北京微酷奥网络技术有限公司. All rights reserved.
//

#import "WIBackdropView.h"

@implementation WIBackdropEffect

- (UIImage *)imageByApplyingEffectToInputImage:(UIImage *)inputImage {
    return inputImage;
}

@end

@implementation WIBackdropView

- (void)setEffect:(WIBackdropEffect *)effect {
    _effect = effect;
    [self setNeedsDisplay];
}

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.effect && self.contentView) {
        if ([self.contentView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            CGRect contentViewRect = [self.contentView convertRect:self.contentView.bounds toView:self];
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.renderScale);
            [self.contentView drawViewHierarchyInRect:CGRectMake(contentViewRect.origin.x, contentViewRect.origin.y, self.bounds.size.width, self.bounds.size.height) afterScreenUpdates:NO];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [[self.effect imageByApplyingEffectToInputImage:image] drawInRect:rect];
        }
    }
}

@end

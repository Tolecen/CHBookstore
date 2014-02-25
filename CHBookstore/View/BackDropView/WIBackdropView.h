//
//  WIBackdropView.h
//  Weico
//
//  Created by YuAo on 6/27/13.
//  Copyright (c) 2013 北京微酷奥网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIBackdropEffect : NSObject
//Subclassing
- (UIImage *)imageByApplyingEffectToInputImage:(UIImage *)inputImage;
@end


@interface WIBackdropView : UIView

@property (nonatomic) CGFloat renderScale; //default 0, mainScreen.scale

@property (nonatomic,strong) WIBackdropEffect *effect;

@property (nonatomic,weak) UIView *contentView;

@end

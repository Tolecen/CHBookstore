//
//  UIViewController+PreferredContentSize.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+PreferredContentSize.h"
#import <objc/runtime.h>

@implementation UIViewController (PreferredContentSize)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		@autoreleasepool {
			if (![self instancesRespondToSelector:@selector(preferredContentSize)]) {
				class_addMethod(self,
								@selector(preferredContentSize),
								class_getMethodImplementation(self, @selector(bs_preferredContentSize)),
								method_getTypeEncoding(class_getInstanceMethod(self, @selector(bs_preferredContentSize))));
			}
			if (![self instancesRespondToSelector:@selector(setPreferredContentSize:)]) {
				class_addMethod(self,
								@selector(setPreferredContentSize:),
								class_getMethodImplementation(self, @selector(bs_setPreferredContentSize:)),
								method_getTypeEncoding(class_getInstanceMethod(self, @selector(bs_setPreferredContentSize:))));
			}
		}
	});
}

- (void)bs_setPreferredContentSize:(CGSize)contentSize {
    self.contentSizeForViewInPopover = contentSize;
}

- (CGSize)bs_preferredContentSize {
    return self.contentSizeForViewInPopover;
}

@end

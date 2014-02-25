//
//  BSGlobalSettings.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSGlobalSettings.h"
#import "BSSettingStore.h"

@implementation BSGlobalSettings

+ (NSDictionary *)settingPropertyKeysWithDefaultValues {
	return @{@"fontSize": @(15.f),
			 @"linespacingMode": @(BSLinespacingModeMin),
			 @"readingMode": @(BSReadingModeSoft),
			 @"shelfThemeMode": @(BSShelfThemeModeColorful)
		};
}

+ (NSString *)settingPropertyKeyPrefix {
	return BSSettingStoreGlobalSettingKeyPrefix;
}

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		@autoreleasepool {
			[self installSettingHelper];
		}
	});
}

@end

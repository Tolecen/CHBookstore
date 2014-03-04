//
//  BSGlobalSettings.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSGlobalSettings.h"
#import "BSSettingStore.h"

CGFloat linespacingHeightFromLinespacingmode(BSLinespacingMode mode) {
	switch (mode) {
		case BSLinespacingModeMax:
			return 1.8;
			break;
		case BSLinespacingModeMiddle:
			return 1.6;
			break;
		case BSLinespacingModeMin:
			return 1.2;
			break;
		default:
			break;
	}
}

UIColor *colorFromReadingMode(BSReadingMode mode) {
	switch (mode) {
		case BSReadingModeDay:
			return [UIColor blackColor];
			break;
		case BSReadingModeSoft:
			return [UIColor blackColor];
			break;
		case BSReadingModeNight:
			return [UIColor whiteColor];
			break;
		default:
			break;
	}
}

void backgroundColorFromReadingMode(BSReadingMode mode,CGContextRef ctx) {
	switch (mode) {
		case BSReadingModeDay:
			CGContextSetRGBFillColor(ctx, 0.99f, 0.99f, 0.99f, 1.0f);
			break;
		case BSReadingModeSoft:
			CGContextSetRGBFillColor(ctx, 0.59f, 0.59f, 0.59f, 1.0f);
			break;
		case BSReadingModeNight:
			CGContextSetRGBFillColor(ctx, 0.01f, 0.01f, 0.01f, 1.0f);
			break;
		default:
			break;
	}
}

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

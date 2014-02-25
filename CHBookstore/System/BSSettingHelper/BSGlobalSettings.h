//
//  BSGlobalSettings.h
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSAbstractSettings.h"

typedef NS_ENUM(NSInteger, BSReadingMode) {
	BSReadingModeDay = 0,
	BSReadingModeSoft = 1,
	BSReadingModeNight = 2
};

typedef NS_ENUM(NSInteger, BSLinespacingMode) {
	BSLinespacingModeMin = 0,
	BSLinespacingModeMiddle = 1,
	BSLinespacingModeMax = 2
};

typedef NS_ENUM(NSInteger, BSShelfThemeMode) {
	BSShelfThemeModeColorful = 0,
	BSShelfThemeModeTexture = 1,
	BSShelfThemeModeWoodiness = 2,
	BSShelfThemeModeBlack = 3,
	BSShelfThemeModeBizarre = 4
};

@interface BSGlobalSettings : BSAbstractSettings

@property (nonatomic) float fontSize;

@property (nonatomic) BSLinespacingMode linespacingMode;

@property (nonatomic) BSReadingMode readingMode;

@property (nonatomic) BSShelfThemeMode shelfThemeMode;

@end

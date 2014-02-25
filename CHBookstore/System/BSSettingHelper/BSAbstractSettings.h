//
//  BSAbstractSettings.h
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSSettingStore;
@interface BSAbstractSettings : NSObject

@property (nonatomic, strong, readonly) NSDictionary *defaultSettings;

- (instancetype)initWithSettingStore:(BSSettingStore *)settingStore;

+ (void)installSettingHelper;

@end

@interface BSAbstractSettings (SubclassingHooks)

+ (NSString *)settingPropertyKeyPrefix;

+ (NSDictionary *)settingPropertyKeysWithDefaultValues;

@end

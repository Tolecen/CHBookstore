//
//  BSSettingStore.h
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

//#import "IASKSettingsStore.h"
#import "BSGlobalSettings.h"

extern NSString *const BSSettingStoreGlobalSettingKeyPrefix;
//Notification
extern NSString *const BSSettingStoreSettingDidChangeNotification;
extern NSString *const BSSettingStoreChangedSettingKey;
extern NSString *const BSSettingStoreChangedSettingOldValueKey;
extern NSString *const BSSettingStoreChangedSettingNewValueKey;


@interface BSSettingStore : IASKAbstractSettingsStore

+ (BSSettingStore *)defaultStore;

- (void)purgeAllSettings;

@end

@interface BSSettingStore (Helper)

@property (nonatomic, strong, readonly) BSGlobalSettings *globalSettings;

@end

//
//  BSSettingStore.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

NSString *const BSSettingStoreGlobalSettingKeyPrefix = @"G_";

NSString *const BSSettingStoreSettingDidChangeNotification = @"BSSettingStoreSettingDidChangeNotification";
NSString *const BSSettingStoreChangedSettingKey = @"BSSettingStoreChangedSettingKey";
NSString *const BSSettingStoreChangedSettingOldValueKey = @"BSSettingStoreChangedSettingOldValueKey";
NSString *const BSSettingStoreChangedSettingNewValueKey = @"BSSettingStoreChangedSettingNewValueKey";

#import "BSSettingStore.h"

@interface BSSettingStore()

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong, readwrite) NSDictionary *applicationGlobalSettings;

@end

@implementation BSSettingStore

+ (BSSettingStore *)defaultStore {
	static BSSettingStore *_defaultStore = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_defaultStore = [[BSSettingStore alloc] initWithName:@"Default"];
	});
	return _defaultStore;
}

- (id)init {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ Failed to call designated initializer. Invoke `initWithName:` instead.", NSStringFromClass([self class])] userInfo:nil];
}

- (id)initWithName:(NSString *)name {
	if (self = [super init]) {
		NSParameterAssert(name);
		self.name = name;
	}
	return self;
}

- (NSString *)settingFloderPath {
	return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}

- (NSString *)globalSettingFilePath {
	return [[self settingFloderPath] stringByAppendingPathComponent:@"GlobalSettings.plist"];
}

- (NSDictionary *)applicationGlobalSettings {
	if (!_applicationGlobalSettings) {
		NSMutableDictionary *applicationGlobalSettings = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:self.globalSettingFilePath]];
        [self.globalSettings.defaultSettings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (!applicationGlobalSettings[key]) {
                applicationGlobalSettings[key] = obj;
            }
        }];
        _applicationGlobalSettings = applicationGlobalSettings.copy;
	}
	return _applicationGlobalSettings;
}

- (void)setObject:(id)value forKey:(NSString *)key {
	void(^setKeyValueInDictionary)(NSMutableDictionary*) = ^(NSMutableDictionary *dictionary) {
        id oldValue = dictionary[key];
        dictionary[key] = value;
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[BSSettingStoreChangedSettingKey] = key;
        userInfo[BSSettingStoreChangedSettingNewValueKey] = value;
        if (oldValue) { userInfo[BSSettingStoreChangedSettingOldValueKey] = oldValue; }
        [[NSNotificationCenter defaultCenter] postNotificationName:BSSettingStoreSettingDidChangeNotification object:self userInfo:userInfo.copy];
    };
    if ([key hasPrefix:BSSettingStoreGlobalSettingKeyPrefix]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.applicationGlobalSettings];
        setKeyValueInDictionary(dictionary);
        self.applicationGlobalSettings = dictionary.copy;
    }
    [self synchronize];
}

- (id)objectForKey:(NSString *)key {
	if ([key hasPrefix:BSSettingStoreGlobalSettingKeyPrefix]) {
		return self.applicationGlobalSettings[key];
	}
	return nil;
}

- (BOOL)synchronize {
	[self.applicationGlobalSettings writeToFile:[self globalSettingFilePath] atomically:YES];
	return YES;
}

- (void)purgeAllSettings {
	
}

@end

#import <objc/runtime.h>

@implementation BSSettingStore (Helper)

- (BSGlobalSettings *)globalSettings {
	static NSString *BSSettingStoreGlobalSettingAssociationKey = @"BSSettingStoreGlobalSettingAssociationKey";
	BSGlobalSettings *globalSettings = objc_getAssociatedObject(self, &BSSettingStoreGlobalSettingAssociationKey);
	if (!globalSettings) {
		globalSettings = [[BSGlobalSettings alloc] initWithSettingStore:self];
		objc_setAssociatedObject(self, &BSSettingStoreGlobalSettingAssociationKey, globalSettings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return globalSettings;
}

@end

//
//  BSAbstractSettings.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSAbstractSettings.h"
#import "BSSettingStore.h"
#import <objc/runtime.h>

@interface BSAbstractSettings()

@property (nonatomic, weak) BSSettingStore *settingStore;

@property (nonatomic, strong, readwrite) NSDictionary *defaultSettings;

@end

@implementation BSAbstractSettings

- (instancetype)initWithSettingStore:(BSSettingStore *)settingStore {
	if (self = [super init]) {
		self.settingStore = settingStore;
		[self generateDefaultSettings];
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			[self.class installSettingHelper];
		});
	}
	return self;
}

- (void)generateDefaultSettings {
	NSDictionary *settingPropertyKeysAndDefaultValues = [self.class settingPropertyKeysWithDefaultValues];
	NSMutableDictionary *defaultSettings = [NSMutableDictionary dictionary];
	[settingPropertyKeysAndDefaultValues enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
		NSString *settingKey = [self.class settingKeyForPropertyKey:key];
		if (settingKey.length) {
			defaultSettings[settingKey] = obj;
		}
	}];
	self.defaultSettings = defaultSettings.copy;
}

+ (NSString *)settingKeyForPropertyKey:(NSString *)key {
	if (key.length) {
		NSString *firstPart = [[key substringToIndex:1] uppercaseString];
		NSString *reminigs = [key substringFromIndex:1];
        NSString *settingKey = [[self.class settingPropertyKeyPrefix] stringByAppendingString:[firstPart stringByAppendingString:reminigs]];
        return settingKey;
	}
	return nil;
}

+ (void)installSettingHelper {
    NSArray *propertyKeys = [self.class settingPropertyKeysWithDefaultValues].allKeys;
    for (NSString *key in propertyKeys) {
        if (key.length) {
            NSString *settingKey = [self settingKeyForPropertyKey:key];
            {
                //Get
                SEL selector = NSSelectorFromString(key);
                Method method = class_getInstanceMethod(self, selector);
                NSMethodSignature *methodSignature = [self instanceMethodSignatureForSelector:selector];
				
                if (method && methodSignature) {
                    const char * type = methodSignature.methodReturnType;
                    if (strcmp(type, @encode(id)) == 0) {
                        method_setImplementation(method, imp_implementationWithBlock(^ id (id _self){
                            return [[_self settingStore] objectForKey:settingKey];
                        }));
                    }
                    if (strcmp(type, @encode(int)) == 0) {
                        method_setImplementation(method, imp_implementationWithBlock(^ NSInteger (id _self){
                            return [[_self settingStore] integerForKey:settingKey];
                        }));
                    }
                    if (strcmp(type, @encode(BOOL)) == 0) {
                        method_setImplementation(method, imp_implementationWithBlock(^ BOOL (id _self){
                            return [[_self settingStore] boolForKey:settingKey];
                        }));
                    }
                    if (strcmp(type, @encode(float)) == 0) {
                        method_setImplementation(method, imp_implementationWithBlock(^ float (id _self){
                            return [[_self settingStore] floatForKey:settingKey];
                        }));
                    }
                    if (strcmp(type, @encode(double)) == 0) {
                        method_setImplementation(method, imp_implementationWithBlock(^ double (id _self){
                            return [[_self settingStore] doubleForKey:settingKey];
                        }));
                    }
                }
            }
            
            {
                //Set
                NSString *firstPart = [key substringToIndex:1].uppercaseString;
                NSString *reminigs = [key substringFromIndex:1];
                SEL selector = NSSelectorFromString([[@"set" stringByAppendingString:[firstPart stringByAppendingString:reminigs]] stringByAppendingString:@":"]);
                Method method = class_getInstanceMethod(self, selector);
                NSMethodSignature *methodSignature = [self instanceMethodSignatureForSelector:selector];
                
                if (method && methodSignature && methodSignature.numberOfArguments == 3) {
                    const char * type = [methodSignature getArgumentTypeAtIndex:2];
                    if (strcmp(type, @encode(id)) == 0) {
                        method_setImplementation(method, imp_implementationWithBlock(^ (id _self, id arg){
                            [[_self settingStore] setObject:arg forKey:settingKey];
                        }));
                    }
                    if (strcmp(type, @encode(int)) == 0) {
                        method_setImplementation(method, imp_implementationWithBlock(^ (id _self, int arg){
                            [[_self settingStore] setInteger:arg forKey:settingKey];
                        }));
                    }
                    if (strcmp(type, @encode(BOOL)) == 0) {
                        method_setImplementation(method, imp_implementationWithBlock(^ (id _self, BOOL arg){
                            [[_self settingStore] setBool:arg forKey:settingKey];
                        }));
                    }
                    if (strcmp(type, @encode(float)) == 0) {
                        method_setImplementation(method, imp_implementationWithBlock(^ (id _self, float arg){
                            [[_self settingStore] setFloat:arg forKey:settingKey];
                        }));
                    }
                    if (strcmp(type, @encode(double)) == 0) {
                        method_setImplementation(method, imp_implementationWithBlock(^ (id _self, double arg){
                            [[_self settingStore] setDouble:arg forKey:settingKey];
                        }));
                    }
                }
            }
        }
    }
}

+ (NSString *)settingPropertyKeyPrefix {
	return @"";
}

+ (NSDictionary *)settingPropertyKeysWithDefaultValues {
	return @{};
}

@end
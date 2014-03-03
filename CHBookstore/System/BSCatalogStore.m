//
//  BSCatalogStore.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-3-3.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSCatalogStore.h"

@interface BSCatalogStore()

@property (nonatomic, copy, readwrite) NSString *bookName;

@property (nonatomic, readwrite) NSInteger volumeCount;

@property (nonatomic, copy)	NSString *JSONFile;

@property (nonatomic, strong) NSDictionary *catalogDictionary;

@end

@implementation BSCatalogStore

- (id)initWithJSONFile:(NSString *)JSONFile {
	if (self = [super init]) {
		self.JSONFile = JSONFile;
	}
	return self;
}

- (void)setJSONFile:(NSString *)JSONFile {
	if (_JSONFile == JSONFile) {
		return;
	}
	_JSONFile = JSONFile;
	[self parserJSONFile:JSONFile];
}

- (void)parserJSONFile:(NSString *)JSONFile {
	self.catalogDictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:JSONFile] options:NSJSONReadingAllowFragments error:nil];
}

- (NSString *)bookName {
	return self.catalogDictionary[@"bookname"];
}

- (NSInteger)volumeCount {
	return [self.catalogDictionary[@"total_volumes"] integerValue];
}

- (NSArray *)catalogsInVolume:(NSInteger)volume {
	return [self.catalogDictionary valueForKeyPath:[NSString stringWithFormat:@"%d.catalog",volume]];
}

- (NSString *)volumeName:(NSInteger)volume {
	return [self.catalogDictionary valueForKeyPath:[NSString stringWithFormat:@"%d.title",volume]];
}

- (void)dealloc {
	_catalogDictionary = nil;
}

@end

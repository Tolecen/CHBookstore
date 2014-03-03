//
//  BSCatalogStore.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-3-3.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSCatalogStore.h"

@interface BSCatalogStore()

@property (nonatomic, readwrite) NSInteger catalogSectionCount;

@property (nonatomic, readwrite) NSInteger catalogItemInSection;

@property (nonatomic, copy)	NSString *catalogJSONFile;

@end

@implementation BSCatalogStore

- (id)initWithCatalogJSONFile:(NSString *)catalogJSONFile {
	if (self = [super init]) {
		self.catalogJSONFile = catalogJSONFile;
	}
	return self;
}

- (void)setCatalogJSONFile:(NSString *)catalogJSONFile {
	if (_catalogJSONFile == catalogJSONFile) {
		return;
	}
	_catalogJSONFile = catalogJSONFile;
	[self parserCatalogJSONFile:catalogJSONFile];
}

- (void)parserCatalogJSONFile:(NSString *)catalogJSONFile {

}

@end

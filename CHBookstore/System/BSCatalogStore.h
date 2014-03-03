//
//  BSCatalogStore.h
//  CHBookstore
//
//  Created by liuxiaoyu on 14-3-3.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSCatalogStore : NSObject

@property (nonatomic, copy, readonly) NSString *bookName;

@property (nonatomic, readonly)	NSInteger volumeCount;

- (id)initWithJSONFile:(NSString *)JSONFile;

- (NSArray *)catalogsInVolume:(NSInteger)volume;

- (NSString *)volumeName:(NSInteger)volume;

@end

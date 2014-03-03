//
//  BSCatalogStore.h
//  CHBookstore
//
//  Created by liuxiaoyu on 14-3-3.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSCatalogStore : NSObject

@property (nonatomic, readonly)	NSInteger catalogSectionCount;

@property (nonatomic, readonly) NSInteger catalogItemInSection;

- (id)initWithCatalogJSONFile:(NSString *)catalogJSONFile;
@end

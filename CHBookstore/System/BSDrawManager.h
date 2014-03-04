//
//  BSDrawManager.h
//  CHBookstore
//
//  Created by liuxiaoyu on 14-3-4.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSPageInfo : NSObject

@property (nonatomic) NSInteger pageIndex;

@property (nonatomic) NSInteger pageLength;

@end

@interface BSDrawManager : NSObject

@property (nonatomic, copy) NSString *txtElement;

@property (nonatomic, copy) NSString *volumeName;

@property (nonatomic) NSUInteger totalPages;

+ (BSDrawManager *)defaultManager;

- (void)renderInContext:(CGContextRef)ctx pageIndex:(NSUInteger)index;

- (void)divideParagraphs:(NSString *)txtElement flags:(NSMutableArray *)flags;

@end

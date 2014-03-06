//
//  BSReadingVC.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-3-4.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSReadingVC.h"
#import "LeavesView.h"
#import "BSDrawManager.h"

@interface BSReadingVC ()

@property (nonatomic, strong) BSDrawManager *defaultManager;

@property (nonatomic, strong) NSMutableArray *pageInfoArray;

@property (nonatomic) NSUInteger currentPageIndex;

@end

@implementation BSReadingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.defaultManager = [BSDrawManager defaultManager];
	self.navigationController.navigationBarHidden = YES;
	
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"1_1" ofType:@"txt"];
	NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	
	self.defaultManager.txtElement = content;
	self.pageInfoArray = [NSMutableArray array];
	[self.defaultManager divideParagraphs:content flags:self.pageInfoArray];
	
	if (_currentPageIndex >= [self.pageInfoArray count]) {
		_currentPageIndex = self.pageInfoArray.count - 1;
	}
	[leavesView reloadData:_currentPageIndex];
}

- (NSUInteger)numberOfPagesInLeavesView:(LeavesView *)leavesView {
	return self.pageInfoArray.count;
}

- (void)renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)context {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"1_1" ofType:@"txt"];
	NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

	BSPageInfo *pageInfo = self.pageInfoArray[index];
	self.defaultManager.txtElement = [content substringWithRange:NSMakeRange(pageInfo.pageIndex, pageInfo.pageLength)];
	self.defaultManager.totalPages = self.pageInfoArray.count;
	self.defaultManager.volumeName = self.volumeName;
	[self.defaultManager renderInContext:context pageIndex:index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

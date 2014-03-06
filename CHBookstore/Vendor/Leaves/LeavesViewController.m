//
//  LeavesViewController.m
//  Leaves
//
//  Created by Tom Brow on 4/18/10.
//  Copyright Tom Brow 2010. All rights reserved.
//

#import "LeavesViewController.h"

@implementation LeavesViewController

- (void)initialize
{
    CGFloat scale = [[UIScreen mainScreen] scale];
//    leavesView = [[LeavesView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, viewSize.width, viewSize.height)];
	leavesView = [[LeavesView alloc] initWithFrame:CGRectZero];
    leavesView.layer.contentsScale = scale;
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
   if (self = [super initWithNibName:nibName bundle:nibBundle]) 
   {
//	   if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_6_0) {
//		   viewSize = CGSizeMake(320, 568);
//	   } else {
//		   viewSize = CGSizeMake(320, 480);
//	   }
      [self initialize];
   }
   return self;
}

- (id)init 
{
   return [self initWithNibName:nil bundle:nil];
}

- (void) awakeFromNib {
	[super awakeFromNib];
	[self initialize];
}

- (void)dealloc {
    
	[leavesView release];
    [super dealloc];
    
}

#pragma mark LeavesViewDataSource methods

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView {
	return 0;
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx 
{
	
}

#pragma mark  UIViewController methods

- (void)loadView 
{
    CGFloat scale = [[UIScreen mainScreen] scale];
//	UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, viewSize.width, viewSize.height)];
//    aView.backgroundColor = [UIColor clearColor];
//    aView.layer.contentsScale = scale;
//    self.view = aView;
//    [aView release];
//    
//	[self.view addSubview:leavesView];
	
	self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.view.backgroundColor = [UIColor whiteColor];
	self.view.layer.contentsScale = scale;
	[self.view addSubview:leavesView];
}

- (void) viewDidLoad {
	[super viewDidLoad];
	leavesView.frame = self.view.bounds;
    [leavesView layoutSubviews];
	leavesView.dataSource = self;
	leavesView.delegate = self;
}

@end

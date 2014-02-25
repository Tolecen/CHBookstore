//
//  BSViewController.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-24.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSViewController.h"
#import "BSSettingVC.h"
#import "BSCollectionViewCell.h"
#import "BSGenieTransitionAnimation.h"

@interface BSViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) BSCollectionViewCell *nibCell;

@property (nonatomic, strong) UIBarButtonItem *settingBtn;

@property (nonatomic)	BOOL isSelected;

@end

@implementation BSViewController

- (BSCollectionViewCell *)nibCell {
	if (!_nibCell) {
		_nibCell = [[BSCollectionViewCell nib] instantiateWithOwner:nil options:nil].lastObject;
	}
	return _nibCell;
}

- (UIBarButtonItem *)settingBtn {
	if (!_settingBtn) {
		_settingBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bs_settings.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pushToSettingViewController:)];
	}
	return _settingBtn;
}

- (void)pushToSettingViewController:(UIBarButtonItem *)sender {
	if (self.isSelected) {
		self.isSelected = NO;
		[self.presentationController dismissViewControllerAnimated:YES completion:nil];
	} else {
		self.isSelected = YES;
		BSSettingVC *settingVC = [[BSSettingVC alloc] initWithNibName:@"BSSettingVC" bundle:nil];
		settingVC.preferredContentSize = CGSizeMake(320, 250);
		BSGenieTransitionAnimation *animation = [BSGenieTransitionAnimation animation];
		animation.fromView = [sender valueForKey:@"_view"];
		animation.edge = BCRectEdgeBottom;
		animation.snapToEdge = YES;
		__weak __typeof(&*self)weakSelf = self;
		[animation setDimmingViewTappedBlock:^(BSPresentationControllerTransitionAnimation *sender) {
			weakSelf.isSelected = NO;
			[sender.presentationController dismissViewControllerAnimated:YES completion:nil];
		}];
		[self.presentationController presentViewController:settingVC animation:animation completion:nil];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.settingBtn;
	[self.collectionView registerNib:[BSCollectionViewCell nib] forCellWithReuseIdentifier:self.nibCell.reuseIdentifier];
	
	NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
	NSLog(@"%@",path);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	BSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.nibCell.reuseIdentifier forIndexPath:indexPath];
	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

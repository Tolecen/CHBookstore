//
//  BSViewController.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-24.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSViewController.h"
#import "BSCollectionViewCell.h"

@interface BSViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) BSCollectionViewCell *nibCell;

@end

@implementation BSViewController

- (BSCollectionViewCell *)nibCell {
	if (!_nibCell) {
		_nibCell = [[BSCollectionViewCell nib] instantiateWithOwner:nil options:nil].lastObject;
	}
	return _nibCell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.collectionView registerNib:[BSCollectionViewCell nib] forCellWithReuseIdentifier:self.nibCell.reuseIdentifier];
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

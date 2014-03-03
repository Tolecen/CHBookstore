//
//  BSCatalogVC.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-3-3.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSCatalogVC.h"
#import "BSCatalogCell.h"

@interface BSCatalogVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BSCatalogCell *nibCell;

@end

@implementation BSCatalogVC

- (BSCatalogCell *)nibCell {
	if (!_nibCell) {
		_nibCell = [[BSCatalogCell nib] instantiateWithOwner:nil options:nil].lastObject;
	}
	return _nibCell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.tableView registerNib:[BSCatalogCell nib] forCellReuseIdentifier:self.nibCell.reuseIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:self.nibCell.reuseIdentifier];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"%d",indexPath.row);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

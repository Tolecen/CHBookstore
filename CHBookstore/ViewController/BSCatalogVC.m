//
//  BSCatalogVC.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-3-3.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSCatalogVC.h"
#import "BSCatalogCell.h"
#import "BSCatalogStore.h"

@interface BSCatalogVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BSCatalogCell *nibCell;

@property (nonatomic, strong) BSCatalogStore *store;

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
	BSCatalogStore *store = [[BSCatalogStore alloc] initWithJSONFile:[[NSBundle mainBundle] pathForResource:@"book_list" ofType:@"json"]];
	self.store = store;
	self.title = self.store.bookName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.store.volumeCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self.store volumeName:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.store catalogsInVolume:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:self.nibCell.reuseIdentifier];
	cell.textLabel.text = [self.store catalogsInVolume:indexPath.section][indexPath.row];
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

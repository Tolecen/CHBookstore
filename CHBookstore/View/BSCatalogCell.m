//
//  BSCatalogCell.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-3-3.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSCatalogCell.h"

@implementation BSCatalogCell

+ (UINib *)nib {
	return [UINib nibWithNibName:@"BSCatalogCell" bundle:nil];
}

- (void)prepareForReuse {
	[super prepareForReuse];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end

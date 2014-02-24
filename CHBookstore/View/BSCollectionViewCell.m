//
//  BSCollectionViewCell.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-24.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSCollectionViewCell.h"

@interface BSCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *CoverImageView;

@end

@implementation BSCollectionViewCell

+ (UINib *)nib {
	return [UINib nibWithNibName:@"BSCollectionViewCell" bundle:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)prepareForReuse {
	[super prepareForReuse];
}

@end

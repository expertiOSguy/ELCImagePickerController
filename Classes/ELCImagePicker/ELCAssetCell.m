//
//  AssetCell.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetCell.h"
#import "ELCAsset.h"

@interface ELCAssetCell ()

@property (nonatomic, retain) NSArray *rowAssets;
@property (nonatomic, retain) NSArray *imageViewArray;
@property (nonatomic, retain) NSArray *overlayViewArray;

@end

@implementation ELCAssetCell

@synthesize rowAssets = _rowAssets;

- (id)initWithAssets:(NSArray *)assets reuseIdentifier:(NSString *)identifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	if(self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [self addGestureRecognizer:tapRecognizer];
        
		self.rowAssets = assets;
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:4];
        UIImage *overlayImage = [UIImage imageNamed:@"Overlay.png"];
        NSMutableArray *overlayArray = [[NSMutableArray alloc] initWithCapacity:4];
        for (int i = 0; i < 4; ++i) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            BOOL selected = NO;
            if (i < [_rowAssets count]) {
                ELCAsset *asset = [_rowAssets objectAtIndex:i];
                imageView.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
                selected = asset.selected;
            } else {
                imageView.image = nil;
            }
            [mutableArray addObject:imageView];
            [imageView release];
            
            UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:overlayImage];
            [overlayArray addObject:overlayImageView];
            overlayImageView.hidden = selected ? NO : YES;
            [overlayImageView release];
        }
        self.imageViewArray = mutableArray;
        [mutableArray release];
        self.overlayViewArray = overlayArray;
        [_overlayViewArray release];
	}
	return self;
}

- (void)setAssets:(NSArray *)assets
{
    self.rowAssets = assets;
	for (UIView *view in [self subviews]) {
		[view removeFromSuperview];
	}
    for (int i = 0; i < 4; ++i) {
        UIImageView *imageView = [_imageViewArray objectAtIndex:i];
        UIImageView *overlayView = [_overlayViewArray objectAtIndex:i];
        if (i < [_rowAssets count]) {
            ELCAsset *asset = [_rowAssets objectAtIndex:i];
            imageView.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
            overlayView.hidden = asset.selected ? NO : YES;
        } else {
            imageView.image = nil;
            overlayView.hidden = YES;
        }
    }
}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint point = [tapRecognizer locationInView:self];
    CGFloat totalWidth = self.rowAssets.count * 75 + (self.rowAssets.count - 1) * 4;
    CGFloat startX = (self.bounds.size.width - totalWidth) / 2;
    
	CGRect frame = CGRectMake(startX, 2, 75, 75);
	
	for (int i = 0; i < 4; ++i) {
        if (CGRectContainsPoint(frame, point)) {
            ELCAsset *asset = [_rowAssets objectAtIndex:i];
            asset.selected = !asset.selected;
            UIImageView *overlayView = [_overlayViewArray objectAtIndex:i];
            overlayView.hidden = !asset.selected;
            break;
        }
        frame.origin.x = frame.origin.x + frame.size.width + 4;
    }
}

- (void)layoutSubviews
{    
    CGFloat totalWidth = self.rowAssets.count * 75 + (self.rowAssets.count - 1) * 4;
    CGFloat startX = (self.bounds.size.width - totalWidth) / 2;
    
	CGRect frame = CGRectMake(startX, 2, 75, 75);
	
	for (int i = 0; i < 4; ++i) {
		UIImageView *imageView = [_imageViewArray objectAtIndex:i];
		[imageView setFrame:frame];
		[self addSubview:imageView];
        
        UIImageView *overlayView = [_overlayViewArray objectAtIndex:i];
        [overlayView setFrame:frame];
        [self addSubview:overlayView];
		
		frame.origin.x = frame.origin.x + frame.size.width + 4;
	}
}

- (void)dealloc
{
	[_rowAssets release];
    [_imageViewArray release];
	[super dealloc];
}

@end

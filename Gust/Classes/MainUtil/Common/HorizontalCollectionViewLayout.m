//
//  HorizontalCollectionViewLayout.m
//  L16-CollectionView
//
//  Created by Iracle Zhang on 16/1/2.
//  Copyright © 2016年 Iralce. All rights reserved.
//

#import "HorizontalCollectionViewLayout.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@implementation HorizontalCollectionViewLayout
{
    NSInteger _cellCount;
    CGSize _boundsSize;
    
}

- (void)prepareLayout
{
    // Get the number of cells and the bounds size
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    _boundsSize = self.collectionView.bounds.size;
}

- (CGSize)collectionViewContentSize
{
    // We should return the content size. Lets do some math:
    
    NSInteger verticalItemsCount = (NSInteger)floorf(_boundsSize.height / _itemSize.height);
    NSInteger horizontalItemsCount = (NSInteger)floorf(_boundsSize.width / _itemSize.width);
    
    NSInteger itemsPerPage = verticalItemsCount * horizontalItemsCount;
    NSInteger numberOfItems = _cellCount;
    NSInteger numberOfPages = (NSInteger)ceilf((CGFloat)numberOfItems / (CGFloat)itemsPerPage);
    
    CGSize size = _boundsSize;
    size.width = numberOfPages * _boundsSize.width;
    return size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // This method requires to return the attributes of those cells that intsersect with the given rect.
    // In this implementation we just return all the attributes.
    // In a better implementation we could compute only those attributes that intersect with the given rect.
    
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:_cellCount];
    
    for (NSUInteger i=0; i<_cellCount; ++i)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [self _layoutForAttributesForCellAtIndexPath:indexPath];
        
        [allAttributes addObject:attr];
    }
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self _layoutForAttributesForCellAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    // We should do some math here, but we are lazy.
    return YES;
}

- (UICollectionViewLayoutAttributes*)_layoutForAttributesForCellAtIndexPath:(NSIndexPath*)indexPath
{
    // Here we have the magic of the layout.
    
    NSInteger row = indexPath.row;
    
    CGRect bounds = self.collectionView.bounds;
    CGSize itemSize = self.itemSize;
    
    // Get some info:
    NSInteger verticalItemsCount = (NSInteger)floorf(bounds.size.height / itemSize.height);
    NSInteger horizontalItemsCount = (NSInteger)floorf(bounds.size.width / itemSize.width);
    NSInteger itemsPerPage = verticalItemsCount * horizontalItemsCount;
    
    // Compute the column & row position, as well as the page of the cell.
    NSInteger columnPosition = row%horizontalItemsCount;
    NSInteger rowPosition = (row/horizontalItemsCount)%verticalItemsCount;
    NSInteger itemPage = floorf(row/itemsPerPage);
    
    // Creating an empty attribute
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame = CGRectZero;
    
    // And finally, we assign the positions of the cells
    frame.origin.x = itemPage * bounds.size.width + columnPosition * itemSize.width;
    frame.origin.y = rowPosition * itemSize.height;
    frame.size = _itemSize;
    
    attr.frame = frame;
    
     NSLog(@"%f",frame.origin.x);
    return attr;
}

#pragma mark Properties

- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    [self invalidateLayout];
}




@end

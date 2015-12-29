//
//  MultiTabView.m
//  Gust
//
//  Created by Iracle on 4/26/15.
//  Copyright (c) 2015 Iralce. All rights reserved.
//

#import "MultiTabView.h"
#import "MutiTabCollectionViewCell.h"
#import "GustConfigure.h"

@interface MultiTabView() <UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic, strong) MultiTabView *visualEffectView;
@property (strong, nonatomic) UICollectionView *mutiTabCollectionView;
@property (nonatomic, strong) UIView *mutiTabCancelView;
@property (nonatomic, strong) NSMutableArray *getTabArray;

@end

@implementation MultiTabView

- (void)showInView:(UIWindow *)view tabArray:(NSMutableArray *)tabArray {

    _getTabArray = [NSMutableArray arrayWithArray:tabArray];
    _visualEffectView = [[MultiTabView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _visualEffectView.frame = CGRectMake(0, 0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds) - 40);
    _visualEffectView.alpha = 0.6;
    [view addSubview:_visualEffectView];
    [self initMutiTabCancelView :view];
    [self initMutiTabCollectionView];
    [UIView animateWithDuration:0.5 animations:^{
        _visualEffectView.alpha = 1.0;
        _mutiTabCancelView.alpha = 1.0;
    }];
  
}

- (void)initMutiTabCancelView:(UIWindow *)window
{
    _mutiTabCancelView = [[UIView alloc] init];
    _mutiTabCancelView.alpha = 0.6;
    _mutiTabCancelView.frame = CGRectMake(0, CGRectGetMaxY(_visualEffectView.frame), CGRectGetWidth(_visualEffectView.bounds), 40);
       _mutiTabCancelView.backgroundColor = [UIColor blackColor];
    [window addSubview:_mutiTabCancelView];
    _mutiTabCancelView.userInteractionEnabled = YES;
    UITapGestureRecognizer *cancelButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mutiTapCancelButtonTaped:)];
    [_mutiTabCancelView addGestureRecognizer:cancelButton];
    
    UILabel *cancelTitleLabel = [[UILabel alloc] initWithFrame:_mutiTabCancelView.bounds];
    cancelTitleLabel.font = [UIFont systemFontOfSize:14];
    cancelTitleLabel.textColor = [UIColor whiteColor];
    cancelTitleLabel.textAlignment = NSTextAlignmentCenter;
    cancelTitleLabel.text = @"返回";
    [_mutiTabCancelView addSubview:cancelTitleLabel];
}
- (void)initMutiTabCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(_visualEffectView.bounds.size.width / 2 - 50,_visualEffectView.bounds.size.height / 3 - 20);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    _mutiTabCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _mutiTabCollectionView.center = CGPointMake(_visualEffectView.center.x, _visualEffectView.center.y);
    _mutiTabCollectionView.bounds = _visualEffectView.bounds;
    _mutiTabCollectionView.backgroundColor = [UIColor clearColor];
    [_mutiTabCollectionView  registerClass:[MutiTabCollectionViewCell class] forCellWithReuseIdentifier:@"MUTITABCELL"];
    _mutiTabCollectionView.delegate = self;
    _mutiTabCollectionView.dataSource = self;
    _mutiTabCollectionView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    [_visualEffectView addSubview:_mutiTabCollectionView];
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _getTabArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MutiTabCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MUTITABCELL" forIndexPath:indexPath];
    NSDictionary *dic = [_getTabArray objectAtIndex:indexPath.row];
    [cell configcell:dic];
    cell.deleteTabButton.tag = 200 + indexPath.row;
    [cell.deleteTabButton addTarget:self action:@selector(deleteTabButtonTabed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeMutiTabView];
    NSDictionary *dic = [_getTabArray objectAtIndex:indexPath.row];
    NSString *pageURLString = dic[PageUrl];
    _mutiGetUrlValueBlock(pageURLString);
}

- (void)mutiTapCancelButtonTaped:(UIGestureRecognizer *)sender {
    [self removeMutiTabView];
}

- (void)removeMutiTabView {
    
    [UIView animateWithDuration:0.3 animations:^{
        _visualEffectView.alpha = 0.0;
        _mutiTabCancelView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_visualEffectView removeFromSuperview];
        [_mutiTabCancelView removeFromSuperview];
    }];

}

- (void)deleteTabButtonTabed:(UIButton *)sender {
    
    [_getTabArray removeObjectAtIndex:sender.tag - 200];
    [_mutiTabCollectionView reloadData];
    _multiUpdateDataArrayBlock(_getTabArray);
}


@end

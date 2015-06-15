
#import "AlbumContentsViewController.h"
#import "MyPageViewController.h"
#import "PageViewControllerData.h"
#import "AlbumContentsViewCell.h"
#import "PageViewControllerData.h"
#import "SCImagesPickerController.h"

static NSString *CellIdentifier = @"photoCell";

@interface AlbumContentsViewController ()<AlbumContentsViewCellDelegate>
{
    BOOL _isViewDidLoad;
}
@property (nonatomic,assign) NSUInteger maxPhotosCount;//可选择最大照片数量


@end

@implementation AlbumContentsViewController

#pragma mark - View lifecycle

- (void)dealloc{
    
}
- (instancetype)init{
    //流布局
    UICollectionViewFlowLayout *fllo = [[UICollectionViewFlowLayout alloc] init];
    fllo.itemSize = CGSizeMake(295/4.0, 295/4.0);
    fllo.minimumInteritemSpacing = 5;
    fllo.minimumLineSpacing = 5;
    fllo.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    fllo.scrollDirection = UICollectionViewScrollDirectionVertical;

    self = [super initWithCollectionViewLayout:fllo];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    //导航栏取消按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(handleRightItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self addToolBar];
    [self.navigationController setToolbarHidden:NO animated:NO];

    
//    CGFloat toolBarHeight = self.navigationController.toolbar.frame.size.height;
//    self.collectionView.frame = CGRectMake(0, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    self.clearsSelectionOnViewWillAppear = NO;
    [self.collectionView registerClass:[AlbumContentsViewCell class] forCellWithReuseIdentifier:CellIdentifier];

    self.maxPhotosCount = [PageViewControllerData sharedInstance].maxPhotosCount;


    
    _isViewDidLoad = YES;

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    if (!self.assets) {
        _assets = [[NSMutableArray alloc] init];
    } else {
        [self.assets removeAllObjects];
    }
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets addObject:result];
        }
    };

    ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
    [self.assetsGroup setAssetsFilter:onlyPhotosFilter];
    [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
    //排序，最新创建的在最前面
//    [self.assets sortUsingComparator:^NSComparisonResult(ALAsset *asset1, ALAsset *asset2) {
//        NSDate *asset1Date = [asset1 valueForProperty:ALAssetPropertyDate];
//        NSDate *asset2Date = [asset2 valueForProperty:ALAssetPropertyDate];
//
//        if ([asset1Date timeIntervalSinceDate:asset2Date] > 0) {
//            return (NSComparisonResult)NSOrderedAscending;
//        }
//        
//        if ([asset1Date timeIntervalSinceDate:asset2Date] < 0) {
//            return (NSComparisonResult)NSOrderedDescending;
//        }
//        return (NSComparisonResult)NSOrderedSame;
//    }];
    

    [self setCurrentBadgeView];

    [PageViewControllerData sharedInstance].photoAssets = self.assets;
    
    [self.collectionView reloadData];
    
    if (_isViewDidLoad) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assets.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];

        _isViewDidLoad = NO;
    }
}


- (void)addToolBar{
    //加上已选微章
    UIBarButtonItem *selectedCountItem = [[UIBarButtonItem alloc] initWithCustomView:self.badgeView];
//    UIBarButtonItem *previewItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"预览", @"预览已选中的照片") style:UIBarButtonItemStylePlain target:self action:@selector(handlePreviewButton:)];
    
    //完成按钮
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDoneButton:)];
    doneItem.enabled = NO;
    // 设置间隔
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    // autorelease
    NSArray *items = @[flexibleItem,selectedCountItem,fixedItem,doneItem];
    
    self.toolbarItems = items;
}

- (UILabel *)badgeView{
    if (_badgeView == nil){
        _badgeView = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
        _badgeView.layer.cornerRadius = _badgeView.frame.size.width/2;
        _badgeView.backgroundColor = [UIColor colorWithRed:13/255.0 green:122/255.0 blue:1 alpha:1];
//        numLabel.textColor = PreferTextColor;
        _badgeView.textColor = [UIColor whiteColor];
        _badgeView.font = [UIFont boldSystemFontOfSize:14.0];
        _badgeView.textAlignment = NSTextAlignmentCenter;
        _badgeView.text = @"0";
        _badgeView.hidden = YES;
    }
 
    return _badgeView;
}

#pragma mark - handleDisplayEvent
- (void)setCurrentBadgeView{
    self.badgeView.text = [@([PageViewControllerData sharedInstance].selectedIndexPaths.count) stringValue];
    
    if ([self.badgeView.text isEqualToString:@"0"]) {
        self.badgeView.hidden = YES;
//        UIBarButtonItem *previewItem = [self.toolbarItems firstObject];
        UIBarButtonItem *doneItem = [self.toolbarItems lastObject];
//        previewItem.enabled = NO;
        doneItem.enabled = NO;
    }else{
        self.badgeView.hidden = NO;
//        UIBarButtonItem *previewItem = [self.toolbarItems firstObject];
        UIBarButtonItem *doneItem = [self.toolbarItems lastObject];
//        previewItem.enabled = YES;
        doneItem.enabled = YES;
    }
}

#pragma mark - handleButtonEvent

- (void)handleRightItem:(id)sender{
    [[PageViewControllerData sharedInstance].selectedIndexPaths removeAllObjects];
    self.badgeView.text = @"0";
    self.badgeView.hidden = YES;
    UIBarButtonItem *doneItem = [self.toolbarItems lastObject];
    doneItem.enabled = NO;
    [self.collectionView reloadData];
}

//- (void)handlePreviewButton:(id)sender{
//    //重新设置单例数据源
//    [PageViewControllerData sharedInstance].photoAssets = [[PageViewControllerData sharedInstance] getSelectedPhotos];
//    
//    MyPageViewController *pageViewController = [[MyPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//    pageViewController.startingIndex = 0;
//    [self.navigationController pushViewController:pageViewController animated:YES];
//}

- (void)handleDoneButton:(id)sender{
    NSArray *photoAssets = [[PageViewControllerData sharedInstance] getSelectedPhotoAssets];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidFinishedPickingImagesNotification object:photoAssets];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumContentsViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    ALAsset *asset = self.assets[indexPath.row];
    CGImageRef thumbnailImageRef = [asset aspectRatioThumbnail];
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    
    cell.imageView.image = thumbnail;
    
    if ([[PageViewControllerData sharedInstance].selectedIndexPaths containsObject:indexPath]) {
        cell.selectedView.hidden = NO;
        cell.selectedButton.selected = YES;
    }else{
        cell.selectedView.hidden = YES;
        cell.selectedButton.selected = NO;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //设置照片间隔
    
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey: @12};
    MyPageViewController *pageViewController = [[MyPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    pageViewController.startingIndex = indexPath.item;
    [self.navigationController pushViewController:pageViewController animated:YES];
}

#pragma mark - AlbumContentsViewCellDelegate

- (BOOL)albumContentsViewCell:(AlbumContentsViewCell *)cell shouldSelectButton:(UIButton *)button{
    BOOL isFull = self.maxPhotosCount == [PageViewControllerData sharedInstance].selectedIndexPaths.count;
    if (isFull && !button.selected) {
        NSString *titleString = [NSString stringWithFormat:NSLocalizedString(@"您最多只能选择%d张照片", nil),self.maxPhotosCount];
        [SMMessageHUD showMessage:titleString afterDelay:1.0];
        return NO;
    }else{
        return YES;
    }
}

- (void)albumContentsViewCell:(AlbumContentsViewCell *)cell DidSelectButton:(UIButton *)button{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    if (button.selected) {
        [[PageViewControllerData sharedInstance].selectedIndexPaths addObject:indexPath];
        
    }else{
        [[PageViewControllerData sharedInstance].selectedIndexPaths removeObject:indexPath];
    }
    
    [self setCurrentBadgeView];
}

@end


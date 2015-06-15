




#import "PageViewControllerData.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation PageViewControllerData

+ (PageViewControllerData *)sharedInstance
{
    static dispatch_once_t onceToken;
    static PageViewControllerData *sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[PageViewControllerData alloc] init];
    });
    return sSharedInstance;
}

- (NSUInteger)photoCount
{
    return self.photoAssets.count;
}

- (UIImage *)photoAtIndex:(NSUInteger)index
{
    ALAsset *photoAsset = self.photoAssets[index];
    
    ALAssetRepresentation *assetRepresentation = [photoAsset defaultRepresentation];
    
    UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullResolutionImage]
                                                   scale:[assetRepresentation scale]
                                             orientation:UIImageOrientationUp];
    return fullScreenImage;
}

- (NSMutableArray *)selectedIndexPaths{
    if (_selectedIndexPaths == nil) {
        _selectedIndexPaths = [[NSMutableArray alloc] initWithCapacity:self.photoCount];
    }
    return _selectedIndexPaths;
}

- (NSArray *)getSelectedPhotoAssets{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        [indexSet addIndex:indexPath.row];
    }
    return [self.photoAssets objectsAtIndexes:indexSet];
}
@end

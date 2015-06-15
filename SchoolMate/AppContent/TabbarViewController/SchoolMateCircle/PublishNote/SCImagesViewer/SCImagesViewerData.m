


#import "SCImagesViewerData.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation SCImagesViewerData

+ (SCImagesViewerData *)sharedInstance
{
    static dispatch_once_t onceToken;
    static SCImagesViewerData *sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[SCImagesViewerData alloc] init];
    });
    return sSharedInstance;
}

- (NSUInteger)photoCount
{
    return self.imagesArray.count;
}

- (UIImage *)photoAtIndex:(NSUInteger)index
{
    UIImage *image = self.imagesArray[index];
    
    return image;
}

- (void)deletePhotoAtIndex:(NSUInteger)index{
    [self.imagesArray removeObjectAtIndex:index];
}

//- (NSArray *)getSelectedPhotoAssets{
//    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
//    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
//        [indexSet addIndex:indexPath.row];
//    }
//    return [self.imagesArray objectsAtIndexes:indexSet];
//}
@end

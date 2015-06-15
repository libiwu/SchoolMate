//
//  SCImagesPickerController.m
//  AssetsLibraryPra1
//
//  Created by 庞东明 on 10/14/14.
//  Copyright (c) 2014 ZhongAo. All rights reserved.
//

#import "SCImagesPickerController.h"
#import "AssetsGroupsTabelView.h"
#import "PageViewControllerData.h"

NSString *kDidFinishedPickingImagesNotification = @"kDidFinishedPickingImagesNotif";
NSString *kDidCanceledPickingImagesNotification = @"kDidCanceledPickingImagesNotif";

@interface SCImagesPickerController ()<UIAlertViewDelegate>
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) AssetsGroupsTabelView *assetsTableView;
@end

@implementation SCImagesPickerController

- (instancetype)init{
    
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidFinishedPickingImages:) name:kDidFinishedPickingImagesNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidCanceledPickingImages:) name:kDidCanceledPickingImagesNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidFinishedPickingImagesNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidCanceledPickingImagesNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self enumerateAssetsGroups];
    //清空单例已选数据
    [[PageViewControllerData sharedInstance].selectedIndexPaths removeAllObjects];
    [PageViewControllerData sharedInstance].maxPhotosCount = self.maxPhotosCount;
}

- (void)enumerateAssetsGroups{
    if (self.assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    if (self.groups == nil) {
        _groups = [[NSMutableArray alloc] init];
    } else {
        [self.groups removeAllObjects];
    }
    
    // setup our failure view controller in case enumerateGroupsWithTypes fails
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
        NSString *errorMessage = nil;
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = NSLocalizedString(@"安信需要访问您的照片。\n请启用照片-设置/隐私/照片", nil);//@"The user has declined access to it."
                break;
            default:
                errorMessage = NSLocalizedString(@"未知错误", nil);
                break;
        }
        
        [[[UIAlertView alloc] initWithTitle:nil
                                      message: errorMessage
                                     delegate:self
                            cancelButtonTitle:NSLocalizedString(@"好",nil)
                            otherButtonTitles:nil] show];
    };
    
    // emumerate through our groups and only add groups that contain photos
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0){
            [self.groups addObject:group];
        }
        //结束点？
        if (group == nil) {
            [self createViewController];
        }
    };

    // enumerate only photos
//    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:failureBlock];


}

- (void)createViewController{
    if (self.groups) {
        BOOL hasSavePhotos = NO;
        ALAssetsGroup *savePhotsGroup = nil;
        for (ALAssetsGroup *group in self.groups) {
            if ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == 16) {
                hasSavePhotos = YES;
                savePhotsGroup = group;
            }
        }
        _assetsTableView = [[AssetsGroupsTabelView alloc] initWithStyle:UITableViewStylePlain];
        _assetsTableView.groups = self.groups;

        if (hasSavePhotos) {
            //如果有相册，默认进入相册内容视图
            AlbumContentsViewController *albumController = [[AlbumContentsViewController alloc] init];
            albumController.assetsGroup = savePhotsGroup;
            [self setViewControllers:@[_assetsTableView,albumController] animated:NO];
        }else{
            [self setViewControllers:@[_assetsTableView] animated:NO];
        }
    }
}


#pragma mark - Notification

- (void)handleDidFinishedPickingImages:(NSNotification *)notif{

    NSArray *photoAssets = notif.object;
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:photoAssets.count];
    for (ALAsset *asset in photoAssets) {
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
                                                       scale:[assetRepresentation scale]
                                                 orientation:UIImageOrientationUp];
        [images addObject:fullScreenImage];
    }

    if ([self.delegate respondsToSelector:@selector(imagesPickerController:didFinishPickingImages:)]) {
        [self.delegate imagesPickerController:self didFinishPickingImages:images];
    }
}

- (void)handleDidCanceledPickingImages:(NSNotification *)notif{
    if ([self.delegate respondsToSelector:@selector(imagesPickerControllerDidCancel:)]) {
        [self.delegate imagesPickerControllerDidCancel:self];
    }
}

@end

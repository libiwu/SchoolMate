//
//  SaySomethingViewController.m
//  SecureCommunication
//
//  Created by 庞东明 on 8/12/14.
//  Copyright (c) 2014 andy_wu. All rights reserved.
//

#import "SaySomethingViewController.h"

#import "SaySomethingPictureCell.h"

#import "SCImagesPickerController.h"
#import "SCImagesViewer.h"

#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#define kTagClearMessage 10081838

static NSString * kCollectionCellIdentifier = @"SaySomethingPictureCell";
static NSString * kReusableViewHeaderIdentifier = @"ReusableViewHeaderIdentifier";

NSString * kFriendCircleViewReloadDataNotification = @"FriendCircleViewReloadDataNotifi";
NSString * kEnableScrollToTopFlagNotification = @"EnableScrollToTopFlagNotif";

@interface SaySomethingViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,SaySomethingPictureCellDelegate,UINavigationControllerDelegate,SCImagesPickerControllerDelegate,UINavigationBarDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{

}
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIBarButtonItem *sendItem;//发送按钮

@property (nonatomic) NSString *currentText;//当前textView的text

@end

@implementation SaySomethingViewController

- (void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //发送
    _sendItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"发送", nil) style:UIBarButtonItemStylePlain target:self action:@selector(handleRightItem:)];
    _sendItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = _sendItem;
    
    self.currentText = @"";

    [self createContentView];
    //监听文本视图输入事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self setSendButtonShouldEnable];

    [self.collectionView reloadData];
}

- (void)createContentView{
    //流布局配置
    UICollectionViewFlowLayout *fllo = [[UICollectionViewFlowLayout alloc] init];
    fllo.itemSize = CGSizeMake(60, 60);
    fllo.minimumInteritemSpacing = 40/3.0;
    fllo.minimumLineSpacing = 40/3.0;
    fllo.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    fllo.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 100);//footerView高度在这里设置
    fllo.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //集合视图
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, KScreenWidth, KScreenHeight-64.0) collectionViewLayout:fllo];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[SaySomethingPictureCell class] forCellWithReuseIdentifier:kCollectionCellIdentifier];
//    [_collectionView registerClass:[SaySomethingReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReusableViewHeaderIdentifier];
    
    [self.view addSubview:_collectionView];
    
}

- (void)setImagesArray:(NSMutableArray *)imagesArray{
    if (imagesArray != _imagesArray) {
        if (_imagesArray == nil) {
            _imagesArray = [NSMutableArray array];
        }
       
        [_imagesArray addObjectsFromArray:imagesArray];
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imagesArray.count == 9) {
        return self.imagesArray.count;
    }else{
        return self.imagesArray.count+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SaySomethingPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;

    if (indexPath.item == self.imagesArray.count) {
        [cell setPlusSymImage];
    }
    else{
        cell.imageView.image = self.imagesArray[indexPath.row];
    }

    
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
//    SaySomethingReusableView *supplementaryView =
//    (SaySomethingReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                                                                   withReuseIdentifier:kReusableViewHeaderIdentifier
//                                                                          forIndexPath:indexPath];
//    supplementaryView.textViewPlaceholder = NSLocalizedString(@"你在想什么...?", nil);
//    return supplementaryView;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == self.imagesArray.count) {
        //点击+按钮
        [self handlePlusButton:nil];
        
    }else{
        //点击照片,预览照片，可删除照片
       
        NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey: @12}; //设置照片间隔
        SCPageViewController *vc = [[SCPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        vc.startingIndex = indexPath.row;
        vc.imagesArray = self.imagesArray;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //相机
        {
            if (![self startCameraControllerFromViewController:self usingDelegate:self]) {
//                [AutoColoseInfoDialog popUpDialog:NSLocalizedString(@"手机拍照暂时不可用", nil) withView:self.view];
            }
        }
            break;
        case 1:
            //相册
        {
            if (![self startMediaBrowserFromViewController:self usingDelegate:self]) {
//                [AutoColoseInfoDialog popUpDialog:NSLocalizedString(@"相册中没有图片", nil) withView:self.view];
            }
        }
            break;
        case 2:
            //取消
            break;
        default:
            break;
    }
    
}
#pragma mark - UIImagePickerControllerDelegate
//单张照片拍照
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    if ([mediaType isEqualToString:@"public.image"]) {
        editedImage = (UIImage *)info[UIImagePickerControllerEditedImage];
        originalImage = (UIImage *)info[UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
    }
    if (imageToUse == nil) {
        [picker dismissViewControllerAnimated:YES completion:^{
//            [AutoColoseInfoDialog popUpDialog:NSLocalizedString(@"视频暂时不可用", nil) withView:self.view];
        }];
    }else{
        self.imagesArray = (NSMutableArray *)@[imageToUse];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SCImagesPickerControllerDelegate
//多张照片选择
- (void)imagesPickerController:(SCImagesPickerController *)picker didFinishPickingImages:(NSArray *)images{
    self.imagesArray = [images mutableCopy];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagesPickerControllerDidCancel:(SCImagesPickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NotificationEvent

- (void)handleTextViewTextDidChange:(NSNotification *)notif{
    UITextView *textView = (UITextView *)notif.object;
    self.currentText = textView.text;
    [self setSendButtonShouldEnable];
}


#pragma mark - Event
//导航栏照相机按钮事件
- (void)handlePlusButton:(id)sender{
    [self.view endEditing:YES];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"拍照", nil),NSLocalizedString(@"从相册选择", nil), nil];
    [sheet showInView:self.view];
}
//发送按钮
- (void)handleRightItem:(id)sender{
    [self.view endEditing:YES];
}
//判断文本和图片不能同时为空
- (void)setSendButtonShouldEnable{
    //文本不能是空格
    NSString *trimString = [self.currentText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    trimString = [trimString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (_imagesArray.count == 0 && trimString.length == 0){
        self.sendItem.enabled = NO;
    }else{
        self.sendItem.enabled = YES;
    }
}
//拍照片
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO) || (delegate == nil) || (controller == nil)){
        return NO;
    }
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    [controller presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}
//选照片
- (BOOL)startMediaBrowserFromViewController: (UIViewController*) controller
                              usingDelegate: (id <SCImagesPickerControllerDelegate,
                                              UINavigationControllerDelegate>) delegate {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO)
        || (delegate == nil)|| (controller == nil)){
        return NO;
    }
    
    SCImagesPickerController *mediaUI = [[SCImagesPickerController alloc] init];
    mediaUI.delegate = self;
    mediaUI.maxPhotosCount = 9 - self.imagesArray.count;
    [controller presentViewController:mediaUI animated:YES completion:nil];
    
    return YES;
}
@end

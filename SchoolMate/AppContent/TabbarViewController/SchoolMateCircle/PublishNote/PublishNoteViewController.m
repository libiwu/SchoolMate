//
//  PublishNoteViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/15.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "PublishNoteViewController.h"
#import "SCImagesPickerController.h"
#import "SaySomethingPictureCell.h"
#import "SCPageViewController.h"

#import "GroupViewController.h"
#import "NoteTagViewController.h"

static NSString * kCollectionCellIdentifier = @"SaySomethingPictureCell";

@interface PublishNoteViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UITextViewDelegate,
UIActionSheetDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
SCImagesPickerControllerDelegate,
SaySomethingPictureCellDelegate
>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSString *sendText;

@property (nonatomic, strong) NSString *groupString;

@property (nonatomic, strong) NSMutableArray *tagArray;
@end

@implementation PublishNoteViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:@"groupString"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavTitle:NSLocalizedString(@"发表笔记", nil)];
    
    [self setRightMenuTitle:@"发表" andnorImage: nil selectedImage:nil];
    
    [self createContentView];
}
- (void)rightMenuPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.sendText.length == 0 || [self.sendText isEqualToString:@"你在想什么...?"]) {
        [SMMessageHUD showMessage:@"请输入笔记" afterDelay:1.0];
        return;
    } else if (self.imageArray.count == 0) {
        [SMMessageHUD showMessage:@"请选择图片" afterDelay:1.0];
        return;
    }
    
    [SMMessageHUD showMessage:NSLocalizedString(@"发表成功", nil) afterDelay:1.0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}
- (void)createContentView {
    
    self.tagArray = [NSMutableArray array];
    WEAKSELF
    [[NSNotificationCenter defaultCenter] addObserverForName:@"groupString" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        weakSelf.groupString = note.object;
    }];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth, KScreenHeight - 64.0) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
#pragma mark -
- (void)setImagesArray:(NSMutableArray *)imagesArray{
    if (imagesArray != _imageArray) {
        
        NSMutableArray *new = [NSMutableArray arrayWithArray:_imageArray];
        [new addObjectsFromArray:imagesArray];
        
        _imageArray = new;
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"你在想什么...?"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    self.sendText = textView.text;
    return YES;
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 110.0;
    } else if (indexPath.row == 1 && indexPath.section == 0) {
        if (self.imageArray.count <= 3) {
            return 70.0;
        } else if (self.imageArray.count > 3 && self.imageArray.count <= 7) {
            return 70.0 + 60.0 + 40.0/3;
        } else {
            return 70.0 + 60.0 * 2 + 40.0/3 * 2;
        }
    } else {
        return 44.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 25.0;
    } else {
        return 0.0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10.0, 10.0, 300.0, 100.0)];
        textView.backgroundColor = [UIColor clearColor];
        textView.font = [UIFont systemFontOfSize:16.0];
        if (self.sendText) {
            textView.text = self.sendText;
            textView.textColor = [UIColor blackColor];
        } else {
            textView.text = @"你在想什么...?";
            textView.textColor = [UIColor lightGrayColor];
        }
        textView.delegate = self;
        textView.scrollEnabled = NO;
        [cell.contentView addSubview:textView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        //流布局配置
        UICollectionViewFlowLayout *fllo = [[UICollectionViewFlowLayout alloc] init];
        fllo.itemSize = CGSizeMake(60, 60);
        fllo.minimumInteritemSpacing = 5.0;
        fllo.minimumLineSpacing = 40/3.0;
        fllo.sectionInset = UIEdgeInsetsMake(5.0, 20.0, 5.0, 20.0);
//        fllo.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        //集合视图
        CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
        UICollectionView *_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 , 0, KScreenWidth, rect.size.height) collectionViewLayout:fllo];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[SaySomethingPictureCell class] forCellWithReuseIdentifier:kCollectionCellIdentifier];
        
        [cell.contentView addSubview:_collectionView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        UIView *btn = [self setUpCell01];
        [cell.contentView addSubview:btn];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        UIView *btn = [self setUpCell10];
        [cell.contentView addSubview:btn];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        UIView *btn = [self setUpCell11];
        [cell.contentView addSubview:btn];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        return nil;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        [SMMessageHUD showMessage:@"所在位置" afterDelay:1.0];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        GroupViewController *vc = [[GroupViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
        vc.groupString = self.groupString;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        NoteTagViewController *vc = [[NoteTagViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
        vc.tagArray = self.tagArray;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        return;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
- (UIView *)setUpCell01 {
    UIView *btn = [[UIView alloc]init];
    [btn setFrame:CGRectMake(0.0, 0.0, KScreenWidth, 44.0)];
    [btn setBackgroundColor:RGBCOLOR(230.0, 230.0, 230.0)];
    [self.view addSubview:btn];
    
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20.0, 7.0, 30.0, 30.0)];
    imageview.backgroundColor = [UIColor redColor];
    [btn addSubview:imageview];
    
    CGRect rect;
    {
        UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame), 0.0, 80.0, 44.0)];
        leftView.backgroundColor = [UIColor clearColor];
        leftView.textAlignment = NSTextAlignmentCenter;
        leftView.textColor = [UIColor blackColor];
        leftView.text = NSLocalizedString(@"所在位置", nil);
        [btn addSubview:leftView];
        rect = leftView.frame;
    }
    
    CGFloat arrowH = btn.frame.size.height - 22.0;
    {
        UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rect),
                                                                      0.0,
                                                                      btn.frame.size.width - CGRectGetMaxX(rect) - arrowH - 15.0 - 5.0,
                                                                      44.0)];
        leftView.backgroundColor = [UIColor clearColor];
        leftView.textAlignment = NSTextAlignmentCenter;
        leftView.textColor = [UIColor blackColor];
        leftView.text = NSLocalizedString(@"拱北吉大客运站", nil);
        [btn addSubview:leftView];
    }
    
    {
        UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.size.width - arrowH - 15.0,
                                                                              11.0,
                                                                              arrowH,
                                                                              arrowH)];
        [arrowView setImage:[UIImage imageNamed:@"youjiantou.png"]];
        [btn addSubview:arrowView];
    }
    
    return btn;
}
- (UIView *)setUpCell10 {
    UIView *btn = [[UIView alloc]init];
    [btn setFrame:CGRectMake(0.0, 0.0, KScreenWidth, 44.0)];
    [btn setBackgroundColor:RGBCOLOR(230.0, 230.0, 230.0)];
    [self.view addSubview:btn];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20.0, 7.0, 30.0, 30.0)];
    imageview.backgroundColor = [UIColor redColor];
    [btn addSubview:imageview];
    
    CGRect rect;
    {
        UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame), 0.0, 50.0, 43.5)];
        leftView.backgroundColor = [UIColor clearColor];
        leftView.textAlignment = NSTextAlignmentCenter;
        leftView.textColor = [UIColor blackColor];
        leftView.text = NSLocalizedString(@"分组", nil);
        [btn addSubview:leftView];
        rect = leftView.frame;
    }
    
    CGFloat arrowH = btn.frame.size.height - 22.0;
    {
        UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rect),
                                                                      0.0,
                                                                      btn.frame.size.width - CGRectGetMaxX(rect) - arrowH - 15.0 - 5.0,
                                                                      44.0)];
        leftView.backgroundColor = [UIColor clearColor];
        leftView.textAlignment = NSTextAlignmentRight;
        leftView.textColor = [UIColor blackColor];
        leftView.text = self.groupString;
        [btn addSubview:leftView];
    }
    {
        UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.size.width - arrowH - 15.0,
                                                                              11.0,
                                                                              arrowH,
                                                                              arrowH)];
        [arrowView setImage:[UIImage imageNamed:@"youjiantou.png"]];
        [btn addSubview:arrowView];
    }
    
    {
        UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 43.5, btn.frame.size.width, 0.5)];
        lineImage.backgroundColor = [UIColor lightGrayColor];
        [btn addSubview:lineImage];
    }
    return btn;
}
- (UIView *)setUpCell11 {
    UIView *btn = [[UIView alloc]init];
    [btn setFrame:CGRectMake(0.0, 0.0, KScreenWidth, 44.0)];
    [btn setBackgroundColor:RGBCOLOR(230.0, 230.0, 230.0)];
    [self.view addSubview:btn];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20.0, 7.0, 30.0, 30.0)];
    imageview.backgroundColor = [UIColor redColor];
    [btn addSubview:imageview];
    
    CGRect rect;
    {
        UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame), 0.0, 50.0, 44.0)];
        leftView.backgroundColor = [UIColor clearColor];
        leftView.textAlignment = NSTextAlignmentCenter;
        leftView.textColor = [UIColor blackColor];
        leftView.text = NSLocalizedString(@"标签", nil);
        [btn addSubview:leftView];
        rect = leftView.frame;
    }
    
    CGFloat arrowH = btn.frame.size.height - 22.0;
    {
        __block NSString *string = @"";
        [self.tagArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx == 0) {
                string = obj;
            } else {
                string = [NSString stringWithFormat:@"%@.%@",string,obj];
            }
        }];
        UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rect),
                                                                      0.0,
                                                                      btn.frame.size.width - CGRectGetMaxX(rect) - arrowH - 15.0 - 5.0,
                                                                      44.0)];
        leftView.backgroundColor = [UIColor clearColor];
        leftView.textAlignment = NSTextAlignmentRight;
        leftView.textColor = [UIColor blackColor];
        leftView.text = string;
        [btn addSubview:leftView];
    }
    {
        UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.size.width - arrowH - 15.0,
                                                                              11.0,
                                                                              arrowH,
                                                                              arrowH)];
        [arrowView setImage:[UIImage imageNamed:@"youjiantou.png"]];
        [btn addSubview:arrowView];
    }
    return btn;
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imageArray.count == 9) {
        return self.imageArray.count;
    }else{
        return self.imageArray.count+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SaySomethingPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier
                                                                              forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.item == self.imageArray.count) {
        [cell setPlusSymImage];
    } else{
        cell.imageView.image = self.imageArray[indexPath.row];
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
    if (indexPath.item == self.imageArray.count) {
        //点击+按钮
        [self handlePlusButton:nil];
    }else{
        //点击照片,预览照片，可删除照片
        NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey: @12}; //设置照片间隔
        SCPageViewController *vc =
        [[SCPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                        navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                      options:options];
        vc.startingIndex = indexPath.row;
        vc.imagesArray = self.imageArray;
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
    mediaUI.delegates = self;
    mediaUI.maxPhotosCount = 9 - self.imageArray.count;
    [controller presentViewController:mediaUI animated:YES completion:nil];
    
    return YES;
}
@end

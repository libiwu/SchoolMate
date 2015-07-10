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
#import "IQTextView.h"

static NSString * kCollectionCellIdentifier = @"SaySomethingPictureCell";
NSString * const  kCirclePublishComplete = @"kPublishComplete_Circle";

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
{
    IQTextView *_mainTextView;
    GroupViewController *_groupViewController;
}

@property (nonatomic, strong) UITableView *tableView;
//图片
@property (nonatomic, strong) NSMutableArray *imageArray;
//文字
@property (nonatomic, strong) NSString *sendText;
//分组
@property (nonatomic, strong) BBNPClassModel *bbnpClassModel;
//标签（暂不用）
@property (nonatomic, strong) NSMutableArray *tagArray;
@end

@implementation PublishNoteViewController
- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:@"groupString"];
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
    
    [self requestAddBlog];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}
- (void)createContentView {
    
    self.tagArray = [NSMutableArray array];
//    WEAKSELF
//    [[NSNotificationCenter defaultCenter] addObserverForName:@"groupString" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        weakSelf.groupString = note.object;
//    }];
    
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
        return 2;
    }
    return 1;
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
        return 0.0;
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
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 0 && indexPath.row == 0) {
        IQTextView *textView = [[IQTextView alloc]initWithFrame:CGRectMake(10.0, 10.0, 300.0, 100.0)];
        textView.backgroundColor = [UIColor clearColor];
        textView.font = [UIFont systemFontOfSize:16.0];
//        if (self.sendText) {
            textView.text = self.sendText;
            textView.textColor = [UIColor blackColor];
//        } else {
//            textView.text = @"你在想什么...?";
//            textView.textColor = [UIColor lightGrayColor];
//        }
        textView.placeholder = @"你在想什么...?";
        textView.delegate = self;
        textView.scrollEnabled = NO;
        [cell.contentView addSubview:textView];
        _mainTextView = textView;
        
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        UIView *btn = [self setUpCell10];
        [cell.contentView addSubview:btn];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        UIView *btn = [self setUpCell11];
        [cell.contentView addSubview:btn];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        return nil;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_mainTextView resignFirstResponder];
    if (indexPath.section == 0 && indexPath.row == 2) {
        [SMMessageHUD showMessage:@"所在位置" afterDelay:1.0];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        WEAKSELF
        if (!_groupViewController) {
            _groupViewController = [[GroupViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
        }
        [_groupViewController setSelectBlock:^(BBNPClassModel *model, NSIndexPath *indexPath) {
            weakSelf.bbnpClassModel = model;
        }];
        [self.navigationController pushViewController:_groupViewController animated:YES];
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
//    imageview.backgroundColor = [UIColor redColor];
    [imageview setImage:[UIImage imageNamed:@"120"]];
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
//    imageview.backgroundColor = [UIColor redColor];
    [imageview setImage:[UIImage imageNamed:@"21"]];
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
        leftView.text = self.bbnpClassModel.schoolType.integerValue == 4 ? self.bbnpClassModel.schoolName : self.bbnpClassModel.className;
        [btn addSubview:leftView];
    }
    {
        UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.size.width - arrowH - 15.0,
                                                                              11.0,
                                                                              arrowH,
                                                                              arrowH)];
        [arrowView setImage:[UIImage imageNamed:@"youjiantou.png"]];
//        [btn addSubview:arrowView];
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
//    imageview.backgroundColor = [UIColor redColor];
    [imageview setImage:[UIImage imageNamed:@"20"]];
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
#pragma mark - Request
#pragma mark 添加黑板报博客
- (void)requestAddBlog {
    /*
     Param: {
     userId:1                           （必填，当前用户ID）
     content：我们当时旅游的图片        （必填，博客内容）
     fileList: file                     （必填，博客图片1）
     fileList:file                      （可选填，博客图片2）
     isPublic: 1                        （版本1暂时不用，是否公开， 0：私密，1：公开，默认为1）
     location:广东省珠海市香洲区光大国贸（可选填，目前所在地点）
     visibleType:1                      （必填，可见类型，1：所有人可见，2：某些班级可见，默认为1）
     userClassIds:[14, 9]               （可选填，分享的用户班级ID列表，可以从接口:"m/user/class/list"中获取，用Json数组格式传递）
     }
     */
    
    NSString *visibleType = @"";
    NSString *userClassIds = @"";
    if (self.bbnpClassModel.boardId.integerValue == 0) {
        visibleType = @"1";
    } else {
        visibleType = @"2";
    }
    userClassIds = [NSString stringWithFormat:@"[%@]",self.bbnpClassModel.boardId];
    
    WEAKSELF
    [SMMessageHUD showLoading:@"正在加载..."];
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/blog/save")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"content" : _sendText,
                                                    @"isPublic" : @"1",
                                                    @"location" : @"",
                                                    @"visibleType" : visibleType,
                                                    @"userClassIds" : userClassIds}
                        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                            [self.imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                
                                NSData *imageDatass = [SMImageTool compressImage:obj
                                                                      andQuality:1.0
                                                                      andMaxSize:CGSizeMake(300, 100)
                                                                andMaxDataLength:100];
                                
//                                UIImage *image = [Tools scaleToSize:obj size:CGSizeMake(75, 50)];
//                                
//                                NSData *imageDatass = UIImageJPEGRepresentation(image, .5);
                                
                                NSString *fileName = [NSString stringWithFormat:@"fileName%ld.jpg",(unsigned long)idx];
                                
                                [formData appendPartWithFileData:imageDatass
                                                            name:@"fileList"
                                                        fileName:fileName
                                                        mimeType:@"image.jpg"];
                            }];
                        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [SMMessageHUD dismissLoading];
                            NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                            if ([success isEqualToString:@"1"]) {
                                [SMMessageHUD showMessage:NSLocalizedString(@"发表成功", nil) afterDelay:1.0];
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:kCirclePublishComplete object:nil];
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                });
                            } else {
                                NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                [SMMessageHUD showMessage:string afterDelay:2.0];
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [SMMessageHUD dismissLoading];
                            [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                        }];
}
@end

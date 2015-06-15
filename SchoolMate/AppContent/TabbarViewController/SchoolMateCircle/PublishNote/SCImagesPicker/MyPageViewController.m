
#import "MyPageViewController.h"
#import "PhotoViewController.h"
#import "PageViewControllerData.h"
#import "SCImagesPickerController.h"

@interface MyPageViewController ()<PhotoViewControllerDelegate>

@property (nonatomic) UIButton *selectedButton;//右上角选中的图片标识

@property (nonatomic,strong) UILabel *badgeView;//已选中图片计数
@property (nonatomic) NSUInteger currentPageIndex;//当前页码
@property (nonatomic,assign) NSUInteger maxPhotosCount;//可选择最大照片数量
@end

@implementation MyPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.maxPhotosCount = [PageViewControllerData sharedInstance].maxPhotosCount;

    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.toolbarHidden = NO;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self addToolBar];
    
    [self setCurrentBadgeView];
    
    // start by viewing the photo tapped by the user
    PhotoViewController *startingPage = [PhotoViewController photoViewControllerForPageIndex:self.startingIndex];
    if (startingPage != nil)
    {
        self.dataSource = self;
        startingPage.delegate = self;
        [self setViewControllers:@[startingPage]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
    }
}

//加上toolbar视图
- (void)addToolBar{
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectedButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *selectedCountItem = [[UIBarButtonItem alloc] initWithCustomView:self.badgeView];
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDoneButton:)];
    titleItem.enabled = NO;
    // 设置间隔
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    NSArray *items = @[flexibleItem,selectedCountItem,fixedItem,titleItem];
    
    self.toolbarItems = items;
}

- (UIButton *)selectedButton{
    if (_selectedButton == nil) {
        _selectedButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_selectedButton setImage:[UIImage imageNamed:@"CellNotSelected"] forState:UIControlStateNormal];
        [_selectedButton setImage:[UIImage imageNamed:@"CellBlueSelected"] forState:UIControlStateSelected];
        [_selectedButton addTarget:self action:@selector(handleSelectedButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _selectedButton;
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
        UIBarButtonItem *item = [self.toolbarItems lastObject];
        item.enabled = NO;
    }else{
        self.badgeView.hidden = NO;
        UIBarButtonItem *item = [self.toolbarItems lastObject];
        item.enabled = YES;
    }
}

- (void)setSelecteButtonCurrentStage:(NSUInteger)pageIndex{
    UIButton *button = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageIndex inSection:0];
    if ([[PageViewControllerData sharedInstance].selectedIndexPaths containsObject:indexPath]) {
        button.selected = YES;
    }else{
        button.selected = NO;
    }
}

#pragma mark - handlButtonEvent

- (void)handleSelectedButton{
    UIButton *button = self.selectedButton;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPageIndex inSection:0];

    if (button.selected) {
        button.selected = NO;
        [[PageViewControllerData sharedInstance].selectedIndexPaths removeObject:indexPath];
    }else{
        if (self.maxPhotosCount == [PageViewControllerData sharedInstance].selectedIndexPaths.count) {
            NSString *titleString = [NSString stringWithFormat:NSLocalizedString(@"您最多只能选择%d张照片", nil),self.maxPhotosCount];
            [SMMessageHUD showMessage:titleString afterDelay:1.0];
        }else{
            button.selected = YES;
            [[PageViewControllerData sharedInstance].selectedIndexPaths addObject:indexPath];
        }
    }
    
    [self setCurrentBadgeView];
}

- (void)handleDoneButton:(id)sender{
    NSArray *photoAssets = [[PageViewControllerData sharedInstance] getSelectedPhotoAssets];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidFinishedPickingImagesNotification object:photoAssets];
}

#pragma mark - UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(PhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    PhotoViewController *photoVC = [PhotoViewController photoViewControllerForPageIndex:index - 1];
    photoVC.delegate = self;
    return photoVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(PhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    
    PhotoViewController *photoVC = [PhotoViewController photoViewControllerForPageIndex:index + 1];
    photoVC.delegate = self;
    return photoVC;
}

#pragma mark - PhotoViewControllerDelegate

- (void)photoViewControllerViewWillAppear:(PhotoViewController *)vc{
    self.currentPageIndex = vc.pageIndex;
    [self setSelecteButtonCurrentStage:vc.pageIndex];
}

@end

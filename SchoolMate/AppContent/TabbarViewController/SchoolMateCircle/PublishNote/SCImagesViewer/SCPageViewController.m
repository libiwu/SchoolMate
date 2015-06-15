
#import "SCPageViewController.h"
#import "SCImageViewController.h"
#import "SCImagesViewerData.h"


@interface SCPageViewController ()<UIPageViewControllerDelegate,UIActionSheetDelegate>

@property (nonatomic) UIButton *selectedButton;//右上角选中的图片标识

@property (nonatomic,strong) UILabel *badgeView;//已选中图片计数
@property (nonatomic) NSUInteger currentPageIndex;//当前页码
@end

@implementation SCPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    //设置不延展
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self customContentView];
    
    [SCImagesViewerData sharedInstance].imagesArray = self.imagesArray;
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(handleDeleteButton:)];
    deleteItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = deleteItem;
    
    // start by viewing the photo tapped by the user
    SCImageViewController *startingPage = [SCImageViewController photoViewControllerForPageIndex:self.startingIndex];
    if (startingPage != nil)
    {
        self.currentPageIndex = self.startingIndex;
        self.delegate = self;
        self.dataSource = self;
        [self setViewControllers:@[startingPage]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
    }
}

- (void)customContentView{
    self.view.backgroundColor = RGBACOLOR(234.0, 234.0, 234.0, 1.0);
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        } else {
            if (IS_IOS7) {
                self.navigationController.navigationBar.barTintColor = RGBACOLOR(110.0, 200.0, 243.0, 1.0);

            }else{
                self.navigationController.navigationBar.tintColor = RGBACOLOR(110.0, 200.0, 243.0, 1.0);
            }
        }
    }
   [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    if(IS_IOS7){//布局适配
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.extendedLayoutIncludesOpaqueBars = NO;
        }
    }
    

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 60.0, 44.0)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 7.0, 15.0, 30.0);
    [backButton setBackgroundImage:[UIImage imageNamed:@"barbuttonicon_back"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"barbuttonicon_back"] forState:UIControlStateNormal];
    
    backButton.backgroundColor=[UIColor clearColor];
    backButton.exclusiveTouch = YES;
    [view addSubview:backButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 0.0, 40.0, 44.0)];
    label.backgroundColor = [UIColor clearColor];
    label.text = NSLocalizedString(@"返回", @"导航栏返回按钮");
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = CGRectMake(0.0, 0.0, view.frame.size.width, view.frame.size.height);
    [clickBtn addTarget:self action:@selector(leftMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:clickBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem.tag = 100;


}

- (void)setNavTitle:(NSString *)title
{
    UILabel *lablel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
    lablel.text = [NSString stringWithFormat:@"%@",title];
    lablel.textColor = [UIColor blackColor];
    lablel.backgroundColor = [UIColor clearColor];
    lablel.textAlignment = NSTextAlignmentCenter;
    lablel.font = [UIFont boldSystemFontOfSize:18.0];
    lablel.minimumScaleFactor = 0.8;
    lablel.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lablel;
}

- (void)leftMenuPressed:(id)sender;//左边按钮被点击，子类重载
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - HandlButtonEvent

- (void)handleDeleteButton:(id)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"确定删除此张照片吗？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:NSLocalizedString(@"删除照片", nil) otherButtonTitles:nil];
    [sheet showInView:self.view];
    
}

#pragma mark - UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(SCImageViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    SCImageViewController *photoVC = [SCImageViewController photoViewControllerForPageIndex:index - 1];
    return photoVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(SCImageViewController *)vc
{
    NSUInteger index = vc.pageIndex;

    SCImageViewController *photoVC = [SCImageViewController photoViewControllerForPageIndex:index + 1];
    return photoVC;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    SCImageViewController *vc = (SCImageViewController *)[pageViewController.viewControllers firstObject];
    self.currentPageIndex = vc.pageIndex;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //删除
        NSUInteger newIndex = self.currentPageIndex;
        NSUInteger photoCount = [SCImagesViewerData sharedInstance].photoCount;
        if (newIndex == photoCount - 1 && photoCount != 1) {
            //设置最后一页时，取前面一页
            newIndex -= 1;
        }
        
        [[SCImagesViewerData sharedInstance] deletePhotoAtIndex:self.currentPageIndex];
        
        if ([SCImagesViewerData sharedInstance].photoCount == 0) {
            //照片数量为零时pop
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SCImageViewController *startingPage = [SCImageViewController photoViewControllerForPageIndex:newIndex];
            if (startingPage != nil){
                self.currentPageIndex = newIndex;
                [self setViewControllers:@[startingPage] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
            }
        }
        
    }else{
        //取消
    }
}
@end

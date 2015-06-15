

#import <UIKit/UIKit.h>

@interface SCImageViewController : UIViewController

@property (nonatomic, strong) NSArray *photos;  // array of ALAsset objects
@property NSUInteger pageIndex;

+ (SCImageViewController *)photoViewControllerForPageIndex:(NSUInteger)pageIndex;

@end



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SCImagesViewerData : NSObject

+ (SCImagesViewerData *)sharedInstance;

@property (nonatomic, strong) NSMutableArray *imagesArray; //

- (NSUInteger)photoCount;
- (UIImage *)photoAtIndex:(NSUInteger)index;

- (void)deletePhotoAtIndex:(NSUInteger)index;

@end
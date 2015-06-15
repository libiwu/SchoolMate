//
//  CheckTools.m
//  DLMacaoApp
//
//  Created by libiwu on 14-6-19.
//  Copyright (c) 2014年 andy_wu. All rights reserved.
//

#import "CheckTools.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netdb.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation CheckTools

+ (BOOL)checkNetWork
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
//    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    return (isReachable && !needsConnection) ? YES : NO;
}
+ (BOOL)isNumber:(NSString *)str//只能输入数字
{
    NSString *keyRegex = @"[0-9]{1,10000}";
    NSPredicate *keyTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", keyRegex];
    return [keyTest evaluateWithObject:str];
}
+ (BOOL)isCountNumber:(NSString *)str//只能输入数字小数点
{
    //    /^\d+\.{0,1}\d*$/
    NSString *countRegex = @"^?\\d*(\\.)?\\d*$";
    NSPredicate *countTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", countRegex];
    return [countTest evaluateWithObject:str];
}

+ (BOOL)isValidateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+ (BOOL)isValidateKeyNum:(NSString *)key{
    NSString *keyRegex = @"[A-Z0-9a-z]{6,20}";
    NSPredicate *keyTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", keyRegex];
    if (![keyTest evaluateWithObject:key]) {
//        [AutoColoseInfoDialog popUpDialog:NSLocalizedString(@"密碼格式不正确", nil) withView:AppWindow];
    }
    return [keyTest evaluateWithObject:key];
}

+ (BOOL)isValidateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)isValidateMobileNumber: (NSString *)mobileNum countryCode: (NSString *)countryCode
{
    int maxLength = 0;
    if ([countryCode isEqualToString:@"+86"]) {
        maxLength = 11;
    }else if ([countryCode isEqualToString:@"+852"]) {
        maxLength = 8;
    }else if ([countryCode isEqualToString:@"+853"]){
        maxLength = 8;
    }else{
        maxLength = 11;
    }

    if (mobileNum.length != maxLength) {
//        [AutoColoseInfoDialog popUpDialog:NSLocalizedString(@"手机号格式不对", nil) withView:AppWindow];
        return NO;
    }
    
    return YES;
}

+ (BOOL)isLoginAccount:(NSString *)account
{
//    NSString *countRegex = @"[[A-Z0-9a-z._%]@[A-Za-z0-9]]{0,20}";
    NSString *countRegex = @"[[A-Z0-9a-z]@[A-Za-z0-9]]{0,20}";
    NSPredicate *countTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", countRegex];
    return [countTest evaluateWithObject:account];
}

+ (BOOL)isRealName:(NSString *)realname//真实姓名，汉字
{
    NSString *countRegex = @"[\u4e00-\u9fa5.]{2,20}$";
    NSPredicate *countTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", countRegex];
    return [countTest evaluateWithObject:realname];
}

#pragma mark - 判断是否为整型
+ (BOOL)isPureInt:(NSString*)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 判断是否为浮点型
+ (BOOL)isPureFloat:(NSString*)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark - 判断手机权限
+ (BOOL)isPermissionsWithType:(NSUInteger)type {
    BOOL isPermit = NO;
    switch (type) {
        case CameraPermissions:
            isPermit = [self cameraPermissions];
            break;
        case PhotoPermissions:
            isPermit = [self photoPermissions];
            break;
        case MicrophonePermissions:
            isPermit = [self microphonePermissions];
            break;
        case AddressBookPermissions:
            isPermit = [self addressBookPermissions];
            break;
        default:
            break;
    }
    return isPermit;
}

+ (BOOL)cameraPermissions {
    __block BOOL isPermit = YES;
    if (IS_IOS7) {
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusAuthorized) {
            isPermit = YES;
        }
        else if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
            isPermit = NO;
        }
        else {
            isPermit = YES;
        }
    }
    return isPermit;
}

+ (BOOL)photoPermissions {
    BOOL isPermit = YES;
    if (IS_IOS7) {
        ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
        if (authorizationStatus == ALAuthorizationStatusAuthorized) {
            isPermit = YES;
        }
        else if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
            isPermit = NO;
        }
        else {
            isPermit = YES;
        }
    }
    return isPermit;
}

+ (BOOL)microphonePermissions {
    __block BOOL isPermit = YES;
    if (IS_IOS7) {
        AVAudioSession *session = [[AVAudioSession alloc] init];
        if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
            [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    isPermit = YES;
                } else {
                    isPermit = NO;
                }
            }];
        }
    }
    return isPermit;
}

+ (BOOL)addressBookPermissions {
    __block BOOL isPermit = YES;
    //用户拒绝访问通讯录,给用户提示设置应用访问通讯录
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authorizationStatus == ALAuthorizationStatusAuthorized) {
        isPermit = YES;
    }
    else if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        isPermit = NO;
    }
    else {
        isPermit = YES;
    }
    return isPermit;
}

+ (UIImage *)cellBackImage:(UIImage *)image {
    image =[image resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0) resizingMode:UIImageResizingModeStretch];
    return image;
}
@end

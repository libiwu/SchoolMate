//
//  UserInfoView.m
//  SchoolMate
//
//  Created by libiwu on 15/6/10.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "UserInfoView.h"
#import "UserInfoCell.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "NickNameViewController.h"
#import "TrueNameViewController.h"
#import "SMDatePickPopView.h"
#import "CompanyViewController.h"
#import "ChangeAccountViewController.h"

#import "SMNavigationPopView.h"
@interface UserInfoView ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *contentArray;
@end

@implementation UserInfoView

- (void)setUp {
    self.backgroundColor = [UIColor clearColor];
    
    self.titleArray = @[@[NSLocalizedString(@"头像", nil),
                          NSLocalizedString(@"昵称", nil),
                          NSLocalizedString(@"真实姓名", nil),
                          NSLocalizedString(@"生日", nil),
                          NSLocalizedString(@"账号", nil),
                          NSLocalizedString(@"性别", nil),
                          NSLocalizedString(@"二维码名片", nil)],
                        @[NSLocalizedString(@"职位", nil),
                          NSLocalizedString(@"工作单位", nil),
                          NSLocalizedString(@"联系地址", nil),
                          NSLocalizedString(@"地区", nil)]];
    
    self.contentArray = @[@[NSLocalizedString(@"头像", nil),
                            NSLocalizedString(@"同学科技", nil),
                            NSLocalizedString(@"呆萌萌", nil),
                            NSLocalizedString(@"1980年10月1日", nil),
                            NSLocalizedString(@"tongxuekeji", nil),
                            NSLocalizedString(@" 男", nil),
                            NSLocalizedString(@"二维码名片", nil)],
                          @[NSLocalizedString(@"漫画家", nil),
                            NSLocalizedString(@"珠海同学科技有限公司", nil),
                            NSLocalizedString(@"联系地址", nil),
                            NSLocalizedString(@"广东 珠海", nil)]];
    
    self.tableView =
    ({
        UITableView *table = [[UITableView alloc]initWithFrame:self.frame];
        table.delegate = self;
        table.dataSource = self;
        table.backgroundColor = [UIColor clearColor];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:table];
        table;
    });
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 85.0;
    } else {
        return 44.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 10.0;
            break;
        default:
        {
            return 10.0;
        }
            break;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"UserInfoCell";
    
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (!cell) {
        cell = [[UserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
    cell.frame = CGRectMake(0.0, 0.0, tableView.frame.size.width, rect.size.height);
    
    UserInfoCellType type = 0;
    if (indexPath.section == 0 && indexPath.row == 0) {
        type = UserInfoCellTypeAvatar;
    } else if (indexPath.section == 0 && indexPath.row == 6) {
        type = UserInfoCellTypeImage;
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        type = UserInfoCellTypeDefault;
    } else {
        type = UserInfoCellTypeArrow;
    }
    
    [cell setUserInfoModel:@{@"title" : self.titleArray[indexPath.section][indexPath.row],
                             @"content" : self.contentArray[indexPath.section][indexPath.row]}
                 indexPath:indexPath
                  cellType:type];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                                         destructiveButtonTitle:nil
                                                              otherButtonTitles:NSLocalizedString(@"相机", nil),NSLocalizedString(@"相册", nil), nil];
                    action.tag = 20001;
                    [action showInView:self];
                }
                    break;
                case 1 :
                {
                    NickNameViewController *vc = [[NickNameViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
                    [CurrentViewController.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                {
                    TrueNameViewController *vc = [[TrueNameViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
                    [CurrentViewController.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3:
                {
                    SMDatePickPopView *view = [[SMDatePickPopView alloc]init];
                    UserInfoCell *cell = (UserInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                    NSDateFormatter *ff = [[NSDateFormatter alloc]init];
                    [ff setDateFormat:@"yyyy年MM月dd日"];
                    [view.datePicker setDate:[ff dateFromString:cell.contentLabel.text] animated:NO];
                    [view setValueChange:^(UIDatePicker *datePicker) {
                        NSString *string = [ff stringFromDate:datePicker.date];
                        cell.contentLabel.text = string;
                    }];
                    [view show];
                }
                    break;
                case 4:
                {
                    ChangeAccountViewController *vc = [[ChangeAccountViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
                    [CurrentViewController.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 5:
                {
                    UserInfoCell *cell = (UserInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                    
                    SMNavigationPopView *view = [[SMNavigationPopView alloc]initWithDataArray:@[@"男", @"女"]];
                    [view setTableViewCenter:AppWindow.center];
                    [view setTableViewSelectBlock:^(NSUInteger index, NSString *string) {
                        cell.contentLabel.text = string;
                    }];
                    [view show];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    CompanyViewController *vc = [[CompanyViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
                    [CurrentViewController.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Events
#pragma mark 打开相册
- (void)openThePhotoLibrary {
    if (IS_IOS7) {
        if ([CheckTools isPermissionsWithType:AddressBookPermissions])  {
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;
            [CurrentViewController presentViewController:pickerImage animated:YES completion:nil];
        }
        else {
            if (IOS_VERSION >= 8.0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                               message:NSLocalizedString(@"對不起，您已將相册權限關閉", nil)
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                                     otherButtonTitles:NSLocalizedString(@"设置", nil), nil];
                alert.tag = 10002;
                [alert show];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                               message:NSLocalizedString(@"對不起，您已將相册權限關閉,请去设置/隐私/照片设置", nil)
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                                     otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
                [alert show];
            }
        }
    }
}
#pragma mark 打开相機
- (void)openTheCamera {
    if (IS_IOS7) {
        if ([CheckTools isPermissionsWithType:CameraPermissions]) {
            //先设定sourceType为相機，然后判断相機是否可用（ipod）没相機，不可用将sourceType设定为相片库
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            //如果没有相機功能，则打开相册
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                //        [self openThePhotoLibrary];
                return;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate      = self;
            picker.allowsEditing = YES;//设置可编辑
            picker.sourceType    = sourceType;
            [CurrentViewController presentViewController:picker animated:YES completion:nil];//进入照相界面
        }
        else {
            if (IOS_VERSION >= 8.0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                               message:NSLocalizedString(@"对不起,您已将相机权限关闭", nil)
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                                     otherButtonTitles:NSLocalizedString(@"设置", nil), nil];
                alert.tag = 10003;
                [alert show];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                               message:NSLocalizedString(@"对不起,您已将相机权限关闭,请去设置/隐私/相机设置", nil)
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                                     otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
                [alert show];
            }
        }
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DLog(@"%@", info);
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *theImage = nil;
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        UserInfoCell *cell = (UserInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.avatarView.image = theImage;
    }
    [CurrentViewController dismissViewControllerAnimated:YES completion:nil];
    
    //选取完头像就上传
//    [self saveChange];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [CurrentViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 10003:
        {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }
            break;
        case 10002:
        {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (actionSheet.tag) {
        case 20001:
        {
            switch (buttonIndex) {
                case 0:
                {
                    [self openTheCamera];
                }
                    break;
                case 1:
                {
                    [self openThePhotoLibrary];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}
@end

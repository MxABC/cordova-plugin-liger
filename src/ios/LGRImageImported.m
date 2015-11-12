//
//  LGRImageImported.m
//  LigerMobile
//
//  Created by John Gustafsson on 12/4/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRImageImported.h"
//#import "LGRViewController+UIImagePickerControllerDelegate.h"

@interface LGRImageImported()<UIAlertViewDelegate,UIImagePickerControllerDelegate>
@end
@implementation LGRImageImported

+ (NSString*)importedPage
{
	return @"image";
}

+ (UIViewController*)controllerForImportedPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent
{
    
    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"选择页面" message:@"测试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"A",@"B", nil];
//    [alertView show];
    
	if (![self isAlertControllerAvailable]) {
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
		picker.delegate = parent;

		return picker;
	}

	return [self alertController:parent];
}

+ (BOOL)isAlertControllerAvailable
{
	return [UIAlertController class];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

#warning 如何增加选择选项呢（网页实现，key 为 image 和 camera.）
+ (UIAlertController*)alertController:(LGRViewController *)parent
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = parent;
            [picker.navigationController presentViewController:picker animated:YES completion:nil];
        }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = parent;
        [picker.navigationController presentViewController:picker animated:YES completion:nil];
        //
        //		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //		picker.delegate = parent;
        //		[parent presentViewController:picker animated:YES completion:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    
    return alertController;
}

@end

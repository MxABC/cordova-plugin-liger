//
//  LGRPageFactory.h
//  LigerMobile
//
//  Created by John Gustafsson on 11/13/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

@class LGRViewController;


@interface LGRPageFactory : NSObject
+ (LGRViewController*)controllerForPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent;
+ (UIViewController*)controllerForDialogPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent;


/**
 @brief  注册原生控制器
 @param arrayNativePages 原生控制器 Class数组
 */
+ (void)registerNativePages:(NSArray*)arrayNativePages;


/**
 @brief  注册原生控制器
 @param natvieClass 原生控制器
 */
+ (void)registerNativePage:(Class)nativeClass;


@end

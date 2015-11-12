//
//  LGRLiger.h
//  LigerMobile
//
//  Created by John Gustafsson on 2/25/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import <Cordova/CDVPlugin.h>

@interface LGRLiger : CDVPlugin

// Cordova
- (void)openPage:(CDVInvokedUrlCommand*)command;
- (void)closePage:(CDVInvokedUrlCommand*)command;

- (void)openDialog:(CDVInvokedUrlCommand*)command;
- (void)openDialogWithTitle:(CDVInvokedUrlCommand*)command;
- (void)closeDialog:(CDVInvokedUrlCommand*)command;

- (void)toolbar:(CDVInvokedUrlCommand*)command;
- (void)getPageArgs:(CDVInvokedUrlCommand*)command;

@end

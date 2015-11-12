//
//  LGRCordovaViewController.h
//  LigerMobile
//
//  Created by John Gustafsson on 2/21/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import <Cordova/CDVViewController.h>

@interface LGRCordovaViewController : CDVViewController
@property (nonatomic, strong) NSDictionary *args;

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options;

- (void)dialogClosed:(NSDictionary*)args;
- (void)childUpdates:(NSDictionary*)args;

- (void)pageWillAppear;
- (void)pageWillReAppear;
- (void)pushNotificationTokenUpdated:(NSString *)token error:(NSError *)error;
- (void)notificationArrived:(NSDictionary *)userInfo state:(UIApplicationState)state;
- (void)handleAppOpenURL:(NSURL*)url;
- (void)buttonTapped:(NSDictionary*)button;

@end

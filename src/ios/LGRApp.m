//
//  LGRApp.m
//  LigerMobile
//
//  Created by John Gustafsson on 10/1/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRApp.h"

#define VERSION @6

@interface LGRApp ()
@property (nonatomic, strong) NSDictionary *app;
@end

@implementation LGRApp

+ (LGRApp*)shared
{
	static LGRApp *shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[LGRApp alloc] init];
	});
	return shared;
}

- (id)init
{
	self = [super init];
	if (self) {
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"app/app" ofType:@"json"];
		NSData *file = [NSData dataWithContentsOfFile:filePath];
		NSAssert(file, @"No app.json in the app folder.");
		
		NSError *error = nil;
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:file options:0 error:&error];
		NSAssert(!error, error.description);
		
		NSAssert([json[@"appFormatVersion"] isEqualToNumber:VERSION], @"Wrong app format version of app.json, please see documentation for updating to the latest format. Do not update appFormatVersion without updating the rest of the file.");
		NSAssert(json[@"appearance"], @"No appearance in app.json.");
		NSAssert(json[@"rootPage"], @"No rootpage in app.json.");
		NSAssert([json[@"rootPage"][@"args"] count] > 0, @"Your rootPage should have arguments (args) in app.json");
		self.app = json;
	}
	return self;
}

+ (void)setupPushNotifications
{
	if (![[self app][@"notifications"] boolValue])
		return;

	// TODO Make it possible to specify badge, sound, alert in app.json
	UIApplication *application = [UIApplication sharedApplication];
	if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
		UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge |
																							 UIUserNotificationTypeSound |
																							 UIUserNotificationTypeAlert) categories:nil];
		[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
		[[UIApplication sharedApplication] registerForRemoteNotifications];

		[application registerUserNotificationSettings:settings];
		[application registerForRemoteNotifications];
	} else {
		UIRemoteNotificationType types = (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound);
		[application cancelAllLocalNotifications];
		[application registerForRemoteNotificationTypes:types];
	}
}

+ (NSDictionary*)root
{
	return [self app][@"rootPage"];
}

+ (NSDictionary*)appearance
{
	return [self app][@"appearance"];
}

+ (NSDictionary*)app
{
	return [self shared].app;
}

@end

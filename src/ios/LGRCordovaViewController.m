//
//  LGRCordovaViewController.m
//  LigerMobile
//
//  Created by John Gustafsson on 2/21/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//
#warning 若是http://的加一个进度条

#import "LGRCordovaViewController.h"

#import "LGRApp.h"
#import "LGRPageFactory.h"

@interface LGRCordovaViewController ()
@property (nonatomic, assign) BOOL toolbarHidden;
@property (nonatomic, strong) NSMutableArray *evalQueue;
@property (nonatomic, assign) BOOL acceptingJS;
@end

@implementation LGRCordovaViewController

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options
{
	self = [super init];
	if (self) {
		self.args = args;
		self.title = title;
//self.wwwFolderName = @"http://";
        //默认先从nativehtml下找本地网页，找不到再。。。
		//self.wwwFolderName = @"nativeHTML";
		self.startPage = [page hasPrefix:@"http"]||[page hasPrefix:@"file"] ? page : [page stringByAppendingString:@".html"];

		if (options[@"toolbar"]) {
			self.toolbarHidden = ![options[@"toolbar"] boolValue];
		} else {
			self.toolbarHidden = YES;
		}

		self.evalQueue = [NSMutableArray arrayWithCapacity:2];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIColor *webBG = [[UIWebView appearance] backgroundColor];
	if (webBG)
		self.webView.backgroundColor = webBG;

	self.webView.allowsInlineMediaPlayback = YES;
	self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
	self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self.navigationController setToolbarHidden:self.toolbarHidden animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	self.acceptingJS = NO;
	[super webViewDidStartLoad:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[super webViewDidFinishLoad:webView];
	self.acceptingJS = YES;
	[self executeQueue];
}

#pragma mark - LGRViewController

- (void)sendArgs:(NSDictionary *)args toJavascript:(NSString*)javascript
{
	NSString *json = @"{}";

	if ([args isKindOfClass:NSDictionary.class]) {
		NSError *error = nil;
		NSData *data = [NSJSONSerialization dataWithJSONObject:args options:0 error:&error];
		json = !error ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"{}";
    }

	[self addToQueue:[NSString stringWithFormat:javascript, json]];
	[self executeQueue];
}

- (void)dialogClosed:(NSDictionary *)args
{
	[self sendArgs:args toJavascript:@"PAGE.closeDialogArguments(%@)"];
}

- (void)childUpdates:(NSDictionary *)args
{
	[self sendArgs:args toJavascript:@"PAGE.childUpdates(%@)"];
}

#pragma mark - Refresh
- (void)pageWillAppear
{
	NSString *js = @"if(PAGE.onPageAppear) PAGE.onPageAppear();";

	[self addToQueue:js];
	[self executeQueue];
}


- (void)pageWillReAppear
{
    NSString *js = @"if(PAGE.onPageReAppear) PAGE.onPageReAppear();";
    
    [self addToQueue:js];
    [self executeQueue];
}

- (void)pushNotificationTokenUpdated:(NSString *)token error:(NSError *)error
{
	NSString *js = @"if(PAGE.pushNotificationTokenUpdated) PAGE.pushNotificationTokenUpdated('%@', 'ios', '%@');";
	js = [NSString stringWithFormat:js, token ? token : @"", error ? [error localizedDescription] : @""];

	[self addToQueue:js];
	[self executeQueue];
}

- (void)notificationArrived:(NSDictionary*)userInfo state:(UIApplicationState)state
{
	NSDictionary *states = @{@(UIApplicationStateActive): @"ios_active",
							 @(UIApplicationStateInactive): @"ios_inactive",
							 @(UIApplicationStateBackground): @"ios_background"};
	NSError *error = nil;
	NSData *json = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:&error];

	NSString *js = @"if(PAGE.notificationArrived) PAGE.notificationArrived(%@, '%@');";
	js = [NSString stringWithFormat:js, [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding], states[@(state)]];

	[self addToQueue:js];
	[self executeQueue];
}

- (void)handleAppOpenURL:(NSURL*)url
{
	NSString *js = @"if(PAGE.handleAppOpenURL) PAGE.handleAppOpenURL('%@');";
	js = [NSString stringWithFormat:js, url];

	[self addToQueue:js];
	[self executeQueue];
}

- (void)buttonTapped:(NSDictionary*)button
{
    NSString *js = @"if(PAGE.headerButtonTapped) PAGE.headerButtonTapped('%@');";
    js = [NSString stringWithFormat:js, button[@"button"]];
    
    [self addToQueue:js];
    [self executeQueue];
}

- (void)addToQueue:(NSString*)js
{
	[self.evalQueue addObject:js];
}

- (void)executeQueue
{
	if (self.acceptingJS && self.evalQueue.count) {
		dispatch_async(dispatch_get_main_queue(), ^{
			while (self.evalQueue.count) {
				NSString* js = [self.evalQueue firstObject];
				[self.webView stringByEvaluatingJavaScriptFromString:js];
				[self.evalQueue removeObjectAtIndex:0];
			}
		});
	}
}


@end

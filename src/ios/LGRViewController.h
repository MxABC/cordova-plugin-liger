//
//  LGRViewController.h
//  LigerMobile
//
//  Created by John Gustafsson on 2/20/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

/**
 LGRViewController forms the basis of what in Liger is called a Page. All UIViewControllers that are intended to be used
 from a Liger HTML view needs to inherit from this class to provide the API for handling Pages.
 
 The API here is reflected in the Javascript API and they are for the most part identical. You can open both native and HTML
 pages from both APIs.
 */
@interface LGRViewController : UIViewController
/**
 If you inherit from LGRViewController and intend to make your page available you should override this method
 and return the name of your page. If you don't do so, or return nil, your class will not be available.
 
 @return The name for you page
 */
+ (NSString*)nativePage;

/**
 The name of the page, as has been set when instantiated. For a native page it will be the same as nativePage
 while an HTML page will reflect the html file (sans .html).
 */
@property (readonly) NSString *page;

/**
 The arguments as set when instantiated. Can be updated by subclasses if desired.
 
 In the future assume that these args will be sent to a page if the application as been restarted.
 */
@property (readonly) NSDictionary *args;

/**
 The arguments as set when instantiated. Can be updated by subclasses if desired.
 
 In the future assume that these args will be sent to a page if the application as been restarted.
 */
@property (readonly) NSDictionary *options;

/**
 The parent of this page, if in a collection.
 
 nil if a root page or not within a collection.
 */
@property (nonatomic, strong) LGRViewController *parentPage;

/**
 The collection this page is in.

 nil if a root page or not within a stack.
 */
@property (nonatomic, weak) LGRViewController *collectionPage;

/**
 Convenience initializer, calls initWithPage:title:args:options:NibName:bundle with nil for nib and bundle.
 */
- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options;

/**
 The designated initializer. Inits the page.
 
 @param page The name of the page. Either nativePage if native, or the name of the HTML file (sans .html).
 @param title The title for the page, same as UIViewController's title. Is used for the UINavigationBar title by UIKit.
 @param args The arguments that were sent to the page. OBS is not automatically updated if the HTML page updates it's args. Be aware that this might change in the future.
 @param options Optional hints for a page.
 @param nibName see UIViewController
 @param nibName see UIViewController
 
 @see initWithNibName:nibBundleOrNil
 */
- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

/**
 Creates and pushes a new page onto the stack (UINavigationController).
 
 @param page The name of the page. Either nativePage if native, or the name of the HTML file (sans .html).
 @param title The title for the page, same as UIViewController's title. Is used for the UINavigationBar title by UIKit.
 @param args The arguments that were sent to the page. OBS is not automatically updated if the HTML page updates it's args. Be aware that this might change in the future.
 @param options Optional hints for a page.
 @param parent The parent for this page. Different from the collection page of this page.
 @param success This block will be called if the operation was successful.
 @param fail This block will be called if something went wrong.
 */
- (void)openPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent success:(void (^)())success fail:(void (^)())fail;

/**
 Closes the current page, and potentially several more pages if a rewindTo page name is supplied.
 
 For example, if this stack contains:
 home
 detail
 veryDetailed
 
 And rewindTo is set to @"home" when calling closePage on veryDetailed, both veryDetailed and detailed will
 be closed and home will be showing.
 
 You can not close the root of the stack, so in the above example you can not close home.
 
 @param rewindTo The name of the page to stop at, ignoring the current page. If nil close only this page.
 @param success This block will be called if the operation was successful.
 @param fail This block will be called if something went wrong.
 */
- (void)closePage:(NSString*)rewindTo success:(void (^)())success fail:(void (^)())fail;

/**
 Closes the current page, and potentially several more pages if a rewindTo page name is supplied.

 For example, if this stack contains:
 home
 detail
 veryDetailed

 And rewindTo is set to @"home" when calling closePage on veryDetailed, both veryDetailed and detailed will
 be closed and home will be showing.

 You can not close the root of the stack, so in the above example you can not close home.

 @param rewindTo The name of the page to stop at, ignoring the current page. If nil close only this page.
 @param sourcePage The originator of the close, for use with collection pages.
 @param success This block will be called if the operation was successful.
 @param fail This block will be called if something went wrong.
 */
- (void)closePage:(NSString*)rewindTo sourcePage:(LGRViewController*)sourcePage success:(void (^)())success fail:(void (^)())fail;

/**
 Sends args to a parent page. Can be used for internal messaging. Will not replace the args of the destination
 page but rather have childUpdates: called with the args.
 
 @param destination A page name (jumping back in the stack in the same manner as closePage) or nil for the direct parent.
 @param args The arguments to be sent to childUpdates:.
 @param success This block will be called if the operation was successful.
 @param fail This block will be called if something went wrong.
 
 @see childUpdates:
 */
- (void)updateParent:(NSString*)destination args:(NSDictionary*)args success:(void (^)())success fail:(void (^)())fail;

/**
 Creates a page and opens it as a dialog (presenting a modal view controller).
 
 @param page The name of the page. Either nativePage if native, or the name of the HTML file (sans .html).
 @param title The title for the page, same as UIViewController's title. Is used for the UINavigationBar title by UIKit.
 @param args The arguments that were sent to the page. OBS is not automatically updated if the HTML page updates it's args. Be aware that this might change in the future.
 @param options Optional hints for a page.
 @param parent The parent for this page. Different from the collection page of this page.
 @param success This block will be called if the operation was successful.
 @param fail This block will be called if something went wrong.
 */
- (void)openDialog:(NSString *)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent success:(void (^)())success fail:(void (^)())fail;

/**
 If this page was opened as a dialog sending closeDialog will close it (dismiss modal view controller).
 
 @param args The arguments that will be sent to the parents dialogClosed:
 @param success This block will be called if the operation was successful.
 @param fail This block will be called if something went wrong.
 
 @see dialogClosed:
 */
- (void)closeDialog:(NSDictionary*)args success:(void (^)())success fail:(void (^)())fail;

/**
 Callback for when a dialog has been closed and wants to send data back to its parent.
 
 @param args The arguments send by the page that was closed.
 @see closeDialog:success:fail:
 */
- (void)dialogClosed:(NSDictionary*)args;

/**
 Callback to recieve the arguments sent by a parent.
 
 @param args The arguments sent by a parent of this page.
 @see updateParent:args:success:fail
 */
- (void)childUpdates:(NSDictionary*)args;

/**
 Callback for when the page will appear, same as viewWillAppear: but generic for both HTML and native.
 */
- (void)pageWillAppear;

/**
 @brief  控制器 ViewWillAppear方法不是第一次调用
 */
- (void)pageWillReAppear;

/**
 Called when the app is starting up. Either a token if successful or an error if it was a failure.
 The simulator will always cause failures as notifications only work on device.
 
 Will only be sent to the rootPage by LigerMobile.
 
 @param token A string representation of the NSData sent in as a token
 @param error An error if it failed
 */
- (void)pushNotificationTokenUpdated:(NSString*)token error:(NSError*)error;

/**
 A notification has arrived to the app.
 
 @param userInfo The notification that was sent to the app.
 @param state The state of the app when the notification arrived
 */
- (void)notificationArrived:(NSDictionary*)userInfo state:(UIApplicationState)state;

/**
 Handle the situation were the app is started by an URL.
 
 @param url The URL the app was started with
 */
- (void)handleAppOpenURL:(NSURL*)url;

/**
 Called when a navigation bar button (added via the options parameter) is tapped.
 
 @param button The object that was passed via the options parameter and then tapped by the user
 
 */
- (void)buttonTapped:(NSDictionary*)button;

@end

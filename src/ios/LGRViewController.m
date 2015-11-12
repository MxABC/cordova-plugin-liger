//
//  LGRViewController.m
//  LigerMobile
//
//  Created by John Gustafsson on 2/20/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRViewController.h"
#import "LGRPageFactory.h"

#import "LGRNativeViewController.h"


@interface LGRViewController ()
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSDictionary *args;
@property (nonatomic, strong) NSDictionary *options;

@property (nonatomic, strong) NSMutableDictionary *buttons;

@property (nonatomic,assign) BOOL isViewWillAppearFirstTime;


@end

@implementation LGRViewController

+ (NSString*)nativePage
{
	return nil;
}

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options
{
	return [self initWithPage:page title:title args:args options:options nibName:nil bundle:nil];
}

- (id)initWithPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //本地页面初始方法
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		NSAssert([self.class nativePage] == nil || [[self.class nativePage] isEqualToString:page], @"Native page name isn't the same as page argument.");
		self.page = page;
		self.args = args;
		self.title = title;
		self.options = options;
		
		self.buttons = [NSMutableDictionary dictionaryWithCapacity:2];
		[self addButtons];
	}
    
    _isViewWillAppearFirstTime = YES;
    
	return self;
}

- (void)addButtons
{
	if ([self.options objectForKey:@"left"]) {
		NSDictionary *left = [self.options objectForKey:@"left"];
		UIBarButtonItem *leftButton = [self buttonFromDictionary:left];
		self.navigationItem.leftBarButtonItem = leftButton;
		self.buttons[[NSValue valueWithNonretainedObject:leftButton]] = left;
	}
	
	if ([self.options objectForKey:@"right"]) {
		NSDictionary *right = [self.options objectForKey:@"right"];
		UIBarButtonItem *rightButton =  [self buttonFromDictionary:right];
		self.navigationItem.rightBarButtonItem = rightButton;
		self.buttons[[NSValue valueWithNonretainedObject:rightButton]] = right;
	}
}


//导航栏根据参数来定义
- (UIBarButtonItem*)buttonFromDictionary:(NSDictionary*)buttonInfo
{
	NSAssert([buttonInfo isKindOfClass:[NSDictionary class]], @"options should look as follows {'right':{'button':'done'}}");
	
	NSDictionary *lookup = @{@"done": @(UIBarButtonSystemItemDone),
				 @"cancel": @(UIBarButtonSystemItemCancel),
				 @"edit": @(UIBarButtonSystemItemEdit),
				 @"save": @(UIBarButtonSystemItemSave),
				 @"add": @(UIBarButtonSystemItemAdd),
				 @"compose": @(UIBarButtonSystemItemCompose),
				 @"reply": @(UIBarButtonSystemItemReply),
				 @"action": @(UIBarButtonSystemItemAction),
				 @"organize": @(UIBarButtonSystemItemOrganize),
				 @"bookmarks": @(UIBarButtonSystemItemBookmarks),
				 @"search": @(UIBarButtonSystemItemSearch),
				 @"refresh": @(UIBarButtonSystemItemRefresh),
				 @"stop": @(UIBarButtonSystemItemStop),
				 @"camera": @(UIBarButtonSystemItemCamera),
				 @"trash": @(UIBarButtonSystemItemTrash),
				 @"play": @(UIBarButtonSystemItemPlay),
				 @"pause": @(UIBarButtonSystemItemPause),
				 @"rewind": @(UIBarButtonSystemItemRewind),
				 @"forward": @(UIBarButtonSystemItemFastForward),
				 @"undo": @(UIBarButtonSystemItemUndo),
				 @"redo": @(UIBarButtonSystemItemRedo)
				 };
	
	NSNumber *buttonValue = lookup[[buttonInfo[@"button"] lowercaseString]];
	if (buttonValue) {
		UIBarButtonSystemItem buttonSystemItem = buttonValue.integerValue;
		
		return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:buttonSystemItem
								     target:self
								     action:@selector(buttonAction:)];
	} else {
		return [[UIBarButtonItem alloc] initWithTitle:buttonInfo[@"button"]
							style:UIBarButtonItemStylePlain
						       target:self
						       action:@selector(buttonAction:)];
	}
}

- (void)buttonAction:(id)sender
{
	NSDictionary *button = self.buttons[[NSValue valueWithNonretainedObject:sender]];
	[self buttonTapped:button];
}

- (void)buttonTapped:(NSDictionary*)button
{

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
   
	[self pageWillAppear];
    
    
    if (_isViewWillAppearFirstTime) {
        
        _isViewWillAppearFirstTime = NO;
        
    }
    else
        [self pageWillReAppear];
	
}


#pragma mark - API

//直接打开本地页面/本地网页/超链接网页
- (void)openPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent success:(void (^)())success fail:(void (^)())fail
{
//#warning 如何设计呢？？
//	[self.collectionPage openPage:page title:title args:args options:options parent:parent success:success fail :fail];
    //delegate设计根控制器为导航控制器，导航控制器的根控制器又是firstPage.
    
    //TODO
    //
    
    
    self.parentPage = parent;
    
    LGRViewController *lgrViewController = [LGRPageFactory controllerForPage:page title:title args:args options:options parent:parent];
    if(lgrViewController){
        [parent.navigationController pushViewController:lgrViewController animated:YES];
    }
    
}


//当前界面给之前界面更新参数。
- (void)updateParent:(NSString*)destination args:(NSDictionary*)args success:(void (^)())success fail:(void (^)())fail
{
    if ([destination isKindOfClass:NSString.class] && self.navigationController)
    {
        NSArray *arrayControllers = self.navigationController.viewControllers;
        
        for (NSInteger i = arrayControllers.count - 1; i >= 0; i--)
        {
            LGRViewController *vc = arrayControllers[i];
            
            if ([vc.page isEqualToString:destination])
            {
                [vc childUpdates:args];
                success();
                return;
            }
        }
        
        
    } else {
        [self.parentPage childUpdates:args];
        success();
        return;
    }
    
    fail();
    
    
//	if ([destination isKindOfClass:NSString.class])
//    {
//		LGRViewController *page = self.parentPage;
//		
//		while (page)
//        {
//            NSLog(@"%@",page.page);
//			if ([page.page isEqualToString:destination]) {
//				[page childUpdates:args];
//				success();
//				return;
//			}
//			page = page.parentPage;
//		}
//	} else {
//		[self.parentPage childUpdates:args];
//		success();
//		return;
//	}
//	
//	fail();
}

- (void)closePage:(NSString*)rewindTo success:(void (^)())success fail:(void (^)())fail
{
	//[self.collectionPage closePage:rewindTo sourcePage:self success:success fail:fail];
    
    /**
     @brief  增加判断并返回
     */
    if (rewindTo)
    {
        NSArray *array = self.navigationController.viewControllers;
        
        for (NSInteger i = [array count] - 1; i >= 0; i--)
        {
            LGRViewController *lgrViewController = array[i];
            if ( [lgrViewController.page isEqualToString:rewindTo] )
            {
                [self.navigationController popToViewController:lgrViewController animated:YES];
                
                if (success) {
                    success();
                }
                return;
            }
        }
        if (fail) {
            fail();
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        if (success) {
            success();
        }
    }

}

- (void)closePageToInverseIndex:(NSString*)index success:(void (^)())success fail:(void (^)())fail
{
    //[self.collectionPage closePage:rewindTo sourcePage:self success:success fail:fail];
    
    /**
     @brief  增加判断并返回
     */
    if (index)
    {
        NSArray *array = self.navigationController.viewControllers;
        
        NSInteger inverseIdx = [index integerValue];
        
        if ([array count] > inverseIdx)
        {
            LGRViewController *lgrViewController = array[ array.count - inverseIdx ];
            
            [self.navigationController popToViewController:lgrViewController animated:YES];
        }
        else
        {
            if (fail) {
                fail();
            }
        }
        
        if (fail) {
            fail();
        }
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        if (success) {
            success();
        }
    }
    
}


- (void)closePage:(NSString*)rewindTo sourcePage:(LGRViewController*)sourcePage success:(void (^)())success fail:(void (^)())fail
{
    
    NSArray *array = self.navigationController.viewControllers;
    
    
    for (NSInteger i = [array count] - 1; i >= 0; i--) {
        
        if ( array[i] == sourcePage )
        {
            [self.navigationController popToViewController:sourcePage animated:YES];
            
            return;
        }
    }
    
    if (fail) {
        fail();
    }
    
 
    
   // [_parentPage.navigationController popViewControllerAnimated:YES];

}

//打开系统页面，如相册控制器
- (void)openDialog:(NSString *)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent success:(void (^)())success fail:(void (^)())fail
{
	if (self.collectionPage) {
		[self.collectionPage openDialog:page
								  title:title
								   args:args
								options:options
								 parent:parent
								success:success
								   fail:fail];
	} else {
		LGRNativeViewController *new = (LGRNativeViewController*)[LGRPageFactory controllerForDialogPage:page title:title args:args options:options parent:parent];

		// Couldn't create a new view controller, possibly a broken plugin
		if (!new) {
			fail();
			return;
		}
        
        __weak __typeof(self) weakSelf = self;
        new.blockArgs = ^(NSDictionary* dicArgs)
        {
            //本地原生界面返回参数给当前控制器,最终调用 LGRHTMLViewController的方法 childUpdates
            [weakSelf childUpdates:dicArgs];
        };

		[self presentViewController:new animated:YES completion:^{
			success();
		}];
	}
}

- (void)closeDialog:(NSDictionary*)args success:(void (^)())success fail:(void (^)())fail
{
	// Internal error, we couldn't find the navigation controller
	
}

#pragma mark - Callbacks
- (void)dialogClosed:(NSDictionary*)args
{
}

- (void)childUpdates:(NSDictionary*)args
{
	self.args = args;
}

- (void)pageWillAppear
{
	
}

- (void)pageWillReAppear
{
    
}

- (void)pushNotificationTokenUpdated:(NSString*)token error:(NSError*)error
{
	
}

- (void)notificationArrived:(NSDictionary*)userInfo state:(UIApplicationState)state
{
	
}

- (void)handleAppOpenURL:(NSURL*)url
{
	
}


@end

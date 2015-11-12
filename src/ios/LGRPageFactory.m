//
//  LGRPageFactory.m
//  LigerMobile
//
//  Created by John Gustafsson on 11/13/13.
//  Copyright (c) 2013-2014 ReachLocal Inc. All rights reserved.  https://github.com/reachlocal/liger-ios/blob/master/LICENSE
//

#import "LGRPageFactory.h"
#import "LGRViewController.h"
#import "LGRHTMLViewController.h"

#import "LGRImportedViewController.h"

#import "LGRNativeViewController.h"

@import ObjectiveC;

BOOL classDescendsFromClass(Class classA, Class classB)
{
	do {
        if(classA == classB)
			return YES;
	} while ((classA = class_getSuperclass(classA)));
	
    return NO;
}

#warning 问题点：imported和native字典的区别，控制器不都是LGR开头设计好的么。虽然一个是现实了LGR协议，一个是继承自LGRViewController
//通过预先设计好的控制器importedPage方法返回一个page key,最终实现将所有的此控制器得到的key与以其类名为value的字典存入内存。
//应该系统自带的一些控制器，如摄像机、短信等，基本可以不考虑，cordova的一些插件搞定，Liger只负责界面跳转及传递参数即可。
BOOL imported(NSMutableDictionary* imported, Class class)
{
    //判断项目里的控制器，若是相关实现该LGR协议的控制器
	if (!class_conformsToProtocol(class, @protocol(LGRImportedViewController)))
		return NO;
	//根据page引入的页面-key
	NSString *importedPage = [class importedPage];
	if (!importedPage)
		return NO;
	
	imported[importedPage] = class;
	return YES;
}

//判断class是否继承自LGRViewController.
//如html界面跳转到原生界面，该原生界面可以定义继承LGRViewController,并实现静态nativePage，返回类名即可。
BOOL native2(NSMutableDictionary* pages, Class class)
{
	if (!classDescendsFromClass(class, LGRViewController.class))
		return NO;
	
	NSString *nativePage = [class nativePage];
	if (!nativePage)
		return NO;
	
	pages[nativePage] = class;
    
	return YES;
}




BOOL native(NSMutableDictionary* pages, Class class)
{
    
    if (!classDescendsFromClass(class, LGRNativeViewController.class))
        return NO;
    
    if (!classDescendsFromClass(class, LGRViewController.class))
    {
        NSLog(@"%@",NSStringFromClass(class));
    }
    
    pages[NSStringFromClass(class)] = class;
    
    return YES;
}


@interface LGRPageFactory ()
@property (nonatomic, strong) NSDictionary *importedPages;
@property (nonatomic, strong) NSDictionary *nativePages;
@end

@implementation LGRPageFactory

+ (LGRPageFactory*)shared
{
	static LGRPageFactory *shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[LGRPageFactory alloc] init];
	});
	return shared;
}

- (id)init
{
	self = [super init];
	if (self)
    {
		int numClasses = objc_getClassList(NULL, 0);
		
		if (numClasses > 0)
        {
			NSMutableDictionary *importedPages = [NSMutableDictionary dictionary];
			NSMutableDictionary *pages = [NSMutableDictionary dictionary];

			Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
            //输出项目所有类
			numClasses = objc_getClassList(classes, numClasses);

			for (int i = 0; i < numClasses; i++)
            {
				if (imported(importedPages, classes[i]))
					continue;

				if (native(pages, classes[i]))
					continue;
			}
			free(classes);
			
			self.importedPages = importedPages;
            //import--字典形式存入类名
			self.nativePages = pages;
            
            //
            
		}
	}
	return self;
}



/**
 @brief  注册原生控制器
 @param arrayNativePages 原生控制器 Class数组
 */
+ (void)registerNativePages:(NSArray*)arrayNativePages
{
    //pages[NSStringFromClass(class)] = class;
    
    
    NSMutableDictionary *pages = [NSMutableDictionary dictionary];
    [pages addEntriesFromDictionary:[LGRPageFactory shared].nativePages];
    
    for (int i = 0; i < [arrayNativePages count]; i++)
    {
        Class nativeClass = arrayNativePages[i];
        
         pages[NSStringFromClass(nativeClass)] = nativeClass;
    }
    
    [LGRPageFactory shared].nativePages = pages;
    
    
    NSLog(@"%@",[LGRPageFactory shared].nativePages);
    
}


/**
 @brief  注册原生控制器
 @param natvieClass 原生控制器
 */
+ (void)registerNativePage:(Class)nativeClass
{
    
    NSMutableDictionary *pages = [NSMutableDictionary dictionary];
    
    [pages addEntriesFromDictionary:[LGRPageFactory shared].nativePages];
    
    pages[NSStringFromClass(nativeClass)] = nativeClass;
    
    
    [LGRPageFactory shared].nativePages = pages;
    
    
    NSLog(@"%@",[LGRPageFactory shared].nativePages);
    
    
  //  pages
  
}


//加一个直接打开的接口？
//+ (void)openPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent success:(void (^)())success fail:(void (^)())fail
//{
//    // Internal error, we couldn't find the navigation controller or we aren't at the top of the navigation stack
//    if (navigator || _navigator.topViewController != parent) {
//        fail();
//        return;
//    }
//    
//    LGRViewController *new = [LGRPageFactory controllerForPage:page title:title args:args options:options parent:parent];
//    
//    // Couldn't create a new view controller
//    if (!new) {
//        fail();
//        return;
//    }
//    
//    new.collectionPage = self;
//    
//    //本地的才生效。
//    [self.N pushViewController:new animated:YES];
//    success();
//}


//创建目标控制器 -- 根据传入的page来判断是需要引入的控制器还是本地的控制器， 本地控制器上加载的是本地控件还是本地网页/http服务端网页
+ (LGRViewController*)controllerForPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent
{
	return [self standardControllerForPage:page
									 title:title
									  args:args
								   options:options
									parent:parent];
}

//创建目标控制器 -- 根据传入的page来判断是需要引入的控制器还是本地的控制器， 本地控制器上加载的是本地控件还是本地网页/http服务端网页
+ (UIViewController*)controllerForDialogPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent
{
	// Imported (into LigerMobile) pages
//	Class importedClass = [self shared].importedPages[page];
//	if (importedClass) {
//		return [importedClass controllerForImportedPage:page title:title args:args options:options parent:parent];
//	}
    
    Class nativeClass = [self shared].nativePages[page];
    
    if (nativeClass) {
        
        
       // return  [parent presentViewController:[[nativeClass class]init] animated:YES completion:nil];
        
        return [[nativeClass alloc]init];
    }
    
    
    return nil;
    

//	if (title) {
//		NSDictionary *navigatorArgs = @{@"page" : page,
//										@"title" : title ?: @"",
//										@"args": args ?: @{},
//										@"options": options ?: @{}};
//
//		return [LGRPageFactory controllerForPage:@"navigator" title:nil args:navigatorArgs options:@{} parent:parent];
//	} else {
//		return [self standardControllerForPage:page title:@"" args:args options:options parent:parent];
//	}
    
}

//根据page判断，打开的是本地/服务器网页，还是本地控制器
+ (LGRViewController*)standardControllerForPage:(NSString*)page title:(NSString*)title args:(NSDictionary*)args options:(NSDictionary*)options parent:(LGRViewController*)parent
{
	// Do we have a native class that inherits from LGRViewController that implements this page?
    //工程内包含的继承LGRViewController类，
	Class class = [self shared].nativePages[page];
	if (class) {
		LGRViewController *new = [[class alloc] initWithPage:page title:title args:args options:options];
		new.parentPage = parent;
		return new;
	}

	// Create an html page if we have one in the bundle of it it's an http address
    //如果工程内没有page类名，再判断是否是html
	if ([self hasHTMLPage:page]) {
		LGRViewController *new = [[LGRHTMLViewController alloc] initWithPage:page title:title args:args options:options];
		new.parentPage = parent;
		return new;
	}
	return nil;
}

+ (BOOL)hasHTMLPage:(NSString*)page
{
	if (!page)
		return NO;

	// TODO Replace with regex to make sure we open any protocol?
	if ([page hasPrefix:@"http"]||[page hasPrefix:@"file"])
		return YES;

    //NSLog(@"---%@",[[NSBundle mainBundle] pathForResource:page ofType:@"html" inDirectory:@"app"]);
    
    /*
     实际可能将www的插件等放到app的doucment路径下，方便升级维护。,那就需要修改下面的路径
     路径可运行程序打印路径，将文件夹copy到目录下即可。升级的ipa可直接打开包，放到包里面，或者程序第一次使用下载更好。
     page可修改为包含相对路径的名称(相对路径用英文，中文会有问题)，如  cailanzi/firstpage
     */
	if([[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"www/%@",page] ofType:@"html"])
//        if([[NSBundle mainBundle] pathForResource:page ofType:@"html" inDirectory:@"app"])
		return YES;
	
	return NO;
}

@end



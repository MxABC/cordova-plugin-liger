//
//  BaseNativeViewController.h
//  LigerTest
//
//  Created by csc on 15/8/24.
//
//

#import <UIKit/UIKit.h>

@interface LGRNativeViewController : UIViewController

@property (nonatomic, copy) void (^blockArgs)(NSDictionary*args);

@end

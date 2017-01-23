//
//  ViewController.h
//  oc<=>js
//
//  Created by timer_open on 16/8/12.
//  Copyright © 2016年 timer_open. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface ViewController : UIViewController<UIWebViewDelegate>
@property(nonatomic,weak)JSContext *context;


@end


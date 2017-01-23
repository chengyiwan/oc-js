//
//  ViewController.m
//  oc<=>js
//
//  Created by timer_open on 16/8/12.
//  Copyright © 2016年 timer_open. All rights reserved.
//   因为是测试功能能否实现 没有做过多的处理  代码比较low 大家凑和看吧

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIButton *btn;
    UIWebView *webview;
    NSString *swift;
    BOOL     isToNext;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    swift = @"swift->js";
    isToNext = NO;
    [self creatUI];
    
}
-(void)creatUI{
    webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webview.backgroundColor = [UIColor yellowColor];
    webview.delegate = self;
    [self.view addSubview:webview];
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"Test" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    UIButton *btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 500, 200, 40);
    btn1.backgroundColor = [UIColor blueColor];
    [btn1 setTitle:@"oc调用无参数js" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 580, 200, 40);
    btn2.backgroundColor = [UIColor blueColor];
    [btn2 setTitle:@"oc调用有参数js" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
}
#pragma MARK ---oc->js
-(void)btn1click{
    [webview stringByEvaluatingJavaScriptFromString:@"buttonclick()"];
}
-(void)btn2click{
    NSString *name = @"Timer";
    NSString *number = @"111111";
    NSString *str = [NSString stringWithFormat:@"buttonclick1('%@','%@')",name,number];
    [webview stringByEvaluatingJavaScriptFromString:str];
   
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    开始相应请求触发
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
//    开始加载网页
}
#pragma mark:-------js->oc
-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    向js中插入一段代码
    NSString *str = @"document.getElementById('AddPfromOC').innerHTML = '这段文字是由oc加入的js代码，在网页加载完成的时候加入';";
    [webview stringByEvaluatingJavaScriptFromString:str];
//    加载完毕
    _context = [webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context[@"jscall1"] = ^(){
        [self changenav];
    };
    
    _context[@"jscall"] = ^(NSString *str){//html中点击事情调用oc
        [self changeNav:str];
    };
    
    _context[@"jscall2"] = ^(){//js中方法调用oc
//      这里需要对数据操作
        NSArray *args = [JSContext currentArguments];
        NSString *name = args[0];
        NSString *num  = args[1];
        [self changenavwith:name and:num];
    };
    _context[@"jscall3"] = ^(){
//        这个地方取到的值是jsvalue  而不是nsstring 如果需要做判断需要进行转类型 上面是错的 但是我懒
        NSArray *args = [JSContext currentArguments];
        JSValue *block = args[2];
        NSString *str =  block.toString;
        [self isOKwith:str];
    };
}
-(void)isOKwith:(NSString *)block{

    if ([block isEqualToString:@"block"]) {
        [self button3success:block];
    }else{
        [self button3error:block];
    }

}
//    这个就当做是筛选吧  一个回调
-(void)button3success:(NSString *)block{
    NSString *str = [NSString stringWithFormat:@"jscallblock('校验成功%@')",block];
    [webview stringByEvaluatingJavaScriptFromString:str];
}
-(void)button3error:(NSString *)block{
    NSString *str = [NSString stringWithFormat:@"jscallblock('校验失败%@')",block];
    [webview stringByEvaluatingJavaScriptFromString:str];
}

- (void)changeNav : (NSString *)str  {
    self.navigationItem.title =str;
}

-(void)changenav{
    self.navigationItem.title =@"无参数方法调用";
}
-(void)changenavwith:(NSString *)name and:(NSString *)number{
    self.navigationItem.title =[NSString stringWithFormat:@"姓名%@,密码%@",name,number];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

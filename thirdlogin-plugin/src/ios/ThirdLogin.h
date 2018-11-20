#import <Cordova/CDVPlugin.h>
//
//  ThirdLogin.h
//  mDesigner
//
//  Created by MAC-10072A on 2018/11/15.
//
//继承CDVPlugin类
@interface ThirdLogin : CDVPlugin
//接口方法， command.arguments[0]获取前端传递的参数
-(void)initSDK:(CDVInvokedUrlCommand*)args;
-(void)doLogin:(CDVInvokedUrlCommand*)args;
-(void)doLogout:(CDVInvokedUrlCommand*)args;
@end

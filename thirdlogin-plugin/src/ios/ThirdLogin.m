//
//  ThirdLogin.m
//  mDesigner
//
//  Created by MAC-10072A on 2018/11/15.
//

#import "ThirdLogin.h"
#import <Cordova/CDVPlugin.h>

@implementation ThirdLogin
- (void)doLogin:(CDVInvokedUrlCommand*)args
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo =[args.arguments objectAtIndex:0];

    if(echo != nil && [echo length] > 0){
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    }else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:args.callbackId]

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警  告" message:@"这里写警告的内容！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *centain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:centain];
    [[self viewController] presentViewController:alert animated:true completion:nil];

}
@end

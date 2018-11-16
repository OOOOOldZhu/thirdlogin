//
//  ThirdLogin.m
//  mDesigner
//
//  Created by MAC-10072A on 2018/11/15.
//

#import "ThirdLogin.h"
#import <Cordova/CDVPlugin.h>
#import <ShareSDK/ShareSDK.h>
#import <MOBFoundation/MobSDK.h>

@implementation ThirdLogin
- (void)doLogin:(CDVInvokedUrlCommand*)args
{
    [self registSDKAppkey];
    [self registPlatforms];
    [self getUserBySDK:args];
}

-(void)getUserBySDK:(CDVInvokedUrlCommand*)args{
    CDVPluginResult* pluginResult = nil;
    NSString* echo =[args.arguments objectAtIndex:0];
    SSDKPlatformType platformType;
    if([echo  isEqualToString: @"wechat"]){
        platformType = SSDKPlatformTypeWechat;
    }else if ([echo isEqualToString:@"weibo"]){
        platformType = SSDKPlatformTypeSinaWeibo;
    }else if ([echo isEqualToString:@"facebook"]){
        platformType = SSDKPlatformTypeFacebook;
    }else if ([echo isEqualToString:@"twitter"]){
        platformType = SSDKPlatformTypeTwitter;
    }
    if(echo != nil){
        // SSDKPlatformTypeWechat SSDKPlatformTypeTwitter SSDKPlatformTypeSinaWeibo
        [ShareSDK getUserInfo:platformType
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 NSLog(@"uid=%@",user.uid);
                 NSLog(@"%@",user.credential);
                 NSLog(@"token=%@",user.credential.token);
                 NSLog(@"nickname=%@",user.nickname);
             }else{
                 NSLog(@"%@",error);
             }
         }];
    }

    [self.commandDelegate sendPluginResult:nil callbackId:args.callbackId];
}
-(void)registSDKAppkey{
    [MobSDK registerAppKey:@"28c038beb20d6" appSecret:@"e1d6dd766e21ac7fbdd25b91efd5f712"];
}
-(void)registPlatforms {

    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {

        [platformsRegister setupQQWithAppId:@"100371282" appkey:@"aed9b0303e3ed1e27bae87c33761161d"];

        //微信
        [platformsRegister setupWeChatWithAppId:@"wx70ae63195d951329" appSecret:@"ea3431d950273750906fe3314b247fc8"];

        //新浪
        [platformsRegister setupSinaWeiboWithAppkey:@"206863495" appSecret:@"d64b22765519e722030f332d7f825ef5" redirectUrl:@"https://www.microduino.cn/3rd/weibo/callback"];

        //Facebook
        [platformsRegister setupFacebookWithAppkey:@"1412473428822331" appSecret:@"a42f4f3f867dc947b9ed6020c2e93558" displayName:@"shareSDK"];

        //Twitter
        [platformsRegister setupTwitterWithKey:@"viOnkeLpHBKs6KXV7MPpeGyzE" secret:@"NJEglQUy2rqZ9Io9FcAU9p17omFqbORknUpRrCDOK46aAbIiey" redirectUrl:@"http://mob.com"];

    }];

}
-(void)alert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警  告" message:@"这里写警告的内容！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *centain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:centain];
    [[self viewController] presentViewController:alert animated:true completion:nil];
}
@end

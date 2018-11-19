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
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

@implementation ThirdLogin
- (void)initSDK:(CDVInvokedUrlCommand*)args
{
    [self registSDKAppkey];
    [self registPlatforms];
}
- (void)doLogin:(CDVInvokedUrlCommand*)args
{
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
        [ShareSDK getUserInfo:platformType onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 NSLog(@"***************************************************");
                 NSLog(@"%@", user.uid);
                 NSLog(@"%@", user.nickname);
                 NSLog(@"%@", user.icon);
                 NSLog(@"%lu", (unsigned long)user.gender);
                 NSLog(@"%@", user.birthday);
                 NSLog(@"%@", user.url);
                 NSLog(@"***************************************************");
                 CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                               messageAsDictionary:[self convertToJsonData:[user rawData]]];
                 [self.commandDelegate sendPluginResult:pluginResult callbackId:args.callbackId];
             }else{
                 NSLog(@"%@",error);
                 NSString *err = [error localizedDescription];
                 if(state == SSDKResponseStateCancel){
                     err = @"0";
                 }
                 CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                 messageAsString:[NSString stringWithFormat:err]];
                 [self.commandDelegate sendPluginResult:pluginResult callbackId:args.callbackId];
             }
         }];
    }
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
-(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    NSRange range3 = {0,mutStr.length};
    //去掉字符串中的斜杠
    [mutStr replaceOccurrencesOfString:@"\\" withString:@""  options:NSLiteralSearch range:range3];
    return mutStr;

}

@end

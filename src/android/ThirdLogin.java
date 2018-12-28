package com.microduino.mDesigner;

import org.apache.cordova.CordovaPlugin;

import android.app.Activity;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONException;

import java.util.HashMap;
import java.util.Map;

import cn.sharesdk.facebook.Facebook;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.twitter.Twitter;
import cn.sharesdk.wechat.moments.WechatMoments;

/*
 * ：Created by z on 2018/11/14
 */

public class ThirdLogin extends CordovaPlugin {

    @Override
    public boolean execute(String action, CordovaArgs args, CallbackContext callbackContext) throws JSONException {
        if ("doLogin".equals(action)) {
            // 获取activity和context --> cordova.getActivity()和cordova.getContext()
            Toast.makeText(cordova.getContext(), args.getString(0), Toast.LENGTH_SHORT).show();
            doLogin(args.getString(0), callbackContext);
            return true;
        }
        if ("initSDK".equals(action)) {

            return true;
        }
        if ("doLogout".equals(action)) {
            doLogout();
            return true;
        }
        return false;
    }
    private void doLogout(){
        Platform platform = ShareSDK.getPlatform(Facebook.NAME);
        if (platform.isAuthValid()) {
            platform.removeAccount(true);
        }
        platform = ShareSDK.getPlatform(SinaWeibo.NAME);
        if (platform.isAuthValid()) {
            platform.removeAccount(true);
        }
        platform = ShareSDK.getPlatform(Twitter.NAME);
        if (platform.isAuthValid()) {
            platform.removeAccount(true);
        }
        platform = ShareSDK.getPlatform(WechatMoments.NAME);
        if (platform.isAuthValid()) {
            platform.removeAccount(true);
        }
    }

    private void doLogin(String loginType, CallbackContext callbackContext) {
        Activity activity = cordova.getActivity();
        Platform platform = ShareSDK.getPlatform(SinaWeibo.NAME);
        if (loginType.equalsIgnoreCase("facebook")) {
            platform = ShareSDK.getPlatform(Facebook.NAME);
        } else if (loginType.equalsIgnoreCase("weibo")) {
            //platform = ShareSDK.getPlatform(SinaWeibo.NAME);
        } else if (loginType.equalsIgnoreCase("twitter")) {
            platform = ShareSDK.getPlatform(Twitter.NAME);
        } else if (loginType.equalsIgnoreCase("wechat")) {
            platform = ShareSDK.getPlatform(WechatMoments.NAME);
        }
        //回调信息，可以在这里获取基本的授权返回的信息，但是注意如果做提示和UI操作要传到主线程handler里去执行
        if (platform != null) {
            platform.setPlatformActionListener(new PlatformActionListener() {

                @Override
                public void onComplete(Platform platform, int action, HashMap<String, Object> resp) {
                    //输出所有授权信息
                    //platform.getDb().exportData();
                    if ((action == Platform.ACTION_AUTHORIZING || action == Platform.ACTION_USER_INFOR) && activity != null) {
                        String json = platform.getDb().exportData();
                        Log.i("zhu", "onComplete: " + json);
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                callbackContext.success(json);
                            }
                        });
                    }
                }

                @Override
                public void onError(Platform platform, int action, Throwable throwable) {
                    if ((action == Platform.ACTION_AUTHORIZING || action == Platform.ACTION_USER_INFOR) && activity != null) {
                        Log.i("zhu", "onError: " + throwable.toString());
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                callbackContext.error(throwable.toString());
                            }
                        });
                    }
                }

                @Override
                public void onCancel(Platform platform, int action) {
                    if ((action == Platform.ACTION_AUTHORIZING || action == Platform.ACTION_USER_INFOR) && activity != null) {
                        Log.i("zhu", "onCancel: ");
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                callbackContext.error("0");
                            }
                        });
                    }
                }
            });
            //判断指定平台是否已经完成授权
            if (platform.isAuthValid() && activity != null) {
                String json = platform.getDb().exportData();
                Log.i("zhu", "onComplete1 : " + json);
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        callbackContext.success(json);
                    }
                });
                return;
            }
            // true不使用SSO授权，false使用SSO授权
            platform.SSOSetting(true);
            //获取用户资料
            if(loginType.equalsIgnoreCase("wechat")){
                platform.authorize(null);
            }else {
                platform.showUser(null);
            }
        }
    }
}

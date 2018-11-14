package com.microduino.mDesigner;

import org.apache.cordova.CordovaPlugin;

import android.widget.Toast;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONException;

import java.util.HashMap;

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
        return false;
    }

    private void doLogin(String loginType, CallbackContext callbackContext) {
        Platform  platform = ShareSDK.getPlatform(SinaWeibo.NAME);
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
        if(platform!=null) {
            platform.setPlatformActionListener(new PlatformActionListener() {

                @Override
                public void onError(Platform arg0, int arg1, Throwable arg2) {
                    // TODO Auto-generated method stub
                    arg2.printStackTrace();
                }

                @Override
                public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
                    // TODO Auto-generated method stub
                    //输出所有授权信息
                    arg0.getDb().exportData();
                }

                @Override
                public void onCancel(Platform arg0, int arg1) {
                    // TODO Auto-generated method stub

                }
            });
            //authorize与showUser单独调用一个即可
            platform.authorize();//要功能不要数据，在监听oncomplete中不会返回用户数据
        }
    }
}


var exec = require('cordova/exec');

// ToastShow： 是plugin.xml文件中的feature标签 name属性
// show：是js中调用的方法名
// [arg0]: 表示一个参数，[arg0,arg1]:表示两个参数
exports.doLogin = function (arg0, success, error) {
    exec(success, error, 'ThirdLogin', 'doLogin', [arg0]);
};
exports.initSDK = function (arg0, success, error) {
    exec(success, error, 'ThirdLogin', 'initSDK', [arg0]);
};

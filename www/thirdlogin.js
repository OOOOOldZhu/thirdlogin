var exec = require('cordova/exec');

// exports.coolMethod = function (arg0, success, error) {
//     exec(success, error, 'thirdlogin', 'coolMethod', [arg0]);
// };

// ThirdLogin： 是plugin.xml文件中的feature标签 name属性
// show：是js中调用的方法名
// [arg0]: 表示一个参数，[arg0,arg1]:表示两个参数
exports.show = function (arg0, success, error) {
    exec(success, error, 'ThirdLogin', 'show', [arg0]);
};
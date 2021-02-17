var exec = require('cordova/exec');

exports.start = function (arg0, arg1, arg2) {
    exec(onSuccess, onFailure, 'NetmeraPlugin', 'start', [arg0, arg1, arg2]);
};

exports.requestPushNotificationAuthorization = function () {
    exec(onSuccess, onFailure, 'NetmeraPlugin', 'requestPushNotificationAuthorization', []);
};

exports.subscribePushNotification = function (success, error) {
    exec(success, error, 'NetmeraPlugin', 'subscribePushNotification', []);
};

exports.subscribeOpenUrl = function (success, error) {
    exec(success, error, 'NetmeraPlugin', 'subscribeOpenUrl', []);
};

exports.subscribePushClick = function (success, error) {
    exec(success, error, 'NetmeraPlugin', 'subscribePushClick', []);
};

exports.subscribePushButtonClick = function (success, error) {
    exec(success, error, 'NetmeraPlugin', 'subscribePushButtonClick', []);
};

exports.sendEvent = function (arg0, arg1) {
    exec(onSuccess, onFailure, 'NetmeraPlugin', 'sendEvent', [arg0, arg1]);
};

exports.fetchInboxUsingFilter = function (arg0, success, error) {
    exec(success, error, 'NetmeraPlugin', 'fetchInboxUsingFilter', [arg0]);
};

exports.fetchNextPage = function (success, error) {
    exec(success, error, 'NetmeraPlugin', 'fetchNextPage', []);
};

exports.countForStatus = function (arg0, success, error) {
    exec(success, error, 'NetmeraPlugin', 'countForStatus', [arg0]);
};

exports.updatePushStatus = function (arg0, arg1, arg2, success, error) {
    exec(success, error, 'NetmeraPlugin', 'updatePushStatus', [arg0, arg1, arg2]);
};

exports.updateAllPushStatus = function(arg0) {
    exec(success, error, 'NetmeraPlugin', 'updateAllPushStatus', [arg0]);
};

exports.updateUser = function (arg0) {
    exec(onSuccess, onFailure,'NetmeraPlugin', 'updateUser', [arg0]);
};

exports.requestLocationAuthorization = function() {
    exec(onSuccess, onFailure, 'NetmeraPlugin', 'requestLocationAuthorization', []);
};

var onSuccess = function (result) {
    console.log("OnSuccess: ", result);
}
var onFailure = function (err) {
    console.log("OnFailure: ", err);
}
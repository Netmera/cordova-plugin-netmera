package com.netmera.cordova.plugin;

import android.content.Context;
import android.os.Bundle;

import com.netmera.NetmeraPushBroadcastReceiver;
import com.netmera.NetmeraPushObject;

public class PushReceiver extends NetmeraPushBroadcastReceiver {
    @Override
    protected void onPushRegister(Context context, String gcmSenderId, String pushTkoen) {
        //if you want to know what is the push token for given gcmSenderId
    }

    @Override
    protected void onPushReceive(Context context, Bundle bundle, NetmeraPushObject netmeraPushObject) {
        //if you want to know when a push receives
        NetmeraPlugin.sendPushNotification(netmeraPushObject);
    }

    @Override
    protected void onPushOpen(Context context, Bundle bundle, NetmeraPushObject netmeraPushObject) {
        //if you want to know when a push is opened
        NetmeraPlugin.setInitialPushPayload(netmeraPushObject);
        NetmeraPlugin.sendPushClick(netmeraPushObject);
    }

    @Override
    protected void onPushDismiss(Context context, Bundle bundle, NetmeraPushObject netmeraPushObject) {
        //if you want to know when a push is dismissed
        //NetmeraPlugin.sendPushNotification(netmeraPushObject);
    }

    @Override
    protected void onPushButtonClicked(Context context, Bundle bundle, NetmeraPushObject netmeraPushObject) {
        //if you want to know when a interactive push button is clicked
        NetmeraPlugin.sendPushButtonClick(netmeraPushObject);
    }
}
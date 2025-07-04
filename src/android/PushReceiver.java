package com.netmera.cordova.plugin;

import android.content.Context;
import android.os.Bundle;

import com.netmera.NetmeraCarouselObject;
import com.netmera.NetmeraPushObject;
import com.netmera.callbacks.NMPushActionCallbacks;

public class PushReceiver implements NMPushActionCallbacks {
    @Override
    public void onPushRegister(Context context, String gcmSenderId, String pushTkoen) {
        //if you want to know what is the push token for given gcmSenderId
    }

    @Override
    public void onPushReceive(Context context, Bundle bundle, NetmeraPushObject netmeraPushObject) {
        //if you want to know when a push receives
        NetmeraPlugin.sendPushNotification(netmeraPushObject);
    }

    @Override
    public void onPushOpen(Context context, Bundle bundle, NetmeraPushObject netmeraPushObject) {
        //if you want to know when a push is opened
        NetmeraPlugin.setInitialPushPayload(netmeraPushObject);
        NetmeraPlugin.sendPushClick(netmeraPushObject);
    }

    @Override
    public void onPushDismiss(Context context, Bundle bundle, NetmeraPushObject netmeraPushObject) {
        //if you want to know when a push is dismissed
        //NetmeraPlugin.sendPushNotification(netmeraPushObject);
    }

    @Override
    public void onPushButtonClicked(Context context, Bundle bundle, NetmeraPushObject netmeraPushObject) {
        //if you want to know when a interactive push button is clicked
        NetmeraPlugin.sendPushButtonClick(netmeraPushObject);
    }

  @Override
  public void onCarouselObjectSelected(Context context, Bundle bundle, NetmeraPushObject netmeraPushObject, int i, NetmeraCarouselObject netmeraCarouselObject) {

  }
}

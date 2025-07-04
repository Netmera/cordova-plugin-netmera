package com.netmera.cordova.plugin;

import android.app.Application;
import android.util.Log;
import com.netmera.Netmera;
import com.netmera.NetmeraConfiguration;

import org.apache.cordova.ConfigXmlParser;

public class NetmeraApplication extends Application {
    @Override
    public void onCreate() {
        Log.d("MyApplication", "onCreate");
        super.onCreate();

        try {
            ConfigXmlParser parser = new ConfigXmlParser();
            parser.parse(this);

            String netmeraKey = parser.getPreferences().getString("NetmeraKey", null);
            String netmeraFCM = parser.getPreferences().getString("FcmKey", null);
            String netmeraBaseUrl = parser.getPreferences().getString("NetmeraBaseUrl", null);

            if (netmeraKey != null && netmeraFCM != null) {
              NetmeraConfiguration.Builder configBuilder = new NetmeraConfiguration.Builder();
              configBuilder
                .baseUrl(netmeraBaseUrl)
                .apiKey(netmeraKey)
                .firebaseSenderId(netmeraFCM)
                .logging(true)
                .disableSerializeRule(false)
                .nmPushActionCallbacks(new PushReceiver());
              Netmera.init(configBuilder.build(this));
            }

            Netmera.enablePopupPresentation();
        } catch (NullPointerException e) {
            Log.e("TAG", "Failed to load meta-data, NullPointer: " + e.getMessage());
        }
    }
}

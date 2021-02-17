package com.netmera.cordova.plugin;

import android.app.Application;
import android.util.Log;
import com.netmera.Netmera;
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
                Netmera.init(this, netmeraFCM, netmeraKey);
            }

            if(netmeraBaseUrl != null) {
                Netmera.setBaseUrl(netmeraBaseUrl);
            }
            Netmera.logging(true);
            Netmera.enablePopupPresentation();
        } catch (NullPointerException e) {
            Log.e("TAG", "Failed to load meta-data, NullPointer: " + e.getMessage());
        }
    }
}
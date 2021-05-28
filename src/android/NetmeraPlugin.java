package com.netmera.cordova.plugin;

import android.util.Log;
import android.content.Context;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.annotations.SerializedName;
import com.netmera.Netmera;
import com.netmera.NetmeraError;
import com.netmera.NetmeraEvent;
import com.netmera.NetmeraInbox;
import com.netmera.NetmeraInboxFilter;
import com.netmera.NetmeraLogEvent;
import com.netmera.NetmeraPushObject;
import com.netmera.NetmeraUser;
import com.netmera.events.NetmeraEventBannerOpen;
import com.netmera.events.NetmeraEventBatteryLevel;
import com.netmera.events.NetmeraEventCategoryView;
import com.netmera.events.NetmeraEventInAppPurchase;
import com.netmera.events.NetmeraEventLogin;
import com.netmera.events.NetmeraEventRegister;
import com.netmera.events.NetmeraEventScreenView;
import com.netmera.events.NetmeraEventSearch;
import com.netmera.events.NetmeraEventShare;
import com.netmera.events.commerce.NetmeraEventCartAddProduct;
import com.netmera.events.commerce.NetmeraEventCartRemoveProduct;
import com.netmera.events.commerce.NetmeraEventCartView;
import com.netmera.events.commerce.NetmeraEventOrderCancel;
import com.netmera.events.commerce.NetmeraEventProduct;
import com.netmera.events.commerce.NetmeraEventProductComment;
import com.netmera.events.commerce.NetmeraEventProductRate;
import com.netmera.events.commerce.NetmeraEventProductView;
import com.netmera.events.commerce.NetmeraEventPurchase;
import com.netmera.events.commerce.NetmeraEventWishList;
import com.netmera.events.commerce.NetmeraProduct;
import com.netmera.events.media.NetmeraContent;
import com.netmera.events.media.NetmeraEventContent;
import com.netmera.events.media.NetmeraEventContentComment;
import com.netmera.events.media.NetmeraEventContentRate;
import com.netmera.events.media.NetmeraEventContentView;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaWebView;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * This class echoes a string called from JavaScript.
 */
public class NetmeraPlugin extends CordovaPlugin {

    private NetmeraInbox netmeraInbox;
    protected static CallbackContext pushCallbackContext;
    protected static CallbackContext pushClickCallbackContext;
    protected static CallbackContext pushButtonClickCallbackContext;
    public static NetmeraPushObject initialPushPayload;


    public static final String TAG = "NetmeraPlugin";
    private static NetmeraPlugin instance;
    protected Context context;

    public NetmeraPlugin() {
    }

    public NetmeraPlugin(Context context) {
        this.context = context;
    }

    public static synchronized NetmeraPlugin getInstance(Context context) {
        if (instance == null) {
            instance = new NetmeraPlugin(context);
            instance = getPlugin(instance);
        }

        return instance;
    }

    public static synchronized NetmeraPlugin getInstance() {
        if (instance == null) {
            instance = new NetmeraPlugin();
            instance = getPlugin(instance);
        }

        return instance;
    }

    public static NetmeraPlugin getPlugin(NetmeraPlugin plugin) {
        if (plugin.webView != null) {
            instance = (NetmeraPlugin) plugin.webView.getPluginManager().getPlugin(NetmeraPlugin.class.getName());
        } else {
            plugin.initialize(null, null);
            instance = plugin;
        }

        return instance;
    }

    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        context = cordova.getActivity().getApplicationContext();
        //cordova.getActivity()
        Log.d(TAG, "==> NetmeraPlugin initialize");
    }

    public static void sendPushNotification(NetmeraPushObject push) {
        if (pushCallbackContext != null) {
            try {
                JSONObject pushObject = returnPushObject(push);
                PluginResult result = new PluginResult(PluginResult.Status.OK, pushObject);
                result.setKeepCallback(true);
                pushCallbackContext.sendPluginResult(result);
            } catch (JSONException e) {
                e.printStackTrace();
                pushCallbackContext.error(e.getMessage());
            }
        }
    }

    public static void sendPushClick(NetmeraPushObject push) {
        if (pushClickCallbackContext != null) {
            try {
                JSONObject pushObject = returnPushObject(push);
                PluginResult result = new PluginResult(PluginResult.Status.OK, pushObject);
                result.setKeepCallback(true);
                pushClickCallbackContext.sendPluginResult(result);
            } catch (JSONException e) {
                e.printStackTrace();
                pushClickCallbackContext.error(e.getMessage());
            }
        }
    }

    public static void sendPushButtonClick(NetmeraPushObject push) {
        if (pushButtonClickCallbackContext != null) {
            try {
                JSONObject pushObject = returnPushObject(push);
                PluginResult result = new PluginResult(PluginResult.Status.OK, pushObject);
                result.setKeepCallback(true);
                pushButtonClickCallbackContext.sendPluginResult(result);
            } catch (JSONException e) {
                e.printStackTrace();
                pushButtonClickCallbackContext.error(e.getMessage());
            }
        }
    }

    public static void setInitialPushPayload(NetmeraPushObject payload) {
        initialPushPayload = payload;
    }

    public NetmeraPushObject getInitialPushPayload() {
        return initialPushPayload;
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("start")) {
            // String netmeraKey = args.getString(0);
            // String fcmKey = args.getString(1);
            // String baseUrl = args.getString(2);
            // cordova.getActivity().runOnUiThread(new Runnable() {
            //     public void run() {
            //         Netmera.init(context, fcmKey, netmeraKey);
            //         Netmera.logging(true);
            //         Netmera.enablePopupPresentation();
            //         if (baseUrl != "null") {
            //             Log.d(TAG, "runs: onpremise setup!");
            //             Netmera.setBaseUrl(baseUrl);
            //         }
            //     }
            // });
            return true;
        } else if (action.equals("subscribePushNotification")) {
            pushCallbackContext = callbackContext;
            return true;
        } else if (action.equals("subscribePushClick")) {
            NetmeraPushObject initPush = getInitialPushPayload();
            if (initPush == null) {
                pushClickCallbackContext = callbackContext;
                return true;
            }
            cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                    try {
                        pushClickCallbackContext = callbackContext;
                        JSONObject pushObject = returnPushObject(initPush);
                        PluginResult result = new PluginResult(PluginResult.Status.OK, pushObject);
                        result.setKeepCallback(true);
                        pushClickCallbackContext.sendPluginResult(result);
                    } catch (Exception e) {
                        callbackContext.error(e.getMessage());
                    }
                }
            });
            return true;
        } else if (action.equals("subscribePushButtonClick")) {
            pushButtonClickCallbackContext = callbackContext;
            return true;
        } else if (action.equals("requestPushNotificationAuthorization")) {
            return true;
        } else if (action.equals("subscribeOpenUrl")) {
            return true;
        } else if (action.equals("sendEvent")) {
            JSONObject event = args.getJSONObject(0);
            this.sendEvent(event, callbackContext);
            return true;
        } else if (action.equals("fetchInboxUsingFilter")) {
            JSONObject userFilter = args.getJSONObject(0);
            this.fetchInbox(userFilter, callbackContext);
            return true;
        } else if (action.equals("fetchNextPage")) {
            this.fetchNextPage(callbackContext);
            return true;
        } else if (action.equals("countForStatus")) {
            int status = args.getInt(0);
            this.countForStatus(status, callbackContext);
            return true;
        } else if (action.equals("updatePushStatus")) {
            int index = args.getInt(0);
            int length = args.getInt(1);
            int status = args.getInt(2);
            this.updatePushStatus(index, length, status, callbackContext);
            return true;
        } else if (action.equals("updateUser")) {
            JSONObject user = args.getJSONObject(0);
            this.updateUser(user, callbackContext);
            return true;
        } else if (action.equals("requestLocationAuthorization")) {
            this.requestPermissionsForLocation(callbackContext);
            return true;
        }
        return false;
    }

    static void sendEvent(JSONObject call, CallbackContext callbackContext) {
        String CODE = "code";
        HashMap<String, Object> eventMap = new Gson().fromJson(call.toString(), HashMap.class);
        eventMap.values().removeAll(Collections.singleton(null));
        FNetmeraEvent event = new FNetmeraEvent();

        if (hasKey(eventMap, CODE)) {
            event.setCode((String) eventMap.get(CODE));
            eventMap.remove(CODE);
        }

        event.setEventParameters(eventMap);
        Netmera.sendEvent(event);
        callbackContext.success();
    }

    private static boolean hasKey(Map map, String key) {
        return map.containsKey(key) && map.get(key) != null;
    }

    private void fetchInbox(JSONObject userFilter, CallbackContext callbackContext) throws JSONException {
        ArrayList list = new ArrayList<String>();
        NetmeraInboxFilter filter = new NetmeraInboxFilter.Builder()
                .pageSize(userFilter.has("pageSize") ? userFilter.getInt("pageSize") : 2147483647)
                .status(userFilter.has("status") ? userFilter.getInt("status") : 3)
                .categories(userFilter.has("categories") ? toArrayList(userFilter.getJSONArray("categories")) : list)
                .includeExpiredObjects(userFilter.has("includeExpiredObjects") ? userFilter.getBoolean("includeExpiredObjects") : false)
                .build();

        Netmera.fetchInbox(filter, new NetmeraInbox.NetmeraInboxFetchCallback() {
            @Override
            public void onFetchInbox(NetmeraInbox inbox, NetmeraError error) {
                if (error != null) {
                    callbackContext.error(error.getMessage());
                    return;
                }
                netmeraInbox = inbox;
                JSONObject response = getInboxResponse(inbox);
                callbackContext.success(response);
            }
        });
    }

    private void fetchNextPage(CallbackContext callbackContext) {
        if (netmeraInbox != null) {
            if (netmeraInbox.hasNextPage()) {
                netmeraInbox.fetchNextPage(new NetmeraInbox.NetmeraInboxFetchCallback() {
                    @Override
                    public void onFetchInbox(NetmeraInbox inbox, NetmeraError error) {
                        if (error != null) {
                            callbackContext.error(error.getMessage());
                            return;
                        }
                        netmeraInbox = inbox;
                        JSONObject response = getInboxResponse(inbox);
                        callbackContext.success(response);
                    }
                });
            }
        }
    }

    private void updatePushStatus(int index, int length, int status, CallbackContext callbackContext) {
        int lastIndex = index + length;
        List<NetmeraPushObject> objectsToDelete = netmeraInbox.pushObjects().subList(index, lastIndex);
        netmeraInbox.updateStatus(objectsToDelete,status,
                new NetmeraInbox.NetmeraInboxStatusCallback() {
                    @Override
                    public void onSetStatusInbox(NetmeraError error) {
                        if (error != null) {
                            callbackContext.error(error.getMessage());
                            return;
                        }
                        callbackContext.success(); // TODO
                    }
                });
    }

    private void countForStatus(int status, CallbackContext callbackContext) {
        int count = 0;
        count = netmeraInbox.countForStatus(status);
        callbackContext.success(count);
    }

    private void requestPermissionsForLocation(CallbackContext callbackContext) {
        Netmera.requestPermissionsForLocation();
        callbackContext.success();
    }

    private JSONObject getInboxResponse(NetmeraInbox inbox) {
        JSONArray pushList = getInboxList(inbox);
        JSONObject result = new JSONObject();
        try {
            result.put("inbox", pushList);
            result.put("hasNextPage", inbox.hasNextPage());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return result;
    }

    private JSONArray getInboxList(NetmeraInbox inbox) {
        List<NetmeraPushObject> objects = inbox.pushObjects();
        JSONArray responsePushList = new JSONArray();
        for (int i = 0; i < objects.size(); i++) {
            NetmeraPushObject push = objects.get(i);
            try {
                JSONObject newPushObject = returnPushObject(push);
                responsePushList.put(newPushObject);
            } catch (JSONException e) {
                e.printStackTrace();
                continue;
            }
        }
        return responsePushList;
    }

    private static JSONObject returnPushObject(NetmeraPushObject push) throws JSONException {
        JSONObject responsePush = new JSONObject();
        responsePush.put("title", push.getPushStyle().getContentTitle());
        responsePush.put("subtitle", push.getPushStyle().getSubText());
        responsePush.put("body", push.getPushStyle().getContentText());
        responsePush.put("pushId", push.getPushId());
        responsePush.put("pushInstanceId", push.getPushInstanceId());
        responsePush.put("pushType", push.getPushType());
        responsePush.put("inboxStatus", push.getInboxStatus());
        responsePush.put("sendDate", push.getSendDate());
        responsePush.put("deeplinkUrl", push.getDeepLink() == null ? "" : push.getDeepLink().toString());

        return responsePush;
    }

    private ArrayList toArrayList(JSONArray jsonArray) throws JSONException {
        ArrayList list = new ArrayList<String>();
        for (int i = 0; i < jsonArray.length(); i++) {
            list.add(jsonArray.getString(i));
        }
        return list;
    }


    static void updateUser(JSONObject call, CallbackContext callbackContext) {
        String USER_ID = "userId";
        String EMAIL = "email";
        String MSISDN = "msisdn";
        String CODE = "code";
        HashMap<String, Object> userMap = new Gson().fromJson(call.toString(), HashMap.class);
        userMap.values().removeAll(Collections.singleton(null));
        FNetmeraUser netmeraUser = new FNetmeraUser();

        if (hasKey(userMap, USER_ID)) {
            netmeraUser.setUserId((String) userMap.get(USER_ID));
            userMap.remove(USER_ID);
        }

        if (hasKey(userMap, EMAIL)) {
            netmeraUser.setEmail((String) userMap.get(EMAIL));
            userMap.remove(EMAIL);
        }

        if (hasKey(userMap, MSISDN)) {
            netmeraUser.setMsisdn((String) userMap.get(MSISDN));
            userMap.remove(MSISDN);
        }
        
        netmeraUser.setUserParameters(userMap);
        Netmera.updateUser(netmeraUser);
        callbackContext.success();
    }



    public static class FNetmeraEvent extends NetmeraEvent {

        @SerializedName("prms")
        private Map<String, Object> eventParameters;

        private String code;

        public void setEventParameters(Map<String, Object> eventParameters) {
            this.eventParameters = eventParameters;
        }

        public void setCode(String code) {
            this.code = code;
        }

        @Override
        protected String eventCode() {
            return code;
        }
    }

    public static class FNetmeraUser extends NetmeraUser {

        @SerializedName("prms")
        private Map<String, Object> userParameters;

        void setUserParameters(Map<String, Object> userParameters) {
            this.userParameters = userParameters;
        }
    }


}


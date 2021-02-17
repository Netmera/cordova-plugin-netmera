# netmera-cordova

Netmera cordova plugin
Netmera cordova sdk
keywords: push, analytics, segmantation, deeplink

run in terminal;
```sh
cordova plugin add https://github.com/Netmera/cordova-plugin-netmera.git
```

add in project's config.xml



```sh
<preference name="NetmeraKey" value="example-key" />
<preference name="NetmeraBaseUrl" value="example-base-url" />
<preference name="FcmKey" value="example-fcm-key" />
<preference name="AppGroupName" value="group.com.example.groupname" />
```

- NetmeraKey = Netmera SDK API Key on Netmera panel - Required
- FcmKey = Firebase sender id on your Firebase project - Required
- AppGroupName = Group name on your Apple developer project(for carousel push) - Optional
- NetmeraBaseUrl = Base URL on your server(for on premise setup) - Optional


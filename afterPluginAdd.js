#!/usr/bin/env node

module.exports = function(context) {

    var fs = require('fs'),
      path = require('path');
  
    var platformRoot = path.join(context.opts.projectRoot, 'platforms/android/app/src/main');
  
    var manifestFile = path.join(platformRoot, 'AndroidManifest.xml');
  
    if (fs.existsSync(manifestFile)) {
      try {
          fs.readFile(manifestFile, 'utf8', function (err,data) {
            if (err) {
              throw new Error('Unable to find AndroidManifest.xml: ' + err);
            }
  
            var appClass = 'com.netmera.cordova.plugin.NetmeraApplication';
  
            if (data.indexOf(appClass) == -1) {
  
              var result = data.replace(/<application/g, '<application android:name="' + appClass + '"');
  
              fs.writeFile(manifestFile, result, 'utf8', function (err) {
                if (err) {
                    throw new Error('Unable to write into AndroidManifest.xml: ' + err);
                }
              });
            }
          });
      } catch(err) {
          process.stdout.write(err);
      }
    }
  }
singlefile
==========

Ensures that your async function runs to completion before it is executed again

```javascript
// example of loading and caching a config file
var singlefile = require("singlefile");
var _config = null;
var getConfig = singlefile(function(cb) {
  console.log("getConfig called");
  if (_config !== null) {
    return cb(null, _config);
  }
  
  // fake delay demonstrating disk/network read for config file
  setTimeout(function() {
    console.log("Setting config file");
    _config = {awesome: true};
    cb(null, _config);
  }, 1000);
});

// let's use it
getConfig(function(err, config) {
  console.log("got config 1");
});
// another call happening at the same time
getConfig(function(err, config) {
  console.log("got config 2");
});

/**
 * LOG OUTPUT
 * getConfig called
 * Setting config file
 * got config 1
 * getConfig called
 * got config 2
 */
 ```

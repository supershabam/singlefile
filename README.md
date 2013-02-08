singlefile
==========

Ensures that your async function runs to completion before it is executed again

```javascript
// example of loading and caching a config file
exports._config = null
exports.getConfig = singlefile(function(cb) {
  console.log("getConfig called");
  if (exports._config !== null) {
    return cb(null, exports._config);
  }
  
  // fake delay demonstrating disk/network read for config file
  setTimeout(function() {
    console.log("Setting config file");
    exports._config = {awesome: true};
    cb(null, exports._config);
  }, 1000);
});

// let's use it
exports.getConfig(function(err, config) {
  console.log("got config 1");
});
// another call happening at the same time
exports.getConfig(function(err, config) {
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

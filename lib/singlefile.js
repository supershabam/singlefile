"use strict"

module.exports = function(fn, context) {
  var queue = []
    , running = false
    , dequeue
    ;

  dequeue = function() {
    var item
      , callback
      ;

    item = queue.pop();
    if (!item) {
      running = false;
      return;
    }

    callback = function() {
      var args = arguments.length === 1 ? [arguments[0]] : Array.apply(null, arguments);
      item.cb.apply(null, args);
      dequeue();
    };

    fn.apply(context, item.args.concat([callback]));
  };

  return function() {
    var args = arguments.length === 1 ? [arguments[0]] : Array.apply(null, arguments)
      , cb = args.pop()
      ;

    queue.push({args: args, cb: cb});

    if (!running) {
      running = true;
      dequeue();
    }
  }
};

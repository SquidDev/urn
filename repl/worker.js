var worker = this;

var location = worker.location && worker.location.path || "/repl/";
if(!location.endsWith("/")) location += "/";

// Load Lua VM
worker.importScripts(location + "../assets/lib/lua.js");

// Stub emscripten methods
emscripten.print = x => console.log(x);
emscripten.printErr = x => console.error(x);

/** Various message methods */
var messages = {
  status: function(msg) { worker.postMessage({ tag: "status", message: msg }); },
  write_plain: function(msg) { worker.postMessage({ tag: "write-plain", message: msg }); },
  write_ansi: function(msg) { worker.postMessage({ tag: "write-ansi", message: msg }); },
  prompt: function(msg) { worker.postMessage({ tag: "prompt", input: msg }); },
};
worker.messages = messages;

/** Attempt to download a URL. */
var fetch_url = function(url, ok, err) {
  var http_request = new XMLHttpRequest();
  http_request.onreadystatechange = function() {
    if (http_request.readyState === XMLHttpRequest.DONE) {
      if (http_request.status === 200) {
        ok(http_request.responseText);
      } else {
        messages.status("Cannot download " + url);
        console.error(http_request);
      }
    }
  };

  http_request.open('GET', url, true);
  http_request.send();
};

var tree = null, wrapper = null;
var run = function() {
  if(tree != null && wrapper != null) {
    L.load(wrapper, "@wrapper.lua")(JSON.parse(tree));
  }
};

fetch_url("https://api.github.com/repos/SquidDev/urn/git/trees/master?recursive=1",
// fetch_url(location + "file_list.json",
          function(r_tree) { tree = r_tree; run(); });

fetch_url(location + "wrapper.lua",
          function(r_wrapper) { wrapper = r_wrapper; run(); });

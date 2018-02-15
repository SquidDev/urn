'use strict';
window.onload = function() {
  const fetch_url = url => new Promise((ok, err) => {
    var http_request = new XMLHttpRequest();
    http_request.onreadystatechange = () => {
      if (http_request.readyState === XMLHttpRequest.DONE) {
        if (http_request.status === 200) {
          ok(http_request.responseText);
        } else {
          err("Cannot find " + url);
        }
      }
    };

    http_request.open('GET', url, true);
    http_request.send();
  });

  emscripten.print = x => console.log(x);
  emscripten.printErr = x => console.error(x);

  const location = document.location.href;
  if(!location.endsWith("/")) location += "/";

  Promise.all([
    fetch_url("https://api.github.com/repos/SquidDev/urn/git/trees/master?recursive=1"),
    // fetch_url("//repl/file_list.json"),
    fetch_url(location + "wrapper.lua"),
  ])
    .then(([tree, wrapper]) => {
      L.load(wrapper, "@wrapper.lua")(JSON.parse(tree));
    })
    .catch(err => {
      console.error(err);
      document.getElementById("terminal-status").innerText = "Error loading REPL: " + err;
    });
};

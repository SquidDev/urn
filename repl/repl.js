'use strict';
window.onload = function() {
  var status = document.getElementById("terminal-status"),
      output = document.getElementById("terminal-output"),
      input = document.getElementById("terminal-input"),
      container = document.getElementById("terminal-container");

  if(!window.Worker) {
    status.innerText = "The Urn REPL requires web workers to be enabled."
    return;
  }

  var bold = false, fg = 0x7;
  var colours = [
    // Black[0x0] Red        Green      Yellow
    "#2e3436", "#cc0000", "#4e9a06", "#c4a000",
    // Blue       Magenta    Cyan       White[0x7]
    "#3464a4", "#af00af", "#06989a", "#d3d7cf",

    // Black[0x8] Red        Green      Yellow
    "#949494", "#5f87d7", "#8ae234", "#34e2e2",
    // Blue       Magenta    Cyan       White[0xF]
    "#ef2929", "#ad7fa8", "#ff9d3a", "#ffffff",
  ];

  /** Write {@code str} to the output, adding styling if needed. */
  var write_plain = function(str) {
    if(str === "") return;

    var contents = document.createElement("span");
    contents.appendChild(document.createTextNode(str));
    contents.style.color = colours[bold ? fg + 8 : fg];

    output.insertBefore(contents, input);
  };

  /** Write the ANSI string {@code str} to the output. */
  var write_ansi = function(str) {
    if(str === "") return;

    var pos = 0;
    while(pos < str.length) {
      var esc = str.indexOf("\x1b[", pos);
      if(esc >= 0) {
        write_plain(str.substring(pos, esc));

        var args = [ "" ];
        for(var off = esc + 2; off < str.length; off++) {
          var chr = str[off];
          if(chr === "m") {
            for(var i = 0; i < args.length; i++ ){
              var arg = parseInt(args[i]);
              if(arg === 0) {
                bold = false;
                fg = 0x7;
              } else if(arg === 1) {
                bold = true;
              } else if (arg >= 30 && arg <= 37) {
                fg = arg - 30;
              } else if (arg >= 90 && arg <= 97) {
                fg = arg - 90 + 8;
              }
            }
            pos = off + 1;
            break;
          } else if (chr === ";") {
            args.push("");
          } else {
            args[args.length - 1] = args[args.length - 1] + chr;
          }
        }
      } else {
        write_plain(str.substr(pos));
        break;
      }
    }
  }

  /** Set the current input string to be {@code str}. */
  var write_input = function(str) {
    input.innerText = str;
    input.focus();

    if(str != "") {
      var range = document.createRange();
      range.selectNodeContents(input);
      range.collapse(false);

      var selection = window.getSelection();
      selection.removeAllRanges();
      selection.addRange(range);
    }
  };

  var worker = new Worker("worker.js");
  worker.onmessage = function(e) {
    var data = e.data;
    if(data.tag === "status") {
      status.innerText = data.message;

    } else if (data.tag === "write-plain") {
      write_plain(data.message);
      container.scrollTop = container.scrollHeight;

    } else if (data.tag === "write-ansi") {
      write_ansi(data.message);
      container.scrollTop = container.scrollHeight;

    } else if (data.tag === "prompt") {
      write_input(data.input);
    } else {
      console.error("Unknown message", e);
    }
  };

  worker.onerror = function(e) {
    status.innerText = "Urn REPL crashed.";
    console.error(e);
  };

  var history = [], history_index = -1;
  input.onkeydown = function(e) {
    var key = e.key || e.which;
    if(key === "Enter" && !e.shiftKey) {
      e.preventDefault();

      var value = this.innerText;
      this.innerText = "";
      this.blur();

      history_index = -1;
      if(value.match(/\S/) && value !== history[history.length - 1]) {
        history.push(value);
      }

      write_plain(value + "\n");
      container.scrollTop = container.scrollHeight;

      worker.postMessage({ tag: "input", input: value });
    } else if(key === "Up" || key === "ArrowUp") {
      e.preventDefault();
      if(history_index > 0) {
        history_index--;
      } else if(history_index < 0 && history.length > 0) {
        history_index = history.length - 1
      } else {
        return;
      }

      write_input(history[history_index]);
    } else if(key === "Down" || key === "ArrowDown") {
      e.preventDefault();
      if(history_index >= 0) {
        history_index = history_index < history.length - 1 ? history_index + 1 : -1;
      } else {
        return;
      }

      write_input(history[history_index] || "");
    }
  };
};

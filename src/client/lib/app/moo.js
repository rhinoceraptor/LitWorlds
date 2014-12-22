// Generated by CoffeeScript 1.7.1
var app, autologin, font, fontsize, host_name, localecho, moo_name, port, set_height, sock_port, sock_server, socket, telnet_line_out;

$(function() {
  app.text = new text_handler();
  $(window).resize(function() {
    return set_height();
  });
  return set_height();
});

app = {};

sock_port = '8080';

set_height = function() {
  var frame_height;
  if (top.frames["java_frame"] != null) {
    frame_height = top.frames["java_frame"].innerHeight;
    return $("#text-backlog").css({
      "height": "" + (frame_height - 35) + "px"
    });
  }
};

telnet_line_out = (function(_this) {
  return function(line) {
    return socket.emit('io_line', line);
  };
})(this);

if (typeof params === "undefined" || params === null) {
  moo_name = "Moo.js";
  host_name = "127.0.0.1";
  port = "7777";
  font = "Courier New";
  fontsize = "12";
  localecho = "false";
} else {
  moo_name = params.MOOname;
  host_name = params.HostName;
  sock_server = params.SocketServer;
  autologin = params.autologin;
  port = params.port;
  font = params.font;
  fontsize = params.fontsize;
  localecho = params.localecho;
}

console.log('connecting to http://' + sock_server + ':' + sock_port);

socket = io.connect('http://' + sock_server + ":" + sock_port);

socket.on('connect', (function(_this) {
  return function() {
    console.log('connected to socket');
    console.log('initiate telnet connection to ' + host_name + ":" + port);
    return socket.emit('init', {
      server: host_name,
      port: port
    });
  };
})(this));

socket.on('disconnect', function() {
  return app.text.disconnect();
});

socket.on('err', function() {
  return app.text.error();
});

socket.on('tcp_line', (function(_this) {
  return function(telnet_data) {
    return app.text.insert(telnet_data);
  };
})(this));

if (autologin != null) {
  this.telnet_line_out(autologin + "\r\n");
}

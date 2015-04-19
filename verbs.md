
How to configure enCore for the JavaScript telnet client
--------------------------------------------------------

- Two verbs need to be changed for enCore to work with the new JavaScript client.
- If you have not already done so, start LambdaMOO and the NodeJS server
  - The restart.sh script is located at /usr/local/moo/bin, run it as the moo user:
  - Type: ```su moo```
  - Type: ```cd /usr/local/moo/bin```
  - Type: ```./restart.sh enCore```
- You will need to log in to the MOO using MOOtcan, using the default wizard account.
- If you have not already configured the MOO in the telnet, do that now:
  - Connect to telnet like this: ```telnet 127.0.0.1 7777```
  - Type: ```co wizard```
  - Type: ```@configure```
  - Select option 8: ```8```
  - Type in the IP or domain for your server
  - Select option 18: ```18```
  - Enter a path for enCore to be served by Apache: ```http://<IP or domain here>/encore```
  - Quit: ```Q```
  - Disconnect: ```@quit```
- Now you will be able to connect to Xpress by visiting ```http://<IP or domain here>:7000```
- Log in using the wizard account (The Java Applet will work fine using Iced Tea and Firefox under Linux)
- Install the verb to embed the JavaScript client in the normal Xpress interface:
  - Click the 'Program' button in the toolbar
  - Enter '#147' in the text box and press 'View'
  - In the 'Verbs on enCore Xpress...' frame, click the 'java_html' link
  - Remove the existing verb and paste the following:

```

"===========================================================";
"Copyright (C) 1999-2004, Jan Rune Holmevik and Sindre Soerensen";
"The original code and Javascript functions written by Sindre Soerensen.";
"Simplified and modified to allow more browsers to run Xpress.";
"Jan, January, 2003-2004";
"Modified to display parameters for new interface project.";
"KRJ Dec 14 2014";
"Modified further to display needed HTML and link to CSS and JS for new interface";
"John Lewis December 30 2014";
"===========================================================";
if (!caller_perms().wizard)
  return E_PERM;
endif
user = args[1];
base_url = tostr("http://", $network.site, "/");
style = 0;
"CSS for the JavaScript MOO client";
body = {tostr("<link rel=\"stylesheet\" href=\"", base_url, "encore/client/lib/css/lw.css\">")};
"JavaScript object containing parameters for the Javascript MOO telnet client";
body = {@body, tostr("<script type=\"text/javascript\"> ")};
body = {@body, tostr("var params = {")};
body = {@body, tostr("\"MOOname\": \"", $network.MOO_name, "\",")};
body = {@body, tostr("\"HostName\": \"", $network.site, "\",")};
body = {@body, tostr("\"port\": \"", $network.port, "\",")};
body = {@body, tostr("\"SocketServer\": \"", $network.site, "\",")};
body = {@body, tostr("\"autologin\": \"autoconnect ", user, " ", crypt(user.web_access_code), "\",")};
body = {@body, tostr("\"font\": \"", user.java_font, "\",")};
body = {@body, tostr("\"fontsize\": \"", user.java_font_size, "\",")};
body = {@body, tostr("\"localecho\": \"", user.java_client_localecho, "\"")};
body = {@body, tostr("}; </script>")};
"Text Areas used in the MOO telnet client";
body = {@body, tostr("<ul class=\"text-mode-ul\">")};
body = {@body, tostr("<li><textarea readonly rows=\"20\" class=\"text-mode\" id=\"text-backlog\" type=\"text\">    </textarea></li>")};
body = {@body, tostr("<li><textarea rows=\"3\" class=\"text-mode\" id=\"text-input\" type=\"text\"     placeholder=\"Enter text here\"></textarea></li>")};
body = {@body, tostr("</ul>")};
"Include JavaScript source files for the Telnet client";
body = {@body, tostr("<script src=\"", base_url, "encore/client/lib/js/jquery-2.1.1.min.js\" type=\"text/javascript\"></script>")};
body = {@body, tostr("<script src=\"", base_url, "encore/client/lib/js/socket.io-1.2.1.js\" type=\"text/javascript\"></script>")};
body = {@body, tostr("<script src=\"", base_url, "encore/client/lib/app/moo.js\" type=\"text/javascript\"></script>")};
body = {@body, tostr("<script src=\"", base_url, "encore/client/lib/app/text_handler.js\" type=\"text/javascript\"></script>")};
result = this:build(user, body, "MOOtcan", "", "", "", "", "", style);
return result;
"Last modified Sun Dec 28 17:50:18 2014 EST by Wizard (#2).";

```

- Install the verb to embed the JavaScript client in the normal Xpress interface:
  - Click the 'Program' button in the toolbar
  - Enter '#148' in the text box and press 'View'
  - In the 'Verbs on enCore Xpress...' frame, click the 'standalone_html' link
  - Remove the existing verb and paste the following:

```

"===========================================================";
"Copyright (C) 1999-2004, Jan Rune Holmevik";
"Run MOOtcan as a standalone application";
"Modified December 30 2014 to display new JavaScript telnet client standalone";
"===========================================================";
if (!caller_perms().wizard)
  return E_PERM;
endif
user = args[1];
base_url = tostr("http://", $network.site, "/");
style = 0;
"CSS for the JavaScript MOO client";
body = {tostr("<link rel=\"stylesheet\" href=\"", base_url, "encore/client/lib/css/lw.css\">")};
"JavaScript object containing parameters for the Javascript MOO telnet client";
body = {@body, tostr("<script type=\"text/javascript\"> ")};
body = {@body, tostr("var params = {")};
body = {@body, tostr("\"MOOname\": \"", $network.MOO_name, "\",")};
body = {@body, tostr("\"HostName\": \"", $network.site, "\",")};
body = {@body, tostr("\"port\": \"", $network.port, "\",")};
body = {@body, tostr("\"SocketServer\": \"", $network.site, "\",")};
body = {@body, tostr("\"font\": \"", user.java_font, "\",")};
body = {@body, tostr("\"fontsize\": \"", user.java_font_size, "\",")};
body = {@body, tostr("\"localecho\": \"", user.java_client_localecho, "\"")};
body = {@body, tostr("} </script>")};
"Text Areas used in the MOO telnet client";
body = {@body, tostr("<ul class=\"text-mode-ul\">")};
body = {@body, tostr("<li><textarea readonly rows=\"20\" class=\"text-mode\" id=\"text-backlog\" type=\"text\">    </textarea></li>")};
body = {@body, tostr("<li><textarea rows=\"3\" class=\"text-mode\" id=\"text-input\" type=\"text\"     placeholder=\"Enter text here\"></textarea></li>")};
body = {@body, tostr("</ul>")};
"Include JavaScript source files for the Telnet client";
body = {@body, tostr("<script src=\"", base_url, "encore/client/lib/js/jquery-2.1.1.min.js\" type=\"text/javascript\"></script>")};
body = {@body, tostr("<script src=\"", base_url, "encore/client/lib/js/socket.io-1.2.1.js\" type=\"text/javascript\"></script>")};
body = {@body, tostr("<script src=\"", base_url, "encore/client/lib/app/moo.js\" type=\"text/javascript\"></script>")};
body = {@body, tostr("<script src=\"", base_url, "encore/client/lib/app/text_handler.js\" type=\"text/javascript\"></script>")};
result = this:build(user, body, "MOOtcan", "", "", "", "", "", style);
return result;
"Last modified Sun Dec 28 03:51:11 2014 EST by Wizard (#2).";

```

You now should have a functioning enCore Xpress server that will work on modern browsers, and mobile devices.

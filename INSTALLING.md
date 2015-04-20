Installing enCore/LambdaMOO with JavaScript telnet on Ubuntu 14.04
------------------------------------------------------------------

### Conventions
I will use
```
$ command
```
to denote commands that are to be run as a normal user, and
```
# command
```
to denote commands that are to be run as root.

### Installing software packages

The first step is to update all software on the system, by running:

```
# apt-get update && apt-get upgrade
```

Next, install the requisite software:

```
# apt-get install sudo apache2 gcc make bison vim csh nodejs nodejs-legacy npm git ncompress
```

### Installing LambdaMOO and enCore

Create a user to run the MOO software as:

```
useradd -g sudo -s /bin/bash -p users -d /home/moo -m moo
```

Next, set the password for the moo user:
```
passwd moo
```

Now, switch to the moo user:
```
su moo
```

We will be installing LamdbaMOO and enCore to the directory

```
/usr/local/moo
```

So we need to create some directories:

```
$ sudo mkdir /usr/local/moo
$ sudo mkdir /usr/local/moo/bin
$ sudo chown -R moo /usr/local/moo
```

Next, we need to get the source for LambdaMOO and compile it:

```
$ cd && git clone https://github.com/rhinoceraptor/LambdaMOO-enCorev4.git
$ cd LambdaMOO-enCorev4/lambdamoo
$ sh configure
$ make
```

Next, move the executable for LambdaMOO, and the enCore database into the directory where it will be run:
```
$ cp moo restart.sh /usr/local/moo/bin
$ cd ..
$ cp encore/enCore.db /usr/local/moo/
```

Install an alias for enCore assets in Apache:
```
# echo -e "Alias /encore \"/usr/local/moo/encore\"\n<Directory /usr/local/moo/encore>\n\tRequire all granted\n</Directory>\n" >> /etc/apache2/apache2.conf
# service apache2 restart
```

### Running the enCore server

Now you have a fully functionin (Java based) enCore server. To run it do:

```
$ cd /usr/local/moo/bin
$ ./restart.sh enCore
```

You will now want to change some settings in the enCore configuration. To do this, telnet to the server:

```
$ telnet 127.0.0.1 7777
```

You will see the enCore welcome message. Log in as wizard:

```
co wizard
```

Enter the configuration menu:

```
@configure
```

You will want to put a password on the wizard account, under option 3.

Next, change the domain name of the enCore server, under option 8. Set it to the server's IP address or domain name.

Finally, set the base URL for enCore's assets, under option 18. Set it to
```
http://<your server IP or domain name>/encore/
```

### Installing the JavaScript Telnet client

Install some tools for Node.js:
```
# npm install -g coffee-script forever
```

First, clone the git repository for the telnet client:

```
$ cd && git clone https://github.com/rhinoceraptor/LitWorlds.git
$ cd LitWorlds && git checkout telnet_only
```

Next, install the dependancies for the server:
```
$ cd src/server
$ npm install
```

Build the server into executable JavaScript:
```
$ cake build
```

We can now run the server. Copy it to the MOO base directory for convenience:
```
$ cd ..
$ cp -r server /usr/local/moo/
```

Next, go to the client directory, and build the code:
```
$ cd client
$ cake build
```

Copy the client to the MOO base directory:
```
$ cd ..
$ cp -r client /usr/local/moo/encore/
```

Now, for convenience in running the server, we will add a line to the restart.sh script for LambdaMOO to start the Node.js server.

Starting after the line 42, which reads
```
nohup ./moo $1.db $1.db.new $2 >> $1.log 2>&1 &
```

Add the following:
```
forever stopall
forever start /usr/local/moo/client/dist/server.js
```

The only thing left to do it modify two verbs in enCore to replace the Java applet with the new client.

Log in to enCore web as the wizard, with a Java applet-enabled browser. Firefox with Iced Tea plugin works under Linux.

Click the "Program" button in the toolbar. Enter "#147" in the textbox, and click "View".

In the 'Verbs on enCore Xpress...' frame, click the 'java_html' link.

Remove the existing verb, and paste the following:

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
    body = {@body, tostr("<script src=\"", base_url, "encore/client/dist/lib/jquery-2.1.1.min.js\" type=\"text/javascript\"></script>")};
    body = {@body, tostr("<script src=\"", base_url, "encore/client/dist/lib/socket.io-1.2.1.js\" type=\"text/javascript\"></script>")};
    body = {@body, tostr("<script src=\"", base_url, "encore/client/dist/moo.js\" type=\"text/javascript\"></script>")};
    body = {@body, tostr("<script src=\"", base_url, "encore/client/dist/text_handler.js\" type=\"text/javascript\"></script>")};
    result = this:build(user, body, "MOOtcan", "", "", "", "", "", style);
    return result;
    "Last modified Sun Dec 28 17:50:18 2014 EST by Wizard (#2).";

```

Then, click "Compile Verb".

Next, enter '#148' in the search textbox, and click 'View'.

In the 'Verbs on enCore Xpress...' frame, click the 'standalone_html' link

Remove the existing verb, and paste the following:

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
    body = {@body, tostr("<script src=\"", base_url, "encore/client/dist/lib/jquery-2.1.1.min.js\" type=\"text/javascript\"></script>")};
    body = {@body, tostr("<script src=\"", base_url, "encore/client/dist/lib/socket.io-1.2.1.js\" type=\"text/javascript\"></script>")};
    body = {@body, tostr("<script src=\"", base_url, "encore/client/dist/moo.js\" type=\"text/javascript\"></script>")};
    body = {@body, tostr("<script src=\"", base_url, "encore/client/dist/text_handler.js\" type=\"text/javascript\"></script>")};
    result = this:build(user, body, "MOOtcan", "", "", "", "", "", style);
    return result;
    "Last modified Sun Dec 28 03:51:11 2014 EST by Wizard (#2).";
```

You now should have a functioning enCore Xpress server that will work on modern browsers, and mobile devices.


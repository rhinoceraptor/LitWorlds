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
# apt-get install sudo apache2 gcc make bison vim csh nodejs nodejs-legacy git
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
# echo -e "Alias /encore \"/usr/local/moo/encore\"\n<Directory /usr/local/moo/encore>\n\tRequire all granted\n</Directory>\n" >> ${APACHEDIR}/apache2.conf
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


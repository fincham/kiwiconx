#!/bin/bash

deploy_key=0x314983B53C8932BFD36335B7FEA3F6BF69FE8D5D
deploy_host=https://st01.fincham.kiwicon.org/bff69625c22aa7c127e23931f158142a
cn="$(hostname -f)"

download_and_verify() {
    echo "Downloading $1..."
    intermediate="$(mktemp)"
    wget -O "${intermediate}" ${deploy_host}/$1 >/dev/null 2>&1
    wget -O "${intermediate}.asc" ${deploy_host}/$1.asc >/dev/null 2>&1;
    echo "Verifying $1..."
    if gpg --verify "${intermediate}.asc" "${intermediate}" >/dev/null 2>&1; then
        mv "${intermediate}" "$2"
        rm "${intermediate}.asc"
    else
        echo "fail: A file failed to validate, specifically \`$1'. The failed file is in \`$intermediate'."
        exit 1
    fi
}

echo "*** Checking some pre-requisites..."

apt-get install -y bind9-host >/dev/null 2>&1

if [[ $(whoami) != "root" ]]; then
    echo "fail: This script has to be run as root on a freshly installed VM!"
    exit 1
fi

if ! egrep '^8\.' /etc/debian_version >/dev/null 2>&1; then
    echo "fail: You have to be using Debian Jessie."
    exit 1
fi

if ! host $cn 8.8.8.8 >/dev/null 2>&1; then
    echo "fail: The output of \`hostname -f' needs to be resolvable on the Internet so a TLS cert can be issued."
    exit 1
fi

echo "*** Fetching cryptographic handwaves..."

if ! gpg --keyserver pgp.net.nz --recv-keys $deploy_key; then
    echo "fail: Couldn't get the PGP key everything is signed with."
    exit 1
fi

echo "*** Installing packages..."

apt-get install -y at apache2 qemu-system-x86 qemu-utils qemu-system-common qemu-kvm bridge-utils screen >/dev/null 2>&1
apt-get install -y -t jessie-backports ansible

echo "*** Getting static content..."

mkdir -p /opt/kiwicon/zoo
download_and_verify static.tar.gz /opt/kiwicon/zoo/static.tar.gz
cd /opt/kiwicon/zoo
tar -z -x --strip-components=2 -f static.tar.gz
rm /opt/kiwicon/zoo/static.tar.gz

echo "*** Running ansible to set up environment..."

cd hotplate-playbooks
./run.sh
cd ..

mv /opt/kiwicon/zoo/apparmor/profile /etc/apparmor.d/usr.bin.qemu-system-i386

if grep "apparmor" /proc/cmdline >/dev/null 2>&1; then
    echo "Apparmor is installed already! Proceeding..."
else
    echo ""
    echo "********* IMPORTANT *********"
    echo ""
    echo "Apparmor has been installed but not configured. You must reboot this machine and re-run the script to continue."
    exit 1
fi

echo "*** Configuring apache and static content..."

cat >/etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>
    ServerName ${cn}

    ServerAdmin kiwicon@kiwicon.org
    DocumentRoot /var/www/html

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

    RewriteEngine on
    RewriteCond %{SERVER_NAME} =${cn}
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,QSA,R=permanent]
</VirtualHost>
EOF

service apache2 restart
apt-get install -y python-certbot-apache -t jessie-backports
if [[ ! -f /etc/apache2/sites-enabled/000-default-le-ssl.conf ]]; then
    certbot --apache
fi

a2enmod proxy_wstunnel

cat >/etc/apache2/sites-enabled/000-default-le-ssl.conf <<EOF
<VirtualHost *:443>
    ServerName ${cn}

    ServerAdmin kiwicon@kiwicon.org
    DocumentRoot /opt/kiwicon/zoo/static

    SSLCertificateFile /etc/letsencrypt/live/${cn}/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/${cn}/privkey.pem
    Include /etc/letsencrypt/options-ssl-apache.conf

    <Directory /opt/kiwicon/zoo/static>
        AllowOverride None
        Require all granted
    </Directory>

    CustomLog \${APACHE_LOG_DIR}/zoo-access.log combined
    ErrorLog \${APACHE_LOG_DIR}/zoo-error.log

    ProxyPass /9392ebbf6a88d548566ec1e199a07a17/tty "ws://10.0.0.2:5000/tty"
    ProxyPass /9392ebbf6a88d548566ec1e199a07a17 !
</VirtualHost>
EOF
service apache2 restart

echo "*** Building VM environment..."

apt-get install -y supervisor >/dev/null 2>&1
service supervisor stop

cat >/etc/supervisor/conf.d/injector.conf <<EOF
[program:injector]
command=/opt/kiwicon/zoo/vm/start-injector.sh
directory=/opt/kiwicon/zoo/vm
user=root
group=root
autostart=true
autorestart=true
redirect_stderr=true
stopasgroup=true
killasgroup=true
EOF

cat >/etc/supervisor/conf.d/airgap.conf <<EOF
[program:airgap]
command=/opt/kiwicon/zoo/vm/start-airgap.sh
directory=/opt/kiwicon/zoo/vm
user=root
group=root
autostart=true
autorestart=true
redirect_stderr=true
stopasgroup=true
killasgroup=true
EOF

cat >/etc/supervisor/conf.d/storesecure.conf <<EOF
[program:storesecure]
command=/opt/kiwicon/zoo/vm/start-storesecure.sh
directory=/opt/kiwicon/zoo/vm
user=root
group=root
autostart=true
autorestart=true
redirect_stderr=true
stopasgroup=true
killasgroup=true
EOF

cat >/etc/supervisor/conf.d/commsecure.conf <<EOF
[program:commsecure]
command=/opt/kiwicon/zoo/vm/start-commsecure.sh
directory=/opt/kiwicon/zoo/vm
user=root
group=root
autostart=true
autorestart=true
redirect_stderr=true
stopasgroup=true
killasgroup=true
EOF

cat >/etc/rc.local <<EOF
#!/bin/sh

aa-enforce /usr/bin/qemu-system-i386
mkdir -p /run/watchdog
/opt/kiwicon/zoo/vm/start-bridges.sh
echo 1 > /proc/sys/net/ipv4/ip_forward
EOF

chmod +x /etc/rc.local
/etc/rc.local

echo "*** Downloading fresh VM images..."

download_and_verify injector.img /opt/kiwicon/zoo/vm/injector.img

download_and_verify airgap.img /opt/kiwicon/zoo/vm/airgap.img
download_and_verify storesecure.img /opt/kiwicon/zoo/vm/storesecure.img
download_and_verify commsecure.img /opt/kiwicon/zoo/vm/commsecure.img

service supervisor start

echo "*** Alright, good frikkin' luck"

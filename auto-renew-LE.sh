#!/bin/bash

set -e

renew() {
    SERVICE=$1
    echo $SERVICE
    echo "Renouvellement du service $SERVICE sur $MACHINE..."    
    cd /srv/letsencrypt
    python acme_tiny.py --account-key "./private/domaine.$MACHINE.key" --csr "./csr/$SERVICE.csr" --acme-dir "/srv/letsencrypt/challenges/$SERVICE/" > "./certs/$SERVICE.crt.new"
    cat  "./certs/$SERVICE.crt.new" ./pem/intermediate-x3.pem > "./pem/$SERVICE.pem"
    /etc/init.d/apache2 reload
    echo "Testez le service. Le résultat est-il OK ? [Y/N]"
    read OK
    if [ "$OK" = y -o "$OK" = Y ]; then
        mv -f ./certs/$SERVICE.crt{.new,}
        service apache2 reload
    else
        echo "Annulation du renouvellement. L'ancien certificat est encore disponible pour intervention et ne sera donc pas écrasé. Se référer à un admin."
    fi
}

MACHINE=$(hostname)

if [ "$(id -u)" != "0" ]; then
    echo "Le renouvellement des certificats nécessite d'être sudo."
    exit 1
else
    case "$MACHINE" in
     nomhost1)
         renew service1.domaine.tld
         renew service2.domaine.tld
         renew service3.domaine.tld
         ;;
     nomhost2)
         renew service1.domaine.tld
         renew service2.domaine.tld
         renew service3.domaine.tld
         ;;
     nomhost3)
         renew service1.domaine.tld
         renew service2.domaine.tld
         renew service3.domaine.tld
         ;;
     nomhost4)
         renew service1.domaine.tld
         renew service2.domaine.tld
         renew service3.domaine.tld
         ;;
     *)
         echo "Erreur dans le nom de machine : $MACHINE ne semble pas utiliser de certificat LE."
         ;;
    esac
fi

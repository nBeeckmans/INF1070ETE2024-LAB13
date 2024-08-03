# INF1070ETE2024-LAB13

# 1. Adresses IP 

- `ip address` pour chercher l'adresse privee 

```sh 
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute
       valid_lft forever preferred_lft forever
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether ff:ff:ff:ff:ff:ff brd ff:ff:ff:ff:ff:ff
    inet 127.0.0.22/24 brd 127.0.0.255 scope global dynamic noprefixroute enp5s0
       valid_lft 171785sec preferred_lft 171785sec
    inet6 ffff::ffff:ffff:ffff:ffff/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: enp6s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN group default qlen 1000
    link/ether ff:ff:ff:ff:ff:ff brd ff:ff:ff:ff:ff:ff
4: wlp4s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether ff:ff:ff:ff:ff:ff brd ff:ff:ff:ff:ff:ff
    inet 127.0.0.140/24 brd 127.0.0.255 scope global dynamic noprefixroute wlp4s0
       valid_lft 171785sec preferred_lft 171785sec
    inet6 ffff::ffff:ffff:ffff:ffff/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

Pour moi, j'ai à la fois du wifi ET un réseau cablé... Mon réseau cablé est enp5s0 avec comme adresse privée: 
127.0.0.22/24. (Noter que j'ai modifié mon adresse IP et MAC manuellement dans cet extrait :D).

`dig +short myip.opendns.com @resolver1.opendns.com` 

`dig` : command de resolution DNS.
`+short` : message court (autrement juste notre adresse).
`myip.opendns.com` : ce qu'on recherche (notre adresse publique).
`@resolver1.opendns.com` : le serveur DNS auquel on fait la demande.

Donne une adresse publique. 

# 2. sockets

## 2.1 Netcat :
Suivre les instructions du labos.

`-k` : laisse la connection au port ouverte.

## 2.2 Communication reseau : 
Suivre les instructions du labos. 

Sinon suivre l'annexe :). 

# 3. Ping : 
Avec `ping adresse`, cherchez votre adresse loopback et faites `ping sur_cette_adresse`. (Notez que `ping localhost`
devrait donner le même résultat.

Pour tester avec docker : voir l'annexe.

`ping -c 2 -b 10.0.0.255` : 10.0.0.255 est trouver avec ip address. Ex : `brd 127.0.0.255` indique que l'adresse de
broadcast est 127.0.0.255. ! 

`ping www.etudier.uqam.ca` : on peut utiliser des adresses normales (web) pour ping !

# 4. ARP : 

ARP est utilisée pour connaitre l'adresse MAC a partir d'une adresse IP ! (Vous verrez ça en INF3271.)

Exemple de `arp`:
```
Address                  HWtype  HWaddress           Flags Mask            Iface
10.0.0.10                        (incomplete)                              enp5s0
_gateway                 ether   ff:ff:ff:ff:ff:ff   C                     wlp4s0
10.0.0.35                ether   a4:31:35:8e:91:70   C                     enp5s0
172.18.0.2               ether   02:42:ac:12:00:02   C                     br-b667e9c77ab1
_gateway                 ether   ff:ff:ff:ff:ff:ff   C                     enp5s0
```

Après `sudo arp -d 172.18.0.3` : 

```
Address                  HWtype  HWaddress           Flags Mask            Iface
10.0.0.10                        (incomplete)                              enp5s0
_gateway                 ether   ff:ff:ff:ff:ff:ff   C                     wlp4s0
10.0.0.35                ether   a4:31:35:8e:91:70   C                     enp5s0
172.18.0.2               ether   02:42:ac:12:00:02   C                     br-b667e9c77ab1
_gateway                 ether   ff:ff:ff:ff:ff:ff   C                     wlp4s0
```

Après `ping 172.18.0.3` : 

```sh 
Address                  HWtype  HWaddress           Flags Mask            Iface
10.0.0.10                        (incomplete)                              enp5s0
172.18.0.3               ether   02:42:ac:12:00:03   C                     br-b667e9c77ab1
_gateway                 ether   ff:ff:ff:ff:ff:ff   C                     wlp4s0
10.0.0.35                ether   a4:31:35:8e:91:70   C                     enp5s0
172.18.0.2               ether   02:42:ac:12:00:02   C                     br-b667e9c77ab1
_gateway                 ether   ff:ff:ff:ff:ff:ff   C                     wlp4s0
```
 
# 5. Téléchargements 

## 5.1 

suivre le labo 

## 5.2 

voir le script `cours`. 

# Annexe 

Si comme moi vous n'avez pas d'amis utilisons docker pour tester les communications !

`sudo docker network create nom_du_network` pour creer un network.
`docker run -it --net nom_du_network ubuntu /bin/bash` pour lancer les deux docker (lancer la commande dans 2
terminaux differents)

Dans les deux dockers, installez netcat : 
`apt update -y && apt install netcat -y`

Avec docker ps, noter les ID des dockers. (Ici, nous utiliserons les IDs des dockers à la place des adresses IP. Cependant, vous pouvez installer les utilitaires nécessaire pour utiliser `ip address` et utiliser les adresses privées à la place.)
Dans un des docker : 
`nc -l 3333` 

Dans l'autre : 
`echo message | nc ID_PREMIER_DOCKER 3333` 

Dans cette simulation, nous remplaçons l'adresse ip avec l'ID du docker.

Pour ping : 

`apt install -y iputils-ping` et `ping ID_PREMIER_DOCKER`.

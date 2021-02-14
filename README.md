# CNCF Harbor を vagrant で起動するコード


## Vagrant 起動方法

~~~
$ vagrant up
~~~

パソコンのブラウザからアクセスするには、/etc/hosts に以下のエントリーを追加しておく。

~~~
192.168.1.71    harbor.labs.local
~~~

IPアドレスが衝突している場合は、Vagrantfileの以下のIPアドレスを変更する。

~~~
 private_ip: "172.16.20.3",
 public_ip: "192.168.1.71",
~~~


## QEMU/KVMでの起動方法

仮想マシンの起動とHarborのセットアップを次のコマンドで実行する。
起動後に、https://harbor.labo.local をブラウザからアクセスして利用を開始できる。

~~~
vm-create -f Qemukvm.yaml
~~~

仮想マシンを含めて停止する方法

~~~
vm-destroy -f Qemukvm.yaml
~~~


※ バックアップ方法があると良いね。



## Harbor の証明書の取得

`fetch-certs`を実行することで、certs 以下に取得できる。

~~~
tkr@hmc:~/marmot-harbor$ ./fetch-certs
ca.crt                                                    100% 2049     1.2MB/s   00:00    
ca.key                                                    100% 3247     1.8MB/s   00:00    
harbor.labo.local.crt                                     100% 2102     1.5MB/s   00:00    
harbor.labo.local.key                                     100% 3243     1.7MB/s   00:00    
DONE
~~~


## macOSでの証明書の登録

上記で取得したファイルca.crtをMacへ転送しておき、次のコマンドでキーチェーンへ登録する。

~~~
security add-trusted-cert -d -r trustRoot -k ~/Library/Keychains/login.keychain ./ca.crt 
~~~

MacのDocker Desktop を再起動して、証明書を読み込ませる。



## docker login

Macのターミナルから、Harborへログインする。

~~~
maho:~ maho$ docker login -u tkr harbor.labo.local
Password: 
~~~

もしも、HarborのIPアドレスを変更した場合は、次のコマンドで、macOSのDNSキャッシュをクリアする。

~~~
sudo killall -HUP mDNSResponder
~~~







参考資料
https://qiita.com/MahoTakara/items/d34877eb7e891a0d7dae
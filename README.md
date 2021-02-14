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

## Harborの初期設定

https://harbor.labo.local
ユーザーID: admin
パスワード: Harbor12345

設定の場所
marmot-harbor/playbook/templates/harbor.yml.j2


## Harborへユーザーの追加

筆者のユーザーID tkr を例にとって記述する。

Administration -> Users -> [+ NEW USER] で画面に従ってユーザーtkrを登録
Projects -> [+ NEW PROJECT]  プロジェクト tkr を画面に従って登録
Projects -> Project Name tkr -> タブ Memberes -> [+ USER] をクリックしてユーザーtkrをプロジェクトtkrへ追加



## Harbor の証明書の取得

`fetch-certs`を実行することで、certs 以下に取得できる。

~~~
tkr@hmc:~/marmot-harbor$ sudo ./fetch-certs
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


~~~
maho:~ maho$ docker pull nginx:latest
latest: Pulling from library/nginx
45b42c59be33: Pull complete 
d0d9e9ea897e: Pull complete 
66e650438339: Pull complete 
76a3dfe4406b: Pull complete 
410ff9d97480: Pull complete 
Digest: sha256:8e10956422503824ebb599f37c26a90fe70541942687f70bbdb744530fc9eba4
Status: Downloaded newer image for nginx:latest
docker.io/library/nginx:latest
~~~

~~~
maho:certs maho$ docker login -u tkr harbor.labo.local
Password: 
Login Succeeded
~~~

タグを付与してHarborレジストリへプッシュする

~~~
maho:certs maho$ docker tag nginx:latest harbor.labo.local/tkr/nginx:latest
maho:certs maho$ docker push harbor.labo.local/tkr/nginx:latest
The push refers to repository [harbor.labo.local/tkr/nginx]
d9eb91d66e2a: Pushed 
ae1f545e4c08: Pushed 
c20672db3628: Pushed 
4cbb728cd302: Pushed 
9eb82f04c782: Pushed 
latest: digest: sha256:1a53eb723d17523512bd25c27299046cfa034cce309f4ed330c943a304513f59 size: 1362
~~~

プッシュの結果確認

~~~
maho:~ maho$ docker images
REPOSITORY                    TAG                IMAGE ID       CREATED         SIZE
nginx                         latest             298ec0e28760   5 days ago      133MB
harbor.labo.local/tkr/nginx   latest             298ec0e28760   5 days ago      133MB
~~~

プルのテストのために、ローカルのイメージを削除する。

~~~
maho:~ maho$ docker rmi -f 298ec0e28760
~~~

プルの実行

~~~
maho:~ maho$ docker pull harbor.labo.local/tkr/nginx:latest
latest: Pulling from tkr/nginx
45b42c59be33: Pull complete 
d0d9e9ea897e: Pull complete 
66e650438339: Pull complete 
76a3dfe4406b: Pull complete 
410ff9d97480: Pull complete 
Digest: sha256:1a53eb723d17523512bd25c27299046cfa034cce309f4ed330c943a304513f59
Status: Downloaded newer image for harbor.labo.local/tkr/nginx:latest
harbor.labo.local/tkr/nginx:latest
~~~

プルできたことを確認する

~~~
maho:~ maho$ docker images
REPOSITORY                    TAG                IMAGE ID       CREATED         SIZE
harbor.labo.local/tkr/nginx   latest             298ec0e28760   5 days ago      133MB
~~~



参考資料
https://qiita.com/MahoTakara/items/d34877eb7e891a0d7dae
# CNCF Harbor を vagrant で起動するコード


起動方法

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



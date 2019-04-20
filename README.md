# JamyCOnacts

----
# 如何将ipa转成deb包
## 1.在当前目录下, 新建目录 package
 ```sh
	mkdir package
	mkdir package/Applications
	mkdir package/DEBIAN
 ```
 ## 2.control文件
 在package/DEBIAN下新建文件control, 内容格式示例如下
```sh
Package: com.jamy.conacts
Version: 1.3
Architecture: iphoneos-arm
Maintainer: BigBoss <bigboss@thebigboss.org>
Author: Conrad Kramer <support@kramerapps.com>
Installed-Size: 22
Section: System
Description: launch apps from the command-line
Name: JamyConacts
Depiction: http://moreinfo.thebigboss.org/moreinfo/depiction.php?file=openData
Website: http://moreinfo.thebigboss.org/moreinfo/depiction.php?file=openData
Sponsor: thebigboss.org <http://thebigboss.org>
dev: conradkramer
```
## 3.编译生成jamyConacts.app包
      用xcode编译成功之后, 生成jamyConacts.app
	  复制jamyConacts.app到package/Applications/下
```sh
		cp jamyConacts.app package/Applications/
```
	  
## 4. 打包
   
 ```sh
  #删除所有得.DS_Store文件.
 find -name ".DS_Store" -depth -exec rm -rf {} \;
 #生成deb
 dpkg-db -b package xxx.deb
 ```
# File Manager

LongOS的文件管理器，使用简单，美观，并保留了经典的PC交互设计。

### Ubuntu依赖包

```
sudo apt install equivs curl git devscripts lintian build-essential automake autotools-dev --no-install-recommends

sudo mk-build-deps -i -t "apt-get --yes" -r
```

### Debian依赖包

```
sudo apt install build-essential cmake extra-cmake-modules libkf5kio-dev libkf5solid-dev libkf5windowsystem-dev libkf5config-dev qtbase5-dev qtbase5-private-dev qtdeclarative5-dev qtquickcontrols2-5-dev qttools5-dev qttools5-dev-tools
```

### ArchLinux依赖包

```shell
sudo pacman -S extra-cmake-modules qt5-base qt5-quickcontrols2 taglib kio
```

## 构建

```shell
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ..
make
```

## 安装

```shell
sudo make install
```

## License

This project has been licensed by GPLv3.

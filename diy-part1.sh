#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

delete_bootstrap=true       # 是否删除默认主题 true 、false
default_theme='argon_mc1'   # 默认主题 结合主题文件夹名字 
theme_argon='https://github.com/sypopo/luci-theme-argon-mc.git'  # 主题地址
openClash_url='https://github.com/vernesong/OpenClash.git'       # OpenClash包地址 
adguardhome_url='https://github.com/rufengsuixing/luci-app-adguardhome.git' # adguardhome 包地址
lienol_url='https://github.com/Lienol/openwrt-package.git'       # Lienol 包地址
vssr_url_rely='https://github.com/jerrykuku/lua-maxminddb.git'   # vssr lua-maxminddb依赖
vssr_url='https://github.com/jerrykuku/luci-app-vssr.git'        # vssr地址


echo "修改默认主题"
sed -i "s/bootstrap/$default_theme/g" feeds/luci/modules/luci-base/root/etc/config/luci


if [ $delete_bootstrap ] ;then
  echo "去除默认bootstrap主题"
  sed -i '/\+luci-theme-bootstrap/d' feeds/luci/collections/luci/Makefile
  sed -i '/\+luci-theme-bootstrap/d' package/feeds/luci/luci/Makefile
  sed -i '/CONFIG_PACKAGE_luci-theme-bootstrap=y/d' .config
  sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
fi

echo '添加主题argon'
git clone $theme_argon package/lean/luci-theme-argon-mc
echo 'CONFIG_PACKAGE_luci-theme-argon-mc=y' >> .config

echo '添加OpenClash'
git clone $openClash_url package/lean/luci-app-openclash 

#  OpenClash
echo 'CONFIG_PACKAGE_luci-app-openclash=y' >> .config
echo 'CONFIG_PACKAGE_luci-i18n-openclash-zh-cn=y'  >> .config

echo '添加Lienol包'
git clone $lienol_url package

echo '添加Passwall'
echo 'CONFIG_PACKAGE_luci-app-passwall=y' >> .config
echo 'CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks=y' >> .config
echo 'CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan=y' >> .config
echo 'CONFIG_PACKAGE_luci-app-passwall_INCLUDE_simple-obfs=y' >> .config
echo 'CONFIG_PACKAGE_luci-app-passwall_INCLUDE_v2ray-plugin=y' >> .config
echo 'CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Brook=y' >> .config
echo 'CONFIG_PACKAGE_luci-app-passwall_INCLUDE_kcptun=y' >> .config
echo 'CONFIG_PACKAGE_luci-i18n-passwall-zh-cn=y'  >> .config

echo '添加filebrowser'
echo 'CONFIG_PACKAGE_luci-app-filebrowser=y' >> .config
echo 'CONFIG_PACKAGE_luci-i18n-filebrowser-zh-cn=y'  >> .config

# echo '添加adguardhome'
# git clone $adguardhome_url package/lean/luci-app-adguardhome
# echo 'CONFIG_PACKAGE_luci-app-adguardhome=y' >> .config
# echo 'CONFIG_PACKAGE_luci-i18n-adguardhome-zh-cn=y'  >> .config

echo '添加HelloWord,并使用包默认的配置'  # TODO 这个的配置文件和SSP 冲突
git clone $vssr_url_rely package/lean/lua-maxminddb
git clone $vssr_url package/lean/luci-app-vssr
echo 'CONFIG_PACKAGE_luci-app-vssr=y' >> .config
echo 'CONFIG_PACKAGE_luci-i18n-vssr-zh-cn=y'  >> .config
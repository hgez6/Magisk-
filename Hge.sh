
AUTOMOUNT=true
PROPFILE=true
POSTFSDATA=false
LATESTARTSERVICE=false



print_modname() {
ui_print "   "
}


REPLACE="
"
 
REPLACE="
"

##########################################################################################
#酷安@增粗脚本结构设计
##########################################################################################

set_permissions() {

  set_perm_recursive  $MODPATH  0  0  0755  0644
}
KEYCHECK=$INSTALLER/common/keycheck
zip=$INSTALLER/common/zip
chmod 755 $KEYCHECK
chmod 755 $zip

keytest() {
ui_print "- 音量键测试 -"
ui_print "   请按下 [音量+] 键："
ui_print "   无反应或传统模式无法正确安装时，请触摸一下屏幕后继续"
(/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events) || return 1
return 0
}

chooseport() {
#note from chainfire @xda-developers: getevent behaves weird when piped, and busybox grep likes that even less than toolbox/toybox grep
while (true); do
	/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events
	if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
		break
	fi
done
if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
	return 0
else
	return 1
fi
}

chooseportold() {
# Calling it first time detects previous input. Calling it second time will do what we want
$KEYCHECK
$KEYCHECK
SEL=$?
if [ "$1" == "UP" ]; then
	UP=$SEL
elif [ "$1" == "DOWN" ]; then
	DOWN=$SEL
elif [ $SEL -eq $UP ]; then
	return 0
elif [ $SEL -eq $DOWN ]; then
	return 1
else
	abort "   未检测到音量键!"
fi
}


verformat() {
vertmp=$(printf %02d `echo ${1#V} | cut -f 1 -d . `)$(printf %02d `echo $1 | cut -f 2 -d . `)$(printf %02d `echo $1 | cut -f 3 -d . `)$(printf %02d `echo $1 | cut -f 4 -d . ` 2>/dev/null)
echo "$vertmp"
}
getfilever() {
[ `verformat $miuiver` -ge `verformat $1` ] && [ `verformat $miuiver` -le `verformat $2` ] && return 0 || return 1
}

# 检查MIUI版本支持
checkdevice() {
local requireddevice="Redmi Note 5"
local nowdevice="`grep_prop ro.product.model`"
if [ "$requireddevice" != "$nowdevice" ]; then
	ui_print "   本模块尚未支持您的手机型号,自动为您启动兼容模式"
	ui_print "   您的手机型号: $nowdevice"
	ui_print "   支持的手机型号: $requireddevice"
	ui_print "   [音量+]：安装MIUI通用模块"
  ui_print "   [音量-]：不安装"
	ui_print "*******************************"
	notmod="0"
	if $FUNCTION; then
	ui_print "   本模块已支持自主救砖"
   ui_print "   [音量+]:正常安装"
  ui_print "   [音量-]：我要救砖"
  	if $FUNCTION; then
	   echo -n "  兼容模式    " >>$INSTALLER/module.prop
  cd $INSTALLER/common/qita
    source ./jian.sh
    else
  v="1"
    fi
    else
    ui_print " 已退出"
    exit
    fi
      if [ "$v" == "1" ]; then
       ui_print " 自动为你开启多项同步模式（安装一个后自动退出）"
  ui_print "音量+安装"
    ui_print "音量-下一个"
       		ui_print "   卸载本模块并清理缓存"
          ui_print "   仅清理缓存"
          ui_print "   仅卸载模块"
          ui_print "   退出"
          ui_print "   已选择卸载本模块并清理缓存"
  if $FUNCTION; then
  rm -rf $MOUNTPATH/MoretoONE
      rm -f /data/system/package_cache/1/SecurityCenter-*
    rm -f /data/system/package_cache/1/SecurityCenter.apk-*   
     rm -f /data/system/package_cache/1/MiuiFreeformService-*       
     rm -rf /data/user/0/com.miui.securitycenter
     rm -rf /data/user/0/com.miui.freeform
     rm -f /data/system/package_cache/1/MiuiHome.apk-*   
     rm -f /data/system/package_cache/1/MiuiHome-*       
     rm -rf /data/user/0/com.miui.home
  	ui_print "   卸载模块成功"
  exit
  else
 ui_print "   已选择仅清理缓存"
    if $FUNCTION; then
   rm -f /data/system/package_cache/1/SecurityCenter-*
    rm -f /data/system/package_cache/1/SecurityCenter.apk-*   
     rm -f /data/system/package_cache/1/MiuiFreeformService-*       
     rm -rf /data/user/0/com.miui.securitycenter
     rm -rf /data/user/0/com.miui.freeform
     rm -f /data/system/package_cache/1/MiuiHome.apk-*   
     rm -f /data/system/package_cache/1/MiuiHome-*       
     rm -rf /data/user/0/com.miui.home
  ui_print " 缓存清理成功"
  exit
  else
  ui_print "   已选择仅卸载模块"
  if $FUNCTION; then
    rm -rf $MOUNTPATH/MoretoONE
    exit
    else
         ui_print " 已退出"
    exit
  fi
  fi
  fi
  fi
else
  ui_print "   检测到已支持您的机型"
   ui_print "   本模块已支持自主救砖"
   ui_print "   [音量+]:正常安装"
  ui_print "   [音量-]：我要救砖"
 if $FUNCTION; then  
    miuiver="`grep_prop ro.build.version.incremental`"
	notver=$miuiver
	#0000000000000000000000000000000000000
	ui_print "   检测到您的MIUI版本：$miuiver"
	# 检查是否支持本模块
	getfilever 8.11.1 10.3.16 && notver=9.1.24
	if [ -d $INSTALLER/common/$notver ]; then
	notmod="1"
	ui_print "   本模块魔改UI已支持您的MIUI版本"
		 ui_print "  - 请按音量键选择是否需要-"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：官方默认"

 if $FUNCTION; then  
   ui_print "已选择安装"
  cp -f $INSTALLER/common/$notver/MiuiSystemUI.apk ${MODPATH}/system/priv-app/MiuiSystemUI/
  b=1
  else
  ui_print "官方默认"
  b=0
  fi
  if [ "$b" == "1" ]; then
    ui_print "   [音量+]：时间居中＋状态栏天气"
  ui_print "   [音量-]：仅状态栏天气"

 if $FUNCTION; then  
 ui_print "   [音量+]：时间显秒"
  ui_print "   [音量-]：否  "
   if $FUNCTION; then  
   cd "$INSTALLER/common/xm"
		$zip -r0 ${MODPATH}/system/priv-app/MiuiSystemUI/MiuiSystemUI.apk ./* >/dev/null
		ui_print "   [时间居中＋状态栏天气时间显秒]安装成功。"
		echo -n "[时间居中＋状态栏天气]；" >>$INSTALLER/module.prop
		k="1"
  else
  echo -n "[时间居中＋状态栏天气]；" >>$INSTALLER/module.prop
  		ui_print "   [时间居中＋状态栏天气]安装成功。"
    	cd "$INSTALLER/common/ClockCenter"  	
    			$zip -r0 ${MODPATH}/system/priv-app/MiuiSystemUI/MiuiSystemUI.apk ./* >/dev/null
  fi  			
    			else
    			
    	
		echo -n "[状态栏天气]；" >>$INSTALLER/module.prop
		ui_print "   状态栏天气安装成功。"
		k="0"
  fi
  fi
  
	else
		ui_print "   本模块sysUI尚未支持您的MIUI版本"
		ui_print "其他理论支持"
		  ui_print "   [音量+]继续"
  ui_print "   [音量-]退出"
    if $FUNCTION; then
		notmod="1"
		else
		notmod="0"
		ui_print "退出安装但不会有残留"
		exit
		fi
		fi
		else
		ui_print " 自动为你开启多项同步模式（安装一个后自动退出）"
  ui_print "音量+安装"
    ui_print "音量-下一个"
       		ui_print "   卸载本模块并清理缓存"
          ui_print "   仅清理缓存"
          ui_print "   仅卸载模块"
          ui_print "   退出"
          ui_print "   已选择卸载本模块并清理缓存"
  if $FUNCTION; then
  rm -rf $MOUNTPATH/MoretoONE
      rm -f /data/system/package_cache/1/SecurityCenter-*
    rm -f /data/system/package_cache/1/SecurityCenter.apk-*   
     rm -f /data/system/package_cache/1/MiuiFreeformService-*       
     rm -rf /data/user/0/com.miui.securitycenter
     rm -rf /data/user/0/com.miui.freeform
     rm -f /data/system/package_cache/1/MiuiHome.apk-*   
     rm -f /data/system/package_cache/1/MiuiHome-*       
     rm -rf /data/user/0/com.miui.home
  	ui_print "   卸载模块成功"
  exit
  else
 ui_print "   已选择仅清理缓存"
    if $FUNCTION; then
   rm -f /data/system/package_cache/1/SecurityCenter-*
    rm -f /data/system/package_cache/1/SecurityCenter.apk-*   
     rm -f /data/system/package_cache/1/MiuiFreeformService-*       
     rm -rf /data/user/0/com.miui.securitycenter
     rm -rf /data/user/0/com.miui.freeform
     rm -f /data/system/package_cache/1/MiuiHome.apk-*   
     rm -f /data/system/package_cache/1/MiuiHome-*       
     rm -rf /data/user/0/com.miui.home
  ui_print " 缓存清理成功"
  exit
  else
  ui_print "   已选择仅卸载模块"
  if $FUNCTION; then
    rm -rf $MOUNTPATH/MoretoONE
    exit
    else
         ui_print " 已退出"
    exit
  fi
  fi
  fi
	fi
	fi
	}
	



ui_print "*******************************"
ui_print "   »»»miui多合一自选安装模块部分apk来源于网络«««"
ui_print "   酷安首发全机型全版本的支持"
ui_print "   酷安首发不需要垃圾mm,是安装包也是多选性救砖包"
ui_print  " 酷安首发主次脚本分流   "
ui_print "   酷安首发创造性的多级菜单添加"
ui_print " 酷安首发后悔药及多刷入模式"
ui_print "  酷安首发同类功能并列选择且自动进入下一级by 酷安@ 增粗"
ui_print "*******************************"

# 测试音量键
if keytest; then
	FUNCTION=chooseport
	ui_print "*******************************"
else
	FUNCTION=chooseportold
	ui_print "*******************************"
	ui_print "- 检测到遗留设备！使用旧的 keycheck 方案 -"
	ui_print "- 进行音量键录入 -"
	ui_print "   录入：请按下 [音量+] 键："
	$FUNCTION "UP"
	ui_print "   已录入 [音量+] 键"
	ui_print "   录入：请按下 [音量-] 键："
	$FUNCTION "DOWN"
	ui_print "   已录入 [音量-] 键"
ui_print "*******************************"
fi

# 安装模块
miuiver_start() {
ui_print "   "
ui_print "Star installation.........................."
ui_print "Loading......................................"
checkdevice
      
if [ "$notmod" == "1" ] ; then
ui_print "   本模块核心模式已支持您的MIUI版本"
		 ui_print "  - 核心模式下玄学模块将不会被载入-"
  ui_print "   [音量+]：使用核心模式(推荐，更简洁)"
  ui_print "   [音量-]：默认模式"
  if $FUNCTION; then
  ui_print "核心模式已启动"
  echo -n  "  核心模式已启动   " >>$INSTALLER/module.prop
  cd $INSTALLER/common/qita
    source ./he.sh
else
    cd $INSTALLER/common/qita
    source ./mo.sh
ui_print "Finish................................"

ui_print "退出安装......................."
fi
ui_print "*******************************"
ui_print " 希望带来愉快体验～～～bye  "
fi
}
			
  
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
local requireddevice="whyred"
local nowdevice="`grep_prop ro.product.device`"
if [ "$requireddevice" != "$nowdevice" ]; then
	ui_print "   本模块尚未支持您的手机型号,自动为您启动兼容模式"
	ui_print "   您的手机型号: $nowdevice"
	ui_print "   支持的手机型号: $requireddevice"
	ui_print "   [音量+]：安装MIUI通用模块"
  ui_print "   [音量-]：不安装"
	ui_print "*******************************"
	notmod="0"
	if $FUNCTION; then
	 
	ui_print "  - 请按音量键选择是否安装:AI预加载"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n  "  ai预加载：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/PowerKeeper.apk ${MODPATH}/system/app/PowerKeeper.apk
    cp -f $INSTALLER/common/$notver/lib/arm64/libpowerkeeper_jni.so ${MODPATH}/system/app/PowerKeeper/lib/arm64/
      cp -f $INSTALLER/common/$notver/lib64/libtensorflow_inference.so ${MODPATH}/system/lib64/
  else
  ui_print "未安装ai预加载"
  echo -n "  ai预加载：×    " >>$INSTALLER/module.prop
  fi
  


    ui_print "  - 请按音量键选择是否安装：谷歌sans字体 -"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n "  谷歌sans：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/fonts/Roboto-Black.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-BlackItalic.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-Bold.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-BoldItalic.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-Italic.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-Light.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-LightItalic.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-Medium.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-MediumItalic.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-Regular.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-Thin.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-ThinItalic.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/etc/fonts.xml ${MODPATH}/system/etc/
  else
  ui_print "未安装字体"
  echo -n "  谷歌sans：×    " >>$INSTALLER/module.prop
  fi
  
  ui_print "  - 请按音量键选择是否开启：QC3.0快充-"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n  "  QC3.0快充：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/80FastCharge ${MODPATH}/system/etc/init.d/80FastCharge
  else
  ui_print "未安装QC3.0快充"
  echo -n "  QC3.0快充：×    " >>$INSTALLER/module.prop
  fi
  
  ui_print "  - 请按音量键选择是否开启：通知分栏-"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n  "  通知分栏：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/com.android.systemui ${MODPATH}/system/media/theme/default/com.android.systemui
  else
  ui_print "未安装通知分栏"
  echo -n "  通知分栏：×    " >>$INSTALLER/module.prop
  fi
  
  ui_print "  - 请按音量键选择是否安装:去除升频文件"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n  "  去除升频文件：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/perfboostsconfig.xml ${MODPATH}/system/vendor/etc/perf/
  else
  ui_print "未安装去除升频"
  echo -n "  去除升频文件：×    " >>$INSTALLER/module.prop
  fi
  

  


# 去除防误触白条
ui_print "*******************************"
ui_print "- 请按音量键选择是否安装[去除防误触白条] -"
ui_print "   [音量+]：安装"
ui_print "   [音量-]：不安装"
if $FUNCTION; then
	cd "$INSTALLER/common/MIUI_anti_block"
	$zip -r ${MODPATH}/system/media/theme/default/com.android.systemui ./* >/dev/null
	echo -n "[去除防误触白条]；" >>$INSTALLER/module.prop
	let num++
	ui_print "   [去除防误触白条]安装成功。"
else
	ui_print "   [去除防误触白条]未安装。"
fi

# 全面屏手效
ui_print "*******************************"
ui_print "- 请按音量键选择是否安装[全面屏手势特效] -"
ui_print "   [音量+]：安装"
ui_print "   [音量-]：不安装"
if $FUNCTION; then
	cd "$INSTALLER/common/MIUI_gestureback"
	$zip -r ${MODPATH}/system/media/theme/default/com.android.systemui ./* >/dev/null
	echo -n "[全面屏手势特效]；" >>$INSTALLER/module.prop
	let num++
	ui_print "   [全面屏手势特效]安装成功。"
else
	ui_print "   [全面屏手势特效]未安装。"
fi

ui_print "*******************************"
ui_print "- 请按音量键选择是否安装[去除音乐专辑图广告] -"
ui_print "   [音量+]：安装"
ui_print "   [音量-]：不安装"
if $FUNCTION; then
	cp -r $INSTALLER/common/MIUI_player_block/* ${MODPATH}/system/
	echo -n "[去除音乐专辑图广告]；" >>$INSTALLER/module.prop
	let num++
	ui_print "   [去除音乐专辑图广告]安装成功。"
else
	ui_print "   [去除音乐专辑图广告]未安装。"
fi

ui_print "*******************************"
ui_print "- 请按音量键选择是否安装[MIUI进程精简(去广告)] -"
ui_print "   by toolazy@酷安"
ui_print "   [音量+]：安装"
ui_print "   [音量-]：不安装"
if $FUNCTION; then
	cp -r $INSTALLER/common/MIUI_msa_block/* ${MODPATH}/system/
	echo -n "[MIUI进程精简(去广告)]；" >>$INSTALLER/module.prop
	let num++
	ui_print "   [MIUI进程精简(去广告)]安装成功。"
else
	ui_print "   [MIUI进程精简(去广告)]未安装。"
fi
  ui_print "  - 请按音量键选择是否安装：eu安全中心"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n  " eu安全中心：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/SecurityCenter.apk ${MODPATH}/system/priv-app/SecurityCenter.apk
  else
  ui_print "未安装"
  fi
  

		ui_print "   本模块魔改桌面已支持您的MIUI版本"
		 ui_print "  - 请按音量键选择是否需要-"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：官方默认"
  if $FUNCTION; then
  b=1
  else
  ui_print "官方默认"
  b=0
  fi
  if [ "$b" == "1" ]; then
    ui_print "   [音量+]：eu home"
  ui_print "   [音量-]：poco home"
 if $FUNCTION; then  
 cp -f $INSTALLER/common/$notver/MiuiHome.apk ${MODPATH}/system/priv-app/MiuiHome.apk
		echo -n "[Home_EU]；" >>$INSTALLER/module.prop
		ui_print "   [Home_EU]安装成功。"
  else
cp -r $INSTALLER/common/poco/* ${MODPATH}/system/
		echo -n "[poco桌面]；" >>$INSTALLER/module.prop
		ui_print "   安装成功。"
  fi
		  echo -n " 兼容模式已开启" >>$INSTALLER/module.prop
		else
		ui_print "退出安装......................."
		fi
		fi
else
    miuiver="`grep_prop ro.build.version.incremental`"
	notver=$miuiver
	#0000000000000000000000000000000000000
	ui_print "   检测到您的MIUI版本：$miuiver"
	# 检查是否支持本模块
	getfilever 8.11.1 9.1.25 && notver=9.1.24
	if [ -d $INSTALLER/common/$notver ]; then
		ui_print "   本模块魔改状态栏已支持您的MIUI版本"
		 ui_print "  - 请按音量键选择是否需要-"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：官方默认"
  	notmod="1"
  if $FUNCTION; then
  a=1
  else
  ui_print "官方默认"
  a=0
  fi
  if [ "$a" == "1" ]; then
    ui_print "   [音量+]：状态栏天气"
  ui_print "   [音量-]：状态栏天气加时间居中"
 if $FUNCTION; then  
  ui_print "安装成功"
  echo -n  "  状态栏天气：√    " >>$INSTALLER/module.prop
  ui_print "   状态栏天气安装成功 "
  cp -f $INSTALLER/common/$notver/MiuiSystemUI.apk ${MODPATH}/system/priv-app/MiuiSystemUI.apk
  else
 echo -n  "  状态栏天气＋时间居中：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/jv/MiuiSystemUI.apk ${MODPATH}/system/priv-app/MiuiSystemUI.apk
  ui_print "  状态栏天气加时间居中安装成功"
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
		fi
	fi
fi
	}
	



ui_print "*******************************"
ui_print "   »»»HMnote5多合一自选安装模块«««"
ui_print "   本人小白，请会自救再安装本模块"
ui_print "   常备mm及同类救砖神器"
ui_print "   部分apk来源于酷安 "
ui_print "   by 酷安@ 增粗"
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


    ui_print "  - 请按音量键选择是否安装:替换为星空温控"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n  "  星空温控：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/thermal-engine-china.conf ${MODPATH}/system/vendor/etc/
  cp -f $INSTALLER/common/$notver/thermal-engine-sgame.conf ${MODPATH}/system/vendor/etc/
  else
  ui_print "未安装星空温控"
  echo -n "  星空温控：×    " >>$INSTALLER/module.prop
  fi
			
  ui_print "  - 请按音量键选择是否安装：败家之眼相机水印 -"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n  "  败家之眼相机水印：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/MIUI_Time.ttf ${MODPATH}/system/etc/
  cp -f $INSTALLER/common/$notver/dualcamera.png ${MODPATH}/system/etc/
  cp -f $INSTALLER/common/$notver/Miui-Light.ttf ${MODPATH}/system/etc/  
  else
  ui_print "未安装水印"
  echo -n "  败家之眼相机水印：×    " >>$INSTALLER/module.prop
  fi
  
  

  ui_print "  - 请按音量键选择是否安装：mix3新版游戏工具箱 -"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n  "  mix3新版工具箱：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/SecurityCenter.apk ${MODPATH}/system/priv-app/SecurityCenter.apk
  else
  ui_print "未安装新版工具箱"
  echo -n "  mix3新版工具箱：×    " >>$INSTALLER/module.prop
  fi
  
   #开机动画 弃用
 
  ui_print "  - 请按音量键选择是否安装：破解miui下载vip -"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n  "  miui下载vip：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/DownloadProviderUi.apk ${MODPATH}/system/priv-app/DownloadProviderUi.apk
  else
  ui_print "未安装miui下载vip"
  echo -n "  miui下载vip：×    " >>$INSTALLER/module.prop
  fi
 
 
   ui_print "  - 请按音量键选择是否安装:AI预加载"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n  "  ai预加载：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/PowerKeeper.apk ${MODPATH}/system/app/PowerKeeper.apk
    cp -f $INSTALLER/common/$notver/lib/arm64/libpowerkeeper_jni.so ${MODPATH}/system/app/PowerKeeper/lib/arm64/
      cp -f $INSTALLER/common/$notver/lib64/libtensorflow_inference.so ${MODPATH}/system/lib64/
  else
  ui_print "未安装ai预加载"
  echo -n "  ai预加载：×    " >>$INSTALLER/module.prop
  fi
  


    ui_print "  - 请按音量键选择是否安装：谷歌sans字体 -"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n "  谷歌sans：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/fonts/Roboto-Black.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-BlackItalic.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-Bold.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-BoldItalic.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-Italic.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-Light.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-LightItalic.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-Medium.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-MediumItalic.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-Regular.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-Thin.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/fonts/Roboto-ThinItalic.ttf ${MODPATH}/system/fonts/
  cp -f $INSTALLER/common/$notver/etc/fonts.xml ${MODPATH}/system/etc/
  else
  ui_print "未安装字体"
  echo -n "  谷歌sans：×    " >>$INSTALLER/module.prop
  fi
  
  ui_print "  - 请按音量键选择是否开启：QC3.0快充-"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n  "  QC3.0快充：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/80FastCharge ${MODPATH}/system/etc/init.d/80FastCharge
  else
  ui_print "未安装QC3.0快充"
  echo -n "  QC3.0快充：×    " >>$INSTALLER/module.prop
  fi
  
  ui_print "  - 请按音量键选择是否开启：通知分栏-"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n  "  通知分栏：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/com.android.systemui ${MODPATH}/system/media/theme/default/com.android.systemui
  else
  ui_print "未安装通知分栏"
  echo -n "  通知分栏：×    " >>$INSTALLER/module.prop
  fi
  
  ui_print "  - 请按音量键选择是否安装:去除升频文件"
  ui_print "   [音量+]：安装"
  ui_print "   [音量-]：不安装"
  if $FUNCTION; then
  ui_print "安装成功"
  echo -n  "  去除升频文件：√    " >>$INSTALLER/module.prop
  cp -f $INSTALLER/common/$notver/perfboostsconfig.xml ${MODPATH}/system/vendor/etc/perf/
  else
  ui_print "未安装去除升频"
  echo -n "  去除升频文件：×    " >>$INSTALLER/module.prop
  fi
  

  


# 去除防误触白条
ui_print "*******************************"
ui_print "- 请按音量键选择是否安装[去除防误触白条] -"
ui_print "   [音量+]：安装"
ui_print "   [音量-]：不安装"
if $FUNCTION; then
	cd "$INSTALLER/common/MIUI_anti_block"
	$zip -r ${MODPATH}/system/media/theme/default/com.android.systemui ./* >/dev/null
	echo -n "[去除防误触白条]；" >>$INSTALLER/module.prop
	let num++
	ui_print "   [去除防误触白条]安装成功。"
else
	ui_print "   [去除防误触白条]未安装。"
fi

# 全面屏手效
ui_print "*******************************"
ui_print "- 请按音量键选择是否安装[全面屏手势特效] -"
ui_print "   [音量+]：安装"
ui_print "   [音量-]：不安装"
if $FUNCTION; then
	cd "$INSTALLER/common/MIUI_gestureback"
	$zip -r ${MODPATH}/system/media/theme/default/com.android.systemui ./* >/dev/null
	echo -n "[全面屏手势特效]；" >>$INSTALLER/module.prop
	let num++
	ui_print "   [全面屏手势特效]安装成功。"
else
	ui_print "   [全面屏手势特效]未安装。"
fi

ui_print "*******************************"
ui_print "- 请按音量键选择是否安装[去除音乐专辑图广告] -"
ui_print "   [音量+]：安装"
ui_print "   [音量-]：不安装"
if $FUNCTION; then
	cp -r $INSTALLER/common/MIUI_player_block/* ${MODPATH}/system/
	echo -n "[去除音乐专辑图广告]；" >>$INSTALLER/module.prop
	let num++
	ui_print "   [去除音乐专辑图广告]安装成功。"
else
	ui_print "   [去除音乐专辑图广告]未安装。"
fi

ui_print "*******************************"
ui_print "- 请按音量键选择是否安装[MIUI进程精简(去广告)] -"
ui_print "   by toolazy@酷安"
ui_print "   [音量+]：安装"
ui_print "   [音量-]：不安装"
if $FUNCTION; then
	cp -r $INSTALLER/common/MIUI_msa_block/* ${MODPATH}/system/
	echo -n "[MIUI进程精简(去广告)]；" >>$INSTALLER/module.prop
	let num++
	ui_print "   [MIUI进程精简(去广告)]安装成功。"
else
	ui_print "   [MIUI进程精简(去广告)]未安装。"
fi

	ui_print "*******************************"
	ui_print "- 请按音量键选择是否安装[poco桌面] -"
	ui_print "   说明：移植poco桌面。"
	ui_print "   [音量+]：安装"
	ui_print "   [音量-]：不安装"
	if $FUNCTION; then
	cp -r $INSTALLER/common/poco/* ${MODPATH}/system/
		echo -n "[poco桌面]；" >>$INSTALLER/module.prop
		ui_print "   安装成功。"
	else
		ui_print "   未安装。"
	fi
	


ui_print "Finish................................"

ui_print "退出安装......................."
fi
ui_print "*******************************"
ui_print " 希望带来愉快体验～～～bye  "
}

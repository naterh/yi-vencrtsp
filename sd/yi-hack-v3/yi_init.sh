ulimit -s 1024
export LD_LIBRARY_PATH=/home/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/app/locallib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/hisiko/hisilib:$LD_LIBRARY_PATH
export PATH=/home/app/localbin:$PATH
export PATH=/home/base/tools:$PATH

/home/app/script/factory_test.sh

#/home/base/tools/nvram_tools_h19
bcmver="bd1e"
bcmver1="0bdc"
bcmcmd=$(lsusb|grep "0a5c"|cut -d':' -f3)
bcmcmd1=$(lsusb|grep "7601"|cut -d':' -f3)
bcmver2="7601"

lsusb

if [ $bcmver = $bcmcmd ];then
	/home/base/tools/bcmdl -n /home/app/localbin/nvram_wubb-738gn.txt /home/base/wifi/firmware/fw_bcmdhd_xy159.bin.trx -C 10 
	insmod /home/base/wifi/driver/bcmdhd.ko iface_name=wlan0
	himm 0x20120080 0x1c00        
	himm 0x20120080 0x1c20
	himm 0x20120080 0x1b0a 
	himm 0x20120080 0x1b2a
	echo "BCM" > /tmp/BCM
elif [ $bcmver1 = $bcmcmd ];then
	/home/base/tools/bcmdl -n /home/app/localbin/nvram_wubb-738gn.txt /home/base/wifi/firmware/fw_bcmdhd_xy159.bin.trx -C 10 
	insmod /home/base/wifi/driver/bcmdhd.ko iface_name=wlan0
	himm 0x20120080 0x1c00        
	himm 0x20120080 0x1c20
	himm 0x20120080 0x1b0a 
	himm 0x20120080 0x1b2a
	echo "BCM" > /tmp/BCM
elif [ $bcmver2 = $bcmcmd1 ];then
	himm 0x20180100 0
	sleep 1
	himm 0x20180100 0x40
	sleep 1
	insmod /home/base/wifi/driver/mt7601Usta.ko
	echo "MTK 7601" > /tmp/MTK
else
	insmod /home/base/wifi/driver/rtl8189fs.ko
	echo "realtech 8819fs"
fi

ifconfig wlan0 up

rm /etc/resolv.conf
ln -s /tmp/resolv.conf /etc/resolv.conf

cd /home/app
./log_server &
./dispatch &

cd /tmp/sd/yi-hack-v3/ko_from_sdk
./load3518e -i

exit
himm 0x201200cc 0xfe033144
himm 0x201200c8 0x23c2e
himm 0x201200d8 0x0d1ec001

insmod /home/base/hi_cipher.ko
cd /home/app
./rmm &
sleep 2
#./rtspsvr &
./mp4record &
./cloud &
./p2p_tnp &
./oss &
./watch_process &
insmod /home/app/localko/watchdog.ko


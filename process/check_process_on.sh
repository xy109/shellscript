#!/bin/bash
if [ "x${1}" = "x" ];then
   echo "进程存活检测脚本:"
   echo "$0 进程标识名称 \"进程启动脚本\""
   echo "sh $0 ssh \"service ssh start\"  "
   exit 0
fi

NOT_HAVE_PROCESS=true
TRY_NUM=0
TRY_TIMEOUT=$3

if [ "x${TRY_TIMEOUT}" = "x" ];then
   TRY_TIMEOUT=30s
fi

while ${NOT_HAVE_PROCESS} && [ $TRY_NUM -lt 10 ];do
 #用ps获取$PRO_NAME进程数量
 NUM=`ps aux | grep -w $1 | grep -v $0 | grep -v grep |wc -l`
 #少于1，重启进程
 if [ "${NUM}" -lt "1" ];then
   if [ $TRY_NUM -gt 0 ];then
      echo "${TRY_TIMEOUT}后将尝试第$(($TRY_NUM+1))次重新启动"
      sleep ${TRY_TIMEOUT}
   else
        echo "进程[${1}]已退出,正在尝试重新启动"
   fi
   if [ $TRY_NUM -gt 0 ];then
      echo "已重试启动${TRY_NUM}次"
   fi
   echo "即将执行:$2"
   $2
   TRY_NUM=$(($TRY_NUM+1))
 else
   NOT_HAVE_PROCESS=false
   NUM=`ps aux | grep -w $1 | grep -v $0 | grep -v grep |awk '{print $2}'`
   echo "进程[$NUM][${1}]存活正常"
 fi
done
exit 0

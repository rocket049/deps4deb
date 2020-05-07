#!/usr/bin/env bash

if [ -z "$1" ];then
	echo "Usage:"
	echo "        deps4deb <ELF file name>"
	exit 1  
fi

echo '' > tmp1
function getPkgName(){
	if [ -f $1 ];then
		fn=$(readlink -f $1)
		pkg1=`dpkg -S ${fn} | cut -f1 -d':'`
		echo "$1: "${pkg1}
		echo ${pkg1} >> tmp1
	fi
}

for l1 in `ldd $1 |cut -f3 -d' '`; do
	 getPkgName ${l1}
done

cat tmp1 | sort | uniq >tmp2

res=""
for l in `cat tmp2`;do
	if [ "$res" = "" ];then
		res=$l
	else
		res="${res}, $l"
	fi
done
echo "Depends:"
echo "        ${res}"

rm tmp1 tmp2

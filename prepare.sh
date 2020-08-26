#!/bin/sh

set -e

export LC_ALL=C
export LANG=C

dir=`dirname "$0"`

version=`dpkg-parsechangelog -l"$dir"/debian/changelog | sed -ne '/Version:/ s,Version: \(.*\),\1,p' | tr '.-' ' '`
major=`echo $version | cut -d" " -f 1`
minor=`echo $version | cut -d" " -f 2`
debian=`echo $version | cut -d" " -f 3`

if [ ! -f jdk-${major}u${minor}-linux-x64.tar.gz ] ; then
  echo "please download jdk-${major}u${minor}-linux-x64.tar.gz"
  exit 1
fi

if [ ! -f jdk-${major}u${minor}-linux-i586.tar.gz ] ; then
  echo "please download jdk-${major}u${minor}-linux-i586.tar.gz"
  exit 1
fi

echo "7755b7d9021f84b4b1f28a58ec319f651488254d24581a8f57fa97a1dd50825a jdk-${major}u${minor}-linux-x64.tar.gz" | sha256sum -c
echo "27342c29031975d3307b483b0b572e1d597b9b782d198ce355f212736e3fa0e5 jdk-${major}u${minor}-linux-i586.tar.gz" | sha256sum -c

rm -rf "$dir"/i586 "$dir"/jdk1.${major}.0_${minor}
tar xf "$dir"/jdk-${major}u${minor}-linux-i586.tar.gz -C "$dir"
mv "$dir"/jdk1.${major}.0_${minor} "$dir"/i586
mv "$dir"/jdk-${major}u${minor}-linux-i586.tar.gz "$dir"/../oracle-java${major}_${major}.${minor}.orig-i586.tar.gz

rm -rf "$dir"/x64 "$dir"/jdk1.${major}.0_${minor}
tar xf "$dir"/jdk-${major}u${minor}-linux-x64.tar.gz -C "$dir"
mv "$dir"/jdk1.${major}.0_${minor} "$dir"/x64
mv "$dir"/jdk-${major}u${minor}-linux-x64.tar.gz "$dir"/../oracle-java${major}_${major}.${minor}.orig-x64.tar.gz

git --git-dir="$dir"/.git archive --format=tar --prefix=oracle_java${major}-${major}.${minor}/ HEAD README.md prepare.sh | gzip > "$dir"/../oracle-java${major}_${major}.${minor}.orig.tar.gz

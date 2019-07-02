#!/bin/bash

echo "Building Event app!"



cd ..


if [ -d "build" ]; then
	rm -fr build  
fi
mkdir build
cd build

if [ -z $1 ]; then
	cmake ../SolarFlightAnalyser -DCMAKE_PREFIX_PATH=/opt/qt5/5.13.0/gcc_64/lib/cmake
else
	cmake ../SolarFlightAnalyser -DCMAKE_PREFIX_PATH=$1
fi


make
cd src
./EventAPP

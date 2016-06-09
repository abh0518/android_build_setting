#!/bin/bash

package_app_dir="release_app_package"
package_module_dir="release_module_package"

# build.gradle 파일에서 버전 정보를 가져온다.
appVersionCode=$(echo "$fullName"  | sed -n '/versionCode /p' ./app/build.gradle)
appVersionName=$(echo "$fullName"  | sed -n '/versionName /p' ./app/build.gradle)
[[ $appVersionCode =~ [0-9]+ ]]
appVersionCode=${BASH_REMATCH[0]}
[[ $appVersionName =~ [0-9]+.[0-9+.[0-9]+ ]]
appVersionName=${BASH_REMATCH[0]}

# 패키지 디렉토리 및 그래들 빌드 환경을 초기화
rm -rf $package_app_dir
mkdir $package_app_dir
rm -rf $package_module_dir
mkdir $package_module_dir
./gradlew clean

# 스테이징 디버그, 상용 디버그, 배포용 빌드
./gradlew assembledevDebug
find ./app -name '*-debug.apk' -exec mv {} ./$package_app_dir/ \;

./gradlew assemblestagingDebug
find ./app -name '*-debug.apk' -exec mv {} ./$package_app_dir/ \;

./gradlew assembleproductDebug
find ./app -name '*-debug.apk' -exec mv {} ./$package_app_dir/ \;

./gradlew assembleproductRelease
find ./app -name '*-unsigned.apk' -exec mv {} ./$package_app_dir/ \;

./gradlew :app_library:aR
find ./app_library -name '*.aar' -exec mv {} ./$package_module_dir/ \;


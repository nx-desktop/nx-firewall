project(kcm-nomad-firewall)
cmake_minimum_required(VERSION 2.18.12)

set(KF5_MIN_VERSION "5.30.0")
set(QT_MIN_VERSION "5.5.0")

find_package(ECM 0.0.14 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

include(FeatureSummary)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings)

find_package(Qt5 ${QT_MIN_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick Test Gui )

find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS
    Archive NewStuff NewStuffCore KIO Declarative I18n Config ConfigWidgets)

################# Enable C++11 features for clang and gcc #################

if(UNIX)
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++0x")
endif()


################# KI18N Translation Domain for this library #################
add_definitions(-DTRANSLATION_DOMAIN=\"kcm-nomad-firewall\")

#############################################################################

add_subdirectory(lib)

#############################################################################

kpackage_install_package(package org.nomad.kcms.firewall kcms)


#############################################################################

file(GLOB_RECURSE QML_SRCS package/*)
add_custom_target(PackageFiles ALL echo SOURCES ${QML_SRCS} ${JS_SRCS})


feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)

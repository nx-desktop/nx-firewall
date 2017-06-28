cmake_minimum_required(VERSION 2.18.12)
#-----------------------------------------------------------------------------
#                           GENERAL CONFIGURATION
#-----------------------------------------------------------------------------
project(nomad-firewall)

set(KF5_MIN_VERSION "5.30.0")
set(QT_MIN_VERSION "5.5.0")

#-----------------------------------------------------------------------------
#                              DEPENDENCIES
#-----------------------------------------------------------------------------
# Qt5
find_package(Qt5 REQUIRED COMPONENTS
    Core
    Qml
)

# KDE5
find_package(ECM REQUIRED)
list(APPEND CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})
include(KDEInstallDirs)
include(FeatureSummary)
include(KDECMakeSettings)
include(KDECompilerSettings)

find_package(KF5 REQUIRED COMPONENTS 
    CoreAddons
    KCMUtils
    I18n
    Plasma
    PlasmaQuick
    KDELibs4Support
    Declarative
)

#-----------------------------------------------------------------------------
#                           BUILD TYPES & FLAGS
#-----------------------------------------------------------------------------
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -std=c++0x")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g3 -O0")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Werror -O2")

#-----------------------------------------------------------------------------
#                               SOURCES
#-----------------------------------------------------------------------------
add_subdirectory(kcm)
#-----------------------------------------------------------------------------
#                               BUILD SUMMARY
#-----------------------------------------------------------------------------
feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)

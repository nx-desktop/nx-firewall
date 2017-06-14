project(nomad-firewall)
cmake_minimum_required(VERSION 2.18.12)

set(KF5_MIN_VERSION "5.30.0")
set(QT_MIN_VERSION "5.6.0")

find_package(ECM 0.0.14 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

include(FeatureSummary)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings)


################# Enable C++11 features for clang and gcc #################

if(UNIX)
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++0x")
endif()


#############################################################################

add_subdirectory(plugins)
add_subdirectory(app)

#############################################################################

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/version.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/version.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(kcm_SRCS
    nomadfirewallkcm.cpp
)

add_library(org.nxos.firewall MODULE ${kcm_SRCS})

target_link_libraries(org.nxos.firewall
    Qt5::Quick
    KF5::CoreAddons
    KF5::Declarative
    KF5::I18n
    KF5::QuickAddons)


kcoreaddons_desktop_to_json(org.nxos.firewall org.nxos.firewall.desktop SERVICE_TYPES kcmodule.desktop)

#this desktop file is installed only for retrocompatibility with sycoca
install(FILES org.nxos.firewall.desktop DESTINATION ${SERVICES_INSTALL_DIR})
install(TARGETS org.nxos.firewall DESTINATION ${PLUGIN_INSTALL_DIR}/kcms)

kpackage_install_package(package org.nxos.firewall kcms)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/version.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/version.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(kcm_SRCS
    nomadfirewallkcm.cpp
)

add_library(kcm_nomadFirewall MODULE ${kcm_SRCS})

kcoreaddons_desktop_to_json(kcm_nomadFirewall "../kcm_nomadFirewall.desktop")

target_link_libraries(kcm_nomadFirewall
    Qt5::Quick
    KF5::CoreAddons
    KF5::Declarative
    KF5::I18n
    KF5::QuickAddons)


install(TARGETS kcm_nomadFirewall DESTINATION ${PLUGIN_INSTALL_DIR}/kcms)

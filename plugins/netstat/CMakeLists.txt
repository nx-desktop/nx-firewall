add_subdirectory(helper)

find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS
    Quick
    Xml
    X11Extras
)

find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS
    Plasma
    PlasmaQuick
    I18n
    Declarative
    Auth
    Config
)


set(nomad_netstat_plugin_SRCS
    netstatplugin.cpp
    conectionsmodel.cpp
    netstatclient.cpp
    qmldir
)

add_library(nomad_netstat_plugin SHARED ${nomad_netstat_plugin_SRCS})
target_link_libraries(nomad_netstat_plugin
                      Qt5::Core
                      Qt5::Quick
                      Qt5::Xml
                      Qt5::X11Extras
                      KF5::CoreAddons
                      KF5::ConfigCore
                      KF5::Auth
                      KF5::I18n)

set(INSTALL_PATH ${QML_INSTALL_DIR}/org/nomad/netstat)

install(TARGETS nomad_netstat_plugin DESTINATION  ${INSTALL_PATH})
install(FILES qmldir DESTINATION ${INSTALL_PATH})

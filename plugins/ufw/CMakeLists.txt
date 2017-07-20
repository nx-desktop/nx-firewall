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
    KDELibs4Support
)


set(nomad_ufw_plugin_SRCS
    ufwplugin.cpp
    ufwclient.cpp
    blocker.cpp
    profile.cpp
    rule.cpp
    types.cpp
    appprofiles.cpp
    rulelistmodel.cpp
    loglistmodel.cpp
    rulewrapper.cpp
    qmldir
)


add_library(nomad_ufw_plugin SHARED ${nomad_ufw_plugin_SRCS})
target_link_libraries(nomad_ufw_plugin
                      Qt5::Core
                      Qt5::Quick
                      Qt5::Xml
                      Qt5::X11Extras
                      KF5::CoreAddons
                      KF5::ConfigCore
                      KF5::Auth
                      KF5::I18n
                      KF5::KDELibs4Support)

set(INSTALL_PATH ${QML_INSTALL_DIR}/org/nomad/ufw)

install(TARGETS nomad_ufw_plugin DESTINATION  ${INSTALL_PATH})
install(FILES qmldir DESTINATION ${INSTALL_PATH})

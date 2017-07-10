# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)
include_directories(${CMAKE_BINARY_DIR})

# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)

find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS
    Quick
    X11Extras
)


find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS
    I18n
    Auth
)

set(netstat_plugin_helper_SRCS netstathelper.cpp )
add_executable(nomad_netstat_plugin_helper ${netstat_plugin_helper_SRCS})

# set_target_properties(kcm_ufw_helper PROPERTIES OUTPUT_NAME kcm_ufw_helper)
target_link_libraries(nomad_netstat_plugin_helper Qt5::Core KF5::Auth)


 kauth_install_actions(org.nomad.netstat org.nomad.netstat.actions)
 install(TARGETS nomad_netstat_plugin_helper DESTINATION ${KAUTH_HELPER_INSTALL_DIR})
 kauth_install_helper_files(nomad_netstat_plugin_helper org.nomad.netstat root)

# install(TARGETS kcm_ufw_helper DESTINATION ${LIBEXEC_INSTALL_DIR})
# install(PROGRAMS ${CMAKE_BINARY_DIR}/nomad_ufw_plugin_helper.py DESTINATION ${LIBEXEC_INSTALL_DIR})

 configure_file(org.kde.netstat.service.cmake ${CMAKE_CURRENT_BINARY_DIR}/session/org.kde.netstat.service)
 install(FILES ${CMAKE_CURRENT_BINARY_DIR}/session/org.kde.netstat.service DESTINATION ${DBUS_SERVICES_INSTALL_DIR})

find_program(NETSTAT_BINARY_PATH NAMES netstat)
configure_file(netstat_helper_config.h.cmake ${CMAKE_BINARY_DIR}/netstat_helper_config.h)

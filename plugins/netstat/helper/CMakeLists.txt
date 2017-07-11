# Find includes in corresponding build directories
include_directories(${CMAKE_BINARY_DIR})

# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)

find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS
    Core
    )


find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS
    I18n
    Auth
    )

find_program(NETSTAT_BINARY_PATH NAMES netstat)
configure_file(netstat_helper_config.h.cmake ${CMAKE_BINARY_DIR}/netstat_helper_config.h)


add_executable(nxos_netstat_helper netstathelper.cpp)
target_link_libraries(nxos_netstat_helper Qt5::Core KF5::I18n KF5::Auth)

install(TARGETS nxos_netstat_helper DESTINATION ${KAUTH_HELPER_INSTALL_DIR})
kauth_install_helper_files(nxos_netstat_helper org.nxos.netstat root)

kauth_install_actions(org.nxos.netstat org.nxos.netstat.actions)

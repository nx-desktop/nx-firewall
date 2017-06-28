################# KI18N Translation Domain for this library #################
add_definitions(-DTRANSLATION_DOMAIN=\"nomad-firewall\")

find_package(Qt5 ${QT_MIN_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick Gui )
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS Declarative I18n)


qt5_add_resources(APP_QML_SOURCES qml.qrc)

set(APP_SOURCES
    main.cpp
    )


add_executable(${PROJECT_NAME} ${APP_SOURCES} ${APP_QML_SOURCES})
target_link_libraries(${PROJECT_NAME} Qt5::Qml Qt5::Quick KF5::I18n KF5::Declarative)

install(TARGETS ${PROJECT_NAME} DESTINATION bin)

install( PROGRAMS nomad-firewall.desktop DESTINATION ${XDG_APPS_INSTALL_DIR} )

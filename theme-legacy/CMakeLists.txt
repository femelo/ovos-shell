set(OpenVoiceStyle_SRCS
    ovostheme.cpp
    kirigamiplasmafactory.cpp
)

kcoreaddons_add_plugin(OpenVoiceStyle SOURCES ${OpenVoiceStyle_SRCS} INSTALL_NAMESPACE "kf5/kirigami" JSON ovostheme.json)

target_link_libraries(OpenVoiceStyle
    PUBLIC
        Qt5::Core
        KF5::Kirigami2
    PRIVATE
        Qt5::DBus
        Qt5::Qml
        Qt5::Quick
        KF5::GuiAddons
        KF5::ConfigWidgets
        KF5::IconThemes
)

install(FILES Theme.qml DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigami.2/styles/OpenVoiceStyle)

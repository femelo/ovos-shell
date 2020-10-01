/*
 * Copyright 2018 by Marco Martin <mart@kde.org>
 * Copyright 2018 David Edmundson <davidedmundson@kde.org>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Window 2.2
import Mycroft 1.0 as Mycroft
import QtQuick.Controls.Material 2.0

import "./panel" as Panel

Kirigami.AbstractApplicationWindow {
    id: root
    visible: true

    minimumHeight : deviceHeight || undefined
    maximumHeight : deviceHeight || undefined
    minimumWidth : deviceWidth || undefined
    maximumWidth : deviceWidth || undefined
    x: deviceWidth ? Screen.desktopAvailableHeight - width : undefined
    y: deviceHeight ? Screen.desktopAvailableHeight - height : undefined

    Component.onCompleted: {
        showMaximized()
    }

    Timer {
        interval: 20000
        running: Mycroft.GlobalSettings.autoConnect && Mycroft.MycroftController.status != Mycroft.MycroftController.Open
        triggeredOnStart: true
        onTriggered: {
            print("Trying to connect to Mycroft");
            Mycroft.MycroftController.start();
        }
    }

    Rectangle {
        id: contentsRect
        color: "black"
        anchors.centerIn: parent
        rotation: {
            switch (applicationSettings.rotation) {
            case "CW":
                return 90;
            case "CCW":
                return -90;
            case "UD":
                return 180;
            case "NORMAL":
            default:
                return 0;
            }
        }
        width: rotation === 90 || rotation == -90 ? parent.height : parent.width
        height: rotation === 90 || rotation == -90 ? parent.width : parent.height
        
        Image {
            source: "background.png"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            opacity: !mainView.currentItem
            Behavior on opacity {
                OpacityAnimator {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InQuad
                }
            }
        }

        Mycroft.SkillView {
            id: mainView
            activeSkills.whiteList: singleSkill.length > 0 ? singleSkill : null
            Kirigami.Theme.colorSet: nightSwitch.checked ? Kirigami.Theme.Complementary : Kirigami.Theme.View
            anchors.fill: parent
        }
        Button {
            anchors.centerIn: parent
            text: "start"
            visible: Mycroft.MycroftController.status == Mycroft.MycroftController.Closed
            onClicked: Mycroft.MycroftController.start();
        }

        Item {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            height: Kirigami.Units.gridUnit * 2
            clip: slidingPanel.position <= 0
            Panel.SlidingPanel {
                id: slidingPanel
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }
                height: contentsRect.height
            }
        }
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: (1 - applicationSettings.fakeBrightness) * 0.85
        }
    }
}

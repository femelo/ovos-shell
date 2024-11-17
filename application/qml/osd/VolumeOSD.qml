/*
 * Copyright 2021 by Aditya Mehra <aix.m@outlook.com>
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
import Mycroft 1.0 as Mycroft

SliderControl {
    id: root
    iconSource: "qrc://icons/volume-high"
    visible: false
    property var refSlidingPanel

    onRefSlidingPanelChanged: {
        if(refSlidingPanel > 1) {
            visible = false
            feedbackTimer.stop()
        }
    }

    onChangeValueChanged: {
        Mycroft.MycroftController.sendRequest("mycroft.volume.set", {"percent": changeValue});
        feedbackTimer.restart()
    }

    Connections {
        target: Mycroft.MycroftController

        onIntentRecevied: {
            if (type == "mycroft.volume.display") {
                root.visible = true
                root.value = Math.round(data.percent * 100);
                feedbackTimer.restart()
            }
        }
    }

    Timer {
        id: feedbackTimer
        interval: 5000

        onTriggered: {
            root.visible = false
        }
    }
}

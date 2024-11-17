import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import org.kde.kirigami 2.9 as Kirigami
import QtQuick.Window 2.2
import Mycroft 1.0 as Mycroft

Column {
    id: notificationsSys
    anchors.fill: parent
    anchors.margins: Mycroft.Units.gridUnit * 2
    spacing: Mycroft.Units.gridUnit * 2
    property int cellWidth: notificationsSys.width
    property int cellHeight: notificationsSys.height
    signal clearNotificationSessionData
    z: 999

    property var notificationData
    property var controlledNotificationData
    property var controlledNotificationObject

    Connections {
        target: Mycroft.MycroftController

        onIntentRecevied: {
            if (type == "ovos.notification.notification_data") {
                var notifdata = data.notification
                notificationsSys.notificationData = notifdata
            }
            if (type == "ovos.notification.show") {
                display_notification()
            }
            if (type == "ovos.notification.controlled.type.show") {
                var control_notif_data = data.notification
                notificationsSys.controlledNotificationData = control_notif_data
                console.log(JSON.stringify(control_notif_data))
                display_update_controlled_notification()
            }
            if (type == "ovos.notification.controlled.type.remove") {
                remove_controlled_notification()
            }
        }
    }

    Connections {
        target: notificationsSys
        onClearNotificationSessionData: {
            Mycroft.MycroftController.sendRequest("ovos.notification.api.pop.clear", {"notification": notificationsSys.notificationData})
        }
    }

    function display_notification() {
        if(notificationsSys.notificationData !== undefined) {
            if(notificationsSys.notificationData.type === "sticky"){
                var component = Qt.createComponent("NotificationPopSticky.qml");
            } else {
                component = Qt.createComponent("NotificationPopTransient.qml");
            }
            if (component.status !== Component.Ready)
            {
                if (component.status === Component.Error) {
                    console.debug("Error: " + component.errorString());
                }
                return;
            } else {
                var notif_object = component.createObject(notificationsSys, {currentNotification: notificationsSys.notificationData})
            }
        }
    }

    function display_update_controlled_notification() {
        console.log("Displaying Controlled Notification")
        if(!notificationsSys.controlledNotificationObject){
            var controlled_component = Qt.createComponent("NotificationPopControlled.qml");
            if (controlled_component.status !== Component.Ready) {
                if (controlled_component.status === Component.Error) {
                    console.debug("Error: " + controlled_component.errorString());
                }
                return;
            } else {
                notificationsSys.controlledNotificationObject = controlled_component.createObject(notificationsSys, {currentNotification: notificationsSys.controlledNotificationData})
            }
        } else {
            notificationsSys.controlledNotificationObject.currentNotification = notificationsSys.controlledNotificationData
        }
    }

    function remove_controlled_notification() {
        console.log("Removing Controlled Notification")
        notificationsSys.controlledNotificationObject.destroy();
    }
}

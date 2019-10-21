import QtQuick 2.0
//import "../settings.js" as Settings

Item {
    id: menu
    height: cancelButton.height + topMenuPart.height + topMenuPart.anchors.bottomMargin
    anchors.leftMargin: 8 * fudge
    anchors.rightMargin: anchors.leftMargin
    anchors.bottomMargin: anchors.leftMargin

    Rectangle {
        id: cancelButton
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 44 * fudge
        radius: 4 * fudge

        color: "white"

        Text {
            anchors.centerIn: parent
            font.bold: true
            font.pixelSize: 19 * fudge
            color: "#0079ff"
            text: "Cancel"
        }
    }

    Rectangle {
        id: topMenuPart
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: cancelButton.top
        anchors.bottomMargin: 8 * fudge
        height: menuTitle.height + divider.height + mobileNumberItem.height
        radius: 4 * fudge

        Item {
            id: mobileNumberItem
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 44 * fudge
            Item {
                id: mobileNumberWrapper
                anchors.centerIn: parent
                width: mobileNumberTypeText.width + numberText.width

                Text {
                    id: mobileNumberTypeText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    width: implicitWidth
                    font.pixelSize: 20 * fudge
                    text: "mobile "
                }
                Text {
                    id: numberText
                    anchors.left: mobileNumberTypeText.right
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 20 * fudge
                    color: "#0079ff"
                    text: "XXX-XXX-XXXX"
                }
            }


        }

        Rectangle {
            id: divider
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: mobileNumberItem.top
            height: 1
            color: "#cccccc"
        }


        Item {
            id: menuTitle
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: divider.top
            height: 48 * fudge
            Text {
                anchors.centerIn: parent
                font.pixelSize: 13 * fudge
                color: "#888888"
                text: "Add to Favorites"
            }
        }
    }
}

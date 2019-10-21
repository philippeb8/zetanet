/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.0
import QtMultimedia 5.6
//import "../settings.js" as Settings

Item {
    id: menu
    //width: parent.width
    //height: parent.height
    //height: cancelButton.height + topMenuPart.height + topMenuPart.anchors.bottomMargin
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
        height: divider.height + 48 * fudge * 3
        radius: 4 * fudge

        Column
        {
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                height: 48 * fudge
                //anchors.fill: parent
                font.pixelSize: 13 * fudge
                color: "#888888"
                text: "Add Picture"
            }

            Rectangle {
                id: divider
                height: 1
                color: "#cccccc"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                height: 48 * fudge
                //anchors.fill: parent
                font.pixelSize: 20 * fudge
                text: "Camera Roll"

                MouseArea {
                    anchors.fill: parent;
                    onClicked:
                    {
                        hideMenu();
                        stackView.push(Qt.resolvedUrl("qrc:/qml/content/CameraAction.qml"))
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                height: 48 * fudge
                //anchors.fill: parent
                font.pixelSize: 20 * fudge
                text: "Facebook"
            }
        }
    }
}

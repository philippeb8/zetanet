/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtGraphicalEffects 1.0

Item {
    id: profileview
    anchors.fill: parent
/*
    Rectangle {
        anchors.centerIn: parent
        width: parent.width<parent.height?parent.width:parent.height
        height: width
        radius: width*0.5
        border.color: "black"
        border.width: 1

        RadialGradient {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "blue" }
                GradientStop { position: 0.5; color: "transparent" }
                GradientStop { position: 1.0; color: "blue" }
            }
        }
    }
*/

    Repeater
    {
        model: 100

        HeartBeat
        {
            initialWidthOffset: index
            initialHeightOffset: index
            initialOpacity: index / 2500
            timer.interval: 1200
            timer.running: true
        }
    }

    Repeater
    {
        model: 100

        HeartBeat
        {
            initialWidthOffset: index
            initialHeightOffset: index
            initialOpacity: index / 2500
            timer.interval: 1000
            timer.running: true
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 20
/*
        // Display name
        Text {
          anchors.horizontalCenter: parent.horizontalCenter

          // Set firstname from facebook profile
          text: facebook.profile.firstName
        }
*/
        Item
        {
            width: 160 * fudge
            height: 160 * fudge
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Image {
                id: image
                anchors.fill: parent
                source: facebook.profile.pictureUrl
                fillMode: Image.PreserveAspectCrop
                visible: false
            }

            Rectangle {
                id: mask
                anchors { fill: parent; margins: 18 * fudge }
                color: "black"
                radius: 0.5 * width
                clip: true
                visible: false
            }

            OpacityMask {
                anchors.fill: mask
                source: image
                maskSource: mask
            }
        }
/*
        // Logout button
        Button {
          text: "Logout"
          anchors.horizontalCenter: parent.horizontalCenter

          onClicked: {
            facebook.closeSession()
          }
        }
*/
    }

    Timer
    {
        id: timer
        interval: 3000
        running: false
        repeat: false
        onTriggered: stackView.push(Qt.resolvedUrl("qrc:/qml/content/GridViewPage.qml"))
    }

    // Reload profile as soon as the view gets visible
    onVisibleChanged:
    {
        if (visible)
        {
            facebook.fetchUserDetails()

            timer.running = true
        }
    }
}

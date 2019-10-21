/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.0
import QtMultimedia 5.0

Item {
    id: propertyButton
    property alias value : popup.currentValue
    property alias model : popup.model

    width : 144 * fudge
    height: 70 * fudge
    anchors.centerIn: parent.centerIn

    BorderImage {
        id: buttonImage
        source: "qrc:/qml/images/toolbutton.sci"
        width: propertyButton.width; height: propertyButton.height
    }

    CameraButton {
        anchors.fill: parent
        Image {
            anchors.centerIn: parent
            source: popup.currentItem.icon
        }

        onClicked: popup.toggle()
    }

    CameraPropertyPopup {
        id: popup
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 8 * fudge
        visible: opacity > 0

        currentValue: propertyButton.value

        onSelected: popup.toggle()
    }
}

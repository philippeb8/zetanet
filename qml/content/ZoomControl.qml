/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.0
import QtMultimedia 5.0

Item {
    id : zoomControl
    property real currentZoom : 1
    property real maximumZoom : 1
    signal zoomTo(real value)

    visible: zoomControl.maximumZoom > 1

    MouseArea {
        id : mouseArea
        anchors.fill: parent

        property real initialZoom : 0
        property real initialPos : 0

        onPressed: {
            initialPos = mouseY
            initialZoom = zoomControl.currentZoom
        }

        onPositionChanged: {
            if (pressed) {
                var target = initialZoom * Math.pow(5, (initialPos-mouseY)/zoomControl.height);
                target = Math.max(1, Math.min(target, zoomControl.maximumZoom))
                zoomControl.zoomTo(target)
            }
        }
    }

    Item {
        id : bar
        x : 16
        y : parent.height/4
        width : 24
        height : parent.height/2

        Rectangle {
            anchors.fill: parent

            smooth: true
            radius: 8
            border.color: "white"
            border.width: 2
            color: "black"
            opacity: 0.3
        }

        Rectangle {
            id: groove
            x : 0
            y : parent.height * (1.0 - (zoomControl.currentZoom-1.0) / (zoomControl.maximumZoom-1.0))
            width: parent.width
            height: parent.height - y
            smooth: true
            radius: 8
            color: "white"
            opacity: 0.5
        }

        Text {
            id: zoomText
            anchors {
                left: bar.right; leftMargin: 16
            }
            y: Math.min(parent.height - height, Math.max(0, groove.y - height / 2))
            text: "x" + Math.round(zoomControl.currentZoom * 100) / 100
            font.bold: true
            color: "white"
            style: Text.Raised; styleColor: "black"
            opacity: 0.85
            font.pixelSize: 18
        }
    }
}

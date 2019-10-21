/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.0

Popup {
    id: cameraListPopup

    property alias model : view.model
    property variant currentValue
    property variant currentItem : model[view.currentIndex]

    property int itemWidth : 200 * fudge
    property int itemHeight : 50 * fudge

    width: itemWidth + view.anchors.margins*2
    height: view.count * itemHeight + view.anchors.margins*2

    signal selected

    ListView {
        id: view
        anchors.fill: parent
        anchors.margins: 5 * fudge
        snapMode: ListView.SnapOneItem
        highlightFollowsCurrentItem: true
        highlight: Rectangle { color: "gray"; radius: 5 }
        currentIndex: 0

        delegate: Item {
            width: cameraListPopup.itemWidth
            height: cameraListPopup.itemHeight

            Text {
                text: modelData.displayName

                anchors.fill: parent
                anchors.margins: 5 * fudge
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                color: "white"
                font.bold: true
                style: Text.Raised
                styleColor: "black"
                font.pixelSize: 14 * fudge
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    view.currentIndex = index
                    cameraListPopup.currentValue = modelData.deviceId
                    cameraListPopup.selected(modelData.deviceId)
                }
            }
        }
    }
}

/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.0

Popup {
    id: propertyPopup

    property alias model : view.model
    property variant currentValue
    property variant currentItem : model.get(view.currentIndex)

    property int itemWidth : 100 * fudge
    property int itemHeight : 70 * fudge
    property int columns : 2

    width: columns*itemWidth + view.anchors.margins*2
    height: Math.ceil(model.count/columns)*itemHeight + view.anchors.margins*2 + 25

    signal selected

    function indexForValue(value) {
        for (var i = 0; i < view.count; i++) {
            if (model.get(i).value == value) {
                return i;
            }
        }

        return 0;
    }

    GridView {
        id: view
        anchors.fill: parent
        anchors.margins: 5 * fudge
        cellWidth: propertyPopup.itemWidth
        cellHeight: propertyPopup.itemHeight
        snapMode: ListView.SnapOneItem
        highlightFollowsCurrentItem: true
        highlight: Rectangle { color: "gray"; radius: 5  * fudge }
        currentIndex: indexForValue(propertyPopup.currentValue)

        delegate: Item {
            width: propertyPopup.itemWidth
            height: 70 * fudge

            Image {
                anchors.centerIn: parent
                source: icon
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    propertyPopup.currentValue = value
                    propertyPopup.selected(value)
                }
            }
        }
    }

    Text {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8 * fudge
        anchors.left: parent.left
        anchors.leftMargin: 16 * fudge

        color: "#ffffff"
        font.bold: true
        style: Text.Raised;
        styleColor: "black"
        font.pixelSize: 14 * fudge

        text: view.model.get(view.currentIndex).text
    }
}

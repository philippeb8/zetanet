/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.5

Rectangle
{
    id: root
    //border.bottom: 8
    //source: "images/toolbar.png"
    width: parent.width
    height: 50 * fudge
    color: "transparent"

    signal refresh();

    Rectangle
    {
        id: cancelButton
        width: 30 * fudge
        height: 20 * fudge
        anchors.left: parent.left
        anchors.leftMargin: 20 * fudge
        anchors.verticalCenter: parent.verticalCenter
        color: "transparent"
        scale: cancelButtonMouse.pressed ? 1.2 : 1
        Text
        {
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 14 * fudge
            color: "#32b2e2"
            text: "Cancel"
            font.family: "FontAwesome"

            MouseArea
            {
                id: cancelButtonMouse;
                anchors.fill: parent;
                onClicked: stackView.pop()
            }
        }
    }

    Rectangle
    {
        id: doneButton
        width: 30 * fudge
        height: 20 * fudge
        anchors.right: parent.right
        anchors.rightMargin: 20 * fudge
        anchors.verticalCenter: parent.verticalCenter
        color: "transparent"
        scale: doneButtonMouse.pressed ? 1.2 : 1
        Text
        {
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 14 * fudge
            color: "#32b2e2"
            text: "Done"
            font.family: "FontAwesome"

            MouseArea
            {
                id: doneButtonMouse;
                anchors.fill: parent;
                onClicked: { stackView.pop(); root.refresh(); }
            }
        }
    }
}

/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4

ListView
{
    id: album
    clip: true
    snapMode: ListView.SnapToItem

    orientation: Qt.Horizontal

    model: albumModel

    delegate: Rectangle
    {
        id: background
        width: album.width
        height: width

        Image
        {
            id: image
            anchors.fill: parent
            source: imageUrl
            fillMode: Image.PreserveAspectCrop
            autoTransform: true
            visible: false
        }

        FastBlur
        {
            source: image
            anchors.fill: image

            radius: imageBlur

            MouseArea
            {
                id: imageMouse
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent;
            }
        }

        Image
        {
            id: padlock
            anchors.centerIn: parent
            width: 20 * fudge
            height: 30 * fudge
            source: "qrc:/qml/images/padlock.png"
            fillMode: Image.PreserveAspectCrop
            visible: imageBlur ? true : false
        }
    }

    Image
    {
        id: leftarrow
        anchors.left: album.left
        anchors.verticalCenter: album.verticalCenter
        width: 20 * fudge
        height: 30 * fudge
        source: "qrc:/qml/images/leftarrow.png"
        fillMode: Image.PreserveAspectCrop
        visible: album.atXBeginning ? false : true
    }

    Image
    {
        id: rightarrow
        anchors.right: album.right
        anchors.verticalCenter: album.verticalCenter
        width: 20 * fudge
        height: 30 * fudge
        source: "qrc:/qml/images/rightarrow.png"
        fillMode: Image.PreserveAspectCrop
        visible: album.atXEnd ? false : true
    }
}

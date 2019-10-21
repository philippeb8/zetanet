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

    property string titleText: "CoveCrew"

    signal refresh();

    Rectangle {
        id: backButton
        width: opacity ? 60 * fudge : 0
        height: 20 * fudge
        anchors.left: parent.left
        anchors.leftMargin: 20 * fudge
        anchors.verticalCenter: parent.verticalCenter
        opacity: stackView.depth > 1 ? 1 : 0
        antialiasing: true
        color: "transparent" //backmouse.pressed ? "#222" : "transparent"
        Behavior on opacity { NumberAnimation{} }
        Row
        {
            Text
            {
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 20 * fudge
                color: "#32b2e2"
                text: "\uf053 "
                font.family: "FontAwesome"
            }
            Text
            {
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14 * fudge
                color: "#32b2e2"
                text: "Back"
            }
        }
        MouseArea {
            id: backmouse
            anchors.fill: parent
            //anchors.margins: -10
            onClicked:  { stackView.pop(); root.refresh(); }
        }
    }

    Text
    {
        font.pixelSize: 24 * fudge
        //Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
        //x: backButton.x + backButton.width + 20 * fudge
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "black"
        text: titleText
        font.family: "FontAwesome"
    }

    // quick and dirty menu "button" for this demo (TODO: replace with your own)
    Rectangle
    {
        id: menu_button_
        width: 20 * fudge
        height: 20 * fudge
        anchors.right: parent.right
        anchors.rightMargin: 20 * fudge
        anchors.verticalCenter: parent.verticalCenter
        color: "transparent"
        scale: ma_.pressed ? 1.2 : 1
        Text
        {
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 20 * fudge
            color: "#32b2e2"
            text: "\uf0c9"
            font.family: "FontAwesome"
        }

        MouseArea
        {
            id: ma_;
            anchors.fill: parent;
            onClicked: gv_.onMenu();
        }
    }
}

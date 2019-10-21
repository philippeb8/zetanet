/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.1

Item
{
    id: root
    width: parent.width
    height: parent.height

    property bool showText: true
    property int min: 1000
    property int max: 20000

    property alias range: range

    //property Item pictureMenu: PictureMenu {}

    signal refresh();

    Column
    {
        anchors.fill: parent
        spacing: 8 * fudge

        Text
        {
            text: "Range"
            color: "black"
            font.pixelSize: 20 * fudge
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter
            visible: showText
        }

        Row
        {
            //anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            //spacing: 8 * fudge

            Text
            {
                id: minText
                text: Math.round(min / 1000) + " km"
                color: "black"
                font.pixelSize: 20 * fudge
                renderType: Text.NativeRendering
                //anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }

            Slider
            {
                id: range
                width: root.width - minText.width - maxText.width - 8 * fudge * 4
                //anchors.margins: 20
                //style: sliderStyle
                from : min
                to : max
                value: (max - min) / 2 + min
                snapMode: Slider.SnapOnRelease
                anchors.verticalCenter: parent.verticalCenter

                ToolTip.visible: pressed
                ToolTip.text: "Range (" + Math.round((visualPosition * (to - from) + from) / 10) / 100 + " km)"

                onValueChanged: textTimer.restart();

                Timer
                {
                    id: textTimer
                    interval: 1000
                    onTriggered: root.refresh();
                }
            }

            Text
            {
                id: maxText
                text: Math.round(max / 1000) + " km"
                color: "black"
                font.pixelSize: 20 * fudge
                renderType: Text.NativeRendering
                //anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

/*
    Component
    {
        id: sliderStyle
        SliderStyle {
            handle: Rectangle {
                width: 30 * fudge
                height: 30 * fudge
                radius: height
                antialiasing: true
                color: Qt.lighter("#468bb7", 1.2)
            }

            groove: Item {
                implicitHeight: 30 * fudge
                implicitWidth: 160 * fudge
                Rectangle {
                    height: 8 * fudge
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#444"
                    opacity: 0.8
                    Rectangle {
                        antialiasing: true
                        radius: 1
                        color: "#468bb7"
                        height: parent.height
                        width: parent.width * control.value / control.maximumValue
                    }
                }
            }
        }
    }
*/
}

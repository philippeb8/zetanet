/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

Item
{
    id: root
    width: parent.width
    height: 80 * fudge

    property alias hh: hh
    property alias mm: mm
    property alias meridiem: meridiem

    property alias text: title.text

    Column
    {
        anchors.fill: parent
        spacing: 8 * fudge

        Text
        {
            id: title
            text: "Time"
            color: "black"
            font.pixelSize: 20 * fudge
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row
        {
            id: toe
            anchors.horizontalCenter: parent.horizontalCenter

            SpinBox
            {
                id: hh
                value: 1
                minimumValue: 1
                maximumValue: 12
                font.pixelSize: 20 * fudge
            }
            Text
            {
                text: ":"
                color: "black"
                font.pixelSize: 20 * fudge
                renderType: Text.NativeRendering
            }
            SpinBox
            {
                id: mm
                value: 0
                minimumValue: 0
                maximumValue: 59
                font.pixelSize: 20 * fudge
            }
            Text
            {
                text: " "
                color: "black"
                font.pixelSize: 20 * fudge
                renderType: Text.NativeRendering
            }
            ComboBox
            {
                id: meridiem

                model: [ "AM", "PM" ]
            }
        }
    }
}

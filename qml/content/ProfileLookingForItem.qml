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
    height: parent.height

    property alias lookfordate: lookfordate
    property alias lookforrelationship: lookforrelationship
    property alias lookforencounter: lookforencounter
    property alias lookforarrangement: lookforarrangement
    property alias lookforpartner: lookforpartner
    property alias lookforactivity: lookforactivity

    Column
    {
        anchors.fill: parent;
        spacing: 8 * fudge

        Text
        {
            text: "Looking for"
            color: "black"
            font.pixelSize: 20 * fudge
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter
        }

        CheckBoxItem
        {
            id: lookfordate
            width: parent.width
            height: 42 * fudge

            text: "Date"
            image: false
        }

        CheckBoxItem
        {
            id: lookforrelationship
            width: parent.width
            height: 42 * fudge

            text: "Serious Relationship"
            image: false
        }

        CheckBoxItem
        {
            id: lookforencounter
            width: parent.width
            height: 42 * fudge

            text: "Intimate Encounter"
            image: false
        }

        CheckBoxItem
        {
            id: lookforarrangement
            width: parent.width
            height: 42 * fudge

            text: "Arrangement"
            image: false
        }

        CheckBoxItem
        {
            id: lookforpartner
            width: parent.width
            height: 42 * fudge

            text: "Activity Partners"
            image: false
        }

        CheckBoxItem
        {
            id: lookforactivity
            width: parent.width
            height: 42 * fudge

            text: "Family Activities"
            image: false
        }
    }

    Component {
        id: radioButtonStyle
        RadioButtonStyle {
            label: Item {
                implicitHeight: 50 * fudge
                implicitWidth: 100 * fudge
                Text {
                    text: control.text
                    anchors.verticalCenter: parent.verticalCenter
                    color: "black"
                    font.pixelSize: 16 * fudge
                    renderType: Text.NativeRendering
                }
            }
        }
    }
}

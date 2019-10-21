/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

TextField
{
    id: root
    width: parent.width
    height: parent.height

    signal textUpdated();

    font.pointSize: 16 * fudge
    font.family: "FontAwesome"
    font.italic: true
    //wrapMode: Text.Wrap
    //verticalAlignment: TextInput.AlignTop

    style: TextFieldStyle
    {
        textColor: "black"
        background: Rectangle
        {
            radius: 16 * fudge
            color: "white"
            implicitWidth: 100 * fudge
            implicitHeight: 30 * fudge
            border.width: 1
            border.color: "darkgrey"
        }
    }

    onTextChanged: textTimer.restart();

    Timer
    {
        id: textTimer
        interval: 1000
        onTriggered: root.textUpdated();
    }
}

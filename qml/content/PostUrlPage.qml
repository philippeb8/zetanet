/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.0



IOSPage
{
    id: root
    width: parent.width
    height: parent.height

    signal refresh();

    Column
    {
        anchors.fill: parent;

        DoneToolBarItem
        {
            width: parent.width
            height: 42 * fudge

            onRefresh:
            {
                // index
                var http3 = new XMLHttpRequest();
                var date = new Date(doe.yyyy.value, doe.mm.value, doe.dd.value, toe.hh.value, toe.mm.value, 0);

                http3.open
                (
                    "GET",
                    apiUrl
                    + "insert"
                    + "?address=" + encodeURIComponent(address.text)
                    + "&lat=" + coordinate.latitude
                    + "&lng=" + coordinate.longitude
                    + "&expiration=" + (doe.text !== "" || toe.text !== "" ? encodeURIComponent(doe.text + " " + toe.text) : "")
                    + "&url=" + encodeURIComponent(url.text),
                    false
                );
                http3.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                http3.onreadystatechange = function()
                {
                    if (http3.readyState === XMLHttpRequest.DONE && http3.status === 200)
                    {
                    }
                }
                http3.send();

                root.refresh();
            }
        }

        Flickable
        {
            width: parent.width
            height: parent.height - 42 * fudge
            //horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            contentWidth: parent.width
            contentHeight: email.height + address.height + doe.height + toe.height + url.height + 8 * fudge * 10
            clip: true

            MouseArea
            {
                anchors.fill: parent
                onClicked: Qt.inputMethod.hide();
            }

            Column
            {
                anchors.fill: parent;
                spacing: 8 * fudge

                MessageItem
                {
                    id: email
                    height: 42 * fudge

                    placeholderText: "Email address"
                }

                MessageItem
                {
                    id: address
                    height: 42 * fudge

                    placeholderText: "Current location, address or place"
                }

                Row
                {
                    width: parent.width
                    height: 42 * fudge

                    MessageItem
                    {
                        id: doe
                        width: parent.width - 42 * fudge
                        height: parent.height

                        placeholderText: "Date of expiration (YYYY-MM-DD)"
                    }

                    Button
                    {
                        width: 42 * fudge
                        height: parent.height

                        style: ButtonStyle
                        {
                            label: Text
                            {
                                renderType: Text.NativeRendering
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 14 * fudge
                                text: "..."
                            }

                            background: Rectangle
                            {
                                border.width: control.activeFocus ? 2 : 1
                                border.color: "#888"
                                radius: 16 * fudge
                                gradient: Gradient
                                {
                                    GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                    GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                                }
                            }
                        }

                        onClicked: calendar.open();
                    }
                }

                MessageItem
                {
                    id: toe
                    height: 42 * fudge

                    placeholderText: "Time of expiration (00:00:00)"
                }

                MessageItem
                {
                    id: url
                    height: 42 * fudge

                    placeholderText: "URL"
                }
            }
        }
    }

    CalendarDialog
    {
        id: calendar
        width: parent.width
        minimumDate: new Date();

        onClicked:
        {
            doe.text = Qt.formatDate(date, Qt.ISODate);
        }
    }
}

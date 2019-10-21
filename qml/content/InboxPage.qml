/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.LocalStorage 2.0


IOSPage
{
    id: root
    width: parent.width
    height: parent.height

    signal refresh();

    Column
    {
        //width: parent.width
        anchors.fill: parent

        Rectangle
        {
            width: parent.width
            height: Theme.statusBarHeight
        }

        ToolBarItem
        {
            width: parent.width
            height: 42 * fudge

            titleText: "Messages"

            onRefresh: root.refresh();
        }

        TabView
        {
            //anchors.fill: parent
            width: parent.width
            height: parent.height - 42 * fudge - Theme.statusBarHeight
            style: touchStyle

            Tab
            {
                title: "All"

                InboxItem
                {
                    Component.onCompleted:
                    {
                    }

                    onVoteClicked:
                    {
                        var http = new XMLHttpRequest();

                        http.open("POST", apiUrl + "insertVote.php", true);
                        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                        http.onreadystatechange = function()
                        {
                            if (http.readyState == 4 && http.status == 200)
                            {
                            }
                        }
                        http.send
                        (
                            apiData
                            + "&imageid=" + imageId
                            + "&userid=" + facebook.profile.userId
                            + "&rank=" + vote
                        );
                    }

                    onRefresh:
                    {
                        load();
                    }

                    function load()
                    {
                        list.model.clear()

                        var http = new XMLHttpRequest();

                        http.open("POST", apiUrl + "getInboxForUser.php", true);
                        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                        http.onreadystatechange = function()
                        {
                            if (http.readyState == 4 && http.status == 200)
                            {
                                var raw = JSON.parse(http.responseText);

                                var f = (function()
                                {
                                    var http2 = [];

                                    for (var i = 0; i < raw.length; ++ i)
                                    {
                                        (function (i)
                                        {
                                            http2[i] = new XMLHttpRequest();
                                            http2[i].open("POST", apiUrl + "getVotedImagesForUser.php", true);
                                            http2[i].setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                            http2[i].onreadystatechange = function()
                                            {
                                                if (http2[i].readyState == 4 && http2[i].status == 200)
                                                {
                                                    var raw2 = JSON.parse(http2[i].responseText);
                                                    var http3 = new XMLHttpRequest();

                                                    http3.open("POST", apiUrl + "getNotVotedImagesForUser.php", true);
                                                    http3.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                                    http3.onreadystatechange = function()
                                                    {
                                                        if (http3.readyState == 4 && http3.status == 200)
                                                        {
                                                            var raw3 = JSON.parse(http3.responseText);
                                                            var http4 = new XMLHttpRequest();

                                                            http4.open("POST", apiUrl + "getUserForUser.php", true);
                                                            http4.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                                            http4.onreadystatechange = function()
                                                            {
                                                                if (http4.readyState == 4 && http4.status == 200)
                                                                {
                                                                    var raw4 = JSON.parse(http4.responseText);

                                                                    list.model.append({moreShown: false, dropShown: true, chatShown: true, id: raw[i].toid, userId: raw[i].toid, subjectString: "<b>" + raw4.name + "</b>", albumModel: [], albumMaximised: false, ratioText: "", textString: ""});

                                                                    for (var j = 0; j < raw2.length; ++ j)
                                                                        list.model.get(list.model.count - 1).albumModel.append({imageId: raw2[j].imageid, imageUrl: "image://votes/" + raw2[j].imageid, imageBlur: 0});

                                                                    for (var k = 0; k < raw3.length; ++ k)
                                                                        list.model.get(list.model.count - 1).albumModel.append({imageId: raw3[k].imageid, imageUrl: "image://votes/" + raw3[k].imageid, imageBlur: 64});
                                                                }
                                                            }
                                                            http4.send(apiData + "&userid=" + raw[i].toid);
                                                        }
                                                    }
                                                    http3.send
                                                    (
                                                        apiData
                                                        + "&userid1=" + facebook.profile.userId
                                                        + "&userid2=" + raw[i].toid
                                                    );
                                                }
                                            }
                                            http2[i].send
                                            (
                                                apiData
                                                + "&userid1=" + facebook.profile.userId
                                                + "&userid2=" + raw[i].toid
                                            );
                                        })(i);
                                    }
                                })();
                            }
                        }
                        http.send(apiData + "&userid=" + facebook.profile.userId);
                    }
                }

                onVisibleChanged:
                {
                    if (visible)
                        item.load()
                }
            }

            Tab
            {
                title: "Unread"

                UnreadInboxItem
                {
                    Component.onCompleted:
                    {
                    }

                    onVoteClicked:
                    {
                        var http = new XMLHttpRequest();

                        http.open("POST", apiUrl + "insertVote.php", true);
                        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                        http.onreadystatechange = function()
                        {
                            if (http.readyState == 4 && http.status == 200)
                            {
                            }
                        }
                        http.send
                        (
                            apiData
                            + "&imageid=" + imageId
                            + "&userid=" + facebook.profile.userId
                            + "&rank=" + vote
                        );
                    }

                    onRefresh:
                    {
                        load();
                    }

                    function load()
                    {
                        list.model.clear()

                        var http = new XMLHttpRequest();

                        http.open("POST", apiUrl + "getUnreadInboxForUser.php", true);
                        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                        http.onreadystatechange = function()
                        {
                            if (http.readyState == 4 && http.status == 200)
                            {
                                var raw = JSON.parse(http.responseText);

                                var f = (function()
                                {
                                    var http2 = [];

                                    for (var i = 0; i < raw.length; ++ i)
                                    {
                                        (function (i)
                                        {
                                            http2[i] = new XMLHttpRequest();
                                            http2[i].open("POST", apiUrl + "getVotedImagesForUser.php", true);
                                            http2[i].setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                            http2[i].onreadystatechange = function()
                                            {
                                                if (http2[i].readyState == 4 && http2[i].status == 200)
                                                {
                                                    var raw2 = JSON.parse(http2[i].responseText);
                                                    var http3 = new XMLHttpRequest();

                                                    http3.open("POST", apiUrl + "getNotVotedImagesForUser.php", true);
                                                    http3.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                                    http3.onreadystatechange = function()
                                                    {
                                                        if (http3.readyState == 4 && http3.status == 200)
                                                        {
                                                            var raw3 = JSON.parse(http3.responseText);
                                                            var http4 = new XMLHttpRequest();

                                                            http4.open("POST", apiUrl + "getUserForUser.php", true);
                                                            http4.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                                            http4.onreadystatechange = function()
                                                            {
                                                                if (http4.readyState == 4 && http4.status == 200)
                                                                {
                                                                    var raw4 = JSON.parse(http4.responseText);

                                                                    list.model.append({moreShown: false, dropShown: true, chatShown: true, id: raw[i].toid, userId: raw[i].toid, subjectString: "<b>" + raw4.name + "</b>", albumModel: [], albumMaximised: false, ratioText: "", textString: ""});

                                                                    for (var j = 0; j < raw2.length; ++ j)
                                                                        list.model.get(list.model.count - 1).albumModel.append({imageId: raw2[j].imageid, imageUrl: "image://votes/" + raw2[j].imageid, imageBlur: 0});

                                                                    for (var k = 0; k < raw3.length; ++ k)
                                                                        list.model.get(list.model.count - 1).albumModel.append({imageId: raw3[k].imageid, imageUrl: "image://votes/" + raw3[k].imageid, imageBlur: 64});
                                                                }
                                                            }
                                                            http4.send(apiData + "&userid=" + raw[i].toid);
                                                        }
                                                    }
                                                    http3.send
                                                    (
                                                        apiData
                                                        + "&userid1=" + facebook.profile.userId
                                                        + "&userid2=" + raw[i].toid
                                                    );
                                                }
                                            }
                                            http2[i].send
                                            (
                                                apiData
                                                + "&userid1=" + facebook.profile.userId
                                                + "&userid2=" + raw[i].toid
                                            );
                                        })(i);
                                    }
                                })();
                            }
                        }
                        http.send(apiData + "&userid=" + facebook.profile.userId);
                    }
                }

                onVisibleChanged:
                {
                    if (visible)
                        item.load()
                }
            }
        }

        Component {
            id: touchStyle
            TabViewStyle {
                tabsAlignment: Qt.AlignVCenter
                tabOverlap: 0
                frame: Item { }
                tab: Item {
                    implicitWidth: control.width/control.count
                    implicitHeight: 50 * fudge
                    BorderImage {
                        anchors.fill: parent
                        border.bottom: 8 * fudge
                        border.top: 8 * fudge
                        source: styleData.selected ? "qrc:/qml/images/tab_selected.png":"../images/tabs_standard.png"
                        Text {
                            anchors.centerIn: parent
                            color: "white"
                            text: styleData.title.toUpperCase()
                            font.pixelSize: 12 * fudge
                            font.family: "FontAwesome"
                        }
                        Rectangle {
                            visible: index > 0
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.margins: 10 * fudge
                            width:1
                            color: "#3a3a3a"
                        }
                    }
                }
            }
        }
    }
}

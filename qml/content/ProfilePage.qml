/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

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

            titleText: "Profile"

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
                title: "Pictures"

                PictureItem
                {
                    Component.onCompleted:
                    {
                        var http = new XMLHttpRequest();

                        http.open("POST", apiUrl + "getImagesForUser.php", true);
                        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                        http.onreadystatechange = function()
                        {
                            if (http.readyState == 4 && http.status == 200)
                            {
                                var raw = JSON.parse(http.responseText);

                                for (var i = 0; i < raw.length; ++ i)
                                    list.model.append({moreShown: false, dropShown: true, id: raw[i].imageid, imageId: raw[i].imageid, albumModel: [{imageId: raw[i].imageid, imageUrl: "image://votes/" + raw[i].imageid, imageBlur: 0}], ratioText: ""});
                            }
                        }
                        http.send(apiData + "&userid=" + facebook.profile.userId);
                    }
                }
            }

            Tab
            {
                title: "Info"

                ProfileInfoItem
                {
                    Component.onCompleted:
                    {
                        var http = new XMLHttpRequest();

                        http.open("POST", apiUrl + "getUserForUser.php", true);
                        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                        http.onreadystatechange = function()
                        {
                            if (http.readyState == 4 && http.status == 200)
                            {
                                var raw = JSON.parse(http.responseText);

                                name.text = raw.name;

                                genderMale.checked = raw.gender & 1;
                                genderFemale.checked = raw.gender & 2;

                                var date = Date.fromLocaleDateString(Qt.locale(), raw.dob, "yyyy-M-dd");

                                dobmm.value = date.getUTCMonth();
                                dobdd.value = date.getUTCDate();
                                dobyyyy.value = date.getUTCFullYear();
                                dobshow.checked = raw.dobshow;

                                income.value = raw.income;
                                incomeshow.checked = raw.incomeshow;

                                heightfoot.value = raw.height / 12;
                                heightinch.value = raw.height % 12;
                                heightshow.checked = raw.heightshow;

                                bodytype.currentIndex = raw.bodytype;
                                bodytypeshow.checked = raw.bodytypeshow;
                            }
                        }
                        http.send(apiData + "&userid=" + facebook.profile.userId);
                    }

                    Component.onDestruction:
                    {
                        var http = new XMLHttpRequest();

                        http.open("POST", apiUrl + "insertUserInfo.php", true);
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
                            + "&userid=" + (facebook.profile.userId ? facebook.profile.userId : 0)
                            + "&name=" + encodeURIComponent(name.text)
                            + "&dob=" + encodeURIComponent(new Date(dobyyyy.value, dobmm.value, dobdd.value).toLocaleDateString(Qt.locale(), "yyyy-MM-dd"))
                            + "&dobshow=" + (dobshow.checked ? 1 : 0)
                            + "&dobverified=" + 0
                            + "&gender=" + ((genderMale.checked << 0) | (genderFemale.checked << 1))
                            + "&income=" + income.value
                            + "&incomeshow=" + (incomeshow.checked ? 1 : 0)
                            + "&incomeverified=" + 0
                            + "&height=" + (heightfoot.value * 12 + heightinch.value)
                            + "&heightshow=" + (heightshow.checked ? 1 : 0)
                            + "&heightverified=" + 0
                            + "&bodytype=" + bodytype.currentIndex
                            + "&bodytypeshow=" + (bodytypeshow.checked ? 1 : 0)
                            + "&credit=" + 0
                        );
                    }
                }
            }

            Tab
            {
                title: "Looking for"

                ProfileLookingForItem
                {
                    Component.onCompleted:
                    {
                        var http = new XMLHttpRequest();

                        http.open("POST", apiUrl + "getUserForUser.php", true);
                        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                        http.onreadystatechange = function()
                        {
                            if (http.readyState == 4 && http.status == 200)
                            {
                                var raw = JSON.parse(http.responseText);

                                lookfordate.checked = raw.lookingfordate;
                                lookforrelationship.checked = raw.lookingforrelationship;
                                lookforencounter.checked = raw.lookingforencounter;
                                lookforarrangement.checked = raw.lookingforarrangement;
                                lookforpartner.checked = raw.lookingforpartner;
                                lookforactivity.checked = raw.lookingforactivity;
                            }
                        }
                        http.send(apiData + "&userid=" + (facebook.profile.userId ? facebook.profile.userId : 0));
                    }

                    Component.onDestruction:
                    {
                        var http = new XMLHttpRequest();

                        http.open("POST", apiUrl + "insertUserLookingFor.php", true);
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
                            + "&userid=" + (facebook.profile.userId ? facebook.profile.userId : 0)
                            + "&lookingfordate=" + (lookfordate.checked ? 1 : 0)
                            + "&lookingforrelationship=" + (lookforrelationship.checked ? 1 : 0)
                            + "&lookingforencounter=" + (lookforencounter.checked ? 1 : 0)
                            + "&lookingforarrangement=" + (lookforarrangement.checked ? 1 : 0)
                            + "&lookingforpartner=" + (lookforpartner.checked ? 1 : 0)
                            + "&lookingforactivity=" + (lookforactivity.checked ? 1 : 0)
                        );
                    }
                }
            }

            Tab
            {
                title: "Credits"

                ProfilePurchaseItem {}
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

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1


IOSPage
{
    width: parent.width
    height: parent.height

    signal refresh();

    Column
    {
        anchors.fill: parent;

        Rectangle
        {
            width: parent.width
            height: Theme.statusBarHeight
        }

        DoneToolBarItem
        {
            width: parent.width
            height: 42 * fudge
        }

        TabView
        {
            //anchors.fill: parent
            width: parent.width
            height: parent.height
            style: touchStyle

            Tab
            {
                title: "Info"

                FilterAnonymousInfo {}
            }

            Tab
            {
                title: "Looking for"

                MainChoicePage {}
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

    Component.onDestruction:
    {
        refresh();
    }
}

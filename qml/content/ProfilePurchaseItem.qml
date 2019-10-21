/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import VPlayPlugins 1.0


Item
{
    id: root
    //width: parent.width
    //height: parent.height

  // Copy/paste into csv file for setting up in-app purchases in platform stores
  // Component.onCompleted: console.debug(store.printStoreProductLists())

    Column
    {
        anchors.fill: parent;

        Column {
            anchors.fill: parent;
            //width: parent.width
            //height: parent.height

              // This rectangle represents an ad banner within your app
              Rectangle {
                id: rect
                color: "green"
                width: parent.width
                height: 75

                // Just one line for handling visiblity of the ad banner, you can use property binding for this!
                visible: !noadsGood.purchased

                SequentialAnimation on color {
                  loops: Animation.Infinite
                  ColorAnimation { from: "green"; to: "red"; duration: 300 }
                  ColorAnimation { from: "red"; to: "green"; duration: 300 }
                }

                Text {
                  text: "Annoying Ad"
                  font.pixelSize: 20
                  color: "white"
                  anchors.centerIn: parent
                }
              }

              // Display status text about current inventory
              Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                font.pixelSize: 16
                text: "Nuggets: %1, Shovels: %2".arg(goldCurrency.balance).arg(shovelGood.balance)
              }

              Column {
                spacing: 10
                anchors.centerIn: parent

                Button {
                  text: "Remove ad"
                  anchors.horizontalCenter: parent.horizontalCenter
                  onClicked: store.buyStoreItem(noAdPurchase.productId)
                }

                Row {
                  spacing: 10
                  anchors.horizontalCenter: parent.horizontalCenter

                  // This one is used to reward the user (remove the ad banner) without charging him
                  Button {
                    text: "Give no ads"
                    onClicked: {
                      store.giveItem(noadsGood.itemId)
                    }
                  }

                  // You can take away the the no-ad reward again
                  Button {
                    text: "Take away no ads"
                    onClicked: {
                      store.takeItem(noadsGood.itemId)
                    }
                  }
                }

                // Used to add some spacing
                Item {
                  width: 1
                  height: 10
                }

                Row {
                  spacing: 10
                  anchors.horizontalCenter: parent.horizontalCenter

                  Button {
                    text: "Buy 10 Nuggets"
                    onClicked: {
                      console.debug("Buy 10 Nuggets with id", gold10Pack.itemId)
                      store.buyItem(gold10Purchase.productId)
                    }
                  }

                  Button {
                    text: "Buy 50 Nuggets"
                    onClicked: store.buyItem(gold50Purchase.productId)
                  }
                }

                Item {
                  width: 1
                  height: 10
                }

                Row {
                  spacing: 10
                  anchors.horizontalCenter: parent.horizontalCenter

                  Button {
                    text: "Buy Shovel"
                    onClicked: store.buyItem(shovelGood.itemId)
                  }

                  Button {
                    text: "Buy 5 Shovels"
                    onClicked: store.buyItem(shovelPackGood.itemId)
                  }
                }

                Item {
                  width: 1
                  height: 10
                }

                Button {
                  text: "Dig for Gold"
                  anchors.horizontalCenter: parent.horizontalCenter
                  onClicked: {
                    if (shovelGood.balance > 0) {
                      // Decrease the amount of shovels, as it gets broken while digging
                      store.takeItem(shovelGood.itemId)
                      // TODO: Randomly show or hide the gold animation
                      goldFoundAnimation.start()
                    }
                    else {
                      // Display pop up that there are no shovels left to dig
                      console.debug("Empty Inventory", "You must buy some shovels before being able to dig for gold again")
                    }
                  }
                }

                Item {
                  width: 1
                  height: 10
                }

                // Allow the user to restore the no-add purchase on this platform
                Button {
                  text: "Restore all transactions"
                  anchors.horizontalCenter: parent.horizontalCenter
                  onClicked: store.restoreAllTransactions()
                }
              }

              // Gold Rectangle on top of all other, in case the digging was successful
              Rectangle {
                id: goldFoundRect
                color: "yellow"
                anchors.fill: parent
                opacity: 0

                SequentialAnimation on opacity {
                  id: goldFoundAnimation

                  NumberAnimation { from: 0; to: 1; duration: 200 }
                  NumberAnimation { from: 1; to: 0; duration: 1000 }
                }
              }

              // The actual store implementation, you can also move this into an own QML file if you want
              Store
              {
                id: store

                version: 1
                secret: "your_game_secret"
                androidPublicKey: "your_google_play_public_license_key"

                // Virtual currencies within the game
                currencies: [
                  Currency {
                    id: goldCurrency
                    itemId: "currency_gold_id"
                    name: "Gold Nugget"
                  }
                ]

                // Purchasable currency packs within game
                currencyPacks: [
                  CurrencyPack {
                    id: gold10Pack
                    itemId: "net.vplay.plugins.SoomlaSample.gold_pack_10"
                    name: "10 Gold Nuggets"
                    description: "Buy 10 Gold Nuggets"
                    currencyId: goldCurrency.itemId
                    currencyAmount: 10
                    purchaseType:  StorePurchase { id: gold10Purchase; productId: gold10Pack.itemId; price: 0.89 }
                  },
                  CurrencyPack {
                    id: gold50Pack
                    itemId: "net.vplay.plugins.SoomlaSample.gold_pack_50"
                    name: "50 Gold Nuggets"
                    description: "Buy 50 Gold Nuggets"
                    currencyId: goldCurrency.itemId
                    currencyAmount: 50
                    purchaseType:  StorePurchase { id: gold50Purchase; productId: gold50Pack.itemId; price: 3.99 }
                  }
                ]

                // Goods contain either single-use, single-use-pack or lifetime goods
                goods: [
                  SingleUseGood {
                    id: shovelGood
                    itemId: "net.vplay.plugins.SoomlaSample.shovel_item"
                    name: "Shovel"
                    description: "A shovel to dig for gold nuggets"
                    purchaseType: VirtualPurchase { itemId: goldCurrency.itemId; amount: 8; }
                  },
                  SingleUsePackGood {
                    id: shovelPackGood
                    itemId: "net.vplay.plugins.SoomlaSample.shovelpack_item"
                    name: "5 Shovels"
                    goodItemId: shovelGood.itemId
                    amount: 5
                    purchaseType: VirtualPurchase { itemId: goldCurrency.itemId; amount: 35; }
                  },
                  LifetimeGood {
                    id: noadsGood
                    itemId: "net.vplay.plugins.SoomlaSample.noads"
                    name: "No Ads"
                    description: "Buy this item to remove the app banner"
                    purchaseType: StorePurchase { id: noAdPurchase; productId: noadsGood.itemId; price: 2.99; }
                  }
                ]

                // Following signals are used for debugging purposes

                onSupportedChanged: {
                  console.debug("Billing support changed to", supported)
                }

                onItemPurchased: {
                  console.debug("Item purchased with id:", itemId)

                  if (itemId === shovelGood.itemId || itemId === shovelPackGood.itemId) {
                    // Bought some new shovels
                    console.debug("Bought some new shovels")
                  }
                  else if (itemId === gold10Pack.itemId || itemId === gold50Pack.itemId) {
                    console.debug("Bought some new gold nuggets to purchase new shovels")
                  }
                }

                onStorePurchaseStarted: {
                  console.debug("Store purchases started with id:", itemId)
                }

                onStorePurchaseCancelled: {
                  console.debug("Store purchases cancelled with id:", itemId)
                }

                onStorePurchased: {
                  // We don't output anything here as store purchases are already triggered with onItemPurchased: too
                }

                onRestoreAllTransactionsFinished: {
                  console.debug("Restore all transactions succeeded:", success)
                }

                onRestoreAllTransactionsStarted: {
                  console.debug("Restore all transactions started")
                }

                onItemNotFoundError: {
                  console.debug("Item for transaction not found:", itemId)
                }

                onInsufficientFundsError: {
                  console.debug("Not enough gold nuggets for that one...")

                  console.debug("Out of Gold", "You're out of gold, you can however purchase some nuggets again.")
                }

                onUnexpectedError: {
                  console.debug("Unexpected error while trying to buy an item.")
                }
            /*
                onMarketItemsRefreshStarted: {
                  console.debug("Getting good information from market...")
                }

                onMarketItemsRefreshFinished: {
                  console.debug("Goods from market retrieved.")
                }
            */
              }
        }
    }
}

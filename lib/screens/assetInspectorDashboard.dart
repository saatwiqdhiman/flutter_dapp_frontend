import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:asset_registration/providers/assetRegisterModel.dart';
import 'package:asset_registration/constant/constants.dart';
import 'package:asset_registration/screens/transferOwnership.dart';
import 'package:asset_registration/widget/menu_item_tile.dart';
import 'package:provider/provider.dart';
import '../constant/utils.dart';
import '../providers/MetamaskProvider.dart';
const docurl = '';

class assetInspector extends StatefulWidget {
  const assetInspector({Key? key}) : super(key: key);

  @override
  _assetInspectorState createState() => _assetInspectorState();
}

class _assetInspectorState extends State<assetInspector> {
  var model, model2;
  final colors = <Color>[Colors.indigo, Colors.blue, Colors.orange, Colors.red];
  List<List<dynamic>> userData = [];
  List<List<dynamic>> assetData = [];
  List<List<dynamic>> paymenList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int screen = 0;
  bool isFirstTimeLoad = true;
  dynamic userCount = -1, assetCount = -1;
  bool isLoading = false;

  List<Menu> menuItems = [
    Menu(title: 'Dashboard', icon: Icons.dashboard),
    Menu(title: 'Verify User', icon: Icons.verified_user),
    Menu(title: 'Verify asset', icon: Icons.web),
    Menu(title: 'Transfer Ownership', icon: Icons.transform),
    Menu(title: 'Logout', icon: Icons.logout),
  ];

  getUserCount() async {
    if (connectedWithMetamask) {
      userCount = await model2.userCount();
      assetCount = await model2.assetCount();
    } else {
      userCount = await model.userCount();
      assetCount = await model.assetCount();
    }
    isFirstTimeLoad = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<assetRegisterModel>(context);
    model2 = Provider.of<MetaMaskProvider>(context);
    if (isFirstTimeLoad) {
      getUserCount();
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("assetInspector Dashboard"),
        centerTitle: true,
        backgroundColor: const Color(0xFF272D34),
        leading: isDesktop
            ? Container()
            : GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ), //AnimatedIcon(icon: AnimatedIcons.menu_arrow,progress: _animationController,),
                ),
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
      ),
      drawer: drawer2(),
      drawerScrimColor: Colors.transparent,
      body: Row(
        children: [
          isDesktop ? drawer2() : Container(),
          if (screen == -1) const Center(child: CircularProgressIndicator()),
          if (screen == 0)
            Expanded(
                child: ListView(
              children: [
                Row(
                  children: [
                    _container(0),
                    _container(1),
                    _container(2),
                  ],
                ),
              ],
            ))
          else if (screen == 1)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: userList(),
              ),
            )
          else if (screen == 2)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: assetList(),
              ),
            )
          else if (screen == 3)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: trnasferOwnership(),
              ),
            )
        ],
      ),
    );
  }

  getassetList() async {
    List<dynamic> assetList;
    if (connectedWithMetamask)
      assetList = await model2.allassetList();
    else
      assetList = await model.allassetList();
    List<List<dynamic>> allInfo = [];
    List<dynamic> temp;
    for (int i = 0; i < assetList.length; i++) {
      if (connectedWithMetamask)
        temp = await model2.assetInfo(assetList[i]);
      else
        temp = await model.assetInfo(assetList[i]);
      allInfo.add(temp);
    }
    assetData = allInfo;
    screen = 2;
    print(assetData);
    setState(() {});
  }

  Widget assetList() {
    return ListView.builder(
      itemCount: assetData == null ? 1 : assetData.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Column(
            children: [
              const Divider(
                height: 15,
              ),
              Row(
                children: const [
                  Expanded(
                    child: Text(
                      '#',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                      child: Center(
                        child: Text('Type',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 5),
                  Expanded(
                    child: Center(
                      child: Text('Name',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Price',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Category',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Content Hash.',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Document',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Verify',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  )
                ],
              ),
              const Divider(
                height: 15,
              )
            ],
          );
        }
        index -= 1;
        List<dynamic> data = assetData[index];
        return ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text((index + 1).toString()),
                flex: 1,
              ),
              Expanded(
                  child: Center(
                    child: Text(data[9].toString()),
                  ),
                  flex: 5),
              Expanded(
                  child: Center(
                    child: Text(data[2].toString()),
                  ),
                  flex: 3),
              Expanded(child: Center(child: Text(data[3].toString())), flex: 2),
              Expanded(child: Center(child: Text(data[5].toString())), flex: 2),
              Expanded(child: Center(child: Text(data[6].toString())), flex: 2),
              Expanded(
                  child: Center(
                      child: TextButton(
                    onPressed: () {
                      launchUrl(data[7].toString());
                    },
                    child: const Text(
                      'View Document',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )),
                  flex: 2),
              Expanded(
                  child: Center(
                    child: data[10]
                        ? const Text('Verified')
                        : ElevatedButton(
                            onPressed: () async {
                              SmartDialog.showLoading();
                              try {
                                if (connectedWithMetamask)
                                  await model2.verifyasset(data[0]);
                                else
                                  await model.verifyasset(data[0]);
                                await getassetList();
                              } catch (e) {
                                print(e);
                              }
                              SmartDialog.dismiss();
                            },
                            child: const Text('Verify')),
                  ),
                  flex: 2),
            ],
          ),
        );
      },
    );
  }

  Future<void> getUserList() async {
    setState(() {
      isLoading = true;
    });

    List<dynamic> userList;
    if (connectedWithMetamask)
      userList = await model2.allUsers();
    else
      userList = await model.allUsers();

    List<List<dynamic>> allInfo = [];
    List<dynamic> temp;
    for (int i = 0; i < userList.length; i++) {
      print(userList[i].toString());
      if (connectedWithMetamask)
        temp = await model2.userInfo(userList[i].toString());
      else
        temp = await model.userInfo(userList[i].toString());
      allInfo.add(temp);
    }
    setState(() {
      userData = allInfo;
      screen = 1;
      isLoading = false;
    });
    //return allInfo;
  }

  Widget userList() {
    if (isLoading)
      return const Center(
        child: CircularProgressIndicator(),
      );

    return ListView.builder(
        itemCount: userData == null ? 1 : userData.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                const Divider(
                  height: 15,
                ),
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        '#',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                        child: Center(
                          child: Text('Address',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        flex: 5),
                    Expanded(
                      child: Center(
                        child: Text('Name',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Center(
                        child: Text('Adhar',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Center(
                        child: Text('Pan',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Center(
                        child: Text('Document',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Center(
                        child: Text('Verify',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 2,
                    )
                  ],
                ),
                const Divider(
                  height: 15,
                )
              ],
            );
          }
          index -= 1;
          List<dynamic> data = userData[index];
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text((index + 1).toString()),
                  flex: 1,
                ),
                Expanded(
                    child: Center(
                      child: Text(data[0].toString()),
                    ),
                    flex: 5),
                Expanded(
                    child: Center(
                      child: Text(data[1].toString()),
                    ),
                    flex: 3),
                Expanded(
                    child: Center(child: Text(data[4].toString())), flex: 2),
                Expanded(
                    child: Center(child: Text(data[5].toString())), flex: 2),
                Expanded(
                    child: Center(
                        child: TextButton(
                      onPressed: () {
                        launchUrl(data[6].toString());
                      },
                      child: const Text(
                        'View Document',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )),
                    flex: 2),
                Expanded(
                    child: Center(
                      child: data[8]
                          ? const Text('Verified')
                          : ElevatedButton(
                              onPressed: () async {
                                SmartDialog.showLoading();
                                try {
                                  if (connectedWithMetamask)
                                    await model2.verifyUser(data[0].toString());
                                  else
                                    await model.verifyUser(data[0].toString());
                                  await getUserList();
                                } catch (e) {
                                  print(e);
                                }
                                SmartDialog.dismiss();
                              },
                              child: const Text('Verify')),
                    ),
                    flex: 2),
              ],
            ),
          );
        });
  }

  Future<void> paymentDoneList() async {
    SmartDialog.showLoading();
    try {
      List<dynamic> list;
      if (connectedWithMetamask)
        list = await model2.paymentDoneList();
      else
        list = await model.paymentDoneList();

      List<List<dynamic>> allInfo = [];
      List<dynamic> temp;
      for (int i = 0; i < list.length; i++) {
        if (connectedWithMetamask)
          temp = await model2.requestInfo(list[i]);
        else
          temp = await model.requestInfo(list[i]);
        allInfo.add(temp);
      }
      paymenList = allInfo;
      screen = 3;
    } catch (e) {}
    SmartDialog.dismiss();
    setState(() {});
    //return allInfo;
  }

  Widget trnasferOwnership() {
    return ListView.builder(
        itemCount: paymenList == null ? 1 : paymenList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                const Divider(
                  height: 15,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '#',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      flex: 1,
                    ),
                    const Expanded(
                      child: Text(
                        'Land Id',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      flex: 1,
                    ),
                    const Expanded(
                        child: Center(
                          child: Text('Seller Address',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        flex: 6),
                    const Expanded(
                      child: Center(
                        child: Text('Buyer Address',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 6,
                    ),
                    const Expanded(
                      child: Center(
                        child: Text('Status',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 2,
                    ),
                    const Expanded(
                      child: Center(
                        child: Text('Transfer Ownership',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 3,
                    )
                  ],
                ),
                const Divider(
                  height: 15,
                )
              ],
            );
          }
          index -= 1;
          List<dynamic> data = paymenList[index];
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text((index + 1).toString()),
                  flex: 1,
                ),
                Expanded(
                    child: Center(
                      child: Text(data[3].toString()),
                    ),
                    flex: 1),
                Expanded(
                    child: Center(
                      child: Text(data[1].toString()),
                    ),
                    flex: 6),
                Expanded(
                    child: Center(child: Text(data[2].toString())), flex: 6),
                Expanded(
                    child: Center(
                        child: data[4].toString() == '3'
                            ? const Text('Payment Done')
                            : const Text('Completed')),
                    flex: 2),
                Expanded(
                    child: Center(
                      child: data[4].toString() == '4'
                          ? const Text('Transfered')
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green),
                              onPressed: () async {
                                SmartDialog.showLoading();
                                try {
                                  if (connectedWithMetamask)
                                    await model2.transferOwnership(data[0],docurl);
                                  else
                                    await model.transferOwnership(data[0],docurl);

                                  await paymentDoneList();
                                  showToast("Ownership Transfered",
                                      context: context,
                                      backgroundColor: Colors.green);
                                } catch (e) {
                                  print(e);
                                  showToast("Something Went Wrong",
                                      context: context,
                                      backgroundColor: Colors.red);
                                }
                                SmartDialog.dismiss();
                              },
                              child: const Text('Transfer')),
                    ),
                    flex: 3),
              ],
            ),
          );
        });
  }

  Widget _container(int index) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xFFE7E7E7),
        child: Card(
          color: const Color(0xFFE7E7E7),
          child: Container(
            color: colors[index],
            width: 250,
            height: 140,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0)
                  Row(
                    children: [
                      userCount == -1
                          ? const CircularProgressIndicator()
                          : Text(
                              userCount.toString(),
                              style: const TextStyle(fontSize: 24),
                            ),
                    ],
                  ),
                if (index == 0)
                  const Text(
                    'Total Users Registered',
                    style: TextStyle(fontSize: 20),
                  ),
                if (index == 1)
                  Row(
                    children: [
                      assetCount == -1
                          ? const CircularProgressIndicator()
                          : Text(
                              assetCount.toString(),
                              style: const TextStyle(fontSize: 24),
                            ),
                    ],
                  ),
                if (index == 1)
                  const Text('Total Property Registered',
                      style: TextStyle(fontSize: 20)),
                if (index == 2)
                  const Text('Total Property Transfered ',
                      style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget drawer2() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black26, spreadRadius: 2)
        ],
        color: Color(0xFF272D34),
      ),
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.person,
            size: 50,
          ),
          const SizedBox(
            width: 30,
          ),
          const Text('Inspector',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 80,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, counter) {
                return const Divider(
                  height: 2,
                );
              },
              itemCount: menuItems.length,
              itemBuilder: (BuildContext context, int index) {
                return MenuItemTile(
                  title: menuItems[index].title,
                  icon: menuItems[index].icon,
                  //animationController: _animationController,
                  isSelected: screen == index,
                  onTap: () {
                    if (index == 4) {
                      Navigator.pop(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const home_page()));
                      Navigator.of(context).pushNamed(
                        '/',
                      );
                    }
                    if (index == 0) getUserCount();
                    if (index == 1) getUserList();
                    if (index == 2) getassetList();
                    if (index == 3) paymentDoneList();
                    setState(() {
                      screen = index;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

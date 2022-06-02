import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:asset_registration/providers/assetRegisterModel.dart';
import 'package:asset_registration/constant/constants.dart';
import 'package:asset_registration/widget/menu_item_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../constant/utils.dart';
import '../providers/MetamaskProvider.dart';

class AddassetInspector extends StatefulWidget {
  const AddassetInspector({Key? key}) : super(key: key);

  @override
  _AddassetInspectorState createState() => _AddassetInspectorState();
}

class _AddassetInspectorState extends State<AddassetInspector> {
  late String address, name, age, desig, city, newaddress;
  var model, model2;
  double width = 490;
  int screen = 0;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Menu> menuItems = [
    Menu(title: 'Add asset Inspector', icon: Icons.person_add),
    Menu(title: 'All asset Inspectors', icon: Icons.group),
    Menu(title: 'Change Contract Owner', icon: Icons.change_circle),
    Menu(title: 'Logout', icon: Icons.logout),
  ];

  List<List<dynamic>> allassetInspectorInfo = [];

  @override
  Widget build(BuildContext context) {
    model = Provider.of<assetRegisterModel>(context);
    model2 = Provider.of<MetaMaskProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF272D34),
        leading: isDesktop
            ? Container()
            : GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ), //AnimatedIcon(icon: AnimatedIcons.menu_arrow,progress: _animationController,),
                ),
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
        title: const Text(
          'Add asset Inspector',
        ),
      ),
      drawer: drawer2(),
      drawerScrimColor: Colors.transparent,
      body: Row(
        children: [
          isDesktop ? drawer2() : Container(),
          if (screen == 0)
            addassetInspector()
          else if (screen == 1)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: assetInspectorList(),
              ),
            )
          else if (screen == 2)
            changeContractOwner()
        ],
      ),
    );
  }

  getassetInspectorInfo() async {
    setState(() {
      isLoading = true;
    });
    List<dynamic> assetList;
    if (connectedWithMetamask)
      assetList = await model2.allassetInspectorList();
    else
      assetList = await model.allassetInspectorList();

    List<List<dynamic>> info = [];
    List<dynamic> temp;
    for (int i = 0; i < assetList.length; i++) {
      if (connectedWithMetamask)
        temp = await model2.assetInspectorInfo(assetList[i]);
      else
        temp = await model.assetInspectorInfo(assetList[i]);
      info.add(temp);
    }
    allassetInspectorInfo = info;
    setState(() {
      isLoading = false;
    });
    print(info);
  }

  Widget assetInspectorList() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    return ListView.builder(
      itemCount:
          allassetInspectorInfo == null ? 1 : allassetInspectorInfo.length + 1,
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
                        child: Text('assetInspector\'s Address',
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
                      child: Text('City',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Remove',
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
        List<dynamic> data = allassetInspectorInfo[index];
        return ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text((index + 1).toString()),
                flex: 1,
              ),
              Expanded(
                  child: Center(
                    child: Text(data[1].toString()),
                  ),
                  flex: 5),
              Expanded(
                  child: Center(
                    child: Text(data[2].toString()),
                  ),
                  flex: 3),
              Expanded(
                  child: Center(
                    child: Text(data[5].toString()),
                  ),
                  flex: 2),
              Expanded(
                  child: Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: () async {
                          confirmDialog('Are you sure to remove?', context,
                              () async {
                            SmartDialog.showLoading();
                            if (connectedWithMetamask)
                              await model2.removeassetInspector(data[1]);
                            else
                              await model.removeassetInspector(data[1]);
                            Navigator.pop(context);
                            await getassetInspectorInfo();
                            SmartDialog.dismiss();
                          });
                        },
                        child: const Text('Remove')),
                  ),
                  flex: 2),
            ],
          ),
        );
      },
    );
  }

  Widget changeContractOwner() {
    return Center(
      widthFactor: isDesktop ? 2 : 1,
      child: Container(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              const Text(
                "Change Contract Owner",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    newaddress = val;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                    hintText: 'Enter new Contract Owner Address',
                  ),
                ),
              ),
              CustomButton(
                  'Change',
                  isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            if (connectedWithMetamask)
                              await model2.changeContractOwner(newaddress);
                            else
                              await model.changeContractOwner(newaddress);
                            showToast("Successfully Changed",
                                context: context,
                                backgroundColor: Colors.green);
                          } catch (e) {
                            print(e);
                            showToast("Something Went Wrong",
                                context: context, backgroundColor: Colors.red);
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }),
              isLoading ? const CircularProgressIndicator() : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget addassetInspector() {
    return Center(
      widthFactor: isDesktop ? 2 : 1,
      child: Container(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      address = val;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Address',
                      hintText:
                          'Enter asset Inspector Address(0xc5aEabE793B923981fc401bb8da620FDAa45ea2B)',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      name = val;
                    },
                    //obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Enter Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      age = val;
                    },
                    //obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Age',
                      hintText: 'Enter Age',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      desig = val;
                    },
                    //obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Designation',
                      hintText: 'Enter Designation',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      city = val;
                    },
                    //obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'City',
                      hintText: 'Enter City',
                    ),
                  ),
                ),
                CustomButton(
                    'Add',
                    isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                if (connectedWithMetamask)
                                  await model2.addassetInspector(
                                      address, name, age, desig, city);
                                else
                                  await model.addassetInspector(
                                      address, name, age, desig, city);
                                showToast("Successfully Added",
                                    context: context,
                                    backgroundColor: Colors.green);
                              } catch (e) {
                                print(e);
                                showToast("Something Went Wrong",
                                    context: context,
                                    backgroundColor: Colors.red);
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }),
                isLoading ? const CircularProgressIndicator() : Container()
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
      width: 260,
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
          const Text('Contract Owner',
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
                  isSelected: screen == index,
                  onTap: () {
                    if (index == 3) {
                      Navigator.pop(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => home_page()));
                      Navigator.of(context).pushNamed(
                        '/',
                      );
                    }
                    if (index == 1) getassetInspectorInfo();

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

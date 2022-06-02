import 'package:flutter/material.dart';
import 'package:asset_registration/constant/constants.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../constant/utils.dart';

class viewassetDetails extends StatefulWidget {
  final String allLatitude;
  final String allLongitude;
  final AssetInfo assetinfo;
  const viewassetDetails(
      {Key? key,
      required this.allLatitude,
      required this.allLongitude,
      required this.assetinfo})
      : super(key: key);

  @override
  _viewassetDetailsState createState() => _viewassetDetailsState();
}

class _viewassetDetailsState extends State<viewassetDetails> {
  late MapboxMapController mapController;

  bool isSatelliteView = true;
  //String allLatitude = "17.48444169085768,17.48505567873093,17.48417562880215,17.48395049906658";
  // String allLongitude = "75.29472411820925,75.2966982240448,75.29665530869948,75.2950674409636";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF272D34),
        title: const Text('asset Details'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 500,
                width: 700,
                child: MapboxMap(
                    accessToken: mapBoxApiKey,
                    styleString:
                        "mapbox://styles/saurabhmw/cky4ce7f61b2414nuh9ng177k",
                    initialCameraPosition: CameraPosition(
                      zoom: 3.0,
                      target: const LatLng(19.663280, 75.300293),
                    ),
                    compassEnabled: false,
                    onMapCreated: (MapboxMapController controller) async {
                      List<double> lati = widget.allLatitude
                          .split(',')
                          .map((a) => double.parse(a))
                          .toList();

                      List<double> longi = widget.allLongitude
                          .split(',')
                          .map((a) => double.parse(a))
                          .toList();
                      mapController = controller;

                      await Future.delayed(const Duration(seconds: 3));
                      mapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                        zoom: 15.0,
                        target: LatLng(lati[1], longi[0]),
                      )));
                      for (int i = 0; i < lati.length; i++) {
                        mapController.addCircle(CircleOptions(
                            geometry: LatLng(lati[i], longi[i]),
                            circleRadius: 5,
                            circleColor: "#ff0000",
                            draggable: true));
                      }
                      // mapController.addCircles(List.generate(
                      //     lati.length,
                      //     (index) => CircleOptions(
                      //         geometry: LatLng(lati[index], longi[index]),
                      //         circleRadius: 5,
                      //         circleColor: "#ff0000",
                      //         draggable: false)));
                      //
                      mapController.addFill(
                        FillOptions(
                          fillColor: "#2596be",
                          fillOutlineColor: "#2596be",
                          geometry: [
                            List.generate(lati.length,
                                (index) => LatLng(lati[index], longi[index]))
                          ],
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                  child: Text('Details',
                      style:
                          TextStyle(fontSize: 35, color: Colors.blueAccent))),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(width: 700, child: Divider()),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 700,
                child: Table(
                  columnWidths: const {
                    0: FractionColumnWidth(0.3),
                    1: FractionColumnWidth(0.7)
                  },
                  children: [
                    TableRow(children: [
                      const Text(
                        "Area : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(widget.assetinfo.fileName,
                          style: const TextStyle(fontSize: 20))
                    ]),
                    const TableRow(children: [
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ]),
                    TableRow(children: [
                      const Text(
                        "Owner Address : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(widget.assetinfo.ownerAddress,
                          style: const TextStyle(fontSize: 20))
                    ]),
                    const TableRow(children: [
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ]),
                    TableRow(children: [
                      const Text(
                        "Address : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(widget.assetinfo.fileType,
                          style: const TextStyle(fontSize: 20))
                    ]),
                    const TableRow(children: [
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ]),
                    TableRow(children: [
                      const Text(
                        "Price : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(widget.assetinfo.assetPrice,
                          style: const TextStyle(fontSize: 20))
                    ]),
                    const TableRow(children: [
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ]),
                    TableRow(children: [
                      const Text(
                        "Survey Number : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(widget.assetinfo.contentHash,
                          style: const TextStyle(fontSize: 20))
                    ]),
                    const TableRow(children: [
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ]),
                    TableRow(children: [
                      const Text(
                        "Property Id : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(widget.assetinfo.category,
                          style: const TextStyle(fontSize: 20))
                    ]),
                    const TableRow(children: [
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ]),
                    TableRow(children: [
                      const Text(
                        "Document : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      MaterialButton(
                        onPressed: () {
                          launchUrl(widget.assetinfo.document);
                        },
                        child: const Text('View',
                            style: TextStyle(fontSize: 20, color: Colors.blue)),
                      )
                    ]),
                    const TableRow(children: [
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ])
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

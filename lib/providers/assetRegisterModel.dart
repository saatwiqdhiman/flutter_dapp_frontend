import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:asset_registration/constant/constants.dart' as constant;
import 'package:asset_registration/constant/utils.dart' as utils;
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
//import 'package:web_socket_channel/io.dart';

class assetRegisterModel extends ChangeNotifier {
  final String _rpcUrl = constant.rpcUrl;
  //"https://ropsten.infura.io/v3/e43345b7383246378963be7acd5b6c67";
  //"http://127.0.0.1:7545";
  //"https://rpc-mumbai.maticvigil.com/v1/a5be973518c173bacd9be16a6314dd08b6abcd23"; //"http://127.0.0.1:7545"
  //final String _wsUrl = "wss://rpc-mumbai.maticvigil.com/ws/v1/a5be973518c173bacd9be16a6314dd08b6abcd23";

  String _privateKey = utils.privateKey;

  String contractAddress = constant.contractAddress;
  //"0x5Fa4972AB37701FA32907E79b46DDD436bd73B05";

  int _chainId = constant.chainId;

  late var _client;
  late String _abiCode;
  late var _credentials;
  late EthereumAddress _contractAddress;
  late EthereumAddress _ownAddress;
  late DeployedContract _contract;
  late ContractFunction _addassetInspector;
  late ContractFunction _registerUser;
  late ContractFunction _isassetInspector;
  late ContractFunction _isContractOwner;
  late ContractFunction _isUserRegistered;
  late ContractFunction _makePaymentTest;
  late ContractFunction _allUsers;
  late ContractFunction _userInfo;
  late ContractFunction _verifyUser;
  late ContractFunction _userCount;
  late ContractFunction _DocumentId;
  late ContractFunction _addasset;
  late ContractFunction _myAllassets;
  late ContractFunction _assetInfo;
  late ContractFunction _allassetList,
      _verifyasset,
      _makeforSell,
      _sendRequestToBuy,
      _myReceivedRequest,
      _mySentRequest,
      _requestInfo;
  late ContractFunction _assetCount;
  late ContractFunction _acceptRequest, _rejectRequest;
  late ContractFunction _assetPrice;
  late ContractFunction _makePayment;
  late ContractFunction _paymentDoneList;
  late ContractFunction _transferOwner;
  late ContractFunction _allassetInspectorList,
      _removeassetInspector,
      _assetInspectorInfo,
      _changeContractOwner;

  assetRegisterModel() {
    //initiateSetup();
  }

  Future<void> initiateSetup() async {
    _privateKey = utils.privateKey;
    // _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
    //   return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    // });
    _client = Web3Client(_rpcUrl, Client());

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/contracts/asset.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress = //EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
        EthereumAddress.fromHex(
            contractAddress); //EthereumAddress.fromHex("0xD6af79CcaaCc6e1d747909d7580630aFc69Ff0B8"); //
    //print(_contractAddress);
  }

  Future<void> getCredentials() async {
    print(_privateKey);

    //_credentials = EthPrivateKey.fromHex(_privateKey);
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.address;

    print("Own address" + _ownAddress.toString());
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "asset"), _contractAddress);

    _addassetInspector = _contract.function("addassetInspector");
    _registerUser = _contract.function("registerUser");
    _isassetInspector = _contract.function("isassetInspector");
    _isContractOwner = _contract.function("isContractOwner");
    _isUserRegistered = _contract.function("isUserRegistered");
    _makePaymentTest = _contract.function("makePaymentTestFun");
    _allUsers = _contract.function("ReturnAllUserList");
    _userInfo = _contract.function("UserMapping");
    _verifyUser = _contract.function("verifyUser");
    _userCount = _contract.function("userCount");
    _DocumentId = _contract.function("documentId");
    _addasset = _contract.function("addasset");
    _myAllassets = _contract.function("myAllassets");
    _assetInfo = _contract.function("assets");
    _allassetList = _contract.function("ReturnAllassetList");
    _verifyasset = _contract.function("verifyasset");
    _makeforSell = _contract.function("makeItforSell");
    _sendRequestToBuy = _contract.function("requestforBuy");
    _myReceivedRequest = _contract.function("myReceivedassetRequests");
    _mySentRequest = _contract.function("mySentassetRequests");
    _requestInfo = _contract.function("assetRequestMapping");
    _assetCount = _contract.function("assetsCount");
    _acceptRequest = _contract.function("acceptRequest");
    _rejectRequest = _contract.function("rejectRequest");
    _assetPrice = _contract.function("assetPrice");
    _makePayment = _contract.function("makePayment");
    _paymentDoneList = _contract.function("returnPaymentDoneList");
    _transferOwner = _contract.function("transferOwnership");

    _allassetInspectorList = _contract.function("ReturnAllassetIncpectorList");
    _removeassetInspector = _contract.function("removeassetInspector");
    _assetInspectorInfo = _contract.function("InspectorMapping");
    _changeContractOwner = _contract.function("changeContractOwner");
  }

  Future<List<dynamic>> assetInspectorInfo(dynamic _addr) async {
    final val = await _client.call(
        sender: _ownAddress,
        contract: _contract,
        function: _assetInspectorInfo,
        params: [_addr]);
    //print(val);
    return val;
  }

  removeassetInspector(dynamic id) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _removeassetInspector,
            parameters: [
              id,
            ]),
        chainId: _chainId,
        fetchChainIdFromNetworkId: false);
  }

  Future<List<dynamic>> allassetInspectorList() async {
    final val = await _client.call(
        sender: _ownAddress,
        contract: _contract,
        function: _allassetInspectorList,
        params: []);
    //print(val);
    return val[0];
  }

  changeContractOwner(dynamic addr) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _changeContractOwner,
            parameters: [
              EthereumAddress.fromHex(addr),
            ]),
        chainId: _chainId,
        fetchChainIdFromNetworkId: false);
  }

  makeTestPayment() async {
    notifyListeners();
    double price = 0.1;
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _makePaymentTest,
            parameters: [
              EthereumAddress.fromHex(
                  '0xa9Ae3838F49564314D9453810FA31665FD8d94D5')
            ],
            value: EtherAmount.fromUnitAndValue(
                EtherUnit.wei, (price * pow(10, 18)).toString())),
        chainId: _chainId,
        fetchChainIdFromNetworkId: false);
    print("Test payment done");
  }

  transferOwnership(dynamic reqId, String docUrl) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _transferOwner,
          parameters: [reqId, docUrl],
        ),
        chainId: _chainId,
        fetchChainIdFromNetworkId: false);
    print("Ownership Transfered");
  }

  Future<List<dynamic>> paymentDoneList() async {
    final val = await _client.call(
        sender: _ownAddress,
        contract: _contract,
        function: _paymentDoneList,
        params: []);
    //print(val);
    return val[0];
  }

  makePayment(dynamic reqId, dynamic price) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _makePayment,
            parameters: [reqId],
            value: EtherAmount.fromUnitAndValue(
                EtherUnit.wei, (price * pow(10, 18)).toString())),
        chainId: _chainId,
        fetchChainIdFromNetworkId: false);
  }

  Future<dynamic> assetPrice(dynamic assetId) async {
    final val = await _client.call(
        sender: _ownAddress,
        contract: _contract,
        function: _assetPrice,
        params: [assetId]);
    //print(val);
    return val[0];
  }

  acceptRequest(dynamic reqId) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _acceptRequest,
            parameters: [
              reqId,
            ]),
        chainId: _chainId,
        fetchChainIdFromNetworkId: false);
  }

  rejectRequest(dynamic reqId) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _rejectRequest,
            parameters: [
              reqId,
            ]),
        chainId: _chainId,
        fetchChainIdFromNetworkId: false);
  }

  Future<List<dynamic>> requestInfo(dynamic requestId) async {
    final val = await _client.call(
        sender: _ownAddress,
        contract: _contract,
        function: _requestInfo,
        params: [requestId]);
    //print(val);
    return val;
  }

  Future<List<dynamic>> mySentRequest() async {
    final val = await _client.call(
        sender: _ownAddress,
        contract: _contract,
        function: _mySentRequest,
        params: []);
    //print(val);
    return val[0];
  }

  Future<List<dynamic>> myReceivedRequest() async {
    final val = await _client.call(
        sender: _ownAddress,
        contract: _contract,
        function: _myReceivedRequest,
        params: []);
    //print(val);
    return val[0];
  }

  sendRequestToBuy(dynamic assetId) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _sendRequestToBuy,
            parameters: [
              assetId,
            ]),
        chainId: _chainId,
        fetchChainIdFromNetworkId: false);
  }

  makeForSell(dynamic id) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _makeforSell,
            parameters: [
              id,
            ]),
        chainId: _chainId,
        fetchChainIdFromNetworkId: false);
  }

  Future<List<dynamic>> assetInfo(dynamic id) async {
    final val = await _client.call(
        sender: _ownAddress,
        contract: _contract,
        function: _assetInfo,
        params: [id]);
    //print(val);
    return val;
  }

  verifyasset(dynamic id) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _verifyasset,
            parameters: [
              id,
            ]),
        chainId: _chainId,
        fetchChainIdFromNetworkId: false);
  }

  Future<List<dynamic>> allassetList() async {
    final val = await _client.call(
        sender: _ownAddress,
        contract: _contract,
        function: _allassetList,
        params: []);
    //print(val);
    return val[0];
  }

  isContractOwner(String address) async {
    final val = await _client.call(
        sender: _ownAddress,
        contract: _contract,
        function: _isContractOwner,
        params: [_ownAddress]);
    print(val);
    return val[0];
  }

  Future<List<dynamic>> myAllassets() async {
    final val = await _client.call(
        contract: _contract, function: _myAllassets, params: [_ownAddress]);
    print(val);
    return val[0];
  }

  addasset(String fileName, String assetAddress, String description,
      String assetPrice, String category, String contentHash, String docu) async {
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _addasset,
            parameters: [
              fileName,
              assetAddress,
              BigInt.parse(assetPrice),
              description,
              category,
              contentHash,
              docu
            ]),
        chainId: _chainId,
        fetchChainIdFromNetworkId: false);
  }

  Future<dynamic> assetCount() async {
    notifyListeners();
    final val = await _client
        .call(contract: _contract, function: _assetCount, params: []);
    print(val);
    return val[0];
  }

  Future<dynamic> userCount() async {
    notifyListeners();
    final val = await _client
        .call(contract: _contract, function: _userCount, params: []);
    print(val);
    return val[0];
  }

  Future<dynamic> documentId() async {
    notifyListeners();
    final val = await _client
        .call(contract: _contract, function: _DocumentId, params: []);
    print(val);
    return val[0].toString();
  }

  Future<List<dynamic>> allUsers() async {
    notifyListeners();
    final val = await _client
        .call(contract: _contract, function: _allUsers, params: []);
    print(val);
    return val[0];
  }

  verifyUser(String address) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _verifyUser,
            parameters: [
              EthereumAddress.fromHex(address),
            ]),
        chainId: _chainId,
        fetchChainIdFromNetworkId: false);
  }

  Future<List<dynamic>> userInfo(String address) async {
    notifyListeners();
    final val =
        await _client.call(contract: _contract, function: _userInfo, params: [
      EthereumAddress.fromHex(address),
    ]);
    print(val);
    return val;
  }

  Future<List<dynamic>> myProfileInfo() async {
    notifyListeners();
    final val =
        await _client.call(contract: _contract, function: _userInfo, params: [
      _ownAddress,
    ]);
    print(val);
    return val;
  }

  addassetInspector(String address, String name, String age, String desig,
      String city) async {
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _addassetInspector,
            parameters: [
              EthereumAddress.fromHex(address),
              name,
              BigInt.parse(age),
              desig,
              city
            ]),
        chainId: _chainId,
        fetchChainIdFromNetworkId: false);
  }

  isassetInspector(String address) async {
    final val = await _client.call(
        contract: _contract, function: _isassetInspector, params: [_ownAddress]);
    return val[0];
  }

  isUserregistered() async {
    final val = await _client.call(
        contract: _contract,
        function: _isUserRegistered,
        params: [_ownAddress]);
    return val[0];
  }

  registerUser(String name, String age, String city, String adhar, String phone,
      String document, String email) async {
    notifyListeners();

    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _registerUser,
            parameters: [
              name,
              BigInt.parse(age),
              city,
              adhar,
              phone,
              document,
              email
            ]),
        chainId: _chainId,
        fetchChainIdFromNetworkId: false);
  }
}

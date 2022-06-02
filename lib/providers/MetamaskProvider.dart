import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:asset_registration/constant/constants.dart' as constant;

class MetaMaskProvider extends ChangeNotifier {
  static const operatingChain = constant.chainId;

  String contractAddress = constant.contractAddress;
  //"0x5Fa4972AB37701FA32907E79b46DDD436bd73B05";

  String currentAddress = '';

  int currentChain = -1;

  bool get isEnabled => ethereum != null;

  bool get isInOperatingChain => currentChain == operatingChain;

  bool get isConnected => isEnabled && currentAddress.isNotEmpty;

  //final rpcProvider = JsonRpcProvider('https://rpc-mumbai.maticvigil.com/v1/a5be973518c173bacd9be16a6314dd08b6abcd23');

  var contract;

  final abi = [
    // Some details about the token

    "function ReturnAllUserList() public view returns(address[] memory)",
    "function isUserRegistered(address _addr) public view returns(bool)",
    "function makePaymentTestFun(address payable _reveiver) public payable",
    "function UserMapping(address) public view returns(address id,string name,uint age,string city,string aadharNumber,string phoneNumber,string document,string email,bool isUserVerified)",
    "function addasset(string memory _fileName, string memory _fileType, uint assetPrice,string memory _description, string memory _category,string memory _contentHash, string memory _document) public",
    "function myAllassets(address id) public view returns( uint[] memory)",
    "function assets(uint) public view returns(uint id,string memory fileName,string fileType,uint assetPrice,string description,string memory category,string contentHash,string document,bool isforSell,address payable ownerAddress,bool isassetVerified)",
    "function ReturnAllassetList() public view returns(uint[] memory)",
    "function makeItforSell(uint id) public",
    "function requestforBuy(uint _assetId) public",
    "function myReceivedassetRequests() public view returns(uint[] memory)",
    "function mySentassetRequests() public view returns(uint[] memory)",
    "function assetRequestMapping(uint) public view returns(uint reqId,address payable sellerId,address payable buyerId,uint assetId,uint8 requestStatus,bool isPaymentDone)",
    "function acceptRequest(uint _requestId) public",
    "function rejectRequest(uint _requestId) public",
    "function registerUser(string memory _name, uint _age, string memory _city,string memory _aadharNumber, string memory _phoneNumber, string memory _document, string memory _email) public",
    "function makePayment(uint _requestId) public payable",
    "function addassetInspector(address _addr,string memory _name, uint _age, string memory _designation,string memory _city) public returns(bool)",
    "function isContractOwner(address _addr) public view returns(bool)",
    "function isassetInspector(address _id) public view returns (bool)",
    "function userCount() public view returns(uint)",
    "function documentId() public view returns(uint)",
    "function assetsCount() public view returns(uint)",
    "function verifyUser(address _userId) public",
    "function verifyasset(uint _id) public",
    "function returnPaymentDoneList() public view returns(uint[] memory)",
    "function transferOwnership(uint _requestId,string memory documentUrl) public returns(bool)",
    "function assetPrice(uint id) public view returns(uint)",
    "function changeContractOwner(address _addr)public",
    "function ReturnAllassetIncpectorList() public view returns(address[] memory)",
    "function removeassetInspector(address _addr) public",
    "function InspectorMapping(address) public view returns(uint id,address _addr,string name,uint age,string designation,string city)"
  ];

  Future<void> connect() async {
    if (isEnabled) {
      final accs = await ethereum!.requestAccount();
      if (accs.isNotEmpty) currentAddress = accs.first;
      print(currentAddress);
      currentChain = await ethereum!.getChainId();
      print(currentChain);

      // Get signer from provider
      // final signer = provider!.getSigner();
      // var t = await signer.getBalance();

      contract = Contract(
        contractAddress,
        Interface(abi),
        provider!.getSigner(),
      );
      notifyListeners();
    }
  }

  sendtrans() async {
    final tx = await provider!.getSigner().sendTransaction(
          TransactionRequest(
            to: '0xf9949ED609523b1F550094E6c19Be80e6DBE38F1',
            value: BigInt.from(100000),
          ),
        );
  }

  clear() {
    currentAddress = '';
    currentChain = -1;
    notifyListeners();
  }

  init() {
    if (isEnabled) {
      ethereum!.onAccountsChanged((accounts) {
        clear();
      });
      ethereum!.onChainChanged((accounts) {
        clear();
      });
    }
  }

  Future<dynamic> readFunction(String funName, List<String> param) async {
    final val = await contract.call<dynamic>(funName, param);
    print(val);
    return val;
  }

  writeFunctionCall(String funName, List<String> param) async {
    await contract.send(funName, param);
  }

  Future<bool> isUserRegistered() async {
    final t =
        await contract.call<dynamic>('isUserRegistered', [currentAddress]);
    print(t);
    return t;
  }

  Future<List<dynamic>> myProfileInfo() async {
    final t = await contract.call<dynamic>('UserMapping', [currentAddress]);
    print(t);
    return t;
  }

  addasset(String fileName, String fileType, String description,
      String assetPrice, String category, String contentHash, String docu) async {
    await contract.send(
      'addasset',
      [fileName, fileType, assetPrice, description, category, contentHash, docu],
    );
  }

  Future<List<dynamic>> myAllassets() async {
    final val = await contract.call<dynamic>('myAllassets', [currentAddress]);
    print(val);
    return val;
  }

  Future<List<dynamic>> assetInfo(dynamic id) async {
    final val = await contract.call<dynamic>('assets', [id.toString()]);
    print(val);
    return val;
  }

  Future<List<dynamic>> allassetList() async {
    final val = await contract.call<dynamic>('ReturnAllassetList', []);
    print(val);
    return val;
  }

  Future<List<dynamic>> assetInspectorInfo(dynamic addr) async {
    final val =
        await contract.call<dynamic>('InspectorMapping', [addr.toString()]);
    print(val);
    return val;
  }

  Future<List<dynamic>> allassetInspectorList() async {
    final val = await contract.call<dynamic>('ReturnAllassetIncpectorList', []);
    print(val);
    return val;
  }

  changeContractOwner(dynamic id) async {
    await contract.send(
      'changeContractOwner',
      [id.toString()],
    );
  }

  removeassetInspector(dynamic id) async {
    await contract.send(
      'removeassetInspector',
      [id.toString()],
    );
  }

  makeForSell(dynamic id) async {
    await contract.send(
      'makeItforSell',
      [id.toString()],
    );
  }

  sendRequestToBuy(dynamic assetId) async {
    await contract.send(
      'requestforBuy',
      [assetId.toString()],
    );
  }

  Future<List<dynamic>> myReceivedRequest() async {
    final val = await contract.call<dynamic>('myReceivedassetRequests', []);
    print(val);
    return val;
  }

  Future<List<dynamic>> mySentRequest() async {
    final val = await contract.call<dynamic>('mySentassetRequests', []);
    print(val);
    return val;
  }

  Future<List<dynamic>> requestInfo(dynamic requestId) async {
    final val = await contract
        .call<dynamic>('assetRequestMapping', [requestId.toString()]);
    //print(val);
    return val;
  }

  acceptRequest(dynamic reqId) async {
    await contract.send(
      'acceptRequest',
      [reqId.toString()],
    );
  }

  rejectRequest(dynamic reqId) async {
    await contract.send(
      'rejectRequest',
      [reqId.toString()],
    );
  }

  registerUser(String name, String age, String city, String adhar, String phone,
      String document, String email) async {
    await contract.send(
      'registerUser',
      [name, age, city, adhar, phone, document, email],
    );
  }

  makePayment(dynamic reqId, dynamic price) async {
    final tx = await contract.send(
      'makePayment',
      [reqId.toString()],
      TransactionOverride(
        value: BigInt.from(price * pow(10, 18)),
      ),
    );
  }

  Future<bool> isContractOwner() async {
    final val =
        await contract.call<dynamic>('isContractOwner', [currentAddress]);
    print(val);
    return val;
  }

  Future<bool> isassetInspector() async {
    final val =
        await contract.call<dynamic>('isassetInspector', [currentAddress]);
    print(val);
    return val;
  }

  addassetInspector(String address, String name, String age, String desig,
      String city) async {
    await contract.send('addassetInspector', [address, name, age, desig, city]);
  }

  Future<dynamic> assetCount() async {
    return await readFunction('assetsCount', []);
  }

  Future<dynamic> userCount() async {
    return await readFunction('userCount', []);
  }

  Future<dynamic> documentId() async {
    var val = await readFunction('documentId', []);
    return val.toString();
  }

  verifyUser(String address) async {
    await writeFunctionCall('verifyUser', [address]);
  }

  verifyasset(dynamic id) async {
    await writeFunctionCall('verifyasset', [id.toString()]);
  }

  Future<List<dynamic>> allUsers() async {
    List<dynamic> temp = await readFunction('ReturnAllUserList', []);
    return temp;
  }

  Future<List<dynamic>> paymentDoneList() async {
    List<dynamic> temp = await readFunction('returnPaymentDoneList', []);
    return temp;
  }

  transferOwnership(dynamic reqId, String docUrl) async {
    final val =
        await contract.send('transferOwnership', [reqId.toString(), docUrl]);
    print(val);
    return val;
  }

  Future<List<dynamic>> userInfo(String address) async {
    final val = await contract.call<dynamic>('UserMapping', [address]);
    print(val);
    return val;
  }

  Future<dynamic> assetPrice(dynamic assetId) async {
    final val = await contract.call<dynamic>('assetPrice', [assetId.toString()]);
    print(val);
    return val;
  }

  makeTestPayment() async {
    final tx = await contract.send(
      'makePaymentTestFun',
      ['0xa9Ae3838F49564314D9453810FA31665FD8d94D5'],
      TransactionOverride(
        value: BigInt.from(10000000000),
      ),
    );
    print("Test payment done");
  }
}

// ignore_for_file: invalid_use_of_protected_member
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:my_wallet/ui/base/base_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class WalletService extends ChangeNotifier {
  late final WalletConnect _connector;
  late Uri uriMetaMask;
  late EthereumWalletConnectProvider provider;
  late Uint8List data;

  WalletConnect get connector => _connector;

  static WalletService getInstance() => WalletService._();

  WalletService._();

  Future<WalletConnect> initWalletConnect() async {
    // final sessionStorage = WalletConnectSecureStorage();
    // final session = await sessionStorage.getSession();

    _connector = WalletConnect(
      // session: session,
      // sessionStorage: sessionStorage,
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'WalletConnect',
        description: 'WalletConnect Developer App',
        url: 'https://walletconnect.org',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );

    provider = EthereumWalletConnectProvider(_connector);
    _connector.on('connect', (session) {
      print("123123 connect");
      notifyListeners();
    });
    _connector.on('session_update', (payload) {
      print("123123 ${_connector.session.accounts}");

      notifyListeners();
    });
    // _connector.on('call_request', (event) => print("123123 event ${event}"));
    _connector.on('disconnect', (session) => print(session));
    return _connector;
  }

  Future<void> walletConnect() async {
    if (!_connector.connected) {
      await _connector.connect(onDisplayUri: (uri) async {
        uriMetaMask = Uri.parse(uri);
        await launchUrl(uriMetaMask);
      });
    }
  }

  Future<void> killSession() async {
    _connector.killSession();
  }

  Future<String> sendTransaction() async {
    final Transaction transaction = await getTransaction();
    await launchUrl(uriMetaMask);
    return await provider.sendTransaction(
      from: transaction.from!.hex,
      to: transaction.to?.hex,
      value: transaction.value?.getInWei,
    );
  }

  Web3Client getWeb3Client() {
    // https://rinkeby.infura.io/v3/f6118b2becea41eeb9f29e8ee57095ec
    // https://data-seed-prebsc-1-s2.binance.org:8545
    var apiUrl =
        "https://rinkeby.infura.io/v3/f6118b2becea41eeb9f29e8ee57095ec";
    return Web3Client(apiUrl, Client());
  }

  Future<Transaction> getTransaction() async {
    Web3Client web3client = getWeb3Client();
    EtherAmount gas = await web3client.getGasPrice();
    BigInt maxGas = await web3client.estimateGas(
      sender: EthereumAddress.fromHex(connector.session.accounts[0]),
      to: EthereumAddress.fromHex(connector.session.accounts[0]),
    );
    return Transaction(
      from: EthereumAddress.fromHex(connector.session.accounts[0]),
      to: EthereumAddress.fromHex(connector.session.accounts[0]),
      // gasPrice: gas,
      // maxGas: int.parse(maxGas.toString()),
      value: EtherAmount.fromUnitAndValue(EtherUnit.wei, 7),
    );
  }

  Future<String> signTransaction() async {
    // final Transaction transaction = await getTransaction();
    // await launchUrl(uriMetaMask);
    // connector.session.approve(params)
    final res = await provider.personalSign(
        address: connector.session.accounts[0],
        message: 'hello',
        password: "hungkute");
    print("123123 ${res}");
    List<int> list = res.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    data = bytes;
    return 'provider.sendRawTransaction()';
  }
}

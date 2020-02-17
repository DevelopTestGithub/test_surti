

import 'package:flutter/material.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';
import 'package:surtiSP/util/persistency/discounts_persistency.dart';
import 'package:surtiSP/util/persistency/products_persistency.dart';

enum SyncState {
  GETTING_DATA,
  CONNECTING,
  SYNCED,
}

class SyncGate extends StatefulWidget{

  SyncGate();

  SyncGateState createState() => SyncGateState();
}

class SyncGateState extends State<SyncGate>{

  SyncGateState();

  SyncState syncStateKey = SyncState.GETTING_DATA;
  bool productsReady = false;
  bool ready = false;

  @override
  void initState() {
    _syncProcess();
    super.initState();
  }

  _updateMachineState(){

    switch(syncStateKey){

      case SyncState.GETTING_DATA:
        // TODO: Handle this case.
        break;
      case SyncState.CONNECTING:
        setState(() {
          productsReady = true;
        });

        break;
      case SyncState.SYNCED:
        // TODO: Handle this case.
        break;
    }
  }

  _syncProcess()async{
    //TODO: Implement sync process.


    await _getRemoteData();

  }

  _getRemoteData()async{

    ProductsP products = await ProductsP();
    print('EL PRODUCT SP SI ENTRA ---------------');
    await products.init('29', context);
    print('${products.products().toString()}');

    DiscountsP discounts = await DiscountsP();
    await discounts.init(context);
    print('${discounts.discounts().toString()}');

    syncStateKey = SyncState.CONNECTING;
    _updateMachineState();
  }

  Widget _syncVisual(){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '- Recolectando datos...',
          style: Style.SMALLER_B_W,
        ),
        Visibility(
          visible: productsReady,
          child: Text(
            '- Paquetes listos.',
            style: Style.SMALLER_B_W,
          ),
        ),

        //TODO: Implement rest of the process.

        Visibility(
          visible: ready,
          child: Text(
              'LISTO!'
          ),
        ),

      ],
    );

  }

  @override
  Widget build(BuildContext context) {

    return  Opacity(
        opacity: 1,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[

              Text(
                T.SYNC,
                style: Style.MEDIUM_M_W,
                textAlign: TextAlign.center,
              ),
              Container(
                height: 75,
                width: 75,
                //padding: EdgeInsets.symmetric(vertical: 15),
                child: CircularProgressIndicator(),
              ),

              GestureDetector(
                onTap: () {
                  //TODO: Implement cancel.
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Cancelar',
                      style: Style.MEDIUM_M_W,
                    ),
                  ),
                ),
              ),

              _syncVisual(),

            ],
        ),
    );
  }

}
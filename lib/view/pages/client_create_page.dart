import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/api/client_api.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/clients.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/models/location_point.dart';
import 'package:surtiSP/models/shipping.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/view/common/button_user.dart';
import 'package:surtiSP/view/common/textField.dart';
import 'package:surtiSP/view/common/toasts.dart';
import 'package:surtiSP/view/loadding/order_loading.dart';
import 'package:surtiSP/view/pages/location_page.dart';
import 'package:surtiSP/view/s_screen.dart';
import 'package:surtiSP/wrappers/location.dart';

class CreateClientPage extends SScreen {
  Client placeModelToTurnCreatePageIntoModifyPage;
  VoidCallback updateClient;
  VoidCallback updateListClient;

  CreateClientPage({this.placeModelToTurnCreatePageIntoModifyPage = null, this.updateClient, this.updateListClient}){
    if (updateClient == null) {
      updateClient = () {};
    }
    if (updateListClient == null){
      updateListClient = (){};
    }

  }

  _CreateClientPageState createState() => _CreateClientPageState();
}

class _CreateClientPageState extends SurtiState<CreateClientPage> {
  _CreateClientPageState();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final businessNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final idController = TextEditingController();
  final referenceController = TextEditingController();
  final latController = TextEditingController();
  final lonController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final firstNameKey = UniqueKey();
  final lastNameKey = UniqueKey();
  final businessNameKey = UniqueKey();
  final phoneNumberKey = UniqueKey();
  final addressKey = UniqueKey();
  final emailKey = UniqueKey();
  final idKey = UniqueKey();
  final referenceKey = UniqueKey();

  bool _autoValidate = false;
  bool _isLoading = false;
  bool isLocationReady = false;

  LocationPoint location = LocationPoint(lat: 0, long: 0);

  void initState() {
    super.initState();
    LocationSearcher.getCurrentLocation((position) {
      print("lo0cat = ${position.success}");
      print(position.location.lat);
      print(position.location.long);
      if (position.success) {
        setState(() {
          location = position.location;
          isLocationReady = true;
          latController.text = position.location.lat.toString();
          lonController.text = position.location.long.toString();
          location.lat = position.location.lat;
          location.long = position.location.long;
        });
      } else {
        //HANDLE
      }
    });

    /* Si hay modelo el app  */
    if (widget.placeModelToTurnCreatePageIntoModifyPage != null) {
      var model = widget.placeModelToTurnCreatePageIntoModifyPage;
      firstNameController.text = model.firstName;
      lastNameController.text = model.lastName;
      businessNameController.text = model.businessName;
      if (model.shippingAddress != null) {
        phoneNumberController.text = "0${model.shippingAddress.phoneNumber}";
        addressController.text = model.shippingAddress.address1;
        emailController.text = model.shippingAddress.email;
        idController.text = model.ruc.toString();
        referenceController.text = model.shippingAddress.reference;
        latController.text = model.shippingAddress.latitud.toString();
        lonController.text = model.shippingAddress.longitud.toString();
      }
    }
  }

  Widget _inputFieldColumn(
    String _fieldName,
    String _hintText,
    UniqueKey _key,
    TextEditingController _controller,
    TextInputType _keyBord,
    List<TextInputFormatter> _formatter,
    Function _validate,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: <Widget>[
          Text(
            _fieldName,
            style: Style.MEDIUM_WHITE,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: textField(
              _hintText,
              _key,
              _controller,
              _keyBord,
              _formatter,
              _validate,
            ),
          ),
        ],
      ),
    );
  }

  String _emptyValidator(String value) {
    return null;
//    if (value.length == 0)
//      return 'Campo no puede estar vacío';
//    else
//      return null;
  }

  String _validateEmail(String value) {
    return null;
//    Pattern pattern =
//        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//    RegExp regex = new RegExp(pattern);
//    if (!regex.hasMatch(value))
//      return 'Ingrese email válido';
//    else
//      return null;
  }

  String _validatePhoneNumber(String _value) {
    if (10 == _value.length || 0 == _value.length) {
      return null;
    } else {
      return 'Telefono debe ser 10 digitos';
    }
  }

  String _validateCI(String _value) {
    if (10 == _value.length || 13 == _value.length || 0 == _value.length) {
      return null;
    } else {
      return 'Cedula 10 digitos, RUC 13 dígitos';
    }
  }

  Widget _createClientForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Style.GATTER_PADDING),
      child: Form(
        key: formKey,
        autovalidate: _autoValidate,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    'Nombre del Cliente',
                    style: Style.MEDIUM_WHITE,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: textField(
                                'Nombre',
                                firstNameKey,
                                firstNameController,
                                TextInputType.text,
                                [],
                                _emptyValidator,
                              ),
                            )),
                        Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: textField(
                                'Apellido',
                                lastNameKey,
                                lastNameController,
                                TextInputType.text,
                                [],
                                _emptyValidator,
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _inputFieldColumn(
              'Cedula/Pasaporte',
              'Identificación',
              idKey,
              idController,
              TextInputType.number,
              [WhitelistingTextInputFormatter.digitsOnly],
              _validateCI,
            ),
            _inputFieldColumn(
              'Email',
              'email',
              emailKey,
              emailController,
              TextInputType.text,
              [],
              _validateEmail,
            ),
            _inputFieldColumn(
              'Nombre del Local',
              'Nombre del local',
              businessNameKey,
              businessNameController,
              TextInputType.text,
              [],
              _emptyValidator,
            ),
            _inputFieldColumn(
              'Número de Celular',
              'Celular',
              phoneNumberKey,
              phoneNumberController,
              TextInputType.phone,
              [WhitelistingTextInputFormatter.digitsOnly],
              _validatePhoneNumber,
            ),
            _inputFieldColumn(
              'Dirección',
              'Direccón del negocio',
              addressKey,
              addressController,
              TextInputType.text,
              [],
              _emptyValidator,
            ),
            _inputFieldColumn(
              'Referencia',
              'Referencia geográfica al local',
              referenceKey,
              referenceController,
              TextInputType.text,
              [],
              _emptyValidator,
            ),
            isLocationReady
                ? Container(
                    width: MyApp.screenWidth,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            'Ubicación GPS',
                            style: Style.MEDIUM_M_W,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(children: [
                              Text(
                                "Lat: " + latController.text,
                                style: Style.MINI_B_W,
                              ),
                              Text(
                                "Lon: " + lonController.text,
                                style: Style.MINI_B_W,
                              ),
                            ]),
                            UserBtn(
                              callback: () {
                                UserController.me.currentId =
                                    UserController.me.promosId;
                                Navigator.of(context).push(
                                  PageTransition(
                                    curve: Curves.easeOutCirc,
                                    type: PageTransitionType.slideLeft,
                                    child: LocationPage((locationRequest) {
                                      setState(() {
                                        latController.text = locationRequest
                                            .location.lat
                                            .toString();
                                        lonController.text = locationRequest
                                            .location.long
                                            .toString();
                                            location.lat = locationRequest
                                            .location.lat;
                                            location.long = locationRequest
                                            .location.long;
                                      });
                                    }),
                                    duration: const Duration(milliseconds: 200),
                                  ),
                                );
                              },
                              active: this.isLocationReady ? true : false,
                              text: "Alinear GPS",
                              width: (MyApp.screenWidth -
                                      Style.GATTER_PADDING * 2) /
                                  3,
                              height: MyApp.screenHeight / 9,
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                : Text(
                    'Localización no lista',
                    style: Style.MEDIUM_M_W,
                  ),
            SizedBox(
              height: 10,
            ),
            (widget.placeModelToTurnCreatePageIntoModifyPage != null)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UserBtn(
                      callback: _modifyClient,
                      active: this.isLocationReady ? true : false,
                      text: "Modificar Cliente",
                      width: (MyApp.screenWidth - Style.GATTER_PADDING * 2) / 3,
                      height: MyApp.screenHeight / 9,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UserBtn(
                      callback: _createClient,
                      active: this.isLocationReady ? true : false,
                      text: "Crear Cliente",
                      width: (MyApp.screenWidth - Style.GATTER_PADDING * 2) / 3,
                      height: MyApp.screenHeight / 9,
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  bool _validateInputs() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    } else {
      setState(() {
        _autoValidate = true;
      });
      return false;
    }
  }

  Widget _creatingClient() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            T.LOADING_CREATE_CLIENT,
            style: Style.SMALL_B_W,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: OrderLoading(
              type: OrderLoadingType.ORDER,
            ),
          )
        ],
      ),
    );
  }

  _modifyClient() async {
    if (_validateInputs()) {
      ShippingAddress _shippingAddress = new ShippingAddress(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phoneNumber: phoneNumberController.text,
        address1: addressController.text,
        reference: referenceController.text,
        latitud: location.lat,
        longitud: location.long,
      );

      if ("" != _shippingAddress.phoneNumber) {
        _shippingAddress.phoneNumber =
            _shippingAddress.phoneNumber.substring(1);
      }

      print("ID CONTROLLER ${idController.text}");

      Client _client2Create = new Client(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        ruc: idController.text,
        email: emailController.text,
        businessName: businessNameController.text,
        shippingAddress: _shippingAddress,
      );

      setState(() {
        _isLoading = true;
      });

      ClientBasicCreate params =
          new ClientBasicCreate(_client2Create, _shippingAddress);

      var _id = await ClientApi.modifyBasicClient(
          "${widget.placeModelToTurnCreatePageIntoModifyPage.id}",
          params,
          context);

      if (null != _id) {
        Toasts.shortMessage('Cliente modificado exitosamente!');
        widget.updateClient();
      } else {
        Toasts.shortMessage('Hubo error modificando cliente');
      }

      backButton();

      setState(() {
        _isLoading = false;
      });
    }
  }

  _createClient() async {
    print('Guardar Cliente');

    if (_validateInputs()) {
      ShippingAddress _shippingAddress = new ShippingAddress(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phoneNumber: phoneNumberController.text,
        address1: addressController.text,
        reference: referenceController.text,
        latitud: location.lat,
        longitud: location.long,
      );

      if ("" != _shippingAddress.phoneNumber) {
        _shippingAddress.phoneNumber =
            _shippingAddress.phoneNumber.substring(1);
      }

      print("ID CONTROLLER ${idController.text}");

      Client _client2Create = new Client(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        ruc: idController.text,
        email: emailController.text,
        businessName: businessNameController.text,
        shippingAddress: _shippingAddress,
      );

      setState(() {
        _isLoading = true;
      });

      ClientBasicCreate params =
          new ClientBasicCreate(_client2Create, _shippingAddress);
      int _id = await ClientApi.createBasicClient(params, context);

      if (null != _id) {
        Toasts.shortMessage('El cliente fue guardado correctamente');
        widget.updateListClient();
      } else {
        Toasts.shortMessage('El cliente no se pudo guardar');
      }

      backButton();

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildExternal(
        backgroundColor: CS.DEEP_SEA_BLUE,
        mainHeaderColor: Colors.white,
        updateCartDetection: false,
        callbackBackButton: backButton,
        nativeAndroidButtonCallback: backButton,
        forceCartButtonInnactive: true,
        enableMainHeader: true,
        mainHeaderOverlayed: false,
        resizeToAvoidBottomInset: false,
        child: _isLoading
            ? _creatingClient()
            : SafeArea(
                child: Scrollbar(child: _createClientForm()),
              ));
  }

  void backButton() {
    Navigator.of(context).pop();
  }
}

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/ui.dart';
import '../models/address_model.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class AuthService extends GetxService {
  final user = User().obs;
  final address = Address().obs;
  FirebaseMessaging _firebaseMessaging;
  GetStorage _box;

  UserRepository _usersRepo;

  AuthService() {
    _usersRepo = new UserRepository();
    _box = new GetStorage();
  }

  Future<AuthService> init() async {
    address.listen((Address _address) {
      _box.write('current_address', _address.toJson());
    });
    user.listen((User _user) {
      address.value.userId = _user.id;
      _box.write('current_user', _user.toJson());
    });
    await getCurrentUser();
    await getAddress();
    return this;
  }

  void setDeviceToken() {
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.value.deviceToken = _deviceToken;
    }).catchError((e) {
      print('Notification not configured');
    });
  }

  Future getCurrentUser() async {
    if (user.value.auth == null && _box.hasData('current_user')) {
      user.value = User.fromJson(await _box.read('current_user'));
      user.value.auth = true;
    } else {
      user.value.auth = false;
    }
  }

  Future removeCurrentUser() async {
    user.value = new User();
    await _usersRepo.signOut();
    await _box.remove('current_user');
  }

  Future getAddress() async {
    try {
      if (_box.hasData('current_address')) {
        address.value = Address.fromJson(await _box.read('current_address'));
      } else if (isAuth) {
        List<Address> _addresses = await _usersRepo.getAddresses();
        if (_addresses.isNotEmpty) {
          address.value = _addresses.firstWhere((_address) => _address.isDefault, orElse: () {
            return _addresses.first;
          });
        } else {
          address.value = new Address(address: "Please choose your address".tr);
        }
      } else {
        address.value = new Address(address: "Please choose your address".tr);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool get isAuth => user.value.auth ?? false;

  String get apiToken => (user.value.auth ?? false) ? user.value.apiToken : '';
}

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app5/models/referral_model.dart';
import 'package:app5/services/referral_service.dart';

class ReferralProvider with ChangeNotifier {
  bool _referral = false;
  bool get referral => _referral;
  ReferralService service = ReferralService();

  ReferralProvider() {
    getReferral();
  }

  Future<void> getReferral() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _referral = prefs.getBool('referral') ?? false;
    notifyListeners();
  }

  Future<void> toggle(bool value) async {
    _referral = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('referral', _referral);
    notifyListeners();
  }

  ReferralModel _referraldata = ReferralModel();
  ReferralModel get referraldata => _referraldata;

  Future<void> getReferralData({
    required String id,
    required String tokenss,
  }) async {
    try {
      _referraldata = await service.getReferralData(id: id, tokenss: tokenss);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  ReferralDashboardModel _referraldashboard = ReferralDashboardModel();
  ReferralDashboardModel get referraldashboard => _referraldashboard;

  Future<void> getDashboard({
    required String id,
    required String tokenss,
  }) async {
    try {
      _referraldashboard = await service.getDashboard(id: id, tokenss: tokenss);
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}

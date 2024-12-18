import 'package:flutter/material.dart';
import 'package:app5/models/school_rating_model.dart';
import 'package:app5/services/school_rating_service.dart';

class SchoolRatingProvider with ChangeNotifier {
  SchoolRatingService service = SchoolRatingService();
  SchoolRatingModel? _rating;
  SchoolRatingModel? get rating => _rating;

  Future<void> getRate({required String token, required String npsn}) async {
    try {
      _rating = await service.getRating(token: token, npsn: npsn);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<SchoolReviewerModel> _reviewer = [];
  List<SchoolReviewerModel> get reviewer => _reviewer;

  Future<void> getReviewer(
      {required String token, required String npsn}) async {
    try {
      _reviewer = await service.getReviewer(token: token, npsn: npsn);
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}

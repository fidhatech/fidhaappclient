import 'dart:developer';
import 'package:dating_app/core/network/http/dio_client.dart';
import 'package:dating_app/core/widgets/offer_popup_card/promotion_model.dart';
import 'package:dio/dio.dart';

class PopupOfferService {
  final Dio _dio = DioClient.instance;

  Future<PromotionResponse> fetchPopupOffer() async {
    try {
      final response = await _dio.get('/user/promotion/popup-offer');
      log("Popup Offer Response: ${response.data}");
      return PromotionResponse.fromJson(response.data);
    } on DioException catch (e) {
      log("Popup Offer Error: $e");
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch popup offer: $e');
    }
  }
}

import 'package:flutter/material.dart';

class WebViewProvider with ChangeNotifier {
  String _currentUrl = 'https://www.crazygames.com/';
  bool _isLoading = false;
  String? _error;
  final List<String> _urls = [
    'https://www.crazygames.com/',
    'https://www.agame.com/',
  ];

  String get currentUrl => _currentUrl;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get urls => _urls;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void updateUrl(String url) {
    _currentUrl = url;
    _error = null;
    notifyListeners();
  }

  void setError(String errorMessage) {
    _error = errorMessage;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

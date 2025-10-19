import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Bridge to the native Rust library
class NativeBridge {
  late ffi.DynamicLibrary _lib;
  bool _isInitialized = false;

  /// Initialize the native library
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Load the native library
    if (Platform.isAndroid) {
      _lib = ffi.DynamicLibrary.open('liblh_mobile_bridge.so');
    } else if (Platform.isIOS) {
      _lib = ffi.DynamicLibrary.process();
    } else {
      throw UnsupportedError('Platform not supported');
    }

    // Get the application documents directory for the database
    final appDir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(appDir.path, 'language_helper.db');

    // Initialize the Rust app
    final initApp = _lib.lookupFunction<
        ffi.Bool Function(ffi.Pointer<Utf8>),
        bool Function(ffi.Pointer<Utf8>)>('init_app');

    final dbPathPtr = dbPath.toNativeUtf8();
    final success = initApp(dbPathPtr);
    calloc.free(dbPathPtr);

    if (!success) {
      throw Exception('Failed to initialize native library');
    }

    _isInitialized = true;
  }

  /// Free a string returned from the native library
  void _freeString(ffi.Pointer<Utf8> ptr) {
    final free = _lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<Utf8>),
        void Function(ffi.Pointer<Utf8>)>('free_string');
    free(ptr);
  }

  /// Call a native function and get JSON response
  String _callNative(String functionName, [String? param1, String? param2, String? param3]) {
    final func = _lib.lookupFunction<
        ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>),
        ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>)>(functionName);

    final param1Ptr = param1?.toNativeUtf8() ?? ffi.nullptr.cast<Utf8>();
    final param2Ptr = param2?.toNativeUtf8() ?? ffi.nullptr.cast<Utf8>();
    final param3Ptr = param3?.toNativeUtf8() ?? ffi.nullptr.cast<Utf8>();

    final resultPtr = func(param1Ptr, param2Ptr, param3Ptr);
    final result = resultPtr.toDartString();

    if (param1 != null) calloc.free(param1Ptr);
    if (param2 != null) calloc.free(param2Ptr);
    if (param3 != null) calloc.free(param3Ptr);
    _freeString(resultPtr);

    return result;
  }

  // ===== User Management =====

  String getUsernames() {
    final func = _lib.lookupFunction<
        ffi.Pointer<Utf8> Function(),
        ffi.Pointer<Utf8> Function()>('get_usernames');

    final resultPtr = func();
    final result = resultPtr.toDartString();
    _freeString(resultPtr);
    return result;
  }

  String getUserByUsername(String username) {
    final func = _lib.lookupFunction<
        ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>),
        ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>)>('get_user_by_username');

    final usernamePtr = username.toNativeUtf8();
    final resultPtr = func(usernamePtr);
    final result = resultPtr.toDartString();

    calloc.free(usernamePtr);
    _freeString(resultPtr);
    return result;
  }

  String createUser(String username, String language) {
    final func = _lib.lookupFunction<
        ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>),
        ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>)>('create_user');

    final usernamePtr = username.toNativeUtf8();
    final languagePtr = language.toNativeUtf8();
    final resultPtr = func(usernamePtr, languagePtr);
    final result = resultPtr.toDartString();

    calloc.free(usernamePtr);
    calloc.free(languagePtr);
    _freeString(resultPtr);
    return result;
  }

  String deleteUser(String username) {
    final func = _lib.lookupFunction<
        ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>),
        ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>)>('delete_user');

    final usernamePtr = username.toNativeUtf8();
    final resultPtr = func(usernamePtr);
    final result = resultPtr.toDartString();

    calloc.free(usernamePtr);
    _freeString(resultPtr);
    return result;
  }

  // ===== Profile Management =====

  String createProfile(String username, String profileName, String targetLanguage) {
    final func = _lib.lookupFunction<
        ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>),
        ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>)>('create_profile');

    final usernamePtr = username.toNativeUtf8();
    final profileNamePtr = profileName.toNativeUtf8();
    final targetLanguagePtr = targetLanguage.toNativeUtf8();
    final resultPtr = func(usernamePtr, profileNamePtr, targetLanguagePtr);
    final result = resultPtr.toDartString();

    calloc.free(usernamePtr);
    calloc.free(profileNamePtr);
    calloc.free(targetLanguagePtr);
    _freeString(resultPtr);
    return result;
  }

  String deleteProfile(String username, String profileName) {
    final func = _lib.lookupFunction<
        ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>),
        ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>)>('delete_profile');

    final usernamePtr = username.toNativeUtf8();
    final profileNamePtr = profileName.toNativeUtf8();
    final resultPtr = func(usernamePtr, profileNamePtr);
    final result = resultPtr.toDartString();

    calloc.free(usernamePtr);
    calloc.free(profileNamePtr);
    _freeString(resultPtr);
    return result;
  }

  // ===== App Settings =====

  String getAppSettings() {
    final func = _lib.lookupFunction<
        ffi.Pointer<Utf8> Function(),
        ffi.Pointer<Utf8> Function()>('get_app_settings');

    final resultPtr = func();
    final result = resultPtr.toDartString();
    _freeString(resultPtr);
    return result;
  }

  // Add more wrapper methods for other FFI functions as needed...
}

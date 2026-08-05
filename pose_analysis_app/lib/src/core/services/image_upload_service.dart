import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ai_sports_training/src/core/config/cloudinary_config.dart';

class ImageUploadService {
  final ImagePicker _picker = ImagePicker();

  Future<Map<String, dynamic>?> pickImageBytes() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (file == null) return null;

    final bytes = await file.readAsBytes();

    return {
      'bytes': bytes,
      'name': file.name,
    };
  }

  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
    int maxRetries = 3,
  }) async {
    Exception? lastError;

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        return await _doUpload(bytes, fileName);
      } on Exception catch (e) {
        lastError = e;
        if (attempt < maxRetries) {
          await Future.delayed(Duration(seconds: attempt * 2));
        }
      }
    }

    throw lastError ?? Exception('Upload failed after $maxRetries attempts');
  }

  Future<String> _doUpload(Uint8List bytes, String fileName) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(CloudinaryConfig.uploadUrl),
    );

    request.fields['upload_preset'] = CloudinaryConfig.uploadPreset;
    request.fields['folder'] = 'profile';

    if (CloudinaryConfig.isSigned) {
      request.fields['api_key'] = CloudinaryConfig.apiKey;
    }

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: fileName,
    ));

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 60),
      onTimeout: () => throw TimeoutException(
        'Upload timed out. Check your network connection.',
      ),
    );

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(
        'Cloudinary upload failed (${response.statusCode}): ${body['error']?['message'] ?? response.body}',
      );
    }

    final data = jsonDecode(response.body);
    final url = data['secure_url'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception('Cloudinary returned no URL');
    }

    return url;
  }

  static String? extractPublicId(String url) {
    final regex = RegExp(r'/upload/(?:v\d+/)?(.+)\.\w+$');
    final match = regex.firstMatch(url);
    return match?.group(1);
  }

  Future<void> deleteImage(String url) async {
    try {
      final publicId = extractPublicId(url);
      if (publicId == null) return;

      final headers = <String, String>{};
      if (CloudinaryConfig.isSigned) {
        const credentials =
            '${CloudinaryConfig.apiKey}:${CloudinaryConfig.apiSecret}';
        headers['Authorization'] =
            'Basic ${base64Encode(utf8.encode(credentials))}';
      }

      await http
          .post(
            Uri.parse(CloudinaryConfig.destroyUrl),
            headers: headers,
            body: {
              'public_id': publicId,
              if (!CloudinaryConfig.isSigned)
                'upload_preset': CloudinaryConfig.uploadPreset,
            },
          )
          .timeout(const Duration(seconds: 15));
    } catch (_) {}
  }
}

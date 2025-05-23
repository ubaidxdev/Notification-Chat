import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryFunctions {
  static const _cloudName =
      'dvjexk4lk'; // Replace with your Cloudinary cloud name
  static const _upload = "upload";
  static const _destroy = "destroy";
  final _url = 'https://api.cloudinary.com/v1_1/$_cloudName/';
  final _apiKey = '	972184791919216'; // Replace with your Cloudinary API key
  final _uploadPreset =
      'andlzzoq'; // Set up an unsigned upload preset in Cloudinary

  //  UPLOADIMAGE TO CLOUDINARY
  Future<String> uploadImageToCloudinary(File imageFile) async {
    final request = http.MultipartRequest('POST', Uri.parse("$_url$_upload"));

    // Add fields to the request
    request.fields['upload_preset'] = _uploadPreset;

    // Attach the image file
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
    ));
    // Send the request
    final response = await request.send();
    String imageUrl = "";
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final data = jsonDecode(responseData.body);
      imageUrl = data["secure_url"];
      print("-----------------------");
      print('Upload successful: $data');
      print("-----------------------");
    } else {
      imageUrl = "";
      print("-----------------------");
      print('Upload failed with status: ${response.statusCode}');
      print("-----------------------");
    }
    return imageUrl;
  }

  Future<void> deleteImageFromUrl(String imageUrl) async {
    const apiSecret =
        'ePS3MCijUoh3O6oC7oDKds9UwRs'; // Replace with your Cloudinary API secret

    // Extract public_id from the URL
    final regex = RegExp(r'/upload/(.*)\.');
    final match = regex.firstMatch(imageUrl);

    if (match == null || match.group(1) == null) {
      print('Invalid Cloudinary URL');
      return;
    }

    final publicId = match.group(1)!;

    // API URL
    final url = Uri.parse("${_url}resources/image/$_destroy");

    // Basic Authentication header
    final authHeader =
        'Basic ${base64Encode(utf8.encode('$_apiKey:$apiSecret'))}';

    // Send the delete request
    final response = await http.post(
      url,
      headers: {
        'Authorization': authHeader,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'public_id': publicId}),
    );

    if (response.statusCode == 200) {
      print('Image deleted successfully: ${response.body}');
    } else {
      print('Failed to delete image: ${response.statusCode}, ${response.body}');
    }
  }
}

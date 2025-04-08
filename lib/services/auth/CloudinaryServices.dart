// uploading files to cloudinary
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloudinary_dart/transformation/delivery/delivery.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/delivery/delivery_actions.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled1/services/auth/DatabaseServices.dart'; // For accessing device directories
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'dart:html' as html;

Future<String?> optimizeImage(String imagePath) async {
  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  String apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
  String apiSecret = dotenv.env['CLOUDINARY_SECRET_KEY'] ?? '';

  Cloudinary cloudinary = Cloudinary.fromCloudName(cloudName: cloudName);

  // Upload the image to Cloudinary and get the optimized URL
  final optimizedUrl = cloudinary.image(imagePath).transformation(
      Transformation()
          .delivery(Delivery.quality(Quality.auto()) as DeliveryAction)
          .delivery(Delivery.format(Format.auto) as DeliveryAction));

  return optimizedUrl.toString();
}

Future<bool> uploadToCloudinary(
    FilePickerResult? filePickerResult, String modelclassID) async {
  if (filePickerResult == null || filePickerResult.files.isEmpty) {
    print("No file selected!");
    return false;
  }

  File file = File(filePickerResult.files.single.path!);

  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';

  // Create a MultipartRequest to upload the file
  var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/upload");
  var request = http.MultipartRequest("POST", uri);

  Uint8List? fileBytes = filePickerResult.files.first.bytes;

  var multipartFile = http.MultipartFile.fromBytes(
    'file', // The form field name for the file
    fileBytes as List<int>,
    filename: file.path.split("/").last, //The file name to send in the request
  );

  // Add the file part to the request
  request.files.add(multipartFile);

  request.fields['upload_preset'] = "preset-for-file-upload";
  request.fields['resource_type'] = "auto";

  // Send the request and await the response
  var response = await request.send();

  // Get the response as text
  var responseBody = await response.stream.bytesToString();

  // Print the response
  print(responseBody);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(responseBody);
    Map<String, String> requiredData = {
      "name": filePickerResult.files.first.name,
      "id": jsonResponse["public_id"],
      "extension": filePickerResult.files.first.extension!,
      "size": jsonResponse["bytes"].toString(),
      "url": jsonResponse["secure_url"],
      "created_at": jsonResponse["created_at"],
      "description": "nothing",
    };

    await DbService().saveUploadedFilesData(requiredData, modelclassID);
    print("Upload successful!");
    return true;
  } else {
    print("Upload failed with status: ${response.statusCode}");
    return false;
  }
}

// delete specific file from cloudinary
Future<bool> deleteFromCloudinary(String publicId) async {
  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ??
      ''; // Replace with your Cloudinary cloud name
  String apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
  String apiSecret = dotenv.env['CLOUDINARY_SECRET_KEY'] ?? '';

  // Generate the timestamp
  int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  // Prepare the string for signature generation
  String toSign = 'public_id=$publicId&timestamp=$timestamp$apiSecret';

  // Generate the signature using SHA1
  var bytes = utf8.encode(toSign);
  var digest = sha1.convert(bytes);
  String signature = digest.toString();
  // Prepare the request URL
  var uri =
      Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/raw/destroy');

  // Create the request
  var response = await http.post(
    uri,
    body: {
      'public_id': publicId,
      'timestamp': timestamp.toString(),
      'api_key': apiKey,
      'signature': signature,
    },
  );

  if (response.statusCode == 200) {
    var responseBody = jsonDecode(response.body);
    // print(responseBody);
    if (responseBody['result'] == 'ok') {
      print("File deleted successfully.");
      // Delete the file from Firestore
      // DbService().deleteFile(publicId, true);
      return true;
    } else {
      print("Failed to delete the file.");
      return false;
    }
  } else {
    print(
        "Failed to delete the file, status: ${response.statusCode} : ${response.reasonPhrase}");
    return false;
  }
}

// download the user file inside the download folder
Future<bool> downloadFileFromCloudinary(String url, String fileName) async {
  // try {
  //   // Request storage permission
  //   var status = await Permission.storage.request();
  //   var manageStatus = await Permission.manageExternalStorage.request();
  //   // FlutterWebBrowser.openWebPage(url: url);
  //   //   print("Opening file in a new tab...");
  //   //   return true;
  //   if (status == PermissionStatus.granted &&
  //       manageStatus == PermissionStatus.granted) {
  //     // The user has granted both permissions, so proceed
  //     print("Storage permissions granted");
  //   } else {
  //     // The user has permanently denied one or both permissions, so open the settings
  //     await openAppSettings();
  //   }

  //   // Get the Downloads directory
  //   Directory? downloadsDir = Directory('/storage/emulated/0/Download');
  //   if (!downloadsDir.existsSync()) {
  //     print("Downloads directory not found");
  //     return false;
  //   }

  //   // Create the file path
  //   String filePath = '${downloadsDir.path}/$fileName';

  //   // Make the HTTP GET request
  //   var response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     // Write file to Downloads folder
  //     File file = File(filePath);
  //     await file.writeAsBytes(response.bodyBytes);

  //     print("File downloaded successfully! Saved at: $filePath");
  //     return true;
  //   } else {
  //     print("Failed to download file. Status code: ${response.statusCode}");
  //     return false;
  //   }
  // } catch (e) {
  //   print("Error downloading file: $e");
  //   return false;
  // }

  try {
    // 🔹 Fetch file data from Cloudinary
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;

      // 🔹 Create a Blob (binary large object) in the browser
      final blob = html.Blob([bytes]);

      // 🔹 Generate a temporary URL for the file
      final url = html.Url.createObjectUrlFromBlob(blob);

      // 🔹 Create a hidden anchor (<a>) tag with the download link
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", fileName) // Set file name
        ..click(); // Auto-click to start download

      // 🔹 Revoke the temporary URL to free up memory
      html.Url.revokeObjectUrl(url);

      print("✅ Download started: $fileName");
      return true;
    } else {
      print("❌ Failed to download file. Status: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("❌ Error downloading file: $e");
    return false;
  }
}

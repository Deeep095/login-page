import 'package:cloudinary_dart/transformation/delivery/delivery.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/delivery/delivery_actions.dart';
import 'package:cloudinary_url_gen/transformation/effect/effect.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:cloudinary_url_gen/transformation/rotate.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


var cloudinary = Cloudinary.fromCloudName(
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '');

String TransformVideo(String videoURL) {
  cloudinary.video(videoURL).transformation(Transformation()
      .delivery(Delivery.quality(Quality.auto()) as DeliveryAction)
      .delivery(Delivery.format(Format.auto) as DeliveryAction));

  return cloudinary.video(videoURL).toString();
}

String TransformImage(String imageURL) {
  try {
    print("Original image URL: $imageURL");

    // Apply transformation
    var transformedImage = cloudinary.image(imageURL).transformation(
        Transformation()
            .resize(Resize.fill().width(250).height(400))
            .rotate(Rotate.byAngle(20))
            .effect(Effect.outline()));

    // Get the transformed URL
    String optimizedUrl = transformedImage.toString();

    print("Transformed image URL: $optimizedUrl");
    return optimizedUrl;
  } catch (e) {
    print("Error transforming image: $e");
    return imageURL; // Return the original URL if transformation fails
  }
}

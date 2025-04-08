// import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_url_gen/transformation/video_edit/video_edit_actions.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:untitled1/Backend/ClassModel.dart'; // Adjust the import path
import 'package:untitled1/Constants/routes.dart';
import 'package:untitled1/Views/ClassInsides/AI_Components/ImageTransformationScreen';
import 'package:untitled1/Views/ClassInsides/AI_Components/VideoTransformationScreen';
import 'package:untitled1/Views/ClassInsides/Components/PreviewPDF.dart';
import 'package:untitled1/Views/ClassInsides/Components/PreviewVideo.dart';
import 'package:untitled1/Views/ClassInsides/Components/previewImage.dart';
import 'package:untitled1/services/auth/CloudinaryAiServices.dart';
import 'package:untitled1/services/auth/CloudinaryServices.dart';
import 'package:untitled1/services/auth/DatabaseServices.dart';
import 'package:untitled1/services/auth/auth_service.dart';

import 'package:permission_handler/permission_handler.dart';

class ClassDetailScreen extends StatefulWidget {
  final ClassModel classModel;
  const ClassDetailScreen({super.key, required this.classModel});

  @override
  _ClassDetailScreenState createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  FilePickerResult? _filePickerResult;

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ["jpg", "jpeg", "png", "mp4", "mkv", "pdf"],
        type: FileType.custom);
    setState(() {
      _filePickerResult = result;
    });

    if (_filePickerResult != null) {
      Navigator.pushNamed(context, uploadAreaRoute, arguments: {
        "filePickerResult": _filePickerResult,
        "classId": widget.classModel.classid,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Files"),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthServices.firebase().logOut();
                Navigator.pushReplacementNamed(context, "/loginRoute");
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
        stream: DbService().readUploadedFiles(widget.classModel.classid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List userUploadedFiles = snapshot.data!.docs;
            if (userUploadedFiles.isEmpty) {
              return const Center(
                child: Text("No files uploaded"),
              );
            } else {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    childAspectRatio: 1, // Aspect ratio for each grid item
                    crossAxisSpacing: 8, // Spacing between columns
                    mainAxisSpacing: 8, // Spacing between rows
                  ),
                  itemCount: userUploadedFiles.length,
                  itemBuilder: (context, index) {
                    String name = userUploadedFiles[index]["name"];
                    String ext = userUploadedFiles[index]["extension"];
                    String publicId = userUploadedFiles[index]["id"];
                    String fileUrl = userUploadedFiles[index]["url"];
                    String uploadDate = userUploadedFiles[index]["created_at"];
                    String description =
                        userUploadedFiles[index]["description"];
                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Delete file"),
                                  content: const Text(
                                      "Are you sure you want to delete?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("No")),
                                    TextButton(
                                        onPressed: () async {
                                          try {
                                            final result =
                                                await deleteFromCloudinary(
                                                    publicId);
                                            print(
                                                "result $result  public id $publicId     $userUploadedFiles");

                                            // DbService().deleteFile(
                                            //       this
                                            //           .widget
                                            //           .classModel
                                            //           .classid,
                                            //       // snapshot.data!.docs[index].id,
                                            //       publicId,
                                            //       );

                                            await FirebaseFirestore.instance
                                                .collection("user-files")
                                                .doc(AuthServices.firebase()
                                                    .currentUser!
                                                    .id)
                                                .collection("classes")
                                                .doc(this
                                                    .widget
                                                    .classModel
                                                    .classid)
                                                .collection("uploads")
                                                .doc(publicId)
                                                .delete();
                                            // print("deleteResult $deleteResult");
                                            // if (deleteResult) {
                                            //   ScaffoldMessenger.of(context)
                                            //       .showSnackBar(
                                            //     const SnackBar(
                                            //       content: Text("File deleted"),
                                            //     ),
                                            //   );
                                            // } else {
                                            //   ScaffoldMessenger.of(context)
                                            //       .showSnackBar(
                                            //     const SnackBar(
                                            //       content: Text(
                                            //           "Error in deleting file."),
                                            //     ),
                                            //   );
                                            // }
                                          } catch (e) {
                                            print("Error in deleting file: $e");
                                          }

                                          // Delay closing the dialog to ensure the SnackBar is visible

                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text("Yes")),
                                  ],
                                ));
                      },
                      onTap: () {
                        if (ext == "png" || ext == "jpg" || ext == "jpeg") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreviewImage(url: fileUrl),
                            ),
                          );
                        } else if (ext == "pdf") {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => PreviewPdf(pdfUrl: fileUrl),
                          //   ),
                          // );
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PreviewVideo(videoUrl: fileUrl)));
                        }
                      },
                      child: Container(
                        color: Colors.grey.shade200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child:
                                  ext == "png" || ext == "jpg" || ext == "jpeg"
                                      ? Image.network(
                                          fileUrl,
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(Icons.movie),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(ext == "png" ||
                                                ext == "jpg" ||
                                                ext == "jpeg"
                                            ? Icons.image
                                            : Icons.picture_as_pdf),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Uploaded: $uploadDate",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            final donwload_result =
                                                await downloadFileFromCloudinary(
                                                    fileUrl, name);
                                            if (donwload_result) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content:
                                                      Text("File downloaded"),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Error in downloading the file."),
                                                ),
                                              );
                                            }
                                          },
                                          icon: Icon(Icons.download)),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Add Comment"),
                                              content: TextField(
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      "Enter your comment",
                                                ),
                                                onSubmitted: (value) async {
                                                  // Save the comment to Firestore
                                                  DbService().UpdateDescription(
                                                      value,
                                                      widget.classModel.classid,
                                                      publicId);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.comment),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (ext == "png" ||
                                              ext == "jpg" ||
                                              ext == "jpeg") {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    "Optimize Image"),
                                                content: const Text(
                                                    "Do you want to optimize this image or preview it first?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PreviewImage(
                                                                  url: fileUrl),
                                                        ),
                                                      );
                                                    },
                                                    child:
                                                        const Text("Preview"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      Navigator.pop(
                                                          context); // Close the dialog
                                                      
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ImageTransformationScreen(
                                                            originalImageUrl:
                                                                fileUrl,
                                                          ),
                                                        ),
                                                      );

                                                      // Navigator.pop(
                                                      //     context); // Close the dialog
                                                    },
                                                    child:
                                                        const Text("Optimize"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else if (ext == "mkv" ||
                                              ext == "mp4") {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    "Optimize Video"),
                                                content: const Text(
                                                    "Do you want to optimize this video or preview it first?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PreviewVideo(
                                                                  videoUrl:
                                                                      fileUrl),
                                                        ),
                                                      );
                                                    },
                                                    child:
                                                        const Text("Preview"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      Navigator.pop(
                                                          context); // Close the dialog

                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              VideoTransformationScreen(
                                                            originalVideoUrl:
                                                                fileUrl,
                                                          ),
                                                        ),
                                                      );

                                                      // Navigator.pop(
                                                      //     context); // Close the dialog
                                                    },
                                                    child:
                                                        const Text("Optimize"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openFilePicker();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

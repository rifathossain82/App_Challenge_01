import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddEditPage extends StatefulWidget {
  const AddEditPage({Key? key}) : super(key: key);

  @override
  _AddEditPageState createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {

  TextEditingController controller1=TextEditingController();
  TextEditingController controller2=TextEditingController();


  File? file;
  UploadTask? task;

  CollectionReference contacts =
  FirebaseFirestore.instance.collection('contacts');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller1,
              decoration: InputDecoration(
                hintText: 'Enter Name',
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 16,),
            TextField(
              controller: controller2,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Enter Number',
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 16,),
            ElevatedButton.icon(
              onPressed: ()async{
                final result=await FilePicker.platform.pickFiles(allowMultiple: false);

                if(result==null){
                  return;
                }
                else{
                  final path=result.files.single.path;
                  setState(() {
                    file=File(path!);
                  });
                }
              },
              icon: Icon(Icons.attach_file),
              label: Text('Select File'),

            ),
            SizedBox(height: 8,),
            file==null?Text('No File Selected'):Text(basename(file!.path)),
            SizedBox(height: 8,),
            ElevatedButton(
              onPressed: ()async{
                if(file==null){
                  return;
                }
                else{
                  final fileName=basename(file!.path);
                  final destination='files/$fileName';
                  task=FirebaseApi.uploadTask(destination, file!);
                  setState(() {

                  });

                  if(task==null){
                    return;
                  }
                  else{
                    final snapshot=await task!.whenComplete((){
                      setState(() {

                      });
                    });
                    final urlDownload=await snapshot.ref.getDownloadURL();
                    contacts.add({
                      'name': controller1.text,
                      'number': controller2.text,
                      'image': urlDownload,
                    });

                    print('Download link: $urlDownload');
                  }
                }
              },
              child: Text('Add Contact'),

            ),
            SizedBox(height: 20,),
            task!=null? buildUploadStatus(task!):Container(),

          ],
        ),
      ),
    );
  }
  Widget buildUploadStatus(UploadTask task){
    return StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder:(context,snapshot){
          final snap=snapshot.data;
          final progress=snap!.bytesTransferred/snap.totalBytes;
          final percentage=(progress*100).toStringAsFixed(2);

          return Text('$percentage %',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
        }
    );
  }
}


class FirebaseApi{

  //to upload file
  static UploadTask? uploadTask(String destination, File file){
    try{
      final ref=FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    }
    catch(e){
      return null;
    }
  }


  //to upload bytes data
  static UploadTask? uploadBytes(String destination, Uint8List data){
    try{
      final ref=FirebaseStorage.instance.ref(destination);
      return ref.putData(data);
    }
    catch(e){
      return null;
    }
  }
}
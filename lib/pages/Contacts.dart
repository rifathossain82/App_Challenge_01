import 'package:app_challenge_01/pages/AddEditPage.dart';
import 'package:app_challenge_01/pages/DetailsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  CollectionReference contacts =
  FirebaseFirestore.instance.collection('contacts');



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Center(
        child: StreamBuilder(
            stream: contacts.orderBy('name').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                  children: snapshot.data!.docs.map((contact) {
                    return Center(
                      child: ListTile(
                        title: Text(contact['name']),
                        onLongPress: () {
                          //favorite.reference.delete();
                          //controller.clear();
                          //controller.text='';
                        },
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsPage(name: contact['name'], number: contact['number'], image: contact['image'])));
                        },
                      ),
                    );
                  }).toList());
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddEditPage()));
        },
      ),
    );
  }
}

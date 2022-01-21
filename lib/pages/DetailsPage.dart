import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  String name;
  String number;
  String image;

  DetailsPage(
      {Key? key, required this.name, required this.number, required this.image})
      : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  CollectionReference favorites =
      FirebaseFirestore.instance.collection('favorites');

  bool _value = false;
  DocumentReference? ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchData();
  }

  void searchData() async {
    FirebaseFirestore.instance
        .collection('favorites')
        .where('number', isEqualTo: widget.number)
        .get()
        .then((QuerySnapshot querySnapshot) {
          if(querySnapshot.docs.isEmpty){
            print('no data found');
            setState(() {
              _value=false;
            });
          }
          else{
            var name=querySnapshot.docs.elementAt(0)['name'];
            ref=querySnapshot.docs.elementAt(0).reference;
            setState(() {
              _value=true;
            });
            print(name);
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.image,height: 320),
              SizedBox(
                height: 30,
              ),
              Text(
                widget.name,
                style: TextStyle(fontSize: 26),
              ),
              SizedBox(
                height: 4,
              ),
              Text(widget.number),
              SizedBox(
                height: 4,
              ),
              Checkbox(
                  value: _value,
                  onChanged: (val) {
                    setState(() {
                      _value = val!;
                      if (_value == true) {
                        favorites.add({
                          'name': widget.name,
                          'number': widget.number,
                          'image': widget.image,
                        });
                      } else {
                        ref!.delete();
                      }
                      print(_value);
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}

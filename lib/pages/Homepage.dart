import 'package:app_challenge_01/pages/Contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {

    CollectionReference favorites =
    FirebaseFirestore.instance.collection('favorites');


    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzrtaXGkXhkLIV4Du-Lg0JPJ5I84RQb8RvIA&usqp=CAU')),
              SizedBox(height: 20,),
              TextButton(child: Text('Contacts'),onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Contacts()));
              },),
              SizedBox(height: 8,),
              TextButton(child: Text('Gmail'),onPressed: (){

              },),
              SizedBox(height: 8,),
              TextButton(child: Text('Gmail'),onPressed: (){

              },),
              SizedBox(height: 20,),
              Text('Favorites',style: TextStyle(fontSize: 26,color: Colors.red),),
              Expanded(
                  child: StreamBuilder(
                      stream: favorites.orderBy('name').snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView(
                            children: snapshot.data!.docs.map((favorite) {
                              return Center(
                                child: ListTile(
                                  title: Text(favorite['name']),
                                  onLongPress: () {
                                    //favorite.reference.delete();
                                    //controller.clear();
                                    //controller.text='';
                                  },
                                  onTap: (){
                                    setState(() {
                                      //controller.text=grocery['name'];
                                      //id=grocery;

                                    });
                                  },
                                ),
                              );
                            }).toList());
                      }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

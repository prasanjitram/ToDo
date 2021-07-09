import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app_final/Authentication.dart';
import 'package:todo_app_final/constants.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late String userId;

  Authentication auth = Authentication();
  String todo = '';
  bool isDone = false;

  @override
  void initState() {
    setState(() {

    });
    userId = widget.userId;
    deleteDay();
    super.initState();
  }

  String updateTodo = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var current = DateTime.now();
    Size size = MediaQuery.of(context).size;
    updateTodo ='';
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap:(){
              setState(() {

              });
            },child: Icon(Icons.refresh)),
        backgroundColor: primaryColor,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10, top: 10,bottom: 8),
            height: 50,
            width: 50,
            child: InkWell(
                onTap: () => auth.signOut(context),
                child: Image(image: AssetImage('assets/images/logout.png'))),
          )
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: size.height * 0.2,
                width: size.width,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      width: size.width,
                      height: size.height * 0.2 - 50,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 40,
                                color: primaryColor.withOpacity(0.3))
                          ]),
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .snapshots(),
                        builder: (builder, snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data;
                            return Text(
                              "Hi ${data!['name']}".toUpperCase(),
                              style: TextStyle(
                                  color: textColor,
                                  fontFamily: 'Calder',
                                  fontSize: 30),
                            );
                          } else
                            return Text('');
                        },
                      ),
                    ),
                    Positioned(
                        bottom: 20.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          width: size.width,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            children: [
                              Form(
                                key: _formKey,
                                child: Expanded(
                                  child: TextFormField(
                                    onFieldSubmitted: (val){
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          isDone = false;
                                          add();
                                          todo = '';
                                        });
                                      }
                                    },
                                    controller: TextEditingController()
                                      ..text = todo,
                                    onChanged: (val) => todo = val,
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'Enter todo to continue';
                                    },
                                    decoration: InputDecoration.collapsed(
                                        hintText: 'Enter ToDo item'),
                                    style: TextStyle(
                                        fontSize: 18, color: primaryColor),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isDone = false;
                                      add();
                                      todo = '';
                                    });
                                  }
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: primaryColor),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userId)
                      .collection('todo')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic>? data =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>?;
                            if(((current.day*100)+current.hour)-(data!['created'].toDate().day*100+data['created'].toDate().hour)>=100){
                              snapshot.data!.docs[index].reference.delete();
                            }
                            if(snapshot.data!.docs.length>0){
                            return Container(
                              margin: EdgeInsets.only(
                                  left: 20, bottom: 20, right: 20),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        snapshot.data!.docs[index].reference
                                            .update({'isDone': !(data['isDone'])});
                                      });

                                    },
                                    child: Container(
                                      width: 32.0,
                                      height: 32.0,
                                      margin: EdgeInsets.only(right: 12.0),
                                      decoration: BoxDecoration(
                                        color: data['isDone']
                                            ? primaryColor
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        border: data['isDone']
                                            ? null
                                            : Border.all(
                                                color: primaryColor,
                                                width: 1.5),
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {

                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                alert(data,snapshot.data!.docs[index].reference)).then((value){
                                                  setState(() {

                                                  });
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.all(15),
                                        width: size.width,
                                        decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 10),
                                                  blurRadius: 40,
                                                  color: secondaryColor
                                                      .withOpacity(0.3))
                                            ]),
                                        child:
                                        Text(
                                          "${data['todo']}",
                                          style: TextStyle(
                                              fontSize: 18, color: textColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );}
                            else
                              return Container();
                          });
                    } else
                      return Text('');
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void add() {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('todo');
    ref.add({'todo': todo, 'isDone': isDone, 'created': DateTime.now()});
  }



  AlertDialog alert(data,reference) {
    return AlertDialog(
      insetPadding: EdgeInsets.only(left: 15, right: 15,),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
      backgroundColor: primaryColor.withOpacity(0.4),
      content: Container(
        margin: EdgeInsets.only(top: 30,bottom: 30),
        width: MediaQuery.of(context).size.width,
        height: 100,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: _key,
          child: TextFormField(
            validator: (value){
              if(value==null||value.isEmpty){
                return "Todo field can't be empty";
              }
            },
            controller: TextEditingController()..text=data['todo'],
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorStyle: TextStyle(fontSize: 16,color: Colors.yellowAccent)
            ),
            style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
            onChanged: (val){
              updateTodo = val;
            },
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Spacer(),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(onPressed: (){
                  if(_key.currentState!.validate()){
                    update(data,reference);
                  }
                }, child: Text('Update'))),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(onPressed: ()=>delete(reference), child: Text('Delete'))),
          ],
        )
      ],
    );
  }
  void delete(reference) async{
    await reference.delete();
    Navigator.pop(context);
  }
  void update(data,reference) async{
    if(updateTodo=='')
      updateTodo = data['todo'];
    await reference.update({'todo':updateTodo});

    Navigator.pop(context);
  }
  void deleteDay(){
  }
}

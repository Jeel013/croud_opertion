
import 'dart:developer';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late String studentName, studentID, studyProgramID;
  late double studentGPA;


  getStudentName(name) {
    this.studentName = name;
  }

  getStudentID(id) {
    this.studentID = id;
  }

  getStudyProgramID(programID) {
    this.studyProgramID = programID;
  }

  getStudentGPA(gpa) {
    this.studentGPA = double.parse(gpa);
  }

  createData() {
    print("Created");

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    Map<String, dynamic> students = {
      "studentName": studentName,
      "studentID": studentID,
      "studyProgramID": studyProgramID,
      "studentGPA": studentGPA
    };

    documentReference.set(students).whenComplete(() {
      print("$studentName created");
    });
  }

  readData() {
    print("read");

  }

  updateData() {
    print("updated");
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    Map<String, dynamic> students = {
      "studentName": studentName,
      "studentID": studentID,
      "studyProgramID": studyProgramID,
      "studentGPA": studentGPA
    };

    documentReference.set(students).whenComplete(() {
      print("$studentName updated");
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try{
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );


    } catch(e){

      return null;
    }
  }
  deleteData() {
    print("deleted");
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    documentReference.delete().whenComplete(() {
      print("$studentName deleted");
    });}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("My Flutter College"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2)),
              ),
              onChanged: (String name) {
                getStudentName(name);
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Student ID",
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2)),
              ),
              onChanged: (String Id) {
                getStudentID(Id);
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Study Program ID",
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2)),
                ),
                onChanged: (String programId) {
                  getStudyProgramID(programId);
                }),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "GPA",
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2)),
              ),
              onChanged: (String gpa) {
                getStudentGPA(gpa);
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      createData();
                    },
                    child: Text("Create")),
                ElevatedButton(
                    onPressed: () {
                      readData();
                    },
                    child: Text("Read")),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      updateData();
                    },
                    child: Text("Update")),
                Spacer(),
                ElevatedButton(
                    onPressed: () {
                      deleteData();
                    },
                    child: Text("Delete")),
                ElevatedButton(
                    onPressed: () {
                      signInWithGoogle();
                    },
                    child: Text("sing in ")),
              ],
            ),

            Padding(padding: EdgeInsets.all(8),
            child: Row(
              textDirection: TextDirection.ltr,
              children: <Widget>[
                Expanded(child: Text("Name")),
                Expanded(child: Text("Student ID")),
                Expanded(child: Text("Program ID")),
                Expanded(child: Text("GPA")),
              ],
            ),
            ),
            // Container(
            //   height: 200,
            //   width: double.infinity,
            //   child: StreamBuilder(
            //       stream: FirebaseFirestore.instance.collection("MyStudents").snapshots(),
            //       builder: (context, snapshot){
            //     if(snapshot.hasData){
            //       return ListView.builder(
            //          shrinkWrap: true,
            //           itemCount: snapshot.data?.docs.length,
            //           itemBuilder: (context, index){
            //             DocumentSnapshot documentSnapshot = snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
            //          return Row(
            //            children: <Widget>[
            //              Expanded(child: Text(documentSnapshot["studentName"])),
            //              Expanded(child: Text(documentSnapshot["studentID"])),
            //              Expanded(child: Text(documentSnapshot["studyProgramID"])),
            //              Expanded(child: Text(documentSnapshot["studentGPA"].toString())),
            //            ],
            //          );
            //           });
            //     } else {
            //       return Align(
            //         alignment: FractionalOffset.bottomRight,
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //   }),
            // ),
          ],
        ),
      ),
    );
  }
}

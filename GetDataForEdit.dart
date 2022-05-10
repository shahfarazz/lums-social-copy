import 'package:flutter/material.dart';
import 'package:lums_social_app2/screens/Admin/editEvent.dart';
import 'package:lums_social_app2/screens/auth/sign_in.dart';
// import 'package:lums_social_app2/screens/news/newsButton.dart';
import 'package:lums_social_app2/screens/news/viewNewsAdmin.dart';
import 'package:provider/provider.dart';
import 'package:lums_social_app2/models/user.dart';
import 'package:lums_social_app2/services/addToCollection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:lums_social_app2/splash.dart';
import 'package:lums_social_app2/screens/Admin/viewEventAdmin.dart';
import 'package:lums_social_app2/screens/news/editdeleteNews.dart';

String? title;
String? headline;
String? news_author;
String? loc;
String? organiser;
String? description;
DateTime? start_date;
DateTime? start_time;
String? imageURL;
String? event_type;
String? uid;

class GetDataForEdit extends StatefulWidget {
  // const GetDataForEdit({Key? key}) : super(key: key);

  @override
  String? eventID;
  GetDataForEdit({required this.eventID});
  State<GetDataForEdit> createState() => _GetDataForEditState();
}

class _GetDataForEditState extends State<GetDataForEdit> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    uid = user?.uid;

    // print(user);
    // // return either Home or Authenticate Widget
    // bool temp = true;
    if (uid == null) {
      return SignIn();
    } else {
      return FutureBuilder(
        builder: ((context, snapshot) {
          if (snapshot.data != null) {
            return EditEvent(
              title: title,
              loc: loc,
              description: description,
              organiser: organiser,
              start_date: start_date,
              start_time: start_time,
              event_type: event_type,
              eventID: widget.eventID,
            );
          } else {
            return Scaffold(
              backgroundColor: const Color(0xFF050A30),
              body: Center(
                  child: Form(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        IconWidget(),
                        const SizedBox(height: 150),
                        // TextWidget(),
                        const CircularProgressIndicator()
                      ],
                    ),
                  ),
                ),
              )),
            );
            // return Container(
            //   // margin: EdgeInsets.all(50.0),
            //   child: const Image(
            //     image: AssetImage('images/finallogo.png'),
            //     // fit: BoxFit.cover,
            //     width: 450,
            //     height: 400,
            //   ),
            // );
          }
        }),
        future: fetchData(user, widget.eventID),
      );
    }
  }
}

class GetDataForView extends StatefulWidget {
  // const GetDataForEdit({Key? key}) : super(key: key);

  @override
  String? eventID;
  GetDataForView({required this.eventID});
  State<GetDataForView> createState() => _GetDataForViewState();
}

class _GetDataForViewState extends State<GetDataForView> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    uid = user?.uid;

    // print(user);
    // // return either Home or Authenticate Widget
    // bool temp = true;
    if (uid == null) {
      return SignIn();
    } else {
      return FutureBuilder(
        builder: ((context, snapshot) {
          if (snapshot.data != null) {
            return viewEvent(
              title: title,
              loc: loc,
              description: description,
              organiser: organiser,
              start_date: start_date,
              start_time: start_time,
              event_type: event_type,
              eventID: widget.eventID,
              imageURL: imageURL,
            );
          } else {
            // return Splash();
            return Scaffold(
              backgroundColor: const Color(0xFF050A30),
              body: Center(
                  child: Form(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        IconWidget(),
                        const SizedBox(height: 150),
                        // TextWidget(),
                        const CircularProgressIndicator()
                      ],
                    ),
                  ),
                ),
              )),
            );
          }
        }),
        future: fetchData(user, widget.eventID),
      );
    }
  }
}

class GetNewsforEdit extends StatefulWidget {
  // const GetNewsforEdit({Key? key}) : super(key: key);
  String? newsID;
  GetNewsforEdit({required this.newsID});

  @override
  State<GetNewsforEdit> createState() => _GetNewsforEditState();

  // const GetNewsforEdit({Key? key}) : super(key: key);

  // @override
  // State<GetNewsforEdit> createState() => _GetNewsforEditState();
}

class _GetNewsforEditState extends State<GetNewsforEdit> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    uid = user?.uid;

    // print(user);
    // // return either Home or Authenticate Widget
    // bool temp = true;
    if (uid == null) {
      return SignIn();
    } else {
      return FutureBuilder(
        builder: ((context, snapshot) {
          if (snapshot.data != null) {
            return EditNews(
                headline: headline,
                news_author: news_author,
                description: description,
                newsID: widget.newsID);
          } else {
            // return Splash();
            return Container(
              // margin: EdgeInsets.all(50.0),
              child: Image(
                image: AssetImage('images/finallogo.png'),
                // fit: BoxFit.cover,
                width: 450,
                height: 400,
              ),
            );
          }
        }),
        future: GetNews(user, widget.newsID),
      );
    }
  }
}

Future<Object> GetNews(user, newsID) async {
  DocumentSnapshot<Map<String, dynamic>> mySnapshot;
  print('START-------------------------');
  print(user?.uid);
  print(newsID);
  print('END-------------------------');
  mySnapshot = await getNews(user?.uid, newsID);
  headline = mySnapshot.data()?['headline'];
  description = mySnapshot.data()?['description'];
  news_author = mySnapshot.data()?['news_author'];
  imageURL = mySnapshot.data()?['imageURL'];

  print('checking image url mahnoor ki ghalti 0');
  print(imageURL);

  return mySnapshot;
}

Future<bool> fetchData(user, eventID) async {
  print('fetchdatawala');
  print(eventID);
  DocumentSnapshot<Map<String, dynamic>> mySnapshot;
  mySnapshot = await getDataOfOne(user?.uid, eventID);
  // start_date = mySnapshot.data()?['start_date'];
  title = mySnapshot.data()?['title'];
  description = mySnapshot.data()?['description'];
  loc = mySnapshot.data()?['location'];
  Timestamp date = mySnapshot.data()?['start_date'];
  Timestamp time = mySnapshot.data()?['start_time'];
  start_date = date.toDate();
  start_time = time.toDate();
  organiser = mySnapshot.data()?['Organiser'];
  event_type = mySnapshot.data()?['event_type'];
  imageURL = mySnapshot.data()?['imageURL'];
  return true;
}

Future<DocumentSnapshot<Map<String, dynamic>>> getDataOfOne(
    String uid, String eventID) async {
  // Get docs from collection reference
  DocumentSnapshot<Map<String, dynamic>> mySnapshot;
  mySnapshot = await FirebaseFirestore.instance
      .collection('adminEvents')
      .doc(uid)
      .collection('Events')
      .doc(eventID)
      .get();
  return mySnapshot;
}

Future<DocumentSnapshot<Map<String, dynamic>>> getNews(
    String uid, String newsID) async {
  // Get docs from collection reference
  DocumentSnapshot<Map<String, dynamic>> mySnapshot;
  mySnapshot = await FirebaseFirestore.instance
      .collection('adminEvents')
      .doc(uid)
      .collection('News')
      .doc(newsID)
      .get();
  return mySnapshot;
}

Widget IconWidget() => Container(
      // margin: EdgeInsets.all(50.0),
      child: Image(
        image: AssetImage('images/finallogo.png'),
        // fit: BoxFit.cover,
        width: 450,
        height: 400,
      ),
    );


// ***************************************************************************************************************



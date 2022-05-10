import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lums_social_app2/models/user.dart';
import 'package:lums_social_app2/screens/Admin/GetDataForEdit.dart';
import 'package:lums_social_app2/screens/auth/forget_password.dart';
import 'package:lums_social_app2/screens/auth/sign_in.dart';
import 'package:lums_social_app2/screens/news/addNews.dart';
// import 'package:lums_social_app2/screens/news/newsButton.dart';
import 'package:lums_social_app2/splash.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lums_social_app2/screens/Admin/addEvent.dart';
import 'package:lums_social_app2/screens/news/editdeletenews.dart';
import '../../services/auth.dart';

class admin extends StatefulWidget {
  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  final AuthService _auth = AuthService();
  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> newsData = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat format = CalendarFormat.month;

  final List colors = [
    const Color(0xffa4dded),
    const Color(0xffa7d8de),
    const Color(0xffb0e0e6),
    const Color(0xfface5ee),
    const Color(0xffc9e5ee),
  ];

  final List colorsB = [
    const Color(0xff00e9d8),
    const Color(0xff00d3e0),
    const Color(0xff00bde8),
    const Color(0xff00a7ef),
    const Color(0xff0091f7)
  ];

  final _random = Random();

  // List<Event> _getEventsforDay(DateTime date) {
  //   return selectedEvents[date] ?? [];
  // }

  // CalendarController _calendarController = CalendarController();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
        drawer: SideMenu(),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            // SideMenu(),
            // SignOut(),
            Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 30.0, bottom: 10.0, top: 15.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: mainText(),
                )),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 15.0, bottom: 10.0, top: 0.0),
              child: greetingRow(user),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment(-0.72, -0.1),
              child: addedEvents(),
            ),
            listEvents(context, user),
            Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 15.0, bottom: 10.0, top: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    addEventButton(context),
                    // const SizedBox(width: 50),
                    addNewsButton(context)
                  ],
                )),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 15.0, bottom: 10.0, top: 0.0),
              child: addedNews(),
            ),
            listNews(context, user),
          ],
        )));
  }

  Widget mainText() => Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: new TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: new TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                  fontFamily: 'poppins',
                  //  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  new TextSpan(
                      text: 'LUMS',
                      style: new TextStyle(fontWeight: FontWeight.w500)),
                  new TextSpan(text: " "),
                  new TextSpan(
                      text: 'SOCIAL',
                      style: new TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5DCAD1))),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(140, 5, 0, 10),
              // child: SignOut(),
            )
            // SignOut(),
          ]);

  Widget SideMenu() => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                '     \n\nAccount Settings',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF5DCAD1),
                // image: DecorationImage(
                //     fit: BoxFit.fill,
                //     image: Icon()

                //     )
              ),
            ),
            ListTile(
              title: Text('\n'),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                size: 40,
                color: Colors.black,
              ),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () async {
                await _auth.signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              },
            ),
            ListTile(
              title: Text('\n'),
            ),
            ListTile(
              leading: Icon(
                Icons.change_circle,
                size: 40,
                color: Colors.black87,
              ),
              title: Text(
                'Change Password',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () async {
                await _auth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()));
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text('Settings'),
            //   // onTap: () => {Navigator.of(context).pop()},
            // ),
            // ListTile(
            //   leading: Icon(Icons.border_color),
            //   title: Text('Feedback'),
            //   // onTap: () => {Navigator.of(context).pop()},
            // ),
            // ListTile(
            //   leading: Icon(Icons.exit_to_app),
            //   title: Text('Logout'),
            //   // onTap: () => {Navigator.of(context).pop()},
            // ),
          ],
        ),
      );

  Widget greetingRow(user) => Row(
        children: [
          Icon(Icons.account_circle_rounded,
              size: 33, color: Color(0xFF050A30)),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Text(
                    "Hello " + snapshot.data.toString().toUpperCase() + "!",
                    style: new TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      // padding: const EdgeInsets.all(15.0),
                    ),
                  );
                } else {
                  return Text('Loading');
                }
              },
              future: getDataName(user?.uid, "name"),
            ),
            // Text(
            //   'Hello',
            //   style: TextStyle(
            //     fontFamily: 'Poppins',
            //     color: Colors.black,
            //     fontSize: 25,
            //     // padding: const EdgeInsets.all(15.0),
            //   ),
            // )
          ),
        ],
      );

  Widget addedEvents() => Text(
        'Events you have added',
        style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontSize: 21,
            fontWeight: FontWeight.w500
            // padding: const EdgeInsets.all(15.0),
            ),
      );
  Widget addedNews() => Row(
        children: [
          Icon(Icons.newspaper_rounded, size: 35, color: Color(0xFF0E1337)),
          const SizedBox(width: 10),
          Text(
            'News Bulletin',
            style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFF0E1337),
                fontSize: 22,
                fontWeight: FontWeight.w600
                // padding: const EdgeInsets.all(15.0),
                ),
          ),
        ],
      );

  Widget listEvents(context, user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        // height: MediaQuery.of(context).size.height * 0.35,
        height: 150,
        // color: Colors.white,
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.data == null) {
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
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allData.length,
                itemBuilder: (context, index) {
                  return Container(
                    // decoration: BoxDecoration(
                    //   border: Border(
                    //       left: BorderSide(
                    //     color: Colors.primaries[
                    //         Random().nextInt(Colors.primaries.length)],
                    //     width: 5,
                    //   )),
                    // ),
                    // width: MediaQuery.of(context).size.width * 0.6,
                    width: 240,
                    height: 200,
                    // decoration: BoxDecoration(
                    //   shape: Border(left: BorderSide(color: Colors.yellow, width: 5)),
                    // ),
                    child: Card(
                      elevation: 3,
                      // shape: Border(left: BorderSide(color: Colors.primaries[Random().nextInt(Colors.primaries.length)], width: 8)),

                      shape: RoundedRectangleBorder(
                        // side: BorderSide(color: Colors.yellow, width: 1),

                        borderRadius: BorderRadius.circular(15),
                        // side: BorderSide(
                        // //   color: Colors.grey.withOpacity(0.5),

                        // )
                      ),

                      shadowColor: Colors.grey.withOpacity(1),

                      // color: Color(0xFFFBF6F0),
                      color: colors[_random.nextInt(4)],
                      // color: Colors
                      //     .primaries[Random().nextInt(Colors.primaries.length)],

                      // color: _randomcolor.randomColor(colorHue: ColorHue.blue),

                      child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Container(
                              //       // height: 50,
                              //       // width: 20,
                              //       color: Colors.yellow,
                              //       alignment: Alignment.centerLeft,
                              //     ),
                              TextButton(
                                  onPressed: () {
                                    String eventID = allData[index]['eventID'];
                                    // print(eventID);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GetDataForView(
                                                eventID: eventID,
                                              )),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        allData[index]['title'].toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        allData[index]['start_date']
                                            .toDate()
                                            .toString()
                                            .substring(0, 10),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                    ],
                                  )),
                            ]),
                      ),
                    ),
                  );
                });
          },
          future: getData(user?.uid),
        ),
      );

  Widget listNews(context, user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        // height: MediaQuery.of(context).size.height,
        height: 400,
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Image(
                  image: AssetImage('images/finallogo.png'),
                  // fit: BoxFit.cover,
                  width: 450,
                  height: 400,
                ),
              );
            }
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: newsData.length,
                itemBuilder: (context, index) {
                  return Container(
                    // decoration: BoxDecoration(
                    //   border: Border(
                    //       left: BorderSide(
                    //     color: Colors.primaries[
                    //         Random().nextInt(Colors.primaries.length)],
                    //     width: 5,
                    //   )),
                    // ),
                    // width: MediaQuery.of(context).size.width * 0.6,
                    width: 240,
                    height: 100,
                    // decoration: BoxDecoration(
                    //   shape: Border(left: BorderSide(color: Colors.yellow, width: 5)),
                    // ),
                    child: Card(
                      elevation: 3,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadowColor: Colors.grey.withOpacity(1),
                      color: Color(0xFFFBF6F0),
                      // crossAxisAlignment: CrossAxisAlignment.center
                      // color: Colors
                      //     .primaries[Random().nextInt(Colors.primaries.length)],

                      // color: _randomcolor.randomColor(colorHue: ColorHue.blue),

                      child: Row(mainAxisAlignment: MainAxisAlignment.start,

                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              color: colorsB[_random.nextInt(4)],
                              width: 15,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Container(
                                  //       // height: 50,
                                  //       // width: 20,
                                  //       color: Colors.yellow,
                                  //       alignment: Alignment.centerLeft,
                                  //     ),
                                  TextButton(
                                      onPressed: () {
                                        String newsID =
                                            newsData[index]['NewsID'];
                                        // print(newsID);
                                        // print('ASHUDUHDUASBDUASHdba');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GetNewsforEdit(
                                                    newsID: newsID,
                                                  )),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            newsData[index]['headline']
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontFamily: 'poppins',
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            newsData[index]['news_author']
                                                .toString(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                fontFamily: 'poppins'),
                                          )
                                        ],
                                        // child: Text(
                                        //   newsData[index]['headline'].toString() +
                                        //       "\n\n" +
                                        //       newsData[index]['news_author'].toString(),
                                        //   // //  allData[index]['location'] + "\n\n" +
                                        //   // newsData[index]['start_date']
                                        //   //     .toDate()
                                        //   //     .toString()
                                        //   //     .substring(0, 10),
                                        //   style: TextStyle(
                                        //       color: Colors.black, fontSize: 16.0),
                                        // textAlign: TextAlign.center,
                                      )),
                                ]),
                          ]),
                    ),
                  );
                });
          },
          future: getNews(user?.uid),
        ),
      );

  Widget editEventButton(context) => Row(
        children: [
          Container(
              height: 30.0,
              width: 30.0,
              child: FloatingActionButton(
                  heroTag: 'hero3',
                  elevation: 2,
                  // backgroundColor: Color(0xFF5DCAD1),
                  backgroundColor: Color(0xFF050A30),
                  child: Icon(Icons.edit),
                  onPressed: () {})),
          Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                ' Edit event',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: Color(0xFF050A30),
                  fontSize: 18,
                  // padding: const EdgeInsets.all(15.0),
                ),
              )),
        ],
      );

  Widget addEventButton(context) => Row(
        children: [
          Container(
              height: 30.0,
              width: 30.0,
              child: FloatingActionButton(
                  heroTag: 'Hero1',
                  elevation: 2,
                  // backgroundColor: Color(0xFF5DCAD1),
                  backgroundColor: Colors.black,
                  child: Icon(Icons.add),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEvent()),
                    );
                  })),
          Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                ' Add event',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 18,
                  // padding: const EdgeInsets.all(15.0),
                ),
              )),
        ],
      );

  Widget addNewsButton(context) => Row(
        children: [
          Container(
              height: 30.0,
              width: 30.0,
              child: FloatingActionButton(
                  heroTag: 'hero2',
                  elevation: 2,
                  // backgroundColor: Color(0xFF5DCAD1),
                  backgroundColor: Colors.black,
                  child: Icon(Icons.add),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddNews()),
                    );
                  })),
          Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                ' Add news',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 18,
                  // padding: const EdgeInsets.all(15.0),
                ),
              )),
        ],
      );

  Widget viewCalender() => Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.grey,
      child: TableCalendar(
        firstDay: DateTime.utc(2022, 4, 12),
        lastDay: DateTime.utc(2040, 3, 14),
        focusedDay: DateTime.now(),
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
          });
        },

        onFormatChanged: (CalendarFormat _format) {
          setState(() {
            format = _format;
          });
        },

        headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            decoration: BoxDecoration(
              color: Color(0xFF5DCAD1),
            ),
            headerMargin: EdgeInsets.only(bottom: 8.0),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            formatButtonDecoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
            formatButtonTextStyle: const TextStyle(
              color: Color(0xFF050A30),
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white)),

        // eventLoader: _getEventsforDay,
        // CALENDER STYLE EDITOR
        calendarStyle: const CalendarStyle(
          selectedDecoration:
              BoxDecoration(color: Color(0xFF5DCAD1), shape: BoxShape.circle),
          todayTextStyle: TextStyle(
            color: Colors.black,
          ),
          todayDecoration: BoxDecoration(
              color: Color.fromARGB(255, 204, 230, 252),
              shape: BoxShape.circle),
        ),

        // CALENDER BUILDER
        calendarBuilders: CalendarBuilders(),
      ));

  Future<String> getDataName(String? uid, String dataType) async {
    // Get docs from collection reference
    DocumentSnapshot<Map<String, dynamic>> mySnapshot;
    mySnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return mySnapshot.data()?[dataType];

    // return ret;
  }

  // Widget SignOut() => IconButton(
  //     onPressed: () async {
  //       await _auth.signOut();
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => SignIn()));
  //     },
  //     icon: const Icon(Icons.logout_rounded));

  Future<bool?> getData(String? uid) async {
    // Get docs from collection reference
    QuerySnapshot<Map<String, dynamic>> mySnapshot;
    mySnapshot = await FirebaseFirestore.instance
        .collection('adminEvents')
        .doc(uid)
        .collection('Events')
        .get();
    allData = mySnapshot.docs.map((doc) => doc.data()).toList();

    // print(allData);
    return true;
  }

  Future<bool?> getNews(String? uid) async {
    // Get docs from collection reference
    QuerySnapshot<Map<String, dynamic>> mySnapshot;
    mySnapshot = await FirebaseFirestore.instance
        .collection('adminEvents')
        .doc(uid)
        .collection('News')
        .get();

    // print('mera data');
    // print(uid);
    newsData = mySnapshot.docs.map((doc) => doc.data()).toList();

    print(newsData);
    return true;
  }
}

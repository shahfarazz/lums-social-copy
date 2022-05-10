//View Event

import 'package:flutter/material.dart';
import 'package:lums_social_app2/screens/Admin/GetDataForEdit.dart';
import 'package:lums_social_app2/services/auth.dart';
import 'package:lums_social_app2/widget/button_widget.dart';
import 'package:intl/intl.dart';

class viewEvent extends StatefulWidget {
  String? title;
  String? loc;
  String? organiser;
  String? description;
  DateTime? start_date;
  DateTime? start_time;
  String? imageURL;
  String? event_type;
  String? eventID;
  // String uid = 'abcdefghij12';

  viewEvent(
      {required this.title,
      required this.loc,
      required this.description,
      required this.organiser,
      required this.start_date,
      required this.start_time,
      required this.event_type,
      required this.eventID,
      required this.imageURL});

  @override
  State<viewEvent> createState() => _viewEventState();
}

class _viewEventState extends State<viewEvent> {
  String getTimeFromDateAndTime(String date) {
    DateTime dateTime;
    dateTime = DateTime.parse(date).toLocal();
    return DateFormat.jm().format(dateTime).toString(); //5:08 PM
  }

  String getDateFromDateAndTime(String date) {
    DateTime dateTime;
    dateTime = DateTime.parse(date).toLocal();
    return DateFormat("dd-MM-yyyy").format(dateTime);
  }

  // getTimeFromDateAndTime(widget.start_date);

  // String now = DateFormat("yyyy-MM-dd").format(widget.start_date);
  // String formattedTime = DateFormat.jm().format(start_time);
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    backgroundColor:
    const Color(0xFFFFFFFF);
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, bottom: 5.0, top: 30.0),
          child: image(),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, bottom: 5.0, top: 15.0),
          child: title(),
        ),
        const SizedBox(height: 20),
        // Padding(
        //   padding: const EdgeInsets.only(
        //       left: 15.0, right: 200.0, bottom: 5.0, top: 15.0),
        //   child:
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [date(), const SizedBox(width: 40), time()]),

        Padding(
          padding: const EdgeInsets.only(
              left: 25.0, right: 25.0, bottom: 20.0, top: 15.0),
          child: location(),
        ),
        Padding(
            padding: EdgeInsets.only(left: 25),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: info(),
            )),
        // Text(widget.description.toString()),
        Padding(
            padding: EdgeInsets.only(left: 25),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: des(),
            )),

        // Padding(
        //   padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        //   child: des(),
        // ),
        Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 295.0, bottom: 5.0, top: 15.0),
          child: author(),
        ),
        Padding(
            padding: EdgeInsets.only(left: 25),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: authorName(),
            )),
        // Padding(
        //   padding: const EdgeInsets.only(left: 15.0, bottom: 5.0, top: 15.0),
        //   child: authorName(),
        // ),
        Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, bottom: 5.0, top: 15.0),
          child: editButton(),
        ),
      ],
    )));
  }

// ********************************** FETCH HEADLINE **********************************
  Widget title() => Container(
          // alignment: Alignment.center,
          // padding: const EdgeInsets.fromLTRB(35, 60, 20, 20),
          child: Text(
        widget.title.toString(),
        style: TextStyle(
            fontSize: 25,
            color: Color(0xFF050A30),
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins'),
      ));

  Widget info() => Text(
        'Additional Information',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xffA19F9F),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      );

  Widget des() => Text(
        widget.description.toString(),
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: 18, color: Color(0xFF050A30), fontFamily: 'Poppins'),
      );

// ********************************** FETCH DATE **********************************
  Widget date() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Date',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xffA19F9F),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Container(
            width: 150,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                )
              ],
            ),
            // alignment: Alignment.center,
            // padding: const EdgeInsets.fromLTRB(35, 0, 0, 20),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.calendar_month_rounded),
                ),
                Text(
                  getDateFromDateAndTime(widget.start_date.toString()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'Poppins'),
                )
              ],
            ))
      ]);

// // FETCH TIME
  Widget time() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Time',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xffA19F9F),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Container(
            width: 150,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                )
              ],
            ),
            // alignment: Alignment.center,
            // padding: const EdgeInsets.fromLTRB(35, 0, 0, 20),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.watch_later_rounded),
                ),
                Text(
                  getTimeFromDateAndTime(widget.start_time.toString()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'Poppins'),
                )
              ],
            ))
      ]);

  Widget location() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Venue',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xffA19F9F),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                )
              ],
            ),
            // alignment: Alignment.center,
            // padding: const EdgeInsets.fromLTRB(35, 0, 0, 20),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.place_rounded),
                ),
                Text(
                  widget.loc.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'Poppins'),
                )
              ],
            ))
      ]);

// ********************************** FETCH IMAGE **********************************
  Widget image() => Container(
          // alignment: Alignment.topLeft,
          // padding: const EdgeInsets.fromLTRB(25, 0, 0, 20),
          child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(widget.imageURL.toString()),
        // child: const Image(
        //   image: AssetImage('images/20poster1 1.png'),
        //   fit: BoxFit.cover,
        // ),
      ));

// ********************************** FETCH NEWS DESC **********************************

  Widget author() => Text(
        "Organiser",
        style: TextStyle(
            fontSize: 16, color: Color(0xffA19F9F), fontFamily: 'Poppins'),
      );

// ********************************** FETCH AUTHOR **********************************
  Widget authorName() => Text(
        widget.organiser.toString(),
        style: TextStyle(
            fontSize: 16, color: Color(0xFF000000), fontFamily: 'Poppins'),
      );

  Widget editButton() => Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.fromLTRB(25, 0, 0, 20),
      child: InkWell(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GetDataForEdit(
                      eventID: widget.eventID,
                    )),
          );
        },
        child: const Image(
          image: AssetImage('images/editImage.png'),
          fit: BoxFit.cover,
        ),
      ));
}

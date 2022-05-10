import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'GetDataForEdit.dart';
// import 'package:lums_social_app2/screens/Admin/addEvent.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'adminDashboard.dart';

class upload {
  Future uploadImageToFirebase(BuildContext context) async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("images/" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(File(image!.path));
    uploadTask.then((res) {
      res.ref.getDownloadURL();
    });
  }
}

class EditEvent extends StatefulWidget {
  @override
  String? title;
  String? loc;
  String? organiser;
  String? description;
  DateTime? start_date;
  DateTime? start_time;
  String? image;
  String? event_type;
  String? eventID;
  EditEvent(
      {required this.title,
      required this.loc,
      required this.description,
      required this.organiser,
      required this.start_date,
      required this.start_time,
      required this.event_type,
      required this.eventID});
  State<EditEvent> createState() => _EditEventState();
}

List eventData = [];

class _EditEventState extends State<EditEvent> {
  String email = '';
  final imageFile = upload();
  // List tags = new List(5);
  final _formKey = GlobalKey<FormBuilderState>();
  // final _globalKey = GlobalKey<TagsState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: ListView(children: <Widget>[
          FormBuilder(
              child: SingleChildScrollView(
            child: Column(children: [
              blueDecor(),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 130.0, bottom: 10.0, top: 15.0),
                child: subText(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 4.0, top: 15.0),
                child: nameField(title),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 4.0, top: 15.0),
                child: OrganiserField(organiser),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 4.0, top: 15.0),
                child: LocationField(loc),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 4.0, top: 15.0),
                child: DescriptionField(description),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 4.0, top: 15.0),
                child: FilterCategory(),
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 4.0, top: 8.0),
                          child: DateField(start_date))),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 4.0, top: 8.0),
                          child: TimeField(start_time))),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 4.0, top: 8.0),
                          child: AddImage())),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, right: 15.0, bottom: 4.0, top: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF5DCAD1),
                              minimumSize: Size.fromHeight(30),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                              ),
                            ),
                            child: FittedBox(
                              child: Text(
                                'Upload',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            onPressed: () =>
                                imageFile.uploadImageToFirebase(context),
                          ))),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 15.0, top: 8.0),
                          child: updateButton(user))),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 15.0, bottom: 15.0, top: 8.0),
                    child: deleteButton(),
                  )),
                ],
              ),
              const SizedBox(height: 10),
            ]),
          )),
        ]));
  }

  Widget blueDecor() => Image(
        image: AssetImage('images/editbackground.png'),
        fit: BoxFit.cover,
        height: 250,
        width: 600,
        alignment: Alignment.topCenter,
      );

  Widget subText() => Text(
        'Please fill in to update details.',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black,
          fontSize: 18,
          // padding: const EdgeInsets.all(15.0),
        ),
      );

  Widget nameField(title) => FormBuilderTextField(
        name: 'title',
        initialValue: widget.title,
        decoration: const InputDecoration(
            labelText: "Event Name",
            hintText: "Enter Event Name",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.only(left: 15.0)),
        validator: (val) => val!.isEmpty ? "Please enter event name" : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (val) => {widget.title = val},
      );

  Widget OrganiserField(organiser) => FormBuilderTextField(
        name: 'organiser',
        initialValue: widget.organiser,
        decoration: const InputDecoration(
            labelText: "Organiser Name",
            hintText: "Enter Organizer Name",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.only(left: 15.0)),
        validator: (val) =>
            val!.isEmpty ? "Please enter event organiser" : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (val) => {widget.organiser = val},
      );

  Widget LocationField(loc) => FormBuilderTextField(
        name: 'location',
        initialValue: widget.loc,
        decoration: const InputDecoration(
            labelText: "Location",
            hintText: "Enter Location",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.only(left: 15.0)),
        // validator: (val) => val!.isEmpty ? "Please enter event location" : null,
        validator: (val) => val!.isEmpty ? "Please enter event location" : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (val) => {widget.loc = val},
      );

  Widget DescriptionField(description) => FormBuilderTextField(
        name: 'description',
        initialValue: widget.description,
        maxLines: 6,
        minLines: 1,
        decoration: const InputDecoration(
            labelText: "Description of Event",
            hintText: "Enter Description",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.only(left: 15.0)),
        validator: (val) =>
            val!.isEmpty ? "Please enter event description" : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (val) => {widget.description = val},
      );

  Widget DateField(start_date) => FormBuilderDateTimePicker(
        name: 'date',
        firstDate: widget.start_date,
        initialValue: widget.start_date,
        initialDate: widget.start_date,
        fieldHintText: "Add Date",
        inputType: InputType.date,
        decoration: const InputDecoration(
          labelText: "Select Date",
          labelStyle: TextStyle(fontSize: 22),
          border: InputBorder.none,
          prefixIcon:
              Icon(Icons.calendar_today, size: 30, color: Color(0xFF050A30)),

          // contentPadding: const EdgeInsets.only(left: 15.0)),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (val) => {widget.start_date = val},
      );

  Widget TimeField(start_time) => FormBuilderDateTimePicker(
        name: 'time',
        initialValue: widget.start_time,
        // initialTime: TimeOfDay(hour: 8, minute: 0),
        fieldHintText: "Add Date",
        inputType: InputType.time,
        initialDate: DateTime.now(),
        decoration: const InputDecoration(
          labelText: "Select Time",
          labelStyle: TextStyle(fontSize: 22),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.watch_later_rounded,
              size: 30, color: Color(0xFF050A30)),

          // contentPadding: const EdgeInsets.only(left: 15.0)),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (val) => {widget.start_time = val},
      );

  Widget FilterCategory() => FormBuilderChoiceChip(
        name: 'choice_chip',
        padding: EdgeInsets.all(2.0),
        // runSpacing: 2.0,
        selectedColor: Color(0xFF5DCAD1),
        decoration: const InputDecoration(
            labelText: 'Select an option', labelStyle: TextStyle(fontSize: 22)),
        labelPadding: EdgeInsets.all(2.0),
        options: const [
          FormBuilderFieldOption(value: 'Academic', child: Text('Academic')),
          FormBuilderFieldOption(
              value: 'Non-Academic', child: Text('Non-Academic')),
        ],
        initialValue: widget.event_type,
        validator: (val) =>
            val.toString() == null ? "Please select event type" : null,
        autovalidateMode: AutovalidateMode.always,
        onChanged: (val) {
          widget.event_type = val.toString();
        },
      );
//
  Widget AddImage() => Row(
        children: const [
          Icon(Icons.photo, size: 30, color: Color(0xFF050A30)),
          Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                'Upload Image',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 18,
                  // padding: const EdgeInsets.all(15.0),
                ),
              )),
        ],
      );
  Widget updateButton(user) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: const Color(0xFF5DCAD1),
          minimumSize: const Size.fromHeight(40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: const FittedBox(
          child: Text(
            'Update',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                decoration: TextDecoration.underline),
          ),
        ),
        onPressed: () async {
          print('yaha hoooo');
          if (widget.title!.isNotEmpty &&
              widget.organiser!.isNotEmpty &&
              widget.loc!.isNotEmpty &&
              widget.organiser!.isNotEmpty &&
              widget.event_type != null) {
            FirebaseFirestore.instance
                .collection("adminEvents")
                .doc(uid)
                .collection('Events')
                .doc(widget.eventID)
                .update({
              'title': widget.title,
              'Organiser': widget.organiser,
              'location': widget.loc,
              'description': widget.description,
              'start_date': widget.start_date,
              'start_time': widget.start_time,
              'event_type': widget.event_type,
              'eventID': widget.eventID,
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => admin()),
            );
            // print("Done");
          }

          // Navigator.pop(context);
        },
      );

  Widget deleteButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          minimumSize: const Size.fromHeight(40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: const FittedBox(
          child: Text(
            'Delete',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                decoration: TextDecoration.underline),
          ),
        ),
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection('adminEvents')
              .doc(uid)
              .collection('Events')
              .doc(widget.eventID) // <-- Doc ID to be deleted.
              .delete()
              .then((_) => print('Deleted'))
              .catchError((error) => print('Delete failed: $error'));

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => admin()),
          );
        },
      );
}

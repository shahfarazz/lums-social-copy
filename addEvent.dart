import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lums_social_app2/screens/Admin/adminDashboard.dart';
import 'package:lums_social_app2/services/addToCollection.dart';
import 'package:lums_social_app2/widget/button_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';

String? url;

class upload {
  Future<String?> uploadImageToFirebase(BuildContext context) async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("images/" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(File(image!.path));
    String downloadURL = await (await uploadTask).ref.getDownloadURL();
    print(downloadURL);
    // uploadTask.then((res) {
    //   print(res.ref.getDownloadURL());
    // });
    return downloadURL;
  }
}

String? title;
String? loc;
String? organiser;
String? description;
DateTime? start_date;
DateTime? start_time;
String? image;
String? event_type;
String? imageURL;

class AddEvent extends StatefulWidget {
  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  String email = '';
  final imageFile = upload();
  // DateTime now = DateFormat("yyyy-MM-dd").format(DateTime.now());

  // List tags = new List(5);
  final _formKey = GlobalKey<FormBuilderState>();
  // final _globalKey = GlobalKey<TagsState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    print(user);
    print(user?.uid);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: ListView(children: <Widget>[
          FormBuilder(
              child: SingleChildScrollView(
            child: Column(children: [
              blueDecor(),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 10.0, top: 15.0),
                child: subText(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 4.0, top: 15.0),
                child: nameField(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 4.0, top: 15.0),
                child: OrganiserField(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 4.0, top: 15.0),
                child: LocationField(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 4.0, top: 15.0),
                child: DescriptionField(),
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
                          child: DateField())),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 4.0, top: 8.0),
                          child: TimeField())),
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
                          child: ButtonWidget(
                              text: 'Upload',
                              onClicked: () async => {
                                    imageURL = await imageFile
                                        .uploadImageToFirebase(context)
                                  }))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 4.0, top: 8.0),
                child: AddButton(user, context),
              ),
              const SizedBox(height: 10),
            ]),
          ))
        ]));
  }

  Widget blueDecor() => Image(
        image: AssetImage('images/background.png'),
        fit: BoxFit.cover,
        height: 250,
        width: 600,
        alignment: Alignment.topCenter,
      );

  Widget subText() => Text(
        'Please fill in the following details carefully to add your event.',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black,
          fontSize: 18,
          // padding: const EdgeInsets.all(15.0),
        ),
      );

  Widget nameField() => FormBuilderTextField(
        name: 'title',
        decoration: InputDecoration(
            hintText: "Enter Event Name",
            border: OutlineInputBorder(),
            contentPadding: const EdgeInsets.only(left: 15.0)),
        validator: (val) => val!.isEmpty ? "Please enter event name" : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (val) => {title = val},
      );

  Widget OrganiserField() => FormBuilderTextField(
        name: 'organiser',
        decoration: InputDecoration(
            hintText: "Enter Organizer Name",
            border: OutlineInputBorder(),
            contentPadding: const EdgeInsets.only(left: 15.0)),
        validator: (val) =>
            val!.isEmpty ? "Please enter event organiser" : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (val) => {organiser = val},
      );
  Widget LocationField() => FormBuilderTextField(
        name: 'location',
        decoration: InputDecoration(
            hintText: "Enter Location",
            border: OutlineInputBorder(),
            contentPadding: const EdgeInsets.only(left: 15.0)),
        // validator: (val) => val!.isEmpty ? "Please enter event location" : null,
        validator: (val) => val!.isEmpty ? "Please enter event location" : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (val) => {loc = val},
      );
  Widget DescriptionField() => FormBuilderTextField(
        name: 'description',
        maxLines: 6,
        minLines: 1,
        decoration: InputDecoration(
            hintText: "Enter Description",
            border: OutlineInputBorder(),
            contentPadding: const EdgeInsets.only(left: 15.0)),
        validator: (val) =>
            val!.isEmpty ? "Please enter event description" : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (val) => {description = val},
      );

  Widget DateField() => FormBuilderDateTimePicker(
        name: 'date',
        firstDate: DateTime.now(),
        initialValue: DateTime.now(),
        initialDate: DateTime.now(),
        fieldHintText: "Add Date",
        inputType: InputType.date,
        decoration: InputDecoration(
          labelText: "Select Date",
          labelStyle: TextStyle(fontSize: 22),
          border: InputBorder.none,
          prefixIcon:
              Icon(Icons.calendar_today, size: 30, color: Color(0xFF050A30)),

          // contentPadding: const EdgeInsets.only(left: 15.0)),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (val) => {
          if (val == null) {start_date = DateTime.now()} else {start_date = val}
        },
      );

  Widget TimeField() => FormBuilderDateTimePicker(
        name: 'time',
        initialValue: DateTime.now(),
        initialTime: TimeOfDay(hour: 8, minute: 0),
        fieldHintText: "Add Date",
        inputType: InputType.time,
        initialDate: DateTime.now(),
        decoration: InputDecoration(
          labelText: "Select Time",
          labelStyle: TextStyle(fontSize: 22),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.watch_later_rounded,
              size: 30, color: Color(0xFF050A30)),

          // contentPadding: const EdgeInsets.only(left: 15.0)),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (val) => {
          if (val == null) {start_time = DateTime.now()} else {start_time = val}
        },
      );

  Widget FilterCategory() => FormBuilderChoiceChip(
        name: 'choice_chip',
        padding: EdgeInsets.all(2.0),
        // runSpacing: 2.0,
        selectedColor: Color(0xFF5DCAD1),
        decoration: InputDecoration(
            labelText: 'Select an option', labelStyle: TextStyle(fontSize: 22)),
        labelPadding: EdgeInsets.all(2.0),
        options: [
          FormBuilderFieldOption(value: 'Academic', child: Text('Academic')),
          FormBuilderFieldOption(
              value: 'Non-Academic', child: Text('Non-Academic')),
        ],
        onChanged: (val) => {
          event_type = val.toString()
          // print(val.toString())
        },
      );
//
  Widget AddImage() => Row(
        children: [
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
  Widget AddButton(user, context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF5DCAD1),
          minimumSize: Size.fromHeight(40),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
        ),
        child: FittedBox(
          child: Text(
            'Add Event',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                decoration: TextDecoration.underline),
          ),
        ),
        onPressed: () async {
          if (title!.isNotEmpty &&
              organiser!.isNotEmpty &&
              loc!.isNotEmpty &&
              description!.isNotEmpty &&
              event_type!.isNotEmpty) {
            if (start_time == null) {
              start_time = DateTime.now();
            }
            if (start_date == null) {
              start_date = DateTime.now();
            }
            addCollection().addEventtoDatabase(
                title,
                organiser,
                loc,
                description,
                start_date,
                start_time,
                event_type,
                user?.uid,
                imageURL);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => admin()),
            );
          }
        },
      );
}

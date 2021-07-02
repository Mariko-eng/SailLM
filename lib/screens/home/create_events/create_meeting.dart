import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sail_live_mobile/models/events.dart';
import 'package:sail_live_mobile/models/user.dart';
import 'package:sail_live_mobile/services/storage.dart';
import 'package:sail_live_mobile/shared/constants.dart';
import 'package:sail_live_mobile/shared/loading.dart';
import 'package:sail_live_mobile/shared/payment.dart';

class CreateMeeting extends StatefulWidget {
  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  String name = '';

  String description = '';

  String email = '';

  int date = 1;

  int month = DateTime.now().month;

  int year = DateTime.now().year;

  int hour = 0;

  int minute = 0;

  String timeError = '';

  String emailsError = '';

  File image;

  String imageError = '';

  List<String> emails = <String>[];

  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  final _controller = TextEditingController();

  final _storage = CloudStorage();

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text('Create Meeting'),
              centerTitle: true,
              backgroundColor: Colors.black,
            ),
            body: Container(
              // padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) => name = value,
                            validator: (value) => value.length > 0
                                ? null
                                : 'Event Name can not be empty',
                            decoration: textFormFieldDecoration.copyWith(
                              hintText: 'Event Name',
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: TextFormField(
                            maxLines: 5,
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) => description = value,
                            validator: (value) => value.length > 0
                                ? null
                                : 'Please give a description for your event.',
                            decoration: textAreaDecoration.copyWith(
                              hintText: 'Event Description',
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: Text(
                            'Event Date',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: timeError.isNotEmpty
                              ? SizedBox(height: 10.0)
                              : SizedBox.shrink(),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: timeError.isNotEmpty
                              ? Text(
                                  timeError,
                                  style: TextStyle(color: Colors.red[800]),
                                )
                              : SizedBox.shrink(),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: Row(
                            children: <Widget>[
                              DropdownButton(
                                dropdownColor: Colors.grey[900],
                                value: year,
                                items: upcomingYears(year),
                                onChanged: (value) {
                                  setState(() {
                                    year = value;
                                  });
                                },
                              ),
                              SizedBox(width: 20.0),
                              DropdownButton(
                                value: month,
                                dropdownColor: Colors.grey[900],
                                items: monthsItems,
                                onChanged: (value) {
                                  setState(() {
                                    month = value;
                                  });
                                },
                              ),
                              SizedBox(width: 20.0),
                              DropdownButton(
                                value: date,
                                dropdownColor: Colors.grey[900],
                                items: getDates(year, month),
                                onChanged: (value) {
                                  setState(() {
                                    date = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: Text(
                            'Event Time',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: Row(
                            children: <Widget>[
                              DropdownButton(
                                dropdownColor: Colors.grey[900],
                                value: hour,
                                items: getNumbers(24),
                                onChanged: (value) {
                                  setState(() {
                                    hour = value;
                                  });
                                },
                              ),
                              SizedBox(width: 20.0),
                              DropdownButton(
                                dropdownColor: Colors.grey[900],
                                value: minute,
                                items: getNumbers(60),
                                onChanged: (value) {
                                  setState(() {
                                    minute = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: Text(
                            'Invite By Email',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(splashColor: Colors.transparent),
                            child: TextFormField(
                              controller: _controller,
                              style: TextStyle(color: Colors.white),
                              onChanged: (value) => email = value,
                              decoration: textFormFieldDecoration.copyWith(
                                hintText: 'Enter email',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.red[800],
                                  ),
                                  onPressed: () => _controller.clear(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: emailsError.isNotEmpty
                              ? SizedBox(height: 10.0)
                              : SizedBox.shrink(),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: emailsError.isNotEmpty
                              ? Text(
                                  emailsError,
                                  style: TextStyle(color: Colors.red),
                                )
                              : SizedBox.shrink(),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.0),
                          child: ButtonTheme(
                            buttonColor: Colors.red[700],
                            child: RaisedButton(
                              onPressed: () {
                                RegExp regex = RegExp(emailPattern);
                                if (email.isNotEmpty && regex.hasMatch(email)) {
                                  setState(() {
                                    emails.add(email);
                                  });
                                }
                              },
                              shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            'Invited Guests: ${emails.length}',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: ButtonTheme(
                            height: 55.0,
                            minWidth: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              color: Colors.grey[900],
                              shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                'Select Image',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                              onPressed: () async {
                                final pickedFile = await picker.getImage(
                                    source: ImageSource.gallery);

                                if (pickedFile != null) {
                                  setState(() {
                                    image = File(pickedFile.path);
                                    imageError = '';
                                  });
                                  return;
                                } else {
                                  setState(() {
                                    imageError = 'No image was selected';
                                  });
                                  return;
                                }
                              },
                            ),
                          ),
                        ),
                        imageError.isEmpty
                            ? SizedBox.shrink()
                            : SizedBox(height: 10.0),
                        imageError.isEmpty
                            ? SizedBox.shrink()
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0),
                                child: Text(
                                  imageError,
                                  style: TextStyle(
                                    color: Colors.red[800],
                                  ),
                                ),
                              ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: ButtonTheme(
                                  height: 55.0,
                                  child: RaisedButton(
                                    color: Colors.red[800],
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text(
                                      'Create Meeting',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        timeError = '';
                                        emailsError = '';
                                        loading = true;
                                      });
                                      if (_formKey.currentState.validate()) {
                                        // Validate that the date is in the furture
                                        DateTime eventDate = DateTime(
                                            year, month, date, hour, minute);
                                        if (eventDate
                                            .isBefore(DateTime.now())) {
                                          setState(() {
                                            timeError = 'Invalid time';
                                            loading = false;
                                          });
                                          return;
                                        }

                                        // Validate that the email list is not empty
                                        if (emails.isEmpty) {
                                          setState(() {
                                            emailsError =
                                                'Invitation list can not be empty';
                                            loading = false;
                                          });
                                        }

                                        // validate that an image has been provided
                                        if (image == null) {
                                          setState(() {
                                            imageError = 'Invalid Image';
                                            loading = false;
                                          });
                                          return;
                                        }

                                        final response =
                                            await _storage.uploadImage(image);
                                        if (!response['isValid']) {
                                          setState(() {
                                            imageError =
                                                'Failed to upload image';
                                            loading = false;
                                          });
                                          return;
                                        }

                                        SailLiveEvent event = SailLiveEvent(
                                          createdBy: Provider.of<SailLiveUser>(
                                            context,
                                            listen: false,
                                          ).uid,
                                          date: eventDate,
                                          description: description,
                                          name: name,
                                          price: '0',
                                          eventType: 'meeting',
                                          emails: emails,
                                          image: response['url'],
                                        );

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PaymentWidget(
                                              event: event,
                                              user: Provider.of<SailLiveUser>(
                                                context,
                                                listen: false,
                                              ),
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      setState(() {
                                        loading = false;
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

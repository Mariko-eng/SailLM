import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sail_live_mobile/models/events.dart';
import 'package:sail_live_mobile/models/user.dart';
import 'package:sail_live_mobile/services/database.dart';
import 'package:sail_live_mobile/services/storage.dart';
import 'package:sail_live_mobile/shared/constants.dart';
import 'package:sail_live_mobile/shared/loading.dart';

class CreateConcert extends StatefulWidget {
  @override
  _CreateConcertState createState() => _CreateConcertState();
}

class _CreateConcertState extends State<CreateConcert> {
  String name = '';

  String description = '';

  int year = DateTime.now().year;

  int month = DateTime.now().month;

  int date = 1;

  int hour = DateTime.now().hour;

  int minute = DateTime.now().minute;

  String price = '0';

  bool loading = false;

  File image;

  String imageError = '';

  String timeError = '';

  final _formKey = GlobalKey<FormState>();

  final _database = Database();

  final _storage = CloudStorage();

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text(
                'Create Concert',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
            ),
            body: ListView(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          onChanged: (value) => name = value,
                          validator: (value) => value.length > 0
                              ? null
                              : 'Concert Name can not be empty',
                          decoration: textFormFieldDecoration.copyWith(
                            hintText: 'Concert Name',
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
                          validator: (value) => description.length > 0
                              ? null
                              : 'Concert Description can not be empty',
                          decoration: textAreaDecoration.copyWith(
                            hintText: 'Concert Description',
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              price = value.replaceAllMapped(numReg, mathFunc),
                          validator: (value) {
                            if (int.tryParse(value) == null) {
                              return 'There are no free events';
                            }

                            return int.parse(value) > 0
                                ? null
                                : 'There are no free events';
                          },
                          decoration: textFormFieldDecoration.copyWith(
                            hintText: 'Ticket Price',
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: Text(
                          'Concert Date',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
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
                              dropdownColor: Colors.grey[900],
                              value: month,
                              items: monthsItems,
                              onChanged: (value) {
                                setState(() {
                                  month = value;
                                });
                              },
                            ),
                            SizedBox(width: 20.0),
                            DropdownButton(
                              dropdownColor: Colors.grey[900],
                              value: date,
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
                          'Concert Time',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: timeError.isEmpty
                            ? SizedBox.shrink()
                            : Text(
                                timeError,
                                style: TextStyle(color: Colors.red[800]),
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
                        child: ButtonTheme(
                          height: 55.0,
                          minWidth: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Colors.red[800],
                            child: Text(
                              'Create Concert',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });

                              if (_formKey.currentState.validate()) {
                                // Validate that event date is in the future
                                DateTime eventDate =
                                    DateTime(year, month, date, hour, minute);
                                if (eventDate.isBefore(DateTime.now())) {
                                  setState(() {
                                    timeError = 'Invalid date';
                                    loading = false;
                                  });
                                  return;
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
                                    imageError = 'Failed to upload image';
                                    loading = false;
                                  });
                                  return;
                                }

                                SailLiveEvent event = SailLiveEvent(
                                  createdBy: Provider.of<SailLiveUser>(context,
                                          listen: false)
                                      .uid,
                                  date: eventDate,
                                  description: description,
                                  price: price,
                                  name: name,
                                  eventType: 'concert',
                                  emails: [],
                                  image: response['url'],
                                );

                                await _database.createEvent(event);
                                Navigator.pop(context);
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
          );
  }
}

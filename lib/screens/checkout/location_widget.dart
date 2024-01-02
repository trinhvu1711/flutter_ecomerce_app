import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/const/validator.dart';
import 'package:flutter_ecomerce_app/models/location_model.dart';
import 'package:flutter_ecomerce_app/providers/location_provider.dart';
import 'package:provider/provider.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({Key? key}) : super(key: key);
  static const routeName = "/Location";

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  late final FocusNode _nameFocusNode, _phoneFocusNode, _addressFocusNode;

  late final TextEditingController _nameController,
      _phoneController,
      _addressController;
  final _formKey = GlobalKey<FormState>();

  String? _wardValue, _cityValue, _districtValue;
  String? _wardCodeValue, _cityCodeValue, _districtCodeValue;
  bool _isLoading = false;

  @override
  void initState() {
    _nameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _addressFocusNode = FocusNode();

    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();

    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _addLocationFct(LocationProvider locationProvider) async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      try {
        int? locationId = locationProvider.getLocations?.locationId != null
            ? int.parse(locationProvider.getLocations!.locationId)
            : Random().nextInt(100000);

        LocationModel locationModel = LocationModel(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          city: _cityValue!,
          district: _districtValue!,
          ward: _wardValue!,
          addressDetails: _addressController.text.trim(),
          locationId: locationId.toString(),
          removed: false,
        );
        locationProvider.addToLocationtDB(
            locationModel: locationModel, context: context);
        Navigator.pop(context);
      } catch (e) {
        print(e.toString());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in the missing fields'),
          backgroundColor: Colors.red[400],
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final locationModel = locationProvider.getLocations;
    if (locationModel != null && locationModel.locationId != '') {
      _nameController.text = locationModel.name;
      _phoneController.text = locationModel.phone;
      // _cityValue = locationModel.city;
      // _wardValue = locationModel.ward;
      // _districtValue = locationModel.district;
      _addressController.text = locationModel.addressDetails;
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Delivery Address',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  textInputAction: TextInputAction.next,
                  decoration: (const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter name',
                  )),
                  validator: (value) {
                    return MyValidators.displayNamevalidator(value);
                  },
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_phoneFocusNode);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  keyboardType: TextInputType.number,
                  decoration: (const InputDecoration(
                    labelText: 'Phone',
                  )),
                  validator: (value) {
                    return MyValidators.phoneNumberValidator(value);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                //FutureBuilder for city
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: locationProvider.fetchLocations(
                      'https://provinces.open-api.vn/api/?depth=1'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Map<String, dynamic>> uniqueCities =
                          snapshot.data!.toSet().toList();
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(),
                        ),
                        value: _cityValue,
                        items: uniqueCities.map((Map<String, dynamic> value) {
                          return DropdownMenuItem<String>(
                            value: value['name'],
                            child: Text(value['name']),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          var cityCodeValue = snapshot.data!.firstWhere(
                              (item) => item['name'] == newValue)['code'];
                          setState(() {
                            _cityValue = newValue;
                            _cityCodeValue = cityCodeValue;
                          });
                        },
                      );
                    } else if (snapshot.hasError) {
                      return DropdownButtonFormField<String>(
                        value: 'Choose your location',
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'Choose your location',
                            child: Text('Choose your location'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          // Handle the new value if necessary
                        },
                        validator: (value) {
                          return MyValidators.uploadProdTexts(
                              value: value,
                              toBeReturnedString: "City is missing");
                        },
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                //FutureBuilder for district
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: locationProvider.fetchDistricts(
                      'https://provinces.open-api.vn/api/p/$_cityCodeValue?depth=2'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Map<String, dynamic>> uniqueDistricts =
                          snapshot.data!.toSet().toList();
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'District',
                          border: OutlineInputBorder(),
                        ),
                        value: _districtValue,
                        items:
                            uniqueDistricts.map((Map<String, dynamic> value) {
                          return DropdownMenuItem<String>(
                            value: value['name'],
                            child: Text(value['name']),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          var districtCodeValue = snapshot.data!.firstWhere(
                              (item) => item['name'] == newValue)['code'];
                          setState(() {
                            _districtValue = newValue!;
                            _districtCodeValue = districtCodeValue;
                          });
                        },
                      );
                    } else if (snapshot.hasError) {
                      return DropdownButtonFormField<String>(
                        value: 'Choose your location',
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'Choose your location',
                            child: Text('Choose your city'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          // Handle the new value if necessary
                        },
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                // FutureBuilder for ward
                FutureBuilder<List<String>>(
                  future: locationProvider.fetchWards(
                      'https://provinces.open-api.vn/api/d/$_districtCodeValue?depth=2'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> uniqueWards =
                          snapshot.data!.toSet().toList();
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Ward',
                          border: OutlineInputBorder(),
                        ),
                        value: _wardValue,
                        items: uniqueWards.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _wardValue = newValue;
                            // locationProvider.setWard(newValue!);
                          });
                        },
                      );
                    } else if (snapshot.hasError) {
                      return DropdownButtonFormField<String>(
                        value: 'Choose your location',
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'Choose your location',
                            child: Text('Choose your district'),
                          ),
                        ],
                        onChanged: (String? newValue) {},
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: 'Enter your address details here...',
                  ),
                  validator: (value) {
                    return MyValidators.uploadProdTexts(
                        value: value,
                        toBeReturnedString: "Description is missing");
                  },
                  onFieldSubmitted: (value) {
                    _addLocationFct(locationProvider);
                    // addressFocusNode.unfocus();
                  },
                  controller: _addressController,
                  focusNode: _addressFocusNode,
                ),

                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      _addLocationFct(locationProvider);
                    },
                    child: const Text('Save'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

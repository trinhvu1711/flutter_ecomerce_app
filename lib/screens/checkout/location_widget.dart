import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/providers/location_provider.dart';
import 'package:provider/provider.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({Key? key}) : super(key: key);

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  @override
  Widget build(BuildContext context) {
    var locationProvider = Provider.of<LocationProvider>(
      context,
    );
    FocusNode nameFocusNode = FocusNode();
    FocusNode phoneFocusNode = FocusNode();
    FocusNode addressFocusNode = FocusNode();
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
          child: Column(
            children: <Widget>[
              TextField(
                autofocus: true,
                focusNode: nameFocusNode,
                decoration: (const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Nguyen Van A',
                )),
                onSubmitted: (value) {
                  setState(() {
                    locationProvider.setName(value);
                  });
                  nameFocusNode.unfocus();
                },
                controller: TextEditingController(
                    text: locationProvider.consumeLocation?.name ??
                        locationProvider.name),
              ),
              const SizedBox(
                height: 20,
              ),

              TextField(
                focusNode: phoneFocusNode,
                keyboardType: TextInputType.number,
                decoration: (const InputDecoration(
                  labelText: 'Phone',
                )),
                onSubmitted: (value) {
                  if (isValidPhoneNumber(value)) {
                    setState(() {
                      locationProvider.setPhone(value);
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Invalid phone number'),
                        backgroundColor: Colors.red[400],
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                  phoneFocusNode.unfocus();
                },
                // controller: TextEditingController(
                //     text: locationProvider.consumeLocation?.phone ?? ''),
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
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                      value: locationProvider.consumeLocation?.city,
                      items: snapshot.data?.map((Map<String, dynamic> value) {
                        return DropdownMenuItem<String>(
                          value: value['name'],
                          child: Text(value['name']),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          locationProvider.setCity(
                              newValue!,
                              snapshot.data!.firstWhere(
                                  (item) => item['name'] == newValue)['code']);
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
                    'https://provinces.open-api.vn/api/p/${locationProvider.cityCode}?depth=2'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'District',
                        border: OutlineInputBorder(),
                      ),
                      value: locationProvider.consumeLocation?.district,
                      items: snapshot.data?.map((Map<String, dynamic> value) {
                        return DropdownMenuItem<String>(
                          value: value['name'],
                          child: Text(value['name']),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          locationProvider.setDistrict(
                              newValue!,
                              snapshot.data!.firstWhere(
                                  (item) => item['name'] == newValue)['code']);
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
                    'https://provinces.open-api.vn/api/d/${locationProvider.districtCode}?depth=2'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Ward',
                        border: OutlineInputBorder(),
                      ),
                      value: locationProvider.consumeLocation?.ward,
                      items: snapshot.data?.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          locationProvider.setWard(newValue!);
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
              Container(
                child: TextField(
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: 'Enter your address details here...',
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      locationProvider.setAddressDetails(value);
                    });
                    addressFocusNode.unfocus();
                  },
                  controller: TextEditingController(
                      text: locationProvider.consumeLocation?.addressDetails ??
                          locationProvider.addressDetails),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (locationProvider.isEmptyField() == false) {
                      locationProvider.addLocation(
                          name: locationProvider.name,
                          phone: locationProvider.phone,
                          city: locationProvider.city,
                          district: locationProvider.district,
                          ward: locationProvider.ward,
                          addressDetails: locationProvider.addressDetails);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              const Text('Please fill in the missing fields'),
                          backgroundColor: Colors.red[400],
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}

bool isValidPhoneNumber(String phoneNumber) {
  // Biểu thức chính quy để kiểm tra số điện thoại
  RegExp regex =
      RegExp(r'^(0?)(3[2-9]|5[6|8|9]|7[0|6-9]|8[0-6|8|9]|9[0-4|6-9])[0-9]{7}$');

  // Sử dụng hàm test để kiểm tra tính hợp lệ
  return regex.hasMatch(phoneNumber);
}

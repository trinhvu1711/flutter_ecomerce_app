import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/location_model.dart';
import 'package:flutter_ecomerce_app/providers/location_provider.dart';
import 'package:flutter_ecomerce_app/screens/checkout/location_widget.dart';
import 'package:provider/provider.dart';

class AddressWidget extends StatelessWidget {
  const AddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final locationModel = locationProvider.locationItems;
    return locationModel != null
        ? InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LocationWidget()));
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 95,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.share_location_outlined),
                            SizedBox(width: 8.0),
                            Text(
                              'Delivery Address',
                              style: TextStyle(fontSize: 23),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          '${locationModel!.name} | ${locationModel!.phone}',
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          '${locationModel!.addressDetails}, ${locationModel!.ward}, ${locationModel!.district},${locationModel!.city}.',
                          softWrap: false,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 17),
                        )
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 5,
                    child: Icon(Icons.chevron_right_outlined),
                  ),
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LocationWidget()));
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: const Row(
                children: [
                  Expanded(
                    flex: 95,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.share_location_outlined),
                            SizedBox(width: 8.0),
                            Text(
                              'Delivery Address',
                              style: TextStyle(fontSize: 23),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Please select your location',
                          softWrap: false,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 17),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Icon(Icons.chevron_right_outlined),
                  ),
                ],
              ),
            ),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sprint2/Models/apis/api_response.dart';
import 'package:sprint2/Models/building_model.dart';
import 'package:sprint2/View/Screens/ViewPerBuilding/viewPerBuilding.dart';
import 'package:sprint2/View/components/BuildingButton.dart';
import 'package:provider/provider.dart';
import 'package:sprint2/View_Models/building_viewModel.dart';
import 'package:sprint2/constraints.dart';

import 'BuildingButton.dart';

// ignore: must_be_immutable
class BuidlingButtons extends StatelessWidget {
  List<Widget> buildingsWidget = <Widget>[];
  List<Building>? buildings = <Building>[
    new Building(
        capacity: 90,
        name: "Pruebaaaaaaaaaa",
        classrooms: [new Classroom(currentCap: 10, maxCap: 10, number: 101)])
  ];

  void createBuildingList(context) {
    ApiResponse apiResponse = Provider.of<BuildingViewModel>(context).response;
    buildings = apiResponse.data as List<Building>?;
  }

  @override
  Widget build(BuildContext context) {
    createBuildingList(context);
    if (buildings != null) {
      buildings!.forEach((building) {
        buildingsWidget.add(new BuildingButton(
          text: building.name.toUpperCase(),
          press: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ViewPerBuildingWidget(
                building: building.name.toUpperCase(),
              );
            }));
          },
          codigo: building.name.toUpperCase(),
        ));
        buildingsWidget.add(SizedBox(height: 20));
      });
      return Expanded(
          flex: 12,
          child: ListView(
            padding: EdgeInsets.fromLTRB(6, 0, 6, 4),
            children: buildingsWidget,
          ));
    } else {
      return Expanded(
          flex: 12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Cargando edificios...'),
              SizedBox(height: 20),
              Center(
                child: CircularProgressIndicator(
                  color: kPrimaryDarkColor,
                ),
              )
            ],
          ));
    }
  }
}

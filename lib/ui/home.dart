import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hello_app/ui/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StackedView<HomeViewModel> {
  @override
  viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.getCurrentPosition();
    viewModel.getDistance();
  }

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(90),
          child: Column(
            children: [
              Text("Ini Dave"),
              Text("Latitude Dave : ${viewModel.current_position?.latitude}"),
              Text("Longitude Dave : ${viewModel.current_position?.longitude}"),
              SizedBox(
                height: 25,
              ),
              Text("Jarak Kamu Dengan Tadeus"),
              Text("${viewModel.distanceInMeters} M")
            ],
          )),
    );
  }
}

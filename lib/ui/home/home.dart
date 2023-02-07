import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hello_app/ui/home/home_viewmodel.dart';
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
              viewModel.distanceInMeters < 1000
                  ? Text("${viewModel.distanceInMeters} M")
                  : Text("${viewModel.distanceInMeters / 1000} KM"),
              viewModel.current_position == null ? ElevatedButton(
                 style: TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                      fixedSize: Size(400, 50),
                      elevation: 0),
                  onPressed: () => {},
                  child: Text(
                    "Loading",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black
                    ),
                  )
              ) : SizedBox(),
              viewModel.distanceInMeters >= 10  &&  viewModel.current_position != 0  ?
              ElevatedButton(
                 style: TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                      fixedSize: Size(400, 50),
                      elevation: 0),
                  onPressed: () => {},
                  child: Text(
                    "Jarak Terlalu Jauh",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black
                    ),
                  )
              ) : SizedBox(),
              viewModel.distanceInMeters < 10  && viewModel.distanceInMeters > 0 ?
              ElevatedButton(
                 style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      fixedSize: Size(400, 50),
                      elevation: 0),
                  onPressed: () => {},
                  child: Text(
                    "Absen Masuk",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                    ),
                  )
              ) : SizedBox()
            ],
          )),
    );
  }
}

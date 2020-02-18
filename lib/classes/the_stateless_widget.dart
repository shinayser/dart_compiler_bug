import 'package:dart_compiler_bug/classes/requests.dart';
import 'package:dart_compiler_bug/classes/user_location.dart';
import 'package:dart_compiler_bug/classes/utils.dart';
import 'package:dart_compiler_bug/main.dart';
import 'package:flutter/material.dart';
import 'package:dartx/dartx.dart';
import 'future_completer.dart';
import 'package:geolocator/geolocator.dart';

class TheStatelessWidget extends StatelessWidget {
  final int localId;

  TheStatelessWidget(this.localId);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ClipRRect(
          child: AppBar(
            title: Text("A fancy title"),
            leading: Icon(Icons.build),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Tap the button below",
                style: theme.textTheme.caption,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              RaisedButton.icon(
                onPressed: () {
                  _openModalDialog(context);
                },
                color: Colors.green,
                icon: Icon(
                  Icons.check,
                  size: 16,
                ),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Tap me",
                    maxLines: 1,
                  ),
                ),
                shape: StadiumBorder(),
              ),
//              RaisedButton.icon(
//                onPressed: () {
//                  _cancelRecovery(context);
//                },
//                color: Colors.red,
//                icon: Icon(
//                  Icons.cancel,
//                  size: 16,
//                ),
//                label: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Text(
//                    "Desistir",
//                    maxLines: 1,
//                  ),
//                ),
//                shape: StadiumBorder(),
//              ),
            ],
          ),
        )
      ],
    );
  }

  void _openModalDialog(BuildContext recoverContext) {
    final navigator = Navigator.of(recoverContext);

    showDialog(
        context: recoverContext,
        builder: (context) => AlertDialog(
              title: Text("Tap me and look at logs"),
              content: Text("Just tap YES and look at logs"),
              actions: <Widget>[
                FlatButton(
                  onPressed: navigator.pop,
                  child: Text("Não"),
                ),
                FlatButton(
                  onPressed: () {
                    final innerNavigator = Navigator.of(recoverContext);
                    innerNavigator.pop(); //Finishes the confirmation dialog
                    innerNavigator.pop(); //Finishes the RecoverPage
                    showModalFutureCompleter(
                      context: context,
                      futureConstructor: () => lastKnownLocation
                          .timeout(5.seconds)
                          .catchError((it) => null)
                          .then((location) async {
                        return await _theCallThatCausesTheProblem(location);
                      }),
                      onCompleted: () {},
                    );
                  },
                  child: Text(
                    "Sim",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ));
  }

  _theCallThatCausesTheProblem(Position location) async {
    print(
        'The value of \'localId\' here is $localId and it is an \'${localId.runtimeType}\'');
    return Requests.finishOrCancelRecover(
            localId,
            false,
            location != null
                ? UserLocation(
                    latitude: location.latitude,
                    longitude: location.longitude,
                    deviceId: await deviceId,
                  )
                : null)
        .then((_) {
      print(
        'Now go back to the code and replace the '
        'call of the method \'_theCallThatCausesTheProblem\' by '
        '\'_thisPartiallyFixesIt\':\nThis will fix the value but still changes the variable type',
      );
      return true;
    });
  }

  ///THIS CALL KEEPS THE VALUE BUT CHANGES THE TYPE TO [double]
  _thisPartiallyFixesIt(Position location) async {
    print(
        'The value of \'localId\' here is $localId and it is an \'${localId.runtimeType}\'');
    var theDeviceId = await deviceId;
    return Requests.finishOrCancelRecover(
            localId,
            false,
            location != null
                ? UserLocation(
                    latitude: location.latitude,
                    longitude: location.longitude,
                    deviceId: theDeviceId,
                  )
                : null)
        .then((_) {
      print(
        'See how the value kept the same but type changed to \'double\'?',
      );
      return true;
    });
  }
}

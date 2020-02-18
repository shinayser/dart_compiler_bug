import 'dart:async';

import 'package:dart_compiler_bug/classes/pair_widget.dart';
import 'package:flutter/material.dart';
import 'utils.dart';

class FutureCompleter extends StatefulWidget {
  final Future<bool> Function() futureBuilder;
  final VoidCallback onCompleted;
  final String title;
  final bool embedded;
  final bool showCancelButton;
  final WidgetBuilder builder;

  FutureCompleter({
    this.futureBuilder,
    this.onCompleted,
    this.title,
    this.embedded = true,
    this.showCancelButton = false,
    this.builder,
  });

  @override
  _FutureCompleterState createState() => _FutureCompleterState();
}

class _FutureCompleterState extends State<FutureCompleter> {
  Future _future;

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  _refresh() {
    setState(() {
      _future = widget.futureBuilder()
        ..then((success) {
          if (success && widget.builder == null) {
            if (mounted) {
              Timer(Duration(milliseconds: 1000), () {
                _finish();
              });
            } else {
              _finish();
            }
          }
        });
    });
  }

  void _finish() {
    if (!widget.embedded) {
      var navigator = context?.navigator;
      if (mounted && navigator?.canPop() == true) {
        navigator.pop();
      }

      if (widget.onCompleted != null) {
        WidgetsBinding.instance
            .addPostFrameCallback((it) => widget.onCompleted());
      }
    } else {
      if (widget.onCompleted != null) {
        widget.onCompleted();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      height: 180,
      child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.title ?? "Processando, por favor aguarde...",
                        style: theme.textTheme.body1,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      CircularProgressIndicator(),
                    ],
                  ),
                );

              case ConnectionState.done:
                if (snapshot.hasError || snapshot.data == false) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 8),
                        Text(
                          "Ops, algo saiu errado :(",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.body1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Poderia tentar novamente?",
                          style: theme.textTheme.caption,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        PairWidget.vertical(
                          child1: RaisedButton(
                            child: Text("Tentar novamente"),
                            onPressed: _refresh,
                            shape: StadiumBorder(),
                          ),
                          spacing: 0,
                          child2: widget.showCancelButton
                              ? MaterialButton(
                                  child: Text(
                                    "Cancelar",
                                    style: theme.textTheme.body1.copyWith(
                                      color: theme.accentColor,
                                    ),
                                  ),
                                  onPressed: context.navigator.pop,
//                                      shape: StadiumBorder(),
                                )
                              : null,
                        ),
                      ],
                    ),
                  );
                } else {
                  if (widget.builder == null) {
                    return Center(
                      child: Icon(Icons.check),
                    );
                  } else {
                    return widget.builder(context);
                  }
                }
                break;

              default:
                return Container();
            }
          }),
    );
  }
}

void showModalFutureCompleter({
  @required BuildContext context,
  @required Future<bool> Function() futureConstructor,
  VoidCallback onCompleted,
  String title,
  WidgetBuilder successChild,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => WillPopScope(
      child: FutureCompleter(
        futureBuilder: futureConstructor,
        onCompleted: onCompleted,
        title: title,
        embedded: false,
        showCancelButton: true,
        builder: successChild,
      ),
      onWillPop: () async => false,
    ),
    isDismissible: false,
  );
}

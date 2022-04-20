import 'package:flutter/material.dart';
import 'package:minigames/games/connect_four/token.dart';
import 'package:minigames/generated/l10n.dart';
import 'package:minigames/styles.dart';
import 'package:minigames/widgets/dropdown.dart';
import 'package:provider/provider.dart';

class ConnectFourPage extends StatefulWidget {
  const ConnectFourPage({
    Key? key,
  }) : super(key: key);

  @override
  _ConnectFourState createState() => _ConnectFourState();
}

class _ConnectFourState extends State<ConnectFourPage> {
  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<ConnectFourNotifier>(
        create: (_) => ConnectFourNotifier(),
        builder: (context, _) => Scaffold(
            appBar: AppBar(title: Text(S.of(context).connect_four_title)),
            body: SingleChildScrollView(
              child: Padding(
                padding: containerPadding,
                child: Column(children: [
                  DropdownWidget(children: [
                    Text(
                      S.of(context).connect_four_desc,
                      style: docTextStyle,
                    ),
                  ], title: S.of(context).description),
                  margin,
                  mainContent(context),
                  margin,
                  steps(context)
                ]),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.refresh),
            )),
      );

  Widget mainContent(BuildContext context) => DataTable(
        columns: List.generate(
            7,
            (index) => DataColumn(
                label: Text("${index + 1}"),
                onSort: (a, b) => {
                      Provider.of<ConnectFourNotifier>(context, listen: false)
                          .step(index)
                    })),
        rows: List.generate(
            6,
            (j) => DataRow(
                cells: List.generate(
                    7,
                    (i) => DataCell(ConnectFourToken(
                        type: Provider.of<ConnectFourNotifier>(context).board[i]
                            [5 - j]))))),
      );

  Widget steps(BuildContext context) =>
      Text(Provider.of<ConnectFourNotifier>(context).saveToString());
}

class ConnectFourNotifier with ChangeNotifier {
  late List<List<ConnectFourTokenType>> board;
  late bool isFirstPlayer;
  late int count;
  late bool finished;

  bool step(int where) {
    if (finished) return false;
    for (var i = 0; i < 6; i++) {
      if (board[where][i] == ConnectFourTokenType.none) {
        if (isFirstPlayer) {
          board[where][i] = ConnectFourTokenType.first;
        } else {
          board[where][i] = ConnectFourTokenType.last;
        }
        isFirstPlayer = !isFirstPlayer;
        count++;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  bool detectGameOver() {
    return false;
  }

  String saveToString() {
    List lines = List.generate(6, (index) => "");
    List blank = List.generate(6, (index) => 0);

    for (var i = 0; i < 7; i++) {
      for (var j = 0; j < 6; j++) {
        switch (board[i][j]) {
          case ConnectFourTokenType.first:
            {
              if (blank[j] != 0) {
                lines[j] += blank[j].toString();
                blank[j] = 0;
              }
              lines[j] += "O";
            }
            break;
          case ConnectFourTokenType.last:
            {
              if (blank[j] != 0) {
                lines[j] += blank[j].toString();
                blank[j] = 0;
              }
              lines[j] += "o";
            }
            break;
          default:
            {
              blank[j]++;
            }
        }
      }
    }

    for (var i = 0; i < 6; i++) {
      if (blank[i] != 0) {
        lines[i] += blank[i].toString();
      }
    }
    return lines.join(":");
  }

  ConnectFourNotifier() {
    softReset();
  }

  softReset() {
    board = List.generate(
        7, (index) => List.generate(6, (i) => ConnectFourTokenType.none));
    isFirstPlayer = true;
    count = 0;
    finished = false;
  }
}

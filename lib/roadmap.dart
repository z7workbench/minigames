import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:minigames/generated/l10n.dart';

class Roadmap extends StatefulWidget {
  const Roadmap({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RoadmapState();
}

class _RoadmapState extends State<Roadmap> {
  PackageInfo _info = PackageInfo(
      appName: "appName",
      packageName: "packageName",
      version: "version",
      buildNumber: "buildNumber");
  late String _version;

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  getVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _info = info;
      _version = _info.version;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(S.of(context).roadmap)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(_version),
          ],
        ),
      ));
}

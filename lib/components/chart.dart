import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartAngin extends StatefulWidget {
  final List<ChartData> windData;

  const ChartAngin({required this.windData, super.key});

  @override
  State<ChartAngin> createState() => _ChartAnginState();
}

class _ChartAnginState extends State<ChartAngin> {
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      zoomMode: ZoomMode.x,
      enablePinching: true,
      enableDoubleTapZooming: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border(
          top: BorderSide.none,
          left: BorderSide.none,
          right: BorderSide.none,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Row(
              children: [
                Text(
                  '   Real-Time Wave Data (Angin)',
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[300], thickness: 1),
          Container(
            height: 150,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              zoomPanBehavior: _zoomPanBehavior,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                autoScrollingDelta: 5,
                labelStyle: const TextStyle(fontSize: 10),
                autoScrollingMode: AutoScrollingMode.start,
              ),
              primaryYAxis: NumericAxis(
                isVisible: false,
                majorGridLines: const MajorGridLines(width: 0),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <LineSeries<ChartData, String>>[
                LineSeries<ChartData, String>(
                  dataSource: widget.windData,
                  xValueMapper: (ChartData data, _) => data.time,
                  yValueMapper: (ChartData data, _) => data.value,
                  name: 'Angin',
                  color: Colors.blue,
                  width: 3,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartArus extends StatefulWidget {
  final List<ChartData> currentData;

  const ChartArus({required this.currentData, super.key});

  @override
  State<ChartArus> createState() => _ChartArusState();
}

class _ChartArusState extends State<ChartArus> {
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      zoomMode: ZoomMode.x,
      enablePinching: true,
      enableDoubleTapZooming: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        border: Border(
          top: BorderSide.none,
          left: BorderSide.none,
          right: BorderSide.none,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Row(
              children: [
                Text(
                  '   Real-Time Wave Data (Arus)',
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[300], thickness: 1),
          Container(
            height: 150,
            child: SfCartesianChart(
              zoomPanBehavior: _zoomPanBehavior,
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                autoScrollingDelta: 5,
                labelStyle: const TextStyle(fontSize: 10),
                autoScrollingMode: AutoScrollingMode.start,
              ),
              primaryYAxis: NumericAxis(
                isVisible: false,
                majorGridLines: const MajorGridLines(width: 0),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <LineSeries<ChartData, String>>[
                LineSeries<ChartData, String>(
                  dataSource: widget.currentData,
                  xValueMapper: (ChartData data, _) => data.time,
                  yValueMapper: (ChartData data, _) => data.value,
                  name: 'Arus',
                  color: Colors.green,
                  width: 3,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.time, this.value);
  final String time;
  final double value;
}

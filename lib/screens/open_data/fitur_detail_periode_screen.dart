import 'package:flutter/material.dart';
import 'package:majadigi/screens/open_data/open_data_dummy.dart';
import 'package:fl_chart/fl_chart.dart';

class FiturDetailPeriodeScreen extends StatefulWidget {

  final String periode;

  const FiturDetailPeriodeScreen({
    super.key,
    required this.periode,
    final VoidCallback? onBack,
  });

  @override
  State<FiturDetailPeriodeScreen> createState() =>
      _FiturDetailPeriodeScreenState();
}

class _FiturDetailPeriodeScreenState
    extends State<FiturDetailPeriodeScreen> {

      final ScrollController tableScrollController =
        ScrollController();

      List<String> getUniqueValues(
        String Function(DetailPeriodeModel) selector,
      ) {

        return [
          "Semua",
          ...dummyDetailPeriode
              .map(selector)
              .where((item) => item.isNotEmpty)
              .toSet()
              .toList(),
        ];
      }

  int selectedTab = 0;
  String selectedPeriode = "2026-Q1";
  String selectedTabelTahun = "2026";
  String selectedKategori = "Semua";
  String selectedProvinsi = "Semua";
  String selectedKabKota = "Semua";
  String selectedPeriodeUpdate = "Semua";
  String selectedSatuan = "Semua";
  String selectedJumlah = "Semua";
  String selectedTahun = "2026";
  String selectedChart = "Bar Chart";
  String selectedXAxis = "periode_update";
  String selectedYAxis = "jumlah";
  String appliedChart = "Bar Chart";
  String appliedXAxis = "periode_update";
  String appliedYAxis = "jumlah";

  late List<String> provinsiItems;
  late List<String> kabKotaItems;
  late List<String> periodeItems;
  late List<String> kategoriItems;
  late List<String> satuanItems;
  late List<String> tahunItems;
  late List<String> jumlahItems;

  List<DetailPeriodeModel> get filteredData {

    return dummyDetailPeriode.where((item) {

      final provinsiMatch =
          selectedProvinsi == "Semua" ||
          item.namaProvinsi == selectedProvinsi;

      final kabKotaMatch =
          selectedKabKota == "Semua" ||
          item.kabKota == selectedKabKota;

      final periodeMatch =
          selectedPeriodeUpdate == "Semua" ||
          item.periodeUpdate ==
              selectedPeriodeUpdate;

      final kategoriMatch =
          selectedKategori == "Semua" ||
          item.kategori == selectedKategori;

      final jumlahMatch =
          selectedJumlah == "Semua" ||
          item.jumlahPosko.toString() ==
              selectedJumlah;

      final satuanMatch =
          selectedSatuan == "Semua" ||
          item.satuan == selectedSatuan;

      final tahunMatch =
          selectedTahun == "Semua" ||
          item.tahun == selectedTahun;

      return provinsiMatch &&
          kabKotaMatch &&
          periodeMatch &&
          kategoriMatch &&
          jumlahMatch &&
          satuanMatch &&
          tahunMatch;
    }).toList();
  }

  List<DetailPeriodeModel> get chartFilteredData {

  return filteredData.where((item) {

    if (selectedFilterValue == "Semua") {
      return true;
    }

    return getFieldValue(
      item,
      selectedFilterColumn,
    ) == selectedFilterValue;

  }).toList();
}

  List<String> visibleColumns = [
    "nama_provinsi",
    "kab_kota",
    "periode_update",
    "kategori",
    "jumlah",
    "satuan",
    "tahun",
  ];

  List<String> availableFields = [
    "id",
    "id_index",
    "kode_provinsi",
    "nama_provinsi",
    "periode_update",
    "kategori",
    "jumlah",
    "satuan",
    "tahun",
  ];
  List<String> unusedFields = [];

  List<String> columnFields = [
    "id",
    "kode_provinsi",
    "id_index",
    "nama_provinsi",
  ];

  List<String> rowFields = [
    "periode_update",
  ];

  List<String> valueFields = [
    "jumlah",
  ];

  List<String> filterFields = [
    "satuan",
    "tahun",
  ];

  String selectedPivotType = "Table";
  String selectedAggregation = "Integer Sum";
  String selectedValueField = "jumlah";

  final List<String> aggregationItems = [

  "Count",
  "Count Unique Values",
  "List Unique Values",
  "Sum",
  "Integer Sum",
  "Average",
  "Median",
  "Sample Variance",
  "Sample Standard Deviation",
  "Minimum",
  "Maximum",
  "First",
  "Last",
  "Sum over Sum",
  "80% Upper Bound",
  "80% Lower Bound",
  "Sum as Fraction of Total",
  "Sum as Fraction of Rows",
];

final Map<String, String> fieldLabels = {
  "id": "ID",
  "id_index": "ID Index",
  "kode_provinsi": "Kode Provinsi",
  "nama_provinsi": "Nama Provinsi",
  "kab_kota": "Kab/Kota",
  "periode_update": "Periode Update",
  "kategori": "Kategori",
  "jumlah": "Jumlah",
  "satuan": "Satuan",
  "tahun": "Tahun",
};

final List<String> stringFields = [
  "kode_provinsi",
  "nama_provinsi",
  "kab_kota",
  "periode_update",
  "kategori",
  "satuan",
  "tahun",
];

final List<String> intFields = [
  "id",
  "id_index",
  "jumlah",
];

String selectedFilterColumn = "tahun";
String selectedFilterValue = "Semua";

  @override
    void initState() {
      super.initState();

      provinsiItems =
          getUniqueValues((e) => e.namaProvinsi);

      kabKotaItems =
          getUniqueValues((e) => e.kabKota);

      periodeItems =
          getUniqueValues((e) => e.periodeUpdate);

      kategoriItems =
          getUniqueValues((e) => e.kategori);

      satuanItems =
          getUniqueValues((e) => e.satuan);

      tahunItems =
          getUniqueValues((e) => e.tahun);

      jumlahItems =
          getUniqueValues(
            (e) => e.jumlahPosko.toString(),
          );
      unusedFields = availableFields
        .where(
          (field) =>
              !columnFields.contains(field) &&
              !rowFields.contains(field) &&
              !filterFields.contains(field),
        )
        .toList();
    }

  Widget build(BuildContext context) {

    return SingleChildScrollView(

      child: Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
          children: [
          Text(
            "Detail Periode Update > ${widget.periode}",
            style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              _buildTab("Tabel", 0),
              _buildTab("Grafik", 1),
              _buildTab("Tabel Dinamis", 2),
            ],
          ),

          const SizedBox(height: 24),
            if (selectedTab == 0)
              _buildTableTab(),
            if (selectedTab == 1)
              _buildChartTab(),
            if (selectedTab == 2)
              _buildDynamicTable(),
            ],
            ),
          ),
    );
  }

  Widget _buildTab(
    String title,
    int index,
  ) {

    final active = selectedTab == index;

    return Expanded(

      child: GestureDetector(

        onTap: () {

          setState(() {
            selectedTab = index;
          });
        },

        child: Container(

          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),

          color:
              active
                  ? const Color(0xFF183B73)
                  : Colors.grey.shade300,

          child: Center(

            child: Text(
              title,

              style: TextStyle(
                color:
                    active
                        ? Colors.white
                        : Colors.black,

                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,

      child: Column(
        children: [

          // ATUR KOLOM
          Align(
            alignment: Alignment.centerRight,

            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),

              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(10),
              ),

              child: PopupMenuButton<String>(
                itemBuilder: (context) {

                final columns = [

                  "nama_provinsi",
                  "kab_kota",
                  "periode_update",
                  "kategori",
                  "jumlah",
                  "satuan",
                  "tahun",
                ];

                return columns.map((column) {

                  return CheckedPopupMenuItem<String>(

                    value: column,

                    checked:
                        visibleColumns.contains(column),

                    child: Text(column),
                  );
                }).toList();
              },

              onSelected: (value) {

                setState(() {

                  if (visibleColumns.contains(value)) {

                    visibleColumns.remove(value);

                  } else {

                    visibleColumns.add(value);
                  }
                });
              },

              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: [

                  Text(
                    "Atur Kolom (${visibleColumns.length}/7)",
                  ),

                  const SizedBox(width: 10),

                  const Icon(
                    Icons.keyboard_arrow_down,
                  ),
                ],
              ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // HEADER TABLE
          Scrollbar(
            controller: tableScrollController,
            thumbVisibility: true,
            trackVisibility: true,
            interactive: true,

            child: SingleChildScrollView(
              controller: tableScrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),

              child: Column(
              children: [

                // HEADER
                Container(
                  width: 1400,

                  color: const Color(0xFF183B73),

                  padding: const EdgeInsets.all(14),

                  child: Row(
                    children: [

                      if (visibleColumns.contains("nama_provinsi"))
                        _fixedHeader("nama_provinsi"),
                      if (visibleColumns.contains("kab_kota"))
                        _fixedHeader("kab_kota"),
                      if (visibleColumns.contains("periode_update"))
                        _fixedHeader("periode_update"),
                      if (visibleColumns.contains("kategori"))
                        _fixedHeader("kategori"),
                      if (visibleColumns.contains("jumlah"))
                        _fixedHeader("jumlah"),
                      if (visibleColumns.contains("satuan"))
                        _fixedHeader("satuan"),
                      if (visibleColumns.contains("tahun"))
                        _fixedHeader("tahun"),
                    ],
                  ),
                ),

                // FILTER
                Container(
                  width: 1400,

                  color: const Color(0xFF183B73),

                  padding: const EdgeInsets.all(14),

                  child: Row(
                    children: [

                      // nama_provinsi
                      _fixedFilter(
                        value: selectedProvinsi,

                        items: provinsiItems,

                        onChanged: (value) {

                          setState(() {
                            selectedProvinsi = value!;
                          });
                        },
                      ),

                      // kab_kota
                      _fixedFilter(
                        value: selectedKabKota,

                        items: kabKotaItems,

                        onChanged: (value) {

                          setState(() {
                            selectedKabKota = value!;
                          });
                        },
                      ),

                      // periode_update
                      _fixedFilter(
                        value: selectedPeriodeUpdate,

                        items: periodeItems,

                        onChanged: (value) {

                          setState(() {
                            selectedPeriodeUpdate = value!;
                          });
                        },
                      ),

                      // kategori
                      _fixedFilter(
                        value: selectedKategori,

                        items: kategoriItems,

                        onChanged: (value) {

                          setState(() {
                            selectedKategori = value!;
                          });
                        },
                      ),

                      // jumlah
                      _fixedFilter(
                        value: selectedJumlah,

                        items: jumlahItems,

                        onChanged: (value) {

                          setState(() {
                            selectedJumlah = value!;
                          });
                        },
                      ),

                      // satuan
                      _fixedFilter(
                        value: selectedSatuan,

                        items: satuanItems,

                        onChanged: (value) {

                          setState(() {
                            selectedSatuan = value!;
                          });
                        },
                      ),

                      // tahun
                      _fixedFilter(
                        value: selectedTahun,

                        items: tahunItems,

                        onChanged: (value) {

                          setState(() {
                            selectedTahun = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                Column(
                  children: filteredData
                      .map(
                        (item) => _tableRow(item),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _fixedHeader(String text) {

  return Container(
    width: 170,

    margin: const EdgeInsets.only(
      right: 14,
    ),

    child: Row(
      children: [

        Expanded(
          child: Text(
            text,

            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),

        const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
      ],
    ),
  );
}

Widget _fixedFilter({
  required String value,
  required List<String> items,
  required Function(String?) onChanged,
  bool disabled = false,
}) {

  return Container(
    width: 170,
    height: 44,

    margin: const EdgeInsets.only(
      right: 14,
    ),

    padding: const EdgeInsets.symmetric(
      horizontal: 12,
    ),

    decoration: BoxDecoration(
      color:
          disabled
              ? Colors.grey.shade300
              : Colors.white,

      borderRadius: BorderRadius.circular(10),
    ),

    child: DropdownButtonHideUnderline(

      child: DropdownButton<String>(
        value: value,

        isExpanded: true,

        onChanged: onChanged,

        items:
            items.map((item) {

          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    ),
  );
}

Widget _fixedSearch(String hint) {

  return Container(
    width: 170,
    height: 44,

    margin: const EdgeInsets.only(
      right: 14,
    ),

    padding: const EdgeInsets.symmetric(
      horizontal: 12,
    ),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),

    child: TextField(

      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
      ),
    ),
  );
}

  Widget _tableHeader(String text) {

    return Expanded(

      child: Row(
        children: [

          Text(
            text,

            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),

          const Spacer(),

          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _filterBox(String hint) {

    return Expanded(

      child: Container(

        height: 42,

        margin: const EdgeInsets.only(
          right: 10,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(10),
        ),

        child: Row(
          children: [

            Text(
              hint,

              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),

            const Spacer(),

            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBox(String hint) {

    return Expanded(

      child: Container(

        height: 42,

        margin: const EdgeInsets.only(
          right: 10,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(10),
        ),

        child: Center(

          child: TextField(

            decoration: InputDecoration(
              hintText: hint,

              border: InputBorder.none,

              isCollapsed: true,

              hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tableRow(DetailPeriodeModel item) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 18,
      ),

      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),

      child: SizedBox(
        width: 1400,

        child: SizedBox(
          width: 1300,

          child: Row(
           children: [

              if (visibleColumns.contains("nama_provinsi"))
                _tableCell(item.namaProvinsi),

              if (visibleColumns.contains("kab_kota"))
                _tableCell(item.kabKota),

              if (visibleColumns.contains("periode_update"))
                _tableCell(item.periodeUpdate),

              if (visibleColumns.contains("kategori"))
                _tableCell(item.kategori),

              if (visibleColumns.contains("jumlah"))
                _tableCell(
                  item.jumlahPosko.toString(),
                ),

              if (visibleColumns.contains("satuan"))
                _tableCell(item.satuan),

              if (visibleColumns.contains("tahun"))
                _tableCell(item.tahun),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tableCell(String text) {

  return Container(
    width: 175,

    alignment: Alignment.centerLeft,

    margin: const EdgeInsets.only(
      right: 14,
    ),

    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        height: 1.5,
      ),
    ),
  );
}

  Widget _buildChartTab() {

    return Container(

      color: Colors.white,

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Sesuaikan tampilan grafik",

              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Pengaturan",

              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            _chartDropdown(
              title: "Gaya Grafik",

              value: selectedChart,

              items: const [
                "Bar Chart",
                "Pie Chart",
                "Line Chart",
              ],

              onChanged: (value) {

                setState(() {
                  selectedChart = value!;
                });
              },
            ),

           _chartDropdown(
            title: "Sumbu X (Horizontal)",

            value: selectedXAxis,

            items: stringFields,

            onChanged: (value) {

              setState(() {
                selectedXAxis = value!;
              });
            },
          ),

            _chartDropdown(
              title: "Sumbu Y (Vertical)",

              value: selectedYAxis,

              items: intFields,

              onChanged: (value) {

                setState(() {
                  selectedYAxis = value!;
                });
              },
            ),

            _chartDropdown(
              title: "Filter Kolom",
              value: selectedFilterColumn,
              items: availableFields,

              onChanged: (value) {
                setState(() {
                  selectedFilterColumn = value!;
                  selectedFilterValue = "Semua";
                });
              },
            ),

            _chartDropdown(
              title: "Filter Value",

              value: selectedFilterValue,

              items: [
                "Semua",
                ...filteredData
                    .map(
                      (e) => getFieldValue(
                        e,
                        selectedFilterColumn,
                      ),
                    )
                    .toSet()
                    .toList(),
              ],

              onChanged: (value) {

                setState(() {
                  selectedFilterValue = value!;
                });
              },
            ),

            _chartDropdown(
              title: "Tahun",

              value: selectedTahun,

              items: const [
                "2026",
              ],

              onChanged: (value) {

                setState(() {
                  selectedTahun = value!;
                });
              },
            ),

            const SizedBox(height: 24),

              GestureDetector(

                onTap: () {

                  setState(() {

                    appliedChart = selectedChart;
                    appliedXAxis = selectedXAxis;
                    appliedYAxis = selectedYAxis;
                  });
                },

                child: Container(

                width: double.infinity,
                height: 54,

                decoration: BoxDecoration(
                  color: const Color(0xFF183B73),

                  borderRadius:
                      BorderRadius.circular(14),
                ),

                child: const Center(
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),

                      SizedBox(width: 10),

                      Text(
                        "Pratinjau",

                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

          Column(

  children: [

    Row(
      children: [

        Container(
          width: 16,
          height: 16,
          color: const Color(0xFFB7C94D),
        ),

        const SizedBox(width: 8),

        Text(
          fieldLabels[appliedYAxis] ?? "",

          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),

    const SizedBox(height: 24),

    SizedBox(
      height: 450,

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,

        children: [

          RotatedBox(
            quarterTurns: 3,

            child: Text(
              "Sumbu Y : ${fieldLabels[appliedYAxis]}",

              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(width: 20),

          Expanded(

            child: Column(
              children: [

                Expanded(
                  child:

                  appliedChart == "Pie Chart"

                  ? PieChart(
                      PieChartData(
                        sections:
                            chartFilteredData.map((item) {

                          return PieChartSectionData(

                            value: getNumericValue(
                              item,
                              appliedYAxis,
                            ),

                            title: getFieldValue(
                              item,
                              appliedXAxis,
                            ),
                          );
                        }).toList(),
                      ),
                    )

                  : appliedChart == "Line Chart"

                  ? LineChart(
                      LineChartData(
                        lineBarsData: [

                          LineChartBarData(

                            spots:
                                chartFilteredData
                                    .asMap()
                                    .entries
                                    .map((e) {

                              return FlSpot(
                                e.key.toDouble(),

                                getNumericValue(
                                  e.value,
                                  appliedYAxis,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )

                  : BarChart(

                      BarChartData(

                        titlesData: FlTitlesData(

                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),

                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 70,
                              getTitlesWidget:
                                  (value, meta) {
                                final index =
                                    value.toInt();
                                if (index >=
                                    chartFilteredData
                                        .length) {
                                  return const SizedBox();
                                }
                                final item =
                                    chartFilteredData[
                                        index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: Transform.rotate(
                                    angle: -0.5,

                                    child: Text(

                                      getFieldValue(
                                        item,
                                        appliedXAxis,
                                      ),

                                      style: const TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          topTitles:
                              const AxisTitles(
                            sideTitles:
                                SideTitles(
                              showTitles: false,
                            ),
                          ),
                        ),

                        barTouchData:
                            BarTouchData(

                          enabled: true,

                          touchTooltipData:
                              BarTouchTooltipData(

                            getTooltipItem: (
                              group,
                              groupIndex,
                              rod,
                              rodIndex,
                            ) {

                              final item =
                                  chartFilteredData[
                                      group.x];

                              return BarTooltipItem(

                                "${fieldLabels[appliedXAxis]} : "
                                "${getFieldValue(item, appliedXAxis)}\n"

                                "${fieldLabels[appliedYAxis]} : "
                                "${getNumericValue(item, appliedYAxis).toInt()}",

                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),

                        borderData:
                            FlBorderData(
                          show: false,
                        ),

                        barGroups:
                            chartFilteredData
                                .asMap()
                                .entries
                                .map((e) {

                          return BarChartGroupData(

                            x: e.key,

                            barRods: [

                              BarChartRodData(

                                toY:
                                    getNumericValue(
                                  e.value,
                                  appliedYAxis,
                                ),

                                color:
                                    const Color(
                                  0xFFB7C94D,
                                ),

                                width: 30,

                                borderRadius:
                                    BorderRadius.circular(
                                  6,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                ),

                const SizedBox(height: 14),

                Text(

                  "Sumbu X : ${fieldLabels[appliedXAxis]}",

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ],
),
            
          ],
        ),
      ),
    );
    }
  

  Widget _chartDropdown({
    required String title,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }){

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            title,

            style: const TextStyle(
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),

          Container(

            width: double.infinity,
            height: 52,

            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
              ),

              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: DropdownButtonHideUnderline(

              child: DropdownButton<String>(
                value: value,

                isExpanded: true,

                onChanged: onChanged,

                items:
                    items.map((item) {

                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicTable() {

  return Container(
    width: double.infinity,
    color: Colors.white,
    padding: const EdgeInsets.all(20),

    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: Container(
        width: 1300,

        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),

        child: Column(
          children: [

            // INFO BOX
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFEAF3FF),

              child: const Row(
                children: [

                  Icon(
                    Icons.info,
                    color: Color(0xFF3366CC),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "Sistem gagal menemukan attribut untuk tabel dinamis secara otomatis. Silahkan pilih opsi attribut secara manual.",
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),

              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // LEFT SIDE
                  SizedBox(
                    width: 420,

                    child: Column(
                      children: [

                        // PIVOT TYPE
                        SizedBox(
                          width: 180,

                          child:
                              DropdownButtonFormField<String>(
                            value: selectedPivotType,

                            decoration:
                                const InputDecoration(
                              border:
                                  OutlineInputBorder(),
                            ),

                            items: const [

                              DropdownMenuItem(
                                value: "Table",
                                child: Text("Table"),
                              ),

                              DropdownMenuItem(
                                value: "Heatmap",
                                child: Text("Heatmap"),
                              ),

                              DropdownMenuItem(
                                value: "Row Heatmap",
                                child:
                                    Text("Row Heatmap"),
                              ),

                              DropdownMenuItem(
                                value: "Col Heatmap",
                                child:
                                    Text("Col Heatmap"),
                              ),
                            ],

                            onChanged: (value) {

                              setState(() {
                                selectedPivotType =
                                    value!;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // AGGREGATION
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  Colors.grey.shade300,
                            ),
                          ),

                          child: Column(
                            children: [

                              Row(
                                children: [

                                  Expanded(
                                    child:
                                        DropdownButtonFormField<
                                            String>(
                                      value:
                                          selectedAggregation,

                                      decoration:
                                          const InputDecoration(
                                        border:
                                            OutlineInputBorder(),
                                      ),

                                      items:
                                          aggregationItems.map(
                                        (item) {

                                          return DropdownMenuItem(
                                            value: item,
                                            child:
                                                Text(item),
                                          );
                                        },
                                      ).toList(),

                                      onChanged: (value) {

                                        setState(() {
                                          selectedAggregation =
                                              value!;
                                        });
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  const Icon(
                                    Icons.swap_vert,
                                  ),

                                  const SizedBox(width: 12),

                                  const Icon(
                                    Icons.swap_horiz,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              DropdownButtonFormField<
                                  String>(
                                value:
                                    selectedValueField,

                                decoration:
                                    const InputDecoration(
                                  border:
                                      OutlineInputBorder(),
                                ),

                                items:
                                    availableFields.map(
                                  (field) {

                                    return DropdownMenuItem(
                                      value: field,
                                      child:
                                          Text(field),
                                    );
                                  },
                                ).toList(),

                                onChanged: (value) {

                                  setState(() {
                                    selectedValueField =
                                        value!;
                                  });
                                },
                              ),

                              const SizedBox(height: 16),

                              Align(
                                alignment:
                                    Alignment.centerLeft,

                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,

                                  children:
                                      unusedFields.map(
                                    (field) {

                                      return _smallPivotChip(
                                          field);
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // RIGHT SIDE
                  SizedBox(
                    width: 760,

                    child: Column(
                      children: [

                        _buildHorizontalArea(
                          fields: columnFields,
                        ),

                        const SizedBox(height: 16),

                        _buildHorizontalArea(
                          fields: filterFields,
                        ),

                        const SizedBox(height: 16),

                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            SizedBox(
                              width: 220,

                              child: _buildVerticalArea(
                                fields: rowFields,
                              ),
                            ),

                            const SizedBox(width: 16),

                            SizedBox(
                              width: 500,
                              child:
                                  _buildPivotMatrix(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildPivotSection({
    required String title,
    required List<String> fields,
  }) {

    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: Row(

              children: fields.map((field) {

                return Padding(
                  padding:
                      const EdgeInsets.only(
                    right: 12,
                  ),

                  child: _pivotChip(
                    field,
                    fields,
                  ),
                );

              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildHorizontalArea({
  required List<String> fields,
}) {

  return DragTarget<String>(

    onAcceptWithDetails: (details) {

      final field = details.data;

      setState(() {

        columnFields.remove(field);
        rowFields.remove(field);
        filterFields.remove(field);
        unusedFields.remove(field);

        if (!fields.contains(field)) {
          fields.add(field);
        }
      });
    },

    builder: (
      context,
      candidateData,
      rejectedData,
    ) {

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400,
          ),
        ),

        child: Wrap(
          spacing: 10,
          runSpacing: 10,

          children:
              fields.map((field) {

            return _smallPivotChip(field);

          }).toList(),
        ),
      );
    },
  );
}

  Widget _buildVerticalArea({
  required List<String> fields,
}) {

  return DragTarget<String>(

    onAcceptWithDetails: (details) {

      final field = details.data;

      setState(() {

        columnFields.remove(field);
        rowFields.remove(field);
        filterFields.remove(field);
        unusedFields.remove(field);

        if (!fields.contains(field)) {
          fields.add(field);
        }
      });
    },

    builder: (
      context,
      candidateData,
      rejectedData,
    ) {

      return Container(
        height: 350,

        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400,
          ),
        ),

        child: ListView(
          padding: const EdgeInsets.all(12),

          children:
              fields.map((field) {

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),

              child: _smallPivotChip(field),
            );

          }).toList(),
        ),
      );
    },
  );
}

  Widget _chip(String text) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(10),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [

          Text(text),

          const SizedBox(width: 6),

          const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _pivotChip(
  String field,
  List<String> sourceList,
) {
  return LongPressDraggable<String>(
    data: field,

    feedback: Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(field),
      ),
    ),

    childWhenDragging: Opacity(
      opacity: 0.4,
      child: _pivotItem(field),
    ),

    child: _pivotItem(field),
  );
}

Widget _pivotItem(String field) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 10,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Colors.grey.shade300,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(field),

        const SizedBox(width: 6),

        const Icon(
          Icons.arrow_drop_down,
        ),
      ],
    ),
  );
}

Widget _smallPivotChip(
  String field,
) {

  return LongPressDraggable<String>(

    data: field,

    feedback: Material(
      color: Colors.transparent,

      child: _pivotVisual(field),
    ),

    childWhenDragging: Opacity(
      opacity: 0.3,
      child: _pivotVisual(field),
    ),

    child: GestureDetector(

      onDoubleTap: () {

        setState(() {

          columnFields.remove(field);
          rowFields.remove(field);
          filterFields.remove(field);

          if (!unusedFields.contains(field)) {
            unusedFields.add(field);
          }
        });
      },

      child: _pivotVisual(field),
    ),
  );
}

Widget _pivotVisual(String text) {

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Colors.grey.shade300,
      ),
    ),

    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
          ),
        ),

        const SizedBox(width: 6),

        const Icon(
          Icons.arrow_drop_down,
          size: 18,
        ),
      ],
    ),
  );
}

Widget _buildPivotMatrix() {

  return Container(
    
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey.shade300,
      ),
    ),

    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: DataTable(

      headingRowColor:
          WidgetStateProperty.all(
        Colors.grey.shade100,
      ),

      columns: [

        ...rowFields.map(
          (field) => DataColumn(
            label: Text(field),
          ),
        ),

        DataColumn(
          label: Text(selectedValueField),
        ),
      ],

      rows: filteredData.map((item) {

        return DataRow(

          cells: [

            ...rowFields.map(
              (field) => DataCell(
                Text(
                  getFieldValue(item, field),
                ),
              ),
            ),

            DataCell(
              Text(
                getFieldValue(
                  item,
                  selectedValueField,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    ),
    ),
  );
}

Widget _buildDragArea({
  required String title,
  required List<String> fields,
}) {

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [

    const SizedBox(height: 10),
      DragTarget<String>(
        onAcceptWithDetails: (details) {

          final field = details.data;

          setState(() {

            columnFields.remove(field);
            rowFields.remove(field);
            filterFields.remove(field);
            unusedFields.remove(field);

            if (!fields.contains(field)) {
              fields.add(field);
            }
          });
        },

        builder: (
          context,
          candidateData,
          rejectedData,
        ) {

          return Container(
            width: double.infinity,

            padding: const EdgeInsets.all(14),

            constraints: const BoxConstraints(
              minHeight: 80,
            ),

            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),

            child: Wrap(
              spacing: 10,
              runSpacing: 10,

              children: fields.map((field) {

                return _smallPivotChip(field);

              }).toList(),
            ),
          );
        },
      ),
    ],
  );
}

  String getFieldValue(
  DetailPeriodeModel item,
  String field,
) {

  switch (field) {

    case "id":
      return item.id.toString();

    case "id_index":
      return item.idIndex.toString();

    case "kode_provinsi":
      return item.kodeProvinsi;

    case "nama_provinsi":
      return item.namaProvinsi;

    case "kab_kota":
      return item.kabKota;

    case "periode_update":
      return item.periodeUpdate;

    case "kategori":
      return item.kategori;

    case "jumlah":
      return item.jumlahPosko.toString();

    case "satuan":
      return item.satuan;

    case "tahun":
      return item.tahun;

    default:
      return "";
  }
}

double getNumericValue(
  DetailPeriodeModel item,
  String field,
) {
  switch (field) {

    case "id":
      return item.id.toDouble();

    case "id_index":
      return item.idIndex.toDouble();

    case "jumlah":
      return item.jumlahPosko.toDouble();

    default:
      return 0;
  }
}

Widget _buildDropSection({
  required String title,
  required List<String> targetList,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 10),

      DragTarget<String>(
        onAcceptWithDetails: (details) {

          final field = details.data;

          setState(() {

            if (!targetList.contains(field)) {
              targetList.add(field);
            }

            columnFields.remove(field);
            rowFields.remove(field);
            filterFields.remove(field);
          });

          if (!targetList.contains(field)) {
            targetList.add(field);
          }
        },

        builder: (
          context,
          candidateData,
          rejectedData,
        ) {

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),

            constraints: const BoxConstraints(
              minHeight: 70,
            ),

            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),

            child: Wrap(
              spacing: 10,
              runSpacing: 10,

              children:
                  targetList.map((field) {

                return _pivotChip(
                  field,
                  targetList,
                );

              }).toList(),
            ),
          );
        },
      ),
    ],
  );
}

Widget _buildPivotResult() {

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),

    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),

    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: DataTable(

        columns: [

          ...rowFields.map(
            (field) => DataColumn(
              label: Text(field),
            ),
          ),

          DataColumn(
            label: Text(selectedValueField),
          ),
        ],

        rows:
            filteredData.map((item) {

          return DataRow(

            cells: [

              ...rowFields.map(
                (field) => DataCell(
                  Text(
                    getFieldValue(item, field),
                  ),
                ),
              ),

              DataCell(
                Text(
                  _getAggregationValue(item),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    ),
  );
}

String _getAggregationValue(
  DetailPeriodeModel item,
) {

  final value =
      int.tryParse(
        getFieldValue(
          item,
          selectedValueField,
        ),
      ) ??
      0;

  switch (selectedAggregation) {

    case "Count":
      return "1";

    case "Average":
      return value.toStringAsFixed(0);

    case "Maximum":
      return value.toString();

    case "Integer Sum":
    default:
      return value.toString();
  }
}
}
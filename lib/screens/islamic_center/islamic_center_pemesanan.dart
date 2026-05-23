import 'package:flutter/material.dart';
import 'islamic_center_dummy.dart';

class IslamicCenterPemesanan
    extends StatefulWidget {

  final IslamicCenterRoomModel room;

  const IslamicCenterPemesanan({
    super.key,
    required this.room,
  });

  @override
  State<IslamicCenterPemesanan>
      createState() =>
          _IslamicCenterPemesananState();
}

class _IslamicCenterPemesananState
    extends State<IslamicCenterPemesanan> {

  final TextEditingController
      namaController =
          TextEditingController();

  DateTime? selectedDate;
  String selectedWaktu = 'Malam';

  final List<String> fasilitasList = [
    'Karpet',
    'Meja & Kursi Penerima Tamu',
    'Kursi',
    'Kamar Rias',
    'Genset',
    'AC',
    'Mimbar',
  ];

  List<String> selectedFasilitas = [
    'Kursi',
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(
        0xff1E4FD8,
      ),

      body: Stack(
        children: [

          /// BACKGROUND
          Container(
            width: double.infinity,
            height: 260,

            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/latar_belakang.png',
                ),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          Column(
            children: [

              /// APPBAR
              _buildAppBar(),

              const SizedBox(height: 10),

              /// BODY
              Expanded(
                child: Container(
                  width: double.infinity,

                  decoration: const BoxDecoration(
                    color: Color(0xffF7F7F7),

                    borderRadius:
                        BorderRadius.only(
                      topLeft:
                          Radius.circular(34),
                      topRight:
                          Radius.circular(34),
                    ),
                  ),

                  child: Column(
                    children: [

                      Expanded(
                        child:
                            SingleChildScrollView(
                          padding:
                              const EdgeInsets.all(
                            20,
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              /// IMAGE
                              ClipRRect(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  24,
                                ),

                                child: Image.asset(
                                  widget.room.image,
                                  width:
                                      double.infinity,
                                  height: 220,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              /// INFO CARD
                              Transform.translate(
                                offset:
                                    const Offset(
                                  0,
                                  -30,
                                ),

                                child: Container(
                                  width:
                                      double.infinity,

                                  padding:
                                      const EdgeInsets.all(
                                    18,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        Colors.white,

                                    borderRadius:
                                        BorderRadius.circular(
                                      20,
                                    ),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors
                                            .black
                                            .withOpacity(
                                          0.06,
                                        ),

                                        blurRadius:
                                            12,

                                        offset:
                                            const Offset(
                                          0,
                                          4,
                                        ),
                                      ),
                                    ],
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [

                                      /// TITLE
                                      Text(
                                        widget
                                            .room
                                            .title,

                                        style:
                                            const TextStyle(
                                          fontSize:
                                              18,

                                          fontWeight:
                                              FontWeight
                                                  .w700,

                                          color:
                                              Color(
                                            0xff1D1D1D,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 16,
                                      ),

                                      /// INFO
                                      Row(
                                        children: [

                                          Expanded(
                                            child:
                                                _buildInfoItem(
                                              Icons
                                                  .people_alt_rounded,

                                              'Kapasitas',

                                              widget
                                                  .room
                                                  .kapasitas,
                                            ),
                                          ),

                                          Expanded(
                                            child:
                                                _buildInfoItem(
                                              Icons
                                                  .payments_rounded,

                                              'Tarif mulai dari',

                                              widget
                                                  .room
                                                  .harga,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /// DATA PEMESANAN
                              const Text(
                                'Data Pemesanan',

                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                  color: Color(
                                    0xff1D1D1D,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 18,
                              ),

                              /// NAMA
                              _buildTextField(
                                controller:
                                    namaController,

                                hint:
                                    'Nama Lengkap',
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              /// WAKTU /TANGGAl
                              _buildDateField(),    

                              const SizedBox(
                                height: 14,
                              ),

                              /// RADIO
                              Row(
                                children: [

                                  _buildRadio(
                                    'Siang',
                                  ),

                                  const SizedBox(
                                    width: 20,
                                  ),

                                  _buildRadio(
                                    'Malam',
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              /// FASILITAS
                              const Text(
                                'Fasilitas',

                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),

                              const SizedBox(
                                height: 12,
                              ),

                              Wrap(
                                spacing: 12,
                                runSpacing: 12,

                                children:
                                    fasilitasList.map(
                                  (
                                    item,
                                  ) {

                                    final isSelected =
                                        selectedFasilitas
                                            .contains(
                                      item,
                                    );

                                    return InkWell(
                                      onTap: () {

                                        setState(() {

                                          if (isSelected) {
                                            selectedFasilitas
                                                .remove(
                                              item,
                                            );
                                          } else {
                                            selectedFasilitas
                                                .add(
                                              item,
                                            );
                                          }
                                        });
                                      },

                                      child: Row(
                                        mainAxisSize:
                                            MainAxisSize
                                                .min,

                                        children: [

                                          Container(
                                            width:
                                                20,
                                            height:
                                                20,

                                            decoration:
                                                BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? const Color(
                                                          0xff2F61E8,
                                                        )
                                                      : Colors.white,

                                              borderRadius:
                                                  BorderRadius.circular(
                                                6,
                                              ),

                                              border:
                                                  Border.all(
                                                color:
                                                    Colors.grey.shade400,
                                              ),
                                            ),

                                            child:
                                                isSelected
                                                    ? const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 14,
                                                      )
                                                    : null,
                                          ),

                                          const SizedBox(
                                            width:
                                                8,
                                          ),

                                          Text(
                                            item,

                                            style:
                                                TextStyle(
                                              fontSize:
                                                  14,

                                              color: Colors
                                                  .grey
                                                  .shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),

                              const SizedBox(
                                height: 28,
                              ),

                              /// DESKRIPSI
                              const Text(
                                'Deskripsi',

                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                  color: Color(
                                    0xff1D1D1D,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 12,
                              ),

                              Text(
                                'Hall Utama Islamic Center Jawa Timur adalah ruang serbaguna megah yang mampu menampung hingga 2.000 orang. Didesain dengan arsitektur yang elegan dan nuansa islami yang khas, hall ini sangat ideal untuk menyelenggarakan berbagai acara berskala medium hingga besar, seperti seminar nasional, konferensi, pelatihan, wisuda, maupun acara keagamaan. Dilengkapi dengan sistem tata suara dan pencahayaan yang modern, hall utama menawarkan kenyamanan dan kesan profesional untuk setiap kegiatan.',

                                style: TextStyle(
                                  color:
                                      Colors.grey
                                          .shade700,

                                  fontSize: 14,

                                  height: 1.7,
                                ),
                              ),

                              const SizedBox(
                                height: 120,
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// BOTTOM BUTTON
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(
                          20,
                          16,
                          20,
                          24,
                        ),

                        decoration:
                            const BoxDecoration(
                          color: Colors.white,
                        ),

                        child: Row(
                          children: [

                            Expanded(
                              child: SizedBox(
                                height: 50,

                                child:
                                    ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                    );
                                  },

                                  style:
                                      ElevatedButton.styleFrom(
                                    elevation: 0,

                                    backgroundColor:
                                        const Color(
                                      0xffE8EEF9,
                                    ),

                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        30,
                                      ),
                                    ),
                                  ),

                                  child:
                                      const Text(
                                    'Batal',

                                    style:
                                        TextStyle(
                                      color:
                                          Color(
                                        0xff2F61E8,
                                      ),

                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 12,
                            ),

                            Expanded(
                              flex: 2,

                              child: SizedBox(
                                height: 50,

                                child:
                                    ElevatedButton(
                                  onPressed: () {},

                                  style:
                                      ElevatedButton.styleFrom(
                                    elevation: 0,

                                    backgroundColor:
                                        const Color(
                                      0xff2F61E8,
                                    ),

                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        30,
                                      ),
                                    ),
                                  ),

                                  child:
                                      const Text(
                                    'Pesan Sekarang',

                                    style:
                                        TextStyle(
                                      color:
                                          Colors
                                              .white,

                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// APPBAR
  Widget _buildAppBar() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        55,
        16,
        0,
      ),

      child: Row(
        children: [

          InkWell(
            onTap: () {
              Navigator.pop(context);
            },

            child: const Row(
              children: [

                Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),

                SizedBox(width: 10),

                Text(
                  'Kembali',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// INFO ITEM
  Widget _buildInfoItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          title,

          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 6),

        Row(
          children: [

            Icon(
              icon,
              size: 16,
              color:
                  const Color(0xff2F61E8),
            ),

            const SizedBox(width: 6),

            Expanded(
              child: Text(
                value,

                style: const TextStyle(
                  fontSize: 16,
                  color:
                      Color(0xff1D1D1D),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// TEXTFIELD
  Widget _buildTextField({
    required TextEditingController
        controller,

    required String hint,
  }) {
    return TextFormField(
      controller: controller,

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,

        hintText: hint,

        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14,
        ),

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),

          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),

          borderSide: const BorderSide(
            color: Color(0xff2F61E8),
          ),
        ),
      ),
    );
  }

  /// DROPDOWN
  Widget _buildDateField() {
  return InkWell(
    onTap: () async {

      final pickedDate =
          await showDatePicker(
        context: context,

        initialDate: DateTime.now(),

        firstDate: DateTime(2024),

        lastDate: DateTime(2030),

        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme:
                  const ColorScheme.light(
                primary:
                    Color(0xff2F61E8),
              ),
            ),

            child: child!,
          );
        },
      );

      if (pickedDate != null) {

        setState(() {
          selectedDate = pickedDate;
        });
      }
    },

    child: Container(
      width: double.infinity,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Row(
        children: [

          Expanded(
            child: Text(
              selectedDate == null
                  ? 'Waktu'
                  : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',

              style: TextStyle(
                color: selectedDate == null
                    ? Colors.grey.shade500
                    : const Color(
                        0xff1D1D1D,
                      ),

                fontSize: 14,
              ),
            ),
          ),

          Icon(
            Icons.calendar_month_outlined,
            color: Colors.grey.shade500,
          ),
        ],
      ),
    ),
  );
}

  /// RADIO
  Widget _buildRadio(
    String value,
  ) {
    return InkWell(
      onTap: () {

        setState(() {
          selectedWaktu = value;
        });
      },

      child: Row(
        children: [

          Container(
            width: 20,
            height: 20,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              border: Border.all(
                color:
                    selectedWaktu == value
                        ? const Color(
                            0xff2F61E8,
                          )
                        : Colors.grey.shade400,
              ),
            ),

            child: selectedWaktu == value
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,

                      decoration:
                          const BoxDecoration(
                        shape:
                            BoxShape.circle,

                        color:
                            Color(0xff2F61E8),
                      ),
                    ),
                  )
                : null,
          ),

          const SizedBox(width: 8),

          Text(
            value,

            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'islamic_center_dummy.dart';
import 'islamic_center_pemesanan.dart';

class IslamicCenterDetailFasilitas
    extends StatelessWidget {

  final IslamicCenterFacilityModel facility;

  const IslamicCenterDetailFasilitas({
    super.key,
    required this.facility,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xff1E4FD8),

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
              _buildAppBar(context),

              const SizedBox(height: 10),

              /// BODY
              Expanded(
                child: Container(
                  width: double.infinity,

                  decoration: const BoxDecoration(
                    color: Color(0xffF7F7F7),

                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(34),
                      topRight: Radius.circular(34),
                    ),
                  ),

                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        /// TITLE
                        Text(
                          'Detail Fasilitas Gedung ${facility.title}',

                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight.w700,
                            color:
                                Color(0xff1D1D1D),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// ROOM LIST
                        ListView.builder(
                          shrinkWrap: true,

                          physics:
                              const NeverScrollableScrollPhysics(),

                          itemCount:
                              facility.rooms.length,

                          itemBuilder:
                              (context, index) {

                            final room =
                                facility.rooms[
                                    index];

                            return _buildRoomCard(
                              context,
                              room,
                            );
                          },
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
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
  Widget _buildAppBar(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
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

  /// ROOM CARD
  Widget _buildRoomCard(
    BuildContext context,
    IslamicCenterRoomModel room,
  ) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(
        bottom: 18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.04,
            ),

            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          /// IMAGE
          ClipRRect(
            borderRadius:
                const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),

            child: Image.asset(
              room.image,
              width: double.infinity,
              height: 190,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                /// TITLE
                Text(
                  room.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(0xff1D1D1D),
                  ),
                ),

                const SizedBox(height: 14),

                /// INFO
                Row(
                  children: [

                    Expanded(
                      child:
                          _buildInfoItem(
                        Icons.people_alt_rounded,
                        'Kapasitas',
                        room.kapasitas,
                      ),
                    ),

                    Expanded(
                      child:
                          _buildInfoItem(
                        Icons.payments_rounded,
                        'Tarif mulai dari',
                        room.harga,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 46,

                  child: OutlinedButton(
                    onPressed: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              IslamicCenterPemesanan(
                            room: room,
                          ),
                        ),
                      );
                    },

                    style:
                        OutlinedButton.styleFrom(
                      backgroundColor:
                          Colors.white,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),
                      ),

                      side: BorderSide(
                        color:
                            Colors.grey.shade300,
                      ),
                    ),

                    child: const Text(
                      'Detail Pemesanan',

                      style: TextStyle(
                        color:
                            Color(0xff1D1D1D),
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
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
              color: const Color(
                0xff1E4FD8,
              ),
            ),

            const SizedBox(width: 6),

            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
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
}
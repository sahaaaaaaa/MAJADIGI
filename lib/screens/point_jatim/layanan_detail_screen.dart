import 'package:flutter/material.dart';
import 'point_jatim_dummy.dart';

class LayananDetailScreen extends StatelessWidget {
  final PointJatimProjectModel item;

  const LayananDetailScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E4FD8),

      body: Stack(
        children: [

          /// BACKGROUND HEADER
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
              Padding(
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

                          SizedBox(width: 8),

                          Text(
                            'Kembali',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// BODY
              Expanded(
                child: Container(
                  width: double.infinity,

                  decoration: const BoxDecoration(
                    color: Color(0xffF6F6F6),
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

                        /// IMAGE
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(24),

                          child: Image.network(
                            item.image,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        /// FLOATING INFO CARD
                        Transform.translate(
                          offset: const Offset(0, -28),

                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            margin:
                                const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.08),
                                  blurRadius: 18,
                                  offset:
                                      const Offset(0, 8),
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.w700,
                                    height: 1.3,
                                    color:
                                        Color(0xff1C1C1C),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Row(
                                  children: [

                                    const Icon(
                                      Icons
                                          .account_balance_wallet_rounded,
                                      size: 16,
                                      color:
                                          Color(0xffFF8A00),
                                    ),

                                    const SizedBox(width: 4),

                                    Text(
                                      item.harga,
                                      style:
                                          const TextStyle(
                                        fontSize: 13,
                                        color: Color(
                                            0xff4B4B4B),
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    const Icon(
                                      Icons
                                          .location_on_rounded,
                                      size: 16,
                                      color:
                                          Color(0xff1E4FD8),
                                    ),

                                    const SizedBox(width: 4),

                                    Expanded(
                                      child: Text(
                                        item.lokasi,
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                        style:
                                            const TextStyle(
                                          fontSize: 13,
                                          color: Color(
                                              0xff4B4B4B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 2),

                        /// INFOMEMO
                        const Text(
                          'Infomemo',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1B1B1B),
                          ),
                        ),

                        const SizedBox(height: 16),

                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(20),

                          child: SizedBox(
                            height: 220,

                            child: item.infomemoImages.length == 1

                                /// SINGLE IMAGE
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(20),

                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,

                                          builder: (_) {

                                            return Dialog(
                                              backgroundColor: Colors.black,

                                              insetPadding:
                                                  const EdgeInsets.all(12),

                                              child: InteractiveViewer(
                                                child: Image.asset(
                                                  item.infomemoImages.first,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },

                                      child: Image.asset(
                                        item.infomemoImages.first,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )

                                /// MULTIPLE IMAGE
                                : ListView.separated(
                                    scrollDirection: Axis.horizontal,

                                    itemCount:
                                        item.infomemoImages.length,

                                    separatorBuilder:
                                        (_, __) =>
                                            const SizedBox(width: 14),

                                    itemBuilder: (context, index) {

                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20),

                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,

                                              builder: (_) {

                                                return Dialog(
                                                  backgroundColor: Colors.black,

                                                  insetPadding:
                                                      const EdgeInsets.all(12),

                                                  child: InteractiveViewer(
                                                    child: Image.asset(
                                                      item.infomemoImages[index],
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },

                                          child: Image.asset(
                                            item.infomemoImages[index],
                                            width: 320,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        /// DETAIL INFORMASI
                        const Text(
                          'Detail Informasi',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _buildDetailRow(
                          'Bidang Usaha',
                          item.category,
                        ),

                        _buildDetailRow(
                          'Tahun',
                          item.tahun,
                        ),

                        _buildDetailRow(
                          'Nilai Investasi',
                          item.harga,
                        ),

                        _buildDetailRow(
                          'Koordinat',
                          '7.8496131, 112.4607358',
                        ),

                        _buildDetailRow(
                          'IRR',
                          '19.82%',
                        ),

                        _buildDetailRow(
                          'NPV',
                          'Rp 7,85 Miliar',
                        ),

                        _buildDetailRow(
                          'Payback Period',
                          '5.5 Tahun',
                          isLast: true,
                        ),

                        const SizedBox(height: 30),

                        /// DESKRIPSI
                        const Text(
                          'Deskripsi',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          PointJatimDetailDummy.deskripsi,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// LOKASI
                        const Text(
                          'Lokasi',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 16),

                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(20),

                          child: Image.network(
                            'https://maps.googleapis.com/maps/api/staticmap?center=-7.8496131,112.4607358&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7C-7.8496131,112.4607358',
                            width: double.infinity,
                            height: 230,
                            fit: BoxFit.cover,

                            errorBuilder:
                                (context, error, stackTrace) {
                              return Container(
                                height: 230,
                                color: Colors.grey.shade300,
                                child: const Center(
                                  child: Icon(
                                    Icons.map,
                                    size: 50,
                                  ),
                                ),
                              );
                            },
                          ),
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

  Widget _buildDetailRow(
    String title,
    String value, {
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),

      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(
                  color: Colors.grey.shade300,
                ),
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff1D1D1D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
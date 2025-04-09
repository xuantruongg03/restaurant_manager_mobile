import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRModal extends StatefulWidget {
  final String name;
  final VoidCallback onPrint;
  final String tableId;
  final String idMenu;
  final String idRestaurant;

  const QRModal({
    super.key,
    required this.name,
    required this.onPrint,
    required this.tableId,
    required this.idMenu,
    required this.idRestaurant,
  });

  @override
  State<QRModal> createState() => _QRModalState();
}

class _QRModalState extends State<QRModal> {
  final GlobalKey qrKey = GlobalKey();

  // Future<void> _downloadQR() async {
  //   try {
  //     // Capture QR code as image
  //     RenderRepaintBoundary boundary =
  //         qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //     ByteData? byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);

  //     if (byteData != null) {
  //       // Save to gallery
  //       final result = await ImageGallerySaver.saveImage(
  //           byteData.buffer.asUint8List(),
  //           quality: 100,
  //           name: "QR_${widget.name}_${DateTime.now().millisecondsSinceEpoch}");

  //       if (result['isSuccess']) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //               content: Text('QR code đã được lưu vào thư viện ảnh')),
  //         );
  //         Get.back();
  //       } else {
  //         throw Exception('Không thể lưu QR code');
  //       }
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Lỗi khi tải QR code: $e')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.4),
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mã QR ${widget.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              RepaintBoundary(
                key: qrKey,
                child: Container(
                  color: Colors.white,
                  child: QrImageView(
                    data:
                        '${dotenv.env['WEB_URL']}/menu?a=${widget.idMenu}&b=${widget.idRestaurant}&c=${widget.tableId}',
                    size: 200,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text(
                  'Tải xuống',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: widget.onPrint,
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Colors.orange, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                child: const Text(
                  'In',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

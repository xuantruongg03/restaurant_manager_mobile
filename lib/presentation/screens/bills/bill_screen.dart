import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';

class BillScreen extends StatelessWidget {
  const BillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(
            title: 'Thanh toán',
            showBackButton: true,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Bill header info
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Ngày vào:', '24/08/2024'),
                          _buildInfoRow('Thu ngân:', 'TruongNe'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Giờ vào:', '18:00'),
                          _buildInfoRow('Tên bàn:', 'Bàn 1 + Bàn 2'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Bill table
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Table(
                    border: TableBorder(
                      borderRadius: BorderRadius.circular(8),
                      horizontalInside:
                          const BorderSide(color: Colors.grey, width: 0.5),
                      verticalInside:
                          const BorderSide(color: Colors.grey, width: 0.5),
                      top: const BorderSide(color: Colors.grey, width: 0.5),
                      bottom: const BorderSide(color: Colors.grey, width: 0.5),
                      left: const BorderSide(color: Colors.grey, width: 0.5),
                      right: const BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    columnWidths: const {
                      0: FlexColumnWidth(1.3),
                      1: FlexColumnWidth(2.8),
                      2: FlexColumnWidth(0.8),
                      3: FlexColumnWidth(2),
                      4: FlexColumnWidth(1),
                    },
                    children: [
                      _buildTableHeader(),
                      _buildTableRow('1', 'Gà chiên', '1', '180,000', true),
                      _buildTableRow('2', 'Tôm nướng', '1', '180,000', false),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Payment button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Thanh toán',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      children: const [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              'STT',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              'Món',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              'SL',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              'Tổng tiền',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              '',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRow(
      String stt, String item, String quantity, String total, bool isServed) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              stt,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              quantity,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              total,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Icon(
              isServed
                  ? PhosphorIconsRegular.checkCircle
                  : PhosphorIconsRegular.hourglassMedium,
              color: isServed ? Colors.green : Colors.orange,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

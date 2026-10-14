import 'package:elingk/modules/masyarakat/controllers/complaint_detail_controller.dart';
import 'package:get/get.dart';

class ComplaintDetailBinding extends Bindings {
  ComplaintDetailBinding({required this.complaintId});

  final int complaintId;

  String get tag => 'complaint_detail_$complaintId';

  @override
  void dependencies() {
    Get.put<ComplaintDetailController>(
      ComplaintDetailController(complaintId: complaintId),
      tag: tag,
    );
  }
}

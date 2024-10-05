import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/loading.dart';
import 'package:axata_absensi/pages/idcloud/controllers/idcloud_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class IdCloudView extends GetView<IdCloudController> {
  const IdCloudView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AxataTheme.bgGrey,
      appBar: const CustomAppBar(title: 'id cloud'),
      // resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AxataTheme.mainColor,
        child: const Icon(Icons.add),
        onPressed: () => controller.showForm(context, null),
      ),
      body: Column(
        children: [
          SizedBox(height: 24.h),
          Obx(
            () => Expanded(
              child: controller.isLoading.isTrue
                  ? const LoadingPage()
                  : controller.listIdCloud.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/logo/axata_logo.png',
                                height: 300.h,
                                width: 300.w,
                              ),
                              SizedBox(
                                height: 60.h,
                              ),
                              Text(
                                'Data id cloud tidak ditemukan',
                                style: TextStyle(
                                  color: AxataTheme.black,
                                  fontSize: 50.sp,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: controller.listIdCloud.length,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 12.h,
                          ),
                          itemBuilder: (context, index) {
                            final data = controller.listIdCloud[index];
                            return GestureDetector(
                              onTap: () => controller.handlePilih(index),
                              child: Container(
                                color: AxataTheme.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 60.w,
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    data['keterangan'],
                                    style: AxataTheme.oneBold,
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        data['idcloud'],
                                        style: AxataTheme.fourSmall,
                                      ),
                                      SizedBox(width: 36.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AxataTheme.white,
                                          border: Border.all(
                                            color: AxataTheme.mainColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          data['koneksi'],
                                          style: AxataTheme.sevenSmall,
                                        ),
                                      )
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        color: AxataTheme.black,
                                        onPressed: () {
                                          controller.showForm(context, index);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: AxataTheme.red,
                                        onPressed: () {
                                          controller.handleHapus(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:axata_absensi/pages/idcloud/controllers/idcloud_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class IdCloudView extends GetView<IdCloudController> {
  const IdCloudView({super.key});

  @override
  Widget build(BuildContext context) {
    Column idcloudWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Id Cloud',
            style: AxataTheme.threeSmall,
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
            height: 140.h,
            width: 0.8.sw,
            padding: EdgeInsets.symmetric(
              horizontal: 40.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: AxataTheme.mainColor,
              ),
            ),
            child: Center(
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.cloud,
                    color: AxataTheme.mainColor,
                    size: 45.r,
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: controller.idcloudC,
                      style: TextStyle(
                        color: AxataTheme.black,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Id Cloud kamu',
                        hintStyle: AxataTheme.oneSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Column namaTokoWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama Toko',
            style: AxataTheme.threeSmall,
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
            height: 140.h,
            width: 0.8.sw,
            padding: EdgeInsets.symmetric(
              horizontal: 40.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: AxataTheme.mainColor,
              ),
            ),
            child: Center(
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.fileSignature,
                    color: AxataTheme.mainColor,
                    size: 45.r,
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: controller.keteranganC,
                      style: TextStyle(
                        color: AxataTheme.black,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Nama Toko kamu',
                        hintStyle: AxataTheme.oneSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: AxataTheme.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            size: 70.r,
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/bg_login.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 120.h,
            child: Image.asset(
              'assets/logo/absensi_white.png',
              height: 170.h,
            ),
          ),
          Positioned(
            top: 0.07.sh,
            child: Image.asset(
              'assets/image/vector_login.png',
              height: 0.5.sh,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 1.sw,
              padding: EdgeInsets.only(top: 40.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AxataTheme.white,
                borderRadius: BorderRadius.circular(80.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ubah Id Cloud',
                    style: AxataTheme.twoBold,
                  ),
                  SizedBox(height: 40.h),
                  idcloudWidget(),
                  SizedBox(height: 12.h),
                  namaTokoWidget(),
                  SizedBox(height: 60.h),
                  Obx(
                    () => controller.isLoading.value
                        ? Container(
                            alignment: Alignment.center,
                            child: const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => controller.handleSimpan(),
                            child: Container(
                              height: 120.h,
                              width: 0.8.sw,
                              margin: EdgeInsets.only(top: 20.h),
                              decoration: AxataTheme.styleGradient,
                              alignment: Alignment.center,
                              child: Text(
                                'Simpan',
                                style: TextStyle(
                                  fontSize: 43.sp,
                                  color: AxataTheme.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: 60.h)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

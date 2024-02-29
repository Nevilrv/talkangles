import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/ui/angels/constant/app_assets.dart';
import 'package:talkangels/ui/angels/constant/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/controller/share_profile_details_service.dart';
import 'package:talkangels/ui/angels/models/angle_list_res_model.dart';
import 'package:talkangels/ui/angels/widgets/app_app_bar.dart';
import 'package:talkangels/ui/angels/widgets/app_button.dart';
import 'package:talkangels/ui/angels/widgets/app_show_profile_pic.dart';

class PersonDetailScreen extends StatefulWidget {
  const PersonDetailScreen({Key? key}) : super(key: key);

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  HandleNetworkConnection handleNetworkConnection = Get.find();
  HomeScreenController homeController = Get.put(HomeScreenController());
  String angelId = Get.arguments["angel_id"];
  AngleData? angelData;

  void getAngelsData() {
    homeController.angleAllData.forEach((element) {
      if (element.id == angelId) {
        angelData = element;
      }
    });
    log("ANGELDATA______${angelData}");
  }

  @override
  void initState() {
    super.initState();
    getAngelsData();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<HandleNetworkConnection>(
      builder: (networkController) {
        return Scaffold(
          appBar: AppAppBar(
            leadingIcon: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(Icons.arrow_back)),
            titleText: AppString.personDetails,
            bottom: PreferredSize(
              preferredSize: const Size(300, 50),
              child: 1.0.appDivider(),
            ),
          ),
          body: GetBuilder<HomeScreenController>(
            builder: (controller) {
              return Stack(
                children: [
                  Container(
                      height: h,
                      width: w,
                      decoration: const BoxDecoration(gradient: appGradient),
                      child: controller.isLoading == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : angelData == null
                              ? Center(
                                  child: AppString.noDataFound
                                      .leagueSpartanfs20w600(fontColor: greyFontColor, fontWeight: FontWeight.w700))
                              : SafeArea(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                AppShowProfilePic(
                                                    image: angelData!.image ?? '',
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) => ProfileDialog(angelId: angelId),
                                                      );
                                                    },
                                                    borderShow: false,
                                                    radius: 70),
                                                Positioned(
                                                  right: 6,
                                                  bottom: 6,
                                                  child: CircleAvatar(
                                                    backgroundColor: containerColor,
                                                    radius: 7,
                                                    child: CircleAvatar(
                                                        backgroundColor: angelData?.callStatus == AppString.available
                                                            ? greenColor
                                                            : angelData?.activeStatus == AppString.busy
                                                                ? yellowColor
                                                                : redFontColor,
                                                        radius: 4.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            (w * 0.03).addWSpace(),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  (angelData?.name ?? "").regularLeagueSpartan(
                                                    fontColor: whiteColor,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    textOverflow: TextOverflow.ellipsis,
                                                  ),
                                                  (angelData?.userName ?? "").regularLeagueSpartan(
                                                    fontColor: whiteColor.withOpacity(0.4),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    textOverflow: TextOverflow.ellipsis,
                                                  ),
                                                  (angelData?.activeStatus ?? "").regularLeagueSpartan(
                                                      fontColor: angelData?.activeStatus == AppString.online
                                                          ? greenColor
                                                          : yellowColor,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (networkController.isResult == false) {
                                                  String url = await DynamicLinkService()
                                                      .createShareProfileLink(angelId: angelData?.id);
                                                  Share.share(url);
                                                } else {
                                                  showAppSnackBar(AppString.noInternetConnection);
                                                }
                                              },
                                              child: const CircleAvatar(
                                                backgroundColor: redFontColor,
                                                radius: 17,
                                                child: Icon(Icons.share, color: whiteColor, size: 20),
                                              ),
                                            ),
                                            (w * 0.03).addWSpace(),
                                            InkWell(
                                              onTap: () {},
                                              child: CircleAvatar(
                                                backgroundColor: whiteColor,
                                                radius: 17,
                                                child: svgAssetImage(AppAssets.whatsAppLogo,
                                                    color: appColorGreen, width: 20, height: 20),
                                              ),
                                            ),
                                          ],
                                        ).paddingSymmetric(horizontal: w * 0.04, vertical: h * 0.02),
                                        1.0.appDivider(),

                                        ///About Me
                                        detailListTile(
                                          image: const Icon(Icons.person, color: whiteColor),
                                          title: AppString.aboutMe,
                                        ),
                                        (angelData?.bio ?? "")
                                            .regularLeagueSpartan(
                                              fontColor: greyFontColor,
                                              fontSize: 15,
                                            )
                                            .paddingOnly(
                                              left: w * 0.04,
                                              right: w * 0.04,
                                              bottom: h * 0.015,
                                            ),
                                        1.0.appDivider(),

                                        /// Language
                                        detailListTile(
                                          image: const Icon(Icons.translate_sharp, color: whiteColor),
                                          title: AppString.language,
                                        ),
                                        (angelData?.language ?? "")
                                            .regularLeagueSpartan(
                                              fontColor: greyFontColor,
                                              fontSize: 15,
                                            )
                                            .paddingOnly(
                                              left: w * 0.04,
                                              right: w * 0.04,
                                              bottom: h * 0.015,
                                            ),
                                        1.0.appDivider(),

                                        /// Personal Detail
                                        detailListTile(
                                          image: const Icon(Icons.link, color: whiteColor),
                                          title: AppString.personalDetails,
                                        ),
                                        ("${AppString.gender} : ${angelData?.gender ?? ""}")
                                            .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15)
                                            .paddingOnly(left: w * 0.04),
                                        ("${AppString.age}       : ${angelData?.age ?? ""} ${AppString.yrsOld}")
                                            .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15)
                                            .paddingOnly(left: w * 0.04, bottom: h * 0.015),
                                        1.0.appDivider(),

                                        /// Customer Rating
                                        InkWell(
                                          onTap: () {
                                            showModalBottomSheet<void>(
                                              constraints: BoxConstraints(maxHeight: h * 0.9, minHeight: h * 0.8),
                                              isDismissible: true,
                                              backgroundColor: containerColor,
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: h * 0.015, horizontal: w * 0.05),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                              height: 30,
                                                              width: 30,
                                                              decoration: BoxDecoration(
                                                                  color: textFieldColor,
                                                                  borderRadius: BorderRadius.circular(4)),
                                                              child: const Icon(Icons.star, color: whiteColor)),
                                                          (w * 0.03).addWSpace(),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  ("${AppString.customerRating} :  ")
                                                                      .regularLeagueSpartan(),
                                                                  (angelData?.totalRating?.toStringAsFixed(1) ?? "0")
                                                                      .regularLeagueSpartan(fontWeight: FontWeight.w800)
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  ("${AppString.totalReviews} :   ")
                                                                      .regularLeagueSpartan(),
                                                                  ("${(angelData?.reviews?.length ?? 0)} ${AppString.reviews}")
                                                                      .regularLeagueSpartan(fontWeight: FontWeight.w800)
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    2.0.appDivider(),
                                                    (h * 0.01).addHSpace(),
                                                    angelData?.reviews == null || angelData?.reviews?.length == 0
                                                        ? Expanded(
                                                            child: Center(
                                                                child: AppString.noReviewsYet
                                                                    .leagueSpartanfs20w600(fontColor: greyFontColor)))
                                                        : Expanded(
                                                            child: ListView.builder(
                                                              physics: const AlwaysScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount: angelData?.reviews?.length,
                                                              itemBuilder: (context, index) {
                                                                return Padding(
                                                                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                                                                  child: SizedBox(
                                                                    width: w,
                                                                    child: Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(vertical: h * 0.015),
                                                                          child: Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: w * 0.8,
                                                                                child: (angelData
                                                                                            ?.reviews?[index].comment ??
                                                                                        AppString.noComment)
                                                                                    .regularLeagueSpartan(
                                                                                        fontColor: greyFontColor),
                                                                              ),
                                                                              1.0.appDivider(),
                                                                              const Spacer(),
                                                                              Column(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment.start,
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.star,
                                                                                    size: 18,
                                                                                    color:
                                                                                        greyFontColor.withOpacity(0.3),
                                                                                  ),
                                                                                  ("${angelData?.reviews?[index].rating}")
                                                                                      .regularLeagueSpartan(
                                                                                          fontWeight: FontWeight.w800,
                                                                                          fontColor: greyFontColor),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        1.0.appDivider(),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  detailListTile(
                                                    image: const Icon(Icons.star, color: whiteColor),
                                                    title: AppString.customerRating,
                                                  ),
                                                  const Spacer(),
                                                  (angelData?.totalRating?.toStringAsFixed(1) ?? "")
                                                      .regularLeagueSpartan(
                                                          fontColor: appColorGreen,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500)
                                                      .paddingOnly(right: w * 0.04),
                                                ],
                                              ),
                                              ("${angelData?.totalListing ?? "0"} ${AppString.listing}")
                                                  .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15)
                                                  .paddingOnly(left: w * 0.04),
                                              ("${angelData?.reviews?.length ?? "0"} ${AppString.reviews}")
                                                  .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15)
                                                  .paddingOnly(left: w * 0.04, bottom: h * 0.015),
                                            ],
                                          ),
                                        ),
                                        1.0.appDivider(),

                                        /// Charges
                                        detailListTile(
                                          image: const Icon(Icons.currency_rupee, color: whiteColor),
                                          title: AppString.charges,
                                        ),
                                        "₹ ${angelData?.charges ?? ""} ${AppString.perMin}"
                                            .regularLeagueSpartan(
                                              fontColor: greyFontColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                            )
                                            .paddingOnly(
                                              left: w * 0.04,
                                              right: w * 0.04,
                                              bottom: h * 0.015,
                                            ),
                                        (h * 0.08).addHSpace(),
                                        AppButton(
                                          onTap: () {
                                            if (networkController.isResult == false) {
                                              homeController.angleCallingApi(
                                                  angelData!.id!, PreferenceManager().getId());
                                            } else {
                                              showAppSnackBar(AppString.noInternetConnection);
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.call, color: whiteColor),
                                              (w * 0.03).addWSpace(),
                                              // (angelData?.callStatus == AppString.available
                                              //         ? AppString.talkNow
                                              //         : angelData?.callStatus == AppString.busy
                                              //             ? AppString.busy
                                              //             : AppString.notAvailableSpec)
                                              (AppString.talkNow)
                                                  .regularLeagueSpartan(fontWeight: FontWeight.w900, fontSize: 20),
                                            ],
                                          ),
                                        ).paddingSymmetric(horizontal: w * 0.04),
                                        (h * 0.03).addHSpace(),
                                      ],
                                    ),
                                  ),
                                )),
                  controller.isCallLoading == true
                      ? Container(
                          height: h,
                          width: w,
                          color: Colors.black26,
                          child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                        )
                      : const SizedBox()
                ],
              );
            },
          ),
        );
      },
    );
  }

  detailListTile({
    required Icon image,
    required String title,
    Color? fontColor,
  }) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(color: textFieldColor, borderRadius: BorderRadius.circular(4)),
                child: image)
            .paddingOnly(right: w * 0.03),
        title.regularLeagueSpartan(fontColor: whiteColor, fontSize: 16, fontWeight: FontWeight.w500),
      ],
    ).paddingOnly(left: w * 0.04, right: w * 0.04, top: h * 0.015, bottom: h * 0.005);
  }
}

class ProfileDialog extends StatefulWidget {
  const ProfileDialog({Key? key, required this.angelId}) : super(key: key);
  final String angelId;

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  HandleNetworkConnection handleNetworkConnection = Get.find();
  HomeScreenController homeScreenController = Get.find();
  AngleData? angelData;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      builder: (controller) {
        controller.angleAllData.forEach((element) {
          if (element.id == widget.angelId) {
            angelData = element;
          }
        });
        return AlertDialog(
          insetPadding: EdgeInsets.only(left: Get.width * 0.06, right: Get.width * 0.3),
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Container(
            padding: EdgeInsets.zero,
            height: Get.height * 0.35,
            width: Get.width * 0.9,
            child: Column(
              children: [
                Container(
                  height: Get.height * 0.29,
                  width: Get.width * 0.9,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: angelData?.image == "" || angelData?.image == "0"
                      ? assetImage(AppAssets.blankProfile, fit: BoxFit.cover)
                      : Image.network("${angelData?.image}", fit: BoxFit.cover),
                ),
                Container(
                  height: Get.height * 0.06,
                  width: Get.width * 0.9,
                  decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (handleNetworkConnection.isResult == false) {
                              controller.setAngle(angelData!);
                              Get.back();
                              controller.angleCallingApi(angelData!.id.toString(), PreferenceManager().getId());
                            } else {
                              showAppSnackBar(AppString.noInternetConnection);
                            }
                          },
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: appColorGreen,
                                radius: 15,
                                child: Icon(Icons.phone, color: whiteColor, size: 18),
                              ),
                              (Get.width * 0.02).addWSpace(),
                              // (angelData?.callStatus == AppString.available
                              //         ? AppString.talkNow
                              //         : angelData?.callStatus == AppString.busy
                              //             ? AppString.busy
                              //             : AppString.notAvailableSpec)
                              (AppString.talkNow).regularLeagueSpartan(
                                  fontColor: appColorGreen, fontSize: 15, fontWeight: FontWeight.w900),
                            ],
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            if (handleNetworkConnection.isResult == false) {
                              Get.back();
                              String url = await DynamicLinkService().createShareProfileLink(angelId: angelData?.id);
                              Share.share(url);
                            } else {
                              showAppSnackBar(AppString.noInternetConnection);
                            }
                          },
                          child: Container(
                            height: Get.width * 0.08,
                            width: Get.width * 0.08,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: greyFontColor),
                            ),
                            child: const Icon(Icons.share, color: greyFontColor, size: 18),
                          ),
                        ),
                        (Get.width * 0.03).addWSpace(),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: Get.width * 0.08,
                            width: Get.width * 0.08,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: greyFontColor),
                            ),
                            child: svgAssetImage(AppAssets.whatsAppLogo, color: greyFontColor).paddingAll(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

///
///
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:talkangels/const/shared_prefs.dart';
// import 'package:talkangels/controller/handle_network_connections.dart';
// import 'package:talkangels/theme/app_layout.dart';
// import 'package:talkangels/ui/angels/constant/app_assets.dart';
// import 'package:talkangels/ui/angels/constant/app_color.dart';
// import 'package:talkangels/ui/angels/constant/app_string.dart';
// import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
// import 'package:talkangels/const/extentions.dart';
// import 'package:talkangels/ui/angels/main/home_pages/person_details_screen_controller.dart';
// import 'package:talkangels/controller/share_profile_details_service.dart';
// import 'package:talkangels/ui/angels/widgets/app_app_bar.dart';
// import 'package:talkangels/ui/angels/widgets/app_button.dart';
// import 'package:talkangels/ui/angels/widgets/app_show_profile_pic.dart';
//
// class PersonDetailScreen extends StatefulWidget {
//   const PersonDetailScreen({Key? key}) : super(key: key);
//
//   @override
//   State<PersonDetailScreen> createState() => _PersonDetailScreenState();
// }
//
// class _PersonDetailScreenState extends State<PersonDetailScreen> {
//   HandleNetworkConnection handleNetworkConnection = Get.find();
//   HomeScreenController homeController = Get.put(HomeScreenController());
//   PersonDetailsScreenController personDetailsScreenController = Get.put(PersonDetailsScreenController());
//
//   String angelId = Get.arguments["angel_id"];
//
//   @override
//   void initState() {
//     if (handleNetworkConnection.isResult == false) {
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         await personDetailsScreenController.getSingleangelData?(angelId);
//       });
//     }
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     log("Selected_Staff_id=========>>>>>>   $angelId");
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     return GetBuilder<HandleNetworkConnection>(
//       builder: (networkController) {
//         return Scaffold(
//           appBar: AppAppBar(
//             leadingIcon: GestureDetector(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: const Icon(Icons.arrow_back)),
//             titleText: AppString.personDetails,
//             bottom: PreferredSize(
//               preferredSize: const Size(300, 50),
//               child: 1.0.appDivider(),
//             ),
//           ),
//           body: GetBuilder<PersonDetailsScreenController>(
//             builder: (controller) {
//               return Container(
//                 height: h,
//                 width: w,
//                 decoration: const BoxDecoration(gradient: appGradient),
//                 child: controller.isDetailsLoading == true
//                     ? const Center(child: CircularProgressIndicator(color: Colors.white))
//                     : controller.getSingleAngelResModel.status == 200
//                         ? controller.getSingleAngelResModel.data == null
//                             ? Center(
//                                 child: AppString.noDataFound
//                                     .leagueSpartanfs20w600(fontColor: greyFontColor, fontWeight: FontWeight.w700))
//                             : SafeArea(
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           Stack(
//                                             children: [
//                                               AppShowProfilePic(
//                                                   image: controller.getSingleAngelResModel.data?.image ?? '',
//                                                   onTap: () {
//                                                     showDialog(
//                                                       context: context,
//                                                       builder: (_) => AlertDialog(
//                                                         insetPadding: EdgeInsets.only(left: w * 0.06, right: w * 0.3),
//                                                         contentPadding: EdgeInsets.zero,
//                                                         clipBehavior: Clip.antiAliasWithSaveLayer,
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius: BorderRadius.circular(10)),
//                                                         content: Builder(
//                                                           builder: (context) {
//                                                             return Container(
//                                                               padding: EdgeInsets.zero,
//                                                               height: h * 0.35,
//                                                               width: w * 0.9,
//                                                               child: Column(
//                                                                 children: [
//                                                                   Container(
//                                                                     height: h * 0.29,
//                                                                     width: w * 0.9,
//                                                                     decoration: const BoxDecoration(
//                                                                       borderRadius: BorderRadius.vertical(
//                                                                           top: Radius.circular(10)),
//                                                                     ),
//                                                                     child: controller.getSingleAngelResModel.data
//                                                                                     ?.image ==
//                                                                                 "" ||
//                                                                             controller.getSingleAngelResModel.data
//                                                                                     ?.image ==
//                                                                                 "0"
//                                                                         ? assetImage(AppAssets.blankProfile,
//                                                                             fit: BoxFit.cover)
//                                                                         : Image.network(
//                                                                             "${controller.getSingleAngelResModel.data?.image}",
//                                                                             fit: BoxFit.cover),
//                                                                   ),
//                                                                   Container(
//                                                                     height: h * 0.06,
//                                                                     width: w * 0.9,
//                                                                     decoration: const BoxDecoration(
//                                                                       color: whiteColor,
//                                                                       borderRadius: BorderRadius.vertical(
//                                                                           bottom: Radius.circular(10)),
//                                                                     ),
//                                                                     child: Padding(
//                                                                       padding:
//                                                                           EdgeInsets.symmetric(horizontal: w * 0.03),
//                                                                       child: Row(
//                                                                         children: [
//                                                                           InkWell(
//                                                                             onTap: () {
//                                                                               if (networkController.isResult == false) {
//                                                                                 if (controller.getSingleAngelResModel
//                                                                                         .data?.callStatus ==
//                                                                                     AppString.available) {
//                                                                                   homeController.angleCallingApi(
//                                                                                       controller.getSingleAngelResModel
//                                                                                           .data!.id!,
//                                                                                       PreferenceManager().getId());
//                                                                                 }
//                                                                               } else {
//                                                                                 showAppSnackBar(
//                                                                                     AppString.noInternetConnection);
//                                                                               }
//                                                                             },
//                                                                             child: Row(
//                                                                               children: [
//                                                                                 const CircleAvatar(
//                                                                                   backgroundColor: appColorGreen,
//                                                                                   radius: 15,
//                                                                                   child: Icon(Icons.phone,
//                                                                                       color: whiteColor, size: 18),
//                                                                                 ),
//                                                                                 (w * 0.02).addWSpace(),
//                                                                                 (controller.getSingleAngelResModel.data
//                                                                                                 ?.callStatus ==
//                                                                                             AppString.available
//                                                                                         ? AppString.talkNow
//                                                                                         : AppString.busy)
//                                                                                     .regularLeagueSpartan(
//                                                                                         fontColor: appColorGreen,
//                                                                                         fontSize: 15,
//                                                                                         fontWeight: FontWeight.w900),
//                                                                               ],
//                                                                             ),
//                                                                           ),
//                                                                           const Spacer(),
//                                                                           InkWell(
//                                                                             onTap: () async {
//                                                                               if (networkController.isResult == false) {
//                                                                                 String url = await DynamicLinkService()
//                                                                                     .createShareProfileLink(
//                                                                                         angelId: angelId);
//                                                                                 Share.share(url);
//                                                                               } else {
//                                                                                 showAppSnackBar(
//                                                                                     AppString.noInternetConnection);
//                                                                               }
//                                                                             },
//                                                                             child: Container(
//                                                                               height: w * 0.08,
//                                                                               width: w * 0.08,
//                                                                               decoration: BoxDecoration(
//                                                                                 shape: BoxShape.circle,
//                                                                                 border:
//                                                                                     Border.all(color: greyFontColor),
//                                                                               ),
//                                                                               child: const Icon(Icons.share,
//                                                                                   color: greyFontColor, size: 18),
//                                                                             ),
//                                                                           ),
//                                                                           (w * 0.03).addWSpace(),
//                                                                           InkWell(
//                                                                             onTap: () {},
//                                                                             child: Container(
//                                                                               height: w * 0.08,
//                                                                               width: w * 0.08,
//                                                                               decoration: BoxDecoration(
//                                                                                 shape: BoxShape.circle,
//                                                                                 border:
//                                                                                     Border.all(color: greyFontColor),
//                                                                               ),
//                                                                               child: svgAssetImage(
//                                                                                       AppAssets.whatsAppLogo,
//                                                                                       color: greyFontColor)
//                                                                                   .paddingAll(6),
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             );
//                                                           },
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   borderShow: false,
//                                                   radius: 70),
//                                               Positioned(
//                                                 right: 6,
//                                                 bottom: 6,
//                                                 child: controller.getSingleAngelResModel.data?.activeStatus ==
//                                                         AppString.online
//                                                     ? const CircleAvatar(
//                                                         backgroundColor: containerColor,
//                                                         radius: 7,
//                                                         child: CircleAvatar(backgroundColor: greenColor, radius: 4.5),
//                                                       )
//                                                     : const SizedBox(),
//                                               ),
//                                             ],
//                                           ),
//                                           (w * 0.03).addWSpace(),
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 (controller.getSingleAngelResModel.data?.name ?? "")
//                                                     .regularLeagueSpartan(
//                                                   fontColor: whiteColor,
//                                                   fontSize: 20,
//                                                   fontWeight: FontWeight.w500,
//                                                   textOverflow: TextOverflow.ellipsis,
//                                                 ),
//                                                 (controller.getSingleAngelResModel.data?.userName ?? "")
//                                                     .regularLeagueSpartan(
//                                                   fontColor: whiteColor.withOpacity(0.4),
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w500,
//                                                   textOverflow: TextOverflow.ellipsis,
//                                                 ),
//                                                 (controller.getSingleAngelResModel.data?.activeStatus ?? "")
//                                                     .regularLeagueSpartan(
//                                                         fontColor:
//                                                             controller.getSingleAngelResModel.data?.activeStatus ==
//                                                                     AppString.online
//                                                                 ? greenColor
//                                                                 : yellowColor,
//                                                         fontSize: 14,
//                                                         fontWeight: FontWeight.w500),
//                                               ],
//                                             ),
//                                           ),
//                                           InkWell(
//                                             onTap: () async {
//                                               if (networkController.isResult == false) {
//                                                 String url =
//                                                     await DynamicLinkService().createShareProfileLink(angelId: angelId);
//                                                 Share.share(url);
//                                               } else {
//                                                 showAppSnackBar(AppString.noInternetConnection);
//                                               }
//                                             },
//                                             child: const CircleAvatar(
//                                               backgroundColor: redFontColor,
//                                               radius: 17,
//                                               child: Icon(Icons.share, color: whiteColor, size: 20),
//                                             ),
//                                           ),
//                                           (w * 0.03).addWSpace(),
//                                           InkWell(
//                                             onTap: () {},
//                                             child: CircleAvatar(
//                                               backgroundColor: whiteColor,
//                                               radius: 17,
//                                               child: svgAssetImage(AppAssets.whatsAppLogo,
//                                                   color: appColorGreen, width: 20, height: 20),
//                                             ),
//                                           ),
//                                         ],
//                                       ).paddingSymmetric(horizontal: w * 0.04, vertical: h * 0.02),
//                                       1.0.appDivider(),
//
//                                       ///About Me
//                                       detailListTile(
//                                         image: const Icon(Icons.person, color: whiteColor),
//                                         title: AppString.aboutMe,
//                                       ),
//                                       (controller.getSingleAngelResModel.data?.bio ?? "")
//                                           .regularLeagueSpartan(
//                                             fontColor: greyFontColor,
//                                             fontSize: 15,
//                                           )
//                                           .paddingOnly(
//                                             left: w * 0.04,
//                                             right: w * 0.04,
//                                             bottom: h * 0.015,
//                                           ),
//                                       1.0.appDivider(),
//
//                                       /// Language
//                                       detailListTile(
//                                         image: const Icon(Icons.translate_sharp, color: whiteColor),
//                                         title: AppString.language,
//                                       ),
//                                       (controller.getSingleAngelResModel.data?.language ?? "")
//                                           .regularLeagueSpartan(
//                                             fontColor: greyFontColor,
//                                             fontSize: 15,
//                                           )
//                                           .paddingOnly(
//                                             left: w * 0.04,
//                                             right: w * 0.04,
//                                             bottom: h * 0.015,
//                                           ),
//                                       1.0.appDivider(),
//
//                                       /// Personal Detail
//                                       detailListTile(
//                                         image: const Icon(Icons.link, color: whiteColor),
//                                         title: AppString.personalDetails,
//                                       ),
//                                       ("${AppString.gender} : ${controller.getSingleAngelResModel.data?.gender ?? ""}")
//                                           .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15)
//                                           .paddingOnly(left: w * 0.04),
//                                       ("${AppString.age}       : ${controller.getSingleAngelResModel.data?.age ?? ""} ${AppString.yrsOld}")
//                                           .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15)
//                                           .paddingOnly(left: w * 0.04, bottom: h * 0.015),
//                                       1.0.appDivider(),
//
//                                       /// Customer Rating
//                                       InkWell(
//                                         onTap: () {
//                                           showModalBottomSheet<void>(
//                                             constraints: BoxConstraints(maxHeight: h * 0.9, minHeight: h * 0.8),
//                                             isDismissible: true,
//                                             backgroundColor: containerColor,
//                                             shape: const RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               return Column(
//                                                 children: [
//                                                   Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(vertical: h * 0.015, horizontal: w * 0.05),
//                                                     child: Row(
//                                                       children: [
//                                                         Container(
//                                                             height: 30,
//                                                             width: 30,
//                                                             decoration: BoxDecoration(
//                                                                 color: textFieldColor,
//                                                                 borderRadius: BorderRadius.circular(4)),
//                                                             child: const Icon(Icons.star, color: whiteColor)),
//                                                         (w * 0.03).addWSpace(),
//                                                         Column(
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           children: [
//                                                             Row(
//                                                               children: [
//                                                                 ("${AppString.customerRating} :  ")
//                                                                     .regularLeagueSpartan(),
//                                                                 (controller.getSingleAngelResModel.data?.totalRating
//                                                                             ?.toStringAsFixed(1) ??
//                                                                         "0")
//                                                                     .regularLeagueSpartan(fontWeight: FontWeight.w800)
//                                                               ],
//                                                             ),
//                                                             Row(
//                                                               children: [
//                                                                 ("${AppString.totalReviews} :   ")
//                                                                     .regularLeagueSpartan(),
//                                                                 ("${(controller.getSingleAngelResModel.data?.reviews?.length ?? 0)} ${AppString.reviews}")
//                                                                     .regularLeagueSpartan(fontWeight: FontWeight.w800)
//                                                               ],
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   2.0.appDivider(),
//                                                   (h * 0.01).addHSpace(),
//                                                   controller.getSingleAngelResModel.data?.reviews == null
//                                                       ? Padding(
//                                                           padding: EdgeInsets.symmetric(vertical: h * 0.15),
//                                                           child: Center(
//                                                             child: AppString.noReviewsYet
//                                                                 .leagueSpartanfs20w600(fontColor: greyFontColor),
//                                                           ),
//                                                         )
//                                                       : Expanded(
//                                                           child: ListView.builder(
//                                                             physics: const AlwaysScrollableScrollPhysics(),
//                                                             shrinkWrap: true,
//                                                             itemCount:
//                                                                 controller.getSingleAngelResModel.data?.reviews?.length,
//                                                             itemBuilder: (context, index) {
//                                                               return Padding(
//                                                                 padding: EdgeInsets.symmetric(horizontal: w * 0.05),
//                                                                 child: SizedBox(
//                                                                   width: w,
//                                                                   child: Column(
//                                                                     children: [
//                                                                       Padding(
//                                                                         padding:
//                                                                             EdgeInsets.symmetric(vertical: h * 0.015),
//                                                                         child: Row(
//                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                           children: [
//                                                                             SizedBox(
//                                                                               width: w * 0.8,
//                                                                               child: (controller
//                                                                                           .getSingleAngelResModel
//                                                                                           .data
//                                                                                           ?.reviews?[index]
//                                                                                           .comment ??
//                                                                                       AppString.noComment)
//                                                                                   .regularLeagueSpartan(
//                                                                                       fontColor: greyFontColor),
//                                                                             ),
//                                                                             1.0.appDivider(),
//                                                                             const Spacer(),
//                                                                             Column(
//                                                                               mainAxisAlignment:
//                                                                                   MainAxisAlignment.start,
//                                                                               children: [
//                                                                                 Icon(
//                                                                                   Icons.star,
//                                                                                   size: 18,
//                                                                                   color: greyFontColor.withOpacity(0.3),
//                                                                                 ),
//                                                                                 ("${controller.getSingleAngelResModel.data?.reviews?[index].rating}")
//                                                                                     .regularLeagueSpartan(
//                                                                                         fontWeight: FontWeight.w800,
//                                                                                         fontColor: greyFontColor),
//                                                                               ],
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                       1.0.appDivider(),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               );
//                                                             },
//                                                           ),
//                                                         ),
//                                                 ],
//                                               );
//                                             },
//                                           );
//                                         },
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 detailListTile(
//                                                   image: const Icon(Icons.star, color: whiteColor),
//                                                   title: AppString.customerRating,
//                                                 ),
//                                                 const Spacer(),
//                                                 (controller.getSingleAngelResModel.data?.totalRating
//                                                             ?.toStringAsFixed(1) ??
//                                                         "")
//                                                     .regularLeagueSpartan(
//                                                         fontColor: appColorGreen,
//                                                         fontSize: 16,
//                                                         fontWeight: FontWeight.w500)
//                                                     .paddingOnly(right: w * 0.04),
//                                               ],
//                                             ),
//                                             ("${controller.getSingleAngelResModel.data?.listingHours ?? ''} ${AppString.listing}")
//                                                 .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15)
//                                                 .paddingOnly(left: w * 0.04),
//                                             ("${controller.getSingleAngelResModel.data?.reviews?.length ?? "0"} ${AppString.reviews}")
//                                                 .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15)
//                                                 .paddingOnly(left: w * 0.04, bottom: h * 0.015),
//                                           ],
//                                         ),
//                                       ),
//                                       1.0.appDivider(),
//
//                                       /// Charges
//                                       detailListTile(
//                                         image: const Icon(Icons.currency_rupee, color: whiteColor),
//                                         title: AppString.charges,
//                                       ),
//                                       "₹ ${controller.getSingleAngelResModel.data?.charges ?? ""} ${AppString.perMin}"
//                                           .regularLeagueSpartan(
//                                             fontColor: greyFontColor,
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w800,
//                                           )
//                                           .paddingOnly(
//                                             left: w * 0.04,
//                                             right: w * 0.04,
//                                             bottom: h * 0.015,
//                                           ),
//
//                                       (h * 0.08).addHSpace(),
//                                       AppButton(
//                                         onTap: () {
//                                           if (networkController.isResult == false) {
//                                             if (controller.getSingleAngelResModel.data?.callStatus ==
//                                                 AppString.available) {
//                                               homeController.angleCallingApi(
//                                                   controller.getSingleAngelResModel.data!.id!,
//                                                   PreferenceManager().getId());
//                                             }
//                                           } else {
//                                             showAppSnackBar(AppString.noInternetConnection);
//                                           }
//                                         },
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             const Icon(Icons.call, color: whiteColor),
//                                             (w * 0.03).addWSpace(),
//                                             (controller.getSingleAngelResModel.data?.callStatus == AppString.available
//                                                     ? AppString.talkNow
//                                                     : AppString.busy)
//                                                 .regularLeagueSpartan(fontWeight: FontWeight.w900, fontSize: 20),
//                                           ],
//                                         ),
//                                       ).paddingSymmetric(horizontal: w * 0.04),
//                                       (h * 0.03).addHSpace(),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                         : controller.getSingleAngelResModel.status == 404
//                             ? Container(
//                                 height: h,
//                                 width: w,
//                                 decoration: const BoxDecoration(gradient: appGradient),
//                                 child: SafeArea(
//                                   child: SingleChildScrollView(
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//                                       child: Column(
//                                         children: [
//                                           (h * 0.1).addHSpace(),
//                                           SizedBox(
//                                               height: h * 0.3,
//                                               width: w * 0.6,
//                                               child: assetImage(AppAssets.somethingWentWrongAnimationAssets,
//                                                   fit: BoxFit.cover)),
//                                           (h * 0.05).addHSpace(),
//                                           AppString.somethingWentWrong.leagueSpartanfs20w600(fontSize: 24),
//                                           (h * 0.02).addHSpace(),
//                                           AppString.angelNotFound.regularLeagueSpartan(
//                                               fontColor: greyFontColor, textAlign: TextAlign.center),
//                                           (h * 0.05).addHSpace(),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             : ErrorScreen(
//                                 isLoading: controller.isDetailsLoading,
//                                 onTap: () {
//                                   if (networkController.isResult == false) {
//                                     WidgetsBinding.instance.addPostFrameCallback((_) async {
//                                       await personDetailsScreenController.getSingleangelData?(angelId);
//                                     });
//                                   }
//                                 },
//                               ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   detailListTile({
//     required Icon image,
//     required String title,
//     Color? fontColor,
//   }) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     return Row(
//       children: [
//         Container(
//                 height: 28,
//                 width: 28,
//                 decoration: BoxDecoration(color: textFieldColor, borderRadius: BorderRadius.circular(4)),
//                 child: image)
//             .paddingOnly(right: w * 0.03),
//         title.regularLeagueSpartan(fontColor: whiteColor, fontSize: 16, fontWeight: FontWeight.w500),
//       ],
//     ).paddingOnly(left: w * 0.04, right: w * 0.04, top: h * 0.015, bottom: h * 0.005);
//   }
// }

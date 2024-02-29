import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/controller/share_profile_details_service.dart';
import 'package:talkangels/ui/staff/constant/app_assets.dart';
import 'package:talkangels/ui/staff/constant/app_color.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart';
import 'package:talkangels/ui/staff/widgets/app_appbar.dart';
import 'package:talkangels/ui/staff/widgets/app_show_profile_pic.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  HomeController homeController = Get.put(HomeController());
  HandleNetworkConnection handleNetworkConnection = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<HandleNetworkConnection>(
      builder: (networkController) {
        return GetBuilder<HomeController>(
          builder: (controller) {
            return Scaffold(
              appBar: AppAppBar(
                titleText: AppString.profileDetails,
                action: [
                  IconButton(
                    onPressed: () {
                      Get.toNamed(Routes.editProfileScreen,
                          arguments: {"profile_detail": controller.getStaffDetailResModel.data!});
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  (w * 0.045).addWSpace(),
                ],
                bottom: PreferredSize(preferredSize: const Size(300, 50), child: 1.0.appDivider()),
              ),
              body: Container(
                height: h,
                width: w,
                decoration: const BoxDecoration(gradient: appGradient),
                child: controller.isLoading == true && controller.getStaffDetailResModel.data == null
                    ? const Center(child: CircularProgressIndicator(color: whiteColor))
                    : controller.getStaffDetailResModel.status == 200
                        ? SafeArea(
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
                                              image: controller.getStaffDetailResModel.data?.image ?? '',
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    insetPadding: EdgeInsets.only(left: w * 0.06, right: w * 0.3),
                                                    contentPadding: EdgeInsets.zero,
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    shape:
                                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                    content: Builder(
                                                      builder: (context) {
                                                        return Container(
                                                          padding: EdgeInsets.zero,
                                                          height: h * 0.35,
                                                          width: w * 0.9,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                height: h * 0.29,
                                                                width: w * 0.9,
                                                                decoration: const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.vertical(top: Radius.circular(10)),
                                                                ),
                                                                child: controller.getStaffDetailResModel.data?.image ==
                                                                            '' ||
                                                                        controller.getStaffDetailResModel.data?.image ==
                                                                            "0" ||
                                                                        controller.getStaffDetailResModel.data?.image ==
                                                                            "file:///null" ||
                                                                        controller.getStaffDetailResModel.data?.image ==
                                                                            null
                                                                    ? assetImage(AppAssets.blankProfile,
                                                                        fit: BoxFit.cover)
                                                                    : Image.network(
                                                                        "${controller.getStaffDetailResModel.data?.image}",
                                                                        fit: BoxFit.cover),
                                                              ),
                                                              Container(
                                                                height: h * 0.06,
                                                                width: w * 0.9,
                                                                decoration: const BoxDecoration(
                                                                  color: whiteColor,
                                                                  borderRadius: BorderRadius.vertical(
                                                                      bottom: Radius.circular(10)),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                                                                  child: Row(
                                                                    children: [
                                                                      const Spacer(),
                                                                      InkWell(
                                                                        onTap: () async {
                                                                          if (networkController.isResult == false) {
                                                                            String url = await DynamicLinkService()
                                                                                .createShareProfileLink(
                                                                                    angelId: PreferenceManager()
                                                                                        .getId()
                                                                                        .toString());
                                                                            Share.share(url);
                                                                          } else {
                                                                            showAppSnackBar(
                                                                                AppString.noInternetConnection);
                                                                          }
                                                                        },
                                                                        child: Container(
                                                                          height: w * 0.08,
                                                                          width: w * 0.08,
                                                                          decoration: BoxDecoration(
                                                                            shape: BoxShape.circle,
                                                                            border: Border.all(color: greyFontColor),
                                                                          ),
                                                                          child: const Icon(Icons.share,
                                                                              color: greyFontColor, size: 18),
                                                                        ),
                                                                      ),
                                                                      (w * 0.03).addWSpace(),
                                                                      InkWell(
                                                                        onTap: () {
                                                                          if (networkController.isResult == false) {
                                                                          } else {
                                                                            showAppSnackBar(
                                                                                AppString.noInternetConnection);
                                                                          }
                                                                        },
                                                                        child: Container(
                                                                          height: w * 0.08,
                                                                          width: w * 0.08,
                                                                          decoration: BoxDecoration(
                                                                            shape: BoxShape.circle,
                                                                            border: Border.all(color: greyFontColor),
                                                                          ),
                                                                          child: svgAssetImage(AppAssets.whatsAppLogo,
                                                                                  color: greyFontColor)
                                                                              .paddingAll(6),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                              borderShow: false,
                                              radius: 70),
                                          Positioned(
                                            right: 6,
                                            bottom: 6,
                                            child: controller.getStaffDetailResModel.data?.activeStatus ==
                                                    AppString.online
                                                ? const CircleAvatar(
                                                    backgroundColor: containerColor,
                                                    radius: 7,
                                                    child: CircleAvatar(backgroundColor: appColorGreen, radius: 4.5),
                                                  )
                                                : const SizedBox(),
                                          ),
                                        ],
                                      ),
                                      (w * 0.03).addWSpace(),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            (controller.getStaffDetailResModel.data?.name ?? "").regularLeagueSpartan(
                                              fontColor: whiteColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              textOverflow: TextOverflow.ellipsis,
                                            ),
                                            (controller.getStaffDetailResModel.data?.userName ?? "")
                                                .regularLeagueSpartan(
                                              fontColor: whiteColor.withOpacity(0.4),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              textOverflow: TextOverflow.ellipsis,
                                            ),
                                            (controller.getStaffDetailResModel.data?.activeStatus ?? "")
                                                .regularLeagueSpartan(
                                                    fontColor: controller.getStaffDetailResModel.data?.activeStatus ==
                                                            AppString.online
                                                        ? appColorGreen
                                                        : yellowColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () async {
                                          if (networkController.isResult == false) {
                                            String url = await DynamicLinkService().createShareProfileLink(
                                                angelId: PreferenceManager().getId().toString());
                                            Share.share(url);
                                          } else {
                                            showAppSnackBar(AppString.noInternetConnection);
                                          }
                                        },
                                        child: const CircleAvatar(
                                          backgroundColor: appColorBlue,
                                          radius: 17,
                                          child: Icon(Icons.share, color: whiteColor, size: 20),
                                        ),
                                      ),
                                      (w * 0.03).addWSpace(),
                                      InkWell(
                                        onTap: () {
                                          if (networkController.isResult == false) {
                                          } else {
                                            showAppSnackBar(AppString.noInternetConnection);
                                          }
                                        },
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
                                  (controller.getStaffDetailResModel.data?.bio ?? "")
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
                                  (controller.getStaffDetailResModel.data?.language ?? "")
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
                                  ("Gender : ${controller.getStaffDetailResModel.data?.gender ?? ""}")
                                      .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15)
                                      .paddingOnly(left: w * 0.04),
                                  ("Age       : ${controller.getStaffDetailResModel.data?.age ?? ''}")
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
                                                padding:
                                                    EdgeInsets.symmetric(vertical: h * 0.015, horizontal: w * 0.05),
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
                                                            ("${AppString.customerRating} :  ").regularLeagueSpartan(),
                                                            (controller.getStaffDetailResModel.data?.totalRating
                                                                        ?.toStringAsFixed(1) ??
                                                                    "0")
                                                                .regularLeagueSpartan(fontWeight: FontWeight.w800)
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            ("${AppString.totalReviews}      :   ")
                                                                .regularLeagueSpartan(),
                                                            ("${(controller.reviewList.length)} Reviews")
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
                                              controller.getStaffDetailResModel.data!.reviews!.isEmpty
                                                  ? Expanded(
                                                      child: Center(
                                                          child: AppString.noReviewsYet
                                                              .leagueSpartanfs20w600(fontColor: greyFontColor)))
                                                  : Expanded(
                                                      child: ListView.builder(
                                                        physics: const AlwaysScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: controller.reviewList.length,
                                                        itemBuilder: (context, index) {
                                                          return Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                                                            child: SizedBox(
                                                              width: w,
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(vertical: h * 0.015),
                                                                    child: Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: w * 0.8,
                                                                          child:
                                                                              ("${controller.reviewList[index].comment ?? "No Comment"}")
                                                                                  .regularLeagueSpartan(
                                                                                      fontColor: greyFontColor),
                                                                        ),
                                                                        1.0.appDivider(),
                                                                        const Spacer(),
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.star,
                                                                              size: 18,
                                                                              color: greyFontColor.withOpacity(0.3),
                                                                            ),
                                                                            ("${controller.reviewList[index].rating}")
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
                                            (controller.getStaffDetailResModel.data?.totalRating?.toStringAsFixed(1) ??
                                                    "")
                                                .regularLeagueSpartan(
                                                    fontColor: appColorGreen, fontSize: 16, fontWeight: FontWeight.w500)
                                                .paddingOnly(right: w * 0.04),
                                          ],
                                        ),
                                        ("${controller.getStaffDetailResModel.data?.listing?.totalMinutes ?? ''} Listing")
                                            .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15)
                                            .paddingOnly(left: w * 0.04),
                                        ("${controller.reviewList.length} Reviews")
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
                                  "₹ ${controller.getStaffDetailResModel.data?.charges ?? ""} ${AppString.perMin}"
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

                                  (h * 0.03).addHSpace(),
                                ],
                              ),
                            ),
                          )
                        : StaffErrorScreen(
                            isLoading: controller.isLoading,
                            onTap: () {
                              if (networkController.isResult == false) {
                                WidgetsBinding.instance.addPostFrameCallback((_) async {
                                  await homeController.getStaffDetailApi();
                                });
                              }
                            },
                          ),
              ),
            );
          },
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
                height: 26,
                width: 26,
                decoration: BoxDecoration(color: textFieldColor, borderRadius: BorderRadius.circular(4)),
                child: image)
            .paddingOnly(right: w * 0.03),
        title.regularLeagueSpartan(fontColor: whiteColor, fontSize: 16, fontWeight: FontWeight.w500),
      ],
    ).paddingOnly(left: w * 0.05, right: w * 0.05, top: h * 0.015, bottom: h * 0.005);
  }
}

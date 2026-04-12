// ignore: must_be_immutable
import 'dart:developer';

import 'package:customer/app/restaurant_details_screen/restaurant_details_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/models/story_model.dart';
import 'package:customer/models/vendor_model.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/network_image_widget.dart';
import 'package:customer/widget/story_view/controller/story_controller.dart';
import 'package:customer/widget/story_view/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../widget/story_view/widgets/story_view.dart';

// ignore: must_be_immutable
class MoreStories extends StatefulWidget {
  final List<StoryModel> storyList;
  int index;

  MoreStories({
    super.key,
    required this.index,
    required this.storyList,
  });

  @override
  State<MoreStories> createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  late StoryController _storyController;
  VideoPlayerController? _videoController;
  late Future<VendorModel?> _vendorFuture;

  @override
  void initState() {
    super.initState();
    _storyController = StoryController();
    _loadStory();
  }

  void _loadStory() {
    _videoController?.dispose();

    final story = widget.storyList[widget.index];

    if (story.videoUrl.isNotEmpty) {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(story.videoUrl.first),
      )..initialize().then((_) {
          if (mounted) setState(() {});
        });
    }

    _vendorFuture = FireStoreUtils.getVendorById(story.vendorID.toString());

    log(
      "Story index: ${widget.index}, videos: ${story.videoUrl.length}",
    );
  }

  void _changeStory(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.storyList.length) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      widget.index = newIndex;
      _storyController.dispose();
      _storyController = StoryController();
      _loadStory();
    });
  }

  @override
  void dispose() {
    _storyController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.storyList[widget.index];

    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity == null) return;

          if (details.primaryVelocity! < 0) {
            _changeStory(widget.index + 1);
          } else if (details.primaryVelocity! > 0) {
            _changeStory(widget.index - 1);
          }
        },
        child: Stack(
          children: [
            if (_videoController == null || !_videoController!.value.isInitialized)
              Constant.loader()
            else
              StoryView(
                key: ValueKey(widget.index),
                controller: _storyController,
                progressPosition: ProgressPosition.top,
                repeat: true,
                storyItems: story.videoUrl.map(
                  (url) {
                    return StoryItem.pageVideo(
                      url,
                      controller: _storyController,
                      duration: _videoController!.value.duration,
                    );
                  },
                ).toList(),
                onComplete: () => _changeStory(widget.index + 1),
                onVerticalSwipeComplete: (direction) {
                  if (direction == Direction.down) {
                    Navigator.pop(context);
                  }
                },
              ),

            /// Vendor Header
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top + 30,
                left: 16,
                right: 16,
              ),
              child: FutureBuilder<VendorModel?>(
                future: _vendorFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();

                  final vendor = snapshot.data!;
                  return InkWell(
                    onTap: () {
                      Get.to(
                        const RestaurantDetailsScreen(),
                        arguments: {"vendorModel": vendor},
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: NetworkImageWidget(
                            imageUrl: vendor.photo ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vendor.title ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset("assets/icons/ic_star.svg"),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${Constant.calculateReview(
                                      reviewCount: vendor.reviewsCount.toString(),
                                      reviewSum: vendor.reviewsSum.toString(),
                                    )} reviews",
                                    style: const TextStyle(
                                      color: AppThemeData.warning300,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: Get.back,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/ic_close.svg",
                              colorFilter: const ColorFilter.mode(
                                AppThemeData.grey800,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter/common/common.dart';
import 'package:twitter/constants/assets_constants.dart';
import 'package:twitter/core/utils.dart';
import 'package:twitter/features/auth/controller/auth_controller.dart';
import 'package:twitter/features/home/tweet/controller/tweet_controller.dart';
import 'package:twitter/theme/pallete.dart';
import 'dart:io';

class CreateTweetScreen extends ConsumerStatefulWidget {
  static router() => MaterialPageRoute(
        builder: (context) => const CreateTweetScreen(),
      );
  const CreateTweetScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final tweetTextController = TextEditingController();
  List<File> images = [];
  onCloseTweetScreen() {
    Navigator.pop(context);
  }

  onPickImage() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  void dispose() {
    tweetTextController.dispose();
    super.dispose();
  }

  void shareTweet() {
    ref.watch(tweetControllerProvider.notifier).shareTweet(
          images: images,
          text: tweetTextController.text,
          context: context,
        );
    Navigator.pop(context);
  } 

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onCloseTweetScreen,
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        actions: [
          RoundedSmallButton(
              ontap: shareTweet,
              label: 'Tweet',
              backgroundColor: Pallete.blueColor,
              textColor: Pallete.whiteColor)
        ],
      ),
      body: currentUser == null || isLoading
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        currentUser.profilePic != ''
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(currentUser.profilePic),
                              )
                            : const Icon(
                                Icons.person_rounded,
                                size: 30,
                              ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: tweetTextController,
                            style: const TextStyle(fontSize: 22),
                            decoration: const InputDecoration(
                                hintText: "What's happening",
                                hintStyle: TextStyle(
                                  color: Pallete.greyColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                                border: InputBorder.none),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                          items: images.map(
                            (file) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                child: Image.file(file),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                              );
                            },
                          ).toList(),
                          options: CarouselOptions(
                            height: 400,
                            enableInfiniteScroll: false,
                          ))
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Pallete.greyColor))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8).copyWith(
                left: 15,
                right: 15,
              ),
              child: GestureDetector(
                child: SvgPicture.asset(AssetsConstants.galleryIcon),
                onTap: onPickImage,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.gifIcon),
            ),
            Padding(
              padding: const EdgeInsets.all(8).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.emojiIcon),
            )
          ],
        ),
      ),
    );
  }
}

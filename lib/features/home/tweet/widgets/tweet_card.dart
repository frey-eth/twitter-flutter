import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter/common/common.dart';
import 'package:twitter/constants/assets_constants.dart';
import 'package:twitter/core/enums/tweet_types.dart';
import 'package:twitter/features/auth/controller/auth_controller.dart';
import 'package:twitter/features/home/tweet/controller/tweet_controller.dart';
import 'package:twitter/features/home/tweet/widgets/hashtag_text.dart';
import 'package:twitter/features/home/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter/features/home/tweet/widgets/tweet_images.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twitter/theme/pallete.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({
    super.key,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(tweet.uid)).when(
              data: (user) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: user!.profilePic != ''
                                ? CircleAvatar(
                                    radius: 35,
                                    backgroundImage:
                                        NetworkImage(user.profilePic),
                                  )
                                : const Icon(
                                    Icons.person_rounded,
                                    size: 35,
                                  ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      child: Text(
                                        user.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      child: Text(
                                        '@${user.name}   ⏳   ${timeago.format(tweet.createdAt, locale: 'en-short')}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                HashtagText(text: tweet.text),
                                if (tweet.tweetType == TweetType.image)
                                  TweetImages(imageLinks: tweet.imageLinks),
                                if (tweet.link.isNotEmpty) ...[
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  AnyLinkPreview(
                                    link: tweet.link,
                                    displayDirection:
                                        UIDirection.uiDirectionHorizontal,
                                  ),
                                ],
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 10,
                                    right: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TweetIconButton(
                                          pathName: AssetsConstants.viewsIcon,
                                          text: (tweet.commentIds.length +
                                                  tweet.reshareCount.bitLength +
                                                  tweet.likes.length)
                                              .toString(),
                                          onTap: () {}),
                                      TweetIconButton(
                                          pathName: AssetsConstants.retweetIcon,
                                          text: tweet.commentIds.length
                                              .toString(),
                                          onTap: () {}),
                                      TweetIconButton(
                                          pathName: AssetsConstants.commentIcon,
                                          text: tweet.commentIds.length
                                              .toString(),
                                          onTap: () {}),
                                      LikeButton(
                                        onTap: (isLiked) async {
                                          ref
                                              .read(tweetControllerProvider
                                                  .notifier)
                                              .likeTweet(tweet, user);
                                          return !isLiked;
                                        },
                                        size: 20,
                                        likeBuilder: (isLiked) {
                                          return isLiked
                                              ? SvgPicture.asset(
                                                  AssetsConstants
                                                      .likeFilledIcon,
                                                  color: Colors.red,
                                                )
                                              : SvgPicture.asset(
                                                  AssetsConstants
                                                      .likeOutlinedIcon,
                                                  color: Pallete.greyColor,
                                                );
                                        },
                                        likeCount: tweet.likes.length,
                                        countBuilder:
                                            (likeCount, isLiked, text) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0),
                                            child: Text(text,
                                                style: TextStyle(
                                                    color: isLiked
                                                        ? Pallete.redColor
                                                        : Pallete.greyColor)),
                                          );
                                        },
                                        isLiked: tweet.likes
                                            .contains(currentUser.uid),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.share_outlined,
                                          size: 20,
                                        ),
                                        color: Pallete.greyColor,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        color: Pallete.greyColor,
                      )
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            );
  }
}

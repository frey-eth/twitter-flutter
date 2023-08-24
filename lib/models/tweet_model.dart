// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:twitter/core/enums/tweet_types.dart';

@immutable
class Tweet {
  final String text;
  final List<String> hashtags;
  final String link;
  final List<String> imageLinks;
  final String uid;
  final TweetType tweetType;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> commentIds;
  final String id;
  final int reshareCount;
  const Tweet({
    required this.text,
    required this.hashtags,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.tweetType,
    required this.createdAt,
    required this.likes,
    required this.commentIds,
    required this.id,
    required this.reshareCount,
  });

  Tweet copyWith({
    String? text,
    List<String>? hashtags,
    String? link,
    List<String>? imageLinks,
    String? uid,
    TweetType? tweetType,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
    int? reshareCount,
  }) {
    return Tweet(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      tweetType: tweetType ?? this.tweetType,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      reshareCount: reshareCount ?? this.reshareCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'hashtags': hashtags,
      'link': link,
      'imageLinks': imageLinks,
      'uid': uid,
      'tweetType': tweetType.type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
      'reshareCount': reshareCount,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      text: map['text'] ?? '',
      hashtags: List<String>.from((map['hashtags'] as List<String>)),
      link: map['link'] ?? '',
      imageLinks: List<String>.from((map['imageLinks'] as List<String>)),
      uid: map['uid'] ?? '',
      tweetType: (map['tweetType'] as String).toTweetTypeEnum(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      likes: List<String>.from((map['likes'] as List<String>)),
      commentIds: List<String>.from((map['commentIds'] as List<String>)),
      id: map['\$id'] ?? '',
      reshareCount: map['reshareCount'] as int,
    );
  }

  @override
  String toString() {
    return 'Tweet(text: $text, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, uid: $uid, tweetType: $tweetType, createdAt: $createdAt, likes: $likes, commentIds: $commentIds, id: $id, reshareCount: $reshareCount)';
  }

  @override
  bool operator ==(covariant Tweet other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        listEquals(other.hashtags, hashtags) &&
        other.link == link &&
        listEquals(other.imageLinks, imageLinks) &&
        other.uid == uid &&
        other.tweetType == tweetType &&
        other.createdAt == createdAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.id == id &&
        other.reshareCount == reshareCount;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hashtags.hashCode ^
        link.hashCode ^
        imageLinks.hashCode ^
        uid.hashCode ^
        tweetType.hashCode ^
        createdAt.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        id.hashCode ^
        reshareCount.hashCode;
  }
}

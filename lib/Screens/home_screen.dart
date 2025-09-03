import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Screens/Categories_screen.dart';
import 'package:news_app/models/Categories_News_Model.dart';
import 'package:news_app/models/News_channels_headlines_model.dart';
import 'package:news_app/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, independent, cnn, reuters, alJazeera }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  FilterList? selectedmenu;
  final format = DateFormat('MMM,dd,yyyy');
  String name = "bbc-news";
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoriesScreen()));
          },
          icon: Image.asset('images/category_icon.png'),
        ),
        title: Text(
          "News",
          style: GoogleFonts.pacifico(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedmenu,
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (FilterList item) {
              if (FilterList.bbcNews.name == item.name) {
                name = "bbc-News";
              }
              if (FilterList.aryNews.name == item.name) {
                name = "ary-News";
              }
              if (FilterList.alJazeera.name == item.name) {
                name = "aljazeera-News";
              }
              if (FilterList.reuters.name == item.name) {
                name = "reuters-News";
              }
              if (FilterList.independent.name == item.name) {
                name = "independent-News";
              }
              if (FilterList.cnn.name == item.name) {
                name = "cnn-News";
              }
              setState(() {
                selectedmenu = item;
              });
            },
            itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem(value: FilterList.bbcNews, child: Text("BBC news")),
              PopupMenuItem(value: FilterList.bbcNews, child: Text("Ary news")),
              PopupMenuItem(value: FilterList.aryNews, child: Text("CNN news")),
              PopupMenuItem(value: FilterList.cnn, child: Text("Independent")),
              PopupMenuItem(
                value: FilterList.independent,
                child: Text("Reuters"),
              ),
              PopupMenuItem(
                value: FilterList.alJazeera,
                child: Text("Aljazeera"),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.brown,
            child: SizedBox(
              height: height * .55,
              child: FutureBuilder<NewsChannelHeadlineModel>(
                future: newsViewModel.fetchnewschannelheadlinesapi(name),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<NewsChannelHeadlineModel> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 40,
                        color: Colors.lightGreenAccent,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(
                          snapshot.data!.articles![index].publishedAt
                              .toString(),
                        );
                        return SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: height * 0.6,
                                width: width * .9,
                                padding: EdgeInsets.symmetric(
                                  horizontal: height * .82,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index]
                                        .urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Container(child: spinkit2),
                                    errorWidget: (context, url, error) =>
                                        Icon(
                                      Icons.error_outline,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    height: height * .22,
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width * .7,
                                          child: Text(
                                            snapshot.data!.articles![index]
                                                .title
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: width * .7,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Text(snapshot
                                                  .data!
                                                  .articles![index]
                                                  .source!
                                                  .name
                                                  .toString()),
                                              Text(
                                                format.format(dateTime),
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ), 

          FutureBuilder<CategoriesNewsModel>(
            future: newsViewModel.fetchcategoriesnewsapi('general'),
            builder: (
              BuildContext context,
              AsyncSnapshot<CategoriesNewsModel> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitCircle(
                    size: 40,
                    color: Colors.lightGreenAccent,
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.articles!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    DateTime dateTime = DateTime.parse(
                      snapshot.data!.articles![index].publishedAt.toString(),
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data!.articles![index]
                                  .urlToImage
                                  .toString(),
                              fit: BoxFit.cover,
                              height: height * .18,
                              width: width * .3,
                              placeholder: (context, url) => Container(
                                child: SpinKitCircle(
                                  size: 40,
                                  color: Colors.lightGreenAccent,
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error_outline,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: height * .18,
                              padding: EdgeInsets.only(left: 15),
                              child: Column(
                                children: [
                                  Text(
                                    snapshot.data!.articles![index].title
                                        .toString(),
                                    maxLines: 3,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Text(
                                        snapshot.data!.articles![index]
                                            .source!.name
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        format.format(dateTime),
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ), 
        ],
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(color: Colors.deepOrange, size: 56);

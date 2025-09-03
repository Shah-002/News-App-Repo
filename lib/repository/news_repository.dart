import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/Categories_News_Model.dart';
import 'package:news_app/models/News_channels_headlines_model.dart';

class NewsRepository{

  Future<NewsChannelHeadlineModel> fetchnewschannelheadlinesapi(String channelname)async{

    String url='https://newsapi.org/v2/top-headlines?sources=${channelname}&apiKey=6009e51dcc25443d96c5005d16737de0';
    
    final response= await http.get(Uri.parse(url));

    if(response.statusCode==200){
      final body=jsonDecode(response.body);

      return NewsChannelHeadlineModel.fromJson(body);

    }
    throw Exception('Error');

  }

  Future<CategoriesNewsModel> fetchcategoriesnewsapi(String category) async{
    final response= await http.get(Uri.parse('https://newsapi.org/v2/everything?q=${category}&apiKey=6009e51dcc25443d96c5005d16737de0'));
    if(response.statusCode==200){
      final body=jsonDecode(response.body);

      return CategoriesNewsModel.fromJson(body);

    }throw Exception('Error');
  }
}
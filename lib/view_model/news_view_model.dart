

import 'package:news_app/models/Categories_News_Model.dart';
import 'package:news_app/models/News_channels_headlines_model.dart';

class NewsViewModel {

  final _rep=NewsViewModel();

  Future<NewsChannelHeadlineModel> fetchnewschannelheadlinesapi(String channelname) async{

    final response= await _rep.fetchnewschannelheadlinesapi(channelname);
    return response;

  }

  Future<CategoriesNewsModel> fetchcategoriesnewsapi(String category) async{

    final response= await _rep.fetchcategoriesnewsapi(category);
    return response;

  }
}
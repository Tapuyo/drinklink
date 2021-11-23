import 'package:dio/dio.dart';
import 'package:driklink/pages/home/post_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class PaymentSample extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();


}

class _HomePageState extends State<PaymentSample> {


  getConsult() async{

    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json"};
    String url = "https://drinklink-prod-be.azurewebsites.net/api/";
    //String url = "http://10.0.2.2:3000/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body);


    print(response.toString());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        centerTitle: true,
        title: Text(
          'Flutter Retrofit',
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Center(
          child: GestureDetector(
            onTap: (){
              getConsult();
            },
            child: Icon(Icons.search, size: 100,),
          ),
        ),
      )
    );
  }
}


//
// class _HomePageState extends State<PaymentSample> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue[300],
//         centerTitle: true,
//         title: Text(
//           'Flutter Retrofit',
//           style: TextStyle(
//               fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: _buildBody(context),
//     );
//   }
//
//
//   FutureBuilder<List<Post>> _buildBody(BuildContext context) {
//     final client = RestClient(Dio(BaseOptions(contentType: "application/json")));
//     return FutureBuilder<List<Post>>(
//
//       future: client.getTasks(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           final List<Post> posts = snapshot.data;
//           return _buildPosts(context, posts);
//         } else {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
//   }
//
//   ListView _buildPosts(BuildContext context, List<Post> posts) {
//     return ListView.builder(
//       itemCount: posts.length,
//       padding: EdgeInsets.all(8),
//       itemBuilder: (context, index) {
//         return Card(
//           elevation: 4,
//           child: ListTile(
//             title: Text(
//               posts[index].name,
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(posts[index].email),
//             leading: Column(
//               children: <Widget>[
//                 Image.network(posts[index].picture,width: 50,height: 50,
//                 ),
//               ],
//
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(ZfanzApp());

class ZfanzApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZFANZ-ELECTRONICS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String,String>> products = [
    {"name":"Phone Charging System","price":"UGX 25,000","video":"dQw4w9WgXcQ"},
    {"name":"TV Repair Kit","price":"UGX 120,00","video":"dQw4w9WgXcQ"},
    {"name":"Solar Power Inverter","price":"UGX 350,00","video":"dQw4w9WgXcQ"},
    {"name":"Bluetooth Speaker","price":"UGX 65,00","video":"dQw4w9WgXcQ"},
  ];

  void orderWhatsApp(String product) async {
    final phone = "256770980980"; // CHANGE to your number
    final msg = "Hello ZFANZ, I want to order: $product";
    final url = Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(msg)}");
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ZFANZ-ELECTRONICS"), centerTitle: true, backgroundColor: Colors.deepPurple[100]),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (c,i){
          final p = products[i];
          final controller = YoutubePlayerController(initialVideoId: p["video"]!, flags: YoutubePlayerFlags(autoPlay: false));
          return Card(
            margin: EdgeInsets.only(bottom:16),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p["name"]!, style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                  SizedBox(height:4),
                  Text(p["price"]!, style: TextStyle(color: Colors.green, fontSize:16)),
                  SizedBox(height:8),
                  YoutubePlayer(controller: controller, showVideoProgressIndicator: true),
                  SizedBox(height:8),
                  SizedBox(width: double.infinity, child: ElevatedButton.icon(icon: Icon(Icons.shopping_cart), label: Text("Order on WhatsApp"), onPressed: ()=> orderWhatsApp(p["name"]!))),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: ()=> orderWhatsApp("General Inquiry"), label: Text("Contact"), icon: Icon(Icons.chat)),
    );
  }
}

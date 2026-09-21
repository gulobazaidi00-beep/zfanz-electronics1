import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp(home: Home(), debugShowCheckedModeBanner: false));

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> ids = [];
  bool loading = true;
  final String handle = "@gulobazaidi-s7f";

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final r = await http.get(Uri.parse('https://www.youtube.com/$handle/videos'),
          headers: {'User-Agent': 'Mozilla/5.0'});
      final reg = RegExp(r'"videoId":"([a-zA-Z0-9_-]{11})"');
      final list = reg.allMatches(r.body).map((m) => m.group(1)!).toSet().toList();
      setState(() { ids = list; loading = false; });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ZFANZ-ELECTRONICS"), backgroundColor: Colors.red, centerTitle: true),
      body: loading? Center(child: CircularProgressIndicator()) :
      ids.isEmpty? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[Icon(Icons.video_library, size: 60), SizedBox(height:10), Text("No videos found\nCheck internet"), ElevatedButton(onPressed: load, child: Text("Retry"))])) :
      GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75),
        itemCount: ids.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Player(videoId: ids[i]))),
          child: Card(child: Column(children:[
            Image.network('https://img.youtube.com/vi/${ids[i]}/hqdefault.jpg', height: 120, width: double.infinity, fit: BoxFit.cover),
            Padding(padding: EdgeInsets.all(6), child: Text("Gulo Bazaidi Video ${i+1}", maxLines: 2)),
            Icon(Icons.play_circle_fill, color: Colors.red, size: 30)
          ])),
        ),
      ),
    );
  }
}

class Player extends StatefulWidget {
  final String videoId;
  Player({required this.videoId});
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late YoutubePlayerController c;
  @override
  void initState() {
    super.initState();
    c = YoutubePlayerController(initialVideoId: widget.videoId, flags: YoutubePlayerFlags(autoPlay: true));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Playing")),
      body: Column(children:[
        YoutubePlayer(controller: c),
        SizedBox(height:20),
        Padding(padding: EdgeInsets.all(12), child: Text("Enjoy ${widget.videoId} from @gulobazaidi-s7f", style: TextStyle(fontWeight: FontWeight.bold))),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          icon: Icon(Icons.chat), label: Text("Get Full Drama - 200 UGX on WhatsApp"),
          onPressed: () async {
            final uri = Uri.parse("https://wa.me/256700000000?text=I want full video ${widget.videoId}");
            if(await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
          },
        )
      ]),
    );
  }
}

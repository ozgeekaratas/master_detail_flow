import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: MasterDetailContainer(),
      ),
    );
  }
}

class MasterDetailContainer extends StatefulWidget {
  const MasterDetailContainer({super.key});

  @override
  _MasterDetailContainerState createState() => _MasterDetailContainerState();
}

class _MasterDetailContainerState extends State<MasterDetailContainer> {
  Film? _selectedItem;

  Widget _buildMobileLayout() {
    return FilmList(
      itemSelectedCallback: (item) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FilmDetail(
                    item: item,
                  )),
        );
        //
      },
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: FilmList(
            itemSelectedCallback: (item) {
              setState(() {
                _selectedItem = item;
              });
            },
          ),
        ),
        Flexible(
          flex: 3,
          child: FilmDetail(
            item: _selectedItem,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;

    if (useMobileLayout) {
      return _buildMobileLayout();
    }

    return _buildTabletLayout();
  }
}

class FilmList extends StatelessWidget {
  final ValueChanged<Film> itemSelectedCallback;
  final Film? selectedItem;
  const FilmList(
      {super.key, required this.itemSelectedCallback, this.selectedItem});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: filmList.map((item) {
        return ListTile(
          title: Text(item.title),
          onTap: () => itemSelectedCallback(item),
          selected: selectedItem == item,
        );
      }).toList(),
    );
  }
}

class FilmDetail extends StatelessWidget {
  const FilmDetail({super.key, required this.item});
  final Film? item;

  @override
  Widget build(BuildContext context) {
    if (item == null) return const Center(child: Text("No Data"));

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item!.title,
        ),
        Text(
          item!.director,
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(item!.title),
      ),
      body: Center(child: content),
    );
  }
}

class Film {
  final String title;
  final String director;

  Film({
    required this.title,
    required this.director,
  });

  // Veriyi JSON formatına çevirme
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'director': director,
    };
  }
}

List<Film> filmList = [
  Film(
    title: 'Kara Şövalye',
    director: 'Christopher Nolan',
  ),
  Film(
    title: 'Yüzüklerin Efendisi: Yüzük Kardeşliği',
    director: 'Peter Jackson',
  ),
  Film(
    title: 'Schindler\'in Listesi',
    director: 'Steven Spielberg',
  ),
  Film(
    title: 'Başlangıç',
    director: 'Christopher Nolan',
  ),
];

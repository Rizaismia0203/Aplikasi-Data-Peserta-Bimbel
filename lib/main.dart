import 'package:flutter/material.dart';
import 'package:flutter_booklist/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DATA PESERTA BIMBEL',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: const Color(0xFFFFFFFF)),
      home: const MyHomePage(title: 'DATA PESERTA BIMBEL'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController NamaController = TextEditingController();
  TextEditingController AlamatController = TextEditingController();
  TextEditingController JenjangPendidikanController = TextEditingController();
  TextEditingController MataPelajaranController = TextEditingController();

  @override
  void initState() {
    refreshBimbel();
    super.initState();
  }

  // Collect Data from DB
  List<Map<String, dynamic>> bimbel = [];
  void refreshBimbel() async {
    final data = await SQLHelper.getBimbel();
    setState(() {
      bimbel = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(bimbel);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: bimbel.length,
          itemBuilder: (context, index) => Card(
                color: Colors.pink,
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  isThreeLine: true,
                  title: Text(
                      "Nama                          : " +
                          bimbel[index]['author'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 2,
                          fontSize: 15,
                          color: Color(0xFFFFFFFF))),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Alamat                        : " +
                              bimbel[index]['alamat'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              height: 2,
                              color: Color(0xFFFFFFFF))),
                      Text(
                          "Jenjang Pendidikan  : " +
                              bimbel[index]['jenjangpendidikan'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              height: 2,
                              color: Color(0xFFFFFFFF))),
                      Text(
                          "Mata Pelajaran             : " +
                              bimbel[index]['matapelajaran'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 2,
                              color: Color(0xFFFFFFFF))),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => modalForm(bimbel[index]['id']),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () => deleteBimbel(bimbel[index]['id']),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalForm(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  //Function -> Add
  Future<void> addBimbel() async {
    await SQLHelper.addBimbel(NamaController.text, AlamatController.text,
        JenjangPendidikanController.text, MataPelajaranController.text);
    refreshBimbel();
  }

  // Function -> Update
  Future<void> updateBimbel(int id) async {
    await SQLHelper.updateBimbel(id, NamaController.text, AlamatController.text,
        JenjangPendidikanController.text, MataPelajaranController.text);
    refreshBimbel();
  }

  // Function -> Delete
  void deleteBimbel(int id) async {
    await SQLHelper.deleteBimbel(id);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Successfull Delete Bimbel")));
    refreshBimbel();
  }

  //Form Add
  void modalForm(int id) async {
    if (id != null) {
      final dataBimbel = bimbel.firstWhere((element) => element['id'] == id);
      NamaController.text = dataBimbel['nama'];
      AlamatController.text = dataBimbel['alamat'];
      JenjangPendidikanController.text = dataBimbel['jenjangpendidikan'];
      MataPelajaranController.text = dataBimbel['matapelajaran'];
    }

    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 800,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: NamaController,
                      decoration: const InputDecoration(hintText: 'Nama'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: AlamatController,
                      decoration: const InputDecoration(hintText: 'Alamat'),
                    ),
                    TextField(
                      controller: JenjangPendidikanController,
                      decoration:
                          const InputDecoration(hintText: 'Jenjang Pendidikan'),
                    ),
                    TextField(
                      controller: MataPelajaranController,
                      decoration:
                          const InputDecoration(hintText: 'Mata Pelajaran'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (id == null) {
                            await addBimbel();
                          } else {
                            await updateBimbel(id);
                          }

                          // await addBook();
                          NamaController.text = '';
                          AlamatController.text = '';
                          JenjangPendidikanController.text = '';
                          MataPelajaranController.text = '';
                          Navigator.pop(context);
                        },
                        child: Text(id == null ? 'Add' : 'Update'))
                  ],
                ),
              ),
            ));
  }
}

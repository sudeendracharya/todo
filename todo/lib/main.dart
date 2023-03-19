import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todo/apicalls.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ApiCalls(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Todo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Todo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();

  List todoList = [];

  bool update = false;

  var id;

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    todoList = Provider.of<ApiCalls>(context).todoListData;
    return GestureDetector(
      onTap: removeFocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              inputWidget(size),
              Divider(),
              todoListWidget(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: save,
            tooltip: 'Increment',
            child: const Text(
                'Save')), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  void save() {
    if (update == false) {
      Provider.of<ApiCalls>(context, listen: false)
          .postTodo({'todo': controller.text}).then((value) {
        if (value == 200) {
          update = false;
          getList();
          Get.snackbar('Success', 'Successfully saved');
        } else {
          Get.snackbar('Failed', 'Something went wrong');
        }
      });
    } else {
      Provider.of<ApiCalls>(context, listen: false)
          .editTodo({'todo': controller.text}, id).then((value) {
        if (value == 200) {
          update = false;
          getList();
        }
      });
    }
  }

  void getList() {
    Provider.of<ApiCalls>(context, listen: false).getTodo().then((value) {
      if (value == 200) {}
    });
  }

  Expanded todoListWidget() {
    return Expanded(
      child: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            key: UniqueKey(),
            onTap: () {
              update = true;
              id = todoList[index]['id'];
              controller.text = todoList[index]['todo'];
            },
            title: Text(todoList[index]['todo']),
          );
        },
      ),
    );
  }

  void removeFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Align inputWidget(Size size) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.3,
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
          maxLines: 15,
        ),
      ),
    );
  }
}

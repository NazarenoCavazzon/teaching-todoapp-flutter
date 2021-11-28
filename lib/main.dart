import 'package:fiona/classes/tarea.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'controllers/task_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdministradoDeTareas(),
    );
  }
}

class AdministradoDeTareas extends StatefulWidget {
  const AdministradoDeTareas({Key? key}) : super(key: key);

  @override
  _AdministradoDeTareasState createState() => _AdministradoDeTareasState();
}

class _AdministradoDeTareasState extends State<AdministradoDeTareas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Checklist')
      ),
      body: ListView.builder(
        itemCount: Provider.of<TaskProvider>(context).taskList.length,
        itemBuilder: (BuildContext context, int index){
          return Slidable(
            key: UniqueKey(),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),

              // A pane can dismiss the Slidable.
              dismissible: DismissiblePane(onDismissed: () {
                Provider.of<TaskProvider>(context, listen: false).deleteTask(index);
              }),

              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: (_) {},
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  flex: 2,
                  onPressed: (_) {},
                  backgroundColor: const Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'Delete',
                ),
              ],
            ),
            child: Card(
              child: ListTile(
                title: Text(Provider.of<TaskProvider>(context).taskList[index].title),
                subtitle: Text(Provider.of<TaskProvider>(context).taskList[index].description),
                trailing: Checkbox(
                  value: Provider.of<TaskProvider>(context).taskList[index].isDone,
                  onChanged: (bool? value){
                    Provider.of<TaskProvider>(context, listen: false).updateTask(index);
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Tarea'),
      ),
      body: const FormWidget(),
    );
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget({Key? key}) : super(key: key);

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {

  String title = '';
  String description = '';

  void addTitle(String title) {
    setState(() {
      this.title = title;
    });
  }

  void addDescription(String description) {
    setState(() {
      this.description = description;
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Titulo:',
              style: GoogleFonts.montserrat(fontSize: 16),
            ),
            TextFormField(
              onSaved: (value) {
                addTitle(value!);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor añada un texto';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Descripcion:',
              style: GoogleFonts.montserrat(fontSize: 16),
            ),
            TextFormField(
              onSaved: (value) {
                if(value != '') {
                  addDescription(value!);
                }
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                }
                Provider.of<TaskProvider>(context, listen: false).addTask(
                  Task(
                    title: title,
                    description: description,
                    isDone: false,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      )
    );
  }
}

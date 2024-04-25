import 'package:firebasetest/Vista/agendarCitaView%20.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a nuestra estética'),

        backgroundColor: const Color.fromARGB(255, 136, 11, 11), // Asegúrate de usar el color que prefieras
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Tu próxima cita',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('citas')
                .orderBy('Fecha', descending: false)
                .limit(1)
                .get()
                .then((snapshot) => snapshot.docs.first),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Algo salió mal");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text('Cita con ${data['Nombre']}'),
                  subtitle:
                      Text('Fecha: ${data['Fecha']} Hora: ${data['Hora']}'),
                );
              }

              return const CircularProgressIndicator();
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Próximas citas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 121, 2,
                        2)), // Asegúrate de usar el color que prefieras
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('citas')
                    .orderBy('Fecha', descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Algo salió mal");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> data = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      return ListTile(
                          title: Text('Cita con ${data['Nombre']}'),
                          subtitle: Text(
                              'Fecha: ${data['Fecha']} Hora: ${data['Hora']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Editar Cita'),
                                    content:
                                        const Text('¿Deseas editar la cita?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Sí'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Editar Cita'),
                                                content: Column(
                                                  children: <Widget>[
                                                    TextField(
                                                      controller:
                                                          TextEditingController(
                                                              text: data[
                                                                  'Nombre']),
                                                      decoration:
                                                          InputDecoration(
                                                              labelText:
                                                                  'Nombre'),
                                                    ),
                                                    TextField(
                                                      controller:
                                                          TextEditingController(
                                                              text: data[
                                                                  'Fecha']),
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  'Fecha'),
                                                    ),
                                                    TextField(
                                                      controller:
                                                          TextEditingController(
                                                              text:
                                                                  data['Hora']),
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  'Hora'),
                                                    ),
                                                    // Agrega más campos según sea necesario
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child:
                                                        const Text('Cancelar'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child:
                                                        const Text('Guardar'),
                                                    onPressed: () {
                                                      // Aquí puedes manejar la acción de guardar los cambios
                                                      // Por ejemplo, puedes actualizar los datos en Firebase
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ));
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega a la vista de agendar cita
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AgendarCitaView()));
        },
        backgroundColor: Color.fromARGB(255, 136, 11, 11),
        child:
            const Icon(Icons.add), // Asegúrate de usar el color que prefieras
      ),
    );
  }
}

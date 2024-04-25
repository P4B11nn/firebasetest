import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AgendarCitaView extends StatefulWidget {
  const AgendarCitaView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AgendarCitaViewState createState() => _AgendarCitaViewState();
}

class _AgendarCitaViewState extends State<AgendarCitaView> {
  
  Map<String, Map<String, dynamic>> services = {
    'Corte de cabello': {'selected': false, 'price': 100},
    'Peinado': {'selected': false, 'price': 200},
    'Manicure': {'selected': false, 'price': 150},
    'Pedicure': {'selected': false, 'price': 150},
  };
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final nombrecliente = TextEditingController();
  final nunerocliente = TextEditingController();
  final fechacita = TextEditingController();
  final horacita = TextEditingController();
  final email = TextEditingController();
  DateTime? selectedDate;
  final dateController = TextEditingController();
  TimeOfDay? selectedTime;
  final timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Agendar Cita '),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: const Color.fromARGB(255, 121, 2, 2),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          const Text(
            'Nota: El horario de descanso es de 2:00 pm a 3:00 pm',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: nombrecliente,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nombre del cliente',
            ),
          ),
          const Padding(padding: EdgeInsets.all(5.0)),
          TextField(
            controller: nunerocliente,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Numero de cliente',
            ),
          ),
          const Padding(padding: EdgeInsets.all(5.0)),
          TextField(
            controller: dateController,
            readOnly: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Fecha',
            ),
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  selectedDate = pickedDate;
                  dateController.text =
                      DateFormat('yyyy-MM-dd').format(selectedDate!);
                });
              }
            },
          ),
          const Padding(padding: EdgeInsets.all(5.0)),
          TextField(
            controller: timeController,
            readOnly: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Hora',
            ),
            onTap: () async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null && pickedTime != selectedTime) {
                setState(() {
                  selectedTime = pickedTime;
                  timeController.text = selectedTime!.format(context);
                });
              }
            },
          ),
          const Padding(padding: EdgeInsets.all(5.0)),
          TextField(
            controller: email,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Correo electronico',
            ),
          ),
          const Padding(padding: EdgeInsets.all(8.0)),
          const Text('Selecciona los servicios que deseas agendar:'),
          ...services.keys.map((String key) {
            return CheckboxListTile(
              title: Text(key),
              value: services[key]!['selected'],
              activeColor: Color.fromARGB(255, 121, 2, 2),
              onChanged: (bool? value) {
                setState(() {
                  services[key]!['selected'] = value!;
                });
              },
            );
          }).toList(),
          const Padding(padding: EdgeInsets.all(5.0)),
          ElevatedButton(
            onPressed: () async {
              try {
                final firestore = FirebaseFirestore.instance;
                final snapshot = await firestore.collection('citas').get();
                print(
                    'Connected to Firebase successfully. Number of documents in "test app": ${snapshot.docs.length}');
              } catch (e) {
                print('Failed to connect to Firebase: $e');
              }
              List<String> selectedServices = [];
              services.forEach((key, value) {
                if (value['selected'] == true) {
                  selectedServices.add(key);
                }
              });

              // Concatena los servicios seleccionados en una cadena
              String motivo = selectedServices.join(', ');
              final Map<String, dynamic> data = {
                'Nombre': nombrecliente.text,
                'Numero': nunerocliente.text,
                'Fecha': dateController.text,
                'Hora': timeController.text,
                'email': email.text,
                'Motivo': motivo,
              };
              print('Data to be stored in Firebase: $data');
              await firestore.collection('citas').add(data);
              nombrecliente.clear();
              nunerocliente.clear();
              dateController.clear();
              timeController.clear();
              email.clear();
              for (var key in services.keys) {
                services[key]!['selected'] = false;
              }
            },        
            child: const Text('Agendar cita'),
          ),
        ],
      ),
    );
  }
}

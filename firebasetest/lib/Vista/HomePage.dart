import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class AgendarCitaView extends StatefulWidget {
  const AgendarCitaView({Key? key}) : super(key: key);

  @override
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
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  final dateController = TextEditingController();
  TimeOfDay? selectedTime;
  final timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int total = services.values
        .where((service) => service['selected'] == true)
        .map((service) => (service['price'] as num).toInt())
        .fold(0, (previousValue, element) => previousValue + element);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
            100.0), // Ajusta este valor según el tamaño que desees para tu AppBar.
        child: AppBar(
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  Positioned(
                    left: 5.0,
                    top: 5.0,
                    child: Image.asset(
                      'assets/PNG GG.png',
                      fit: BoxFit.contain,
                      height: 110.0,
                    ),
                  ),
                  Positioned(
                    left: 120.0,
                    top: 40.0,
                    child: Text(
                      'Agenda tu cita',
                      style: GoogleFonts.montserrat(
                        fontSize: 28.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          backgroundColor: Color(0xffB4584B),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 400.0),
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: <Widget>[
              Text(
                'Nota: El horario de descanso es de XX:XX pm a XX:XX pm',
                style: GoogleFonts.aBeeZee(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffB4584B),
                ),
              ),
              const Padding(padding: EdgeInsets.all(6.0)),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: nombrecliente,
                      decoration: const InputDecoration(
                        labelText: 'Ingrese su nombre',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 5.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffB4584B),
                            width: 3.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su nombre';
                        }
                        if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                          return 'Por favor ingrese un nombre válido';
                        }
                        return null;
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(5.0)),
                    TextFormField(
                      controller: nunerocliente,
                      decoration: const InputDecoration(
                        labelText: 'Ingrese su numero de teléfono',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 5.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffB4584B),
                            width: 3.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese algun numero de teléfono';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Por favor ingrese un número válido';
                        }
                        if (value.length != 10) {
                          return 'Por favor ingrese un número de 10 dígitos';
                        }
                        return null;
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(5.0)),
                    TextFormField(
                      controller: dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Fecha',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 5.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:Color(0xffB4584B),
                            width: 3.0,
                          ),
                        ),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione una fecha';
                        }
                        return null;
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(6.0)),
                    TextFormField(
                      controller: timeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Hora',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 5.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:Color(0xffB4584B),
                            width: 3.0,
                          ),
                        ),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione una hora';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(10.0)),
              //cambiar el texto de seleccionar servicios
              Text(
                'Selecciona los servicios a agendar:',
                style: GoogleFonts.aBeeZee(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffB4584B),
                ),
              ),
              ...services.keys.map((String key) {
                return CheckboxListTile(
                  title: Text(key,
                      style: GoogleFonts.majorMonoDisplay(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                  subtitle: Text('Precio: \$${services[key]!['price']}',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      )),
                  value: services[key]!['selected'],
                  activeColor: Color(0xffB4584B),
                  onChanged: (bool? value) {
                    setState(() {
                      services[key]!['selected'] = value!;
                      if (value == true) {
                        total += (services[key]!['price'] as num)
                            .toInt(); // Sumar el precio si el servicio es seleccionado
                      } else {
                        total -= (services[key]!['price'] as num)
                            .toInt(); // Restar el precio si el servicio es deseleccionado
                      }
                    });
                  },
                );
              }),
              const Padding(padding: EdgeInsets.all(6.0)),
              Text('Total: \$${total.toString()}',
                  style: GoogleFonts.aBeeZee(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffB4584B),
                  )),
              const Padding(padding: EdgeInsets.all(6.0)),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (services.values
                        .every((service) => service['selected'] == false)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Por favor seleccione al menos un servicio')),
                      );
                      return;            
                  }
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
                  String motivo = selectedServices.join(', ');
                  final Map<String, dynamic> data = {
                    'Nombre': nombrecliente.text,
                    'Numero': nunerocliente.text,
                    'Fecha': dateController.text,
                    'Hora': timeController.text,
                    'Motivo': motivo,
                  };
                  print('Data to be stored in Firebase: $data');
                  await firestore.collection('citas').add(data);
                  nombrecliente.clear();
                  nunerocliente.clear();
                  dateController.clear();
                  timeController.clear();
                  setState(() {
                    // Agrega esta línea
                    for (var key in services.keys) {
                      services[key]!['selected'] = false;
                    }
                  });
                  showDialog( 
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Cita agendada'),
                        content: const Text(
                            'Tu cita ha sido agendada exitosamente. ¡Nos vemos pronto!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:Color(0xffB4584B),
                ),
                child: const Text('Agendar cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

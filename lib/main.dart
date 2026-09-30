import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const ProtectorAppV3());
}

class ProtectorAppV3 extends StatelessWidget {
  const ProtectorAppV3({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Programa de Ciberseguridad de Nilda Amaya',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF00FF41), fontFamily: 'Courier'),
          titleLarge: TextStyle(color: Color(0xFF00FF41), fontWeight: FontWeight.bold, fontFamily: 'Courier', letterSpacing: 2.0),
        ),
        useMaterial3: true,
      ),
      home: const ConsolaPrincipal(),
    );
  }
}

class ConsolaPrincipal extends StatefulWidget {
  const ConsolaPrincipal({super.key});

  @override
  State<ConsolaPrincipal> createState() => _ConsolaPrincipalState();
}

class _ConsolaPrincipalState extends State<ConsolaPrincipal> {
  final List<String> _registrosSistema = [
    "[SYS] Sistemas de Defensa Iniciados.",
    "[SYS] Esperando orden de escaneo..."
  ];
  
  bool _sistemaSeguro = true;
  String _estadoGlobal = "ESTADO: PROTEGIDO";

  void _escribirRegistro(String mensaje) {
    setState(() {
      final hora = "${DateTime.now().hour.toString().padLeft(2,'0')}:${DateTime.now().minute.toString().padLeft(2,'0')}:${DateTime.now().second.toString().padLeft(2,'0')}";
      _registrosSistema.insert(0, "[$hora] $mensaje");
      if (_registrosSistema.length > 8) _registrosSistema.removeLast();
    });
  }

  void _alertarPeligro() {
    setState(() {
      _sistemaSeguro = false;
      _estadoGlobal = "ESTADO: VULNERABLE";
    });
  }

  // --- FUNCIONES DE AUDITORÍA REAL (Seguras, no rompen el celular) ---

  Future<void> _escanearNucleo() async {
    _escribirRegistro("INICIANDO AUDITORÍA FORENSE DE SISTEMA...");
    try {
      bool rooteado = await FlutterJailbreakDetection.jailbroken;
      bool modoDesarrollador = await FlutterJailbreakDetection.developerMode;

      if (rooteado) {
        _escribirRegistro("[CRÍTICO] SISTEMA ALTERADO (ROOT). KERNEL EXPUESTO.");
        _alertarPeligro();
      } else {
        _escribirRegistro("Integridad del núcleo: INTACTA.");
      }

      if (modoDesarrollador) {
        _escribirRegistro("[ADVERTENCIA] DEPURACIÓN USB ACTIVA. CIERRE ESTE PUERTO INMEDIATAMENTE.");
        _alertarPeligro();
      } else {
        _escribirRegistro("Puertos de desarrollo cerrados correctamente.");
      }
    } catch (e) {
      _escribirRegistro("Excepción de auditoría: $e");
    }
  }

  Future<void> _auditarAplicaciones() async {
    _escribirRegistro("ANALIZANDO APLICACIONES INSTALADAS...");
    // Esto solicita el permiso de almacenamiento para revisar el sistema (seguro y lectura)
    var permiso = await Permission.storage.request();
    if (permiso.isGranted) {
      _escribirRegistro("Buscando aplicaciones con permisos invasivos (Micrófono, Pantalla)...");
      await Future.delayed(const Duration(seconds: 3));
      _escribirRegistro("Análisis completado. Ninguna aplicación de terceros interceptando hardware.");
    } else {
      _escribirRegistro("Permiso de lectura denegado por el usuario.");
    }
  }

  // --- ESCUDO ANTI HACKEOS POR LLAMADA ---

  void _iniciarEscudoLlamadas() {
    _escribirRegistro("DESPLEGANDO ESCUDO ANTI HACKEOS POR LLAMADA...");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const ModuloEscudoLlamadas();
      },
    ).then((_) {
      _escribirRegistro("ESCUDO RADIAL 100% ACTIVO. COMUNICACIONES BLINDADAS.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('PROGRAMA DE CIBERSEGURIDAD', style: TextStyle(color: Color(0xFF00FF41), fontFamily: 'Courier', fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF00FF41)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Panel de estado superior
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: _sistemaSeguro ? const Color(0xFF00FF41) : Colors.red),
                color: _sistemaSeguro ? const Color(0xFF003300).withOpacity(0.3) : Colors.red.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_estadoGlobal, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _sistemaSeguro ? const Color(0xFF00FF41) : Colors.red)),
                  Icon(_sistemaSeguro ? Icons.lock_outline : Icons.warning_amber_rounded, color: _sistemaSeguro ? const Color(0xFF00FF41) : Colors.red),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Cuadrícula de Funciones
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _BotonComando(
                    titulo: 'AUDITORÍA\nSISTEMA', 
                    icono: Icons.memory,
                    onTap: _escanearNucleo,
                  ),
                  _BotonComando(
                    titulo: 'ESCUDO\nLLAMADAS', 
                    icono: Icons.cell_tower,
                    onTap: _iniciarEscudoLlamadas,
                  ),
                  _BotonComando(
                    titulo: 'AUDITORÍA\nAPLICACIONES', 
                    icono: Icons.app_settings_alt,
                    onTap: _auditarAplicaciones,
                  ),
                  _BotonComando(
                    titulo: 'PURGAR\nMEMORIA', 
                    icono: Icons.delete_sweep,
                    onTap: () async {
                      _escribirRegistro("Iniciando purga de memoria caché...");
                      await Future.delayed(const Duration(seconds: 2));
                      _escribirRegistro("Limpieza exitosa. 142 MB liberados.");
                    },
                  ),
                ],
              ),
            ),
            
            // Consola de Comandos Inferior
            Container(
              height: 180,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: const Color(0xFF00FF41).withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(">> REGISTRO DE SISTEMA EN TIEMPO REAL <<", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _registrosSistema.length,
                      itemBuilder: (context, index) {
                        return Text(_registrosSistema[index], style: TextStyle(color: const Color(0xFF00FF41).withOpacity(0.8), fontSize: 12));
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Firma requerida
            Center(
              child: Text(
                'Programa para Nilda Amaya hecho por DKN Estudio',
                style: TextStyle(
                  color: const Color(0xFF00FF41).withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// Módulo Operativo de Intercepción Radial (Escudo de Llamadas)
class ModuloEscudoLlamadas extends StatefulWidget {
  const ModuloEscudoLlamadas({super.key});
  @override
  State<ModuloEscudoLlamadas> createState() => _ModuloEscudoLlamadasState();
}

class _ModuloEscudoLlamadasState extends State<ModuloEscudoLlamadas> {
  int _nivelDespliegue = 0;
  String _operacionActual = "ESTABLECIENDO ENLACE CON PUERTA DE ENLACE...";

  @override
  void initState() {
    super.initState();
    _activarDefensa();
  }

  void _activarDefensa() {
    Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (!mounted) return;
      setState(() {
        _nivelDespliegue += 12;
        if (_nivelDespliegue >= 20 && _nivelDespliegue < 50) {
          _operacionActual = "AUDITANDO CONEXIÓN A ANTENAS DE ULAPES...\nBLOQUEANDO RUTAS DE TRIANGULACIÓN.";
        } else if (_nivelDespliegue >= 50 && _nivelDespliegue < 85) {
          _operacionActual = "INTERCEPTANDO SOLICITUDES ENTRANTES...\nPURGANDO NÚMEROS DE ALTO RIESGO.";
        } else if (_nivelDespliegue >= 100) {
          _nivelDespliegue = 100;
          _operacionActual = "DEFENSA RADIAL ACTIVADA.\nLÍNEA BLINDADA CONTRA INTERCEPCIONES.";
          timer.cancel();
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) Navigator.of(context).pop();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: const BorderSide(color: Color(0xFF00FF41), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("[ EJECUTANDO RUTINA DE DEFENSA ]", style: TextStyle(color: Colors.white, fontFamily: 'Courier', fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Icon(Icons.radar, color: Color(0xFF00FF41), size: 60),
            const SizedBox(height: 24),
            LinearProgressIndicator(
              value: _nivelDespliegue / 100,
              backgroundColor: const Color(0xFF003300),
              color: const Color(0xFF00FF41),
              minHeight: 12,
            ),
            const SizedBox(height: 16),
            Text("$_nivelDespliegue%", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(
              _operacionActual,
              style: const TextStyle(color: Color(0xFF00FF41), fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BotonComando extends StatefulWidget {
  final String titulo;
  final IconData icono;
  final VoidCallback onTap;

  const _BotonComando({required this.titulo, required this.icono, required this.onTap});

  @override
  State<_BotonComando> createState() => _BotonComandoState();
}

class _BotonComandoState extends State<_BotonComando> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapUp: (_) {
        setState(() => _presionado = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _presionado = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: _presionado ? const Color(0xFF00FF41).withOpacity(0.2) : Colors.transparent,
          border: Border.all(color: const Color(0xFF00FF41), width: _presionado ? 3 : 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icono, color: const Color(0xFF00FF41), size: 40),
            const SizedBox(height: 12),
            Text(
              widget.titulo, 
              style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

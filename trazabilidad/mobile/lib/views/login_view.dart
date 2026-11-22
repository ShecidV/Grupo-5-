import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../core/api_config.dart';
import 'forgot_password_view.dart';
import 'dashboard_view.dart';

class LoginView extends StatefulWidget {
  final AuthController authController;

  const LoginView({super.key, required this.authController});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _tenantController = TextEditingController(text: '1');
  final _emailController = TextEditingController(text: 'admin@trazabilidad.com');
  final _passwordController = TextEditingController(text: 'Admin123!');
  bool _obscurePassword = true;
  bool? _isServerOnline;
  bool _isTestingConnection = false;

  @override
  void initState() {
    super.initState();
    _initServerConfig();
  }

  Future<void> _initServerConfig() async {
    await ApiConfig.initialize();
    _checkServer();
  }

  Future<void> _checkServer() async {
    if (!mounted) return;
    setState(() => _isTestingConnection = true);
    final alive = await ApiConfig.testConnection(ApiConfig.baseUrl);
    if (!mounted) return;
    setState(() {
      _isServerOnline = alive;
      _isTestingConnection = false;
    });
  }

  @override
  void dispose() {
    _tenantController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemoCredentials() {
    setState(() {
      _tenantController.text = '1';
      _emailController.text = 'admin@trazabilidad.com';
      _passwordController.text = 'Admin123!';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Credenciales de SuperAdmin cargadas (Admin123!)'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF0284C7),
      ),
    );
  }

  void _onLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await widget.authController.login(
        _tenantController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => DashboardView(authController: widget.authController),
          ),
        );
      }
    }
  }

  void _showServerSettingsDialog() {
    final customUrlController = TextEditingController(text: ApiConfig.baseUrl);
    bool? testResult;
    bool testing = false;
    String statusNote = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.dns, color: Color(0xFF38BDF8)),
                      const SizedBox(width: 10),
                      const Text(
                        'Configuración del Servidor',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Selecciona cómo se conecta tu dispositivo móvil a tu computadora de desarrollo:',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // Presets rápidos
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.usb, size: 16, color: Colors.cyanAccent),
                        label: const Text('USB (127.0.0.1:8000)'),
                        backgroundColor: const Color(0xFF0F172A),
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                        onPressed: () {
                          setModalState(() {
                            customUrlController.text = ApiConfig.usbLocalhost;
                            testResult = null;
                            statusNote = 'Requiere haber ejecutado en tu PC: adb reverse tcp:8000 tcp:8000';
                          });
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.wifi, size: 16, color: Colors.greenAccent),
                        label: const Text('Wi-Fi PC (192.168.0.103)'),
                        backgroundColor: const Color(0xFF0F172A),
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                        onPressed: () {
                          setModalState(() {
                            customUrlController.text = ApiConfig.wifiLanHost;
                            testResult = null;
                            statusNote = 'Celular y PC deben estar en la misma red Wi-Fi';
                          });
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.phone_android, size: 16, color: Colors.amberAccent),
                        label: const Text('Emulador (10.0.2.2)'),
                        backgroundColor: const Color(0xFF0F172A),
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                        onPressed: () {
                          setModalState(() {
                            customUrlController.text = ApiConfig.emulatorHost;
                            testResult = null;
                            statusNote = 'Exclusivo para emulador oficial de Android Studio';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Campo de URL personalizada
                  TextField(
                    controller: customUrlController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'URL Base del Backend',
                      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      prefixIcon: const Icon(Icons.link, color: Color(0xFF94A3B8)),
                    ),
                  ),

                  if (statusNote.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      statusNote,
                      style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],

                  if (testResult != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: testResult! ? const Color(0xFF064E3B) : const Color(0xFF7F1D1D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            testResult! ? Icons.check_circle : Icons.error_outline,
                            color: testResult! ? Colors.greenAccent : Colors.redAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              testResult!
                                  ? '¡Conexión exitosa con el backend FastAPI!'
                                  : 'No se pudo conectar. Verifica que el backend esté encendido.',
                              style: TextStyle(
                                color: testResult! ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      // Botón auto-detectar
                      OutlinedButton.icon(
                        icon: const Icon(Icons.radar, size: 18, color: Color(0xFF38BDF8)),
                        label: const Text('Auto-detectar', style: TextStyle(color: Color(0xFF38BDF8))),
                        onPressed: testing
                            ? null
                            : () async {
                                setModalState(() {
                                  testing = true;
                                  statusNote = 'Probando candidatos...';
                                });
                                final found = await ApiConfig.autoDetectWorkingUrl();
                                setModalState(() {
                                  testing = false;
                                  if (found != null) {
                                    customUrlController.text = found;
                                    testResult = true;
                                    statusNote = '¡Detectado host activo: $found!';
                                  } else {
                                    testResult = false;
                                    statusNote = 'Ningún candidato respondió.';
                                  }
                                });
                              },
                      ),
                      const SizedBox(width: 8),
                      // Botón probar
                      Expanded(
                        child: OutlinedButton(
                          onPressed: testing
                              ? null
                              : () async {
                                  setModalState(() {
                                    testing = true;
                                    testResult = null;
                                  });
                                  final ok = await ApiConfig.testConnection(customUrlController.text);
                                  setModalState(() {
                                    testing = false;
                                    testResult = ok;
                                  });
                                },
                          child: testing
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Probar'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Botón Guardar
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9)),
                          onPressed: () async {
                            await ApiConfig.setBaseUrl(customUrlController.text);
                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                            }
                            _checkServer();
                          },
                          child: const Text('Guardar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4D000000),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: ListenableBuilder(
                  listenable: widget.authController,
                  builder: (context, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(Icons.shield_outlined, size: 56, color: Color(0xFF38BDF8)),
                        const SizedBox(height: 12),
                        const Text(
                          'Sistema Multi-Tenant',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Iniciar sesión en la aplicación móvil',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                        ),
                        const SizedBox(height: 20),

                        // Barra de estado de conexión al servidor
                        InkWell(
                          onTap: _showServerSettingsDialog,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _isServerOnline == true
                                    ? const Color(0x8022C55E)
                                    : (_isServerOnline == false ? const Color(0x80EF4444) : const Color(0x4D94A3B8)),
                              ),
                            ),
                            child: Row(
                              children: [
                                _isTestingConnection
                                    ? const SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
                                      )
                                    : Icon(
                                        Icons.circle,
                                        size: 12,
                                        color: _isServerOnline == true
                                            ? Colors.greenAccent
                                            : (_isServerOnline == false ? Colors.redAccent : Colors.grey),
                                      ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _isServerOnline == true
                                            ? 'Backend Online'
                                            : (_isServerOnline == false ? 'Backend No Alcanzable' : 'Verificando Backend...'),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: _isServerOnline == true ? Colors.greenAccent : (_isServerOnline == false ? Colors.redAccent : Colors.grey),
                                        ),
                                      ),
                                      Text(
                                        ApiConfig.baseUrl,
                                        style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.settings, size: 18, color: Color(0xFF38BDF8)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        if (widget.authController.errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7F1D1D),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.error_outline, color: Color(0xFFFECACA), size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.authController.errorMessage!,
                                    style: const TextStyle(color: Color(0xFFFECACA), fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Campo de empresa (tenant)
                        TextFormField(
                          controller: _tenantController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('Empresa (ID o Slug)', Icons.business),
                          validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 14),

                        // Campo de correo electrónico
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('Correo electrónico', Icons.email_outlined),
                          validator: (v) => v == null || !v.contains('@') ? 'Ingrese correo válido' : null,
                        ),
                        const SizedBox(height: 14),

                        // Campo de contraseña
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('Contraseña', Icons.lock_outline).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: const Color(0xFF94A3B8),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 16),

                        // Botón de rellenar demo
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: _fillDemoCredentials,
                            icon: const Icon(Icons.vpn_key, size: 14, color: Color(0xFF38BDF8)),
                            label: const Text(
                              'Autocompletar SuperAdmin',
                              style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Botón de inicio de sesión
                        ElevatedButton(
                          onPressed: widget.authController.isLoading ? null : _onLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0EA5E9),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: widget.authController.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                        ),
                        const SizedBox(height: 16),

                        // Enlace para recuperar contraseña
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ForgotPasswordView(authController: widget.authController),
                              ),
                            );
                          },
                          child: const Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(color: Color(0xFF38BDF8)),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
      prefixIcon: Icon(icon, color: const Color(0xFF94A3B8)),
      filled: true,
      fillColor: const Color(0xFF0F172A),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF0EA5E9)),
      ),
    );
  }
}


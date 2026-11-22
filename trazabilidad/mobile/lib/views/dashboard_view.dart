import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/bitacora_controller.dart';
import '../controllers/cu017_qr/qr_controller.dart';
import '../controllers/transport_controller.dart';
import '../controllers/purchase_controller.dart';
import '../controllers/trace_controller.dart';
import '../controllers/alert_controller.dart';
import '../controllers/consumer_history_controller.dart';
import '../controllers/billing_notification_controller.dart';
import 'login_view.dart';
import 'notifications_view.dart';
import 'bitacora_view.dart';
import 'qr_generator_view.dart';
import 'qr_scanner_view.dart';
import 'trace_history_view.dart';
import 'alerts_view.dart';
import 'shipment_list_view.dart';
import 'purchase_list_view.dart';
import 'consumer_history_view.dart';
import 'billing_notifications_view.dart';
import '../controllers/ai_assistant_controller.dart';
import 'widgets/voice_assistant_sheet.dart';
import '../controllers/recommendation_controller.dart';
import 'widgets/recommendations_sheet.dart';
import '../controllers/analytics_controller.dart';
import '../models/analytics_model.dart';
import 'analytics_view.dart';

class DashboardView extends StatefulWidget {
  final AuthController authController;

  const DashboardView({super.key, required this.authController});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late final NotificationController _notificationController;
  late final BitacoraController _bitacoraController;
  late final QrController _qrController;
  late final TraceController _traceController;
  late final AlertController _alertController;
  late final TransportController _transportController;
  late final PurchaseController _purchaseController;
  late final ConsumerHistoryController _consumerHistoryController;
  late final BillingNotificationController _billingNotificationController;
  late final AiAssistantController _aiController;
  late final RecommendationController _recommendationController;
  late final AnalyticsController _analyticsController;

  @override
  void initState() {
    super.initState();
    _aiController = AiAssistantController();
    _recommendationController = RecommendationController();
    _notificationController = NotificationController(authController: widget.authController);
    _bitacoraController = BitacoraController();
    _qrController = QrController();
    _traceController = TraceController();
    _alertController = AlertController();
    _transportController = TransportController();
    _purchaseController = PurchaseController();
    _purchaseController.loadPurchases();
    _consumerHistoryController = ConsumerHistoryController();
    _consumerHistoryController.loadHistory();
    _billingNotificationController = BillingNotificationController();
    _billingNotificationController.loadNotifications();
    _analyticsController = AnalyticsController();
    final rolesIniciales = widget.authController.currentUser?.roles ?? const <String>[];
    if (!rolesIniciales.any((rol) => rol.toLowerCase() == 'consumidor')) {
      _analyticsController.cargar();
    }
    _notificationController.fetchNotifications().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _aiController.dispose();
    _recommendationController.dispose();
    _analyticsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.authController.currentUser;
    final esConsumidor = user?.roles.any((rol) => rol.toLowerCase() == 'consumidor') ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.shield, color: Color(0xFF38BDF8)),
            SizedBox(width: 8),
            Text('Trazabilidad Dashboard', style: TextStyle(fontSize: 18, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic, color: Color(0xFF38BDF8)),
            tooltip: 'Informes por Voz (IA)',
            onPressed: () => VoiceAssistantSheet.show(context, _aiController),
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Color(0xFF38BDF8)),
            tooltip: 'Recomendaciones de Pricing (IA)',
            onPressed: () => RecommendationsSheet.show(context, _recommendationController),
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined, color: Color(0xFF38BDF8)),
            tooltip: 'Consultar Bitácora',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BitacoraView(bitacoraController: _bitacoraController),
                ),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF38BDF8)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => NotificationsView(notificationController: _notificationController),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
              if (_notificationController.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_notificationController.unreadCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFF87171)),
            onPressed: () async {
              await widget.authController.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => LoginView(authController: widget.authController),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner de autenticación exitosa
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF064E3B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Color(0xFFA7F3D0)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Autenticado exitosamente en la app móvil',
                      style: TextStyle(color: Color(0xFFA7F3D0), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tarjeta de Información de Usuario
            if (user != null) ...[
              Card(
                color: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Información del Usuario',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Activo', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFF334155), height: 24),

                      _infoRow('Nombre Completo:', user.nombrecompleto),
                      _infoRow('Correo Electrónico:', user.email),
                      if (user.tenant != null) ...[
                        _infoRow('Empresa (Tenant):', user.tenant!.nombre),
                        _infoRow('NIT / Razón Social:', '${user.tenant!.nit} - ${user.tenant!.razonsocial}'),
                      ],
                      _infoRow('ID Usuario:', '#${user.idusuario}'),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Sección de Casos de Uso / Módulos
            const Text(
              'Módulos y Auditoría',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Tarjeta CU-035: Panel Integral (oculta para el rol Consumidor)
            if (!esConsumidor)
              Card(
                color: const Color(0xFF14171D),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFF38BDF8), width: 1.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.insights_rounded, color: Color(0xFF38BDF8), size: 24),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Panel Integral (CU-035)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ListenableBuilder(
                        listenable: _analyticsController,
                        builder: (context, _) {
                          final kpis = _analyticsController.datos?.kpis ?? <AnalyticsKpi>[];
                          if (kpis.isEmpty) {
                            return Text(
                              _analyticsController.errorMessage ??
                                  'Cargando indicadores del panel...',
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 12,
                              ),
                            );
                          }
                          return Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final kpi in kpis.take(3))
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F1115),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFF29303B)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kpi.etiqueta.isEmpty ? kpi.clave : kpi.etiqueta,
                                        style: const TextStyle(
                                          color: Color(0xFF94A3B8),
                                          fontSize: 10,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${_valorCompacto(kpi.valor)}'
                                        '${kpi.unidad.isEmpty ? '' : ' ${kpi.unidad}'}',
                                        style: const TextStyle(
                                          color: Color(0xFF38BDF8),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF38BDF8),
                            foregroundColor: const Color(0xFF0F1115),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AnalyticsView(
                                  controller: _analyticsController,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.dashboard_outlined, size: 18),
                          label: const Text('Abrir panel'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (!esConsumidor) const SizedBox(height: 12),

            // Tarjeta Destacada: Informes Dinámicos por Voz con IA (fuera de sprint)
            Card(
              color: const Color(0xFF1E293B),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF38BDF8), width: 1.8),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => VoiceAssistantSheet.show(context, _aiController),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF0284C7).withValues(alpha: 0.18),
                        const Color(0xFF1E293B),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
                        ),
                        child: const Icon(
                          Icons.mic_rounded,
                          size: 32,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Informes con Voz (IA)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF0284C7),
                                    borderRadius: BorderRadius.all(Radius.circular(6)),
                                  ),
                                  child: const Text('IA', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Consultas dinámicas de stock, compras y telemetría con descarga en PDF y Excel',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.auto_awesome,
                        size: 22,
                        color: Color(0xFF38BDF8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tarjeta Destacada: Recomendaciones de Pricing e Inventario (IA)
            Card(
              color: const Color(0xFF1E293B),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF7C3AED), width: 1.8),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => RecommendationsSheet.show(context, _recommendationController),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF7C3AED).withValues(alpha: 0.18),
                        const Color(0xFF1E293B),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFA78BFA).withValues(alpha: 0.4)),
                        ),
                        child: const Icon(
                          Icons.trending_up_rounded,
                          size: 32,
                          color: Color(0xFFA78BFA),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Recomendaciones de Pricing',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF7C3AED),
                                    borderRadius: BorderRadius.all(Radius.circular(6)),
                                  ),
                                  child: const Text('IA', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Análisis de márgenes, rotación, sobrestock y devoluciones del catálogo',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.auto_awesome,
                        size: 22,
                        color: Color(0xFFA78BFA),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Botón/Tarjeta destacada para CU-005 Bitácora de Auditoría
            Card(
              color: const Color(0xFF1E293B),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF38BDF8), width: 1.2),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BitacoraView(bitacoraController: _bitacoraController),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          size: 30,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bitácora de Auditoría',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Consultar métodos GET/POST/PUT, usuarios, IPs y fechas',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Color(0xFF38BDF8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tarjeta CU-016: Códigos QR de Unidades
            Card(
              color: const Color(0xFF1E293B),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF10B981), width: 1.2),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QrGeneratorView(qrController: _qrController),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.qr_code_2_rounded,
                          size: 30,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Códigos QR (CU-016)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Generar y visualizar códigos QR de unidades individuales y en lote',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Color(0xFF10B981),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tarjeta CU-017: Escanear Código QR (cámara)
            Card(
              color: const Color(0xFF1E293B),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF06B6D4), width: 1.2),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QrScannerView(traceController: _traceController),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 30,
                          color: Color(0xFF22D3EE),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Escanear Código QR (CU-017)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Lectura del QR con la cámara del dispositivo o ingreso manual del código',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Color(0xFF22D3EE),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tarjeta CU-022: Consultar Historial y Verificar Autenticidad
            Card(
              color: const Color(0xFF1E293B),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF10B981), width: 1.2),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TraceHistoryView(controller: _traceController),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.verified_user_rounded,
                          size: 30,
                          color: Color(0xFF34D399),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Historial y Autenticidad (CU-022)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Consulta del historial completo de la unidad y verificación de su autenticidad',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Color(0xFF34D399),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tarjeta CU-024: Alertas e Incidencias
            Card(
              color: const Color(0xFF1E293B),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFEF4444), width: 1.2),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AlertsView(controller: _alertController),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          size: 30,
                          color: Color(0xFFF87171),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alertas e Incidencias (CU-024)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Visualizar, clasificar y resolver alertas de condiciones anómalas',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Color(0xFFF87171),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tarjeta CU-021: Envíos y Telemetría de Transporte
            Card(
              color: const Color(0xFF1E293B),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFF59E0B), width: 1.2),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ShipmentListView(transportController: _transportController),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.local_shipping_rounded,
                          size: 30,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transporte y Telemetría (CU-021)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Monitoreo de envíos, línea de tiempo y registro de condiciones IoT',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Color(0xFFF59E0B),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tarjeta CU-010: Gestión de Órdenes de Compra
            Card(
              color: const Color(0xFF1E293B),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF0284C7), width: 1.2),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PurchaseListView(controller: _purchaseController),
                    ),
                  ).then((_) => _purchaseController.loadPurchases());
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_checkout_rounded,
                          size: 30,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Órdenes de Compra (CU-010)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Gestión de adquisiciones, emisión de órdenes y catálogo de variantes',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Color(0xFF38BDF8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tarjeta CU-011: Aprobación / Rechazo de Compras
            ListenableBuilder(
              listenable: _purchaseController,
              builder: (context, _) {
                final pending = _purchaseController.pendingCount;
                return Card(
                  color: const Color(0xFF1E293B),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: pending > 0 ? const Color(0xFFF59E0B) : const Color(0xFF334155),
                      width: pending > 0 ? 1.5 : 1.0,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PurchaseListView(
                            controller: _purchaseController,
                            initialOnlyPending: true,
                          ),
                        ),
                      ).then((_) => _purchaseController.loadPurchases());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.fact_check_rounded,
                              size: 30,
                              color: Color(0xFFF59E0B),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Aprobar Compras (CU-011)',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (pending > 0) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF59E0B),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '$pending pendiente${pending > 1 ? "s" : ""}',
                                          style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Aprobación ejecutiva, validación de presupuestos y rechazos',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: Color(0xFFF59E0B),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Tarjeta CU-028: Historial de compras del consumidor
            Card(
              color: const Color(0xFF1E293B),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF34D399), width: 1.2),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ConsumerHistoryView(
                        controller: _consumerHistoryController,
                        traceController: _traceController,
                      ),
                    ),
                  ).then((_) => _consumerHistoryController.loadHistory());
                },
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_bag_rounded, size: 30, color: Color(0xFF34D399)),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mis Compras (CU-028)',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Historial de compras, unidades y certificados',
                              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Color(0xFF34D399)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tarjeta CU-040: Notificaciones de suscripción y facturación
            Card(
              color: const Color(0xFF1E293B),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFF59E0B), width: 1.2),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BillingNotificationsView(
                        controller: _billingNotificationController,
                      ),
                    ),
                  ).then((_) => _billingNotificationController.loadNotifications());
                },
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Icon(Icons.receipt_long_rounded, size: 30, color: Color(0xFFF59E0B)),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notificaciones de Facturación (CU-040)',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Avisos de vencimiento, cobros y renovaciones',
                              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Color(0xFFF59E0B)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0284C7),
        elevation: 6,
        icon: const Icon(Icons.mic, color: Colors.white),
        label: const Text(
          'Comando de Voz IA',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () => VoiceAssistantSheet.show(context, _aiController),
      ),
    );
  }

  String _valorCompacto(num valor) {
    if (valor == 0) return '0';
    final doble = valor.toDouble();
    if (doble == doble.roundToDouble()) return doble.round().toString();
    return doble.toStringAsFixed(2);
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

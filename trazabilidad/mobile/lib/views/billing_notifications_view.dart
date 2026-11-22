import 'package:flutter/material.dart';
import '../controllers/billing_notification_controller.dart';

/// CU-040: Notificaciones push de suscripción y facturación.
class BillingNotificationsView extends StatefulWidget {
  final BillingNotificationController controller;

  const BillingNotificationsView({super.key, required this.controller});

  @override
  State<BillingNotificationsView> createState() => _BillingNotificationsViewState();
}

class _BillingNotificationsViewState extends State<BillingNotificationsView> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Notificaciones de Facturación (CU-040)',
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF38BDF8)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF38BDF8)),
            tooltip: 'Actualizar',
            onPressed: () => widget.controller.loadNotifications(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final controller = widget.controller;
          if (controller.isLoading && controller.response == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
            );
          }
          if (controller.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFF87171), size: 48),
                    const SizedBox(height: 12),
                    Text(
                      controller.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFFCA5A5)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7)),
                      onPressed: () => controller.loadNotifications(),
                      child: const Text('Reintentar', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }
          final response = controller.response;
          if (response == null || response.items.isEmpty) {
            return const Center(
              child: Text(
                'No hay notificaciones de facturación.',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
            );
          }
          return RefreshIndicator(
            color: const Color(0xFF38BDF8),
            onRefresh: () => controller.loadNotifications(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: response.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = response.items[index];
                return Card(
                  color: const Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.receipt_long, color: Color(0xFF38BDF8), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.titulo,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                item.tipo,
                                style: const TextStyle(color: Color(0xFFFCD34D), fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(item.contenido, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item.destinatarios} destinatario(s) · ${item.enviadoen.toLocal()}',
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                            ),
                            if (item.enlaceaccion != null)
                              Text(
                                item.enlaceaccion!,
                                style: const TextStyle(color: Color(0xFF7DD3FC), fontSize: 11),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

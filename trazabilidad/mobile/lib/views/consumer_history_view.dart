import 'package:flutter/material.dart';
import '../controllers/consumer_history_controller.dart';
import '../controllers/trace_controller.dart';
import 'certificate_view.dart';
import 'trace_history_view.dart';

/// CU-028: Historial de compras del consumidor registrado.
class ConsumerHistoryView extends StatefulWidget {
  final ConsumerHistoryController controller;
  final TraceController traceController;

  const ConsumerHistoryView({
    super.key,
    required this.controller,
    required this.traceController,
  });

  @override
  State<ConsumerHistoryView> createState() => _ConsumerHistoryViewState();
}

class _ConsumerHistoryViewState extends State<ConsumerHistoryView> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Mis Compras (CU-028)',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF38BDF8)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF38BDF8)),
            tooltip: 'Actualizar',
            onPressed: () => widget.controller.loadHistory(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final controller = widget.controller;
          if (controller.isLoading && controller.history == null) {
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
                      onPressed: () => controller.loadHistory(),
                      child: const Text('Reintentar', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }
          final history = controller.history;
          if (history == null || history.items.isEmpty) {
            return const Center(
              child: Text(
                'Aún no tienes compras registradas.',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
            );
          }
          return RefreshIndicator(
            color: const Color(0xFF38BDF8),
            onRefresh: () => controller.loadHistory(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SummaryCard(history: history),
                const SizedBox(height: 16),
                ...history.items.map(
                  (compra) => _PurchaseCard(
                    compra: compra,
                    onUnitTrace: (uuid) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TraceHistoryView(
                          controller: widget.traceController,
                          initialUuid: uuid,
                        ),
                      ),
                    ),
                    onCertificate: (uuid) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CertificateView(uuidpublico: uuid),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final dynamic history;

  const _SummaryCard({required this.history});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _metric('Compras', '${history.totalcompras}'),
            _metric('Monto total', '\$${history.montototal.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _PurchaseCard extends StatelessWidget {
  final dynamic compra;
  final void Function(String uuid) onUnitTrace;
  final void Function(String uuid) onCertificate;

  const _PurchaseCard({
    required this.compra,
    required this.onUnitTrace,
    required this.onCertificate,
  });

  @override
  Widget build(BuildContext context) {
    final unidades = (compra.unidades as List).cast<dynamic>();
    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Venta #${compra.idventa}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${compra.estado}',
                    style: const TextStyle(color: Color(0xFF7DD3FC), fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${compra.fechaventa.toLocal()}',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              'Total: \$${compra.total.toStringAsFixed(2)}',
              style: const TextStyle(color: Color(0xFFF8FAFC), fontWeight: FontWeight.w600),
            ),
            const Divider(color: Color(0xFF334155), height: 18),
            ...unidades.map(
              (u) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.smartphone, color: Color(0xFF38BDF8), size: 20),
                title: Text(
                  'S/N ${u.numeroserie}',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                subtitle: Text(
                  'UUID: ${u.uuidpublico}',
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.history, color: Color(0xFF38BDF8), size: 20),
                      tooltip: 'Trazabilidad',
                      onPressed: () => onUnitTrace(u.uuidpublico),
                    ),
                    IconButton(
                      icon: const Icon(Icons.verified, color: Color(0xFF34D399), size: 20),
                      tooltip: 'Certificado',
                      onPressed: () => onCertificate(u.uuidpublico),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

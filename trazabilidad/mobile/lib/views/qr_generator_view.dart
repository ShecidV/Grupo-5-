import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../controllers/cu017_qr/qr_controller.dart';
import '../models/qr_model.dart';

class QrGeneratorView extends StatefulWidget {
  final QrController qrController;

  const QrGeneratorView({super.key, required this.qrController});

  @override
  State<QrGeneratorView> createState() => _QrGeneratorViewState();
}

class _QrGeneratorViewState extends State<QrGeneratorView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.qrController.loadUnits();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showQrDialog(UnitQrModel unit) async {
    showDialog(
      context: context,
      builder: (ctx) => Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.88,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF38BDF8), width: 1.2),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Código QR de Unidad',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FutureBuilder<Uint8List?>(
                  future: widget.qrController.getQrImageBytes(unit.idunidad),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
                      );
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.memory(
                          snapshot.data!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      );
                    }
                    return const Text('Error al cargar imagen QR', style: TextStyle(color: Colors.redAccent));
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  unit.productoNombre,
                  style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '${unit.varianteSku} (${unit.color ?? ''} ${unit.almacenamiento ?? ''})',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  'Nº Serie: ${unit.numeroserie}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                ),
                if (unit.imei1 != null && unit.imei1!.isNotEmpty)
                  Text('IMEI: ${unit.imei1}', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Código QR listo para trazabilidad.')),
                      );
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text('Listo', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.qrController,
      builder: (context, _) {
        final ctrl = widget.qrController;

        return Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E293B),
            title: const Row(
              children: [
                Icon(Icons.qr_code_2, color: Color(0xFF38BDF8)),
                SizedBox(width: 8),
                Text('Generar Código QR', style: TextStyle(fontSize: 18, color: Colors.white)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFF38BDF8)),
                onPressed: () => ctrl.loadUnits(),
              ),
            ],
          ),
          body: Column(
            children: [
              // Barra de búsqueda y filtros
              Container(
                padding: const EdgeInsets.all(12),
                color: const Color(0xFF1E293B),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Buscar por Serie, IMEI, Modelo...',
                        hintStyle: const TextStyle(color: Colors.white38),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF38BDF8)),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.white38),
                                onPressed: () {
                                  _searchController.clear();
                                  ctrl.setSearch('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFF0F172A),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF334155)),
                        ),
                      ),
                      onSubmitted: (val) => ctrl.setSearch(val),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _filterChip('Todas', ctrl.filterTieneQr == null, () => ctrl.setFilter(null)),
                        const SizedBox(width: 6),
                        _filterChip('Con QR', ctrl.filterTieneQr == true, () => ctrl.setFilter(true)),
                        const SizedBox(width: 6),
                        _filterChip('Sin QR', ctrl.filterTieneQr == false, () => ctrl.setFilter(false)),
                      ],
                    ),
                  ],
                ),
              ),

              if (ctrl.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red.shade900,
                  width: double.infinity,
                  child: Text(ctrl.errorMessage!, style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),

              // Lista de unidades
              Expanded(
                child: ctrl.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)))
                    : ctrl.units.isEmpty
                        ? const Center(
                            child: Text(
                              'No se encontraron unidades.',
                              style: TextStyle(color: Colors.white54, fontSize: 15),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: ctrl.units.length,
                            itemBuilder: (context, index) {
                              final u = ctrl.units[index];
                              return Card(
                                color: const Color(0xFF1E293B),
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: u.tieneQr ? const Color(0xFF059669) : const Color(0xFF334155),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              u.productoNombre,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: u.tieneQr
                                                  ? const Color(0xFF064E3B)
                                                  : const Color(0xFF78350F),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              u.tieneQr ? 'QR Activo' : 'Sin QR',
                                              style: TextStyle(
                                                color: u.tieneQr
                                                    ? const Color(0xFFA7F3D0)
                                                    : const Color(0xFFFDE68A),
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${u.varianteSku} • ${u.color ?? ''} ${u.almacenamiento ?? ''}',
                                        style: const TextStyle(color: Colors.white60, fontSize: 13),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Text('Serie: ', style: TextStyle(color: Colors.white38, fontSize: 12)),
                                          Text(u.numeroserie, style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w600, fontSize: 12)),
                                          if (u.imei1 != null) ...[
                                            const SizedBox(width: 12),
                                            const Text('IMEI: ', style: TextStyle(color: Colors.white38, fontSize: 12)),
                                            Text(u.imei1!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                          ],
                                        ],
                                      ),
                                      const Divider(color: Color(0xFF334155), height: 18),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          if (u.tieneQr)
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF0284C7),
                                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                              ),
                                              onPressed: () => _showQrDialog(u),
                                              icon: const Icon(Icons.qr_code, size: 16, color: Colors.white),
                                              label: const Text('Ver QR', style: TextStyle(color: Colors.white, fontSize: 12)),
                                            )
                                          else
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF059669),
                                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                              ),
                                              onPressed: () async {
                                                final res = await ctrl.generateQr(u.idunidad);
                                                if (res != null) {
                                                  _showQrDialog(u);
                                                }
                                              },
                                              icon: const Icon(Icons.add, size: 16, color: Colors.white),
                                              label: const Text('Generar QR', style: TextStyle(color: Colors.white, fontSize: 12)),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF334155),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

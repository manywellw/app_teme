import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bible_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BibleProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Text size box
          Card(
            color: const Color(0xFF161A30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.text_fields, color: Color(0xFF818CF8), size: 18),
                      SizedBox(width: 10),
                      Text(
                        'Tamanho da Fonte Bíblica',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Fonte Leitura', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      Text('${provider.fontSize.toInt()}px', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  Slider(
                    value: provider.fontSize,
                    min: 14.0,
                    max: 28.0,
                    divisions: 7,
                    activeColor: const Color(0xFF6366F1),
                    inactiveColor: Colors.blueGrey[800],
                    onChanged: (val) {
                      provider.updateFontSize(val);
                    },
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: const Color(0xFF0B0E20),
                    child: Text(
                      '"O Senhor é o meu pastor; nada me faltará."',
                      style: TextStyle(fontSize: provider.fontSize, fontStyle: FontStyle.italic, color: Colors.blueGrey),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Speech Voice adjustments
          Card(
            color: const Color(0xFF161A30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.record_voice_over_outlined, color: Color(0xFF818CF8), size: 18),
                      SizedBox(width: 10),
                      Text(
                        'Velocidade do Áudio Narrado',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Leitura por voz de apoio', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      Text('${provider.speechRate}x', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  Slider(
                    value: provider.speechRate,
                    min: 0.6,
                    max: 1.4,
                    divisions: 4,
                    activeColor: const Color(0xFF6366F1),
                    inactiveColor: Colors.blueGrey[800],
                    onChanged: (val) {
                      provider.updateSpeechRate(val);
                    },
                  ),
                  const Text(
                    'A reprodução utiliza a síntese de voz original do celular, operando de forma 100% livre, off-line e sem cobranças em redes móveis.',
                    style: TextStyle(color: Colors.grey, fontSize: 9, height: 1.4),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Destructive Clean Card
          Card(
            color: const Color(0xFF161A30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manutenção e Memória Local',
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Caso deseje repor as preferências básicas da aplicação, zerar os diálogos do assistente inteligente e remover as notas e marcadores salvos:',
                    style: TextStyle(color: Colors.grey, fontSize: 11, height: 1.5),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: const Color(0xFF161A30),
                          title: const Text('Limpar dados locais?', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          content: const Text('Esta ação apagará de forma irreparável todos os seus marcadores, notas escritas à mão e histórico devocional.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
                            ElevatedButton(
                              onPressed: () {
                                provider.clearAllUserData();
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Tudo foi redefinido.')),
                                );
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                              child: const Text('Limpar Tudo', style: TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_forever, size: 14, color: Colors.white),
                    label: const Text('Apagar Notas e Marcadores', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withValues(alpha: 0.12), side: const BorderSide(color: Colors.redAccent)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Specs list info
          const Text('Aplicação: Bíblia TEME (Almeida Revista e Corrigida - ARC)', style: TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(height: 2),
          const Text('Versão: 1.0.0 (Flutter & Material 3 Devocional)', style: TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}

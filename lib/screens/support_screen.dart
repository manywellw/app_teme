import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Elegant vector-drawn TEME Dove Symbol
          Card(
            color: const Color(0xFF161A30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                children: [
                  // Drawn Logo
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: CustomPaint(
                        size: const Size(60, 60),
                        painter: LogoPainter(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'O Princípio é... TEME',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Trabalho Evangélico Missão Eterna',
                    style: TextStyle(color: Color(0xFF818CF8), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Institutional definition
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Significado Institucional',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          const SizedBox(height: 12),

          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildAcronymTile('T', 'Trabaho', 'Dedicação diária na videira do Senhor.', Colors.amber),
              const SizedBox(height: 10),
              _buildAcronymTile('E', 'Evangélico', 'Fidelidade total às escrituras sagradas.', Colors.redAccent),
              const SizedBox(height: 10),
              _buildAcronymTile('M', 'Missão', 'Levar a palavra de salvação a toda criatura.', Colors.blueAccent),
              const SizedBox(height: 10),
              _buildAcronymTile('E', 'Eterna', 'A recompensa gloriosa no Reino dos Céus.', Colors.lightGreen),
            ],
          ),
          const SizedBox(height: 24),

          // About Paragraph Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF121630).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueGrey[800]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.library_books, color: Color(0xFF6366F1), size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Sobre o Projeto Bíblia TEME',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'A Bíblia TEME é uma iniciativa dedicada a levar o Evangelho de forma limpa, veloz e 100% offline para todos os leitores. Escolhemos a tradução Almeida Revista e Corrigida (ARC) por ser uma tradução fiel, consolidada e amada por gerações de cristãos.\n\nNossa missão é puramente evangelística. O aplicativo oferece uma suite de ferramentas modernas (Destaques Coloridos, Anotações Pessoais vinculadas a passagens, Buscas avançadas e Áudio Integrado) para que o seu tempo devocional seja rico, edificante e transformador.',
                  style: TextStyle(color: Colors.blueGrey[300], fontSize: 12, height: 1.6),
                ),
                const SizedBox(height: 14),
                Text(
                  '"Lâmpada para os meus pés é tua palavra, e luz para o meu caminho." — Salmos 119:105',
                  style: GoogleFonts.inter(
                    color: Colors.amber,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcronymTile(String letter, String word, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF121630),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blueGrey[800]!),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 1),
                Text(
                  description,
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 10),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Custom Painter vector for Logo shield in Dart
class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    
    // Cross Painter (Gold)
    paint.color = const Color(0xFFD97706);
    paint.strokeWidth = 5;
    paint.strokeCap = StrokeCap.round;
    // vertical line
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.2), Offset(size.width * 0.5, size.height * 0.8), paint);
    // horizontal line
    canvas.drawLine(Offset(size.width * 0.25, size.height * 0.4), Offset(size.width * 0.75, size.height * 0.4), paint);
    
    // Bird symbol drawn on top
    paint.color = const Color(0xFF1E3A8A);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.5;

    var path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.65, size.height * 0.15, size.width * 0.7, size.height * 0.35);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width * 0.5, size.height * 0.58);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width * 0.3, size.height * 0.35);
    path.quadraticBezierTo(size.width * 0.35, size.height * 0.15, size.width * 0.5, size.height * 0.2);
    canvas.drawPath(path, paint);

    // Dove eye loop
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.3), 1.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

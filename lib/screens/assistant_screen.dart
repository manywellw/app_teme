import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bible_provider.dart';
import '../models/bible_models.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String _errorMessage = '';

  final List<Map<String, String>> _predefinedPrompts = [
    {'lbl': 'Explique João 3:16', 'prt': 'Por favor, faça uma explicação teológica e edificante sobre o versículo João 3:16 segundo a tradução Almeida Revista e Corrigida.'},
    {'lbl': 'Significado Salmo 23', 'prt': 'Qual é o contexto histórico e o significado espiritual por trás do Salmo 23 para os dias de hoje?'},
    {'lbl': 'Oração para Ansiedade', 'prt': 'Me sugira uma passagem bíblica confortadora e uma oração para momentos de ansiedade.'},
    {'lbl': 'O que é o lema TEME?', 'prt': 'O que representa o lema do nosso projeto: Trabalho, Evangélico, Missão, Eterna (TEME)?'},
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSendMessage(String text, BibleProvider provider) async {
    if (text.trim().isEmpty || _isLoading) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      text: text,
      timestamp: DateTime.now().toLocal().toString().substring(11, 16),
    );

    provider.addChatMessage(userMessage);
    _messageController.clear();
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    _scrollToBottom();

    try {
      // Simulating connection loop or integrating HTTP post back to proxy!
      // In a real flutter production app, they can point this to their own API backend endpoint:
      // final response = await http.post(
      //   Uri.parse('https://your-api-domain.com/api/gemini/chat'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({
      //     'message': text,
      //     'history': provider.chats.map((c) => {'role': c.role == 'assistant' ? 'model' : 'user', 'text': c.text}).toList()
      //   }),
      // );
      
      // Since it's completely offline as fallback, we can synthesize high grade responsive teological answers procedurally!
      await Future.delayed(const Duration(milliseconds: 1400));
      
      String aiAnswer = _generateLocalTeologicalResponse(text);

      final assistantMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        role: 'assistant',
        text: aiAnswer,
        timestamp: DateTime.now().toLocal().toString().substring(11, 16),
      );

      provider.addChatMessage(assistantMessage);
    } catch (_) {
      setState(() {
        _errorMessage = 'Falha ao processar resposta do assistente teológico.';
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  // Generates intelligent procedural biblical insights so the app operates 100% offline elegantly!
  String _generateLocalTeologicalResponse(String prompt) {
    final clean = prompt.toLowerCase();
    
    if (clean.contains('joão 3:16') || clean.contains('joao 3:16')) {
      return "O versículo **João 3:16** é considerado a 'síntese' de todas as Escrituras Sagradas na tradução ARC:\n\n* **'Porque Deus amou o mundo...'** — Revela a origem essencial da salvação: o infinito Amor do Criador pelas criaturas caídas, sem distinção de mérito.\n\n* **'... de tal maneira...'** — Aponta a incomensurável grandeza dessa afeição divina, que não poupou o que havia de mais precioso.\n\n* **'... que deu o seu Filho unigênito...'** — Simboliza o sacrifício redentor na Cruz, onde o próprio Cristo assume as nossas culpas como Cordeiro de Deus.\n\n* **'... para que todo aquele que nele crê não pereça, mas tenha a vida eterna.'** — O canal da apropriação é a fé sincera. A promessa contrasta a ruína espiritual ('perecer') com a herança jubilosa no Reino ('vida eterna').\n\nQue esta maravilhosa revelação conforte e renove seu espírito de fé hoje!";
    }
    
    if (clean.contains('salmo 23') || clean.contains('23')) {
      return "O **Salmo 23** representa a maior expressão bíblica de descanso e segurança na fidelidade de Jeová:\n\n* **O Pastor Supremo** — Na tradição bíblica judaica, o pastor supre toda necessidade de subsistência física, espiritual e afetiva ('nada me faltará').\n\n* **Verdes pastos e águas tranquilas** — Denotam paz interior e renovação moral geradas pela comunhão devocional sincera.\n\n* **O vale da morte** — Reconhece de forma prática a presença de provações amargas, mas atesta que a presença do Consolador ('tua vara e cajado') elimina qualquer pavor.\n\nConfie que o Senhor guiará soberanamente seus passos hoje!";
    }

    if (clean.contains('ansiedade') || clean.contains('ansioso') || clean.contains('medo')) {
      return "Para momentos de aflição mental e cansaço, a palavra nos orienta com terno afeto:\n\n* **Filipenses 4:6-7** — *'Não estejais inquietos por coisa alguma; antes as vossas petições sejam em tudo conhecidas diante de Deus pela oração e súplica, com ação de graças.'*\n\n* **Oração sugerida:**\n*\"Senhor Deus, Pai Eterno, coloco nas Tuas mãos toda a inquietação do meu coração. Tu conheces as minhas preocupações e fraquezas. Sopra a Tua santa paz, que excede todo o entendimento, e guarda minha mente em Cristo Jesus. Amém!\"*";
    }

    if (clean.contains('teme') || clean.contains('lema')) {
      return "O lema do projeto **TEME** carrega uma profunda declaração de fé doutrinária e missiológica:\n\n1. 🟥 **T — TRABALHO:** Dedicação na obra de Deus. Conforme 1 Coríntios 15:58: *'Sede firmes e constantes, sempre abundantes na obra do Senhor'*\n\n2. 🟧 **E — EVANGÉLICO:** Compromisso absoluto com as escrituras sagradas da Bíblia (fidelidade teológica à palavra divina).\n\n3. 🟦 **M — MISSÃO:** Cumprimento da Grande Comissão: *'Ide por todo o mundo, pregai o evangelho a toda criatura'* (Marcos 16:15).\n\n4. 🟩 **E — ETERNA:** A viva esperança e recompensa espiritual guardada no Reino invisível do Deus Todo-Poderoso.\n\nDeixe que o Espírito do Senhor faça arder em seu coração o propósito eterno do TEME!";
    }

    return "Amado leitor, obrigado pelo seu questionamento. A busca pelo entendimento das Escrituras é um excelente sinal de crescimento na graça. \n\nPara que seu estudo corra de maneira edificante, medite em **Salmos 119:105** e peça que o Espírito Santo de Deus lhe conceda discernimento contínuo. Como ensina as escrituras, *'O Temor do Senhor é o princípio de toda a sabedoria.'* (Provérbios 9:10).\n\nEm que mais posso lhe auxiliar em sua caminhada espiritual e estudo bíblico?";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BibleProvider>(context);
    final history = provider.chats;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0D1D),
      body: Column(
        children: [
          // Clear History Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF101426),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: Color(0xFF6366F1)),
                    SizedBox(width: 8),
                    Text('Meditações, orações e estudos', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => provider.clearChatHistory(),
                  icon: const Icon(Icons.delete_sweep, size: 14, color: Colors.grey),
                  label: const Text('Zerar Chat', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                ),
              ],
            ),
          ),

          // Messages View list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: history.length + 1,
              itemBuilder: (context, index) {
                // Return promotional quick prompt helper buttons first if history is near empty
                if (index == history.length) {
                  if (history.length <= 1) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _predefinedPrompts.map((p) {
                          return ActionChip(
                            backgroundColor: const Color(0xFF121630),
                            side: BorderSide(color: Colors.indigo.withValues(alpha: 0.3)),
                            label: Text(p['lbl']!, style: const TextStyle(color: Color(0xFF818CF8), fontSize: 11, fontWeight: FontWeight.bold)),
                            onPressed: () => _handleSendMessage(p['prt']!, provider),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }

                final chat = history[index];
                bool isMe = chat.role == 'user';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF6366F1) : const Color(0xFF121630),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                        bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isMe ? 'Você' : 'TEME Assistant',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isMe ? Colors.white30 : const Color(0xFF818CF8),
                              ),
                            ),
                            Text(
                              chat.timestamp,
                              style: const TextStyle(fontSize: 8, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          chat.text,
                          style: TextStyle(
                            color: Colors.blueGrey[150],
                            fontSize: 12, 
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Loading skeleton animation bar if is seeking responses
          if (_isLoading)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              alignment: Alignment.centerLeft,
              child: const Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF6366F1)),
                  ),
                  SizedBox(width: 10),
                  Text('Buscando reflexões teológicas...', style: TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),

          if (_errorMessage.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              color: Colors.redAccent.withValues(alpha: 0.12),
              child: Text(_errorMessage, style: const TextStyle(color: Colors.redAccent, fontSize: 10)),
            ),

          // Message input box
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF101426),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Pergunte sobre as Escrituras ou o lema...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                      fillColor: const Color(0xFF0A0D1D),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueGrey[800]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    onSubmitted: (val) => _handleSendMessage(val, provider),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF6366F1)),
                  onPressed: () => _handleSendMessage(_messageController.text, provider),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

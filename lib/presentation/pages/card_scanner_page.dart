import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../core/parsers/card_parser.dart';
import '../../core/models/card_details.dart';

class CardScannerPage extends StatefulWidget {
  const CardScannerPage({super.key});

  @override
  State<CardScannerPage> createState() => _CardScannerPageState();
}

class _CardScannerPageState extends State<CardScannerPage> {
  CameraController? _controller;
  bool _isProcessing = false;
  final TextRecognizer _textRecognizer = TextRecognizer();
  CardDetails? _result;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(cameras[0], ResolutionPreset.high);
    await _controller?.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _processImage() async {
    if (_controller == null || _isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final image = await _controller!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      final cardDetails = CardParser.parseCard(recognizedText.text);
      
      setState(() {
        _result = cardDetails;
        _isProcessing = false;
      });
    } catch (e) {
      debugPrint("OCR Error: $e");
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Card')),
      body: Stack(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: 1 / _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),
          
          // Scanning Overlay
          _buildOverlay(),

          if (_result != null) _buildResultSheet(),
          
          if (_isProcessing)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: _isProcessing ? null : _processImage,
        child: const Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildOverlay() {
    return Stack(
      children: [
        ColorFiltered(
          overlayColor: Colors.black54,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
          ),
        ),
        Center(
          child: Container(
            width: 350,
            height: 220,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Extracted Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => setState(() => _result = null), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              _buildInfoRow('Card Number', _maskCardNumber(_result!.cardNumber)),
              _buildInfoRow('Expiry', _result!.expiryDate),
              _buildInfoRow('Holder Name', _result!.cardHolderName ?? 'Unknown'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _result!.isValid ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(_result!.isValid ? Icons.check_circle : Icons.error, 
                         color: _result!.isValid ? Colors.green : Colors.red),
                    const SizedBox(width: 12),
                    Text(_result!.isValid ? 'Valid Card (Luhn Passed)' : 'Invalid Card (Luhn Failed)',
                         style: TextStyle(color: _result!.isValid ? Colors.green : Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String _maskCardNumber(String number) {
    if (number.length < 4) return number;
    String lastFour = number.substring(number.length - 4);
    String masked = "";
    for (int i = 0; i < number.length - 4; i++) {
      masked += (i > 0 && i % 4 == 0) ? " X" : "X";
    }
    return "$masked $lastFour";
  }
}

// Simple ColorFiltered extension to support overlay
class ColorFiltered extends StatelessWidget {
  final Color overlayColor;
  final Widget child;

  const ColorFiltered({super.key, required this.overlayColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(colors: [overlayColor, overlayColor]).createShader(rect);
      },
      blendMode: BlendMode.darken,
      child: child,
    );
  }
}

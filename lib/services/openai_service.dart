import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:typed_data';

class OpenAIService {
  static final OpenAIService _instance = OpenAIService._internal();
  late final Dio _dio;
  static const String apiKey = String.fromEnvironment('OPENAI_API_KEY');

  // Factory constructor to return the singleton instance
  factory OpenAIService() {
    return _instance;
  }

  // Private constructor for singleton pattern
  OpenAIService._internal() {
    _initializeService();
  }

  void _initializeService() {
    // Load API key from environment variables
    if (apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY must be provided via --dart-define');
    }

    // Configure Dio with base URL and headers
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.openai.com/v1',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
      ),
    );
  }

  Dio get dio => _dio;
}

class OpenAIClient {
  final Dio dio;

  OpenAIClient(this.dio);

  /// Generates a text response from chat completion
  Future<Completion> createChatCompletion({
    required List<Message> messages,
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async {
    try {
      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages
              .map((m) => {
                    'role': m.role,
                    'content': m.content,
                  })
              .toList(),
          if (options != null) ...options,
        },
      );
      final text = response.data['choices'][0]['message']['content'];
      return Completion(text: text);
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// Vision API (image analysis) for video frames
  Future<Completion> generateTextFromImage({
    String? imageUrl,
    Uint8List? imageBytes,
    String promptText =
        'Analyze this video frame and extract any Python code visible in the image. Return only the Python code found, formatted properly.',
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async {
    try {
      if (imageUrl == null && imageBytes == null) {
        throw ArgumentError('Either imageUrl or imageBytes must be provided');
      }

      final List<Map<String, dynamic>> content = [
        {'type': 'text', 'text': promptText},
      ];

      // Add image content based on what was provided
      if (imageUrl != null) {
        content.add({
          'type': 'image_url',
          'image_url': {'url': imageUrl}
        });
      } else if (imageBytes != null) {
        // Convert image bytes to base64
        final base64Image = base64Encode(imageBytes);
        content.add({
          'type': 'image_url',
          'image_url': {'url': 'data:image/jpeg;base64,$base64Image'}
        });
      }

      final messages = [
        Message(role: 'user', content: content),
      ];

      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages
              .map((m) => {
                    'role': m.role,
                    'content': m.content,
                  })
              .toList(),
          if (options != null) ...options,
        },
      );

      final text = response.data['choices'][0]['message']['content'];
      return Completion(text: text);
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// Streaming chat completion for real-time processing updates
  Stream<StreamCompletion> streamChatCompletion({
    required List<Message> messages,
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async* {
    try {
      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages
              .map((m) => {
                    'role': m.role,
                    'content': m.content,
                  })
              .toList(),
          'stream': true,
          if (options != null) ...options,
        },
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data.stream;
      await for (var line
          in LineSplitter().bind(utf8.decoder.bind(stream.stream))) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') break;

          final json = jsonDecode(data) as Map<String, dynamic>;
          final delta = json['choices'][0]['delta'] as Map<String, dynamic>;
          final content = delta['content'] ?? '';
          final finishReason = json['choices'][0]['finish_reason'];
          final systemFingerprint = json['system_fingerprint'];

          yield StreamCompletion(
            content: content,
            finishReason: finishReason,
            systemFingerprint: systemFingerprint,
          );

          // If finish reason is provided, this is the final chunk
          if (finishReason != null) break;
        }
      }
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }
}

/// Support classes
class Message {
  final String role;
  final dynamic content;

  Message({required this.role, required this.content});
}

class Completion {
  final String text;

  Completion({required this.text});
}

class StreamCompletion {
  final String content;
  final String? finishReason;
  final String? systemFingerprint;

  StreamCompletion({
    required this.content,
    this.finishReason,
    this.systemFingerprint,
  });
}

class OpenAIException implements Exception {
  final int statusCode;
  final String message;

  OpenAIException({required this.statusCode, required this.message});

  @override
  String toString() => 'OpenAIException: $statusCode - $message';
}

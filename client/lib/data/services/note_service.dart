import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/api/api_response.dart';
import '../models/note.dart';
import '../models/note/create_note_request.dart';

class NoteService {
  static final NoteService _instance = NoteService._internal();
  factory NoteService() => _instance;
  NoteService._internal();

  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<Note>> createNote(CreateNoteRequest request) async {
    try {
      final response = await _apiClient.post<Note>(
        ApiEndpoints.notes,
        request.toJson(),
        fromJson: (json) => Note.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al crear nota: $e');
    }
  }

  Future<ApiResponse<List<Note>>> getNotes({String order = 'desc'}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.notes}?order=$order',
      );

      if (response.success && response.data != null) {
        final data = response.data;
        if (data is List) {
          final notes = <Note>[];
          for (var item in data) {
            try {
              if (item is Map<String, dynamic>) {
                notes.add(Note.fromJson(item));
              }
            } catch (e) {
              continue;
            }
          }
          return ApiResponse.success(data: notes);
        }
      }

      return ApiResponse.error(response.error ?? 'Error al obtener notas');
    } catch (e) {
      return ApiResponse.error('Error al obtener notas: $e');
    }
  }

  Future<ApiResponse<Note>> getNoteById(String noteId) async {
    try {
      final response = await _apiClient.get<Note>(
        ApiEndpoints.noteById(noteId),
        fromJson: (json) => Note.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al obtener nota: $e');
    }
  }

  Future<ApiResponse<Note>> updateNote(
    String noteId,
    CreateNoteRequest request,
  ) async {
    try {
      final response = await _apiClient.patch<Note>(
        ApiEndpoints.noteById(noteId),
        request.toJson(),
        fromJson: (json) => Note.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al actualizar nota: $e');
    }
  }

  Future<ApiResponse<String>> deleteNote(String noteId) async {
    try {
      final response = await _apiClient.delete<String>(
        ApiEndpoints.noteById(noteId),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al eliminar nota: $e');
    }
  }

}
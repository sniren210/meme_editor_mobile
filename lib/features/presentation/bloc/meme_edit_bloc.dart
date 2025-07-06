import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme_edit.dart';
import 'package:meme_editor_mobile/features/domain/usecases/meme_operations.dart';

// Events
abstract class MemeEditEvent extends Equatable {
  const MemeEditEvent();

  @override
  List<Object> get props => [];
}

class LoadMemeEditEvent extends MemeEditEvent {
  final String memeId;

  const LoadMemeEditEvent(this.memeId);

  @override
  List<Object> get props => [memeId];
}

class AddTextElementEvent extends MemeEditEvent {
  final TextElement textElement;

  const AddTextElementEvent(this.textElement);

  @override
  List<Object> get props => [textElement];
}

class UpdateTextElementEvent extends MemeEditEvent {
  final TextElement textElement;

  const UpdateTextElementEvent(this.textElement);

  @override
  List<Object> get props => [textElement];
}

class RemoveTextElementEvent extends MemeEditEvent {
  final String elementId;

  const RemoveTextElementEvent(this.elementId);

  @override
  List<Object> get props => [elementId];
}

class AddStickerElementEvent extends MemeEditEvent {
  final StickerElement stickerElement;

  const AddStickerElementEvent(this.stickerElement);

  @override
  List<Object> get props => [stickerElement];
}

class UpdateStickerElementEvent extends MemeEditEvent {
  final StickerElement stickerElement;

  const UpdateStickerElementEvent(this.stickerElement);

  @override
  List<Object> get props => [stickerElement];
}

class RemoveStickerElementEvent extends MemeEditEvent {
  final String elementId;

  const RemoveStickerElementEvent(this.elementId);

  @override
  List<Object> get props => [elementId];
}

class SaveMemeEditEvent extends MemeEditEvent {}

class UndoEvent extends MemeEditEvent {}

class RedoEvent extends MemeEditEvent {}

class SaveToGalleryEvent extends MemeEditEvent {
  final String imagePath;

  const SaveToGalleryEvent(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class ShareImageEvent extends MemeEditEvent {
  final String imagePath;

  const ShareImageEvent(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

// States
abstract class MemeEditState extends Equatable {
  const MemeEditState();

  @override
  List<Object> get props => [];
}

class MemeEditInitial extends MemeEditState {}

class MemeEditLoading extends MemeEditState {}

class MemeEditLoaded extends MemeEditState {
  final MemeEdit memeEdit;
  final List<MemeEdit> undoStack;
  final List<MemeEdit> redoStack;

  const MemeEditLoaded({
    required this.memeEdit,
    this.undoStack = const [],
    this.redoStack = const [],
  });

  MemeEditLoaded copyWith({
    MemeEdit? memeEdit,
    List<MemeEdit>? undoStack,
    List<MemeEdit>? redoStack,
  }) {
    return MemeEditLoaded(
      memeEdit: memeEdit ?? this.memeEdit,
      undoStack: undoStack ?? this.undoStack,
      redoStack: redoStack ?? this.redoStack,
    );
  }

  @override
  List<Object> get props => [memeEdit, undoStack, redoStack];
}

class MemeEditSaved extends MemeEditState {
  final MemeEdit memeEdit;

  const MemeEditSaved(this.memeEdit);

  @override
  List<Object> get props => [memeEdit];
}

class ImageSavedToGallery extends MemeEditState {
  final String path;

  const ImageSavedToGallery(this.path);

  @override
  List<Object> get props => [path];
}

class ImageShared extends MemeEditState {}

class MemeEditError extends MemeEditState {
  final String message;

  const MemeEditError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class MemeEditBloc extends Bloc<MemeEditEvent, MemeEditState> {
  final SaveMemeEditUseCase saveMemeEditUseCase;
  final GetMemeEditUseCase getMemeEditUseCase;
  final SaveImageToGalleryUseCase saveImageToGalleryUseCase;
  final ShareImageUseCase shareImageUseCase;

  MemeEditBloc({
    required this.saveMemeEditUseCase,
    required this.getMemeEditUseCase,
    required this.saveImageToGalleryUseCase,
    required this.shareImageUseCase,
  }) : super(MemeEditInitial()) {
    on<LoadMemeEditEvent>(_onLoadMemeEdit);
    on<AddTextElementEvent>(_onAddTextElement);
    on<UpdateTextElementEvent>(_onUpdateTextElement);
    on<RemoveTextElementEvent>(_onRemoveTextElement);
    on<AddStickerElementEvent>(_onAddStickerElement);
    on<UpdateStickerElementEvent>(_onUpdateStickerElement);
    on<RemoveStickerElementEvent>(_onRemoveStickerElement);
    on<SaveMemeEditEvent>(_onSaveMemeEdit);
    on<UndoEvent>(_onUndo);
    on<RedoEvent>(_onRedo);
    on<SaveToGalleryEvent>(_onSaveToGallery);
    on<ShareImageEvent>(_onShareImage);
  }

  Future<void> _onLoadMemeEdit(LoadMemeEditEvent event, Emitter<MemeEditState> emit) async {
    emit(MemeEditLoading());
    
    final result = await getMemeEditUseCase(event.memeId);
    result.fold(
      (failure) => emit(MemeEditError(failure.message)),
      (memeEdit) {
        final edit = memeEdit ?? MemeEdit(
          memeId: event.memeId,
          textElements: const [],
          stickerElements: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        emit(MemeEditLoaded(memeEdit: edit));
      },
    );
  }

  void _onAddTextElement(AddTextElementEvent event, Emitter<MemeEditState> emit) {
    final currentState = state;
    if (currentState is MemeEditLoaded) {
      final newUndoStack = List<MemeEdit>.from(currentState.undoStack)..add(currentState.memeEdit);
      final updatedEdit = currentState.memeEdit.copyWith(
        textElements: [...currentState.memeEdit.textElements, event.textElement],
        updatedAt: DateTime.now(),
      );
      
      emit(currentState.copyWith(
        memeEdit: updatedEdit,
        undoStack: newUndoStack,
        redoStack: [], // Clear redo stack when new action is performed
      ));
    }
  }

  void _onUpdateTextElement(UpdateTextElementEvent event, Emitter<MemeEditState> emit) {
    final currentState = state;
    if (currentState is MemeEditLoaded) {
      final newUndoStack = List<MemeEdit>.from(currentState.undoStack)..add(currentState.memeEdit);
      final updatedElements = currentState.memeEdit.textElements.map((element) {
        return element.id == event.textElement.id ? event.textElement : element;
      }).toList();
      
      final updatedEdit = currentState.memeEdit.copyWith(
        textElements: updatedElements,
        updatedAt: DateTime.now(),
      );
      
      emit(currentState.copyWith(
        memeEdit: updatedEdit,
        undoStack: newUndoStack,
        redoStack: [],
      ));
    }
  }

  void _onRemoveTextElement(RemoveTextElementEvent event, Emitter<MemeEditState> emit) {
    final currentState = state;
    if (currentState is MemeEditLoaded) {
      final newUndoStack = List<MemeEdit>.from(currentState.undoStack)..add(currentState.memeEdit);
      final updatedElements = currentState.memeEdit.textElements
          .where((element) => element.id != event.elementId)
          .toList();
      
      final updatedEdit = currentState.memeEdit.copyWith(
        textElements: updatedElements,
        updatedAt: DateTime.now(),
      );
      
      emit(currentState.copyWith(
        memeEdit: updatedEdit,
        undoStack: newUndoStack,
        redoStack: [],
      ));
    }
  }

  void _onAddStickerElement(AddStickerElementEvent event, Emitter<MemeEditState> emit) {
    final currentState = state;
    if (currentState is MemeEditLoaded) {
      final newUndoStack = List<MemeEdit>.from(currentState.undoStack)..add(currentState.memeEdit);
      final updatedEdit = currentState.memeEdit.copyWith(
        stickerElements: [...currentState.memeEdit.stickerElements, event.stickerElement],
        updatedAt: DateTime.now(),
      );
      
      emit(currentState.copyWith(
        memeEdit: updatedEdit,
        undoStack: newUndoStack,
        redoStack: [],
      ));
    }
  }

  void _onUpdateStickerElement(UpdateStickerElementEvent event, Emitter<MemeEditState> emit) {
    final currentState = state;
    if (currentState is MemeEditLoaded) {
      final newUndoStack = List<MemeEdit>.from(currentState.undoStack)..add(currentState.memeEdit);
      final updatedElements = currentState.memeEdit.stickerElements.map((element) {
        return element.id == event.stickerElement.id ? event.stickerElement : element;
      }).toList();
      
      final updatedEdit = currentState.memeEdit.copyWith(
        stickerElements: updatedElements,
        updatedAt: DateTime.now(),
      );
      
      emit(currentState.copyWith(
        memeEdit: updatedEdit,
        undoStack: newUndoStack,
        redoStack: [],
      ));
    }
  }

  void _onRemoveStickerElement(RemoveStickerElementEvent event, Emitter<MemeEditState> emit) {
    final currentState = state;
    if (currentState is MemeEditLoaded) {
      final newUndoStack = List<MemeEdit>.from(currentState.undoStack)..add(currentState.memeEdit);
      final updatedElements = currentState.memeEdit.stickerElements
          .where((element) => element.id != event.elementId)
          .toList();
      
      final updatedEdit = currentState.memeEdit.copyWith(
        stickerElements: updatedElements,
        updatedAt: DateTime.now(),
      );
      
      emit(currentState.copyWith(
        memeEdit: updatedEdit,
        undoStack: newUndoStack,
        redoStack: [],
      ));
    }
  }

  Future<void> _onSaveMemeEdit(SaveMemeEditEvent event, Emitter<MemeEditState> emit) async {
    final currentState = state;
    if (currentState is MemeEditLoaded) {
      final result = await saveMemeEditUseCase(currentState.memeEdit);
      result.fold(
        (failure) => emit(MemeEditError(failure.message)),
        (memeEdit) => emit(MemeEditSaved(memeEdit)),
      );
    }
  }

  void _onUndo(UndoEvent event, Emitter<MemeEditState> emit) {
    final currentState = state;
    if (currentState is MemeEditLoaded && currentState.undoStack.isNotEmpty) {
      final newRedoStack = List<MemeEdit>.from(currentState.redoStack)..add(currentState.memeEdit);
      final newUndoStack = List<MemeEdit>.from(currentState.undoStack);
      final previousEdit = newUndoStack.removeLast();
      
      emit(currentState.copyWith(
        memeEdit: previousEdit,
        undoStack: newUndoStack,
        redoStack: newRedoStack,
      ));
    }
  }

  void _onRedo(RedoEvent event, Emitter<MemeEditState> emit) {
    final currentState = state;
    if (currentState is MemeEditLoaded && currentState.redoStack.isNotEmpty) {
      final newUndoStack = List<MemeEdit>.from(currentState.undoStack)..add(currentState.memeEdit);
      final newRedoStack = List<MemeEdit>.from(currentState.redoStack);
      final nextEdit = newRedoStack.removeLast();
      
      emit(currentState.copyWith(
        memeEdit: nextEdit,
        undoStack: newUndoStack,
        redoStack: newRedoStack,
      ));
    }
  }

  Future<void> _onSaveToGallery(SaveToGalleryEvent event, Emitter<MemeEditState> emit) async {
    final result = await saveImageToGalleryUseCase(event.imagePath);
    result.fold(
      (failure) => emit(MemeEditError(failure.message)),
      (path) => emit(ImageSavedToGallery(path)),
    );
  }

  Future<void> _onShareImage(ShareImageEvent event, Emitter<MemeEditState> emit) async {
    final result = await shareImageUseCase(event.imagePath);
    result.fold(
      (failure) => emit(MemeEditError(failure.message)),
      (success) => emit(ImageShared()),
    );
  }
}

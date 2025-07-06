import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme.dart';
import 'package:meme_editor_mobile/features/domain/usecases/get_memes.dart';
import 'package:meme_editor_mobile/features/domain/usecases/meme_operations.dart';

// Events
abstract class MemeEvent extends Equatable {
  const MemeEvent();

  @override
  List<Object> get props => [];
}

class LoadMemesEvent extends MemeEvent {}

class RefreshMemesEvent extends MemeEvent {}

class SearchMemesEvent extends MemeEvent {
  final String query;

  const SearchMemesEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ToggleOfflineModeEvent extends MemeEvent {
  final bool isOffline;

  const ToggleOfflineModeEvent(this.isOffline);

  @override
  List<Object> get props => [isOffline];
}

// States
abstract class MemeState extends Equatable {
  const MemeState();

  @override
  List<Object> get props => [];
}

class MemeInitial extends MemeState {}

class MemeLoading extends MemeState {}

class MemeLoaded extends MemeState {
  final List<Meme> memes;
  final List<Meme> filteredMemes;
  final bool isOfflineMode;
  final String searchQuery;

  const MemeLoaded({
    required this.memes,
    required this.filteredMemes,
    required this.isOfflineMode,
    this.searchQuery = '',
  });

  MemeLoaded copyWith({
    List<Meme>? memes,
    List<Meme>? filteredMemes,
    bool? isOfflineMode,
    String? searchQuery,
  }) {
    return MemeLoaded(
      memes: memes ?? this.memes,
      filteredMemes: filteredMemes ?? this.filteredMemes,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [memes, filteredMemes, isOfflineMode, searchQuery];
}

class MemeError extends MemeState {
  final String message;

  const MemeError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class MemeBloc extends Bloc<MemeEvent, MemeState> {
  final GetMemesUseCase getMemesUseCase;
  final ToggleOfflineModeUseCase toggleOfflineModeUseCase;

  MemeBloc({
    required this.getMemesUseCase,
    required this.toggleOfflineModeUseCase,
  }) : super(MemeInitial()) {
    on<LoadMemesEvent>(_onLoadMemes);
    on<RefreshMemesEvent>(_onRefreshMemes);
    on<SearchMemesEvent>(_onSearchMemes);
    on<ToggleOfflineModeEvent>(_onToggleOfflineMode);
  }

  Future<void> _onLoadMemes(LoadMemesEvent event, Emitter<MemeState> emit) async {
    emit(MemeLoading());

    final result = await getMemesUseCase();
    result.fold(
      (failure) => emit(MemeError(failure.message)),
      (memes) => emit(MemeLoaded(
        memes: memes,
        filteredMemes: memes,
        isOfflineMode: false,
      )),
    );
  }

  Future<void> _onRefreshMemes(RefreshMemesEvent event, Emitter<MemeState> emit) async {
    final currentState = state;
    if (currentState is MemeLoaded) {
      emit(currentState.copyWith());
    }

    final result = await getMemesUseCase();
    result.fold(
      (failure) => emit(MemeError(failure.message)),
      (memes) {
        if (currentState is MemeLoaded) {
          final filteredMemes = currentState.searchQuery.isEmpty ? memes : memes.where((meme) => meme.name.toLowerCase().contains(currentState.searchQuery.toLowerCase())).toList();

          emit(currentState.copyWith(
            memes: memes,
            filteredMemes: filteredMemes,
          ));
        } else {
          emit(MemeLoaded(
            memes: memes,
            filteredMemes: memes,
            isOfflineMode: false,
          ));
        }
      },
    );
  }

  void _onSearchMemes(SearchMemesEvent event, Emitter<MemeState> emit) {
    final currentState = state;
    if (currentState is MemeLoaded) {
      final filteredMemes = event.query.isEmpty ? currentState.memes : currentState.memes.where((meme) => meme.name.toLowerCase().contains(event.query.toLowerCase())).toList();

      emit(currentState.copyWith(
        filteredMemes: filteredMemes,
        searchQuery: event.query,
      ));
    }
  }

  Future<void> _onToggleOfflineMode(ToggleOfflineModeEvent event, Emitter<MemeState> emit) async {
    final result = await toggleOfflineModeUseCase(event.isOffline);

    result.fold(
      (failure) => emit(MemeError(failure.message)),
      (isOffline) {
        final currentState = state;

        if (currentState is MemeLoaded) {
          emit(currentState.copyWith(isOfflineMode: isOffline));
        }
      },
    );
  }
}

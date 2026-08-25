import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/delete_account.dart';
import '../../../domain/usecases/delete_avatar.dart';
import '../../../domain/usecases/export_profile_data.dart';
import '../../../domain/usecases/get_profile.dart';
import '../../../domain/usecases/update_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;
  final DeleteAvatar? deleteAvatar;
  final DeleteAccount? deleteAccount;
  final ExportProfileData? exportProfileData;

  ProfileBloc({
    required this.getProfile,
    required this.updateProfile,
    this.deleteAvatar,
    this.deleteAccount,
    this.exportProfileData,
  }) : super(ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
    on<ProfileUpdated>(_onProfileUpdated);
    on<ProfileAvatarDeleted>(_onProfileAvatarDeleted);
    on<ProfileAccountDeleted>(_onProfileAccountDeleted);
    on<ProfileDataExportRequested>(_onProfileDataExportRequested);
  }

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final profile = await getProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onProfileUpdated(
    ProfileUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final updatedProfile = await updateProfile(
        event.name,
        gender: event.gender,
        dateOfBirth: event.dateOfBirth,
      );
      emit(ProfileLoaded(updatedProfile));
    } catch (e) {
      emit(ProfileFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onProfileAvatarDeleted(
    ProfileAvatarDeleted event,
    Emitter<ProfileState> emit,
  ) async {
    if (deleteAvatar == null) return;
    emit(ProfileLoading());

    try {
      final updatedProfile = await deleteAvatar!();
      emit(ProfileLoaded(updatedProfile));
    } catch (e) {
      emit(ProfileFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onProfileAccountDeleted(
    ProfileAccountDeleted event,
    Emitter<ProfileState> emit,
  ) async {
    if (deleteAccount == null) return;
    emit(ProfileLoading());

    try {
      await deleteAccount!();
      emit(ProfileAccountDeletedSuccess());
    } catch (e) {
      emit(ProfileFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onProfileDataExportRequested(
    ProfileDataExportRequested event,
    Emitter<ProfileState> emit,
  ) async {
    if (exportProfileData == null) return;
    emit(ProfileLoading());

    try {
      final result = await exportProfileData!();
      final url = (result['download_url'] ?? '') as String;
      final expires = (result['expires_in_minutes'] as num?)?.toInt() ?? 30;
      emit(ProfileDataExportSuccess(downloadUrl: url, expiresInMinutes: expires));
    } catch (e) {
      emit(ProfileFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}

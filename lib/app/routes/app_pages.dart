import 'package:get/get.dart';
import 'package:unsikuy_app/app/modules/profile/views/connected_view.dart';

import '../modules/chat_room/bindings/chat_room_binding.dart';
import '../modules/chat_room/views/chat_room_view.dart';
import '../modules/chats/bindings/chats_binding.dart';
import '../modules/chats/views/chats_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/edit_profile/views/update_bio.dart';
import '../modules/edit_profile/views/update_profile.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/people/bindings/people_binding.dart';
import '../modules/people/views/people_view.dart';
import '../modules/post/bindings/post_binding.dart';
import '../modules/post/views/post_comment.dart';
import '../modules/post/views/post_view.dart';
import '../modules/post_detail/bindings/post_detail_binding.dart';
import '../modules/post_detail/views/post_detail_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/upload/bindings/upload_binding.dart';
import '../modules/upload/views/upload_view.dart';
import '../utils/widgets/loading_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.LOADER,
      page: () => const LoadingView(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.POST,
      page: () => const PostView(),
      binding: PostBinding(),
    ),
    GetPage(
      name: _Paths.CHATS,
      page: () => const ChatsView(),
      binding: ChatsBinding(),
    ),
    GetPage(
      name: _Paths.UPLOAD,
      page: () => const UploadView(),
      binding: UploadBinding(),
    ),
    GetPage(
      name: _Paths.PEOPLE,
      page: () => const PeopleView(),
      binding: PeopleBinding(),
    ),
    GetPage(
      name: _Paths.COMMENT,
      page: () => const PostComment(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.update_profile,
      page: () => const UpdateProfile(),
    ),
    GetPage(
      name: _Paths.update_bio,
      page: () => const UpdateBio(),
    ),
    GetPage(
      name: _Paths.CHAT_ROOM,
      page: () => const ChatRoomView(),
      binding: ChatRoomBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.POST_DETAIL,
      page: () => const PostDetailView(),
      binding: PostDetailBinding(),
    ),
    GetPage(
      name: _Paths.CONNECTED_VIEW,
      page: () => const ConnectedView(),
    ),
  ];
}

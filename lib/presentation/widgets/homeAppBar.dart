import 'package:bloc_chat/business_logic/cubits/auth/auth_cubit.dart';
import 'package:bloc_chat/business_logic/cubits/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  const HomeAppBar({
    Key? key,
    required this.backgroundColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: Icon(
        Icons.menu_rounded,
        color: Colors.white,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Chats'),
          SizedBox(width: 5),
          Padding(
            padding: const EdgeInsets.all(1.0),
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {
              print('sign-out');
              BlocProvider.of<AuthCubit>(context).signOut(context);
            },
            icon: Icon(Icons.logout)),
        SizedBox(width: 5),
        IconButton(
            onPressed: () {
              print('change color');
              BlocProvider.of<ThemeCubit>(context).changeTheme();
            },
            icon: Icon(Icons.palette)),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

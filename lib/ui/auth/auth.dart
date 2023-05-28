import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewelry_e_commerce/data/repoditory/auth_repository.dart';
import 'package:jewelry_e_commerce/ui/auth/bloc/auth_bloc.dart';
import 'package:jewelry_e_commerce/util/theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController usernameController =
      TextEditingController(text: "test@gmail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "123456");
  final TextEditingController passwordControllerRepeat =
      TextEditingController(text: "123456");

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    const onBackground = Colors.white;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
          data: themeData.copyWith(
              snackBarTheme: SnackBarThemeData(
                  contentTextStyle: themeData.textTheme.bodySmall!
                      .copyWith(color: onBackground),
                  backgroundColor: LightThemeColors.secoundryColor),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                      minimumSize:
                          MaterialStateProperty.all(const Size.fromHeight(56)),
                      foregroundColor: MaterialStateProperty.all(
                          LightThemeColors.backgroundColor),
                      backgroundColor: MaterialStateProperty.all(
                          LightThemeColors.theritaryTextColor))),
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: themeData.textTheme.bodySmall!
                    .copyWith(color: onBackground),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: onBackground),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: onBackground),
                ),
              )),
          child: Scaffold(
            backgroundColor: themeData.colorScheme.primary,
            body: BlocProvider<AuthBloc>(
              create: (context) {
                final authBloc = AuthBloc(
                  authRepository: authRepository,
                );
                authBloc.stream.forEach((state) {
                  if (state is AuthSuccess) {
                    Navigator.of(context).pop();
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.error)));
                  }
                });
                authBloc.add(AuthStarted());
                return authBloc;
              },
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24, left: 24),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (previous, current) {
                        return current is AuthError ||
                            current is AuthInitial ||
                            current is AuthLoading;
                      },
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/icon_transparent.png',
                              width: 100,
                            ),
                            Text(
                              state.isLoginMode ? 'خوش آمدید' : 'فرم ثبت نام',
                              style: themeData.textTheme.headlineMedium!
                                  .copyWith(color: onBackground),
                            ),
                            Text(
                              state.isLoginMode
                                  ? 'لطفا وارد حساب کاربری خود شوید'
                                  : 'ایمیل و رمز عبور خود را تعیین نمایید',
                              style: themeData.textTheme.headlineMedium!
                                  .copyWith(color: onBackground),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            TextField(
                              controller: usernameController,
                              keyboardType: TextInputType.emailAddress,
                              style: themeData.textTheme.bodySmall!
                                  .copyWith(color: onBackground),
                              cursorColor: onBackground,
                              decoration: const InputDecoration(
                                label: Text('آدرس ایمیل'),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            _PasswordTextField(
                              onBackground: onBackground,
                              controller: passwordController,
                              title: 'رمز عبور',
                            ),
                            SizedBox(
                              height: state.isLoginMode ? 0 : 16,
                            ),
                            state.isLoginMode
                                ? Container()
                                : _PasswordTextField(
                                    onBackground: onBackground,
                                    controller: passwordControllerRepeat,
                                    title: 'تکرار رمز عبور',
                                  ),
                            const SizedBox(
                              height: 24,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (state.isLoginMode) {
                                  BlocProvider.of<AuthBloc>(context).add(
                                      AuthButtonIsClicked(
                                          username: usernameController.text,
                                          password: passwordController.text));
                                } else {
                                  if (passwordEqualityChecker(
                                      passwordControllerRepeat.text,
                                      passwordController.text,
                                      context)) {
                                    BlocProvider.of<AuthBloc>(context).add(
                                        AuthButtonIsClicked(
                                            username: usernameController.text,
                                            password: passwordController.text));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'رمز عبور یکسان نمی باشد')));
                                  }
                                }
                              },
                              child: state is AuthLoading
                                  ? CupertinoActivityIndicator(
                                      color: themeData.colorScheme.onSecondary,
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          CupertinoIcons.lock_open,
                                          size: 22,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(state.isLoginMode
                                            ? 'ورود'
                                            : 'ثبت نام'),
                                      ],
                                    ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            state.isLoginMode
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return Container();
                                          //ForgotPassword();
                                        },
                                      ));
                                    },
                                    child: Text(
                                      'رمز عبور خود را فراموش کرده اید؟',
                                      style: themeData.textTheme.bodyMedium!
                                          .copyWith(
                                              color: LightThemeColors
                                                  .theritaryTextColor),
                                    ),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.isLoginMode
                                      ? 'حساب کاربری ندارید؟'
                                      : 'حساب کاربری دارید؟',
                                  style: themeData.textTheme.bodyMedium!
                                      .copyWith(color: onBackground),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<AuthBloc>(context)
                                        .add(AuthModeChangeIsClicked());
                                  },
                                  child: Text(
                                    state.isLoginMode ? 'ثبت نام' : 'ورود',
                                    style: themeData.textTheme.bodyMedium!
                                        .copyWith(
                                            color: LightThemeColors
                                                .theritaryTextColor),
                                  ),
                                )
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

bool passwordEqualityChecker(
    String password, String passwordConfirm, BuildContext context) {
  if (password != passwordConfirm) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('رمز عبور یکسان نمی باشد')));
    return false;
  } else {
    return true;
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    required this.onBackground,
    required this.controller,
    required this.title,
  });

  final Color onBackground;
  final TextEditingController controller;
  final String title;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obsecureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      style: TextStyle(color: widget.onBackground),
      cursorColor: widget.onBackground,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obsecureText,
      decoration: InputDecoration(
          label: Text(widget.title),
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obsecureText = !obsecureText;
                });
              },
              icon: Icon(
                obsecureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: widget.onBackground.withOpacity(0.6),
              ))),
    );
  }
}

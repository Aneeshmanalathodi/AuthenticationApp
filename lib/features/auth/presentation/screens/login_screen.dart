import 'package:authenticationapp/core/constants/app_colors.dart';
import 'package:authenticationapp/core/utils/helpers.dart';
import 'package:authenticationapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:authenticationapp/features/home/presentation/screens/home_screen.dart'
    show HomeScreen;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        },
        error: (error, _) {
          Helpers.showSnackBar(context, error.toString(), isError: true);
        },
      );
    });

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.08),

            /// 🔹 Title
            Text(
              "Enter Your\nMobile Number",
              style: TextStyle(
                fontSize: width * 0.08,
                fontWeight: FontWeight.w600,
                height: 1.3,
                color: Colors.white,
              ),
            ),

            SizedBox(height: height * 0.02),

            Text(
              "Lorem ipsum dolor sit amet consectetur. Porta at id hac vitae.",
              style: TextStyle(
                color: Colors.white54,
                fontSize: width * 0.035,
                height: 1.6,
              ),
            ),

            SizedBox(height: height * 0.05),

            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.018,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text("+91"),
                      Icon(Icons.keyboard_arrow_down, size: width * 0.04),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: "Enter Mobile Number",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            Center(
              child: GestureDetector(
                onTap: authState.isLoading
                    ? null
                    : () {
                        ref
                            .read(authProvider.notifier)
                            .login(phoneController.text.trim());
                      },
                child: Container(
                  width: width * 0.5,
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: authState.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.red,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Continue",
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: height * 0.045,
                              height: height * 0.045,
                              decoration: const BoxDecoration(
                                color: AppColors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            SizedBox(height: height * 0.05),
          ],
        ),
      ),
    );
  }
}

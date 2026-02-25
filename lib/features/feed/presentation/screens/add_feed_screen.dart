import 'dart:io';
import 'package:authenticationapp/core/constants/app_colors.dart';
import 'package:authenticationapp/features/feed/presentation/providers/upload_feed_provider.dart';
import 'package:authenticationapp/features/feed/presentation/providers/my_feed_provider.dart';
import 'package:authenticationapp/features/feed/presentation/screens/my_feed_screen.dart';
import 'package:authenticationapp/features/home/presentation/widgets/category_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddFeedScreen extends ConsumerStatefulWidget {
  const AddFeedScreen({super.key});

  @override
  ConsumerState<AddFeedScreen> createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends ConsumerState<AddFeedScreen> {
  File? selectedVideo;
  File? selectedImage;

  final TextEditingController descController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  bool isUploading = false;
  List<int> selectedCategories = [];

  final List<Map<String, dynamic>> categories = const [
    {"id": 1, "name": "Physics"},
    {"id": 2, "name": "Artificial Intelligence"},
    {"id": 3, "name": "Mathematics"},
    {"id": 4, "name": "Chemistry"},
    {"id": 5, "name": "Micro Biology"},
    {"id": 6, "name": "Lorem ipsum dolor sit gre"},
  ];

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }

  Future<void> pickVideo() async {
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        selectedVideo = File(video.path);
      });
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> uploadFeed() async {
    if (isUploading) return;

    if (selectedVideo == null || selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select video & image")),
      );
      return;
    }

    if (selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one category")),
      );
      return;
    }

    setState(() => isUploading = true);

    try {
      await ref.read(
        uploadFeedProvider({
          "video": selectedVideo!,
          "image": selectedImage!,
          "desc": descController.text,
          "category": selectedCategories,
        }).future,
      );

      if (!mounted) return;

      ref.read(uploadProgressProvider.notifier).state = 0;

      ref.invalidate(myFeedProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Feed added successfully"),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 400));

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MyFeedScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload Failed"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(uploadProgressProvider);
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Add Feeds",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppColors.red, width: .8),
                ),
              ),
              onPressed: isUploading ? null : uploadFeed,
              child: isUploading
                  ? const SizedBox(
                      height: 14,
                      width: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red,
                      ),
                    )
                  : const Text(
                      "Share Post",
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: 16),
        children: [
          GestureDetector(
            onTap: pickVideo,
            child: _uploadBox(
              selectedVideo == null
                  ? "Select a video from Gallery"
                  : "Video Selected",
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: pickImage,
            child: _uploadBox(
              selectedImage == null ? "Add a Thumbnail" : "Thumbnail Selected",
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Add Description",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: descController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "Write description...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Categories This Project",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              Text(
                "View All",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (progress > 0 && progress < 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: LinearProgressIndicator(value: progress),
            ),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              final isSelected = selectedCategories.contains(cat["id"]);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedCategories.remove(cat["id"]);
                    } else {
                      selectedCategories.add(cat["id"]);
                    }
                  });
                },
                child: CategoryChip(cat["name"], isSelected),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _uploadBox(String text) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.upload_file_outlined,
                  color: Colors.white70,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                text,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

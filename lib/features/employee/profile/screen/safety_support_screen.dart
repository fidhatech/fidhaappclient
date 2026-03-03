import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/employee/profile/screen/widgets/profile_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SafetySupportScreen extends StatelessWidget {
  const SafetySupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Safety & Support",
            style: TextStyle(color: Colors.white, fontSize: 26),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Info card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColor.textFieldBorder.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.primary.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColor.highlightColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "We're here to help",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Report any issues or reach out to our support team.",
                            style: TextStyle(
                              color: AppColor.secondaryText,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "How can we help you?",
                style: TextStyle(
                  color: AppColor.secondaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              ProfileOptionTile(
                icon: Icons.flag_outlined,
                title: "Report Abuse",
                onTap: () => _showReportAbuseBottomSheet(context),
              ),
              const Divider(color: Colors.white12, height: 1),
              ProfileOptionTile(
                icon: Icons.headset_mic_outlined,
                title: "Contact Support",
                onTap: () => _launchSupportEmail(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportAbuseBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ReportAbuseBottomSheet(),
    );
  }

  Future<void> _launchSupportEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'fidhaapphelp@gmail.com',
      queryParameters: {'subject': 'Support Request - Fidha App'},
    );

    if (!await launchUrl(emailUri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open email app'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}

class _ReportAbuseBottomSheet extends StatefulWidget {
  const _ReportAbuseBottomSheet();

  @override
  State<_ReportAbuseBottomSheet> createState() =>
      _ReportAbuseBottomSheetState();
}

class _ReportAbuseBottomSheetState extends State<_ReportAbuseBottomSheet> {
  final TextEditingController _issueController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _issueController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A0029),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.primaryPink.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.flag_outlined,
                  color: AppColor.primaryPink,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Report Abuse",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Tell us what happened",
                    style: TextStyle(
                      color: AppColor.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Text field
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColor.textFieldBorder),
            ),
            child: TextField(
              controller: _issueController,
              focusNode: _focusNode,
              maxLines: 5,
              minLines: 5,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: const InputDecoration(
                hintText: "Describe the issue...",
                hintStyle: TextStyle(color: AppColor.secondaryText),
                contentPadding: EdgeInsets.all(16),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting
                  ? null
                  : () async {
                      setState(() => _isSubmitting = true);
                      // Mock API call — 2 second delay
                      await Future.delayed(const Duration(seconds: 2));
                      if (!mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Report submitted. Thank you!'),
                          backgroundColor: Color(0xFF30C267),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryButton,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Submit Report",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

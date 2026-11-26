import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/avatar_image.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final List<String> _hours = ['10.00 AM', '11.00 AM', '12.00 PM', '01.00 PM'];
  final List<String> _dates = ['Sun 4', 'Mon 5', 'Tue 6', 'Wed 7'];

  int _selectedHour = 1;
  int _selectedDate = 0;

  static const String _details =
      'Worem ipsum dolor sit amet, consectetur adipiscing elit. Nunc '
      'vulputate libero et velit interdum, ac aliquet odio mattis. Class '
      'aptent taciti sociosqu ad litora torquent per conubia nostra, per '
      'inceptos himenaeos. Curabitur tempus urna at turpis condimentum '
      'lobortis. Ut commodo efficitur neque. Ut diam quam, semper iaculis '
      'condimentum ac, vestibulum eu nisl.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildDoctorInfo(),
                  ),
                  const SizedBox(height: 34),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Details', style: _sectionStyle),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _details,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildSectionHeader('Working Hours'),
                  const SizedBox(height: 16),
                  _buildChips(
                    items: _hours,
                    selected: _selectedHour,
                    onTap: (i) => setState(() => _selectedHour = i),
                  ),
                  const SizedBox(height: 26),
                  _buildSectionHeader('Date'),
                  const SizedBox(height: 16),
                  _buildChips(
                    items: _dates,
                    selected: _selectedDate,
                    onTap: (i) => setState(() => _selectedDate = i),
                  ),
                ],
              ),
            ),
            _buildBookButton(),
          ],
        ),
      ),
    );
  }

  static const TextStyle _sectionStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 22),
              color: AppColors.textDark,
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          const Text(
            'Appointment',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  // Poza doctorului, nume, specialitate, butoane de contact si pret
  Widget _buildDoctorInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AvatarImage(
          url: 'https://randomuser.me/api/portraits/men/86.jpg',
          width: 118,
          height: 118,
          radius: 8,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: SizedBox(
            height: 118,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Dr.Upul',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    _contactButton(Icons.chat_bubble_outline),
                    const SizedBox(width: 10),
                    _contactButton(Icons.call_outlined),
                    const SizedBox(width: 10),
                    _contactButton(Icons.videocam_outlined),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Denteeth',
                  style: TextStyle(fontSize: 14, color: AppColors.accent),
                ),
                const Spacer(),
                const Row(
                  children: [
                    Text(
                      'Payment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '\$120.00',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _contactButton(IconData icon) {
    return Container(
      width: 26,
      height: 26,
      decoration: const BoxDecoration(
        color: AppColors.iconBg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 14, color: AppColors.textDark),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(title, style: _sectionStyle),
          const Spacer(),
          const Text(
            'See All',
            style: TextStyle(fontSize: 14, color: AppColors.textDark),
          ),
        ],
      ),
    );
  }

  // Lista orizontala selectabile (ore / zile)
  Widget _buildChips({
    required List<String> items,
    required int selected,
    required ValueChanged<int> onTap,
  }) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final isSelected = i == selected;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Container(
              width: 116,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryDark : AppColors.chip,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                items[i],
                style: TextStyle(
                  fontSize: 17,
                  color: isSelected ? Colors.white : AppColors.textDark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: () {},
          child: const Text(
            'Book an Appointment',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

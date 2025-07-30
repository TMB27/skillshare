import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/skills_provider.dart';
import '../widgets/skill_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SkillsProvider>().loadSkills();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final skillsProvider = context.watch<SkillsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SkillShare'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.push('/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              context.push('/notifications');
            },
          ),
        ],
      ),
      body: skillsProvider.isLoading && skillsProvider.skills.isEmpty
          ? const LoadingIndicator()
          : skillsProvider.errorMessage != null
              ? ErrorMessage(message: skillsProvider.errorMessage!)
              : RefreshIndicator(
                  onRefresh: () => skillsProvider.loadSkills(refresh: true),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome Message
                          Text(
                            'Hello, ${authProvider.currentUser?.firstName ?? 'Guest'}!',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'What would you like to learn or teach today?',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 24),

                          // Featured Skills Section
                          Text(
                            'Featured Skills',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          skillsProvider.featuredSkills.isEmpty
                              ? const Center(
                                  child: Text('No featured skills available.'),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.75,
                                  ),
                                  itemCount: skillsProvider.featuredSkills.length,
                                  itemBuilder: (context, index) {
                                    final skill = skillsProvider.featuredSkills[index];
                                    return SkillCard(skill: skill);
                                  },
                                ),
                          const SizedBox(height: 24),

                          // Browse All Skills Button
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                context.push('/browse');
                              },
                              child: const Text('Browse All Skills'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/skill/add');
        },
        label: const Text('Add Skill'),
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.primaryTeal,
      ),
    );
  }
}


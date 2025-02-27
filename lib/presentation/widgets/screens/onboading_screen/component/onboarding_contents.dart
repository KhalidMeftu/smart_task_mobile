class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Stay on Top of Your Tasks",
    image: "assets/images/onboarding_one.png",
    desc: "Never miss a deadline again! Organize your tasks, set priorities, and track your progress—all in one place.",
  ),

  OnboardingContents(
    title: "Collaborate with Your Team",
    image: "assets/images/onboarding_two.png",
    desc: "Work smarter together! Assign tasks, share updates, and keep everyone in sync—no more messy email threads.",
  ),

  OnboardingContents(
    title: "Get Real-Time Updates",
    image: "assets/images/onboarding_three.png",
    desc: "Stay in the loop! Get instant notifications when tasks are completed, deadlines change, or your team needs your input.",
  ),
];

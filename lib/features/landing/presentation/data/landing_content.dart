/// Copy + structure for the marketing landing page.
/// Swap team names / bios here without touching layout code.
class LandingContent {
  static const brand = 'CrowdVise';
  static const tagline = 'RESEARCH PLATFORM';

  static const heroLead = 'Know what customers think,';
  static const heroEmphasis = 'before you ship.';
  static const heroSupport =
      'Synthetic panels that react, abandon, and convert like real humans, without the focus-group bill.';

  static const aboutEyebrow = 'THE PLATFORM';
  static const aboutTitle = 'Customer research that moves at product speed.';
  static const aboutBody =
      'CrowdVise assembles AI personas that behave like your real audience. Describe a product, run a journey, and get adoption scores, objections, and next moves in minutes.';

  static const metrics = [
    LandingMetric(value: 3, suffix: ' min', label: 'To first signal'),
    LandingMetric(value: 500, suffix: '+', label: 'Synthetic personas'),
    LandingMetric(value: 4, suffix: '', label: 'Journey stages scored'),
    LandingMetric(value: 0, suffix: '', label: 'Real customers required'),
  ];

  static const stages = [
    LandingStage(
      id: 'describe',
      label: 'Describe',
      title: 'Start with the product, not a survey.',
      body:
          'Paste a product description or pitch. Crowdvise maps the journey from discovery and trial through paywall and support, so a panel can walk through it.',
    ),
    LandingStage(
      id: 'assemble',
      label: 'Assemble',
      title: 'A panel that mirrors your market.',
      body:
          'Choose panel size and segment. We spin up synthetic customers with distinct motivations, budgets, and friction points.',
    ),
    LandingStage(
      id: 'simulate',
      label: 'Simulate',
      title: 'Watch them react in real time.',
      body:
          'Each persona moves through your journey. Some convert. Some bounce. Some argue. Every reaction is logged and scored.',
    ),
    LandingStage(
      id: 'decide',
      label: 'Decide',
      title: 'Ship with evidence, not hunches.',
      body:
          'Adoption score, top objections, and concrete fixes, so you know what to change before launch.',
    ),
  ];

  static const services = [
    LandingService(
      number: '01',
      eyebrow: 'PANELS',
      title: 'Synthetic customers that feel human.',
      body:
          'Diverse personas with jobs-to-be-done, price sensitivity, and real drop-off behavior, not chatbot yes-men.',
    ),
    LandingService(
      number: '02',
      eyebrow: 'JOURNEYS',
      title: 'Full-funnel simulation.',
      body:
          'From first impression to checkout. Stress-test onboarding, pricing, and messaging before a single dollar of ads.',
    ),
    LandingService(
      number: '03',
      eyebrow: 'INSIGHTS',
      title: 'Live reactions & objections.',
      body:
          'See what they loved, what confused them, and the exact friction that kills conversion, in plain language.',
    ),
    LandingService(
      number: '04',
      eyebrow: 'SCORE',
      title: 'Adoption readiness, scored.',
      body:
          'A clear readiness score plus prioritized recommendations so your team knows what to fix next.',
    ),
  ];

  static const faqs = [
    LandingFaq(
      question: 'What is CrowdVise?',
      answer:
          'CrowdVise is an AI research platform that builds synthetic customer panels to simulate how real people would react to your product, journey, or pitch, then surfaces adoption scores, objections, and recommendations.',
    ),
    LandingFaq(
      question: 'How is this different from a focus group?',
      answer:
          'Focus groups take weeks and thousands of dollars. Crowdvise runs in minutes, scales panel size on demand, and captures every reaction with full traceability, so you can iterate the same day.',
    ),
    LandingFaq(
      question: 'Are the personas just ChatGPT wrappers?',
      answer:
          'No. Personas are configured with segment traits, motivations, and constraints, then run through structured journeys with scoring, not open-ended chat. The goal is behavioral signal, not polite answers.',
    ),
    LandingFaq(
      question: 'Who is CrowdVise for?',
      answer:
          'Founders, PMs, and marketers validating ideas, pricing, onboarding, or messaging before launch, especially when a full research budget isn’t realistic yet.',
    ),
    LandingFaq(
      question: 'How do I get started?',
      answer:
          'Create an account, describe your product, pick a panel size, and run your first simulation. You’ll get reactions and an adoption score on the first run.',
    ),
  ];

  /// Ebuka's portrait is local (`assets/images/ebuka.jpeg`); the second
  /// member's photo and links are still placeholders.
  static const team = [
    LandingTeamMember(
      name: 'Ebuka Ihekwaba',
      role: 'Founder & Software Engineer',
      initials: 'EI',
      photoUrl: 'assets/images/ebuka.jpeg',
      github: 'https://github.com/quabiee07',
      portfolio: 'https://ebuka-ihekwaba.vercel.app/',
      x: 'https://x.com/quabiee',
      linkedin: 'https://www.linkedin.com/in/kingsley-ihekwaba-9365ab206/',
      email: 'mailto:kingsleyihekwaba208@gmail.com',
      bio:
          'Building Crowdvise so teams can stress-test products with synthetic customers before they ship.',
    ),
    LandingTeamMember(
      name: 'Olajumoke Taiwo',
      role: 'Co-founder & AI Backend Engineer',
      initials: 'OT',
      photoUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=900&q=80',
      github: 'https://github.com/olajumoketaiwo',
      portfolio: 'https://olajumoketaiwo.com',
      x: 'https://x.com/olajumoketaiwo',
      linkedin: 'https://www.linkedin.com/in/olajumoketaiwo',
      email: 'mailto:olajumoke@crowdvise.com',
      bio:
          'Partnering on product, research quality, and the experience that makes insights actually usable.',
    ),
  ];
}

class LandingMetric {
  const LandingMetric({
    required this.value,
    required this.suffix,
    required this.label,
  });

  final int value;
  final String suffix;
  final String label;
}

class LandingStage {
  const LandingStage({
    required this.id,
    required this.label,
    required this.title,
    required this.body,
  });

  final String id;
  final String label;
  final String title;
  final String body;
}

class LandingService {
  const LandingService({
    required this.number,
    required this.eyebrow,
    required this.title,
    required this.body,
  });

  final String number;
  final String eyebrow;
  final String title;
  final String body;
}

class LandingFaq {
  const LandingFaq({required this.question, required this.answer});

  final String question;
  final String answer;
}

class LandingTeamMember {
  const LandingTeamMember({
    required this.name,
    required this.role,
    required this.initials,
    required this.photoUrl,
    required this.github,
    required this.portfolio,
    required this.x,
    required this.linkedin,
    required this.email,
    required this.bio,
  });

  final String name;
  final String role;
  final String initials;
  final String photoUrl;
  final String github;
  final String portfolio;
  final String x;
  final String linkedin;
  final String email;
  final String bio;
}

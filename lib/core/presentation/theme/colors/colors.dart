import 'package:flutter/material.dart';

const electricOrange = Color(0xffFF5C00);
const electricBlue = Color(0xFF5B7FFF);
const vividGreen = Color(0xff00FF87);
const secondary = Color(0xff77A8F5);
const secondary20 = Color(0xffE4EEFD);
const white = Color(0xffFFFFFF);
const nearBlack = Color(0xff050508);
const surface = Color(0xff0C0C0F);
const surfaceElevated = Color(0xff131318);
const surfaceOverlay = Color(0xff1A1A22);

/// Landing / brand surfaces — cool paper, not warm cream.
const ink = Color(0xFF07080C);
const inkElevated = Color(0xFF101218);
const paper = Color(0xFFF2F4F7);
const paperDeep = Color(0xFFE6E9EF);
const signal = Color(0xFFFF5C00);
const signalSoft = Color(0xFFFF8A3D);
const slate = Color(0xFF1A1D26);
const slateMuted = Color(0xFF5C6370);

/// Workspace (dashboard) surfaces — flat, 1px hairlines, no glow.
const wsSidebar = Color(0xFF0A0B10);
const wsCanvas = Color(0xFF07080C);
const wsCard = Color(0xFF0F1117);
const wsCardHover = Color(0xFF141720);
const hairline = Color(0x14FFFFFF);
const hairlineStrong = Color(0x24FFFFFF);

// Glass morphism surfaces
const glassSurface = Color(0x14FFFFFF);
const glassBorder = Color(0x1AFFFFFF);
const glassBorderHover = Color(0x33FFFFFF);

// Text hierarchy
const textPrimary = Color(0xFFF4F4F5);
const textSecondary = Color(0xFFA1A1AA);
const textTertiary = Color(0xFF71717A);

const grey200 = Color(0xffE9EAEB);
const grey1111 = Color(0xff5E6572);
const grey300 = Color(0xFFA4A7AE);
const grey900 = Color(0xFF858EA0);

// Primary Brand Colors
const primaryColor = Color(0xFF7993F2);
const primaryLight = Color(0xFFCBDCFF);
const primaryDark = Color(0xFF5A6FD8);
const secondaryColor = Color(0xFF8B5CF6);

// Neutral Colors (from Figma)
const neutral5 = Color(0xFFF9FAFB);
const neutral50 = Color(0xFFF9FAFB); // Added neutral50
const neutral100 = Color(0xFFF3F4F6);
const neutral200 = Color(0xFFE5E7EB); // ✅ NEW
const neutral300 = Color(0xFFD1D5DB); // ✅ NEW
const neutral400 = Color(0xFF9CA3AF);
const neutral500 = Color(0xFF6B7280);
const neutral600 = Color(0xFF535862);
const neutral700 = Color(0xFF374151);
const neutral900 = Color(0xFF111827);

// Success Colors (for password strength)
const success50 = Color(0xFFECFDF5);
const success100 = Color(0xFFD1FAE5);
const success200 = Color(0xFFA7F3D0);
const success300 = Color(0xFF6EE7B7);
const success400 = Color(0xFF34D399);
const success500 = Color(0xFF10B981);
const success600 = Color(0xFF059669);
const success700 = Color(0xFF047857);
const success800 = Color(0xFF065F46);
const success900 = Color(0xFF064E3B);

// Warning Colors
const warning25 = Color(0xFFFFFCF5);
const warning50 = Color(0xFFFFFAEB);
const warning100 = Color(0xFFFEF0C7);
const warning300 = Color(0xFFFEC84B);
const warning400 = Color(0xFFF59E0B);
const warning500 = Color(0xFFF79009);
const warning700 = Color(0xFFB54708);

// Error Colors
const error50 = Color(0xFFFEF3F2);
const error100 = Color(0xFFFEE4E2);
const error400 = Color(0xFFF97066);
const error500 = Color(0xFFF04438);
const error600 = Color(0xFFD92D20);
const error700 = Color(0xFFB42318);

// Legacy colors (for backward compatibility)
const lightGray = neutral100;
const mediumGray = neutral400;
const darkGray = neutral700;
const darkColor = neutral900;
const bgColor = Colors.white;
const successColor = success400;

// Social sign-in colors
const Color google = Color(0xFFDB4437);
const Color facebook = Color(0xFF1877F2);

const mefaraiGradient = LinearGradient(
  stops: [0.05, 1.0],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [electricBlue, Color(0xffCBDCFF)],
);

/// Primary brand gradient — signal orange (no purple glow).
const aiGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [signal, signalSoft],
);

const aiGradientSubtle = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0x1AFF5C00),
    Color(0x14FF8A3D),
  ],
);

const heroGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [signal, Color(0xFFFFB347)],
);

/// Cool data accent for charts / insights (not CTA).
const insightGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF3D5AFE), Color(0xFF00B4D8)],
);

const greyGradient = LinearGradient(colors: [textTertiary, textTertiary]);
const neutralGradient = LinearGradient(colors: [neutral100, neutral100]);
const bottomNavGradient = LinearGradient(colors: [textTertiary, textTertiary]);

/// Semantic status colors
const statusReady = Color(0xFF10B981);
const statusWarning = Color(0xFFF59E0B);
const statusDanger = Color(0xFFEF4444);

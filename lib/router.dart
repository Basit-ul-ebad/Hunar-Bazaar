import 'package:go_router/go_router.dart';
import 'features/buyer/bazaar_home_screen.dart';
import 'features/buyer/live_listing_screen.dart';
import 'features/buyer/maker_storefront_screen.dart';
import 'features/buyer/product_screen.dart';
import 'features/gallery/gallery_screen.dart';
import 'features/listing/add_photos_screen.dart';
import 'features/listing/ai_writing_screen.dart';
import 'features/listing/fair_price_screen.dart';
import 'features/listing/listing_live_screen.dart';
import 'features/listing/preview_share_screen.dart';
import 'features/listing/review_listing_screen.dart';
import 'features/orders/orders_screen.dart';
import 'features/seller_onboarding/seller_dashboard_screen.dart';
import 'features/seller_onboarding/shop_setup_screen.dart';
import 'features/seller_onboarding/start_selling_screen.dart';

/// Routes follow the navigation map in DESIGN.md section 5.
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const BazaarHomeScreen()),
    GoRoute(
      path: '/listing/:id',
      builder: (context, state) =>
          LiveListingScreen(listingId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) =>
          ProductScreen(productId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/maker/:id',
      builder: (context, state) =>
          MakerStorefrontScreen(makerId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/sell',
      builder: (context, state) => const StartSellingScreen(),
    ),
    GoRoute(
      path: '/sell/setup',
      builder: (context, state) => const ShopSetupScreen(),
    ),
    GoRoute(
      path: '/seller',
      builder: (context, state) => const SellerDashboardScreen(),
    ),
    GoRoute(
      path: '/seller/orders',
      builder: (context, state) => const OrdersScreen(),
    ),
    GoRoute(
      path: '/seller/new/photos',
      builder: (context, state) => const AddPhotosScreen(),
    ),
    GoRoute(
      path: '/seller/new/ai',
      builder: (context, state) => const AiWritingScreen(),
    ),
    GoRoute(
      path: '/seller/new/details',
      builder: (context, state) => const ReviewListingScreen(),
    ),
    GoRoute(
      path: '/seller/new/price',
      builder: (context, state) => const FairPriceScreen(),
    ),
    GoRoute(
      path: '/seller/new/preview',
      builder: (context, state) => const PreviewShareScreen(),
    ),
    GoRoute(
      path: '/seller/new/done',
      builder: (context, state) => const ListingLiveScreen(),
    ),
    GoRoute(
      path: '/gallery',
      builder: (context, state) => const GalleryScreen(),
    ),
  ],
);
